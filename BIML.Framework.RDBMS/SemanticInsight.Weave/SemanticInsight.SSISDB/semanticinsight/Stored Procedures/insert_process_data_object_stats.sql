




create procedure [semanticinsight].[insert_process_data_object_stats]
(
	@@process_id int,
	@@data_object_mapping_id int,
	@@ssis_row_count int
)
as
begin


	insert into [semanticinsight].[process_data_object_stats]
           ([process_id]
           ,[data_object_mapping_id]
           ,[ssis_row_count])
     values(@@process_id, @@data_object_mapping_id, @@ssis_row_count)

end