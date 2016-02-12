
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_employee_hours]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		
        IF OBJECT_ID('dwh.data_employee_hours') IS NOT NULL
            DROP TABLE dwh.data_employee_hours;
        IF OBJECT_ID('dwh.data_employee_hours_status') IS NOT NULL
            DROP TABLE dwh.data_employee_hours_status;




        SELECT  de.employee_key ,
	        	de.employee_month_key,
                [Pay Date] ,
                [Type] AS status_type ,
			
				 ( SELECT TOP 1
                                        location_key
                                 FROM   dwh.data_location dl
                                 WHERE  dl.site_id = 	ah.Site
                                        AND dl.location_id_unique_flag = 1
                                        AND 	ah.Site IS NOT NULL
                               ) as location_key,
                [Earnings Code Timecard] AS status_ec_tc ,
                [Earnings Code Payroll] AS status_ec_pr ,
                ROUND([Rate], 0, 1) AS status_rate ,
                [Earnings Code Timecard] ,
                [Earnings Code Payroll] ,
                [Rate] ,
                [Hours Timecard] ,
                [Hours Payroll] ,
                [Dollars] ,
				ah.[Employee ID],
				ah.[Last Name],
				ah.Status,
				ah.[Worked Department]
				
               
		   

		-- Need to aggregate all Data control and translate into actual FTE
	
		-- Gonna need overtime report 
		-- Months of employement
		-- Vintage of employee
		-- Balances Vacation and sick
		



     --INTO dwh.data_employee_hours
        INTO    #precomp
        FROM    etl.data_adp_hours ah
                INNER JOIN dwh.data_employee_month de ON RIGHT(ah.[Employee ID], 6) = de.[File Number]
				AND de.first_mon_date = CAST(CONVERT(VARCHAR(6), [ah].[Pay Date], 112) +'01' AS date) ;
		      
		        
              
			  
        SELECT  
		ROW_NUMBER() OVER ( ORDER BY x1.status_type , x2.status_ec_tc , x3.status_ec_pr , x4.status_rate ) AS employee_hours_comp_key ,
                x1.status_type ,
                x2.status_ec_tc ,
                x3.status_ec_pr ,
                x4.status_rate
        INTO    dwh.data_employee_hours_status
        FROM    ( SELECT DISTINCT
                            status_type
                  FROM      #precomp
                ) x1
                CROSS JOIN ( SELECT DISTINCT
                                    status_ec_tc
                             FROM   #precomp
                           ) x2
                CROSS JOIN ( SELECT DISTINCT
                                    status_ec_pr
                             FROM   #precomp
                           ) x3
                CROSS JOIN ( SELECT DISTINCT
                                    status_rate
                             FROM   #precomp
                           ) x4;
                



        SELECT  IDENTITY( INT, 1, 1 )  AS employee_hours_key ,
		        d.* ,
                employee_hours_comp_key
        INTO    dwh.data_employee_hours
        FROM    #precomp d
                LEFT JOIN dwh.data_employee_hours_status e ON e.status_type = d.status_type
                                                              AND e.status_ec_tc = d.status_ec_tc
                                                              AND e.status_ec_pr = d.status_ec_pr
                                                              AND e.status_rate = d.status_rate;
                     
					 
					 
					 
        ALTER TABLE dwh.data_employee_hours_status
        ALTER COLUMN employee_hours_comp_key BIGINT NOT NULL;                  

		ALTER TABLE dwh.data_employee_hours
        ALTER COLUMN [Pay Date] DATE  NULL;                  


        ALTER TABLE dwh.data_employee_hours_status
        ADD CONSTRAINT employee_hours_comp_key_pk PRIMARY KEY (employee_hours_comp_key);

		     ALTER TABLE dwh.data_employee_hours
        ADD CONSTRAINT employee_hours_key_pk PRIMARY KEY (employee_hours_key);

        DROP TABLE #precomp;

    END;
GO
