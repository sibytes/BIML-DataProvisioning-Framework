CREATE TABLE [semanticinsight].[data_attribute_mapping] (
    [data_attribute_mapping_id]     INT IDENTITY (1, 1) NOT NULL,
    [data_object_mapping_id]        INT NOT NULL,
    [source_data_attribute_id]      INT NOT NULL,
    [destination_data_attribute_id] INT NOT NULL,
    CONSTRAINT [PK_data_attribute_mapping] PRIMARY KEY CLUSTERED ([data_attribute_mapping_id] ASC),
    CONSTRAINT [FK_data_attribute_mapping_data_attribute] FOREIGN KEY ([source_data_attribute_id]) REFERENCES [semanticinsight].[data_attribute] ([data_attribute_id]),
    CONSTRAINT [FK_data_attribute_mapping_data_attribute1] FOREIGN KEY ([destination_data_attribute_id]) REFERENCES [semanticinsight].[data_attribute] ([data_attribute_id]),
    CONSTRAINT [FK_data_attribute_mapping_data_object_mapping] FOREIGN KEY ([data_object_mapping_id]) REFERENCES [semanticinsight].[data_object_mapping] ([data_object_mapping_id])
);











