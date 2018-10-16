
# Migrate from Folder Redirection to OneDrive and Known Folder Move

## Issue
The main issues I came across when attempting to move from Folder Redirection to OneDrive Known Folder Move was once my users left the original OU their data would get placed in the local users C:\Windows\CSC directory and not back in their typical C:\Users\username directories.  KFM did not like this and gave me errors about not wanted to move files located on \\\servername\share\username\folder.  

## Resolution
Through testing I realized I needed a GPO to move the files from the Offline location to the users local profile (C:\Users\users\folder) and another GPO to disable Folder Redirection. I didn't want to have to stage users so I ended up creating GPO Environmental Variables and WMI Filters.

1.  Configure your existing Folder Redirection GPO User Configuration > Policies > Windows Settings > Folder Redirection > Folder > Settings > "Redirect the folder back to the local userprofile location when policy is removed" 
2.  
