Check for filepath longer than 260 characters.  Adjust the value to also accomidate for other locations path if you plan on migrating data.  For example \\fileserver\archive\ would be 21 characters so 260 - 21 = 239 should be your -gt value.

    ps# cmd /c dir /s /b | ? {$_.length -gt 247} | Out-File toolong.csv

Better for mirroring lots of files

    robocopy <source> <destination> /e /copyall /zb /mt:8 /log:FilesRobo.log /tee
    
Better for MOVING lots of files (Use this for annual archive)

    robocopy <source> <destination> /e /move /sec /mt:8 /log:FilesRobo.log /tee

Better for mirroring large files

    robocopy <source> <destination> /copyall /j
