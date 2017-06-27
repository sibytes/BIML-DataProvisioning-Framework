


create procedure [semanticinsight].[delete_process]
as
begin

delete from [semanticinsight].[process] where process_id > 0

end