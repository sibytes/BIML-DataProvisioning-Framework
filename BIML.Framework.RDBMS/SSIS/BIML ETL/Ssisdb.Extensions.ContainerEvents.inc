				<Event Name="OnPostExecute" EventType="OnPostExecute" ConstraintMode="Parallel" >

				  <Tasks>

					<Expression Name="Fire Event" Expression="@[SSISDB::fire_container_event] =  @[System::SourceName] ==  &quot;<#=containerName#>&quot;">
					</Expression>

					<ExecuteSQL Name="Record Stats" ConnectionName="SSISDB" ResultSet="None">

					  <DirectInput>
		  
EXEC [semanticinsight].[insert_process_data_object_stats] @@process_id = ?, @@data_object_mapping_id = ?, @@ssis_row_count = ?

					  </DirectInput>

					  <Parameters>
						<Parameter Name="@@process_id" DataType="Int32" VariableName="SSISDB.process_id"></Parameter>
						<Parameter Name="@@data_object_mapping_id" DataType="Int32" VariableName="SSISDB.data_object_mapping_id"></Parameter>
						<Parameter Name="@@ssis_row_count" DataType="Int32" VariableName="SSISDB.ssis_row_count"></Parameter>
					  </Parameters>

					  <PrecedenceConstraints>
						<Inputs>
						  <Input OutputPathName="Fire Event.Output" EvaluationOperation="ExpressionAndConstraint" EvaluationValue="Success" Expression="@[SSISDB::fire_container_event]"></Input>
						</Inputs>
					  </PrecedenceConstraints>

					</ExecuteSQL>

				  </Tasks>

				</Event>