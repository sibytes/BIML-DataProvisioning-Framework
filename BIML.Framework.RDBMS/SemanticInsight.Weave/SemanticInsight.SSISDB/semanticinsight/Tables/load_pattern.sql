CREATE TABLE [semanticinsight].[load_pattern] (
    [load_pattern_id]          INT             IDENTITY (1, 1) NOT NULL,
    [load_pattern_name]        NVARCHAR (200)  NOT NULL,
    [load_pattern_description] NVARCHAR (4000) NOT NULL,
    CONSTRAINT [PK_load_pattern] PRIMARY KEY CLUSTERED ([load_pattern_id] ASC)
);



