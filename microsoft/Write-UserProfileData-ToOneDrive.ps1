# Get current user variables
$currentUser = $env:UserName
$desktop = [Environment]::GetFolderPath("Desktop")
$documents = [Environment]::GetFolderPath("MyDocuments")
$pictures = [Environment]::GetFolderPath("MyPictures")

# Business OneDrive Settings
$odName = 'OneDrive - Royal Electric'

Function Copy-WithProgress
  {
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory=$true,
                 ValueFromPipelineByPropertyName=$true,
                 Position=0)]
       $Source,
       [Parameter(Mandatory=$true,
                  ValueFromPipelineByPropertyName=$true,
                  Position=0)]
       $Destination
        
  )
  $Source=$Source.tolower()

  $Filelist=get-childitem -path $source -Recurse
  $Total=$Filelist.count
  $Position=0
    foreach ($File in $Filelist)
      { 
        $Filename=$File.Fullname.tolower().replace($Source,'') 
        $DestinationFile=($Destination+$Filename).replace('\\','\')
        Write-Progress -Activity "Copying data from $source to $Destination" -Status "Moving Files" -PercentComplete (($Position/$total)*100)
        Copy-Item -path $File.FullName -Destination $DestinationFile -Recurse -Force
        $File.Fullname
        $DestinationFile
        $Position++
      }
}

# Backup Desktop data
Write-Host 'Backing up Desktop files' -ForegroundColor Yellow
$odDesktop = "C:\users\$currentUser\$odName\Desktop"

if(!(Test-Path -Path $odDesktop)) {
  md $odDesktop
}

Try {
  Copy-WithProgress $desktop -Destination $odDesktop
} Catch {
  $err = $ErrorMessage = $_.Exception.Message
  Write-Host $err -ForegroundColor Red
}

# Backup My Documents data
Write-Host 'Backing up My Documents files' -ForegroundColor Yellow
$odDocuments = "C:\users\$currentUser\$odName\Documents"

if(!(Test-Path -Path $odDocuments)) {
  md $odDocuments
}

Try {
  Copy-WithProgress $documents -Destination $odDocuments
} Catch {
  $err = $ErrorMessage = $_.Exception.Message
  Write-Host $err -ForegroundColor Red
}

# Backup IE Favorites data
Write-Host 'Backing up IE Favorites files' -ForegroundColor Yellow
$odFavorites = "C:\users\$currentUser\$odName\Favorites"

if(!(Test-Path -Path $odFavorites)) {
  md $odFavorites
}

Try {
  Copy-WithProgress $favorites -Destination $odFavorites
} Catch {
  $err = $ErrorMessage = $_.Exception.Message
  Write-Host $err -ForegroundColor Red
}

# Backup My Pictures data
Write-Host 'Backing up Pictures files' -ForegroundColor Yellow
$odPictures = "C:\users\$currentUser\$odName\Pictures"

if(!(Test-Path -Path $odPictures)) {
  md $odPictures
}

Try {
  Copy-WithProgress $Pictures -Destination $odPictures
} Catch {
  $err = $ErrorMessage = $_.Exception.Message
  Write-Host $err -ForegroundColor Red
}

# Backup Chrome bookmarks if user doesn't have a gmail account
Write-Host 'Backing up Chrome bookmarks' -ForegroundColor Yellow
if((Test-Path -Path "C:\Users\$currentUser\appdata\local\Google\Chrome\User Data\Default\bookmarks*")) {
  $odChrome = "C:\users\$currentUser\$odName\Backups\Chrome"

  if(!(Test-Path -Path $odChrome)) {
    md $odChrome
  }

  Try {
    Copy-WithProgress "C:\Users\$currentUser\appdata\local\Google\Chrome\User Data\Default\bookmarks*" -Destination "C:\Users\$currentUser\OneDrive - Royal Electric\Backups\Chrome"
    Write-Host 'Successfully backed up Chrome bookmarks' -ForegroundColor Green
  } Catch {
    $err = $ErrorMessage = $_.Exception.Message
    Write-Host $err -ForegroundColor Red
  }
} else {
  Write-Host 'No Chrome data to backup'
}

# Backup Firefox data if user doesn't have an account
Write-Host 'Backing up Firefox bookmarks' -ForegroundColor Yellow
if((Test-Path -Path "C:\Users\$currentUser\AppData\Roaming\Mozilla\Firefox\Profiles")) {
  $odFirefox = "C:\users\$currentUser\$odName\Backups\Firefox"


  if(!(Test-Path -Path $odFirefox)) {
    md $odFirefox
  }

  Try {
    Copy-WithProgress "C:\Users\$currentUser\AppData\Roaming\Mozilla\Firefox\Profiles" -Destination "C:\Users\$currentUser\OneDrive - Royal Electric\Backups\Firefox"
    Write-Host 'Successfully backed up Firefox bookmarks' -ForegroundColor Green
  } Catch {
    $err = $ErrorMessage = $_.Exception.Message
    Write-Host $err -ForegroundColor Red
  }
} else {
  Write-Host 'No Firefox data to backup'
}

# Backup Outlook signatures
Write-Host 'Backing up Outlook Signature' -ForegroundColor Yellow
$odOutlook = "C:\users\$currentUser\$odName\Backups\Outlook"

if(!(Test-Path -Path $odOutlook)) {
  md $odOutlook
}
Try {
  Copy-WithProgress "C:\Users\$currentUser\AppData\Roaming\Microsoft\Signatures" -Destination "C:\Users\$currentUser\OneDrive - Royal Electric\Backups\Outlook"
  Write-Host 'Successfully backed up Outlook signatures' -ForegroundColor Green
} Catch {
  $err = $ErrorMessage = $_.Exception.Message
  Write-Host $err -ForegroundColor Red
}

Read-Host -Prompt "Done - press Enter to exit"
