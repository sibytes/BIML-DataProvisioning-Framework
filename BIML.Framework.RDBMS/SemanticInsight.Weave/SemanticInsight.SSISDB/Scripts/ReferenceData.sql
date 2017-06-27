SET IDENTITY_INSERT [semanticinsight].[data_object_type] ON
INSERT INTO semanticinsight.data_object_type (data_object_type_id, data_object_type, [description])
VALUES
(1	,'Table',			'RDBMS relational tables'),
(2	,'View',			'RDBMS compiled view'),
(3	,'StoredProcedure',	'RDBS compiled stored procedure')
SET IDENTITY_INSERT [semanticinsight].[data_object_type] OFF


SET IDENTITY_INSERT [semanticinsight].[system_framework] ON;
INSERT INTO [semanticinsight].[system_framework]
           ([system_framework_id]
		   ,[name]
           ,[description]
           ,[is_default])
VALUES
(1,	'Semantic.Insight',	'Semantic Insight framework that extends SSIDB with package executiona and system logging and meta data lineage',	1)
SET IDENTITY_INSERT [semanticinsight].[system_framework] OFF;

SET IDENTITY_INSERT [semanticinsight].[data_type] ON;
INSERT INTO [semanticinsight].[data_type]
           ([data_type_id]
		   ,[sql_server]
           ,[sql_server_default_conversion]
           ,[ssis]
           ,[biml])
VALUES
(1,		'bigint'			,NULL																			,'DT_I8'					,'Int64'				),
(2,		'binary'			,NULL																			,'DT_BYTES'					,'Binary'				),
(3,		'bit'				,NULL																			,'DT_BOOL'					,'Boolean'				),
(4,		'char'				,NULL																			,'DT_STR'					,'AnsiStringFixedLength'),
(5,		'date'				,NULL																			,'DT_DBDATE'				,'Date'					),
(6,		'datetime'			,NULL																			,'DT_DBTIMESTAMP'			,'DateTime'				),
(7,		'datetime2'			,NULL																			,'DT_DBTIMESTAMP2'			,'DateTime2'			),
(8,		'datetimeoffset'	,NULL																			,'DT_DBTIMESTAMPOFFSET'		,'DateTimeOffset'		),
(9,		'decimal'			,NULL																			,'DT_DECIMAL'				,'Decimal'				),
(10,	'float'				,NULL																			,'DT_R8'					,'Double'				),
(11,	'image'				,NULL																			,'DT_IMAGE'					,'Binary'				),
(12,	'int'				,NULL																			,'DT_I4'					,'Int32'				),
(13,	'money'				,NULL																			,'DT_CY'					,'Currency'				),
(14,	'nchar'				,NULL																			,'DT_WSTR'					,'StringFixedLength'	),
(15,	'ntext'				,NULL																			,'DT_NTEXT'					,'String'				),
(16,	'numeric'			,NULL																			,'DT_NUMERIC'				,'Decimal'				),
(17,	'nvarchar'			,NULL																			,'DT_WSTR'					,'String'				),
(18,	'real'				,NULL																			,'DT_R4'					,'Single'				),
(19,	'smalldatetime'		,NULL																			,'DT_DBTIMESTAMP'			,'DateTime'				),
(20,	'smallint'			,NULL																			,'DT_I2'					,'Int16'				),
(21,	'smallmoney'		,NULL																			,'DT_CY'					,'Currency'				),
(22,	'sql_variant'		,NULL																			,'DT_WSTR'					,'Object'				),
(23,	'text'				,NULL																			,'DT_TEXT'					,'AnsiString'			),
(24,	'time'				,NULL																			,'DT_DBTIME2'				,'Time'					),
(25,	'tinyint'			,NULL																			,'DT_UI1'					,'Byte'					),
(26,	'uniqueidentifier'	,NULL																			,'DT_GUID'					,'Guid'					),
(27,	'varbinary'			,NULL																			,'DT_BYTES'					,'Binary'				),
(28,	'varchar'			,NULL																			,'DT_STR'					,'AnsiString'			),
(29,	'xml'				,NULL																			,'DT_WSTR'					,'Xml'					),
(30,	'geography'			,'convert(varbinary(max), <data_attribute_name>) as <data_attribute_name>'		,'DT_BYTES'					,'Binary'				),
(31,	'geometry'			,'convert(varbinary(max), <data_attribute_name>) as <data_attribute_name>'		,'DT_BYTES'					,'Binary'				),
(32,	'hierarchyid'		,'convert(varbinary(892), <data_attribute_name>) as <data_attribute_name>'		,'DT_BYTES'					,'Binary'				)
SET IDENTITY_INSERT [semanticinsight].[data_type] OFF;

SET IDENTITY_INSERT [semanticinsight].[load_pattern] ON
INSERT INTO [semanticinsight].[load_pattern]
           (
		    [load_pattern_id]
		   ,[load_pattern_name]
           ,[load_pattern_description])
VALUES
(1,	'OleDb.Truncate.Load',	'Truncates and loads through OleDb')
SET IDENTITY_INSERT [semanticinsight].[load_pattern] OFF



SET IDENTITY_INSERT [semanticinsight].[system_framework_attribute] ON
INSERT INTO [semanticinsight].[system_framework_attribute] (
	   [system_framework_attribute_id]
      ,[system_framework_id]
      ,[name]
      ,[data_type_id]
      ,[max_length]
      ,[precision]
      ,[scale]
      ,[is_nullable]
      ,[identity_seed]
      ,[identity_increment]
      ,[extended_property]
      ,[enabled])
VALUES
(1,	1,	'process_id',				12,	4,	10,	0,	1,	NULL,	NULL,	'process_id',				1),
(4,	1,	'data_object_mapping_id',	12,	4,	10,	0,	1,	NULL,	NULL,	'data_object_mapping_id',	1)
SET IDENTITY_INSERT [semanticinsight].[system_framework_attribute] OFF



SET IDENTITY_INSERT [semanticinsight].[load_pattern_attribute] ON
INSERT INTO [semanticinsight].[load_pattern_attribute]
           ([load_pattern_attribute_id]
		   ,[load_pattern_id]
           ,[name]
           ,[data_type_id]
           ,[max_length]
           ,[precision]
           ,[scale]
           ,[is_nullable]
           ,[identity_seed]
           ,[identity_increment]
           ,[extended_property]
           ,[enabled])
VALUES
(1,	1,	'Dw<surrogate_key>Id',	12,	4,	10,	0,	0,	1,	1,	'surrogate_key',	1)
SET IDENTITY_INSERT [semanticinsight].[load_pattern_attribute] OFF

SET IDENTITY_INSERT [semanticinsight].[process] ON;
INSERT INTO [semanticinsight].[process]
           ([process_id]
		   ,[parent_process_id]
           ,[system_component_id]
           ,[execution_id]
           ,[package_id]
           ,[status]
           ,[message]
           ,[start_date]
           ,[end_date]
           ,[user_name]
           ,[machine_name]
           ,[version_number]
           ,[version_comments])
VALUES
(0,	0,	0,	-1,	NULL,	'Succeeded',	'Package execution finalised',	'1900-01-01 00:00:00.000',	'2015-07-12 14:10:59.697',	'NA',	'NA',	'0.0.0',	NULL)
SET IDENTITY_INSERT [semanticinsight].[process] OFF;




