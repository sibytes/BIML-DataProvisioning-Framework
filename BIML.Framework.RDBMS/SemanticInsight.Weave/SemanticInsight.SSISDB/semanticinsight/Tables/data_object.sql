CREATE TABLE [semanticinsight].[data_object] (
    [data_object_id]               INT             IDENTITY (1, 1) NOT NULL,
    [data_object_type_id]          SMALLINT        NOT NULL,
    [load_pattern_id]              INT             DEFAULT ((1)) NOT NULL,
    [data_schema_id]               INT             NOT NULL,
    [source_data_object_id]        INT             NULL,
    [description]                  NVARCHAR (4000) NULL,
    [name]                         NVARCHAR (132)  NOT NULL,
    [attribute_delimiter]          NVARCHAR (1)    NULL,
    [row_delimiter]                NVARCHAR (2)    NULL,
    [attribute_qualifier]          NVARCHAR (1)    NULL,
    [batch_size]                   INT             DEFAULT ((0)) NOT NULL,
    [use_fast_load_if_available]   BIT             DEFAULT ((1)) NOT NULL,
    [always_use_default_code_page] BIT             DEFAULT ((0)) NOT NULL,
    [check_constraints]            BIT             DEFAULT ((1)) NOT NULL,
    [default_code_page]            INT             DEFAULT ((1252)) NOT NULL,
    [fast_load_options]            NVARCHAR (500)  DEFAULT ('TABLOCK,CHECK_CONSTRAINTS') NOT NULL,
    [keep_identity]                BIT             DEFAULT ((0)) NOT NULL,
    [keep_nulls]                   BIT             DEFAULT ((0)) NOT NULL,
    [locale_id]                    INT             DEFAULT ((2057)) NOT NULL,
    [maximum_insert_commit_size]   INT             DEFAULT ((2147483647)) NOT NULL,
    [table_lock]                   BIT             DEFAULT ((1)) NOT NULL,
    [timeout]                      INT             DEFAULT ((0)) NOT NULL,
    [validate_external_metadata]   BIT             DEFAULT ((0)) NOT NULL,
    [enabled]                      BIT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_data_object] PRIMARY KEY CLUSTERED ([data_object_id] ASC),
    CONSTRAINT [FK_data_object_data_object_type] FOREIGN KEY ([data_object_type_id]) REFERENCES [semanticinsight].[data_object_type] ([data_object_type_id]),
    CONSTRAINT [FK_data_object_data_schema] FOREIGN KEY ([data_schema_id]) REFERENCES [semanticinsight].[data_schema] ([data_schema_id]),
    CONSTRAINT [FK_data_object_load_pattern] FOREIGN KEY ([load_pattern_id]) REFERENCES [semanticinsight].[load_pattern] ([load_pattern_id])
);







