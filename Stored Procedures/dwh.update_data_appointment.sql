SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_appointment]
AS
    BEGIN




        IF OBJECT_ID('dwh.data_appointment') IS NOT NULL
            DROP TABLE dwh.data_appointment;

			
        IF OBJECT_ID('dwh.data_enc_appt_status') IS NOT NULL
            DROP TABLE dwh.data_enc_appt_status;
			 
        IF OBJECT_ID('tempdb..#ar') IS NOT NULL
            DROP TABLE #ar;
        IF OBJECT_ID('tempdb..#appt_enc') IS NOT NULL
            DROP TABLE #appt_enc;

        IF OBJECT_ID('tempdb..#appt_DQ') IS NOT NULL
            DROP TABLE #appt_DQ;

        IF OBJECT_ID('tempdb..#appt_enc2') IS NOT NULL
            DROP TABLE #appt_enc2;

        IF OBJECT_ID('tempdb..#appt_enc3') IS NOT NULL
            DROP TABLE #appt_enc3;

        IF OBJECT_ID('tempdb..#temp_dim') IS NOT NULL
            DROP TABLE #temp_dim;
			

        IF OBJECT_ID('dwh.data_event') IS NOT NULL
            DROP TABLE dwh.data_event;


        SELECT  IDENTITY( INT, 1, 1 ) AS event_key ,
                e.event_id ,
                e.event AS event_name
        INTO    dwh.data_event
        FROM    [10.183.0.94].NGProd.dbo.[events] e; 

/*
-- all appts from start date forward
-- include enc info if available, but get standalone appts as well
-- get all appts regardless of cancel/resched/delete status

-- 2nd query to get standalone encounters as well


link between appts and slots based on 
- date
- begintime
- resource
- location

*/

-- calculate start date
        DECLARE @dt_start VARCHAR(8);
        SELECT  @dt_start = '20100301'; 



-- use last modified person resource to deal with any multi-resource appts
        SELECT  resource_id ,
                appt_id ,
                interval
        INTO    #ar
        FROM    ( SELECT    am.resource_id ,
                            am.appt_id ,
                            r.interval ,
                            rank_order = ROW_NUMBER() OVER ( PARTITION BY am.appt_id ORDER BY am.modify_timestamp DESC )
                  FROM      [10.183.0.94].NGProd.dbo.appointment_members am
                            INNER JOIN [10.183.0.94].NGProd.dbo.resources r ON am.resource_id = r.resource_id
                  WHERE     r.resource_type = 'Person'
                            AND am.delete_ind = 'N'
                ) x
        WHERE   rank_order = 1;
      

-- all appts
                
    
  
        CREATE TABLE #appt_enc
            (
              [appt_date] [DATE] NULL ,
              [slot_time] [CHAR](4) NULL ,
              [appt_type] [CHAR](1) NULL ,
              [resource_id] [UNIQUEIDENTIFIER] NULL ,
              [appt_loc_id] [UNIQUEIDENTIFIER] NULL ,
              [appt_person_id] [UNIQUEIDENTIFIER] NULL ,
              [enc_person_id] [UNIQUEIDENTIFIER] NULL ,
              [enc_id] [UNIQUEIDENTIFIER] NULL ,
              [enc_nbr] [NUMERIC](12, 0) NULL ,
              [enc_slot_type] [VARCHAR](40) NULL ,
              [appt_nbr] [NUMERIC](12, 0) NULL ,
              [interval] [INT] NULL ,
              [duration] [INT] NULL ,
              [slot_count] [INT] NULL ,
              [enc_loc_id] [UNIQUEIDENTIFIER] NULL ,
              [enc_date] [DATE] NULL ,
              [enc_rendering_id] [UNIQUEIDENTIFIER] NULL ,
              [appt_status] [CHAR](1) NULL ,
              [appt_kept_ind] [CHAR](1) NULL ,
              [cancel_ind] [CHAR](1) NULL ,
              [cancel_reason] [UNIQUEIDENTIFIER] NULL ,
              [delete_ind] [CHAR](1) NULL ,
              [resched_ind] [CHAR](1) NULL ,
              [checkin_datetime] [DATETIME] NULL ,
              [enc_status] [CHAR](1) NULL ,
              [user_enc_created] [INT] NULL ,
              [pcp_id] [UNIQUEIDENTIFIER] NULL ,
              [billable_ind] [CHAR](1) NULL ,
              [event_id] [UNIQUEIDENTIFIER] NULL ,
              [event_name] [VARCHAR](30) NULL ,
              [appt_create_time] [DATETIME] NULL ,
              [appt_modify_time] [DATETIME] NULL ,
              [user_appt_created] [INT] NULL
            ); 

		
		
		
		--DQ Issue -- Apparently some appointments are getting linked to the same same enc_id. to get the number of billable appointments correct
		           -- So, I will null out the enc_id for the remailing appointments (so unique by enc Id on the field)-- the effect may displace
				   -- Its not clear to me how to know which of the billable encounters is properly mapped with the appointment, but
				   -- I will keep the encounter date that matched the appointment date and null the remaining ID in the appointment table


        SELECT  DQ_enc_id = ROW_NUMBER() OVER ( PARTITION BY enc_id ORDER BY a.modify_timestamp DESC ) ,
                a.*
        INTO    #appt_DQ
        FROM    [10.183.0.94].NGProd.dbo.appointments a;


        INSERT  INTO #appt_enc
                ( appt_date ,
                  slot_time ,
                  appt_type ,
                  resource_id ,
                  appt_loc_id ,
                  appt_person_id ,
                  enc_person_id ,
                  enc_id ,
                  enc_nbr ,
                  enc_slot_type ,
                  appt_nbr ,
                  interval ,
                  duration ,
                  slot_count ,
                  enc_loc_id ,
                  enc_date ,
                  enc_rendering_id ,
                  appt_status ,
                  appt_kept_ind ,
                  cancel_ind ,
                  cancel_reason ,
                  delete_ind ,
                  resched_ind ,
                  checkin_datetime ,
                  enc_status ,
                  user_enc_created ,
                  pcp_id ,
                  billable_ind ,
                  event_id ,
                  event_name ,
                  appt_create_time ,
                  appt_modify_time ,
                  user_appt_created
                )
                SELECT  CAST(a.appt_date AS DATE) AS appt_date ,
                        a.begintime AS slot_time ,
                        a.appt_type ,
                        ar.resource_id ,
                        a.location_id AS appt_loc_id ,
                        a.person_id AS appt_person_id ,
                        enc.person_id AS enc_person_id ,
                        CASE WHEN a.DQ_enc_id = 1
                                  AND a.enc_id IS NOT NULL THEN enc.enc_id
                             ELSE NULL
                        END AS enc_id ,
                        CASE WHEN a.DQ_enc_id = 1
                                  AND a.enc_id IS NOT NULL THEN enc.enc_nbr
                             ELSE NULL
                        END AS enc_nbr ,
                        enc_slot_type = CASE WHEN a.enc_id IS NULL THEN 'Appt without encounter'
                                             ELSE 'Appt with Encounter'
                                        END ,
                        a.appt_nbr ,
                        ar.interval ,
                        a.duration AS duration ,
                        slot_count = FLOOR(a.duration / ar.interval) , --Gives number of individual slots
                        enc_loc_id = enc.location_id ,
                        enc_date = CAST(enc.billable_timestamp AS DATE) ,
                        enc_rendering_id = a.rendering_provider_id ,
                        a.appt_status ,
                        a.appt_kept_ind ,
                        a.cancel_ind ,
                        a.cancel_reason ,
                        a.delete_ind ,
                        a.resched_ind ,
                        enc.checkin_datetime ,
                        enc.enc_status ,
                        enc.created_by AS user_enc_created ,
                        per.primarycare_prov_id AS pcp_id ,
                        enc.billable_ind ,
                        a.event_id ,
                        e.event AS event_name ,
                        a.create_timestamp AS appt_create_time ,
                        a.modify_timestamp AS appt_modify_time ,
                        a.created_by AS user_appt_created
                FROM    #appt_DQ a
                        INNER JOIN #ar ar ON a.appt_id = ar.appt_id
                        LEFT JOIN [10.183.0.94].NGProd.dbo.patient_encounter enc ON a.enc_id = enc.enc_id
                        LEFT JOIN [10.183.0.94].NGProd.dbo.person per ON per.person_id = a.person_id
                        LEFT JOIN [10.183.0.94].NGProd.dbo.events e ON e.event_id = a.event_id
                WHERE   a.appt_date >= @dt_start; 

	-- add in past encounters not linked to appts		
  
        INSERT  INTO #appt_enc
                ( appt_date ,
                  slot_time ,
                  appt_type ,
                  resource_id ,
                  appt_loc_id ,
                  appt_person_id ,
                  enc_person_id ,
                  enc_id ,
                  enc_nbr ,
                  enc_slot_type ,
                  appt_nbr ,
                  interval ,
                  duration ,
                  slot_count ,
                  enc_loc_id ,
                  enc_date ,
                  enc_rendering_id ,
                  appt_status ,
                  appt_kept_ind ,
                  cancel_ind ,
                  cancel_reason ,
                  delete_ind ,
                  resched_ind ,
                  checkin_datetime ,
                  enc_status ,
                  user_enc_created ,
                  pcp_id ,
                  billable_ind ,
                  event_id ,
                  event_name ,
                  appt_create_time ,
                  appt_modify_time ,
                  user_appt_created 
                )
               
			   --There is a bug in SQL server 2012 for linked servers that requires CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER) as workaround for NULL as uniqueindetifier 
			   --See this post http://sqlwithmanoj.com/2015/03/27/sqlncli11-for-linked-server-xyz-returned-message-requested-conversion-is-not-supported-sql-server-2012-upgrade-behavior-changes/
                SELECT  CAST(NULL AS DATE) AS appt_date ,
                        CAST(NULL AS CHAR(4)) AS slot_time ,
                        CAST(NULL AS CHAR(1)) AS appt_type ,
                        CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER) AS resource_id ,
                        CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER) AS appt_loc_id ,
                        CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER) AS appt_person_id ,
                        CAST(enc.person_id AS UNIQUEIDENTIFIER) AS enc_person_id ,
                        CAST(enc.enc_id AS UNIQUEIDENTIFIER) AS enc_id ,
                        CAST(enc.enc_nbr AS NUMERIC(12, 0)) AS enc_nbr ,
                        CAST('Encounter no appt' AS VARCHAR(20)) AS enc_slot_type ,
                        CAST(NULL AS NUMERIC(12, 0)) AS appt_nbr ,
                        CAST(NULL AS INT) AS interval ,
                        CAST(NULL AS INT) AS duration ,
                        CAST(NULL AS INT) AS slot_count ,
                        CAST(enc.location_id AS UNIQUEIDENTIFIER) AS enc_loc_id ,
                        CAST(enc.billable_timestamp AS DATE) AS enc_date ,
                        CAST(enc.rendering_provider_id AS UNIQUEIDENTIFIER) AS enc_rendering_id ,
                        CAST (NULL AS CHAR(1)) AS appt_status ,
                        CAST (NULL AS CHAR(1)) AS appt_kept_ind ,
                        CAST (NULL AS CHAR(1)) AS cancel_ind ,
                        CAST (NULL AS CHAR(1)) AS delete_ind ,
                        CAST(a.cancel_reason AS UNIQUEIDENTIFIER) AS cancel_reason ,
                        CAST (NULL AS CHAR(1)) AS resched_ind ,
                        CAST(enc.checkin_datetime AS DATETIME) AS checkin_datetime ,
                        CAST(enc.enc_status AS CHAR(1)) AS enc_status ,
                        CAST(enc.created_by AS INT) AS user_enc_created ,
                        CAST(per.primarycare_prov_id AS UNIQUEIDENTIFIER) AS pcp_id ,
                        CAST(enc.billable_ind AS CHAR(1)) AS billable_ind ,
                        CAST(a.event_id AS UNIQUEIDENTIFIER) AS event_id ,
                        CAST(NULL AS VARCHAR(30)) AS event_name ,
                        CAST(NULL AS DATETIME) AS appt_create_time ,
                        CAST(NULL AS DATETIME) AS appt_modify_time ,
                        CAST(NULL AS INT) AS user_appt_created
                FROM    [10.183.0.94].NGProd.dbo.patient_encounter enc
                        LEFT JOIN [10.183.0.94].NGProd.dbo.appointments a ON enc.enc_id = a.enc_id
                        LEFT JOIN [10.183.0.94].NGProd.dbo.person per ON per.person_id = enc.person_id
                WHERE   a.enc_id IS NULL
                        AND CONVERT(CHAR(8), enc.billable_timestamp, 112) >= @dt_start;
                



       

        SELECT  d.* ,
                
				
		
                CASE WHEN ( d.appt_date IS NOT NULL
                            AND d.slot_time IS NOT NULL
                            AND d.appt_modify_time IS NOT NULL
                            AND ISNULL(d.cancel_ind, 'N') = 'Y'
                            AND ISNULL(d.resched_ind, 'N') = 'N'
                            AND DATEDIFF(MINUTE, d.appt_modify_time,
                                         CAST(CONCAT(CONVERT(VARCHAR(8), d.appt_date, 112), ' ',
                                                     SUBSTRING(d.slot_time, 1, 2), ':', SUBSTRING(d.slot_time, 3, 2),
                                                     ':00') AS DATETIME)) <= 4 * 60
                          ) THEN 'Cancelled < 4 Hrs before appt'
                     WHEN ( d.appt_date IS NOT NULL
                            AND d.slot_time IS NOT NULL
                            AND d.appt_modify_time IS NOT NULL
                            AND ISNULL(d.cancel_ind, 'N') = 'Y'
                            AND ISNULL(d.resched_ind, 'N') = 'N'
                            AND DATEDIFF(MINUTE, d.appt_modify_time,
                                         CAST(CONCAT(CONVERT(VARCHAR(8), d.appt_date, 112), ' ',
                                                     SUBSTRING(d.slot_time, 1, 2), ':', SUBSTRING(d.slot_time, 3, 2),
                                                     ':00') AS DATETIME)) <= 48 * 60
                          ) THEN 'Cancelled 4-48 Hrs before appt'
                     WHEN ( d.appt_date IS NOT NULL
                            AND d.slot_time IS NOT NULL
                            AND d.appt_modify_time IS NOT NULL
                            AND ISNULL(d.cancel_ind, 'N') = 'Y'
                            AND ISNULL(d.resched_ind, 'N') = 'N'
                            AND DATEDIFF(MINUTE, d.appt_modify_time,
                                         CAST(CONCAT(CONVERT(VARCHAR(8), d.appt_date, 112), ' ',
                                                     SUBSTRING(d.slot_time, 1, 2), ':', SUBSTRING(d.slot_time, 3, 2),
                                                     ':00') AS DATETIME)) > 48 * 60 
                          ) THEN 'Cancelled  > 48 Hrs before appt'
                     WHEN ISNULL(d.delete_ind, 'N') = 'Y'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 'Deleted'
                     WHEN ISNULL(d.resched_ind, 'N') = 'Y' THEN 'Rescheduled'
                     WHEN d.appt_date >= CONVERT(CHAR(8), GETDATE(), 112)
                          AND d.appt_person_id IS NOT NULL
                          AND ISNULL(d.appt_kept_ind, 'N') = 'N'
                          AND ISNULL(d.delete_ind, 'N') = 'N'
                          AND ISNULL(d.cancel_ind, 'N') = 'N'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 'Future'
                     WHEN d.appt_date < CONVERT(CHAR(8), GETDATE(), 112)
                          AND d.appt_person_id IS NOT NULL
                          AND ISNULL(d.appt_kept_ind, 'N') = 'N'
                          AND ISNULL(d.cancel_ind, 'N') = 'N'
                          AND ISNULL(d.delete_ind, 'N') = 'N'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 'No show'
                     WHEN d.appt_date > CONVERT(CHAR(8), GETDATE(), 112)
                          AND d.appt_person_id IS  NULL
                          AND ISNULL(d.appt_kept_ind, 'N') = 'N'
                          AND ISNULL(d.delete_ind, 'N') = 'N'
                          AND ISNULL(d.cancel_ind, 'N') = 'N'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 'Future blocks'
                     WHEN d.appt_date <= CONVERT(CHAR(8), GETDATE(), 112)
                          AND d.appt_person_id IS  NULL
                          AND ISNULL(d.appt_kept_ind, 'N') = 'N'
                          AND ISNULL(d.cancel_ind, 'N') = 'N'
                          AND ISNULL(d.delete_ind, 'N') = 'N'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 'Historic blocks'
                     WHEN ISNULL(d.appt_kept_ind, 'N') = 'Y'
                          AND d.appt_nbr IS NOT NULL THEN 'Kept'
                     WHEN d.appt_nbr IS  NULL THEN 'No appointment'
                     ELSE 'Unknown'
                END AS status_appt ,
                CASE WHEN ( d.appt_nbr IS NOT NULL
                            AND d.appt_person_id IS NULL
                          ) THEN 'Appointment without patient'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.appt_person_id IS NOT NULL
                          ) THEN 'Appointment with a patient'
                     ELSE 'No appointment'
                END AS status_appt_person ,
                CASE WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NOT NULL
                            AND d.enc_rendering_id IS NOT NULL
                            AND d.pcp_id = d.enc_rendering_id
                          ) THEN 'Appointment booked with PCP'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NOT NULL
                            AND d.enc_rendering_id IS NOT NULL
                            AND d.pcp_id != d.enc_rendering_id
                          ) THEN 'Appointment not booked with PCP'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NULL
                            AND d.enc_rendering_id IS NOT NULL
                          ) THEN 'Patient has no PCP assigned'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NOT NULL
                            AND d.enc_rendering_id IS NULL
                          ) THEN 'No rendering provider for appt'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS  NULL
                            AND d.enc_rendering_id IS NULL
                          ) THEN 'No rendering provider and No PCP assigned for appt'
                     WHEN ( d.appt_nbr IS NULL ) THEN 'No appointment'
                     ELSE 'Unknown'
                END AS status_appt_pcp ,
                CASE WHEN ( d.enc_id IS NOT NULL
                            AND d.appt_nbr IS NOT NULL
                          ) THEN 'Appointment with encounter'
                     WHEN ( d.enc_id IS NOT NULL
                            AND d.appt_nbr IS  NULL
                          ) THEN 'Encounter without appointment'
                     WHEN ( d.enc_id IS NULL
                            AND d.appt_nbr IS NOT NULL
                          ) THEN 'Appointment without encounter'
                     WHEN ( d.enc_id IS NULL
                            AND d.appt_nbr IS NULL
                          ) THEN 'No appointment and no encounter'
                     ELSE 'Unknown'
                END AS status_appt_enc ,
                CASE WHEN ( d.enc_id IS NOT NULL
                            AND d.appt_nbr IS NOT NULL
                          ) THEN 'Encounter with appointment'
                     WHEN ( d.enc_id IS NOT NULL
                            AND d.appt_nbr IS  NULL
                          ) THEN 'Encounter without appointment'
                     WHEN ( d.enc_id IS NULL
                            AND d.appt_nbr IS NOT NULL
                          ) THEN 'Appointment without encounter'
                     WHEN ( d.enc_id IS NULL
                            AND d.appt_nbr IS NULL
                          ) THEN 'No appointment and no encounter'
                     ELSE 'Unknown'
                END AS status_enc_appt ,
                CASE WHEN ISNULL(d.billable_ind, 'N') = 'Y'
                          AND d.enc_id IS NOT NULL THEN 'Billable visit'
                     WHEN ISNULL(d.billable_ind, 'N') != 'Y'
                          AND d.enc_id IS NOT NULL THEN 'Non-billable visit'
                     ELSE 'No encounter'
                END AS status_enc_billable ,
                CASE WHEN d.enc_status = 'U' THEN 'Unbilled'
                     WHEN d.enc_status = 'R' THEN 'Rebilled'
                     WHEN d.enc_status = 'H' THEN 'Historical'
                     WHEN d.enc_status = 'B' THEN 'Billed'
                     WHEN d.enc_status = 'D' THEN 'Bad Debt'
                     WHEN d.enc_id IS NULL THEN 'No encounter'
                     ELSE 'Unknown'
                END AS status_enc ,
                CASE WHEN ISNULL(d.appt_kept_ind, 'N') = 'Y'
                          AND d.appt_nbr IS NOT NULL THEN 'Kept'
                     WHEN ISNULL(d.appt_kept_ind, 'N') != 'Y'
                          AND d.appt_nbr IS NOT NULL THEN 'Not kept'
                     ELSE 'No appointment'
                END AS status_appt_kept ,
                CASE WHEN ISNULL(m.mstr_list_item_desc, '') != '' THEN ( m.mstr_list_item_desc )
                     ELSE 'Unknown'
                END AS status_cancel_reason,
				CASE WHEN chg.source_id is not null THEN 'Has Charges'
                     ELSE 'No Charges'
                END AS status_charges



        INTO    #appt_enc2
        FROM    #appt_enc d
                LEFT JOIN [10.183.0.94].NGProd.dbo.[mstr_lists] m ON d.cancel_reason = m.mstr_list_item_id
				LEFT JOIN  (select distinct source_id from  [10.183.0.94].NGProd.dbo.charges) chg on chg.source_id =d.enc_id

				
        SELECT  ROW_NUMBER() OVER ( ORDER BY x1.status_appt , x2.status_appt_pcp , x3.status_appt_person , x4.status_appt_enc , x5.status_enc_appt , x6.status_enc_billable , x7.status_enc, x8.status_appt_kept, x9.status_cancel_reason, x10.status_charges ) AS enc_appt_comp_key ,
                x1.status_appt ,
                x2.status_appt_pcp ,
                x3.status_appt_person ,
                x4.status_appt_enc ,
                x5.status_enc_appt ,
                x6.status_enc_billable ,
                x7.status_enc ,
                x8.status_appt_kept ,
                x9.status_cancel_reason,
				x10.status_charges
        INTO    dwh.data_enc_appt_status
        FROM    ( SELECT DISTINCT
                            status_appt
                  FROM      #appt_enc2
                ) x1
                CROSS JOIN ( SELECT DISTINCT
                                    status_appt_pcp
                             FROM   #appt_enc2
                           ) x2
                CROSS JOIN ( SELECT DISTINCT
                                    status_appt_person
                             FROM   #appt_enc2
                           ) x3
                CROSS JOIN ( SELECT DISTINCT
                                    status_appt_enc
                             FROM   #appt_enc2
                           ) x4
                CROSS JOIN ( SELECT DISTINCT
                                    status_enc_appt
                             FROM   #appt_enc2
                           ) x5
                CROSS JOIN ( SELECT DISTINCT
                                    status_enc_billable
                             FROM   #appt_enc2
                           ) x6
                CROSS JOIN ( SELECT DISTINCT
                                    status_enc
                             FROM   #appt_enc2
                           ) x7
                CROSS JOIN ( SELECT DISTINCT
                                    status_appt_kept
                             FROM   #appt_enc2
                           ) x8
                CROSS JOIN ( SELECT DISTINCT
                                    status_cancel_reason
                             FROM   #appt_enc2
                           ) x9
						    CROSS JOIN ( SELECT DISTINCT
                                    status_charges
                             FROM   #appt_enc2
                           ) x10;





        SELECT  d.* ,
                e.enc_appt_comp_key
        INTO    #appt_enc3
        FROM    #appt_enc2 d
                LEFT JOIN dwh.data_enc_appt_status e ON e.status_appt = d.status_appt
                                                        AND e.status_appt_pcp = d.status_appt_pcp
                                                        AND e.status_appt_person = d.status_appt_person
                                                        AND e.status_appt_enc = d.status_appt_enc
                                                        AND e.status_enc_appt = d.status_enc_appt
                                                        AND e.status_enc_billable = d.status_enc_billable
                                                        AND e.status_enc = d.status_enc
                                                        AND e.status_appt_kept = d.status_appt_kept
                                                        AND e.status_cancel_reason = d.status_cancel_reason
														AND e.status_charges =d.status_charges;
			 
	   			 
					 
        SELECT  IDENTITY( INT, 1, 1 ) AS enc_appt_key ,
                ( SELECT TOP 1
                            user_key
                  FROM      dwh.data_user du
                  WHERE     du.resource_id = d.resource_id
                            AND d.resource_id IS NOT NULL
                ) AS user_resource_key ,
                d.resource_id ,
                ( SELECT TOP 1
                            location_key
                  FROM      dwh.data_location dl
                  WHERE     dl.location_id = d.appt_loc_id
                            AND dl.location_id_unique_flag = 1
                            AND d.appt_loc_id IS NOT NULL
                ) AS appt_loc_key ,
                d.appt_loc_id ,
                ( SELECT TOP 1
                            enc_key
                  FROM      dwh.data_encounter de
                  WHERE     de.enc_id = d.enc_id
                            AND d.enc_id IS NOT NULL
                ) AS enc_key ,
                d.enc_id ,
                ( SELECT TOP 1
                            location_key
                  FROM      dwh.data_location dl
                  WHERE     dl.location_id = d.enc_loc_id
                            AND dl.location_id_unique_flag = 1
                            AND d.enc_loc_id IS NOT NULL
                ) AS enc_loc_key ,
                d.enc_loc_id ,
                ( SELECT TOP 1
                            user_key
                  FROM      dwh.data_user du
                  WHERE     du.provider_id = d.enc_rendering_id
                            AND d.enc_rendering_id IS NOT NULL
                ) AS enc_rendering_key ,
                d.enc_rendering_id ,
                ( SELECT TOP 1
                            per_mon_id
                  FROM      dwh.data_person_nd_month pm
                  WHERE     pm.first_mon_date = CAST(CONVERT(VARCHAR(6), COALESCE(d.enc_date, d.appt_date), 112) + '01' AS DATE)
                            AND pm.person_id = COALESCE(d.enc_person_id, d.appt_person_id)
                            AND COALESCE(d.enc_person_id, d.appt_person_id) IS NOT NULL
                ) AS per_mon_id ,
                COALESCE(( SELECT TOP 1
                                    location_key
                           FROM     dwh.data_location dl
                           WHERE    dl.location_id = d.enc_loc_id
                                    AND dl.location_id_unique_flag = 1
                                    AND d.enc_loc_id IS NOT NULL
                         ), ( SELECT TOP 1
                                        location_key
                              FROM      dwh.data_location dl
                              WHERE     dl.location_id = d.appt_loc_id
                                        AND dl.location_id_unique_flag = 1
                                        AND d.appt_loc_id IS NOT NULL
                            )) AS location_key ,
                d.enc_appt_comp_key ,
                ( SELECT TOP 1
                            cat_event_key
                  FROM      dwh.data_category_event ed
                  WHERE     ed.event_id = d.event_id
                ) AS event_key ,
                d.event_name ,
                COALESCE(enc_date, appt_date) AS enc_app_date ,
                d.pcp_id ,
                d.appt_person_id ,
                d.enc_person_id ,
                d.event_id ,
                d.enc_date ,
                d.checkin_datetime AS enc_checkin_datetime ,
                d.appt_nbr ,
                d.enc_nbr ,
                d.appt_type ,
                d.appt_status ,
                d.enc_slot_type ,
                d.appt_date ,
                d.slot_time AS appt_time ,
                d.duration AS appt_duration ,
                d.interval AS appt_interval ,
                d.appt_kept_ind ,
                d.cancel_ind AS appt_cancel_ind ,
                d.resched_ind AS appt_resched_ind ,
                d.delete_ind AS appt_delete_ind ,
                d.enc_status ,
                ds.user_checkout ,
                ds.user_readyforprovider ,
                ds.user_charted ,
                ( SELECT TOP 1
                            user_key
                  FROM      dwh.data_user du
                  WHERE     du.user_id = d.user_appt_created
                            AND d.user_appt_created IS NOT NULL
                ) AS user_appt_created ,
                ( SELECT TOP 1
                            user_key
                  FROM      dwh.data_user du
                  WHERE     du.user_id = d.user_enc_created
                            AND d.user_enc_created IS NOT NULL
                ) AS user_enc_created ,
                COALESCE(d.enc_person_id, d.appt_person_id) AS person_id ,
                CAST(CONVERT(VARCHAR(6), COALESCE(d.enc_date, d.appt_date), 112) + '01' AS DATE) AS first_mon_date ,
                CASE WHEN ( d.appt_date IS NOT NULL
                            AND d.slot_time IS NOT NULL
                            --AND d.checkin_datetime IS NOT NULL
                          )
                     THEN CAST(CONCAT(CONVERT(VARCHAR(8), d.appt_date, 112), ' ', SUBSTRING(d.slot_time, 1, 2), ':',
                                      SUBSTRING(d.slot_time, 3, 2), ':00') AS DATETIME)
                END AS appt_datetime ,
                
			
				
				--Here we are counting how many of all appoints regardless of their status as cancelled our rescheduled were booked with the PCP
                CASE WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NOT NULL
                            AND d.enc_rendering_id IS NOT NULL
                            AND d.pcp_id = d.enc_rendering_id
                          ) THEN 'Appointment booked with PCP'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NOT NULL
                            AND d.enc_rendering_id IS NOT NULL
                            AND d.pcp_id != d.enc_rendering_id
                          ) THEN 'Appointment not booked with PCP'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NULL
                            AND d.enc_rendering_id IS NOT NULL
                          ) THEN 'Patient has no PCP assigned'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NOT NULL
                            AND d.enc_rendering_id IS NULL
                          ) THEN 'No rendering provider for appt'
                     WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS  NULL
                            AND d.enc_rendering_id IS NULL
                          ) THEN 'No rendering provider and no PCP assigned for appt'
                     WHEN ( d.appt_nbr IS NULL ) THEN 'No appointment'
                     ELSE 'Unknown'
                END AS appt_w_pcp_status_txt ,
                CASE WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NOT NULL
                            AND d.enc_rendering_id IS NOT NULL
                            AND d.pcp_id = d.enc_rendering_id
                          ) THEN 1
                     ELSE 0
                END AS nbr_pcp_appts ,
                CASE WHEN ( d.appt_nbr IS NOT NULL
                            AND d.pcp_id IS NOT NULL
                            AND d.enc_rendering_id IS NOT NULL
                            AND d.pcp_id = d.enc_rendering_id
                          ) THEN 0
                     ELSE 1
                END AS nbr_nonpcp_appt ,
                CASE WHEN ( d.appt_nbr IS NOT NULL ) THEN 1
                     ELSE 0
                END AS nbr_appts ,
				

					 
				--This metric is appointments that aren't linked to a person -- not sure why this would be the case
                CASE WHEN ( d.appt_nbr IS NOT NULL
                            AND d.appt_person_id IS NULL
                          ) THEN 1
                     ELSE 0
                END AS nbr_appt_notlinked_toperson ,
               
				
				
					--Could include number of non-billable encounters completed by PCP
                
				--This is the number of appointments that have a linked encounter that were kept (or checked in)
                CASE WHEN ISNULL(d.appt_kept_ind, 'N') = 'Y'
                          AND ISNULL(d.resched_ind, 'N') != 'Y' -- This is checking for reschedules The D are reschedules, Could have also checked resched_ind != 'Y'
                          AND d.enc_id IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_appt_kept_and_linked_enc ,
                
			
				--I think of this as a data quality audit
                CASE WHEN ISNULL(d.appt_kept_ind, 'N') = 'Y'
                          AND ISNULL(resched_ind, 'N') != 'Y'
                          AND d.enc_id IS NULL THEN 1
                     ELSE 0
                END AS nbr_appt_kept_not_linked_enc ,

						--These are ne counts of future appointments
                CASE WHEN d.appt_date >= CONVERT(CHAR(8), GETDATE(), 112)
                         -- AND d.enc_nbr IS NOT NULL
                          AND ISNULL(d.appt_kept_ind, 'N') = 'N'
                          AND ISNULL(d.delete_ind, 'N') = 'N'
                          AND ISNULL(d.cancel_ind, 'N') = 'N'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 1
                     ELSE 0
                END AS nbr_appt_future ,
                CASE WHEN d.appt_date < CONVERT(CHAR(8), GETDATE(), 112)
                         -- AND d.enc_nbr IS NOT NULL
                          AND ISNULL(d.appt_kept_ind, 'N') = 'N'
                          AND ISNULL(d.cancel_ind, 'N') = 'N'
                          AND ISNULL(d.delete_ind, 'N') = 'N'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 1
                     ELSE 0
                END AS nbr_appt_no_show ,
                CASE WHEN d.appt_date >= CONVERT(CHAR(8), GETDATE(), 112)
                          AND d.appt_person_id IS NULL
                          AND ISNULL(d.appt_kept_ind, 'N') = 'N'
                          AND ISNULL(d.delete_ind, 'N') = 'N'
                          AND ISNULL(d.cancel_ind, 'N') = 'N'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 1
                     ELSE 0
                END AS nbr_appt_future_no_patient ,
                CASE WHEN d.appt_date < CONVERT(CHAR(8), GETDATE(), 112)
                          AND d.appt_person_id IS NULL
                          AND ISNULL(d.appt_kept_ind, 'N') = 'N'
                          AND ISNULL(d.cancel_ind, 'N') = 'N'
                          AND ISNULL(d.delete_ind, 'N') = 'N'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 1
                     ELSE 0
                END AS nbr_appt_no_show_no_patient ,
                CASE WHEN ISNULL(d.cancel_ind, 'N') = 'Y'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 1
                     ELSE 0
                END AS nbr_appt_cancelled , --
                CASE WHEN ISNULL(d.delete_ind, 'N') = 'Y'
                          AND ISNULL(d.resched_ind, 'N') = 'N' THEN 1
                     ELSE 0
                END AS nbr_appt_deleted , --
                CASE WHEN ISNULL(d.resched_ind, 'N') = 'Y' THEN 1
                     ELSE 0
                END AS nbr_appt_rescheduled ,  --

				--This is billable encounters of for patients
                --Here is a concern that popped up in the 
                CASE WHEN d.enc_id IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_enc ,
                CASE WHEN ISNULL(d.billable_ind, 'N') = 'Y'
                          AND d.enc_id IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_bill_enc ,
                CASE WHEN d.enc_id IS NOT NULL
                          OR d.appt_nbr IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_enc_or_appt ,
                CASE WHEN ISNULL(d.billable_ind, 'N') != 'Y'
                          AND d.enc_id IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_non_bill_enc ,
                CASE WHEN ISNULL(d.billable_ind, 'N') = 'Y'
                          AND d.appt_nbr IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_bill_enc_with_an_appt ,
                CASE WHEN ISNULL(d.billable_ind, 'N') != 'Y'
                          AND d.appt_nbr IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_non_bill_enc_with_an_appt ,
                CASE WHEN ISNULL(d.billable_ind, 'N') = 'Y'
                          AND ISNULL(d.appt_kept_ind, 'N') = 'Y'
                          AND ISNULL(d.appt_nbr, 'N') IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_bill_enc_with_an_appt_and_kept ,
                CASE WHEN ISNULL(d.billable_ind, 'N') != 'Y'
                          AND ISNULL(d.appt_kept_ind, 'N') = 'Y'
                          AND d.appt_nbr IS NOT NULL THEN 1
                     ELSE 0
                END AS nbr_non_bill_enc_with_an_appt_and_kept ,
                CASE WHEN ISNULL(d.appt_create_time, 0) != 0
                     THEN DATEDIFF(DAY, CAST(d.appt_create_time AS DATE), d.appt_date)
                END AS days_to_appt ,
                d.appt_create_time ,
                ds.cycle_min_kept_checkedout ,
                ds.cycle_min_kept_readyforprovider ,
                ds.cycle_min_kept_charted ,
                ds.cycle_min_readyforprovider_checkout ,
                CASE WHEN ( d.appt_date IS NOT NULL
                            AND d.slot_time IS NOT NULL
                            AND d.checkin_datetime IS NOT NULL
                          )
                     THEN IIF(( COALESCE(DATEDIFF(mi,
                                                  CAST(CONCAT(CONVERT(VARCHAR(8), d.appt_date, 112), ' ',
                                                              SUBSTRING(d.slot_time, 1, 2), ':',
                                                              SUBSTRING(d.slot_time, 3, 2), ':00') AS DATETIME),
                                                  d.checkin_datetime), 0) > 480 )
                          OR ( COALESCE(DATEDIFF(mi,
                                                 CAST(CONCAT(CONVERT(VARCHAR(8), d.appt_date, 112), ' ',
                                                             SUBSTRING(d.slot_time, 1, 2), ':',
                                                             SUBSTRING(d.slot_time, 3, 2), ':00') AS DATETIME),
                                                 d.checkin_datetime), 0) > -480 ), NULL, COALESCE(DATEDIFF(mi,
                                                                                                        CAST(CONCAT(CONVERT(VARCHAR(8), d.appt_date, 112),
                                                                                                        ' ',
                                                                                                        SUBSTRING(d.slot_time,
                                                                                                        1, 2), ':',
                                                                                                        SUBSTRING(d.slot_time,
                                                                                                        3, 2), ':00') AS DATETIME),
                                                                                                        d.checkin_datetime),
                                                                                                  0))
                END AS cycle_min_slottime_to_kept
        INTO    dwh.data_appointment
        FROM    #appt_enc3 d
                LEFT JOIN dwh.data_status ds ON d.enc_id = ds.enc_id
                                                AND d.enc_id IS NOT NULL;
			
               




        ALTER TABLE Prod_Ghost.dwh.data_appointment
        ALTER COLUMN appt_time VARCHAR(4) NULL;
			
     			
        ALTER TABLE Prod_Ghost.dwh.data_appointment
        ADD CONSTRAINT enc_appt_key_PK PRIMARY KEY (enc_appt_key);

        CREATE NONCLUSTERED INDEX IX_person_mon_id1 
        ON dwh.data_appointment (per_mon_id); 

 
        CREATE NONCLUSTERED INDEX IX_person_mon_x_first_mon_date1 
        ON dwh.data_appointment (per_mon_id, first_mon_date); 

    END;
GO