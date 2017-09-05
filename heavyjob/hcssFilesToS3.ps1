#Check if previous instance is still running
$Processes = Get-WMIObject -Class Win32_Process -Filter "Name='PowerShell.EXE'" | Where {$_.CommandLine -Like "*HCSSFilesToS3*"}
if ($Processes -ne $null) {
    Write-EventLog -LogName Application -Source "HCSStoS3" -EntryType Information -EventId 1 -Message "Previous task still running"
    exit
}

Get-AWSCredential -ListProfileDetail
# Install AWS PowerShell - http://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up.html
# Install-Package -Name AWSPowerShell

# Import AWS PowerShell Modules
Import-Module AWSPowerShell

# Auth Keys
$AccessKey = '<your aws access key>'
$SecretKey = '<your aws secret key>'
$hcssCredentials = 'hcssCredentials'

# Set your AWS Credentials
$awsCredentials = Get-AWSCredential -ListProfileDetail | Where-Object {$_.ProfileName -eq $hcssCredentials}
if (! $awsCredentials ) {
    Set-AWSCredential -AccessKey $AccessKey -SecretKey $SecretKey -StoreAs $hcssCredentials
}

# Default Region
$region = 'us-west-2'

# Default Bucket
$bucket = 'heavyjob'

# Location of local HeavyJob Job files/repo
$fileLocation = '\\Heavyjob\HeavyJob\MGRJOBS\'

# Email settings
$smtpserver = '<your email server name/ip>'
$from = 'heavyjobs@<your domain>'
$to = 'itsupport@<your domain>'
$subject = "Error uploading HeavyJob files into AWS/S3"

# Logging
$hcssLogFileExists = [System.Diagnostics.EventLog]::SourceExists("HCSStoS3")
if ( ! $hcssLogFileExists) {
    New-EventLog -LogName Application -Source "HCSStoS3"
}

# Iterate over each HeavyJob repo
$files = Get-ChildItem -Path $fileLocation -Recurse -Include *.xls, *.pdf, *.jpg | Where-Object {$_.BaseName -ne "SupDoc" -or "MGRJOBS"}

ForEach($file in $files) {
    
    # Set the job name
    $jobName = $file.Directory.Parent.Name
    $keyName = $jobName + '/' + $file.Name

    # Check if the file exists
    if(!(Get-S3Object -BucketName $bucket -Key $keyName -ProfileName $hcssCredentials )) {
        
        # Create the file
        Write-Host Saving the $keyName to AWS -ForegroundColor Yellow
            Try {
                Write-S3Object -BucketName $bucket -Key $keyName -File $file
                Write-EventLog -LogName Application -Source "HCSStoS3" -EntryType Information -EventId 1 -Message "Successfully uploaded $jobName - $file "
            }
            Catch {
                Write-Host $Error
                Write-EventLog -LogName Application -Source "HCSStoS3" -EntryType Error -EventId 1 -Message $Error
                Send-MailMessage -From $from -To $to -Subject $subject -Body $Error
                Break
            }
            Finally { Write-Host $keyName saved successfully to AWS -ForegroundColor Green }
    } else {
        Write-Host $keyName is already in S3 -ForegroundColor Cyan
    }
}
