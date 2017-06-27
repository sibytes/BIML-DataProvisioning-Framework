CREATE TABLE [semanticinsight].[data_schema] (
    [data_schema_id]                      INT            IDENTITY (1, 1) NOT NULL,
    [system_component_id]                 INT            NOT NULL,
    [database_name]                       NVARCHAR (132) NOT NULL,
    [schema_name]                         NVARCHAR (132) NOT NULL,
    [is_source]                           BIT            NOT NULL,
    [is_destination]                      BIT            NOT NULL,
    [enabled]                             BIT            CONSTRAINT [DF_data_schema_enabled] DEFAULT ((1)) NOT NULL,
    [concatenate_source_schem_table_name] BIT            NOT NULL,
    CONSTRAINT [PK_data_schema] PRIMARY KEY CLUSTERED ([data_schema_id] ASC),
    CONSTRAINT [FK_data_schema_system_component] FOREIGN KEY ([system_component_id]) REFERENCES [semanticinsight].[system_component] ([system_component_id])
);







