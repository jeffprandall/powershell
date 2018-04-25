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
    # Enables only for users who have Clutter $false
    $AllMailboxes = Get-MailBox -Filter '(RecipientTypeDetails -eq "UserMailbox")' | Where-Object {(Get-Clutter -Identity $_.UserPrincipalName).IsEnabled -eq $False}
    ForEach ($Mailbox in $AllMailboxes) { Set-Clutter -Identity $Mailbox.UserPrincipalName -Enable $True }

    # OR Force for all users
    Get-Mailbox -ResultSize Unlimited | Set-Clutter -Enable $True
