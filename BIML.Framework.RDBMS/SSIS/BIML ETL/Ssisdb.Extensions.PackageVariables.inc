<!-- 
  fire event is used to restrict the firing of package OnPreExecute event to the package executable only.
  Another way to control this is to set the internal Propagate variable to false on all the package child executables 
  however this is pretty hidden and default is true for all child executables, hence does bode well for a robust framework.
-->
<Variable Name="fire_event" Namespace="SSISDB" DataType="Boolean" >False</Variable>
<!--
  This is the process id of the calling package if there is one. This is so the calling hierarchy of executions can be recroded in the
  SSISDB extensions semanticinsight.process
-->
<Variable Name="parent_process_id" Namespace="SSISDB" DataType="Int64" EvaluateAsExpression="true">@[$Package::parent_process_id]</Variable>
<!--
  This is the process id of this package. It's retrieved and logged into the SSISDB extensions semanticinsight.process for the 
  following package events OnPreExecute, OnPostExecute and OnError
-->
<Variable Name="process_id" Namespace="SSISDB" DataType="Int64" EvaluateAsExpression="false">0</Variable>
<!--
  This is the object id that this package is loading. It's retrieved and logged into the SSISDB extensions semanticinsight.process for the 
  following package events OnPreExecute, OnPostExecute and OnError. It's also piped into the target object so that the target objects can be joined into the data lineage.
  
 <Variable Name="data_object_mapping_id" Namespace="SSISDB" DataType="Int64" EvaluateAsExpression="false">0</Variable>
-->

<!--
  Records the start date time of the package in SSISDB extensions. Rather than use getdate() the framework passes througuh the start_date
  to record into the SSISDB extensions semanticinsight.process to ensure it matches the actual start dates in SSISDB. Note that these start
  date and package end dates will be logged by SSISDB when deployed to the server. They are logged into semanticinsight.process at a package
  level for convenience and to collect the package level runtimes when executed in development which is useful.
 -->
 <Variable Name="start_date" Namespace="SSISDB" DataType="DateTime" EvaluateAsExpression="true">@[System::StartTime]</Variable>

 <!--
  Used to store any messages that need to be passed back to the SSISDB exntension semanticinsight.process logging when the package
  execution is finanlised on the OnPostExecute event handler. This is required because System::ErrorDescription is only 
 -->
 <Variable Name="message" Namespace="SSISDB" DataType="String"></Variable>


 <!--
  capture system variables that are useful as processing logging information logging
 -->
<Variable Name="user_name" Namespace="SSISDB" DataType="String" EvaluateAsExpression="true">@[System::UserName]</Variable>
<Variable Name="machine_name" Namespace="SSISDB" DataType="String" EvaluateAsExpression="true">@[System::MachineName]</Variable>
<Variable Name="package_id" Namespace="SSISDB" DataType="String" EvaluateAsExpression="true">@[System::PackageID]</Variable>
<Variable Name="execution_id" Namespace="SSISDB" DataType="String" EvaluateAsExpression="true">@[System::ServerExecutionID]</Variable>
<Variable Name="version_number" Namespace="SSISDB" DataType="String" EvaluateAsExpression="true">(DT_WSTR, 10)@[System::VersionMajor] + "." + (DT_WSTR, 10)@[System::VersionMinor] + "." + (DT_WSTR, 10)@[System::VersionBuild]</Variable>
<Variable Name="version_comments" Namespace="SSISDB" DataType="String" EvaluateAsExpression="true">@[System::VersionComments]</Variable>