SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Julius Abate>
/* Description:	
	Dependant on dwh.data_appointment
	5 min run

*/
-- =============================================
CREATE PROCEDURE [dwh].[update_data_diagnosis_problems]
AS
  BEGIN 



        --DECLARE @build_dt_start VARCHAR(8) ,
        --    @build_dt_end VARCHAR(8) ,
        --    @Build_counter VARCHAR(8);

        --SET @build_dt_start = CONVERT(VARCHAR(8), GETDATE(), 112); --This routine will build current and hx data from begin to end date 
        --SET @build_dt_end = CONVERT(VARCHAR(8), GETDATE(), 112);

        --SET @build_dt_start = '20100101';
--set @build_dt_end =   '20100202'

--set @build_dt_end =   '20150701'


 
        IF OBJECT_ID('dwh.data_diagnosis') IS NOT NULL
            DROP TABLE dwh.data_diagnosis;

		
        IF OBJECT_ID('dwh.data_problem_list') IS NOT NULL
            DROP TABLE dwh.data_problem_list;

		IF OBJECT_ID('tempdb..#temp_problem_list') IS NOT NULL
            DROP TABLE #temp_problem_list;

		
        IF OBJECT_ID('tempdb..#temp_diagnosis') IS NOT NULL
            DROP TABLE #temp_diagnosis;



        SELECT  DISTINCT
				app.per_mon_id, --To link to PHI Patient table
				app.enc_appt_key, --To link to Appointment table
				app.location_key,
				app.provider_key,
				pd.enc_id,
                CAST(CONVERT(CHAR(6), pd.create_timestamp, 112) + '01' AS DATE) AS first_mon_date ,
                pd.[create_timestamp],
                pd.diagnosis_code_id, --icd code
                COALESCE(pd.[description],'') AS ICD9_Name ,
				CASE
					WHEN pd.chronic_ind = 'Y' THEN 1 ELSE 0 
				END 
					AS chronic_ind,
                pd.[person_id],
                pd.[location_id] ,
                pd.[provider_id] ,
				pd.snomed_concept_id,
				pd.snomed_fully_specified_name,
                COALESCE(CONCAT(pd.[diagnosis_code_id], ' - ', pd.[description]),'') AS Diag_Full_Name
        INTO    #temp_diagnosis
        FROM    [10.183.0.94].NGProd.dbo.[patient_diagnosis] pd WITH (NOLOCK)
		Left JOIN  [Prod_Ghost].[dwh].[data_appointment] app with (nolock) ON app.enc_id = pd.enc_id --[enc_appt_key] via enc_id, per_mon_id
--        WHERE   ( pd.create_timestamp >= CAST(@build_dt_start AS DATE) )
--                AND ( pd.create_timestamp <= CAST(@build_dt_end AS DATE) );
--;

--Create temp problem list
SELECT DISTINCT
	pd.enc_id,
	app.per_mon_id --To link to PHI Patient table
	,app.enc_appt_key --To link to Appointment table
	,CASE 	
		WHEN IsDate(date_diagnosed) = 1 and IsNull(date_diagnosed,'') != '' THEN    CONVERT(DATETIME,pd.date_diagnosed) 
		WHEN IsDate(date_onset_sympt) = 1 and IsNull(date_onset_sympt,'') != '' THEN    CONVERT(DATETIME,pd.date_onset_sympt)
		ELSE DATEADD(dd, DATEDIFF(dd, 0, pe.enc_timestamp), 0)
	END eff_dt
	,convert(datetime, case when date_resolved = '' then '29991231' else date_resolved end) thru_dt
	,pd.diagnosis_code_id --icd code
	,pd.description icd9_description
	,pd.created_by
	,pd.provider_id
INTO #temp_problem_list
FROM [10.183.0.94].[NGProd].dbo.patient_diagnosis pd with (nolock) 
LEFT JOIN  [Prod_Ghost].[dwh].[data_appointment] app with (nolock) ON app.enc_id = pd.enc_id --[enc_appt_key] via enc_id, per_mon_id
INNER  JOIN  [10.183.0.94].[NGProd].[dbo].[patient_encounter] pe with (nolock) on pd.enc_id = pe.enc_id
--INNER  JOIN  [10.183.0.94].[NGProd].dbo.patient p with (nolock) on pd.person_id = p.person_id
--LEFT JOIN dwh.data_diagnosis diag with (nolock) ON diag.enc_id = pd.enc_id
 where 
pd.icd9cm_code_id <> ''
and pd.practice_id in ('0001','0002')






--DWH Diagnosis Table
 SELECT  
				IDENTITY( INT, 1, 1 )  AS Dx_key ,
				d.per_mon_id, --To link to PHI Patient table
				d.enc_appt_key, --To link to Appointment table
				d.enc_id,
                d.ICD9_Name ,
				d.diagnosis_code_id AS diagnosis_code,
				d.chronic_ind,
				CASE
					WHEN d.chronic_ind = 1 THEN 'Chronic'
					ELSE 'Acute'
				END
					AS dx_status,
                d.person_id,
                d.location_id ,
                d.provider_id ,
				d.snomed_concept_id,
				d.snomed_fully_specified_name,
                d.Diag_Full_Name,
				--Flag is 1 if ICD code falls in range for Diabetes mellitus
				--Does not cover entire range of diabetes
				CASE
					WHEN d.diagnosis_code_id LIKE '250%' THEN 1
					WHEN d.diagnosis_code_id LIKE 'E10.%' THEN 1
					WHEN d.diagnosis_code_id LIKE 'E11.%' THEN 1
					ELSE 0
				END
					AS diabetes_flag,
				----Flag is 1 if ICD code is in hypertension range
				CASE
					WHEN d.diagnosis_code_id LIKE '401%' THEN 1
					WHEN d.diagnosis_code_id LIKE '402%' THEN 1
					WHEN d.diagnosis_code_id LIKE 'I10.%' THEN 1
					WHEN d.diagnosis_code_id LIKE 'I11.%' THEN 1
					ELSE 0
				END
					AS hypertension_flag,
				--Flag is 1 if ICD code is in HIV range
				CASE
					WHEN d.diagnosis_code_id LIKE 'B20%'THEN 1
					WHEN d.diagnosis_code_id LIKE 'B21%'THEN 1
					WHEN d.diagnosis_code_id LIKE 'B22%'THEN 1
					WHEN d.diagnosis_code_id LIKE 'B23%'THEN 1
					WHEN d.diagnosis_code_id LIKE 'B24%'THEN 1
					WHEN d.diagnosis_code_id LIKE '042%'THEN 1
					WHEN d.diagnosis_code_id LIKE 'V08%'THEN 1 --Asymptomatic HIV
					WHEN d.diagnosis_code_id LIKE '079.53'THEN 1 --For HIV-2
					--WHEN d.diagnosis_code_id LIKE '795.71' THEN 1 --Inconclusive HIV Test, possibly requires its own flag
					ELSE 0
				END
					AS hiv_flag
        INTO    dwh.data_diagnosis
        FROM    #temp_diagnosis d
		Left JOIN  [Prod_Ghost].[dwh].[data_appointment] app with (nolock) ON app.enc_id = d.enc_id --[enc_appt_key] via enc_id, per_mon_id
        
;

--DWH Problem List
SELECT 
	IDENTITY( INT, 1, 1 )  AS prob_key,
	diag.Dx_key,
	pl.enc_id,
	app.per_mon_id --To link to PHI Patient table
	,app.enc_appt_key --To link to Appointment table
	,pl.eff_dt
	,pl.thru_dt
	,pl.diagnosis_code_id AS diagnosis_code
	,pl.icd9_description
	,pl.created_by
	,pl.provider_id,
	CASE
		WHEN pl.diagnosis_code_id LIKE '250%' THEN 1
		WHEN pl.diagnosis_code_id LIKE 'E10.%' THEN 1
		WHEN pl.diagnosis_code_id LIKE 'E11.%' THEN 1
		ELSE 0
	END
		AS diabetes_flag,
	----Flag is 1 if ICD code is in hypertension range
	CASE
		WHEN pl.diagnosis_code_id LIKE '401%' THEN 1
		WHEN pl.diagnosis_code_id LIKE '402%' THEN 1
		WHEN pl.diagnosis_code_id LIKE 'I10.%' THEN 1
		WHEN pl.diagnosis_code_id LIKE 'I11.%' THEN 1
		ELSE 0
	END
		AS hypertension_flag,
	CASE
		WHEN pl.diagnosis_code_id LIKE 'B20%'THEN 1
		WHEN pl.diagnosis_code_id LIKE 'B21%'THEN 1
		WHEN pl.diagnosis_code_id LIKE 'B22%'THEN 1
		WHEN pl.diagnosis_code_id LIKE 'B23%'THEN 1
		WHEN pl.diagnosis_code_id LIKE 'B24%'THEN 1
		WHEN pl.diagnosis_code_id LIKE '042%'THEN 1
		WHEN pl.diagnosis_code_id LIKE 'V08%'THEN 1 --Asymptomatic HIV
		WHEN pl.diagnosis_code_id LIKE '079.53'THEN 1 --For HIV-2
		--WHEN pl.diagnosis_code_id LIKE '795.71' THEN 1 --Inconclusive HIV Test, possibly requires its own flag
		ELSE 0
	END
		AS hiv_flag,
	diag.chronic_ind,
	CASE
		WHEN diag.chronic_ind = 1 THEN 'Chronic'
		ELSE 'Acute'
	END
		AS dx_status
INTO dwh.data_problem_list
FROM #temp_problem_list pl with (nolock) 
LEFT JOIN  [Prod_Ghost].[dwh].[data_appointment] app with (nolock) ON app.enc_id = pl.enc_id --[enc_appt_key] via enc_id, per_mon_id
--INNER  JOIN  [10.183.0.94].[NGProd].[dbo].[patient_encounter] pe with (nolock) on pd.enc_id = pe.enc_id
--INNER  JOIN  [10.183.0.94].[NGProd].dbo.patient p with (nolock) on pd.person_id = p.person_id
LEFT JOIN dwh.data_diagnosis diag with (nolock) ON diag.enc_id = pl.enc_id AND diag.diagnosis_code = pl.diagnosis_code_id




    END;
GO
