<!-- 
  OnPreExecute - this event logs the start of the execution in the SSIDB extensions table semanticinsight.process.
  This table records the hierarchical execution of the packages for the ease of convenience for basic health check reporting.
  It also issues an id for data lineage recording in the warehouse tables. 
            
  OnPostExecute - this event logs the end of the package execution in the SSISDB extensions table semanticinsight.process.
  This table recrods the hierarchical execution of the packages for the of convenience for basic health check reporting.
  It also issues an id for data lineage recording in the warehouse tables. 
            
  OnError - This event picks up the error description from System.ErrorDescription to log into the package hierarchical execution log 
  semanticinsight.process. 
            
  Fire Event - Expression Task
  The fire_event expression task and variable ensure that OnPreExecute and OnPostExecute only actually execute for the package executable
  since the events handler will call from child executables where Propagate is set to True. Unfortunately True is the default and the setting
  is quite burried therefore it safer and more robust to handle this way.
 -->

<!-- Set up the events that log into our SSISDB extensions -->

<!--
  OnPreExecute :
    Initiliase the process in the semanticinsight.process. 
    Use parallel since we need to put an expression in the workflow 
-->
<Event Name="OnPreExecute" EventType="OnPreExecute" ConstraintMode="Parallel" >

  <Tasks>

    <!-- Ensure this event only fires the package executable event -->

    <Expression Name="Fire Event" Expression="@[SSISDB::fire_event] =  @[System::SourceName] ==  @[System::PackageName]"></Expression>

    <!--
      call the stored proc to initialise the process in semanticinsight.process in SSISDB
      It returns the process_id into the package so that
        a) It can be used to close the process on the package event OnPostExecute
        b) It can be logged into the data flow target tables to provide data lineage and linkage to processing audit and performance tables in SSISDB
        c) It can be passed to child packages into their parent_process_id for hierarchical logging of package execution in SSDB extentions semanticinsight.process
    -->

    <ExecuteSQL Name="Initialise Process" ConnectionName="SSISDB" ResultSet="SingleRow">
      <DirectInput>

EXEC [semanticinsight].[initialise_process] 
	@@parent_process_id = ?,
	@@component_application_name = ?,
	@@start_date = ?,

	@@user_name = ?,
	@@machine_name = ?,
	@@package_id = ?,
	@@execution_id = ?,
	@@version_number = ?,
	@@version_comments = ?


	</DirectInput>
      <Parameters>
        <Parameter Name="@@parent_process_id" DataType="Int64" VariableName="SSISDB.parent_process_id"></Parameter>
		<Parameter Name="@@component_application_name" DataType="AnsiString" VariableName="SSISDB.component_application_name"></Parameter>
        <Parameter Name="@@start_date" DataType="DateTime" VariableName="SSISDB.start_date"></Parameter>
		<Parameter Name="@@user_name" DataType="AnsiString" VariableName="SSISDB.user_name"></Parameter>
		<Parameter Name="@@machine_name" DataType="AnsiString" VariableName="SSISDB.machine_name"></Parameter>
	    <Parameter Name="@@package_id" DataType="Guid" VariableName="SSISDB.package_id"></Parameter>
		<Parameter Name="@@execution_id" DataType="Int64" VariableName="SSISDB.execution_id"></Parameter>
		<Parameter Name="@@version_number" DataType="AnsiString" VariableName="SSISDB.version_number"></Parameter>
		<Parameter Name="@@version_comments" DataType="AnsiString" VariableName="SSISDB.version_comments"></Parameter>
      </Parameters>
      <Results>
        <Result Name="process_id" VariableName="SSISDB.process_id"></Result>
      </Results>
      <!-- precedence constraint ensures that proc only fires on the package event hendler -->
      <PrecedenceConstraints>
        <Inputs>
          <Input OutputPathName="Fire Event.Output" EvaluationOperation="ExpressionAndConstraint" EvaluationValue="Success" Expression="@[SSISDB::fire_event]"></Input>
        </Inputs>
      </PrecedenceConstraints>
    </ExecuteSQL>

  </Tasks>
</Event>

<!-- 
  OnError :
    Retrieve the error message into a package scoped variable so that we can close off the package process exection in SSISDB extensions
    semanticinsight.process. Unfortunately ErrorDescription is scoped to the OnError event handler only. Whislt detailed logging is available
    in SSISDB native semanticinsight.process provides an intuitive quick and easy way to tie a the main process failure into the system health
    and warehouse data lineage. It's also available when executed in SSDT which is also very useful.
-->
<Event Name="OnError" EventType="OnError" ConstraintMode="Linear" >
  <Tasks>
    <Expression Name ="Retrieve Error Message" Expression ="@[SSISDB::message] = @[System::ErrorDescription]"></Expression>
  </Tasks>
</Event>

<!--
  OnPreExecute :
    Initiliase the process in the semanticinsight.process. 
    Use parallel since we need to put an expression in the workflow 
-->
<Event Name="OnPostExecute" EventType="OnPostExecute" ConstraintMode="Parallel" >

  <Tasks>

    <Expression Name="Fire Event" Expression="@[SSISDB::fire_event] =  @[System::SourceName] ==  @[System::PackageName]">
    </Expression>

    <ExecuteSQL Name="Finalise Process" ConnectionName="SSISDB" ResultSet="None">

      <DirectInput>
		  
EXEC [semanticinsight].[finalise_process] @@process_id = ?, @@error_message = ?

	  </DirectInput>

      <Parameters>
        <Parameter Name="@@process_id" DataType="Int32" VariableName="SSISDB.process_id"></Parameter>
        <Parameter Name="@@error_message" DataType="String" VariableName="SSISDB.message"></Parameter>
      </Parameters>

      <PrecedenceConstraints>
        <Inputs>
          <Input OutputPathName="Fire Event.Output" EvaluationOperation="ExpressionAndConstraint" EvaluationValue="Success" Expression="@[SSISDB::fire_event]"></Input>
        </Inputs>
      </PrecedenceConstraints>

    </ExecuteSQL>

  </Tasks>

</Event>