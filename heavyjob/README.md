[HCSS to S3](https://github.com/jeffprandall/randoms/blob/master/heavyjob/hcssWriteToS3.ps1)

Copies local images and pdf files stored on a local HeavyJob server to Amazon S3.  You can then use the SSRS templates (or Crystal reports) to create a report with image/file links that are accessible external to your network.

You will need to adjust lines 32 and 62 in the SQL views to match your region and bucket name.

Create a Scheduled task to run this script how ever often you like.

`powershell.exe -ExecutionPolicy Bypass -File C:\scripts\hcssFilesToS3.ps1`
