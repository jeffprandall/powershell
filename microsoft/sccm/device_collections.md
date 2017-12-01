### Queries

#### SCCM Device Collection for Office 2010 (specifically Excel 2010)
	SELECT 
	  SMS_R_System.NetbiosName,   
	  SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName
	FROM SMS_R_System 
	INNER JOIN SMS_G_System_ADD_REMOVE_PROGRAMS ON SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceId = SMS_R_System.ResourceId 
	WHERE SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName LIKE "Microsoft Office Excel %2010%"

#### SCCM Device Collection for Office 2010 (specifically Excel 2010)
	SELECT 
	  SMS_R_System.NetbiosName,
	  SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName
	FROM SMS_R_System 
	INNER JOIN SMS_G_System_ADD_REMOVE_PROGRAMS ON SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceId = SMS_R_System.ResourceId
	WHERE SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName LIKE "Microsoft Office %365%"

#### SCCM Device Collection for local HeavyJob installs based on File path
	SELECT 
	  SMS_R_SYSTEM.ResourceID,
	  SMS_R_SYSTEM.ResourceType,
	  SMS_R_SYSTEM.Name,
	  SMS_R_SYSTEM.SMSUniqueIdentifier,
	  SMS_R_SYSTEM.ResourceDomainORWorkgroup,
	  SMS_R_SYSTEM.Client

	FROM SMS_R_System INNER JOIN SMS_G_System_SoftwareFile ON SMS_G_System_SoftwareFile.ResourceId = SMS_R_System.ResourceId  
	WHERE SMS_G_System_SoftwareFile.FilePath LIKE "C:\\HeavyJobWS\\%"
