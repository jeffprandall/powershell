# Disable Skype for all licensed users
# https://docs.microsoft.com/en-us/office365/enterprise/powershell/disable-access-to-services-while-assigning-user-licenses

# Install modules
Install-Module MSOnline

# Log into Office365
$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential

# Location of CSV Import
$inFileName="C:\Users\<USERNAME>\Downloads\ExportData.csv"
$outFileName="C:\Users\<USERNAME>\Downloads\ExportData-Results.csv"
$accountSkuId="<DOMAINNAME>:ENTERPRISEPACK"
$planList=@( "MCOSTANDARD" )
$users=Import-Csv $inFileName
$licenseOptions=New-MsolLicenseOptions -AccountSkuId $accountSkuId -DisabledPlans $planList

ForEach ($user in $users)
{
  $user.Userprincipalname
  $upn=$user.UserPrincipalName
  $usageLocation=$user.UsageLocation
  Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $AccountSkuId -ErrorAction SilentlyContinue
  sleep -Seconds 5
  Set-MsolUserLicense -UserPrincipalName $upn -LicenseOptions $licenseOptions -ErrorAction SilentlyContinue
  Set-MsolUser -UserPrincipalName $upn -UsageLocation $usageLocation
  $users | Get-MsolUser | Select UserPrincipalName, Islicensed,Usagelocation | Export-Csv $outFileName
}
