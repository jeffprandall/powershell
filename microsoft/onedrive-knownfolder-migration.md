
# Migrate from Folder Redirection to OneDrive and Known Folder Move

## Issue
The main issues I came across when attempting to move from Folder Redirection to OneDrive Known Folder Move was once my users left the original OU their data would get placed in the local users C:\Windows\CSC directory and not back in their typical C:\Users\username directories.  KFM did not like this and gave me errors about not wanted to move files located on \\\servername\share\username\folder.  

## Resolution
Through testing I realized I needed a GPO to move the files from the Offline location to the users local profile and another GPO to disable Folder Redirection altogether. I didn't want to have to stage users so I ended up creating GPO Environmental Variables and WMI Filters.

### Create the GPO's
1. Configure your existing Folder Redirection GPO - User Configuration > Policies > Windows Settings > Folder Redirection > Folder > Settings > "Redirect the folder back to the local userprofile location when policy is removed" 
   ![Default Folder Redirection Settings](https://github.com/jeffprandall/randoms/blob/master/microsoft/Default%20Folder%20Redirection%20Settings.png)

2. If you can create a new OU for your Users.

3. Create a new GPO linked to that new OU that will redirect the files from the C:\Windows\CSC to C:\Users\username.  I called mine "Redirect Folder Redirection".

4. Edit this GPO - User Configuration > Policies > Windows Settings > Folder Redirection > Folder

5. The Target Settings should be Basic - Redirect everyones folder to the same location and the Target folder location should be "Redirect to the local userprofile location"

   ![Redirect Folder Redirection](https://github.com/jeffprandall/randoms/blob/master/microsoft/Redirect%20Folder%20Redirection.png)

   **Note - during testing if I tried to perform KFM at this point I got error 80070005 which I believe is conflicting with this GPO hence the second GPO need.**
6.  Also in the "Redirect Folder Redirection" GPO we need to a few Environmental Variables under User Configuration > Preferences > Windows Settings > Enviroment.
7.  Create a new Environmental Variable.  Set the Action to Delete, the type to System Variable, and the Name is LocalFolders.  This one starts our variable off empty.
8.  Create another Environmental Variable.  Set the Action to Update, the type to System Variable, the Name to LocalFolders and the Value to False.  
9.  Click on the Common tab > Item-level Targetting and select Targeting
10.  For this example I am only checking Desktop but you can add whatever you like.  The target is checking if the Desktop folder DOES NOT exist in the currently logged on users profile.  In this scenario once a user switches to the new OU their data will be in C:\Windows\CSC and not in their C:\Users\Username\Desktop and now the variable LocalFolders = 0 which you will see later will let the "Redirect Folder Redirection" GPO apply.
![Does not exist](https://github.com/jeffprandall/randoms/blob/master/microsoft/screenshots/ENV-Does%20Not%20Exist.png)
11.  Create another Environmental Variable.  Set the Action to Update, the type to System Variable, the Name to LocalFolders and the Value to True.  
12.  Click on the Common tab > Item-level Targetting and select Targeting
13.  The target is checking if the Desktop folder DOES exist in the currently logged on users profile.  I also check the user profiles OneDrive location for Desktop just in case the KFM has not completed.
![Does exist](https://github.com/jeffprandall/randoms/blob/master/microsoft/screenshots/ENV-Does%20Exist.png)
14.  Verify the order ![order](https://github.com/jeffprandall/randoms/blob/master/microsoft/screenshots/ENV-Order.png)
15.  Now we create another GPO in that same OU.  I called mine "Disabled Folder Redirection".
16.  Since the default Folder Redirection on a new policy is Not Configured this will essentially remove all Folder Redirection but we do need to set and verify some Environmental Variables under User Configuration > Preferences > Windows Settings > Enviroment.
17.  Create a new Environmental Variable.  Set the Action to Update, the type to System Variable, the Name is LocalFolders and the Value to False.
18. Click on the Common tab > Item-level Targetting and select Targeting
19.  The target is checking if the Desktop folder DOES NOT exist in the currently logged on users profile.  I also check the user profiles OneDrive location for Desktop just in case the KFM has not completed.  This might seem overkill but during testing this GPO's kept fighting so I put this in just to verify.
![Does exist](https://github.com/jeffprandall/randoms/blob/master/microsoft/screenshots/ENV-Does%20Not%20Exist%20OneDrive.png)
20.  One last thing to check is to make the sure first GPO you create "Redirect Folder Redirection" has a lower Link Order than the second GPO "Disabled Folder Redirection".

### Create the WMI Filter
The WMI filter is going to check the system for an Environmental Variable called LocalFolders and if its Value = 0.
1.  In the Group Policy Management console go to WMI Filters
2.  Create a new WMI Filter
3.  I named mine ENV-LocalFolders
4.  Press Add
5.  Then Namespace should be root/CIMv2
6.  The query should be 
```Select * FROM Win32_Environment WHERE Name='LocalFolders' AND VariableValue='False'```
![WMI Query](https://github.com/jeffprandall/randoms/blob/master/microsoft/screenshots/ENV-WMI%20Query.png)

### Apply the WMI Filter to the GPO
When we apply a WMI Filter to a GPO if the results of the WMI are True then that GPO gets applied, otherwise it gets denied.
1.  Locate the first GPO you created "Redirect Folder Redirection"
2.  At the bottom of the screen under WMI Filtering select ENV-LocalFolders

## Applying to end users
Since Folder Redirection changes only happen at logon/logoff I like to start this process in the AM.  I also recommend staging this as to not saturate your network connection as depending on the amount of data users have will depend on their log in time.
1.  Move users to the new OU in the AM.  This gives AD all day to replicate the changes.
2.  Tell users that night to log off, then back on, and then leave.  Upon login the "Redirect Folder Redirection" GPO will get applied and start moving all the files from C:\Windows\CSC to C:\Users\Username.  This could take time.  **It's also a security risk leaving an unattended workstation, thats your call**
3.  Hopefully all thier files have migrated overnight and in the meantime a few gpupdates have ran behind the scene.  If the gpupdates have run then the Environmental Variable LocalFolders should have been updated to True as the user profile directories now exist.  You can check that on the computer by going to System Information > Software Environment > Environmental Variables.  If it's true have them log off and back on.
4.  Now you should be open to open OneDrive > More > Settings > Auto Save > Update Folders > Protect Folders.  If this is the first time they have used OneDrive on a Windows 7 or 8 machine it might prompt them to update.
