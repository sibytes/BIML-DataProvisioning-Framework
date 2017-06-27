CREATE TABLE [semanticinsight].[process_data_object_stats] (
    [process_data_object_stats_id] INT IDENTITY (1, 1) NOT NULL,
    [process_id]                   INT NOT NULL,
    [data_object_mapping_id]       INT NOT NULL,
    [ssis_row_count]               INT NOT NULL,
    CONSTRAINT [PK_process_data_object_stats] PRIMARY KEY CLUSTERED ([process_data_object_stats_id] ASC),
    CONSTRAINT [FK_process_data_object_stats_data_object_mapping] FOREIGN KEY ([data_object_mapping_id]) REFERENCES [semanticinsight].[data_object_mapping] ([data_object_mapping_id]),
    CONSTRAINT [FK_process_data_object_stats_process] FOREIGN KEY ([process_id]) REFERENCES [semanticinsight].[process] ([process_id])
);



