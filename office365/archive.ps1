# Enable Archive for all mailboxes
Get-RemoteMailbox -ResultSize Unlimited -Filter {(RecipientTypeDetails -eq 'RemoteUserMailbox')} | Enable-RemoteMailbox -Archive
