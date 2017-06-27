

CREATE procedure [semanticinsight].[finalise_process]
(
	@@process_id int = 0,
	@@error_message nvarchar(4000) = null
)
as
begin
	
	declare 
		@message nvarchar(4000) = 'Package execution finalised',
		@status nvarchar(9) = 'Succeeded',
		@end_date datetime = getdate();

	if (nullif(ltrim(rtrim(@@error_message)),'') is not null)
	begin
		set @message = @@error_message;
		set @status = 'Failed'
	end

	begin try

		update semanticinsight.process
		set [end_date] = @end_date,
			[message] = @message,
			[status] = @status
		where process_id = @@process_id

	end try 
	begin catch

		throw 51000, 'Process failed to finilise in semanticinsight.process custom etl control.', 1;

	end catch

end