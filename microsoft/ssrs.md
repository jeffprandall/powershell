Get the year difference between two date

    =DateDiff("yyyy", Fields!DateOfHire.Value, Today())
    
Get the start and end date of last business week

    =DateAdd(DateInterval.Day, 2-Weekday(TODAY), DateAdd(DateInterval.Day, -7, Today))
    =DateAdd(DateInterval.Day, 1-WeekDay(Today),Today)
    
[Cheatsheet](https://pragmaticworks.com/portfolio/ssrs-expressions-cheat-sheet/)
