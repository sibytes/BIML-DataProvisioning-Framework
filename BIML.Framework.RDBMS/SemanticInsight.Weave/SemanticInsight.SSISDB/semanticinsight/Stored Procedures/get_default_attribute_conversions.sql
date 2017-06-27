

CREATE procedure [semanticinsight].[get_default_attribute_conversions]
(
--declare
	@@root_component_application_name nvarchar(50) = 'Adventure Works BI',
	@@schema_name nvarchar(132) = 'Production',
	@@data_object_name nvarchar(132)= 'ProductDocument'
)
as
begin

	select
		da.name as data_attribute_name,
		replace(dt.sql_server_default_conversion, '<data_attribute_name>', '[' + da.name + ']') as data_attribute_conversion
	from [semanticinsight].system_component sc
	join [semanticinsight].system_component rsc on sc.root_system_component_id = rsc.system_component_id
	join [semanticinsight].data_schema ds on sc.system_component_id = ds.system_component_id
	join [semanticinsight].data_object do on do.data_schema_id = ds.data_schema_id
	join semanticinsight.data_attribute da on da.data_object_id = do.data_object_id
	join [semanticinsight].[data_type] dt on dt.data_type_id = da.data_type_id
	where ds.schema_name = @@schema_name
	and do.name = @@data_object_name
	and rsc.component_application_name = @@root_component_application_name
	and dt.sql_server_default_conversion is not null

end

--GO