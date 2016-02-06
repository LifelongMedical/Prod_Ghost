SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_diagnosis]
AS
    BEGIN
/****** Script for SelectTopNRows command from SSMS  ******/

--Build Diagnoses DataMart

        DECLARE @build_dt_start VARCHAR(8) ,
            @build_dt_end VARCHAR(8) ,
            @Build_counter VARCHAR(8);

        SET @build_dt_start = CONVERT(VARCHAR(8), GETDATE(), 112); --This routine will build current and hx data from begin to end date 
        SET @build_dt_end = CONVERT(VARCHAR(8), GETDATE(), 112);

        SET @build_dt_start = '20100101';
--set @build_dt_end =   '20100202'

--set @build_dt_end =   '20150701'


 
        IF OBJECT_ID('dwh.data_diagnosis') IS NOT NULL
            DROP TABLE dwh.data_diagnosis;


        SELECT  CAST(CONVERT(CHAR(6), pd.[create_timestamp], 112) + '01' AS DATE) AS first_mon_date ,
                pd.[create_timestamp] ,
                IDENTITY( INT, 1, 1 )  AS Dx_key,
                pd.[diagnosis_code_id] ,
                COALESCE(pd.[description], '') AS ICD9_Name ,
                ( SELECT    per_mon_id
                  FROM      dwh.data_person_nd_month dpm
                  WHERE     dpm.person_id = pd.person_id
                            AND CAST(CONVERT(CHAR(6), pd.[create_timestamp], 112) + '01' AS DATE) = dpm.first_mon_date
                ) AS per_mon_id ,
                ( SELECT    enc_appt_key
                  FROM      dwh.data_appointment da
                  WHERE     pd.enc_id = da.enc_id
                ) AS enc_appt_key ,
                ( SELECT TOP 1
                            location_key
                  FROM      dwh.data_location dl
                  WHERE     pd.location_id = dl.[location_id]
                            AND [location_id_unique_flag] = 1
                ) AS location_key ,
                ( SELECT   TOP 1 du.user_key
                  FROM      dwh.data_user du
                  WHERE     pd.provider_id = du.provider_id and unique_provider_id_flag=1
				  order by unique_provider_id_flag,unique_resource_id_flag,unique_user_id_flag
                ) AS provider_key ,
                COALESCE(CONCAT(pd.[diagnosis_code_id], ' - ', pd.[description]), '') AS Diag_Full_Name ,
                pd.snomed_concept_id ,
                pd.snomed_fully_specified_name ,
                pd.created_by ,
                pd.note
        INTO    dwh.data_diagnosis
        FROM    [10.183.0.94].NGProd.dbo.[patient_diagnosis] pd
                LEFT JOIN [10.183.0.94].NGProd.dbo.diagnosis_status_mstr ds ON pd.status_id = ds.status_id
                -- previously had added join to location table as some bad records introduced with poor location data
        WHERE   ( pd.create_timestamp >= CAST(@build_dt_start AS DATE) )
                AND ( pd.create_timestamp <= CAST(@build_dt_end AS DATE) );





--ALT Version
/*select 
med_rec_nbr + 0 prt_no
,case	when IsDate(date_diagnosed) = 1 and IsNull(date_diagnosed,'') != '' then   convert(datetime,pd.date_diagnosed) 
		when IsDate(date_onset_sympt) = 1 and IsNull(date_onset_sympt,'') != '' then   convert(datetime,pd.date_onset_sympt)
		else DATEADD(dd, DATEDIFF(dd, 0, enc_timestamp), 0)
end eff_dt
,convert(datetime, case when date_resolved = '' then '29991231' else date_resolved end) thru_dt
,icd9cm_code_id icd9_code
,Desc_txt icd9_description
, pd.created_by, pd.provider_id
into #diag
from PacelinkDW.patient_diagnosis pd with (nolock) 
inner join PacelinkDW.patient_encounter pe with (nolock) on pd.enc_id = pe.enc_id
inner join PacelinkDW.patient p with (nolock) on pd.person_id = p.person_id and p.med_rec_nbr + 0 > 100
Join   DW.Diag_Ref r on r.Diag_Cd = pd.icd9cm_code_id
 where 
icd9cm_code_id <> ''
and pd.practice_id in ('0001','0002')
*/


    END;
GO
