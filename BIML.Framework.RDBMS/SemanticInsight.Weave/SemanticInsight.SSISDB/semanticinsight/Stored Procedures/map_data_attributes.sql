
CREATE procedure [semanticinsight].[map_data_attributes]
(
--declare
	@@root_component_application_name nvarchar(50),-- = 'Adventure Works BI',
	@@source_component_application_name nvarchar(50),-- = 'Adventure Works',
	@@destination_component_application_name nvarchar(50),-- = 'Adventure Works Stage',
	@@source_data_schema_name nvarchar(132),-- = '',
	@@destination_data_schema_name nvarchar(132),-- = '',
	@@source_data_object_name nvarchar(132),-- = '',
	@@destination_data_object_name nvarchar(132),-- = ''
	@@map_attributes_on_name bit = 1,
	@@return_id bit = 0
)
as
begin

	declare @data_object_mapping_id int;

	-- insert if they don't exist already
	insert into [semanticinsight].[data_object_mapping] (
		[source_system_component_id],
		[source_schema_id],
		[source_data_object_id],
		[destination_system_component_id],
		[destination_schema_id],
		[destination_data_object_id]
	)
	select
		src.system_component_id as [source_system_component_id]
		,src.data_schema_id as [source_schema_id]
		,src.data_object_id as [source_data_object_id]
		,dst.system_component_id as [destination_system_copmonent_id]
		,dst.data_schema_id as [destination_schema_id]
		,dst.data_object_id as [destination_data_object_id]

	from
	(
		select
			sc.system_component_id,
			ds.data_schema_id,
			do.data_object_id
		from [semanticinsight].system_component sc
		join [semanticinsight].system_component rsc on sc.root_system_component_id = rsc.system_component_id
		join [semanticinsight].data_schema ds on sc.system_component_id = ds.system_component_id
		join [semanticinsight].data_object do on do.data_schema_id = ds.data_schema_id
		where rsc.component_application_name = @@root_component_application_name
		and sc.component_application_name = @@source_component_application_name
		and ds.schema_name = @@source_data_schema_name
		and do.name = @@source_data_object_name
	) src
	cross join
	(
		select
			sc.system_component_id,
			ds.data_schema_id,
			do.data_object_id
		from [semanticinsight].system_component sc
		join [semanticinsight].system_component rsc on sc.root_system_component_id = rsc.system_component_id
		join [semanticinsight].data_schema ds on sc.system_component_id = ds.system_component_id
		join [semanticinsight].data_object do on do.data_schema_id = ds.data_schema_id
		where rsc.component_application_name = @@root_component_application_name
		and sc.component_application_name = @@destination_component_application_name
		and ds.schema_name = @@destination_data_schema_name
		and do.name = @@destination_data_object_name
	) dst
	where not exists (
		select 1
		from [semanticinsight].[data_object_mapping] dam
		where dam.destination_data_object_id = dst.data_object_id
			and dam.destination_schema_id = dst.data_schema_id
			and dam.destination_system_component_id = dst.system_component_id

			and dam.source_data_object_id = src.data_object_id
			and dam.source_schema_id = src.data_schema_id
			and dam.source_system_component_id = src.system_component_id
	)

	select @data_object_mapping_id = SCOPE_IDENTITY();

	if (@data_object_mapping_id is null)
	(
		select data_object_mapping_id
		from [semanticinsight].[data_object_mapping] dam
		join (
			select
				sc.system_component_id,
				ds.data_schema_id,
				do.data_object_id
			from [semanticinsight].system_component sc
			join [semanticinsight].system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join [semanticinsight].data_schema ds on sc.system_component_id = ds.system_component_id
			join [semanticinsight].data_object do on do.data_schema_id = ds.data_schema_id
			where rsc.component_application_name = @@root_component_application_name
			and sc.component_application_name = @@source_component_application_name
			and ds.schema_name = @@source_data_schema_name
			and do.name = @@source_data_object_name
		) src on    dam.source_data_object_id = src.data_object_id
				and dam.source_schema_id = src.data_schema_id
				and dam.source_system_component_id = src.system_component_id
		join
		(
			select
				sc.system_component_id,
				ds.data_schema_id,
				do.data_object_id
			from [semanticinsight].system_component sc
			join [semanticinsight].system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join [semanticinsight].data_schema ds on sc.system_component_id = ds.system_component_id
			join [semanticinsight].data_object do on do.data_schema_id = ds.data_schema_id
			where rsc.component_application_name = @@root_component_application_name
			and sc.component_application_name = @@destination_component_application_name
			and ds.schema_name = @@destination_data_schema_name
			and do.name = @@destination_data_object_name
		) dst on  dam.destination_data_object_id = dst.data_object_id
				and dam.destination_schema_id = dst.data_schema_id
				and dam.destination_system_component_id = dst.system_component_id
	)

	if (@@map_attributes_on_name = 1)
	begin
		insert into semanticinsight.data_attribute_mapping 
		(
			data_object_mapping_id, 
			source_data_attribute_id, 
			destination_data_attribute_id
		)
		select 
			@data_object_mapping_id,
			src.source_data_attribute_id,
			dst.destination_data_attribute_id
		from
		(
			select
				da.data_attribute_id	as source_data_attribute_id,
				da.name					as source_data_attribute_name
			from [semanticinsight].data_object_mapping	dam 
			join [semanticinsight].data_object			do	on do.data_object_id			= dam.source_data_object_id
			join [semanticinsight].data_attribute		da	on do.data_object_id			= da.data_object_id
			where dam.data_object_mapping_id = @data_object_mapping_id
		) src
		join
		(
			select
				da.data_attribute_id	as destination_data_attribute_id,
				da.name					as destination_data_attribute_name
			from [semanticinsight].data_object_mapping	dam 
			join [semanticinsight].data_object			do	on do.data_object_id			= dam.destination_data_object_id
			join [semanticinsight].data_attribute		da	on do.data_object_id			= da.data_object_id
			where dam.data_object_mapping_id = @data_object_mapping_id
		) dst on  src.source_data_attribute_name = dst.destination_data_attribute_name
	end

	if (@@return_id = 1)
	begin
		select @data_object_mapping_id as data_object_mapping_id
	end

end