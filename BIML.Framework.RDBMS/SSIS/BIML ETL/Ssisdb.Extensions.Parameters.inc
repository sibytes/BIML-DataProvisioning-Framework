  <!--
    Parent process id is the data lineage process id passed in by the parent calling package.
    This is so we can record a hierarchical package process log in SSISDB extensions for data lineage and integrated warehouse
    package execution logging, audit and system health. Detailed information is avaiable in SSISDB and our SSISDB extensions
    bridge a small gap between SSISDB and data warehouse lineage, system health and system auditing.
  -->
<Parameter Name="parent_process_id" DataType="Int64" IsRequired="true" IsSensitive="false">0</Parameter>