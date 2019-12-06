Get the year difference between two date

    =DateDiff("yyyy", Fields!DateOfHire.Value, Today())
    
Get the start and end date of last business week

    =DateAdd(DateInterval.Day, 2-Weekday(TODAY), DateAdd(DateInterval.Day, -7, Today))
    =DateAdd(DateInterval.Day, 1-WeekDay(Today),Today)

Get the start date of previous month if falls on week end
    
    =IIF(
        DateInterval.Weekday <= 7,
        Dateadd("m",-1,dateserial(year(Today),month(Today),1)),
        DateAdd("d",-(Day(today)-1), Today)
     )
 
 Get the last date of previous month if falls on week end
 
    =IIF(
	    DateInterval.Weekday <= 7,
	    Dateadd("m",0,dateserial(year(Today),month(Today),0)),
	    Today
    )
    
[Cheatsheet](https://pragmaticworks.com/portfolio/ssrs-expressions-cheat-sheet/)
