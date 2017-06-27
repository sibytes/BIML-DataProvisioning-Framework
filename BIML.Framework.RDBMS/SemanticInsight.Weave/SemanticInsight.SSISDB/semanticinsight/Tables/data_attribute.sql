CREATE TABLE [semanticinsight].[data_attribute] (
    [data_attribute_id]        INT            IDENTITY (1, 1) NOT NULL,
    [data_object_id]           INT            NOT NULL,
    [source_data_attribute_id] INT            DEFAULT ((0)) NOT NULL,
    [name]                     NVARCHAR (132) NOT NULL,
    [data_object_datatype]     NVARCHAR (132) NOT NULL,
    [data_type_id]             INT            NOT NULL,
    [max_length]               INT            NULL,
    [precision]                INT            NULL,
    [scale]                    INT            NULL,
    [max]                      BIT            DEFAULT ((0)) NOT NULL,
    [is_nullable]              BIT            DEFAULT ((0)) NOT NULL,
    [is_key]                   BIT            DEFAULT ((0)) NOT NULL,
    [enabled]                  BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_data_attribute] PRIMARY KEY CLUSTERED ([data_attribute_id] ASC),
    CONSTRAINT [FK_data_attribute_data_object] FOREIGN KEY ([data_object_id]) REFERENCES [semanticinsight].[data_object] ([data_object_id]),
    CONSTRAINT [FK_data_attribute_data_type] FOREIGN KEY ([data_type_id]) REFERENCES [semanticinsight].[data_type] ([data_type_id])
);





