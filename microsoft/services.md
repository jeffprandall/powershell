I was needing to verify a specific account we had marked as a "Service" account was not being used on any of our Windows Servers.  It dumps the results to the results.csv file which you can then filter accordingly.

Enable WMI first on all the servers you wish to query (here's a quickie but might not be the most secure) 

`netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes profile=Domain`

    $servers = Get-ADComputer -Filter * -SearchBase "OU=Member Servers, DC=domain, DC=com"

    foreach($server in $servers) {
        $services = Get-WmiObject win32_service -Impersonation 3 -ComputerName $server.DNSHostName | Select-Object -Property PSComputerName, DisplayName, StartType, Status, StartName, State | export-csv -Append services.csv
        Write-Host "-----------"
        Write-Host Getting services for $server.DNSHostName
        Try {
            $services
        } Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Host Failed to create $server.DNSHostname -- $ErrorMessage -ForegroundColor Red
            Exit
        }
    }
