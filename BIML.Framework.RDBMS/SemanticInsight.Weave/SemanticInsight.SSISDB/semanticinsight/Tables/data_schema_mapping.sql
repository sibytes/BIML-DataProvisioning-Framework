CREATE TABLE [semanticinsight].[data_schema_mapping] (
    [data_schema_mapping_id]     INT IDENTITY (1, 1) NOT NULL,
    [source_data_schema_id]      INT NOT NULL,
    [destination_data_schema_id] INT NOT NULL,
    [enabled]                    BIT DEFAULT ((1)) NULL,
    CONSTRAINT [PK_data_schema_mapping] PRIMARY KEY CLUSTERED ([data_schema_mapping_id] ASC),
    CONSTRAINT [FK_data_schema_mapping_data_schema] FOREIGN KEY ([source_data_schema_id]) REFERENCES [semanticinsight].[data_schema] ([data_schema_id]),
    CONSTRAINT [FK_data_schema_mapping_data_schema1] FOREIGN KEY ([destination_data_schema_id]) REFERENCES [semanticinsight].[data_schema] ([data_schema_id])
);







