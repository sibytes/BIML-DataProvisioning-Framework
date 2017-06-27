<Variable Name="ssis_row_count" Namespace="SSISDB" DataType="Int64">0</Variable>
<Variable Name="fire_container_event" Namespace="SSISDB" DataType="Boolean">false</Variable>

<!--
  This is the object id that this package is loading. It's retrieved and logged into the SSISDB extensions semanticinsight.process for the 
  following package events OnPreExecute, OnPostExecute and OnError. It's also piped into the target object so that the target objects can be joined into the data lineage.
-->
<Variable Name="data_object_mapping_id" Namespace="SSISDB" DataType="Int64" EvaluateAsExpression="false">0</Variable>