**Update** - 
Using [HCSS to S3](https://github.com/jeffprandall/randoms/blob/master/heavyjob/hcssWriteToS3.ps1) is not needed anymore (unless you want to).  We can reference the files directly that HeavyJob stores in Azure by getting your client id and linking to the images.  

  

1. Log into [HCSS Credentials](http://hcssapps.com)
2. Reports > HeavyJob Data > Event Data
3. Search for any entry that with an Event Type of Diary/Photo
4. Click on XML Data
5. If there is an associated image/pdf associated you will something like this
```<UserPicture>
	<FileName>
		~|https://hcssuseruploads2.blob.core.windows.net/<your client id>/20161018140508_photo-1476824698-2.jpg|~
	</FileName>...
```
6. Replace `<your id here>` with that client id on lines 34 and 64 in [sql_views](https://github.com/jeffprandall/randoms/blob/master/heavyjob/sql_views.sql)
7. Then in the [Daily Logs by Job](https://github.com/jeffprandall/randoms/blob/master/heavyjob/daily_logs_by_job.rdl) update the Action > Selection URL on the Image Object to pull from [AzureLink] 
8. Then in the [Weekly Logs by Job](https://github.com/jeffprandall/randoms/blob/master/heavyjob/weekly_logs_by_job.rdl) update the Action > Selection URL on the Image Object to pull from [AzureLink] 



----------

***OLD - not really needed anymore***

[HCSS to S3](https://github.com/jeffprandall/randoms/blob/master/heavyjob/hcssWriteToS3.ps1)

Copies local images and pdf files stored on a local HeavyJob server to Amazon S3.  You can then use the SSRS templates (or Crystal reports) to create a report with image/file links that are accessible external to your network.

You will need to adjust lines 32 and 62 in the SQL views to match your region and bucket name.


Create a Scheduled task to run this script how ever often you like.

`powershell.exe -ExecutionPolicy Bypass -File C:\scripts\hcssFilesToS3.ps1`
