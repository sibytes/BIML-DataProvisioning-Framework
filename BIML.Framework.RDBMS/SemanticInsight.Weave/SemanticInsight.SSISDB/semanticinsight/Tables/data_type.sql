CREATE TABLE [semanticinsight].[data_type] (
    [data_type_id]                  INT            IDENTITY (1, 1) NOT NULL,
    [sql_server]                    NVARCHAR (132) NOT NULL,
    [sql_server_default_conversion] NVARCHAR (150) NULL,
    [ssis]                          NVARCHAR (132) NOT NULL,
    [biml]                          NVARCHAR (132) NOT NULL,
    CONSTRAINT [PK_data_type] PRIMARY KEY CLUSTERED ([data_type_id] ASC)
);





