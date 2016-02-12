
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/


CREATE PROCEDURE [dwh].[update_data_budget_encounter]  as

begin
--Create a time table of working days for fiscal year 2015-16
   DECLARE @build_dt_start VARCHAR(8) ,
    @build_dt_end VARCHAR(8) ,
    @build_counter INT ,
    @cur_month VARCHAR(3) ,
    @pk_month DATE;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   SET @build_dt_start = '20150701';
   SET @build_dt_end = '20160630';

   IF OBJECT_ID('tempdb..#WorkingDays') IS NOT NULL
    DROP TABLE #WorkingDays;



   SELECT   ROW_NUMBER() OVER ( PARTITION BY dt.Month ORDER BY dt.Day_Of_Month ASC ) AS workday_of_month ,
            dt.*
   INTO     #WorkingDays
   FROM     dwh.data_time dt
            INNER JOIN ( SELECT PK_date
                         FROM   dwh.data_time
                         WHERE  PK_date >= CAST(@build_dt_start AS DATE)
                                AND PK_date <= CAST(@build_dt_end AS DATE)
                                AND Day_Of_Week NOT IN ( 7, 1 )
                         EXCEPT
                         SELECT *
                         FROM   etl.data_hr_holidays
                       ) dw ON dt.PK_date = dw.PK_date;

   IF OBJECT_ID('tempdb..#Numb') IS NOT NULL
    DROP TABLE #Numb;


--Create a Tally table


   CREATE TABLE #Numb ( n [INT] PRIMARY KEY );
   INSERT   INTO #Numb
            ( n
            )
            SELECT 
                    ROW_NUMBER() OVER ( ORDER BY ( SELECT   0
                                                 ) )
            FROM    sys.all_columns;


   DECLARE @ids TABLE
    (
      idx INT IDENTITY(1, 1) ,
      month_name VARCHAR(3) ,
      date_month DATE
    );


   IF OBJECT_ID('dwh.data_budget_encounter') IS NOT NULL
    DROP TABLE dwh.data_budget_encounter;
   
   IF OBJECT_ID('tempdb..#budget_enc') IS NOT NULL
    DROP TABLE #budget_enc;
   
   
   CREATE TABLE #budget_enc
    (
      payor VARCHAR(50) ,
      [Site Code] VARCHAR(50) ,
      [ActualLocalDateKey] DATE ,
      enc INT
    );



   SET @build_counter = 0;
   WHILE @build_counter <= 11
    BEGIN
        INSERT  INTO @ids
                ( month_name ,
                  date_month
                )
                SELECT  UPPER(CONVERT(VARCHAR(3), DATEADD(MONTH, @build_counter, CAST(@build_dt_start AS DATE)), 0)) ,
                        CAST(CONVERT(VARCHAR(6), DATEADD(MONTH, @build_counter, CAST(@build_dt_start AS DATE)), 112)
                        + '01' AS DATE);
   
        SELECT  @build_counter = @build_counter + 1;
    END;
 
   DECLARE @i INT;
   DECLARE @cnt INT;

   SELECT   @i = MIN(idx) - 1 ,
            @cnt = MAX(idx)
   FROM     @ids;

   WHILE @i < @cnt
    BEGIN
        SELECT  @i = @i + 1;

        SELECT  @cur_month = month_name ,
                @pk_month = date_month
        FROM    @ids
        WHERE   idx = @i;

--Get budget Data and merge onto working days

      
   IF OBJECT_ID('tempdb..#MonthlyItems') IS NOT NULL
       DROP TABLE #MonthlyItems;

  
		  
		  
        SELECT  r.[Payor] ,
                r.[Site Code] ,
                CASE WHEN @cur_month = 'JAN' THEN r.[JAN]
                     WHEN @cur_month = 'FEB' THEN r.[FEB]
                     WHEN @cur_month = 'MAR' THEN r.[MAR]
                     WHEN @cur_month = 'APR' THEN r.[APR]
                     WHEN @cur_month = 'MAY' THEN r.[MAY]
                     WHEN @cur_month = 'JUN' THEN r.[JUN]
                     WHEN @cur_month = 'JUL' THEN r.[JUL]
                     WHEN @cur_month = 'AUG' THEN r.[AUG]
                     WHEN @cur_month = 'SEP' THEN r.[SEP]
                     WHEN @cur_month = 'OCT' THEN r.[OCT]
                     WHEN @cur_month = 'NOV' THEN r.[NOV]
                     WHEN @cur_month = 'DEC' THEN r.[DEC]
                END AS [MonthlyOccurrences]
        INTO    #MonthlyItems
        FROM    [Prod_Ghost].[etl].[data_budget_encounter] r;
  


     IF OBJECT_ID('tempdb..#MonthlyEncWithTileSize') IS NOT NULL
        DROP TABLE #MonthlyEncWithTileSize;
       
        SELECT  m.[Payor] ,
                m.[Site Code] ,
                d.PK_date AS [ActualLocalDateKey] ,
                1. * m.[MonthlyOccurrences] / ( SELECT TOP ( 1 )
                                                        workday_of_month
                                                FROM    #WorkingDays
                                                WHERE   Month = d.Month
                                                ORDER BY [PK_date] DESC
                                              ) AS [TileSize] ,
                a.n AS [RowNumber]
        INTO    #MonthlyEncWithTileSize
        FROM    #MonthlyItems m
                CROSS APPLY ( SELECT TOP 1
                                        d1.PK_date ,
                                        d1.Month ,
                                        d1.first_mon_date
                              FROM      #WorkingDays d1
                              WHERE     d1.first_mon_date = CAST(@pk_month AS DATE)
                              ORDER BY  d1.PK_date ASC
                            ) d
                CROSS APPLY ( SELECT    *
                              FROM      #Numb n
                              WHERE     n.n <= m.[MonthlyOccurrences]
                            ) a;

        INSERT  INTO #budget_enc
                ( payor ,
                  [Site Code] ,
                  ActualLocalDateKey ,
                  enc
                )
                SELECT  e.payor AS payer ,
                        e.[Site Code] AS [Site Code] ,
                        ( SELECT TOP 1
                                    PK_date
                          FROM      #WorkingDays wd
                          WHERE     wd.workday_of_month = CAST(( e.[RowNumber] - 1 ) / e.[TileSize] + 1 AS INT)
                                    AND wd.first_mon_date = CAST(@pk_month AS DATE)
                        ) AS [ActualLocalDateKey] ,
                        1 AS enc
                FROM    #MonthlyEncWithTileSize e;



    END;

	     IF OBJECT_ID('tempdb..#budget_enc2') IS NOT NULL
        DROP TABLE #budget_enc2;
       
	SELECT  [payor]
      ,dl.location_key
	  ,[Site Code]
      ,[ActualLocalDateKey]
      ,[enc]
	  
  
  INTO #budget_enc2
  FROM  #budget_enc be
  LEFT JOIN dwh.data_location dl ON be.[Site Code] = dl.[site_id] AND  dl.location_id_unique_flag = 1




     IF OBJECT_ID('[Prod_Ghost].[dwh].[data_budget_encounter]') IS NOT NULL
        DROP TABLE [Prod_Ghost].[dwh].[data_budget_encounter];
       

SELECT IDENTITY( INT, 1, 1 )  AS budget_enc_key , payor, [site code], location_key, [ActualLocalDateKey], SUM(enc) AS enc 

INTO [Prod_Ghost].[dwh].[data_budget_encounter]
FROM #budget_enc2 GROUP BY payor, [site code],location_key, [ActualLocalDateKey]



--SELECT  [site code], payor, DATEPART(MONTH, [ActualLocalDateKey]) AS  months, SUM(enc) AS enc FROM #temp GROUP BY  [site code], payor, DATEPART(MONTH, [ActualLocalDateKey]) ORDER BY [site code],  DATEPART(MONTH, [ActualLocalDateKey]), payor

end



GO
