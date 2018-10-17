
# Migrate from Folder Redirection to OneDrive and Known Folder Move

## Issue
The main issues I came across when attempting to move from Folder Redirection to OneDrive Known Folder Move was once my users left the original OU their data would get placed in the local users C:\Windows\CSC directory and not back in their typical C:\Users\username directories.  KFM did not like this and gave me errors about not wanted to move files located on \\\servername\share\username\folder.  

## Resolution
Through testing I realized I needed a GPO to move the files from the Offline location to the users local profile and another GPO to disable Folder Redirection altogether. I didn't want to have to stage users so I ended up creating GPO Environmental Variables and WMI Filters.

1. Configure your existing Folder Redirection GPO - User Configuration > Policies > Windows Settings > Folder Redirection > Folder > Settings > "Redirect the folder back to the local userprofile location when policy is removed" 
   ![Default Folder Redirection Settings](https://github.com/jeffprandall/randoms/blob/master/microsoft/Default%20Folder%20Redirection%20Settings.png)

2. If you can create a new OU for your Users.

3. Create a new GPO linked to that new OU that will redirect the files from the C:\Windows\CSC to C:\Users\username.  I called mine "Redirect Folder Redirection".

4. Edit this GPO - User Configuration > Policies > Windows Settings > Folder Redirection > Folder

5. The Target Settings should be Basic - Redirect everyones folder to the same location and the Target folder location should be "Redirect to the local userprofile location"

   ![Redirect Folder Redirection](https://github.com/jeffprandall/randoms/blob/master/microsoft/Redirect%20Folder%20Redirection.png)

   *Note - during testing if I tried to perform KFM at this point I got error 80070005 which I believe is conflicting with this GPO hence the second GPO need.*
6.  Also in the "Redirect Folder Redirection "GPO we need to a few Environmental Variables under User Configuration > Preferences > Windows Settings > Enviroment.
7.  Create a new Environmental Variable.  Set the Action to Delete, the type to System Variable, and the Name is LocalFolders.  This one starts our variable off empty.
8.  Create another Environmental Variable.  Set the Action to Update, the type to System Variable, the Name to LocalFolders and the Value to False.  
9.  Click on the Common tab > Item-level Targetting and select Targeting
10.  For this example I am only checking Desktop but you can add whatever you like.  The target is checking if the Desktop folder DOES NOT exist in the currently logged on users profile.  In this scenario once a user switches to the new OU their data will be in C:\Windows\CSC and not in their C:\Users\Username\Desktop and now the variable LocalFolders = 0 which you will see later will let the "Redirect Folder Redirection" GPO apply.
![Does exist](https://github.com/jeffprandall/randoms/blob/master/microsoft/screenshots/ENV-Does%20Not%20Exist.png)
11.  Create another Environmental Variable.  Set the Action to Update, the type to System Variable, the Name to LocalFolders and the Value to True.  
12.  Click on the Common tab > Item-level Targetting and select Targeting
13.  The target is checking if the Desktop folder DOES exist in the currently logged on users profile.  I also check the user profiles OneDrive location for Desktop just in case the KFM has not completed.
![Does not exist](https://github.com/jeffprandall/randoms/blob/master/microsoft/ENV%20-%20Does%20Not%20Exist.png)
