#### Log into Office365 via Exchange Management Shell
    $UserCredential = Get-Credential 
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection 
    Import-PSSession $Session 

#### Enable Clutter for one user
    Set-Clutter -Identity “Allie Bellew” -Enable $true

#### Disable Clutter for one user
    Set-Clutter -Identity “Allie Bellew” -Enable $false

#### [Enable Clutter for a specific set of users](https://community.spiceworks.com/how_to/128158-how-to-turn-off-clutter-for-office-365-user-all-users)

    $cluttermailbox = Get-RemoteMailbox | Out-GridView -PassThru 
    Get-Clutter -Identity $cluttermailbox.UserPrincipalName | Out-GridView 
    Set-Clutter -Identity $cluttermailbox.UserPrincipalName -Enable $false 
    Get-Clutter -Identity $cluttermailbox.UserPrincipalName |fl

#### Enable/Disable for all users
    Get-RemoteMailbox -ResultSize Unlimited | Set-Clutter -Enable $False | Out-Gridview (for some reason this does not work for me but it's the one all over web)
    Get-RemoteMailbox -ResultSize Unlimited | Foreach-Object { Set-Clutter -Identity $_.UserPrincipalName -Enable $true }
