CREATE TABLE [semanticinsight].[data_object_type] (
    [data_object_type_id] SMALLINT       IDENTITY (1, 1) NOT NULL,
    [data_object_type]    NVARCHAR (50)  NOT NULL,
    [description]         NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_data_object_type] PRIMARY KEY CLUSTERED ([data_object_type_id] ASC)
);



