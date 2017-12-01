#### SCCM Device Collection for Office 2010 based on Add/Remove Programs and File Path 
	SELECT 
	  SMS_R_SYSTEM.ResourceID,
	  SMS_R_SYSTEM.ResourceType,
	  SMS_R_SYSTEM.Name,
	  SMS_R_SYSTEM.SMSUniqueIdentifier,
	  SMS_R_SYSTEM.ResourceDomainORWorkgroup,
	  SMS_R_SYSTEM.Client 

	FROM SMS_R_System 
	  INNER JOIN SMS_G_System_ADD_REMOVE_PROGRAMS ON SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceID = SMS_R_System.ResourceId
	  INNER JOIN SMS_G_System_ADD_REMOVE_PROGRAMS_64 ON SMS_G_System_ADD_REMOVE_PROGRAMS_64.ResourceID = SMS_R_System.ResourceId 
	  INNER JOIN SMS_G_System_SoftwareFile ON SMS_G_System_SoftwareFile.ResourceID = SMS_R_System.ResourceId 

	WHERE SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName LIKE "Microsoft Office %2010%"
	  OR SMS_G_System_ADD_REMOVE_PROGRAMS_64.DisplayName LIKE "Microsoft Office %2010%" 
	  OR SMS_G_System_SoftwareFile.FilePath = "C:\\Program Files\\Microsoft Office\\root\\Office14\\Winword.exe" 
	  OR SMS_G_System_SoftwareFile.FilePath = "C:\\Program Files (x86)\\Microsoft Office\\root\\Office14\\WINWORD.EXE"

#### SCCM Device Collection for Office 2016 based on Add/Remove Programs and File Path 
	SELECT 
	  SMS_R_SYSTEM.ResourceID,
	  SMS_R_SYSTEM.ResourceType,
	  SMS_R_SYSTEM.Name,
	  SMS_R_SYSTEM.SMSUniqueIdentifier,
	  SMS_R_SYSTEM.ResourceDomainORWorkgroup,
	  SMS_R_SYSTEM.Client 

	FROM SMS_R_System 
	  INNER JOIN SMS_G_System_ADD_REMOVE_PROGRAMS ON SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceID = SMS_R_System.ResourceId
	  INNER JOIN SMS_G_System_ADD_REMOVE_PROGRAMS_64 ON SMS_G_System_ADD_REMOVE_PROGRAMS_64.ResourceID = SMS_R_System.ResourceId 
	  INNER JOIN SMS_G_System_SoftwareFile ON SMS_G_System_SoftwareFile.ResourceID = SMS_R_System.ResourceId 

	WHERE SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName LIKE "%Office %365%"
	  OR SMS_G_System_ADD_REMOVE_PROGRAMS_64.DisplayName LIKE "%Office %365%" 
	  OR SMS_G_System_SoftwareFile.FilePath = "C:\\Program Files\\Microsoft Office\\root\\Office16\\Winword.exe" 
	  OR SMS_G_System_SoftwareFile.FilePath = "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE"

#### SCCM Device Collection for BlueBeam
	  SELECT 
	    SMS_R_SYSTEM.ResourceID,
	    SMS_R_SYSTEM.ResourceType,
	    SMS_R_SYSTEM.Name,
	    SMS_R_SYSTEM.SMSUniqueIdentifier,
	    SMS_R_SYSTEM.ResourceDomainORWorkgroup,
	    SMS_R_SYSTEM.Client 
	 
	 FROM SMS_R_System 
	   INNER JOIN SMS_G_System_ADD_REMOVE_PROGRAMS ON SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceID = SMS_R_System.ResourceId
	   INNER JOIN SMS_G_System_ADD_REMOVE_PROGRAMS_64 ON SMS_G_System_ADD_REMOVE_PROGRAMS_64.ResourceID = SMS_R_System.ResourceId 

	 WHERE SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName LIKE "%Revu%" 
	   OR SMS_G_System_ADD_REMOVE_PROGRAMS_64.DisplayName LIKE "%Revu%" 

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
