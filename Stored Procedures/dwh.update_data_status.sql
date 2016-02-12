
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_status]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

/****** Script for SelectTopNRows command from SSMS  ******/

/****** Script for SelectTopNRows command from SSMS  ******/


        IF OBJECT_ID('dwh.data_status') IS NOT NULL
            DROP TABLE dwh.data_status; 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @build_dt_start VARCHAR(8) ,
            @build_dt_end VARCHAR(8);
--set @build_dt_start = CONVERT(varchar(8), DATEADD(DAY,-1,cast(GETDATE() as date)),112) --This routine will build current and hx data from begin to end date 
        SET @build_dt_end = CONVERT(VARCHAR(8), DATEADD(DAY, -1, CAST(GETDATE() AS DATE)), 112);


        SET @build_dt_start = '20100301';

        WITH    StatusCategorize
                  AS ( SELECT   enc.rendering_provider_id ,
                                CAST (enc.checkin_datetime AS DATE) AS Checkin_Date ,
                                enc.location_id ,
                                pah.[person_id] ,
                                pah.[enc_id] ,
                                pah.[modified_by] status_user ,
                                pah.[modify_timestamp] AS status_datetime ,
                                pah.[txt_status] AS status_text ,
                                enc.checkin_datetime ,
                                CASE WHEN txt_status LIKE '%check%'
                                          AND txt_status NOT LIKE '%recheck%'
                                          AND txt_status NOT LIKE '%MA in Room%' THEN 2 --'CheckOut'
                                     WHEN txt_status LIKE '%provider%'
                                          AND txt_status NOT LIKE '%check%'
                                          AND txt_status NOT LIKE '%wait%' THEN 1--'ReadyProvider'
                                     WHEN txt_status LIKE '%charted%' THEN 3--'Charted'
                                     ELSE 4 --'Unknown'
                                END AS status_category
                       FROM     [10.183.0.94].NGProd.dbo.[pat_apt_status_hx_] pah
                                INNER JOIN [10.183.0.94].NGProd.dbo.patient_encounter enc ON pah.enc_id = enc.enc_id
                       WHERE    ( CAST(enc.checkin_datetime AS DATE) >= ( CAST(@build_dt_start AS DATE) ) )
                                AND ( CAST(enc.checkin_datetime AS DATE) <= CAST(@build_dt_end AS DATE) )
                     ),
                statusorg
                  AS ( SELECT   rendering_provider_id ,
                                location_id ,
                                [person_id] ,
                                [enc_id] ,
                                status_text ,
                                status_user ,
                                Checkin_Date ,
                                checkin_datetime ,
                                status_datetime ,
                                status_category ,
                                rank_order_old_first = ROW_NUMBER() OVER ( PARTITION BY enc_id, status_category ORDER BY status_datetime DESC ) , --Only grab the last of the same type of status msg
                                rank_order_new_first = ROW_NUMBER() OVER ( PARTITION BY enc_id, status_category ORDER BY status_datetime ASC )
                       FROM     StatusCategorize
                     ),
                statusfilter
                  AS ( SELECT   rendering_provider_id ,
                                [enc_id] ,
                                [person_id] ,
                                location_id ,
                                [status_user] ,
                                checkin_datetime ,
                                Checkin_Date ,
                                [status_datetime] ,
                                [status_text] ,
                                [status_category] ,
                                DATEDIFF(mi, checkin_datetime, status_datetime) AS Min_Kept_to_StatusUpdate ,
                                ( DATEDIFF(mi, checkin_datetime, status_datetime)
                                  - LAG(DATEDIFF(mi, checkin_datetime, status_datetime), 1, 0) OVER ( PARTITION BY enc_id ORDER BY status_datetime ) ) AS Min_Since_Last_StatusUpdate
                       FROM     statusorg x
                       WHERE    ( status_category = 1
                                  AND rank_order_new_first = 1
                                )
                                OR ( status_category = 2
                                     AND rank_order_old_first = 1
                                   )
                                OR ( status_category = 3
                                     AND rank_order_old_first = 1
                                   )
                     ),
                unique_enc
                  AS ( SELECT DISTINCT
                                enc_id ,
                                person_id ,
                                location_id ,
                                Checkin_Date ,
                                rendering_provider_id
                       FROM     statusfilter
                     ),
                statusfinal
                  AS ( SELECT   d.* ,
                                COALESCE(st1.Min_Kept_to_StatusUpdate, 0) AS cycle_min_Kept_readyforprovider ,
                                COALESCE(st2.Min_Kept_to_StatusUpdate, 0) AS cycle_min_kept_checkedout ,
                                COALESCE(st3.Min_Kept_to_StatusUpdate, 0) AS cycle_min_kept_charted ,
                                COALESCE(st4.Min_Since_Last_StatusUpdate, 0) AS cycle_min_readyforprovider_checkout ,
                                st1.status_user AS user_readyforprovider ,
                                st2.status_user AS user_checkout ,
                                st3.status_user AS user_charted
                

				--1 Ready for Provider
				--2 Checked out or Ready for Checkout
				--3 Charted
                       FROM     unique_enc d
                                LEFT JOIN ( SELECT  [enc_id] ,
                                                    [status_user] ,
                                                    [Min_Kept_to_StatusUpdate]
                                            FROM    statusfilter
                                            WHERE   status_category = 1
                                          ) st1 ON d.enc_id = st1.enc_id
                                LEFT JOIN ( SELECT  [enc_id] ,
                                                    [status_user] ,
                                                    [Min_Kept_to_StatusUpdate]
                                            FROM    statusfilter
                                            WHERE   status_category = 2
                                          ) st2 ON d.enc_id = st2.enc_id
                                LEFT JOIN ( SELECT  [enc_id] ,
                                                    [status_user] ,
                                                    [Min_Kept_to_StatusUpdate]
                                            FROM    statusfilter
                                            WHERE   status_category = 3
                                          ) st3 ON d.enc_id = st3.enc_id
                                LEFT JOIN ( SELECT  [enc_id] ,
                                                    [status_user] ,
                                                    [Min_Since_Last_StatusUpdate]
                                            FROM    statusfilter
                                            WHERE   status_category = 2
                                          ) st4 ON d.enc_id = st4.enc_id
                     )
           
		   --Data DQ cleaning cycle time
		    SELECT  x.Checkin_Date ,
                    CASE WHEN x.cycle_min_Kept_readyforprovider >= 480 --Throw away anything that is over 8 hours
                              OR x.cycle_min_Kept_readyforprovider < 0 THEN NULL ELSE x.cycle_min_Kept_readyforprovider
                    END AS cycle_min_kept_readyforprovider ,
                    CASE WHEN x.cycle_min_kept_checkedout >= 480   --Throw away anything that is over 8 hours
                              OR x.cycle_min_kept_checkedout < 0 THEN NULL ELSE x.cycle_min_kept_checkedout
                    END AS cycle_min_kept_checkedout ,
                    CASE WHEN x.cycle_min_kept_charted >= ( 24 * 60 * 14 ) -- Throw away anything over 2 weeks
                              OR x.cycle_min_kept_charted < 0 THEN NULL ELSE x.cycle_min_kept_charted 
                    END AS cycle_min_kept_charted ,
                    CASE WHEN x.cycle_min_readyforprovider_checkout >= 480 --Throw away anything that is over 8 hours
                              OR x.cycle_min_readyforprovider_checkout < 0 THEN NULL ELSE x.cycle_min_readyforprovider_checkout
                    END AS cycle_min_readyforprovider_checkout ,
                    x.enc_id ,
                    ( SELECT TOP 1
                                enc_key
                      FROM      dwh.data_encounter de
                      WHERE     de.enc_id = x.enc_id
                                AND x.enc_id IS NOT NULL
                    ) AS enc_key ,
                    ( SELECT TOP 1
                                user_key
                      FROM      dwh.data_user du
                      WHERE     x.user_readyforprovider = du.user_id
                                AND x.user_readyforprovider IS NOT NULL
                    ) AS user_readyforprovider ,
                    ( SELECT TOP 1
                                user_key
                      FROM      dwh.data_user du
                      WHERE     x.user_checkout = du.user_id
                                AND x.user_checkout IS NOT NULL
                    ) AS user_checkout ,
                    ( SELECT TOP 1
                                user_key
                      FROM      dwh.data_user du
                      WHERE     x.user_charted = du.user_id
                                AND x.user_charted IS NOT NULL
                    ) AS user_charted
            INTO    dwh.data_status
            FROM    statusfinal x;


        ALTER TABLE Prod_Ghost.dwh.data_status
        ALTER COLUMN enc_key INTEGER NOT NULL;

        ALTER TABLE Prod_Ghost.dwh.data_status
        ADD CONSTRAINT enc_key_pk20 PRIMARY KEY (enc_key);
  
		

    END;

					 


GO
