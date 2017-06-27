CREATE TABLE [semanticinsight].[data_object_mapping] (
    [data_object_mapping_id]          INT IDENTITY (1, 1) NOT NULL,
    [source_system_component_id]      INT NOT NULL,
    [source_schema_id]                INT NOT NULL,
    [source_data_object_id]           INT NOT NULL,
    [destination_system_component_id] INT NOT NULL,
    [destination_schema_id]           INT NOT NULL,
    [destination_data_object_id]      INT NOT NULL,
    CONSTRAINT [PK_data_object_mapping] PRIMARY KEY CLUSTERED ([data_object_mapping_id] ASC),
    CONSTRAINT [FK_data_object_mapping_data_object] FOREIGN KEY ([source_data_object_id]) REFERENCES [semanticinsight].[data_object] ([data_object_id]),
    CONSTRAINT [FK_data_object_mapping_data_object1] FOREIGN KEY ([destination_data_object_id]) REFERENCES [semanticinsight].[data_object] ([data_object_id]),
    CONSTRAINT [FK_data_object_mapping_data_schema] FOREIGN KEY ([source_schema_id]) REFERENCES [semanticinsight].[data_schema] ([data_schema_id]),
    CONSTRAINT [FK_data_object_mapping_data_schema1] FOREIGN KEY ([destination_schema_id]) REFERENCES [semanticinsight].[data_schema] ([data_schema_id]),
    CONSTRAINT [FK_data_object_mapping_system_component] FOREIGN KEY ([source_system_component_id]) REFERENCES [semanticinsight].[system_component] ([system_component_id]),
    CONSTRAINT [FK_data_object_mapping_system_component1] FOREIGN KEY ([destination_system_component_id]) REFERENCES [semanticinsight].[system_component] ([system_component_id])
);





