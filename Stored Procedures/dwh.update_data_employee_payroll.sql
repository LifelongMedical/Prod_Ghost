SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_employee_payroll]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF OBJECT_ID('dwh.data_employee_payroll') IS NOT NULL
            DROP TABLE dwh.data_employee_payroll;





        SELECT  
--Important Keys
             

			CASE WHEN  COALESCE([Period Beginning Date],'') = '' THEN DATEADD(d,-13,[Period End Date - Check])
			ELSE [Period Beginning Date] END AS [Period Beginning Date],
			
			    [Period End Date - Check] , -- It appears that the earliest date available for analysis is 2012-08-05
                [Pay Date],
				[File Number] ,
      
	  -- Need to change code based on assigned site in allocation to get gross dollars by site
	  -- Probably need to use multiplier for Facts so that distribution makes sense by site
                [Location] ,
                [Location Code] ,
                [Home Cost Number - Check] ,
                [Home Cost Number Desc - Check] ,
                [Home Department - Check] ,
                [Home Department Desc - Check] ,
                [Cost Number Worked In] ,
                [Cost Number Worked In Desc] ,
                [Home Department] ,
                SUBSTRING([Cost Number Worked In], 1, CASE CHARINDEX('-', [Cost Number Worked In])
                                                        WHEN 0 THEN LEN([Cost Number Worked In])
                                                        ELSE CHARINDEX('-', [Cost Number Worked In]) - 1
                                                      END) AS cn_account_code ,
                SUBSTRING([Cost Number Worked In], 1, 2) AS cn_account_code_sub ,
                SUBSTRING([Cost Number Worked In], CASE CHARINDEX('-', [Cost Number Worked In])
                                                     WHEN 0 THEN LEN([Cost Number Worked In]) + 1
                                                     ELSE CHARINDEX('-', [Cost Number Worked In]) + 1
                                                   END, 3) AS cn_site ,
                SUBSTRING([Cost Number Worked In], CASE CHARINDEX('-', [Cost Number Worked In], 7)
                                                     WHEN 0 THEN LEN([Cost Number Worked In]) + 1
                                                     ELSE CHARINDEX('-', [Cost Number Worked In], 7) + 1
                                                   END, 2) AS cn_fund ,
                SUBSTRING([Cost Number Worked In], CASE CHARINDEX('-', [Cost Number Worked In], 11)
                                                     WHEN 0 THEN LEN([Cost Number Worked In]) + 1
                                                     ELSE CHARINDEX('-', [Cost Number Worked In], 11) + 1
                                                   END, 1) AS cn_dir_indir ,
                SUBSTRING([Cost Number Worked In], CASE CHARINDEX('-', [Cost Number Worked In], 14)
                                                     WHEN 0 THEN LEN([Cost Number Worked In]) + 1
                                                     ELSE CHARINDEX('-', [Cost Number Worked In], 14) + 1
                                                   END, 2) AS cn_category ,
                SUBSTRING([Cost Number Worked In], CASE CHARINDEX('-', [Cost Number Worked In], 16)
                                                     WHEN 0 THEN LEN([Cost Number Worked In]) + 1
                                                     ELSE CHARINDEX('-', [Cost Number Worked In], 16) + 1
                                                   END, 4) AS cn_proj_grant ,



--Probably want to get this into employee facts instead of using roster data.  For some reason roster infomation appears to drop folks
--Also interesting that sometimes employees are terminated (date field populated) but then re-hired and set to active
--This means that clean would need to include status = terminated and termination date field populated.
--So tracking by payroll is much more accurate
                [Status] ,
                [Current Status] ,
                [Hire Date] ,
                [Termination Date] ,
                [Termination Reason] ,
                [Termination Reason Code] ,
                [Rehire Date] ,
                [Rehire Status] ,
                [Rehire Status Code] ,
                [Rate Type Code] ,
                [Rate Type Desc] ,
                [Data Control] ,
                [Reversal Indicator - Check] [Payroll Number] ,
             

--Adding other dimensions at time of paycheck here
                [Pay Frequency] ,
                [Job Title] ,
                [First Name] ,
                [Last Name] ,
                [Payroll Name] ,
                [Race] ,
                [Manager First Name] ,
                [Manager Last Name] ,
                [Manager ID] ,
                [Age] ,
                [Zip/Postal Code] ,
	  
	  
		 
	 -- There ARE dimensions
	  

	 -- I want this function to look at the past 3 pay periods and pick the max value
	   --IIF(LAG([Standard Hours], 1) OVER ( PARTITION BY dp.person_id ORDER BY dp.first_mon_date ASC ) != dp.mh_hx_key, 1, 0) AS nbr_pt_mh_change ,
      
	   -- IIF(LAG([Standard Hours], 1) OVER ( PARTITION BY [File Number] ORDER BY  [Period End Date - Check] ASC ) != dp.mh_hx_key, 1, 0) AS nbr_pt_mh_change ,
                [Annual Salary] ,
                [Hourly Rate (001)] ,
				 CASE WHEN [Regular Hours]>0 THEN [Regular Earnings]/[Regular Hours] ELSE NULL END AS [Calculated Rate],
            --    [Period Rate] ,
                [Rate Amount] ,
                [Standard Hours] -- this field only represents current FTE not at the time of the payroll
                ,
                [Regular Hours] -- use a lag function to compare to standard hours which is current -- regular hours is historial data
                ,
                ( ( MAX(ISNULL([Regular Hours], 0)) OVER ( PARTITION BY [File Number], [Cost Number Worked In] ORDER BY [Period End Date - Check] ASC  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) ) ) AS [New Regular Hours] ,
                ( ( MAX(ISNULL([Regular Hours], 0)) OVER ( PARTITION BY [File Number],  [Cost Number Worked In] ORDER BY [Period End Date - Check] ASC  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) ) )
                / 80 AS [Paid FTE per pay period] ,
                ( ( MAX(ISNULL([Regular Hours], 0)) OVER ( PARTITION BY [File Number], [Cost Number Worked In] ORDER BY [Period End Date - Check] ASC  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) ) )
                / ( 80 * 26 ) AS [Paid FTE per pay year]
	
--Remaining are facts
                ,
                [All Other Coded Hours] AS [All Other Coded Hours] ,
                [Overtime Hours] AS [Overtime Hours] ,
                [Regular Earnings] AS [Regular Earnings] ,
                [Other Earnings] AS [Other Earnings] ,
                [Overtime Earnings] AS [Overtime Earnings] ,
                [Net Pay] AS [Net Pay] ,
                [Gross Pay] AS [Gross Pay],
				    CAST( ROUND([Rate Amount], 0, 1) AS INTEGER) AS rounded_rate ,
                CAST(ROUND([Annual Salary], 0, 1) AS INTEGER) AS rounded_salary ,
             
            
                CASE WHEN [Rate Type Code] = 'S' THEN ROUND([Annual Salary] / ( 26 * 80 ), 0, 1)
                     WHEN [Rate Type Code] = 'H' THEN ROUND([Annual Salary] / ( 26 * 80 ), 0, 1)
                     ELSE NULL
                END AS rate_cur ,
                CASE WHEN [Annual Salary] / ( 26 * 80 ) < 5 THEN '$1-4 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 10 THEN '$5-9 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 15 THEN '$10-14 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 20 THEN '$15-19 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 25 THEN '$20-24 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 30 THEN '$25-29 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 35 THEN '$30-34 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 40 THEN '$35-39 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 45 THEN '$40-44 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 50 THEN '$45-49 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 55 THEN '$50-54 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 60 THEN '$55-59 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 65 THEN '$60-64 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 70 THEN '$65-69 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 75 THEN '$70-74 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 80 THEN '$75-79 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 85 THEN '$80-84 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 90 THEN '$85-89 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 95 THEN '$90-94 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 100 THEN '$95-99 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 105 THEN '$100-104 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 110 THEN '$105-109 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 115 THEN '$110-114 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) < 120 THEN '$115-119 /hr'
                     WHEN [Annual Salary] / ( 26 * 80 ) >= 120 THEN '>=$120 /hr'
                END AS rate_cur_range ,

				CASE WHEN [Annual Salary] / ( 26 * 80 ) < 5 THEN 1
                     WHEN [Annual Salary] / ( 26 * 80 ) < 10 THEN 2
                     WHEN [Annual Salary] / ( 26 * 80 ) < 15 THEN 3
                     WHEN [Annual Salary] / ( 26 * 80 ) < 20 THEN 4
                     WHEN [Annual Salary] / ( 26 * 80 ) < 25 THEN 5
                     WHEN [Annual Salary] / ( 26 * 80 ) < 30 THEN 6
                     WHEN [Annual Salary] / ( 26 * 80 ) < 35 THEN 7
                     WHEN [Annual Salary] / ( 26 * 80 ) < 40 THEN 8
                     WHEN [Annual Salary] / ( 26 * 80 ) < 45 THEN 9
                     WHEN [Annual Salary] / ( 26 * 80 ) < 50 THEN 10
                     WHEN [Annual Salary] / ( 26 * 80 ) < 55 THEN 11
                     WHEN [Annual Salary] / ( 26 * 80 ) < 60 THEN 12
                     WHEN [Annual Salary] / ( 26 * 80 ) < 65 THEN 13
                     WHEN [Annual Salary] / ( 26 * 80 ) < 70 THEN 14
                     WHEN [Annual Salary] / ( 26 * 80 ) < 75 THEN 15
                     WHEN [Annual Salary] / ( 26 * 80 ) < 80 THEN 16
                     WHEN [Annual Salary] / ( 26 * 80 ) < 85 THEN 17
                     WHEN [Annual Salary] / ( 26 * 80 ) < 90 THEN 18
                     WHEN [Annual Salary] / ( 26 * 80 ) < 95 THEN 19
                     WHEN [Annual Salary] / ( 26 * 80 ) < 100 THEN 20
                     WHEN [Annual Salary] / ( 26 * 80 ) < 105 THEN 21
                     WHEN [Annual Salary] / ( 26 * 80 ) < 110 THEN 22
                     WHEN [Annual Salary] / ( 26 * 80 ) < 115 THEN 23
                     WHEN [Annual Salary] / ( 26 * 80 ) < 120 THEN 24
                     WHEN [Annual Salary] / ( 26 * 80 ) >= 120 THEN 25 
                END AS rate_cur_range_sort ,





                CASE WHEN [Annual Salary] < 5000 THEN '$0-4,999 /year'
                     WHEN [Annual Salary] < 10000 THEN '$5,000-9,000 /year'
                     WHEN [Annual Salary] < 20000 THEN '$10,000-19,999 /year'
                     WHEN [Annual Salary] < 30000 THEN '$20,000-29,999 /year'
                     WHEN [Annual Salary] < 40000 THEN '$30,000-39,999 /year'
                     WHEN [Annual Salary] < 50000 THEN '$40,000-49,999 /year'
                     WHEN [Annual Salary] < 60000 THEN '$50,000-59,999 /year'
                     WHEN [Annual Salary] < 70000 THEN '$60,000-69,999 /year'
                     WHEN [Annual Salary] < 80000 THEN '$70,000-79,999 /year'
                     WHEN [Annual Salary] < 90000 THEN '$80,000-89,999 /year'
                     WHEN [Annual Salary] < 100000 THEN '$90,000-99,999 /year'
                     WHEN [Annual Salary] < 110000 THEN '$100,000-109,999 /year'
                     WHEN [Annual Salary] < 120000 THEN '$110,000-119,999 /year'
                     WHEN [Annual Salary] < 130000 THEN '$120,000-129,999 /year'
                     WHEN [Annual Salary] < 140000 THEN '$130,000-139,999 /year'
                     WHEN [Annual Salary] < 150000 THEN '$140,000-149,999 /year'
                     WHEN [Annual Salary] < 160000 THEN '$150,000-159,999 /year'
                     WHEN [Annual Salary] < 170000 THEN '$160,000-169,999 /year'
                     WHEN [Annual Salary] < 180000 THEN '$170,000-179,999 /year'
                     WHEN [Annual Salary] < 190000 THEN '$180,000-189,999 /year'
                     WHEN [Annual Salary] < 200000 THEN '$190,000-199,999 /year'
                     WHEN [Annual Salary] < 210000 THEN '$200,000-209,999 /year'
                     WHEN [Annual Salary] < 220000 THEN '$210,000-219,999 /year'
                     WHEN [Annual Salary] < 230000 THEN '$220,000-229,999 /year'
                     WHEN [Annual Salary] < 240000 THEN '$230,000-239,999 /year'
                     WHEN [Annual Salary] < 250000 THEN '$240,000-249,999 /year'
                     WHEN [Annual Salary] < 260000 THEN '$250,000-259,999 /year'
                     WHEN [Annual Salary] < 270000 THEN '$260,000-269,999 /year'
                     WHEN [Annual Salary] < 280000 THEN '$270,000-279,999 /year'
                     WHEN [Annual Salary] < 290000 THEN '$280,000-289,999 /year'
                     WHEN [Annual Salary] < 300000 THEN '$290,000-299,999 /year'
                     WHEN [Annual Salary] < 310000 THEN '$300,000-309,999 /year'
                     WHEN [Annual Salary] >= 310000 THEN '>=$310,000 /year'
                END AS salary_cur_range,

				CASE WHEN [Annual Salary] < 5000 THEN 1
                     WHEN [Annual Salary] < 10000 THEN 2
                     WHEN [Annual Salary] < 20000 THEN 3
                     WHEN [Annual Salary] < 30000 THEN 4
                     WHEN [Annual Salary] < 40000 THEN 5
                     WHEN [Annual Salary] < 50000 THEN 6
                     WHEN [Annual Salary] < 60000 THEN 7
                     WHEN [Annual Salary] < 70000 THEN 8
                     WHEN [Annual Salary] < 80000 THEN 9
                     WHEN [Annual Salary] < 90000 THEN 10
                     WHEN [Annual Salary] < 100000 THEN 11
                     WHEN [Annual Salary] < 110000 THEN 12
                     WHEN [Annual Salary] < 120000 THEN 13
                     WHEN [Annual Salary] < 130000 THEN 14
                     WHEN [Annual Salary] < 140000 THEN 15
                     WHEN [Annual Salary] < 150000 THEN 16
                     WHEN [Annual Salary] < 160000 THEN 17
                     WHEN [Annual Salary] < 170000 THEN 18
                     WHEN [Annual Salary] < 180000 THEN 19
                     WHEN [Annual Salary] < 190000 THEN 20
                     WHEN [Annual Salary] < 200000 THEN 21
                     WHEN [Annual Salary] < 210000 THEN 22
                     WHEN [Annual Salary] < 220000 THEN 23
                     WHEN [Annual Salary] < 230000 THEN 24
                     WHEN [Annual Salary] < 240000 THEN 25
                     WHEN [Annual Salary] < 250000 THEN 26
                     WHEN [Annual Salary] < 260000 THEN 27
                     WHEN [Annual Salary] < 270000 THEN 28
                     WHEN [Annual Salary] < 280000 THEN 29
                     WHEN [Annual Salary] < 290000 THEN 30
                     WHEN [Annual Salary] < 300000 THEN 31
                     WHEN [Annual Salary] < 310000 THEN 32
                     WHEN [Annual Salary] >= 310000 THEN 33
                END AS salary_cur_range_sort
        
		
		
		
		
		
		
		
		FROM    [Prod_Ghost].[etl].[data_adp_payroll]
    
				
			WHERE [last Name] LIKE '%henley%'
				    ORDER BY [File Number] ,
                [Period End Date - Check]
				; 
     


       -- INTO    dwh.data_employee_payroll
 --       FROM    etl.data_adp_roster ar;
        
   --     ALTER TABLE dwh.data_employee
  --      ADD CONSTRAINT employee_key_pk PRIMARY KEY (employee_key);






    END;
GO
