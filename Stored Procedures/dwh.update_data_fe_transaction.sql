SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dwh].[update_data_fe_transaction]
AS
    BEGIN


        SET ANSI_NULLS ON; --Treats NULL as a missing value, cannot be used with comparison operators
        SET QUOTED_IDENTIFIER ON;
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; --Allow for "dirty" reads

        IF OBJECT_ID('dwh.data_fe_transaction') IS NOT NULL
            DROP TABLE dwh.data_fe_transaction;
 
 
        IF OBJECT_ID('dwh.data_fe_account') IS NOT NULL
            DROP TABLE  dwh.data_fe_account;

        IF OBJECT_ID('fdt.[Dim FE Account]') IS NOT NULL
            DROP TABLE  fdt.[Dim FE Account];


			
        IF OBJECT_ID('fdt.[Fact FE Transaction]') IS NOT NULL
            DROP TABLE  fdt.[Fact FE Transaction];

 IF OBJECT_ID('dwh.data_site ') IS NOT NULL
            DROP TABLE  dwh.data_site ;


IF OBJECT_ID('fdt.[Dim Site]') IS NOT NULL
            DROP TABLE  fdt.[Dim Site];

 
  


        --SELECT  prj.[Description] AS Prjname ,
        --        SUM(CASE WHEN glt.TRANSACTIONTYPE = 2 THEN -1 * glt.AMOUNT
        --                 ELSE glt.AMOUNT
        --            END)
        --FROM    [SQL01].[FE_LMC_Production].[dbo].gl7transactions glt
        --        JOIN [SQL01].[FE_LMC_Production].[dbo].gl7transactiondistributions gld ON glt.gl7transactionsid = gld.gl7transactionsid
        --        JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7PROJECTS] prj ON gld.gl7projectsid = prj.gl7projectsid
        --WHERE   REFERENCE LIKE '%mansalis%'
        --        AND glt.POSTDATE >= CAST('20150101' AS DATETIME)
        --        AND glt.POSTDATE <= CAST('20151231' AS DATETIME)
        --GROUP BY prj.[Description];


			 
--Create complete list of transactions chart of accounts
     

        SELECT  IDENTITY( INT, 1, 1 )  AS fe_trans_key ,
                glt.GL7ACCOUNTSID ,
                ac.ACCOUNTNUMBER AS [Account Number] ,
				ac.[DESCRIPTION] AS [Account Description],
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 1 THEN 'Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 2 THEN 'Liabilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 3 THEN 'Net Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 4 THEN 'Revenue'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 51 THEN 'Expense-Salaries'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 52 THEN 'Expense-Fringe Benefits'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 53 THEN 'Expense-Medical, Dental etc supplies'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 54 THEN 'Expense-Contracted/Consultant Services'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 55 THEN 'Expense-Facilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 56 THEN 'Expense-Facilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 57 THEN 'Expense-Insurance'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 58 THEN 'Expense-Insurance'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 69 THEN 'Overhead'
                     ELSE 'Unknown'
                END AS [Account Group] ,
                    prj.PROJECTID AS [Project ID] ,
                prj.[DESCRIPTION] AS [Project Name] ,
          
			  
			    te2.entryID AS Site ,
                te2.[DESCRIPTION] AS [Site Description] ,
                te1.entryID AS [Category Number] ,
                te1.DESCRIPTION AS [Category Description] ,
                glt.POSTDATE AS [Post Date] ,
                CASE 
                   
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 7)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 7) + 1
                                                      END, 2) = '01' THEN 'Unrestricted'
													  ELSE 'Unknown'
                END AS [Fund] ,
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '1' THEN 'Direct'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '0' THEN 'Balance Sheet'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '2' THEN 'Admin'
                END AS [Indirect or Direct] ,
                CASE WHEN glt.TRANSACTIONTYPE = 2 THEN 1.0 * glt.AMOUNT
                     ELSE -1.0 * glt.AMOUNT
                END AS [Amount] ,
                glt.REFERENCE AS Description
        INTO    dwh.data_fe_transaction
        FROM    [SQL01].[FE_LMC_Production].[dbo].GL7TRANSACTIONS glt
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].GL7TRANSACTIONDISTRIBUTIONS gld ON glt.GL7TRANSACTIONSID = gld.GL7TRANSACTIONSID
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7PROJECTS] prj ON gld.GL7PROJECTSID = prj.GL7PROJECTSID
				LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7ACCOUNTS] ac ON ac.GL7ACCOUNTSID = glt.GL7ACCOUNTSID
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te1 ON te1.CODETABLESID=1004 AND te1.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                     CASE CHARINDEX('-',
                                                                                                    ac.ACCOUNTNUMBER, 14)
                                                                                       WHEN 0
                                                                                       THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                                                       ELSE CHARINDEX('-',
                                                                                                      ac.ACCOUNTNUMBER,
                                                                                                      14) + 1
                                                                                     END, 2) 
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te2 ON te2.CODETABLESID=1002 AND te2.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                              CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                WHEN 0
                                                                                                THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                     + 1
                                                                                                ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                     + 1
                                                                                              END, 3)
		
		WHERE   glt.POSTDATE >= CAST('20100101' AS DATE);
		




		     SELECT  DISTINCT 
      
                ac.ACCOUNTNUMBER AS [Account Number] ,
				ac.[DESCRIPTION] AS [Account Description],
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 1 THEN 'Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 2 THEN 'Liabilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 3 THEN 'Net Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 4 THEN 'Revenue'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 51 THEN 'Expense-Salaries'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 52 THEN 'Expense-Fringe Benefits'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 53 THEN 'Expense-Medical, Dental etc supplies'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 54 THEN 'Expense-Contracted/Consultant Services'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 55 THEN 'Expense-Facilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 56 THEN 'Expense-Facilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 57 THEN 'Expense-Insurance'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 58 THEN 'Expense-Insurance'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 69 THEN 'Overhead'
                     ELSE 'Unknown'
                END AS [Account Group] ,
                    COALESCE(prj.PROJECTID,'Unknown') AS [Project ID] ,
                COALESCE(prj.[DESCRIPTION],'Unknown') AS [Project Name] ,
          
			  
			    te2.entryID AS Site ,
                te2.[DESCRIPTION] AS [Site Description] ,
                te1.entryID AS [Category Number] ,
                te1.DESCRIPTION AS [Category Description] ,
           
                CASE 
                   
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 7)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 7) + 1
                                                      END, 2) = '01' THEN 'Unrestricted'
													  ELSE 'Unknown'
                END AS [Fund] ,
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '1' THEN 'Direct'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '0' THEN 'Balance Sheet'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '2' THEN 'Admin'
                END AS [Indirect or Direct] 
              
       INTO    #tempPayrollAccounts
        FROM   dwh.data_employee_payroll_v2 pa 
               
         
				LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7ACCOUNTS] ac ON ac.ACCOUNTNUMBER= SUBSTRING([Cost Number Worked In], 1, 17)
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te1 ON te1.CODETABLESID=1004 AND te1.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                     CASE CHARINDEX('-',
                                                                                                    ac.ACCOUNTNUMBER, 14)
                                                                                       WHEN 0
                                                                                       THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                                                       ELSE CHARINDEX('-',
                                                                                                      ac.ACCOUNTNUMBER,
                                                                                                      14) + 1
                                                                                     END, 2) 
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te2 ON te2.CODETABLESID=1002 AND te2.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                              CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                WHEN 0
                                                                                                THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                     + 1
                                                                                                ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                     + 1
                                                                                              END, 3)
		
		       LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7PROJECTS] prj ON   SUBSTRING([Cost Number Worked In], CASE CHARINDEX('-', [Cost Number Worked In], 16)
                                                     WHEN 0 THEN LEN([Cost Number Worked In]) + 1
                                                     ELSE CHARINDEX('-', [Cost Number Worked In], 16) + 1
                                                   END, 4) =prj.PROJECTID
		
		WHERE ac.ACCOUNTNUMBER IS NOT null
	

--Bad Payroll cost numbers
--51316-310-01-39-1901
--51325-865-01-45-1-1901
--51572-730-1-1-68-1901
--51731-740-40-01-1-56-0364






		
        SELECT 
                ac.[ACCOUNTNUMBER] AS [Account Number] ,
				ac.[description] AS [Account Description],
                   CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 1 THEN 'Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 2 THEN 'Liabilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 3 THEN 'Net Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 4 THEN 'Revenue'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 51 THEN 'Expense-Salaries'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 52 THEN 'Expense-Fringe Benefits'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 53 THEN 'Expense-Medical, Dental etc supplies'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 54 THEN 'Expense-Contracted/Consultant Services'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 55 THEN 'Expense-Facilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 56 THEN 'Expense-Facilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 57 THEN 'Expense-Insurance'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 58 THEN 'Expense-Insurance'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 2) = 69 THEN 'Overhead'
                     ELSE 'Unknown'
                END AS [Account Group] ,
             	ac.[Project ID] AS [Project ID],
				   ac.[Project Name] AS [Project Name],
			
		         te2.entryID AS Site ,
                te2.[DESCRIPTION] AS [Site Description] ,
                te1.entryID AS [Category Number] ,
                te1.DESCRIPTION AS [Category Description] ,
           
                  CASE 
                   
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 7)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 7) + 1
                                                      END, 2) = '01' THEN 'Unrestricted'
													  ELSE 'Unknown'
                END AS [Fund] ,
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '1' THEN 'Direct'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '0' THEN 'Balance Sheet'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 11)
                                                        WHEN 0 THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                        ELSE CHARINDEX('-', ac.ACCOUNTNUMBER, 11) + 1
                                                      END, 1) = '2' THEN 'Admin'
                END AS [Indirect or Direct] 
	   INTO #tempCOA
	   
	 
        FROM    (SELECT *,'Unknown' [Project ID],'Unknown' [Project Name] FROM [SQL01].[FE_LMC_Production].[dbo].[GL7ACCOUNTS]) ac
               
				
			

				 LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te1 ON te1.CODETABLESID=1004 AND te1.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                     CASE CHARINDEX('-',
                                                                                                    ac.ACCOUNTNUMBER, 14)
                                                                                       WHEN 0
                                                                                       THEN LEN(ac.ACCOUNTNUMBER) + 1
                                                                                       ELSE CHARINDEX('-',
                                                                                                      ac.ACCOUNTNUMBER,
                                                                                                      14) + 1
                                                                                     END, 2) 
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te2 ON te2.CODETABLESID=1002 AND te2.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                              CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                WHEN 0
                                                                                                THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                     + 1
                                                                                                ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                     + 1
                                                                                         END, 3)




SELECT 

    
	   [Account Number] ,
       [Account Description] ,
       [Account Group] ,
       [Project ID] ,
       [Project Name] ,
       Site ,
       [Site Description] ,
       [Category Number] ,
       [Category Description] ,
       Fund ,
       [Indirect or Direct] 
  INTO      dwh.data_fe_account
	   FROM #tempcoa
UNION 
        SELECT DISTINCT
           
                [ACCOUNT NUMBER] ,
				[Account Description],
                [Account Group] ,
		        COALESCE([Project ID],'Unknown') as [Project ID],
                COALESCE([Project Name],'Unknown') AS [Project Name] ,
                [Site] ,
                [Site Description] ,
                [Category Number] ,
                [Category Description] ,
                [Fund] ,
                [Indirect or Direct]

        FROM    dwh.data_fe_transaction glt 
      
UNION 
	    SELECT DISTINCT
           
                [ACCOUNT NUMBER] ,
				[Account Description],
                [Account Group] ,
		        COALESCE([Project ID],'Unknown') as [Project ID],
                COALESCE([Project Name],'Unknown') AS [Project Name] ,
                [Site] ,
                [Site Description] ,
                [Category Number] ,
                [Category Description] ,
                [Fund] ,
                [Indirect or Direct]

        FROM    	 #tempPayrollAccounts	

		       ALTER TABLE dwh.data_fe_account
        ADD chart_account_key INT NOT NULL IDENTITY(1,1);

	
		
        SELECT  *
        INTO    fdt.[Dim FE Account]
        FROM    dwh.data_fe_account;




        SELECT  COALESCE(ac.chart_account_key, ax.chart_account_key) AS chart_account_key ,
                tr.[Post Date] ,
                tr.Description AS [Transaction Description] ,
                tr.[Amount]
        INTO    fdt.[Fact FE Transaction]
        FROM    dwh.data_fe_transaction tr
                LEFT JOIN dwh.data_fe_account ac ON tr.[Account Number] = ac.[Account Number]
                                                    AND ( ac.[Project ID] = tr.[Project ID] )
                LEFT JOIN dwh.data_fe_account ax ON tr.[Account Number] = ax.[Account Number]
                                                    AND ( tr.[Project ID] IS NULL
                                                          AND ax.[Project ID] IS NULL
                                                        );                                                                           
														
				

      
	SELECT DISTINCT  IDENTITY( INT, 1, 1 )  AS fe_site_key, dl.location_key, [site] AS [Site], [Site Description] INTO dwh.data_site FROM dwh.data_fe_account fe LEFT JOIN dwh.data_location dl ON fe.Site=dl.site_id AND dl.location_id_unique_flag=1 
    

	SELECT * INTO fdt.[Dim Site] FROM dwh.data_site
      




--Create an employee Month fact table from the Payroll table


--Need to match to Time, Employee and Manager DIM tables and well as account DIM table

--Create an SCD table that has Regular Hrs/80 for FTE, Hx Age, Months as Employee, Cur and Hx for : Hourly Rate and Annual Salary and Annual Salary
--Make it a snap shot table




						  
--SELECT TOP 1000  * FROM [SQL01].[FE_LMC_Production].[dbo].[GL7ACCOUNTS] 

--SELECT TOP 1000  * FROM [SQL01].[FE_LMC_Production].[dbo].gl7transactions 


--SELECT TOP 1000  * FROM [SQL01].[FE_LMC_Production].[dbo].[GL7PROJECTS]   




						  
						  
						--  WHERE REFERENCE LIKE '%mansalis%' AND glt.POSTDATE >= CAST('20150101' AS DATETIME) AND glt.POSTDATE <= CAST ('20151231' AS datetime) 
                    -- GROUP BY prj.[Description]









	--  FROM [FE_LMC_Production].[dbo].[FATRANSACTIONDISTRIBUTIONS]  Another transaction distribution table possibility
	-- FROM [FE_LMC_Production].[dbo].[AR7TRANSACTIONDISTRIBUTIONS]  I think this us how transactions get distributed to grants
	--  FROM [FE_LMC_Production].[dbo].[BBTRANSACTIONDISTRIBUTIONS] also possible transactions to grants
--  FROM [FE_LMC_Production].[dbo].[GL7ACCOUNTCODES]  Account Codes
---  [FE_LMC_Production].[dbo].[GL7PROJECTS]         --- All Projects and Grants
--- [FE_LMC_Production].[dbo].[GLACCOUNTS]           --- All accounts (home cost number with Description
--- [FE_LMC_Production].[dbo].[GL7TRANSACTIONS]      --- All transactions posted to accounts
---   FROM [FE_LMC_Production].[dbo].[GL7ACCOUNTS]  --- All accounts (home cost number with Description Not sure what the difference is here with the GL7 accounts

--BUild of financial Edge Data




--SELECT 

----tr.POSTSTATUS ,
----tr.POSTDATE ,
----tr.TRANSACTIONTYPE ,
--ac.ACCOUNTNUMBER ,
----tr.REFERENCE ,
--ac.DESCRIPTION ,
----ac.CATEGORY --,
--SUM(CASE WHEN tr.TRANSACTIONTYPE=2 THEN -1*tr.AMOUNT ELSE tr.AMOUNT END ) as amount

----tr.REVERSEDATE ,
----tr.REVERSEDTRANSACTIONSID ,
----tr.SOURCERECORDSID ,
----tr.SOURCENUMBER ,
----tr.SOURCETYPE ,
----tr.SOURCESYSTEMMASK ,

----ac.CATEGORY



--  FROM [FE_LMC_Production].[dbo].[GL7TRANSACTIONS] tr
--    INNER JOIN [FE_LMC_Production].[dbo].[GL7ACCOUNTS] ac ON ac.GL7ACCOUNTSID = tr.GL7ACCOUNTSID
  
--   WHERE REFERENCE LIKE '%mansalis%' AND tr.POSTDATE >= CAST('20150101' AS DATETIME) AND tr.POSTDATE <= CAST ('20151231' AS datetime) 
--  GROUP BY ac.ACCOUNTNUMBER ,ac.DESCRIPTION 
   
-- --  ORDER BY tr.POSTDATE


--DROP table #TempCOA 

    END;
GO
