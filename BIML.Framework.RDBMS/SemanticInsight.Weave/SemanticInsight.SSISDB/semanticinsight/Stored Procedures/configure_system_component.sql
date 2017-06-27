
CREATE procedure [semanticinsight].[configure_system_component]
(
	@@data_source_name varchar(50)
)
as
begin

	declare @system_component_id int;
	declare @test_single_destination_schema bit = 0;

	if (@@data_source_name = 'Adventure Works')
	begin

		if not exists(select * from semanticinsight.system_component where component_application_name = 'Adventure Works BI')
		begin
			insert into semanticinsight.system_component (
				parent_system_component_id,
				system_framework_id,
				component_application_name, 
				component_application_description, 
				component_hostservice_name,
				component_hostservice_description
				)			
			select 
				0 as parent_system_component_id,
				sf.system_framework_id, 
				'Adventure Works BI' as component_application_name, 
				'BI System for a multinational manufacturing company called Adventure Works Cycles.' as component_application_description,
				'SQL Server 2012' as component_hostservice_name,
				'Microsoft SQL Server 2012 - 11.0.5058.0 (X64) May 14 2014 18:34:29 Copyright (c) Microsoft Corporation Developer Edition (64-bit) on Windows NT 6.1 <X64> (Build 7601: Service Pack 1)' as component_hostservice_description
			from semanticinsight.system_framework sf
			where sf.name = 'Semantic.Insight'

			update semanticinsight.system_component
			set root_system_component_id = @@IDENTITY
			where component_application_name = 'Adventure Works BI'
		end

		if not exists(select * from semanticinsight.system_component where component_application_name = 'Adventure Works')
		begin
			insert into semanticinsight.system_component (
				parent_system_component_id,
				system_framework_id,
				root_system_component_id,
				component_application_name, 
				component_application_description, 
				component_hostservice_name,
				component_hostservice_description
				)
			select 
				system_component_id as parent_system_component_id,
				sf.system_framework_id,
				system_component_id as root_system_component_id,
				'Adventure Works' as component_application_name,
				'Operational database for a multinational manufacturing company called Adventure Works Cycles.' as component_application_description,
				'SQL Server 2012' as component_hostservice_name,
				'Microsoft SQL Server 2012 - 11.0.5058.0 (X64) May 14 2014 18:34:29 Copyright (c) Microsoft Corporation Developer Edition (64-bit) on Windows NT 6.1 <X64> (Build 7601: Service Pack 1)' as component_hostservice_description
			from semanticinsight.system_component
			,semanticinsight.system_framework sf
			where sf.name = 'Semantic.Insight'
			and component_application_name = 'Adventure Works BI'

			set @system_component_id = @@IDENTITY

			insert into [semanticinsight].[data_schema] (system_component_id, database_name, [schema_name], is_source, is_destination, concatenate_source_schem_table_name)
			select @system_component_id,'AdventureWorks' ,'HumanResources' ,1 , 0, 0
			union all
			select @system_component_id,'AdventureWorks' ,'Person' ,1 , 0, 0
			union all
			select @system_component_id,'AdventureWorks' ,'Production' ,1 , 0, 0
			union all
			select @system_component_id,'AdventureWorks' ,'Purchasing' ,1 , 0, 0
			union all
			select @system_component_id,'AdventureWorks' ,'Sales' ,1 ,0, 0

		end

		if not exists(select * from semanticinsight.system_component where component_application_name = 'Adventure Works Stage')
		begin
			insert into semanticinsight.system_component (
				parent_system_component_id,
				system_framework_id,
				root_system_component_id,
				component_application_name, 
				component_application_description, 
				component_hostservice_name,
				component_hostservice_description
				)
			select 
				system_component_id as parent_system_component_id,
				sf.system_framework_id,
				system_component_id as root_system_component_id,
				'Adventure Works Stage' as component_application_name,
				'Stage database for a multinational manufacturing company called Adventure Works Cycles.' as component_application_description,
				'SQL Server 2012' as component_hostservice_name,
				'Microsoft SQL Server 2012 - 11.0.5058.0 (X64) May 14 2014 18:34:29 Copyright (c) Microsoft Corporation Developer Edition (64-bit) on Windows NT 6.1 <X64> (Build 7601: Service Pack 1)' as component_hostservice_description
			from semanticinsight.system_component
			,semanticinsight.system_framework sf
			where sf.name = 'Semantic.Insight'
			and component_application_name = 'Adventure Works BI'

			set @system_component_id = @@IDENTITY

			if (@test_single_destination_schema = 0)
			begin

				insert into [semanticinsight].[data_schema] (system_component_id, database_name, [schema_name], is_source, is_destination, concatenate_source_schem_table_name)
				select @system_component_id,'Stage' ,'HumanResources' ,0, 1, 0
				union all
				select @system_component_id,'Stage' ,'Person' ,0, 1, 0
				union all
				select @system_component_id,'Stage' ,'Production' ,0, 1, 0
				union all
				select @system_component_id,'Stage' ,'Purchasing' ,0, 1, 0
				union all
				select @system_component_id,'Stage' ,'Sales' ,0, 1, 0

				insert into semanticinsight.data_schema_mapping(source_data_schema_id, destination_data_schema_id)
				select source_data_schema_id, destination_data_schema_id
				from
				(select data_schema_id as source_data_schema_id, schema_name as source_schema_name
				from semanticinsight.data_schema ds
				join semanticinsight.system_component sc on sc.system_component_id = ds.system_component_id
				join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
				where rsc.component_application_name = 'Adventure Works BI' and sc.component_application_name = 'Adventure Works'
				and ds.is_source = 1) s
				join
				(select data_schema_id as destination_data_schema_id, schema_name as destination_schema_name
				from semanticinsight.data_schema ds
				join semanticinsight.system_component sc on sc.system_component_id = ds.system_component_id
				join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
				where rsc.component_application_name = 'Adventure Works BI' and sc.component_application_name = 'Adventure Works Stage'
				and ds.is_destination = 1) d on s.source_schema_name = d.destination_schema_name
			end
			else
			begin

				insert into [semanticinsight].[data_schema] (system_component_id, database_name, [schema_name], is_source, is_destination, concatenate_source_schem_table_name)
				select @system_component_id,'Stage' ,'AdventureWorks' , 0, 1 ,1

				insert into semanticinsight.data_schema_mapping(source_data_schema_id, destination_data_schema_id)
				select source_data_schema_id, destination_data_schema_id
				from
				(select data_schema_id as source_data_schema_id
				from semanticinsight.data_schema ds
				join semanticinsight.system_component sc on sc.system_component_id = ds.system_component_id
				join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
				where rsc.component_application_name = 'Adventure Works BI' and sc.component_application_name = 'Adventure Works'
				and ds.is_source = 1) s,
				(select data_schema_id as destination_data_schema_id, ds.*
				from semanticinsight.data_schema ds
				join semanticinsight.system_component sc on sc.system_component_id = ds.system_component_id
				join semanticinsight.system_component rsc on sc.root_system_component_id = rsc.system_component_id
				where rsc.component_application_name = 'Adventure Works BI' and sc.component_application_name = 'Adventure Works Stage'
				and ds.is_destination = 1) d

			end


		end

	end

end