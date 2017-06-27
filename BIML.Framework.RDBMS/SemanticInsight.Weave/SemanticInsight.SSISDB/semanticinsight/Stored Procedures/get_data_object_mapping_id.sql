




CREATE procedure [semanticinsight].[get_data_object_mapping_id]
(
	@@source_component_application_name nvarchar(50),
	@@source_data_schema_name nvarchar(132),
	@@source_data_object_name nvarchar(150),
	@@destination_component_application_name nvarchar(50),
	@@destination_data_schema_name nvarchar(132),
	@@destination_data_object_name nvarchar(150)
)
as
begin
	

	select dom.data_object_mapping_id
	from semanticinsight.data_object_mapping dom
	join semanticinsight.data_object sdo on dom.source_data_object_id = sdo.data_object_id and sdo.name = @@source_data_object_name
	join semanticinsight.data_schema sds on sdo.data_schema_id = sds.data_schema_id and sds.schema_name = @@source_data_schema_name
	join semanticinsight.system_component scs on scs.system_component_id = sds.system_component_id and scs.component_application_name = @@source_component_application_name

	join semanticinsight.data_object ddo on dom.destination_data_object_id = ddo.data_object_id and ddo.name = @@destination_data_object_name
	join semanticinsight.data_schema dds on ddo.data_schema_id = dds.data_schema_id and dds.schema_name = @@destination_data_schema_name
	join semanticinsight.system_component dcs on dcs.system_component_id = dds.system_component_id and dcs.component_application_name = @@destination_component_application_name

end