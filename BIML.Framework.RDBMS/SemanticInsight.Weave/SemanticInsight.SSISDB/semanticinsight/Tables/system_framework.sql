CREATE TABLE [semanticinsight].[system_framework] (
    [system_framework_id] INT             IDENTITY (1, 1) NOT NULL,
    [name]                NVARCHAR (50)   NOT NULL,
    [description]         NVARCHAR (4000) NOT NULL,
    [is_default]          BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_system_framework] PRIMARY KEY CLUSTERED ([system_framework_id] ASC)
);



