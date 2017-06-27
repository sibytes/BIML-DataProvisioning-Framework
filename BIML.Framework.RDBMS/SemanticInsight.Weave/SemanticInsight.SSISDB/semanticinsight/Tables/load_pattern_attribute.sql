CREATE TABLE [semanticinsight].[load_pattern_attribute] (
    [load_pattern_attribute_id] INT            IDENTITY (1, 1) NOT NULL,
    [load_pattern_id]           INT            NOT NULL,
    [name]                      NVARCHAR (132) NOT NULL,
    [data_type_id]              INT            NOT NULL,
    [max_length]                INT            NULL,
    [precision]                 INT            NULL,
    [scale]                     INT            NULL,
    [is_nullable]               BIT            NOT NULL,
    [identity_seed]             INT            DEFAULT ((1)) NOT NULL,
    [identity_increment]        INT            DEFAULT ((1)) NOT NULL,
    [extended_property]         NVARCHAR (200) NULL,
    [enabled]                   BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_load_pattern_attribute] PRIMARY KEY CLUSTERED ([load_pattern_attribute_id] ASC),
    CONSTRAINT [FK_load_pattern_attribute_data_type] FOREIGN KEY ([data_type_id]) REFERENCES [semanticinsight].[data_type] ([data_type_id]),
    CONSTRAINT [FK_load_pattern_attribute_load_pattern] FOREIGN KEY ([load_pattern_id]) REFERENCES [semanticinsight].[load_pattern] ([load_pattern_id])
);





