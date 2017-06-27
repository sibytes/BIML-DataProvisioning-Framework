# BIML-DataProvisioning-Framework

Automated development framework to create data provisioning platforms using BIML and T4 Templates for Code Creation.

## What's in this project

This project has 2 visual studio solutions each having 2 projects.

1. **SemanticInsight.Weave**
    
  * SemanticInsight.SSISDB (SQL Server database project)
  
    SSDB extensions for fully integrated logging, row stats, data lineage, rag status reporting, BIML script conifguration and most importantly a meta data repository with procedures that maps metadata and returns BIML script.

  * SemanticInsight.Weave (C# library)
    
    C# assembly to integrate BIML scripts with the metadata repository SemanticInsight.SSISDB
  
2. **BIML**

  * BIML ETL (SSIS project)
  
    This SSIS project creates the operational packages that will be deployed with re-usable emebedded framework extensions for logging, row     stats, data lineage all tied to the meta data repository and mappings.
  
  * BIML Utility (SSIS Project)
    
    This SSIS project creates working development utility packages that bulk scrape metadata into the metadata repository, create tables       and delete tables
  

Note that SSIS is not yet support in Visual Studio 2017 and therefore it's advised to work with teh BIML solition in Visual Studio 2015.
