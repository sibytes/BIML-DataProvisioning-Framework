




---exec semanticinsight.[get_destination_table_definition_biml]

CREATE procedure [semanticinsight].[get_table_definition_biml] 
(
	@@root_component_application_name nvarchar(132),-- = 'Adventure Works BI',
	@@connection_name nvarchar(132) ,--= 'Stage',
	@@database_name nvarchar(132) ,--= 'Stage',
	@@schema_name nvarchar(132) = null,--= 'AdventureWorks',
	@@source_schema_name nvarchar(132) = null,
	@@source_database_name nvarchar(132) = null,
	@@as_varchar bit = 1,
	@@with_framework_attribute bit = 1,
	@@with_source_object bit = 0,
	@@with_source_attribute bit = 0
)
as
begin

	declare @source_schema_data table
	(
		source_schema_name nvarchar(132) not null,
		source_database_name nvarchar(132) not null,
		destination_schema_name nvarchar(132) not null,
		concatenate_source_schem_table_name bit not null
	);

	insert into @source_schema_data (source_schema_name, source_database_name, destination_schema_name, concatenate_source_schem_table_name)
	select
		sds.schema_name,
		sds.database_name,
		dds.schema_name as destination_schema_name,
		dds.concatenate_source_schem_table_name
	from semanticinsight.data_schema dds
	join semanticinsight.data_schema_mapping dsm on dds.data_schema_id = dsm.destination_data_schema_id
	join semanticinsight.data_schema sds on sds.data_schema_id = dsm.source_data_schema_id
	join semanticinsight.system_component sc on sds.system_component_id = sc.system_component_id
	join semanticinsight.system_component rsc on rsc.system_component_id = sc.root_system_component_id
	where rsc.component_application_name = @@root_component_application_name
	and dds.database_name = @@database_name
	and dds.schema_name = isnull(@@schema_name, dds.schema_name)
	and sds.schema_name = isnull(@@source_schema_name, sds.schema_name)
	and sds.database_name = isnull(@@source_database_name, sds.database_name)

	declare @databaseXml xml =
	(
		select
			Tag,
			Parent,
			[Databases!1!],
			[Database!2!Name],
			[Database!2!ConnectionName]
		from
		(
			select
				Tag = 1,
				Parent = null,
				[Databases!1!] = null,
				[Database!2!Name] = null,
				[Database!2!ConnectionName] = null
			union all
			select
				Tag = 2,
				Parent = 1,
				[Databases!1!] = null,
				[Database!2!Name] = @@database_name,
				[Database!2!ConnectionName] = @@connection_name
		) databasexml
		for xml explicit
	);

	declare @schemaXml xml =
	(
		select
			Tag,
			Parent,
			[Schemas!1!],
			[Schema!2!Name],
			[Schema!2!DatabaseName]
		from
		(
			select
				Tag = 1,
				Parent = null,
				[Schemas!1!] = null,
				[Schema!2!Name] = null,
				[Schema!2!DatabaseName] = null
			union all
			select distinct
				Tag = 2,
				Parent = 1,
				[Schemas!1!] = null,
				[Schema!2!Name] = destination_schema_name,
				[Schema!2!DatabaseName] = @@database_name
			from @source_schema_data
		) databasexml
		for xml explicit
	);

	declare @tablesXml xml =
	(
		select
			Tag,
			Parent,
			[Tables!1!],
			[Table!2!SchemaName],
			[Table!2!Name],
			[Columns!3!],
			[Column!4!Name],
			[Column!4!DataType],
			[Column!4!Length],
			[Column!4!Precision],
			[Column!4!Scale],
			[Column!4!IsNullable],
			[Column!4!IdentityIncrement],
			[Column!4!IdentitySeed],
			[Annotations!5!],
			[Annotation!6!AnnotationType],
			[Annotation!6!Tag],
			[Annotation!6!!Element]
		from
		(
			select 
				Tag = 1,
				Parent = null,
				data_object_id = null,
				data_attribute_id = -3,
				[system_framework_attribute_id] = -4,
				[load_pattern_attribute_id] = -4,
				[Tables!1!] = null,
				[Table!2!SchemaName] = null,
				[Table!2!Name] = null,
				[Columns!3!] = null,
				[Column!4!Name] = null,
				[Column!4!DataType] = null,
				[Column!4!Length] = null,
				[Column!4!Precision] = null,
				[Column!4!Scale] = null,
				[Column!4!IsNullable] = null,
				[Column!4!IdentityIncrement] = null,
				[Column!4!IdentitySeed] = null,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = null,
				[Annotation!6!Tag] = null,
				[Annotation!6!!Element] = null

			union all

			select distinct
				Tag = 2,
				Parent = 1,
				do.data_object_id,
				data_attribute_id = -3,
				[system_framework_attribute_id] = -3,
				[load_pattern_attribute_id] = -3,
				[Tables!1!] = null,
				[Table!2!SchemaName] = @@database_name + '.' + src.destination_schema_name,
				[Table!2!Name] = iif(src.concatenate_source_schem_table_name = 1, src.source_schema_name+do.name, do.name),
				[Columns!3!] = null,
				[Column!4!Name] = null,
				[Column!4!DataType] = null,
				[Column!4!Length] = null,
				[Column!4!Precision] = null,
				[Column!4!Scale] = null,
				[Column!4!IsNullable] = null,
				[Column!4!IdentityIncrement] = null,
				[Column!4!IdentitySeed] = null,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = null,
				[Annotation!6!Tag] = null,
				[Annotation!6!!Element] = null

			from semanticinsight.data_object do
			join semanticinsight.data_schema ds on do.data_schema_id = ds.data_schema_id
			join semanticinsight.system_component sc on ds.system_component_id = sc.system_component_id
			join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join semanticinsight.data_object_type dot on dot.data_object_type_id = do.data_object_type_id
			join @source_schema_data src on src.source_database_name = ds.database_name and src.source_schema_name = ds.schema_name
			and do.enabled = 1 and ds.enabled = 1 and sc.enabled = 1
			and rsc.component_application_name = @@root_component_application_name
			and dot.data_object_type in ('Table','View')

			union all

			select 
				Tag = 5,
				Parent = 2,
				do.data_object_id,
				data_attribute_id = -2,
				[system_framework_attribute_id] = -2,
				[load_pattern_attribute_id] = -2,
				[Tables!1!] = null,
				[Table!2!SchemaName] = null,
				[Table!2!Name] = null,
				[Columns!3!] = null,
				[Column!4!Name] = null,
				[Column!4!DataType] = null,
				[Column!4!Length] = null,
				[Column!4!Precision] = null,
				[Column!4!Scale] = null,
				[Column!4!IsNullable] = null,
				[Column!4!IdentityIncrement] = null,
				[Column!4!IdentitySeed] = null,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = null,
				[Annotation!6!Tag] = null,
				[Annotation!6!!Element] = null
			from semanticinsight.data_object do
			join semanticinsight.data_schema ds on do.data_schema_id = ds.data_schema_id
			join semanticinsight.system_component sc on ds.system_component_id = sc.system_component_id
			join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join semanticinsight.data_object_type dot on dot.data_object_type_id = do.data_object_type_id
			join @source_schema_data src on src.source_database_name = ds.database_name and src.source_schema_name = ds.schema_name
			and do.enabled = 1 and ds.enabled = 1 and sc.enabled = 1
			and rsc.component_application_name = @@root_component_application_name
			and dot.data_object_type in ('Table','View')
			and @@with_source_object = 1

			union all

			select 
				Tag = 6,
				Parent = 5,
				do.data_object_id,
				data_attribute_id = -2,
				[system_framework_attribute_id] = -2,
				[load_pattern_attribute_id] = -2,
				[Tables!1!] = null,
				[Table!2!SchemaName] = null,
				[Table!2!Name] = null,
				[Columns!3!] = null,
				[Column!4!Name] = null,
				[Column!4!DataType] = null,
				[Column!4!Length] = null,
				[Column!4!Precision] = null,
				[Column!4!Scale] = null,
				[Column!4!IsNullable] = null,
				[Column!4!IdentityIncrement] = null,
				[Column!4!IdentitySeed] = null,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = 'Tag',
				[Annotation!6!Tag] = 'SourceDataSchema',
				[Annotation!6!!Element] = src.source_schema_name
			from semanticinsight.data_object do
			join semanticinsight.data_schema ds on do.data_schema_id = ds.data_schema_id
			join semanticinsight.system_component sc on ds.system_component_id = sc.system_component_id
			join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join semanticinsight.data_object_type dot on dot.data_object_type_id = do.data_object_type_id
			join @source_schema_data src on src.source_database_name = ds.database_name and src.source_schema_name = ds.schema_name
			and do.enabled = 1 and ds.enabled = 1 and sc.enabled = 1
			and rsc.component_application_name = @@root_component_application_name
			and dot.data_object_type in ('Table','View')
			and @@with_source_object = 1

			union all

			select 
				Tag = 6,
				Parent = 5,
				do.data_object_id,
				data_attribute_id = -2,
				[system_framework_attribute_id] = -2,
				[load_pattern_attribute_id] = -2,
				[Tables!1!] = null,
				[Table!2!SchemaName] = null,
				[Table!2!Name] = null,
				[Columns!3!] = null,
				[Column!4!Name] = null,
				[Column!4!DataType] = null,
				[Column!4!Length] = null,
				[Column!4!Precision] = null,
				[Column!4!Scale] = null,
				[Column!4!IsNullable] = null,
				[Column!4!IdentityIncrement] = null,
				[Column!4!IdentitySeed] = null,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = 'Tag',
				[Annotation!6!Tag] = 'SourceDataObject',
				[Annotation!6!!Element] = do.name
			from semanticinsight.data_object do
			join semanticinsight.data_schema ds on do.data_schema_id = ds.data_schema_id
			join semanticinsight.system_component sc on ds.system_component_id = sc.system_component_id
			join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join semanticinsight.data_object_type dot on dot.data_object_type_id = do.data_object_type_id
			join @source_schema_data src on src.source_database_name = ds.database_name and src.source_schema_name = ds.schema_name
			and do.enabled = 1 and ds.enabled = 1 and sc.enabled = 1
			and rsc.component_application_name = @@root_component_application_name
			and dot.data_object_type in ('Table','View')
			and @@with_source_object = 1

			union all

			select distinct
				Tag = 3,
				Parent = 2,
				do.data_object_id,
				data_attribute_id = -1,
				[system_framework_attribute_id] = -1,
				[load_pattern_attribute_id] = -1,
				[Tables!1!] = null,
				[Table!2!SchemaName] = null,
				[Table!2!Name] = null,
				[Columns!3!] = null,
				[Column!4!Name] = null,
				[Column!4!DataType] = null,
				[Column!4!Length] = null,
				[Column!4!Precision] = null,
				[Column!4!Scale] = null,
				[Column!4!IsNullable] = null,
				[Column!4!IdentityIncrement] = null,
				[Column!4!IdentitySeed] = null,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = null,
				[Annotation!6!Tag] = null,
				[Annotation!6!!Element] = null

			from semanticinsight.data_object do
			join semanticinsight.data_schema ds on ds.data_schema_id = do.data_schema_id
			join semanticinsight.system_component sc on ds.system_component_id = sc.system_component_id
			join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join semanticinsight.data_object_type dot on dot.data_object_type_id = do.data_object_type_id
			join @source_schema_data src on src.source_database_name = ds.database_name and src.source_schema_name = ds.schema_name
			and do.enabled = 1 and ds.enabled = 1 and sc.enabled = 1
			and rsc.component_application_name = @@root_component_application_name
			and dot.data_object_type in ('Table','View')

			union all

			select 
				Tag = 4,
				Parent = 3,
				do.data_object_id,
				data_attribute_id = 0,
				[system_framework_attribute_id] = 0,
				[lpa].[load_pattern_attribute_id],
				[Tables!1!] = null,
				[Table!2!SchemaName] = null,
				[Table!2!Name] = null,
				[Columns!3!] = null,
				[Column!4!Name] = replace(lpa.name,'<surrogate_key>',do.name),
				[Column!4!DataType] = dt.biml,
				[Column!4!Length] = null,
				[Column!4!Precision] = null,
				[Column!4!Scale] = null,
				[Column!4!IsNullable] = 'false',
				[Column!4!IdentityIncrement] = lpa.identity_increment,
				[Column!4!IdentitySeed] = lpa.identity_seed,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = null,
				[Annotation!6!Tag] = null,
				[Annotation!6!!Element] = null
			from semanticinsight.data_object do
			join semanticinsight.data_schema ds on do.data_schema_id = ds.data_schema_id
			join semanticinsight.system_component sc on ds.system_component_id = sc.system_component_id
			join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join semanticinsight.data_object_type dot on dot.data_object_type_id = do.data_object_type_id
			join semanticinsight.load_pattern lp on do.load_pattern_id = lp.load_pattern_id
			join semanticinsight.load_pattern_attribute lpa on lpa.load_pattern_id = lp.load_pattern_id
			join semanticinsight.data_type dt on lpa.data_type_id = dt.data_type_id
			join @source_schema_data src on src.source_database_name = ds.database_name and src.source_schema_name = ds.schema_name
			and do.enabled = 1 and ds.enabled = 1 and sc.enabled = 1 and lpa.enabled = 1
			and rsc.component_application_name = @@root_component_application_name
			and dot.data_object_type in ('Table','View')
			and @@with_framework_attribute = 1

			union all

			select distinct
				Tag = 4,
				Parent = 3,
				do.data_object_id,
				data_attribute_id = 0,
				[system_framework_attribute_id] = sfa.system_framework_attribute_id,
				[load_pattern_attribute_id] = null,
				[Tables!1!] = null,
				[Table!2!SchemaName] = null,
				[Table!2!Name] = null,
				[Columns!3!] = null,
				[Column!4!Name] = sfa.name,
				[Column!4!DataType] = dt.biml,
				[Column!4!Length] = null,
				[Column!4!Precision] = null,
				[Column!4!Scale] = null,
				[Column!4!IsNullable] = iif(sfa.is_nullable=1,'true','false'),
				[Column!4!IdentityIncrement] = sfa.identity_increment,
				[Column!4!IdentitySeed] = sfa.identity_seed,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = null,
				[Annotation!6!Tag] = null,
				[Annotation!6!!Element] = null
			from semanticinsight.data_object do
			join semanticinsight.data_schema ds on do.data_schema_id = ds.data_schema_id
			join semanticinsight.system_component sc on ds.system_component_id = sc.system_component_id
			join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join semanticinsight.data_object_type dot on dot.data_object_type_id = do.data_object_type_id
			join semanticinsight.system_framework sf on sc.system_framework_id = sf.system_framework_id
			join semanticinsight.system_framework_attribute sfa on sfa.system_framework_id = sf.system_framework_id
			join semanticinsight.data_type dt on sfa.data_type_id = dt.data_type_id
			join @source_schema_data src on src.source_database_name = ds.database_name and src.source_schema_name = ds.schema_name
			and do.enabled = 1 and ds.enabled = 1 and sc.enabled = 1 and sfa.enabled = 1
			and rsc.component_application_name = @@root_component_application_name
			and dot.data_object_type in ('Table','View')
			and @@with_framework_attribute = 1

			union all

			select 
				Tag = 4,
				Parent = 3,
				da.[data_object_id],
				da.[data_attribute_id],
				[system_framework_attribute_id] = null,
				[load_pattern_attribute_id] = null,
				[Tables!1!] = null,
				[Table!2!SchemaName] = null,
				[Table!2!Name] = null,
				[Columns!3!] = null,
				[Column!4!Name] = da.name,
				[Column!4!DataType] = dt.biml,
				[Column!4!Length] = da.max_length, --iif(dt.biml in ('String','Binary','StringFixedLength'), da.max_length, null),
				[Column!4!Precision] = da.precision,
				[Column!4!Scale] = da.scale,
				[Column!4!IsNullable] = iif(da.is_nullable=1,'true','false'),
				[Column!4!IdentityIncrement] = null,
				[Column!4!IdentitySeed] = null,
				[Annotations!5!] = null,
				[Annotation!6!AnnotationType] = null,
				[Annotation!6!Tag] = null,
				[Annotation!6!!Element] = null
			from semanticinsight.data_object do
			join semanticinsight.data_schema ds on do.data_schema_id = ds.data_schema_id
			join semanticinsight.data_attribute da on da.data_object_id = do.data_object_id
			join semanticinsight.system_component sc on ds.system_component_id = sc.system_component_id
			join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
			join semanticinsight.data_type dt on da.data_type_id = dt.data_type_id
			join semanticinsight.data_object_type dot on dot.data_object_type_id = do.data_object_type_id
			join @source_schema_data src on src.source_database_name = ds.database_name and src.source_schema_name = ds.schema_name
			and do.enabled = 1 and ds.enabled = 1 and sc.enabled = 1 and da.enabled = 1
			and rsc.component_application_name = @@root_component_application_name
			and dot.data_object_type in ('Table','View')
		) x
		order by data_object_id, data_attribute_id, [system_framework_attribute_id], load_pattern_attribute_id
		for xml explicit
	)

	if (@@as_varchar = 1)
	begin
		select convert(varchar(max), @databaseXml) + convert(varchar(max),@schemaXml) + convert(varchar(max),@tablesXml) as table_definition_biml
	end
	else
	begin
		select convert(xml, convert(varchar(max), @databaseXml) + convert(varchar(max),@schemaXml) + convert(varchar(max),@tablesXml)) as table_definition_biml
	end

end