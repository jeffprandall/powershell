[HCSS to S3](https://github.com/jeffprandall/randoms/blob/master/heavyjob/hcssWriteToS3.ps1)

Copies local images and pdf files stored on a local HeavyJob server to Amazon S3.  You can then use something SSRS or Crystal reports and send links to access the files external to your network.

Create a Scheduled task to run this script how ever often you like.

`powershell.exe -ExecutionPolicy Bypass -File C:\scripts\hcssFilesToS3.ps1`
