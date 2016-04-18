SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Julius Abate>
-- Create date: <April 9, 2016>
/* Description:	Table holds both Diagnosis and
Problem list, the different rows can be identified
by 'D' or 'P' in the dx_prob_ind column

*/
-- =============================================
CREATE PROCEDURE [dwh].[update_data_diagnosis]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --Allow for dirty reads

    IF OBJECT_ID('dwh.data_diagnosis_problem') IS NOT NULL
	DROP TABLE dwh.data_diagnosis_problem

IF OBJECT_ID('tempdb..#temp_dp') IS NOT NULL
	DROP TABLE #temp_dp

CREATE TABLE #temp_dp(
	[per_mon_id] INT NULL,
	[enc_appt_key] INT NULL,
	[enc_id] UNIQUEIDENTIFIER NULL,
	[person_id] UNIQUEIDENTIFIER NULL,
	[person_id_ecw] INT NULL,
	[icd_code] VARCHAR(10) NULL,
	[diag_name] VARCHAR(255) NULL,
	[diag_full_name] VARCHAR(255) NULL,
	[chronic_ind] INT NULL,
	[dx_create_date] DATETIME NULL,
	[eff_date] DATETIME NULL,
	[thru_date] DATETIME NULL,
	[snomed_id] VARCHAR(18) NULL,
	[snomed_name] varchar(255) NULL,
	[chronic_dx_label] VARCHAR(50) NULL,
	[dx_status] VARCHAR(7) NULL, --Indicate Acute vs Chronic
	[dx_prob_ind] CHAR(1) NULL --To indicated Problem or Diagnosis

)



--Insert Diagnosis into the #temptable
INSERT INTO #temp_dp
        ( per_mon_id ,
          enc_appt_key ,
          enc_id ,
          person_id ,
          icd_code ,
          diag_name ,
		  diag_full_name,
          chronic_ind ,
		  dx_status,
          snomed_id ,
          snomed_name ,
		  dx_create_date,
          chronic_dx_label,
		  dx_prob_ind
        )
SELECT  DISTINCT
		app.per_mon_id, --To link to PHI Patient table
		app.enc_appt_key, --To link to Appointment table
		pd.enc_id,
		pd.person_id,
		pd.diagnosis_code_id, --icd code
		COALESCE(pd.[description],'') AS diag_name ,
		COALESCE(CONCAT(pd.diagnosis_code_id, ' - ', pd.description),'') AS diag_full_name,
		CASE
			WHEN pd.chronic_ind = 'Y' THEN 1 ELSE 0 
		END 
			AS chronic_ind,
		CASE
			WHEN pd.chronic_ind = 'Y' THEN 'Chronic' ELSE 'Acute'
		END 
			AS dx_status,
		pd.snomed_concept_id,
		pd.snomed_fully_specified_name,
        pd.create_timestamp,
		--Match Chronic diseases to ICD codes, only tracking Htn, DM, and HIV currently
		CASE
			WHEN pd.diagnosis_code_id LIKE '250%' THEN 'Diabetes'
			WHEN pd.diagnosis_code_id LIKE 'E10.%' THEN 'Diabetes'
			WHEN pd.diagnosis_code_id LIKE 'E11.%' THEN 'Diabetes'
			WHEN pd.diagnosis_code_id LIKE '401%' THEN 'Hypertension'
			WHEN pd.diagnosis_code_id LIKE '402%' THEN 'Hypertension'
			WHEN pd.diagnosis_code_id LIKE 'I10.%' THEN 'Hypertension'
			WHEN pd.diagnosis_code_id LIKE 'I11.%' THEN 'Hypertension'
			WHEN pd.diagnosis_code_id LIKE 'B20%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'B21%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'B22%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'B23%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'B24%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE '042%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'V08%'THEN 'HIV' --Asymptomatic HIV
			WHEN pd.diagnosis_code_id LIKE '079.53'THEN 'HIV' --For HIV-2
			--WHEN d.diagnosis_code_id LIKE '795.71' THEN 1 --Inconclusive HIV Test, possibly requires its own flag
			ELSE NULL
		END
			AS chronic_dx_label,
		--Indication field to marke whether a diagnosis or a problem
		'D' AS dx_prob_ind
FROM  [10.183.0.94].NGProd.dbo.[patient_diagnosis] pd WITH (NOLOCK)
Left JOIN  [Prod_Ghost].[dwh].[data_appointment] app with (nolock) ON app.enc_id = pd.enc_id --[enc_appt_key] via enc_id, per_mon_id


--Insert Problem List
INSERT INTO #temp_dp
        ( per_mon_id ,
          enc_appt_key ,
          enc_id ,
          person_id, 
		  eff_date ,
          thru_date ,
          icd_code ,
          diag_name ,
          diag_full_name ,
          chronic_ind ,
		  dx_status,
          dx_create_date ,
          chronic_dx_label ,
          dx_prob_ind
        )
SELECT DISTINCT
	app.per_mon_id, --To link to PHI Patient table
	app.enc_appt_key, --To link to Appointment table
	pd.enc_id,
	pd.person_id,
	CASE 	
		WHEN IsDate(date_diagnosed) = 1 and IsNull(date_diagnosed,'') != '' THEN    CONVERT(DATETIME,pd.date_diagnosed) 
		WHEN IsDate(date_onset_sympt) = 1 and IsNull(date_onset_sympt,'') != '' THEN    CONVERT(DATETIME,pd.date_onset_sympt)
		ELSE DATEADD(dd, DATEDIFF(dd, 0, pe.enc_timestamp), 0)
	END 
		AS eff_dt,

	CONVERT(datetime, case when date_resolved = '' then '29991231' else date_resolved end) AS thru_dt,
	pd.diagnosis_code_id, --icd code
	COALESCE(pd.[description],'') AS diag_name ,
	COALESCE(CONCAT(pd.diagnosis_code_id, ' - ', pd.description),'') AS diag_full_name,
	--Using NextGen flag in this case, which appears to be untrustworthy
	CASE
		WHEN pd.chronic_ind = 'Y' THEN 1 ELSE 0 
	END 
		AS chronic_ind,
	CASE
		WHEN pd.chronic_ind = 'Y' THEN 'Chronic' ELSE 'Acute'
	END 
		AS dx_status,
	pd.create_timestamp,
		CASE
			WHEN pd.diagnosis_code_id LIKE '250%' THEN 'Diabetes'
			WHEN pd.diagnosis_code_id LIKE 'E10.%' THEN 'Diabetes'
			WHEN pd.diagnosis_code_id LIKE 'E11.%' THEN 'Diabetes'
			WHEN pd.diagnosis_code_id LIKE '401%' THEN 'Hypertension'
			WHEN pd.diagnosis_code_id LIKE '402%' THEN 'Hypertension'
			WHEN pd.diagnosis_code_id LIKE 'I10.%' THEN 'Hypertension'
			WHEN pd.diagnosis_code_id LIKE 'I11.%' THEN 'Hypertension'
			WHEN pd.diagnosis_code_id LIKE 'B20%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'B21%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'B22%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'B23%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'B24%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE '042%'THEN 'HIV'
			WHEN pd.diagnosis_code_id LIKE 'V08%'THEN 'HIV' --Asymptomatic HIV
			WHEN pd.diagnosis_code_id LIKE '079.53'THEN 'HIV' --For HIV-2
			--WHEN d.diagnosis_code_id LIKE '795.71' THEN 1 --Inconclusive HIV Test, possibly requires its own flag
			ELSE NULL
		END
			AS chronic_dx_label,
		'P' AS dx_prob_ind

FROM [10.183.0.94].[NGProd].dbo.patient_diagnosis pd with (nolock) 
LEFT JOIN  [Prod_Ghost].[dwh].[data_appointment] app with (nolock) ON app.enc_id = pd.enc_id --[enc_appt_key] via enc_id, per_mon_id
INNER  JOIN  [10.183.0.94].[NGProd].[dbo].[patient_encounter] pe with (nolock) on pd.enc_id = pe.enc_id
WHERE pd.icd9cm_code_id <> ''
AND pd.practice_id in ('0001','0002')


SELECT
	IDENTITY(INT,1,1) AS dx_prob_key,
	dp.*
INTO dwh.data_diagnosis_problem
FROM #temp_dp dp

END
GO
