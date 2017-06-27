

CREATE procedure [semanticinsight].[truncate_metadata]
as
begin



	ALTER TABLE [semanticinsight].[data_attribute]				DROP CONSTRAINT [FK_data_attribute_data_object]
	ALTER TABLE [semanticinsight].[data_attribute]				DROP CONSTRAINT [FK_data_attribute_data_type]
	ALTER TABLE [semanticinsight].[data_attribute_mapping]		DROP CONSTRAINT [FK_data_attribute_mapping_data_attribute]
	ALTER TABLE [semanticinsight].[data_attribute_mapping]		DROP CONSTRAINT [FK_data_attribute_mapping_data_attribute1]
	ALTER TABLE [semanticinsight].[data_attribute_mapping]		DROP CONSTRAINT [FK_data_attribute_mapping_data_object_mapping]
	ALTER TABLE [semanticinsight].[data_object]					DROP CONSTRAINT [FK_data_object_data_object_type]
	ALTER TABLE [semanticinsight].[data_object]					DROP CONSTRAINT [FK_data_object_data_schema]
	ALTER TABLE [semanticinsight].[data_object]					DROP CONSTRAINT [FK_data_object_load_pattern]
	ALTER TABLE [semanticinsight].[data_object_mapping]			DROP CONSTRAINT [FK_data_object_mapping_data_object]
	ALTER TABLE [semanticinsight].[data_object_mapping]			DROP CONSTRAINT [FK_data_object_mapping_data_object1]
	ALTER TABLE [semanticinsight].[data_object_mapping]			DROP CONSTRAINT [FK_data_object_mapping_data_schema]
	ALTER TABLE [semanticinsight].[data_object_mapping]			DROP CONSTRAINT [FK_data_object_mapping_data_schema1]
	ALTER TABLE [semanticinsight].[data_object_mapping]			DROP CONSTRAINT [FK_data_object_mapping_system_component]
	ALTER TABLE [semanticinsight].[data_object_mapping]			DROP CONSTRAINT [FK_data_object_mapping_system_component1]
	ALTER TABLE [semanticinsight].[data_schema]					DROP CONSTRAINT [FK_data_schema_system_component]
	ALTER TABLE [semanticinsight].[data_schema_mapping]			DROP CONSTRAINT [FK_data_schema_mapping_data_schema]
	ALTER TABLE [semanticinsight].[data_schema_mapping]			DROP CONSTRAINT [FK_data_schema_mapping_data_schema1]
	ALTER TABLE [semanticinsight].[load_pattern_attribute]		DROP CONSTRAINT [FK_load_pattern_attribute_data_type]
	ALTER TABLE [semanticinsight].[load_pattern_attribute]		DROP CONSTRAINT [FK_load_pattern_attribute_load_pattern]
	ALTER TABLE [semanticinsight].[process]						DROP CONSTRAINT [FK_process_process]
	ALTER TABLE [semanticinsight].[process]						DROP CONSTRAINT [FK_process_system_component]
	ALTER TABLE [semanticinsight].[process_data_object_stats]	DROP CONSTRAINT [FK_process_data_object_stats_data_object_mapping]
	ALTER TABLE [semanticinsight].[process_data_object_stats]	DROP CONSTRAINT [FK_process_data_object_stats_process]
	ALTER TABLE [semanticinsight].[system_component]			DROP CONSTRAINT [FK_system_component_system_component_parent]
	ALTER TABLE [semanticinsight].[system_component]			DROP CONSTRAINT [FK_system_component_system_component_root]
	ALTER TABLE [semanticinsight].[system_component]			DROP CONSTRAINT [FK_system_component_system_framework]
	ALTER TABLE [semanticinsight].[system_framework_attribute]	DROP CONSTRAINT [FK_system_framework_attribute_data_type]
	ALTER TABLE [semanticinsight].[system_framework_attribute]	DROP CONSTRAINT [FK_system_framework_attribute_system_framework]

	truncate table [semanticinsight].[process_data_object_stats]
	truncate table [semanticinsight].[data_attribute_mapping]
	truncate table [semanticinsight].[data_schema_mapping]
	truncate table [semanticinsight].[data_object_mapping]
	truncate table [semanticinsight].[data_object]
	truncate table [semanticinsight].[data_attribute]
	truncate table [semanticinsight].[system_component]
	truncate table [semanticinsight].[data_schema]
	delete from [semanticinsight].[process] where process_id > 0


ALTER TABLE [semanticinsight].[data_attribute]  WITH CHECK ADD  CONSTRAINT [FK_data_attribute_data_object] FOREIGN KEY([data_object_id])
REFERENCES [semanticinsight].[data_object] ([data_object_id])
ALTER TABLE [semanticinsight].[data_attribute] CHECK CONSTRAINT [FK_data_attribute_data_object]

ALTER TABLE [semanticinsight].[data_attribute]  WITH CHECK ADD  CONSTRAINT [FK_data_attribute_data_type] FOREIGN KEY([data_type_id])
REFERENCES [semanticinsight].[data_type] ([data_type_id])
ALTER TABLE [semanticinsight].[data_attribute] CHECK CONSTRAINT [FK_data_attribute_data_type]

ALTER TABLE [semanticinsight].[data_attribute_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_attribute_mapping_data_attribute] FOREIGN KEY([source_data_attribute_id])
REFERENCES [semanticinsight].[data_attribute] ([data_attribute_id])
ALTER TABLE [semanticinsight].[data_attribute_mapping] CHECK CONSTRAINT [FK_data_attribute_mapping_data_attribute]

ALTER TABLE [semanticinsight].[data_attribute_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_attribute_mapping_data_attribute1] FOREIGN KEY([destination_data_attribute_id])
REFERENCES [semanticinsight].[data_attribute] ([data_attribute_id])
ALTER TABLE [semanticinsight].[data_attribute_mapping] CHECK CONSTRAINT [FK_data_attribute_mapping_data_attribute1]

ALTER TABLE [semanticinsight].[data_attribute_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_attribute_mapping_data_object_mapping] FOREIGN KEY([data_object_mapping_id])
REFERENCES [semanticinsight].[data_object_mapping] ([data_object_mapping_id])
ALTER TABLE [semanticinsight].[data_attribute_mapping] CHECK CONSTRAINT [FK_data_attribute_mapping_data_object_mapping]

ALTER TABLE [semanticinsight].[data_object]  WITH CHECK ADD  CONSTRAINT [FK_data_object_data_object_type] FOREIGN KEY([data_object_type_id])
REFERENCES [semanticinsight].[data_object_type] ([data_object_type_id])
ALTER TABLE [semanticinsight].[data_object] CHECK CONSTRAINT [FK_data_object_data_object_type]

ALTER TABLE [semanticinsight].[data_object]  WITH CHECK ADD  CONSTRAINT [FK_data_object_data_schema] FOREIGN KEY([data_schema_id])
REFERENCES [semanticinsight].[data_schema] ([data_schema_id])
ALTER TABLE [semanticinsight].[data_object] CHECK CONSTRAINT [FK_data_object_data_schema]

ALTER TABLE [semanticinsight].[data_object]  WITH CHECK ADD  CONSTRAINT [FK_data_object_load_pattern] FOREIGN KEY([load_pattern_id])
REFERENCES [semanticinsight].[load_pattern] ([load_pattern_id])
ALTER TABLE [semanticinsight].[data_object] CHECK CONSTRAINT [FK_data_object_load_pattern]

ALTER TABLE [semanticinsight].[data_object_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_object_mapping_data_object] FOREIGN KEY([source_data_object_id])
REFERENCES [semanticinsight].[data_object] ([data_object_id])
ALTER TABLE [semanticinsight].[data_object_mapping] CHECK CONSTRAINT [FK_data_object_mapping_data_object]

ALTER TABLE [semanticinsight].[data_object_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_object_mapping_data_object1] FOREIGN KEY([destination_data_object_id])
REFERENCES [semanticinsight].[data_object] ([data_object_id])
ALTER TABLE [semanticinsight].[data_object_mapping] CHECK CONSTRAINT [FK_data_object_mapping_data_object1]

ALTER TABLE [semanticinsight].[data_object_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_object_mapping_data_schema] FOREIGN KEY([source_schema_id])
REFERENCES [semanticinsight].[data_schema] ([data_schema_id])
ALTER TABLE [semanticinsight].[data_object_mapping] CHECK CONSTRAINT [FK_data_object_mapping_data_schema]

ALTER TABLE [semanticinsight].[data_object_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_object_mapping_data_schema1] FOREIGN KEY([destination_schema_id])
REFERENCES [semanticinsight].[data_schema] ([data_schema_id])
ALTER TABLE [semanticinsight].[data_object_mapping] CHECK CONSTRAINT [FK_data_object_mapping_data_schema1]

ALTER TABLE [semanticinsight].[data_object_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_object_mapping_system_component] FOREIGN KEY([source_system_component_id])
REFERENCES [semanticinsight].[system_component] ([system_component_id])
ALTER TABLE [semanticinsight].[data_object_mapping] CHECK CONSTRAINT [FK_data_object_mapping_system_component]

ALTER TABLE [semanticinsight].[data_object_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_object_mapping_system_component1] FOREIGN KEY([destination_system_component_id])
REFERENCES [semanticinsight].[system_component] ([system_component_id])
ALTER TABLE [semanticinsight].[data_object_mapping] CHECK CONSTRAINT [FK_data_object_mapping_system_component1]

ALTER TABLE [semanticinsight].[data_schema]  WITH CHECK ADD  CONSTRAINT [FK_data_schema_system_component] FOREIGN KEY([system_component_id])
REFERENCES [semanticinsight].[system_component] ([system_component_id])
ALTER TABLE [semanticinsight].[data_schema] CHECK CONSTRAINT [FK_data_schema_system_component]

ALTER TABLE [semanticinsight].[data_schema_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_schema_mapping_data_schema] FOREIGN KEY([source_data_schema_id])
REFERENCES [semanticinsight].[data_schema] ([data_schema_id])
ALTER TABLE [semanticinsight].[data_schema_mapping] CHECK CONSTRAINT [FK_data_schema_mapping_data_schema]

ALTER TABLE [semanticinsight].[data_schema_mapping]  WITH CHECK ADD  CONSTRAINT [FK_data_schema_mapping_data_schema1] FOREIGN KEY([destination_data_schema_id])
REFERENCES [semanticinsight].[data_schema] ([data_schema_id])
ALTER TABLE [semanticinsight].[data_schema_mapping] CHECK CONSTRAINT [FK_data_schema_mapping_data_schema1]

ALTER TABLE [semanticinsight].[load_pattern_attribute]  WITH CHECK ADD  CONSTRAINT [FK_load_pattern_attribute_data_type] FOREIGN KEY([data_type_id])
REFERENCES [semanticinsight].[data_type] ([data_type_id])
ALTER TABLE [semanticinsight].[load_pattern_attribute] CHECK CONSTRAINT [FK_load_pattern_attribute_data_type]

ALTER TABLE [semanticinsight].[load_pattern_attribute]  WITH CHECK ADD  CONSTRAINT [FK_load_pattern_attribute_load_pattern] FOREIGN KEY([load_pattern_id])
REFERENCES [semanticinsight].[load_pattern] ([load_pattern_id])
ALTER TABLE [semanticinsight].[load_pattern_attribute] CHECK CONSTRAINT [FK_load_pattern_attribute_load_pattern]

ALTER TABLE [semanticinsight].[process]  WITH NOCHECK ADD  CONSTRAINT [FK_process_process] FOREIGN KEY([parent_process_id])
REFERENCES [semanticinsight].[process] ([process_id])
ALTER TABLE [semanticinsight].[process] NOCHECK CONSTRAINT [FK_process_process]

ALTER TABLE [semanticinsight].[process]  WITH NOCHECK ADD  CONSTRAINT [FK_process_system_component] FOREIGN KEY([system_component_id])
REFERENCES [semanticinsight].[system_component] ([system_component_id])
ALTER TABLE [semanticinsight].[process] NOCHECK CONSTRAINT [FK_process_system_component]

ALTER TABLE [semanticinsight].[process_data_object_stats]	WITH CHECK ADD  CONSTRAINT [FK_process_data_object_stats_data_object_mapping] FOREIGN KEY([data_object_mapping_id])
REFERENCES [semanticinsight].[data_object_mapping] ([data_object_mapping_id])
ALTER TABLE [semanticinsight].[process_data_object_stats] CHECK CONSTRAINT [FK_process_data_object_stats_data_object_mapping]

ALTER TABLE [semanticinsight].[process_data_object_stats]  WITH CHECK ADD  CONSTRAINT [FK_process_data_object_stats_process] FOREIGN KEY([process_id])
REFERENCES [semanticinsight].[process] ([process_id])
ALTER TABLE [semanticinsight].[process_data_object_stats] CHECK CONSTRAINT [FK_process_data_object_stats_process]

ALTER TABLE [semanticinsight].[system_component]  WITH NOCHECK ADD  CONSTRAINT [FK_system_component_system_component_parent] FOREIGN KEY([parent_system_component_id])
REFERENCES [semanticinsight].[system_component] ([system_component_id])
ALTER TABLE [semanticinsight].[system_component] NOCHECK CONSTRAINT [FK_system_component_system_component_parent]

ALTER TABLE [semanticinsight].[system_component]  WITH NOCHECK ADD  CONSTRAINT [FK_system_component_system_component_root] FOREIGN KEY([root_system_component_id])
REFERENCES [semanticinsight].[system_component] ([system_component_id])
ALTER TABLE [semanticinsight].[system_component] NOCHECK CONSTRAINT [FK_system_component_system_component_root]

ALTER TABLE [semanticinsight].[system_component]  WITH CHECK ADD  CONSTRAINT [FK_system_component_system_framework] FOREIGN KEY([system_framework_id])
REFERENCES [semanticinsight].[system_framework] ([system_framework_id])
ALTER TABLE [semanticinsight].[system_component] CHECK CONSTRAINT [FK_system_component_system_framework]

ALTER TABLE [semanticinsight].[system_framework_attribute]  WITH CHECK ADD  CONSTRAINT [FK_system_framework_attribute_data_type] FOREIGN KEY([data_type_id])
REFERENCES [semanticinsight].[data_type] ([data_type_id])
ALTER TABLE [semanticinsight].[system_framework_attribute] CHECK CONSTRAINT [FK_system_framework_attribute_data_type]

ALTER TABLE [semanticinsight].[system_framework_attribute]  WITH CHECK ADD  CONSTRAINT [FK_system_framework_attribute_system_framework] FOREIGN KEY([system_framework_id])
REFERENCES [semanticinsight].[system_framework] ([system_framework_id])
ALTER TABLE [semanticinsight].[system_framework_attribute] CHECK CONSTRAINT [FK_system_framework_attribute_system_framework]

end