$currentUser = $env:UserName
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

Try {
  Set-ItemProperty -Path $registryPath -Name Desktop -Value "C:\Users\$currentUser\Desktop"
  Write-Host 'Successfully changed the Desktop settings' -ForegroundColor Green
} catch {
  $err = $ErrorMessage = $_.Exception.Message
  Write-Host $err -ForegroundColor Red
}

Try {
  Set-ItemProperty -Path $registryPath -Name Personal -Value "C:\Users\$currentUser\Documents"
  Write-Host 'Successfully changed the My Documents settings' -ForegroundColor Green
} catch {
  $err = $ErrorMessage = $_.Exception.Message
  Write-Host $err -ForegroundColor Red
}

Read-Host -Prompt "Done - press Enter to exit"
