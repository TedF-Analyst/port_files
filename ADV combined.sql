/*
This file contains 5 scripts combined.  All used to clean up the various tables used in the project
*/


/*
**************************************
*/

-- Update tables to a more recent time frame.

-- Declare variables  
DECLARE @CurrentYear INT = year(getdate())
DECLARE @LastDayCurrentYear DATE = DATEADD(dd, - 1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, 0))
DECLARE @MaxDateInDW INT

SELECT @MaxDateInDW = MAX(year(orderdate))
FROM [dbo].[FactInternetSales]

DECLARE @YearsToAdd INT = @CurrentYear - @MaxDateInDW

IF (@YearsToAdd > 0)
BEGIN
	-- Delete leap year records (February 29th)
	DELETE
	FROM FactCurrencyRate
	WHERE month([Date]) = 2
		AND day([Date]) = 29

	DELETE
	FROM FactProductInventory
	WHERE month([MovementDate]) = 2
		AND day([MovementDate]) = 29

	-- Drop FKs
	ALTER TABLE FactCurrencyRate

	DROP CONSTRAINT FK_FactCurrencyRate_DimDate

	ALTER TABLE FactFinance

	DROP CONSTRAINT FK_FactFinance_DimDate

	ALTER TABLE FactInternetSales

	DROP CONSTRAINT FK_FactInternetSales_DimDate

	ALTER TABLE FactInternetSales

	DROP CONSTRAINT FK_FactInternetSales_DimDate1

	ALTER TABLE FactInternetSales

	DROP CONSTRAINT FK_FactInternetSales_DimDate2

	ALTER TABLE FactProductInventory

	DROP CONSTRAINT FK_FactProductInventory_DimDate

	ALTER TABLE FactResellerSales

	DROP CONSTRAINT FK_FactResellerSales_DimDate

	ALTER TABLE FactSurveyResponse

	DROP CONSTRAINT FK_FactSurveyResponse_DateKey

	--Populate the date dimension 
	
   DECLARE @startdate DATE = '2015-01-01' --change start date if required 
		,
		@enddate DATE = @LastDayCurrentYear --change end date if required 
	DECLARE @datelist TABLE (FullDate DATE)
		--recursive date query 
		;

	WITH dt_cte
	AS (
		SELECT @startdate AS FullDate
		
		UNION ALL
		
		SELECT DATEADD(DAY, 1, FullDate) AS FullDate
		FROM dt_cte
		WHERE dt_cte.FullDate < @enddate
		)
	INSERT INTO @datelist
	SELECT FullDate
	FROM dt_cte
	OPTION (MAXRECURSION 0)

	--Populate Date Dimension 
	SET DATEFIRST 7;-- Sets the first day of the week to Monday just to show how its done

	INSERT INTO [dbo].[dimdate] (
		[DateKey],
		[FullDateAlternateKey],
		[DayNumberOfWeek],
		[EnglishDayNameOfWeek],
		[SpanishDayNameOfWeek],
		[FrenchDayNameOfWeek],
		[DayNumberOfMonth],
		[DayNumberOfYear],
		[WeekNumberOfYear],
		[EnglishMonthName],
		[SpanishMonthName],
		[FrenchMonthName],
		[MonthNumberOfYear],
		[CalendarQuarter],
		[CalendarYear],
		[CalendarSemester],
		[FiscalQuarter],
		[FiscalYear],
		[FiscalSemester]
		)
	SELECT CONVERT(INT, CONVERT(VARCHAR, dl.FullDate, 112)) AS DateKey,
		dl.FullDate,
		DATEPART(dw, dl.FullDate) AS DayOfWeekNumber,
		DATENAME(weekday, dl.FullDate) AS DayOfWeekName,
		CASE DATENAME(weekday, dl.FullDate)
			WHEN 'Monday'
				THEN 'Lunes'
			WHEN 'Tuesday'
				THEN 'Martes'
			WHEN 'Wednesday'
				THEN 'Miércoles'
			WHEN 'Thursday'
				THEN 'Jueves'
			WHEN 'Friday'
				THEN 'Viernes'
			WHEN 'Saturday'
				THEN 'Sábado'
			WHEN 'Sunday'
				THEN 'Doming'
			END AS SpanishDayNameOfWeek,
		CASE DATENAME(weekday, dl.FullDate)
			WHEN 'Monday'
				THEN 'Lundi'
			WHEN 'Tuesday'
				THEN 'Mardi'
			WHEN 'Wednesday'
				THEN 'Mercredi'
			WHEN 'Thursday'
				THEN 'Jeudi'
			WHEN 'Friday'
				THEN 'Vendredi'
			WHEN 'Saturday'
				THEN 'Samedi'
			WHEN 'Sunday'
				THEN 'Dimanche'
			END AS SpanishDayNameOfWeek,
		DATEPART(d, dl.FullDate) AS DayOfMonthNumber,
		DATEPART(dy, dl.FullDate) AS DayOfYearNumber,
		DATEPART(wk, dl.FullDate) AS WeekOfYearNumber,
		DATENAME(MONTH, dl.FullDate) AS [MonthName],
		CASE DATENAME(MONTH, dl.FullDate)
			WHEN 'January'
				THEN 'Enero'
			WHEN 'February'
				THEN 'Febrero'
			WHEN 'March'
				THEN 'Marzo'
			WHEN 'April'
				THEN 'Abril'
			WHEN 'May'
				THEN 'Mayo'
			WHEN 'June'
				THEN 'Junio'
			WHEN 'July'
				THEN 'Julio'
			WHEN 'August'
				THEN 'Agosto'
			WHEN 'September'
				THEN 'Septiembre'
			WHEN 'October'
				THEN 'Octubre'
			WHEN 'November'
				THEN 'Noviembre'
			WHEN 'December'
				THEN 'Diciembre'
			END AS SpanishMonthName,
		CASE DATENAME(MONTH, dl.FullDate)
			WHEN 'January'
				THEN 'Janvier'
			WHEN 'February'
				THEN 'Février'
			WHEN 'March'
				THEN 'Mars'
			WHEN 'April'
				THEN 'Avril'
			WHEN 'May'
				THEN 'Mai'
			WHEN 'June'
				THEN 'Juin'
			WHEN 'July'
				THEN 'Juillet'
			WHEN 'August'
				THEN 'Août'
			WHEN 'September'
				THEN 'Septembre'
			WHEN 'October'
				THEN 'Octobre'
			WHEN 'November'
				THEN 'Novembre'
			WHEN 'December'
				THEN 'Décembre'
			END AS FrenchMonthName,
		MONTH(dl.FullDate) AS MonthNumber,
		DATEPART(qq, dl.FullDate) AS CalendarQuarter,
		YEAR(dl.FullDate) AS CalendarYear,
		CASE DATEPART(qq, dl.FullDate)
			WHEN 1
				THEN 1
			WHEN 2
				THEN 1
			WHEN 3
				THEN 2
			WHEN 4
				THEN 2
			END AS CalendarSemester,
		CASE DATEPART(qq, dl.FullDate)
			WHEN 1
				THEN 3
			WHEN 2
				THEN 4
			WHEN 3
				THEN 1
			WHEN 4
				THEN 2
			END AS FiscalQuarter,
		CASE DATEPART(qq, dl.FullDate)
			WHEN 1
				THEN YEAR(dl.FullDate) - 1
			WHEN 2
				THEN YEAR(dl.FullDate) - 1
			WHEN 3
				THEN YEAR(dl.FullDate)
			WHEN 4
				THEN YEAR(dl.FullDate)
			END AS FiscalYear,
		CASE DATEPART(qq, dl.FullDate)
			WHEN 1
				THEN 2
			WHEN 2
				THEN 2
			WHEN 3
				THEN 1
			WHEN 4
				THEN 1
			END AS FiscalSemester
	FROM @datelist dl
	LEFT JOIN [dbo].[dimdate] dt ON dt.FullDateAlternateKey = dl.FullDate
	WHERE dt.DateKey IS NULL
	ORDER BY DateKey DESC

	-- Date (data type: date) 
	-- Birth Date and Hire Date are not being updated 
	UPDATE DimCustomer
	SET DateFirstPurchase = CASE 
			WHEN DateFirstPurchase IS NOT NULL
				THEN dateadd(year, @YearsToAdd, DateFirstPurchase)
			END

	UPDATE DimEmployee
	SET StartDate = CASE 
			WHEN StartDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, StartDate)
			END

	UPDATE DimEmployee
	SET EndDate = CASE 
			WHEN EndDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, EndDate)
			END

	UPDATE DimProduct
	SET StartDate = CASE 
			WHEN StartDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, StartDate)
			END

	UPDATE DimProduct
	SET EndDate = CASE 
			WHEN EndDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, EndDate)
			END

	UPDATE DimPromotion
	SET StartDate = CASE 
			WHEN StartDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, StartDate)
			END

	UPDATE DimPromotion
	SET EndDate = CASE 
			WHEN EndDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, EndDate)
			END

	UPDATE FactCallCenter
	SET DATE = CASE 
			WHEN DATE IS NOT NULL
				THEN dateadd(year, @YearsToAdd, DATE)
			END

	UPDATE FactCurrencyRate
	SET DATE = CASE 
			WHEN DATE IS NOT NULL
				THEN dateadd(year, @YearsToAdd, DATE)
			END

	UPDATE FactFinance
	SET DATE = CASE 
			WHEN DATE IS NOT NULL
				THEN dateadd(year, @YearsToAdd, DATE)
			END

	UPDATE FactInternetSales
	SET OrderDate = CASE 
			WHEN OrderDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, OrderDate)
			END

	UPDATE FactInternetSales
	SET DueDate = CASE 
			WHEN DueDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, DueDate)
			END

	UPDATE FactInternetSales
	SET ShipDate = CASE 
			WHEN ShipDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, ShipDate)
			END

	UPDATE FactProductInventory
	SET MovementDate = CASE 
			WHEN MovementDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, MovementDate)
			END

	UPDATE FactResellerSales
	SET OrderDate = CASE 
			WHEN OrderDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, OrderDate)
			END

	UPDATE FactResellerSales
	SET DueDate = CASE 
			WHEN DueDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, DueDate)
			END

	UPDATE FactResellerSales
	SET ShipDate = CASE 
			WHEN ShipDate IS NOT NULL
				THEN dateadd(year, @YearsToAdd, ShipDate)
			END

	UPDATE FactSalesQuota
	SET DATE = CASE 
			WHEN DATE IS NOT NULL
				THEN dateadd(year, @YearsToAdd, DATE)
			END

	UPDATE FactSurveyResponse
	SET DATE = CASE 
			WHEN DATE IS NOT NULL
				THEN dateadd(year, @YearsToAdd, DATE)
			END

	-- DateKey (data type: int) 
	UPDATE FactCallCenter
	SET DateKey = CASE 
			WHEN DateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [Date], 112) AS INT)
			END

	UPDATE FactCurrencyRate
	SET DateKey = CASE 
			WHEN DateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [Date], 112) AS INT)
			END

	UPDATE FactFinance
	SET DateKey = CASE 
			WHEN DateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [Date], 112) AS INT)
			END

	UPDATE FactInternetSales
	SET DueDateKey = CASE 
			WHEN DueDateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [DueDate], 112) AS INT)
			END

	UPDATE FactInternetSales
	SET OrderDateKey = CASE 
			WHEN OrderDateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [OrderDate], 112) AS INT)
			END

	UPDATE FactInternetSales
	SET ShipDateKey = CASE 
			WHEN ShipDateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [ShipDate], 112) AS INT)
			END

	UPDATE FactProductInventory
	SET DateKey = CASE 
			WHEN DateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [MovementDate], 112) AS INT)
			END

	UPDATE FactResellerSales
	SET DueDateKey = CASE 
			WHEN DueDateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [ShipDate], 112) AS INT)
			END

	UPDATE FactResellerSales
	SET OrderDateKey = CASE 
			WHEN OrderDateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [ShipDate], 112) AS INT)
			END

	UPDATE FactResellerSales
	SET ShipDateKey = CASE 
			WHEN ShipDateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [ShipDate], 112) AS INT)
			END

	UPDATE FactSalesQuota
	SET DateKey = CASE 
			WHEN DateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [Date], 112) AS INT)
			END

	UPDATE FactSurveyResponse
	SET DateKey = CASE 
			WHEN DateKey IS NOT NULL
				THEN CAST(convert(VARCHAR, [Date], 112) AS INT)
			END

	-- Update tables where year is a number in the format YYYY 
	UPDATE FactSalesQuota
	SET CalendarYear = CASE 
			WHEN CalendarYear IS NOT NULL
				THEN @YearsToAdd + CalendarYear
			END

	UPDATE DimReseller
	SET FirstOrderYear = CASE 
			WHEN FirstOrderYear IS NOT NULL
				THEN @YearsToAdd + FirstOrderYear
			END

	UPDATE DimReseller
	SET LastOrderYear = CASE 
			WHEN LastOrderYear IS NOT NULL
				THEN @YearsToAdd + LastOrderYear
			END

	UPDATE DimReseller
	SET YearOpened = CASE 
			WHEN YearOpened IS NOT NULL
				THEN @YearsToAdd + YearOpened
			END

	-- Add back CONSTRAINTS into the tables
	ALTER TABLE [dbo].[FactCurrencyRate]
		WITH CHECK ADD CONSTRAINT [FK_FactCurrencyRate_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

	ALTER TABLE [dbo].[FactCurrencyRate] CHECK CONSTRAINT [FK_FactCurrencyRate_DimDate]

	ALTER TABLE [dbo].[FactFinance]
		WITH CHECK ADD CONSTRAINT [FK_FactFinance_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

	ALTER TABLE [dbo].[FactFinance] CHECK CONSTRAINT [FK_FactFinance_DimDate]

	ALTER TABLE [dbo].[FactInternetSales]
		WITH CHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate] FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

	ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate]

	ALTER TABLE [dbo].[FactInternetSales]
		WITH CHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate1] FOREIGN KEY ([DueDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

	ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate1]

	ALTER TABLE [dbo].[FactInternetSales]
		WITH CHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate2] FOREIGN KEY ([ShipDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

	ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate2]

	ALTER TABLE [dbo].[FactProductInventory]
		WITH CHECK ADD CONSTRAINT [FK_FactProductInventory_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

	ALTER TABLE [dbo].[FactProductInventory] CHECK CONSTRAINT [FK_FactProductInventory_DimDate]

	ALTER TABLE [dbo].[FactResellerSales]
		WITH CHECK ADD CONSTRAINT [FK_FactResellerSales_DimDate] FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

	ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimDate]

	ALTER TABLE [dbo].[FactSurveyResponse]
		WITH CHECK ADD CONSTRAINT [FK_FactSurveyResponse_DateKey] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

	ALTER TABLE [dbo].[FactSurveyResponse] CHECK CONSTRAINT [FK_FactSurveyResponse_DateKey]
END



/*
**************************************
*/



-- This was used to pull the relevent information from the Internet Sales fact table and exported to CSV

USE AdventureWorksDW2019
SELECT
	[ProductKey],
	[OrderDateKey],
	[DueDateKey],
	[ShipDateKey],
	[CustomerKey],
	[SalesOrderNumber],
	[SalesAmount]
FROM
	[dbo].[FactInternetSales]
WHERE
	LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -2 -- Ensures we always only bring two years of the date from extraction
ORDER BY
	OrderDateKey ASC



/*
**************************************
*/



-- Clean up DIM_DateTable and export to CSV

SELECT 
	[DateKey],
	[FullDateAlternateKey] AS Date,
	[EnglishDayNameOfWeek] AS Day,
	[EnglishMonthName] AS Month,
	LEFT([EnglishMonthName], 3) AS MonthShort,
	[MonthNumberOfYear] AS MonthNo,
	[CalendarQuarter] AS Quarter,
	[CalendarYear] AS Year
FROM 
	AdventureWorksDW2019..DimDate
WHERE 
	CalendarYear >= 2019



/*
**************************************
*/



-- Clean up DIM_Customers
-- c. from Customers, g. from Geography
-- Join to bring in the Customers City
SELECT
	c.customerkey AS CustomerKey,
	c.firstname AS [First Name],
	c.lastname AS [Last Name],
	c.firstname + ' ' + lastname AS [Full Name],
CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
	c.datefirstpurchase AS DateFirstPurchase,
	g.city AS [Customer City]
FROM
	dbo.DimCustomer AS c
	LEFT JOIN dbo.DimGeography AS g ON g.GeographyKey = c.GeographyKey
ORDER BY
	CustomerKey ASC



/*
**************************************
*/



-- Clean up DIM_Products table
-- Turns NULL records into 'Outdated'
USE AdventureWorksDW2019
SELECT
	p.[ProductKey],
	p.[ProductAlternateKey] AS ProdItemCode,
	p.[EnglishProductName] AS [Product Name],
	pc.EnglishProductCategoryName AS [Product Category], -- Joined in from Product Category table
	ps.EnglishProductSubcategoryName AS [Sub Category], -- Joined in from Product Subcategory table
	p.[Color] AS [Product Color],
	p.[Size] AS [Product Size],
	p.[ProductLine] as [Product Line],
	p.[ModelName] AS [Product Model Name],
	p.[EnglishDescription] AS [Product Description],
ISNULL (p.Status, 'Outdated') AS [Product Status]
FROM
	[dbo].[DimProduct] as p
	LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
	LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY
	p.ProductKey ASC



/*
**************************************
*/