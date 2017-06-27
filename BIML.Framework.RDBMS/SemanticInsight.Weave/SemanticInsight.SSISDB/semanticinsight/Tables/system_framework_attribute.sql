CREATE TABLE [semanticinsight].[system_framework_attribute] (
    [system_framework_attribute_id] INT            IDENTITY (1, 1) NOT NULL,
    [system_framework_id]           INT            NOT NULL,
    [name]                          NVARCHAR (132) NOT NULL,
    [data_type_id]                  INT            NOT NULL,
    [max_length]                    INT            NULL,
    [precision]                     INT            NULL,
    [scale]                         INT            NULL,
    [is_nullable]                   INT            NOT NULL,
    [identity_seed]                 INT            NULL,
    [identity_increment]            INT            NULL,
    [extended_property]             NVARCHAR (200) NULL,
    [enabled]                       BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_system_framework_attribute] PRIMARY KEY CLUSTERED ([system_framework_attribute_id] ASC),
    CONSTRAINT [FK_system_framework_attribute_data_type] FOREIGN KEY ([data_type_id]) REFERENCES [semanticinsight].[data_type] ([data_type_id]),
    CONSTRAINT [FK_system_framework_attribute_system_framework] FOREIGN KEY ([system_framework_id]) REFERENCES [semanticinsight].[system_framework] ([system_framework_id])
);





