CREATE VIEW [dbo].[_rec_daily_logs] AS

SELECT
	D.JOBCODE,
	JOB.NAME,
	D.DATE,
	D.FOREMAN,
	D.WEATHER1,
	D.NOTE,
	JOB.FULL_PATH
FROM DIARY AS D
INNER JOIN JOBGUIDE AS JOB ON JOB.JOB# = D.JOBCODE
INNER JOIN (SELECT JOBCODE, DATE, FOREMAN, MAX(REVNUM) AS REVNUM
			FROM DIARY
			GROUP BY JOBCODE, DATE, FOREMAN) AS G ON D.JOBCODE = G.JOBCODE AND D.DATE = G.DATE AND D.FOREMAN = G.FOREMAN AND D.REVNUM = G.REVNUM

WHERE (D.WEATHER1 <> '' OR D.NOTE NOT LIKE ('%Attached Images%'))

GO

CREATE view [dbo].[_rec_daily_images] AS
SELECT
  JOB,
  DATE,
  FOREMAN,
  RIGHT(FILENAME, 3) AS Extension,
  CASE RIGHT(FILENAME, 3)
	WHEN 'jpg' THEN ('file://///heavyjob\HeavyJob\MGRJOBS\' + JOB + '\SupDoc\' + FILENAME)
  END AS ImageLocation,
  CASE RIGHT(FILENAME, 3)
	WHEN 'jpg' THEN COMMENTS
  END AS ImageComments,
  'https://s3-us-west-2.amazonaws.com/heavyjob/' + JOB + '/' + FILENAME AS Link,
  (Row_Number() over (partition by JOB, DATE, RIGHT(FILENAME, 3) order by FILENAME)) As SortOrder

FROM IMAGDOCS

WHERE RIGHT(FILENAME,3) = 'jpg'

CREATE view [dbo].[_rec_joblist] AS
SELECT 
  JOB# AS JOB_NUMBER,
  CONCAT(JOB#, ' - ', NAME) AS JOB_NAME

FROM JOBGUIDE J

JOIN (
  SELECT JOBCODE, COUNT(*) AS entries
  FROM DIARY
  GROUP BY JOBCODE
) D ON J.JOB# = D.JOBCODE

GO

CREATE view [dbo].[_rec_daily_attachments] AS
SELECT
  JOB,
  DATE,
  convert(varchar(10), date, 101) as short_date,
  FOREMAN,
  RIGHT(FILENAME, 3) AS Extension,
  'https://s3-us-west-2.amazonaws.com/heavyjob/' + JOB + '/' + FILENAME AS Link,
  COMMENTS,
  (Row_Number() over (partition by JOB, DATE, RIGHT(FILENAME, 3) order by FILENAME)) As SortOrder
  
FROM IMAGDOCS

WHERE RIGHT(FILENAME,3) <> 'jpg' AND COMMENTS <> ''
