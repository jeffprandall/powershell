ENABLE REMOTEREGISTRY FIRST

Remotely start a service

    PS> Get-Service -Name <service name>  -ComputerName <computer name> | Start-service 
    
See who is logged onto a remote computer

    psloggedon.exe \\<computer name or IP address>

Add a domain user to local admin group
  
    psexec \\ComputerName net localgroup Administrators "DomainName\UserName" /add
