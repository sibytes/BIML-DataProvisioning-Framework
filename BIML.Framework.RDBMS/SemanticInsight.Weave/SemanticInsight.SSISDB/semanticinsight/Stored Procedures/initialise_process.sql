



CREATE procedure [semanticinsight].[initialise_process]
(
	@@parent_process_id int = 0,
	@@component_application_name varchar(50) = 'default',
	@@start_date datetime = null,

	@@user_name varchar(150),
	@@machine_name varchar(150),
	@@package_id uniqueidentifier = null,
	@@execution_id bigint = -1,
	@@version_number varchar(50),
	@@version_comments varchar(8000) = null
)
as
begin
	
	/*
		test script

		declare 
		@P1 int = 0,
		@P2 int = 0,
		@P3 varchar(21) = 'Adventure Works Stage',
		@P4 datetime2(0) = '2015-07-11 07:26:18',
		@P5 varchar(7) = 'RYAN\sr',
		@P6 varchar(15) = 'SEMANTICMI-WIN7',
		@P7 varchar(39) = '{22637EDB-28DC-478F-9470-5DBEF0204325}',
		@P8 bigint = 0,
		@P9 varchar(5) = '0.0.3',
		@P10 varchar(1) = ''


		EXEC [semanticinsight].[initialise_process] 
		 @@parent_process_id = @P1,
		 @@data_object_id = @P2,
		 @@component_application_name = @P3,
		 @@start_date = @P4,

		 @@user_name = @P5,
		 @@machine_name = @P6,
		 @@package_id = @P7,
		 @@execution_id = @P8,
		 @@version_number = @P9,
		 @@version_comments = @P10

	*/
	declare 
		@message nvarchar(4000) = 'Package execution initialised',
		@status nvarchar(9) = 'Running'

	set @@start_date = isnull(@@start_date, getdate());

	begin try

		insert into semanticinsight.process 
		(
			[parent_process_id], 
			[system_component_id], 
			[execution_id], 
			[package_id],
			[status], 
			[message], 
			[start_date],
			[user_name],
			[machine_name],
			[version_number],
			[version_comments]
		)
		select	
			@@parent_process_id, 
			sc.system_component_id, 
			@@execution_id, 
			@@package_id,
			@status, 
			@message, 
			@@start_date,
			@@user_name,
			@@machine_name,
			@@version_number,
			nullif(ltrim(rtrim(@@version_comments)),'')
		from semanticinsight.system_component sc
		where 
			component_application_name = @@component_application_name

		select convert(int, isnull(SCOPE_IDENTITY(),0)) as process_id

	end try 
	begin catch

		throw 51000, 'Process failed to initialise in semanticinsight.process custom etl control.', 1;

	end catch
end