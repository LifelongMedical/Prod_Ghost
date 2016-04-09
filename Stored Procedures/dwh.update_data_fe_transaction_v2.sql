SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---TEST before closing

CREATE PROCEDURE [dwh].[update_data_fe_transaction_v2]
AS
    BEGIN


        SET ANSI_NULLS ON; --Treats NULL as a missing value, cannot be used with comparison operators
        SET QUOTED_IDENTIFIER ON;
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; --Allow for "dirty" reads

        IF OBJECT_ID('dwh.data_fe_transaction') IS NOT NULL
            DROP TABLE dwh.data_fe_transaction;
        IF OBJECT_ID('dwh.data_fe_account_budget') IS NOT NULL
            DROP TABLE dwh.data_fe_account_budget;

      IF OBJECT_ID('fdt.[Fact and Dim FE Budget]') IS NOT NULL
            DROP TABLE fdt.[Fact and Dim FE Budget]


        IF OBJECT_ID('dwh.data_fe_account') IS NOT NULL
            DROP TABLE  dwh.data_fe_account;

        IF OBJECT_ID('fdt.[Dim FE Account]') IS NOT NULL
            DROP TABLE  fdt.[Dim FE Account];


			
        IF OBJECT_ID('fdt.[Fact FE Transaction]') IS NOT NULL
            DROP TABLE  fdt.[Fact FE Transaction];

        IF OBJECT_ID('dwh.data_site ') IS NOT NULL
            DROP TABLE  dwh.data_site;


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
                ac.[DESCRIPTION] AS [Account Description] ,
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
				CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 1 THEN 'Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 2 THEN 'Liabilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 3 THEN 'Net Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 4 THEN 'Revenue'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1,1 ) = 5 THEN 'Expenses'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1,1) = 6 THEN 'Overhead'
                     ELSE 'Unknown'
                END AS [Account Super Group] ,

                prj.PROJECTID AS [Project ID] ,
                prj.[DESCRIPTION] AS [Project Name] ,
                te2.ENTRYID AS Site ,
                te2.[DESCRIPTION] AS [Site Description] ,
                te1.ENTRYID AS [Category Number] ,
                te1.DESCRIPTION AS [Category Description] ,
                glt.POSTDATE AS [Post Date] ,
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 7)
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
                CASE WHEN glt.TRANSACTIONTYPE = 2 THEN -1.0 * glt.AMOUNT
                     ELSE 1.0 * glt.AMOUNT
                END AS [Amount] ,
                glt.REFERENCE AS Description
        INTO    dwh.data_fe_transaction
        FROM    [SQL01].[FE_LMC_Production].[dbo].GL7TRANSACTIONS glt
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].GL7TRANSACTIONDISTRIBUTIONS gld ON glt.GL7TRANSACTIONSID = gld.GL7TRANSACTIONSID
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7PROJECTS] prj ON gld.GL7PROJECTSID = prj.GL7PROJECTSID
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7ACCOUNTS] ac ON ac.GL7ACCOUNTSID = glt.GL7ACCOUNTSID
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te1 ON te1.CODETABLESID = 1004
                                                                                  AND te1.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                                        CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER,
                                                                                                        14)
                                                                                                        WHEN 0
                                                                                                        THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER,
                                                                                                        14) + 1
                                                                                                        END, 2)
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te2 ON te2.CODETABLESID = 1002
                                                                                  AND te2.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
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
                ac.GL7ACCOUNTSID ,
                ac.ACCOUNTNUMBER AS [Account Number] ,
                ac.[DESCRIPTION] AS [Account Description] ,
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
			CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 1 THEN 'Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 2 THEN 'Liabilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 3 THEN 'Net Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 4 THEN 'Revenue'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1,1 ) = 5 THEN 'Expenses'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1,1) = 6 THEN 'Overhead'
                     ELSE 'Unknown'
                END AS [Account Super Group] ,
                COALESCE(prj.PROJECTID, 'Unknown') AS [Project ID] ,
                COALESCE(prj.[DESCRIPTION], 'Unknown') AS [Project Name] ,
                te2.ENTRYID AS Site ,
                te2.[DESCRIPTION] AS [Site Description] ,
                te1.ENTRYID AS [Category Number] ,
                te1.DESCRIPTION AS [Category Description] ,
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 7)
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
        FROM    dwh.data_employee_payroll_v2 pa
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7ACCOUNTS] ac ON ac.ACCOUNTNUMBER = SUBSTRING([Cost Number Worked In],
                                                                                                        1, 17)
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te1 ON te1.CODETABLESID = 1004
                                                                                  AND te1.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                                        CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER,
                                                                                                        14)
                                                                                                        WHEN 0
                                                                                                        THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER,
                                                                                                        14) + 1
                                                                                                        END, 2)
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te2 ON te2.CODETABLESID = 1002
                                                                                  AND te2.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                                        CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                        WHEN 0
                                                                                                        THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        END, 3)
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[GL7PROJECTS] prj ON SUBSTRING([Cost Number Worked In],
                                                                                           CASE CHARINDEX('-',
                                                                                                        [Cost Number Worked In],
                                                                                                        16)
                                                                                             WHEN 0
                                                                                             THEN LEN([Cost Number Worked In])
                                                                                                  + 1
                                                                                             ELSE CHARINDEX('-',
                                                                                                        [Cost Number Worked In],
                                                                                                        16) + 1
                                                                                           END, 4) = prj.PROJECTID
        WHERE   ac.ACCOUNTNUMBER IS NOT NULL;
	

--Bad Payroll cost numbers
--51316-310-01-39-1901
--51325-865-01-45-1-1901
--51572-730-1-1-68-1901
--51731-740-40-01-1-56-0364






		
        SELECT  ac.GL7ACCOUNTSID ,
                ac.[ACCOUNTNUMBER] AS [Account Number] ,
                ac.[DESCRIPTION] AS [Account Description] ,
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
         		CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 1 THEN 'Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 2 THEN 'Liabilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 3 THEN 'Net Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 4 THEN 'Revenue'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1,1 ) = 5 THEN 'Expenses'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1,1) = 6 THEN 'Overhead'
                     ELSE 'Unknown'
                END AS [Account Super Group] ,
				ac.[Project ID] AS [Project ID] ,

                ac.[Project Name] AS [Project Name] ,
                te2.ENTRYID AS Site ,
                te2.[DESCRIPTION] AS [Site Description] ,
                te1.ENTRYID AS [Category Number] ,
                te1.DESCRIPTION AS [Category Description] ,
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 7)
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
        INTO    #tempCOA
        FROM    ( SELECT    * ,
                            'Unknown' [Project ID] ,
                            'Unknown' [Project Name]
                  FROM      [SQL01].[FE_LMC_Production].[dbo].[GL7ACCOUNTS]
                ) ac
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te1 ON te1.CODETABLESID = 1004
                                                                                  AND te1.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                                        CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER,
                                                                                                        14)
                                                                                                        WHEN 0
                                                                                                        THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER,
                                                                                                        14) + 1
                                                                                                        END, 2)
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te2 ON te2.CODETABLESID = 1002
                                                                                  AND te2.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                                        CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                        WHEN 0
                                                                                                        THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        END, 3);


---Need to bring in the budget level data here for all accounts

	
        SELECT  COALESCE(ABD.AMOUNT, 0) Amount ,--Amount in budget
                FY.YEARID ,
                AB.GL7ACCOUNTSID , -- Account 
                BS.GL7BUDGETSCENARIOSID , --Key to mapping on budget scenario Dimension
                FP.STARTDATE , -- Begining date of Budgeted amount
                FP.ENDDATE    -- Ending Date of Budgeted amount
        INTO    #budgetTemp
        FROM    [SQL01].[FE_LMC_Production].[dbo].GL7ACCOUNTBUDGETDETAILS ABD
                JOIN [SQL01].[FE_LMC_Production].[dbo].GL7ACCOUNTBUDGETS AB ON ABD.GL7ACCOUNTBUDGETSID = AB.GL7ACCOUNTBUDGETSID
                JOIN [SQL01].[FE_LMC_Production].[dbo].GL7BUDGETSCENARIOS BS ON BS.GL7BUDGETSCENARIOSID = AB.GL7BUDGETSCENARIOSID
                JOIN [SQL01].[FE_LMC_Production].[dbo].GL7FISCALPERIODS FP ON ABD.GL7FISCALPERIODSID = FP.GL7FISCALPERIODSID
                JOIN [SQL01].[FE_LMC_Production].[dbo].GL7FISCALYEARS FY ON FY.GL7FISCALYEARSID = BS.GL7FISCALYEARSID;



        SELECT  ac.GL7ACCOUNTSID ,
                ac.[ACCOUNTNUMBER] AS [Account Number] ,
                ac.[DESCRIPTION] AS [Account Description] ,
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
				CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 1 THEN 'Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 2 THEN 'Liabilities'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 3 THEN 'Net Assets'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1, 1) = 4 THEN 'Revenue'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1,1 ) = 5 THEN 'Expenses'
                     WHEN SUBSTRING(ac.ACCOUNTNUMBER, 1,1) = 6 THEN 'Overhead'
                     ELSE 'Unknown'
                END AS [Account Super Group] ,
                ac.[Project ID] AS [Project ID] ,
                ac.[Project Name] AS [Project Name] ,
                te2.ENTRYID AS Site ,
                te2.[DESCRIPTION] AS [Site Description] ,
                te1.ENTRYID AS [Category Number] ,
                te1.DESCRIPTION AS [Category Description] ,
                CASE WHEN SUBSTRING(ac.ACCOUNTNUMBER, CASE CHARINDEX('-', ac.ACCOUNTNUMBER, 7)
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
        INTO    #budgetTemp2
        FROM    #budgetTemp bt
                INNER JOIN ( SELECT * ,
                                    'Budget' [Project ID] ,
                                    'Budget' [Project Name]
                             FROM   [SQL01].[FE_LMC_Production].[dbo].[GL7ACCOUNTS]
                           ) ac ON ac.GL7ACCOUNTSID = bt.GL7ACCOUNTSID
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te1 ON te1.CODETABLESID = 1004
                                                                                  AND te1.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                                        CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER,
                                                                                                        14)
                                                                                                        WHEN 0
                                                                                                        THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER,
                                                                                                        14) + 1
                                                                                                        END, 2)
                LEFT JOIN [SQL01].[FE_LMC_Production].[dbo].[TABLEENTRIES] te2 ON te2.CODETABLESID = 1002
                                                                                  AND te2.ENTRYID = SUBSTRING(ac.ACCOUNTNUMBER,
                                                                                                        CASE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                        WHEN 0
                                                                                                        THEN LEN(ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        ELSE CHARINDEX('-',
                                                                                                        ac.ACCOUNTNUMBER)
                                                                                                        + 1
                                                                                                        END, 3);




--We are going to do a lookup on budget data for the project line item =Budget to match the chart Key




        SELECT  GL7ACCOUNTSID ,
                [Account Number] ,
                [Account Description] ,
                [Account Group] ,
		       [Account Super Group] ,
                [Project ID] ,
                [Project Name] ,
                Site ,
                [Site Description] ,
                [Category Number] ,
                [Category Description] ,
                Fund ,
                [Indirect or Direct]
        INTO    dwh.data_fe_account
        FROM    #tempCOA
        UNION
        SELECT DISTINCT
                GL7ACCOUNTSID ,
                [Account Number] ,
                [Account Description] ,
                [Account Group] ,
               [Account Super Group] ,
              
			    COALESCE([Project ID], 'Unknown') AS [Project ID] ,
                COALESCE([Project Name], 'Unknown') AS [Project Name] ,
                [Site] ,
                [Site Description] ,
                [Category Number] ,
                [Category Description] ,
                [Fund] ,
                [Indirect or Direct]
        FROM    dwh.data_fe_transaction glt
        UNION
        SELECT DISTINCT
                GL7ACCOUNTSID ,
                [Account Number] ,
                [Account Description] ,
                [Account Group] ,
               [Account Super Group] ,
              
			    COALESCE([Project ID], 'Unknown') AS [Project ID] ,
                COALESCE([Project Name], 'Unknown') AS [Project Name] ,
                [Site] ,
                [Site Description] ,
                [Category Number] ,
                [Category Description] ,
                [Fund] ,
                [Indirect or Direct]
        FROM    #tempPayrollAccounts
        UNION
        SELECT DISTINCT
                GL7ACCOUNTSID ,
                [Account Number] ,
                [Account Description] ,
                [Account Group] ,
               [Account Super Group] ,
              
			    COALESCE([Project ID], 'Unknown') AS [Project ID] ,
                COALESCE([Project Name], 'Unknown') AS [Project Name] ,
                [Site] ,
                [Site Description] ,
                [Category Number] ,
                [Category Description] ,
                [Fund] ,
                [Indirect or Direct]
        FROM    #budgetTemp2;	









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
														
				

      
        SELECT DISTINCT
                IDENTITY( INT, 1, 1 )  AS fe_site_key ,
                dl.location_key ,
                [Site] AS [Site] ,
                [Site Description]
        INTO    dwh.data_site
        FROM    dwh.data_fe_account fe
                LEFT JOIN dwh.data_location dl ON fe.Site = dl.site_id
                                                  AND dl.location_id_unique_flag = 1; 
    

        SELECT  *
        INTO    fdt.[Dim Site]
        FROM    dwh.data_site;
      





--This code below is for getting a dimension on budget scenario
--May consider adding this to a dimension to select the budget scenario or just include it for all fiscal years
--I will add a dimension in the budget transaction Fact and Dim table t select transactions

        --SELECT  ENTRYID ,
        --        TE.DESCRIPTION ,
        --        GL7BUDGETSCENARIOSID ,
        --        FY.YEARID ,
        --        FY.YEARID ,
        --        SCENARIOID ,
        --        FY.GL7FISCALYEARSID ,
        --        FY.GL7FISCALYEARSID
        --FROM    [SQL01].[FE_LMC_Production].[dbo].GL7BUDGETSCENARIOS BS
        --        INNER JOIN [SQL01].[FE_LMC_Production].[dbo].TABLEENTRIES TE ON TE.TABLEENTRIESID = BS.SCENARIOID
        --        INNER JOIN [SQL01].[FE_LMC_Production].[dbo].GL7FISCALYEARS FY ON FY.GL7FISCALYEARSID = BS.GL7FISCALYEARSID;



--This code actually builds the budget table  
--Its about 171k records for all time by month and account 
--What I am planning on doing is creating a day level allocation of budget data so that we can browse at week or daily granularity
--Of course this is going to create a ton of records


        SELECT  COALESCE(ABD.AMOUNT, 0) Amount ,--Amount in budget
                FY.YEARID ,
                AB.GL7ACCOUNTSID , -- Account 
                BS.GL7BUDGETSCENARIOSID , --Key to mapping on budget scenario Dimension
                FP.STARTDATE , -- Begining date of Budgeted amount
                FP.ENDDATE ,   -- Ending Date of Budgeted amount
                ROW_NUMBER() OVER ( ORDER BY FY.YEARID, AB.GL7ACCOUNTSID, FP.STARTDATE ) AS rownum
        INTO    #temp2
        FROM    [SQL01].[FE_LMC_Production].[dbo].GL7ACCOUNTBUDGETDETAILS ABD
                JOIN [SQL01].[FE_LMC_Production].[dbo].GL7ACCOUNTBUDGETS AB ON ABD.GL7ACCOUNTBUDGETSID = AB.GL7ACCOUNTBUDGETSID
                JOIN [SQL01].[FE_LMC_Production].[dbo].GL7BUDGETSCENARIOS BS ON BS.GL7BUDGETSCENARIOSID = AB.GL7BUDGETSCENARIOSID
                JOIN [SQL01].[FE_LMC_Production].[dbo].GL7FISCALPERIODS FP ON ABD.GL7FISCALPERIODSID = FP.GL7FISCALPERIODSID
                JOIN [SQL01].[FE_LMC_Production].[dbo].GL7FISCALYEARS FY ON FY.GL7FISCALYEARSID = BS.GL7FISCALYEARSID;


-- Now take the #Temp3 file and get a chart of accounts unique ID associated with it
-- Then Create a Fact and Dim Table for budget which includes YearID as Budget Scenario in case anyone wants to filter by it.

--- Above procedure is way to inefficient.  Need to try a join with the time table by month and then calculate the amount budgeted.
        DECLARE @start_date DATE ,
            @END_date DATE;
 
        SET @start_date = '20100101';
 
        SELECT  @END_date = MAX(ENDDATE)
        FROM    #temp2;

        SELECT  [PK_Date]
        INTO    #temptime
        FROM    dwh.data_time_source
        WHERE   [PK_Date] >= @start_date
                AND [PK_Date] <= @END_date
        ORDER BY [PK_Date];

--Now join this to temp#2 table
        SELECT  [Amount] AS amount_old ,
                YEARID ,
                [GL7ACCOUNTSID] ,
                [STARTDATE] ,
                tt.PK_Date ,
                ( t2.Amount )
                / NULLIF(COUNT(*) OVER ( PARTITION BY t2.YEARID, YEAR(t2.STARTDATE), MONTH(t2.STARTDATE),
                                         t2.GL7ACCOUNTSID ), 0) AS Amount
        INTO    #temp6
        FROM    [#temp2] t2
                INNER JOIN #temptime tt ON MONTH(t2.STARTDATE) = MONTH(tt.PK_Date)
                                           AND YEAR(t2.STARTDATE) = YEAR(tt.PK_Date);



        SELECT  t3.amount_old ,
                t3.YEARID ,
                t3.GL7ACCOUNTSID ,
                t3.STARTDATE ,
                t3.PK_Date ,
                CASE WHEN fe.[Account Super Group] ='Revenue' then
				t3.Amount*-1.0
				ELSE t3.Amount

				end
				AS amount ,
                fe.[Account Number] ,
                fe.[Account Description] ,
                fe.[Account Group] ,
				fe.[Account Super Group] ,
                fe.[Project ID] ,
                fe.[Project Name] ,
                fe.Site ,
                fe.[Site Description] ,
                fe.[Category Number] ,
                fe.[Category Description] ,
                fe.Fund ,
                fe.[Indirect or Direct] ,
           
                fe.chart_account_key
        INTO    dwh.data_fe_account_budget
        FROM    #temp6 t3
                INNER JOIN dwh.data_fe_account fe ON t3.GL7ACCOUNTSID = fe.GL7ACCOUNTSID
                                                     AND fe.[Project ID] = 'Budget';



        SELECT  [Amount] [Amount Budget] ,
                [YEARID] [Fiscal Scenario Name] ,
                [PK_DATE] ,
                chart_account_key
        INTO    fdt.[Fact and Dim FE Budget]
        FROM    dwh.data_fe_account_budget;



	--  FROM [FE_LMC_Production].[dbo].[FATRANSACTIONDISTRIBUTIONS]  Another transaction distribution table possibility
	-- FROM [FE_LMC_Production].[dbo].[AR7TRANSACTIONDISTRIBUTIONS]  I think this us how transactions get distributed to grants
	--  FROM [FE_LMC_Production].[dbo].[BBTRANSACTIONDISTRIBUTIONS] also possible transactions to grants
--  FROM [FE_LMC_Production].[dbo].[GL7ACCOUNTCODES]  Account Codes
---  [FE_LMC_Production].[dbo].[GL7PROJECTS]         --- All Projects and Grants
--- [FE_LMC_Production].[dbo].[GLACCOUNTS]           --- All accounts (home cost number with Description
--- [FE_LMC_Production].[dbo].[GL7TRANSACTIONS]      --- All transactions posted to accounts
---   FROM [FE_LMC_Production].[dbo].[GL7ACCOUNTS]  --- All accounts (home cost number with Description Not sure what the difference is here with the GL7 accounts
    END;
GO
