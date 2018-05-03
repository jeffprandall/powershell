Connect to Office365 via Powershell first with this command

    $UserCredential = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection 
    Import-PSSession $Session 
    
Use this at the end of script to close the session

    Remove-PSSession $Session
