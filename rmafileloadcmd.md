
## RMA File Loaad Command
=====
 
Certain types of files, eg., specially large files can't be loaded with the normal RMA file load process due to taking too long or timeout. So I introduce RMA command that uses a different technical approach to resolve the issue.

Rma file load process typically takes 4 hours to load a gigbite file in the first step - raw data load, it also has a concern of out of memory when loading large files. My new approach, Rma Command, typically spends less than 20 minues and there is no memory concern.

RMA FL Command Syntax

RmaFL -F {file_path} -R -T {target_db}

-F: to specify the location and name of the data file 
-R: to force a command run. without it, this command only is only to show details of the command and verify if the command is valid
-T: to specify the target enviroment, such as UAT or PRD database.



The configuration 
Environments and their changes are defined in configuration file. I didn't do this with db tables becausue I need to have a database environment just for this command, and it is not necessary.

MapFileLocation:
MappingFiles:
- FileTypeKey: 
  MapFileName:
  TargetTable: 
  PreSql: 
  PostSql:
  TriggerSql:

  
  



