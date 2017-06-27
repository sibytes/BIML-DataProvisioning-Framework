CREATE TABLE [semanticinsight].[process] (
    [process_id]          INT              IDENTITY (1, 1) NOT NULL,
    [parent_process_id]   INT              CONSTRAINT [DF__process__parent___1E3A7A34] DEFAULT ((0)) NOT NULL,
    [system_component_id] INT              NOT NULL,
    [execution_id]        BIGINT           CONSTRAINT [DF__process__executi__1F2E9E6D] DEFAULT ((-1)) NOT NULL,
    [package_id]          UNIQUEIDENTIFIER NULL,
    [status]              NVARCHAR (9)     NOT NULL,
    [message]             NVARCHAR (4000)  NOT NULL,
    [start_date]          DATETIME         NOT NULL,
    [end_date]            DATETIME         NULL,
    [user_name]           VARCHAR (150)    NOT NULL,
    [machine_name]        VARCHAR (150)    NOT NULL,
    [version_number]      VARCHAR (50)     NOT NULL,
    [version_comments]    VARCHAR (8000)   NULL,
    CONSTRAINT [PK_process] PRIMARY KEY CLUSTERED ([process_id] ASC),
    CONSTRAINT [FK_process_process] FOREIGN KEY ([parent_process_id]) REFERENCES [semanticinsight].[process] ([process_id]),
    CONSTRAINT [FK_process_system_component] FOREIGN KEY ([system_component_id]) REFERENCES [semanticinsight].[system_component] ([system_component_id])
);


GO
ALTER TABLE [semanticinsight].[process] NOCHECK CONSTRAINT [FK_process_process];


GO
ALTER TABLE [semanticinsight].[process] NOCHECK CONSTRAINT [FK_process_system_component];




GO
ALTER TABLE [semanticinsight].[process] NOCHECK CONSTRAINT [FK_process_process];









