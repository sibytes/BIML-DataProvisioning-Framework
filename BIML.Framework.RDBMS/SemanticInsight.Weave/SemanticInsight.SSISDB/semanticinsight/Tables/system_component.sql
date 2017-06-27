CREATE TABLE [semanticinsight].[system_component] (
    [system_component_id]               INT             IDENTITY (1, 1) NOT NULL,
    [system_framework_id]               INT             CONSTRAINT [DF__system_co__syste__1758727B] DEFAULT ((1)) NOT NULL,
    [parent_system_component_id]        INT             CONSTRAINT [DF__system_co__paren__184C96B4] DEFAULT ((0)) NOT NULL,
    [root_system_component_id]          INT             CONSTRAINT [DF__system_co__root___1940BAED] DEFAULT ((0)) NOT NULL,
    [component_application_name]        NVARCHAR (50)   NOT NULL,
    [component_application_description] NVARCHAR (2000) NOT NULL,
    [component_hostservice_name]        NVARCHAR (50)   NOT NULL,
    [component_hostservice_description] NVARCHAR (2000) NOT NULL,
    [enabled]                           BIT             CONSTRAINT [DF_system_component_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_system_component] PRIMARY KEY CLUSTERED ([system_component_id] ASC),
    CONSTRAINT [FK_system_component_system_component_parent] FOREIGN KEY ([parent_system_component_id]) REFERENCES [semanticinsight].[system_component] ([system_component_id]),
    CONSTRAINT [FK_system_component_system_component_root] FOREIGN KEY ([root_system_component_id]) REFERENCES [semanticinsight].[system_component] ([system_component_id]),
    CONSTRAINT [FK_system_component_system_framework] FOREIGN KEY ([system_framework_id]) REFERENCES [semanticinsight].[system_framework] ([system_framework_id])
);


GO
ALTER TABLE [semanticinsight].[system_component] NOCHECK CONSTRAINT [FK_system_component_system_component_parent];


GO
ALTER TABLE [semanticinsight].[system_component] NOCHECK CONSTRAINT [FK_system_component_system_component_root];







