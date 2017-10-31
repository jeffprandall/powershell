Better for mirroring lots of files

    robocopy <source> <destination> /e /copyall /zb /mt:8 /log:FilesRobo.log /tee
    
Better for MOVING lots of files (Use this for annual archive)

    robocopy <source> <destination> /e /move /sec /mt:8 /log:FilesRobo.log /tee

Better for mirroring large files

    robocopy <source> <destination> /copyall /j

Check for files longer than 260 characters

    robocopy.exe <source> <destination> /l /e /b /np /fp /njh /njs /ndl | Where-Object {$_.Length -ge 286} | ForEach-Object {$_.Substring(26,$_.Length-26)} | Out-File F:\toolong.csv
