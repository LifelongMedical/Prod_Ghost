SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Benjamin P Mansalis
-- Create date: 9/29/2015
-- Description:	
-- This routine creates a provider table for the data warehouse based on the NG provider master file

--Dependencies - none

-- =============================================
CREATE PROCEDURE [dwh].[update_data_user_v2]
AS
    BEGIN


        SET ANSI_NULLS ON;
        SET QUOTED_IDENTIFIER ON;

        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
        IF OBJECT_ID('dwh.data_resource') IS NOT NULL
            DROP TABLE dwh.data_resource;

       IF OBJECT_ID('dwh.data_provider') IS NOT NULL
            DROP TABLE dwh.data_provider;

			
       IF OBJECT_ID('dwh.data_user_v2') IS NOT NULL
            DROP TABLE dwh.data_user_v2;



--Create a user table  and match up to employees
--Create a provider table and match up to users
--Create a Resource table and match up to user table (employees)


--Pull the name from the user table and build provider and resource filter tables

--Will need to restructure many of the exisiting reports to accomodate these changes


   SELECT   IDENTITY( INT, 1, 1 )  AS user_key,
   
                xr.[provider_id] AS self_provider_id,
			    ar.employee_key,
				um.[user_id] ,
                COALESCE(um.first_name,'') AS first_name ,
                                COALESCE(um.last_name, '') AS last_name ,
                                CASE WHEN CONCAT(COALESCE(um.last_name,  ''), ', ',
                                                 COALESCE(um.first_name,  '')) != ', '
                                     THEN CONCAT(COALESCE(um.last_name,''), ', ',
                                                 COALESCE(um.first_name,  ''))
                                     ELSE ''
                                END AS FullName 
        
             INTO #user
				FROM     [10.183.0.94].[NGProd].[dbo].[user_mstr] um
                                LEFT JOIN ( SELECT  provider_id ,
                                                    user_id
                                            FROM    [10.183.0.94].[NGProd].[dbo].[user_provider_xref]
                                            WHERE   [relationship_id] = '3FF021CC-6C25-4DBC-B7CE-2303A720C1D7'
                                          ) xr ON um.user_id = xr.user_id
                      LEFT JOIN dwh.data_employee_v2 ar ON REPLACE(UPPER(LEFT(um.first_name, 3)), '''', '') = REPLACE(UPPER(LEFT(ar.[Payroll First Name],
                                                                                                        3)), '''', '')
                                                      AND REPLACE(UPPER(um.last_name), '''', '') = REPLACE(UPPER(ar.[Payroll Last Name]),
                                                                                                        '''', '');


  SELECT   

                                prov.provider_id ,
						  ar.employee_key,
                                CASE WHEN COALESCE(prov.degree, '') != '' THEN 'Provider'
                                     ELSE 'Not Provider'
                                END AS role_status ,
                                COALESCE(prov.first_name,'') AS first_name ,
                                COALESCE( prov.last_name, '') AS last_name ,
                                CASE WHEN CONCAT(COALESCE( prov.last_name, ''), ', ',
                                                 COALESCE( prov.first_name, '')) != ', '
                                     THEN CONCAT(COALESCE(prov.last_name, ''), ', ',
                                                 COALESCE(prov.first_name, ''))
                                     ELSE ''
                                END AS FullName ,
                                COALESCE(prov.description, '') AS provider_name ,
                                COALESCE(prov.degree, '') AS degree ,
                                COALESCE(prov.[delete_ind], '') AS delete_ind 
                               
					
               INTO #provider
				       FROM     [10.183.0.94].[NGProd].[dbo].[provider_mstr] prov
					   LEFT JOIN dwh.data_employee_v2 ar ON REPLACE(UPPER(LEFT(prov.first_name, 3)), '''', '') = REPLACE(UPPER(LEFT(ar.[Payroll First Name],
                                                                                                        3)), '''', '')
                                                      AND REPLACE(UPPER(prov.last_name), '''', '') = REPLACE(UPPER(ar.[Payroll Last Name]),
                                                                                                        '''', '');

                    



              --Select the location where provider had the most encounters over the past 3 months  
              SELECT   *
			  INTO #enc3m
                       FROM     ( SELECT    e.* ,
                                            ROW_NUMBER() OVER ( PARTITION BY e.rendering_provider_id ORDER BY e.rendering_provider_id, e.QTY DESC ) AS Most_enc
                                  FROM      ( SELECT    enc.rendering_provider_id ,
                                                        loc.location_name ,
                                                        COUNT(*) AS QTY
                                              FROM      [10.183.0.94].NGProd.dbo.patient_encounter enc
                                                        INNER JOIN [10.183.0.94].NGProd.dbo.location_mstr loc ON loc.location_id = enc.location_id
                                              WHERE     enc.billable_ind = 'Y'
                                                        AND DATEDIFF(MONTH, enc.billable_timestamp, GETDATE()) <= 3
                                              GROUP BY  enc.rendering_provider_id ,
                                                        loc.location_name
                                            ) e
                                ) f
                       WHERE    f.Most_enc = 1
                    




               --Location where provider had second most encounters over the past 3 months
                  SELECT   *
                  INTO #enc3ms
				       FROM     ( SELECT    e.* ,
                                            ROW_NUMBER() OVER ( PARTITION BY e.rendering_provider_id ORDER BY e.rendering_provider_id, e.QTY DESC ) AS Most_enc
                                  FROM      ( SELECT    enc.rendering_provider_id ,
                                                        loc.location_name ,
                                                        COUNT(*) AS QTY
                                              FROM      [10.183.0.94].NGProd.dbo.patient_encounter enc
                                                        INNER JOIN [10.183.0.94].NGProd.dbo.location_mstr loc ON loc.location_id = enc.location_id
                                              WHERE     enc.billable_ind = 'Y'
                                                        AND DATEDIFF(MONTH, enc.billable_timestamp, GETDATE()) <= 3
                                              GROUP BY  enc.rendering_provider_id ,
                                                        loc.location_name
                                            ) e
                                ) f
               
			   
			           WHERE    f.Most_enc = 2
               
			   
			   
			   
			    
                  SELECT   *
                       INTO #enc6m
					   FROM     ( SELECT    e.* ,
                                            ROW_NUMBER() OVER ( PARTITION BY e.rendering_provider_id ORDER BY e.rendering_provider_id, e.QTY DESC ) AS Most_enc
                                  FROM      ( SELECT    enc.rendering_provider_id ,
                                                        loc.location_name ,
                                                        COUNT(*) AS QTY
                                              FROM      [10.183.0.94].NGProd.dbo.patient_encounter enc
                                                        INNER JOIN [10.183.0.94].NGProd.dbo.location_mstr loc ON loc.location_id = enc.location_id
                                              WHERE     enc.billable_ind = 'Y'
                                                        AND DATEDIFF(MONTH, enc.billable_timestamp, GETDATE()) <= 6
                                              GROUP BY  enc.rendering_provider_id ,
                                                        loc.location_name
                                            ) e
                                ) f
                       WHERE    f.Most_enc = 1
                 
				 
				 
		
                   SELECT   *
                       INTO #enc12m
					   FROM     ( SELECT    e.* ,
                                            ROW_NUMBER() OVER ( PARTITION BY e.rendering_provider_id ORDER BY e.rendering_provider_id, e.QTY DESC ) AS Most_enc
                                  FROM      ( SELECT    enc.rendering_provider_id ,
                                                        loc.location_name ,
                                                        COUNT(*) AS QTY
                                              FROM      [10.183.0.94].NGProd.dbo.patient_encounter enc
                                                        INNER JOIN [10.183.0.94].NGProd.dbo.location_mstr loc ON loc.location_id = enc.location_id
                                              WHERE     enc.billable_ind = 'Y'
                                                        AND DATEDIFF(MONTH, enc.billable_timestamp, GETDATE()) <= 12
                                              GROUP BY  enc.rendering_provider_id ,
                                                        loc.location_name
                                            ) e
                                ) f
                       WHERE    f.Most_enc = 1
                     
                
                   SELECT  
                                res.resource_id ,
                          												 
res.phys_id,
                                res.description AS resource_name
					
            
        
		--Create an aggregate user_key with provider_id and user_id Null is not present in both
                       INTO #resource
					   FROM    [10.183.0.94].[NGProd].[dbo].[resources] res

           






            SELECT 
                    process.provider_id ,
					process.employee_key,
                    process.role_status ,
                    process.first_name ,
                    process.last_name ,
                    process.FullName ,
                    process.provider_name ,
                    IIF(CHARINDEX(' ',
                                  IIF(CHARINDEX(',', process.provider_name) > 0, LTRIM(SUBSTRING(process.provider_name,
                                                                                                 1,
                                                                                                 CHARINDEX(',',
                                                                                                        process.provider_name)
                                                                                                 - 1)), 'Failed')) > 0, SUBSTRING(IIF(CHARINDEX(',',
                                                                                                        process.provider_name) > 0, LTRIM(SUBSTRING(process.provider_name,
                                                                                                        1,
                                                                                                        CHARINDEX(',',
                                                                                                        process.provider_name)
                                                                                                        - 1)), 'Failed'),
                                                                                                        1,
                                                                                                        CHARINDEX(' ',
                                                                                                        IIF(CHARINDEX(',',
                                                                                                        process.provider_name) > 0, LTRIM(SUBSTRING(process.provider_name,
                                                                                                        1,
                                                                                                        CHARINDEX(',',
                                                                                                        process.provider_name)
                                                                                                        - 1)), 'Failed'))
                                                                                                        - 1), IIF(CHARINDEX(',',
                                                                                                        process.provider_name) > 0, LTRIM(SUBSTRING(process.provider_name,
                                                                                                        1,
                                                                                                        CHARINDEX(',',
                                                                                                        process.provider_name)
                                                                                                        - 1)), 'Failed')) AS LastName_cleaned ,
                    IIF(CHARINDEX(' ',
                                  IIF(CHARINDEX(',', process.provider_name) > 0, LTRIM(SUBSTRING(process.provider_name,
                                                                                                 CHARINDEX(',',
                                                                                                        process.provider_name)
                                                                                                 + 1, 8000)), 'Failed')) > 0, SUBSTRING(IIF(CHARINDEX(',',
                                                                                                        process.provider_name) > 0, LTRIM(SUBSTRING(process.provider_name,
                                                                                                        CHARINDEX(',',
                                                                                                        process.provider_name)
                                                                                                        + 1, 8000)), 'Failed'),
                                                                                                        1,
                                                                                                        CHARINDEX(' ',
                                                                                                        IIF(CHARINDEX(',',
                                                                                                        process.provider_name) > 0, LTRIM(SUBSTRING(process.provider_name,
                                                                                                        CHARINDEX(',',
                                                                                                        process.provider_name)
                                                                                                        + 1, 8000)), 'Failed'))
                                                                                                        - 1), IIF(CHARINDEX(',',
                                                                                                        process.provider_name) > 0, LTRIM(SUBSTRING(process.provider_name,
                                                                                                        CHARINDEX(',',
                                                                                                        process.provider_name)
                                                                                                        + 1, 8000)), 'Failed')) AS FirstName_cleaned ,
                 
                    process.degree ,
                    process.delete_ind ,
                    CASE WHEN e3.location_name IS NOT NULL
                              AND provider_id IS NOT NULL THEN 'Provider active in past 3 months'
                         WHEN e3.location_name IS  NULL
                              AND provider_id IS NOT NULL THEN 'Provider not active in past 3 months'
                         ELSE 'Unknown'
                    END AS active_3m_provider ,
                    CASE WHEN e3.location_name IS NOT NULL
                              AND provider_id IS NOT NULL THEN e3.location_name
                         ELSE 'Unknown'
                    END AS primary_loc_3m_provider ,
                    CASE WHEN e3s.location_name IS NOT NULL
                              AND provider_id IS NOT NULL THEN 'Provider active in past 3 months at secondary site'
                         WHEN e3s.location_name IS  NULL
                              AND provider_id IS NOT NULL THEN 'Provider not active in past 3 months at secondary site'
                         ELSE 'Unknown'
                    END AS active_3ms_provider ,
                    CASE WHEN e3s.location_name IS NOT NULL
                              AND provider_id IS NOT NULL THEN e3s.location_name
                         ELSE 'Unknown'
                    END AS secondary_loc_3m_provider ,
                    CASE WHEN e6.location_name IS NOT NULL
                              AND provider_id IS NOT NULL THEN 'Provider active in past 6 months'
                         WHEN e6.location_name IS  NULL
                              AND provider_id IS NOT NULL THEN 'Provider not active in past 6 months'
                         ELSE 'Unknown'
                    END AS active_6m_provider ,
                    CASE WHEN e6.location_name IS NOT NULL
                              AND provider_id IS NOT NULL THEN e6.location_name
                         ELSE 'Unknown'
                    END AS primary_loc_6m_provider ,
                    CASE WHEN e12.location_name IS NOT NULL
                              AND provider_id IS NOT NULL THEN 'Provider active in past 12 months'
                         WHEN e12.location_name IS  NULL
                              AND provider_id IS NOT NULL THEN 'Provider not active in past 12 months'
                         ELSE 'Unknown'
                    END AS active_12m_provider ,
                    CASE WHEN e12.location_name IS NOT NULL
                              AND provider_id IS NOT NULL THEN e12.location_name
                         ELSE 'Unknown'
                    END AS primary_loc_12m_provider 
                
              INTO    #provider2
            FROM    #provider process
                    LEFT JOIN #enc3m e3 ON process.provider_id = e3.rendering_provider_id
                    LEFT JOIN #enc3ms e3s ON process.provider_id = e3s.rendering_provider_id
                    LEFT JOIN #enc6m e6 ON process.provider_id = e6.rendering_provider_id
                    LEFT JOIN #enc12m e12 ON process.provider_id = e12.rendering_provider_id
                  


SELECT u.* INTO dwh.data_user_v2 FROM #user u 

SELECT p.*,user_key, ROW_NUMBER() OVER(PARTITION BY p.provider_id ORDER BY (SELECT NULL)) AS rownum INTO #provider3 FROM #provider2 p LEFT JOIN  dwh.data_user_v2 u ON p.provider_id=u.self_provider_id 

SELECT IDENTITY( INT, 1, 1 )  AS provider_key, * INTO dwh.data_provider FROM #provider3 WHERE rownum <2

SELECT  IDENTITY( INT, 1, 1 )  AS resource_key,r.*, p.provider_key INTO dwh.data_resource FROM #resource r LEFT JOIN dwh.data_provider p ON p.provider_id= r.phys_id

/*
Insertion of ECW provider data
*/
ALTER TABLE dwh.data_provider ALTER COLUMN provider_id UNIQUEIDENTIFIER NULL
ALTER TABLE dwh.data_provider ALTER COLUMN first_name VARCHAR(50)
ALTER TABLE dwh.data_provider ALTER COLUMN last_name VARCHAR(50)
ALTER TABLE dwh.data_provider ADD ecw_provider_key INT null

  INSERT INTO dwh.data_provider
   (employee_key , 
   role_status, 
   first_name, 
   last_name , 
   FullName, 
   provider_name,
   LastName_cleaned, 
   FirstName_cleaned, 
   delete_ind , 
   active_3m_provider,active_3ms_provider, active_6m_provider,active_12m_provider,
   ecw_provider_key)
  SELECT 
	emp .employee_key, 
	'Provider' AS role_status, 
	prov.provider_first_name , 
	prov.provider_last_name,
	prov.provider_last_name +', '+ prov.provider_first_name ,
	prov. provider_last_name+', '+prov. provider_first_name, 
	prov .provider_first_name, 
	prov.provider_last_name ,
    CASE
        WHEN (prov .DeleteFlag = 1 OR prov .DeleteFlag IS NULL) THEN 'Y'
        ELSE 'N'
        END
    AS delete_flag ,
        'Unknown','Unknown' ,'Unknown', 'Unknown',
		prov.provider_id
  FROM dwh .data_provider_ecw prov LEFT JOIN dwh .data_employee_v2 emp ON (prov. provider_first_name=emp .[Payroll First Name] AND prov.provider_last_name= emp.[Payroll Last Name] )
  WHERE prov.provider_first_name <> '' AND prov.provider_last_name <> ''

--End ECW Insert
	

    END;
GO
