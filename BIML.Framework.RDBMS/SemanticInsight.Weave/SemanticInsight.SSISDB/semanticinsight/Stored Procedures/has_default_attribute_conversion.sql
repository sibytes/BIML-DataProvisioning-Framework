
create procedure [semanticinsight].[has_default_attribute_conversion]
(
--declare
	@@root_component_application_name nvarchar(50),-- = 'Adventure Works BI',
	@@schema_name nvarchar(132), --= 'Production',
	@@data_object_name nvarchar(132) --= 'ProductDocument'
)
as
begin


	if exists (
		select 1
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
	)
	begin
		select cast(1 as bit) as [has_default_attribute_conversion]
	end
	else
	begin
		select cast(0 as bit) as [has_default_attribute_conversion]
	end

end