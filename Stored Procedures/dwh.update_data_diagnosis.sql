
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

	IF OBJECT_ID('tempdb..#temp_prob') IS NOT NULL
		DROP TABLE #temp_prob

CREATE TABLE #temp_dp(
	[per_mon_id] INT NULL,
	[person_key] INT NULL,
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
	[dx_prob_ind] CHAR(1) NULL, --To indicated Problem or Diagnosis
	[ng_data] INT NULL

)



--Insert Diagnosis into the #temptable
INSERT INTO #temp_dp
        ( per_mon_id ,
		  person_key,
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
		  eff_date,
          chronic_dx_label,
		  dx_prob_ind,
		  ng_data
        )
SELECT  DISTINCT
		app.per_mon_id, --To link to PHI Patient table
		app.person_key,
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
		'D' AS dx_prob_ind,
		1 AS ng_data
FROM  [10.183.0.94].NGProd.dbo.[patient_diagnosis] pd WITH (NOLOCK)
Left JOIN  [Prod_Ghost].[dwh].[data_appointment] app with (nolock) ON app.enc_id = pd.enc_id --[enc_appt_key] via enc_id, per_mon_id



SELECT
	  (SELECT TOP 1 person_key
		FROM dwh.data_person_dp_month dp
		WHERE dp.person_id = prob.person_id)
		AS person_key,
      person_id
      ,concept_id
      --,description
      ,fully_specified_name
      ,
	  -- **DQ** A number of problems have no valid onset date, so create date is used in these cases
	  CASE
			WHEN ISDATE(onset_date) = 1 THEN CAST(onset_date AS DATE)
			ELSE prob.create_timestamp
		END
			AS onset_date
      --,last_addressed_date
      ,CASE
			WHEN ISDATE(resolved_date) = 1 THEN CAST(resolved_date AS DATE)
			ELSE NULL
		END
			AS resolved_date,
	  prob.chronic_ind,
      prob.create_timestamp,
	  'P' AS dx_prob_ind,
	  1 AS ng_data,
	  CASE
		WHEN prob.concept_id LIKE '165816005'
			OR prob.concept_id LIKE '186723002'
            OR prob.concept_id LIKE '40780007'
            OR prob.concept_id LIKE '52079000'
            OR prob.concept_id LIKE '52448006'
            OR prob.concept_id LIKE '79019005'
            OR prob.concept_id LIKE '81000119104'
            OR prob.concept_id LIKE '86406008'
            OR prob.concept_id LIKE '91947003' THEN 'HIV'
        ELSE 'Unknown'
	  END
		AS chronic_dx_label
INTO #temp_prob
FROM [10.183.0.94].NGProd.dbo.patient_problems prob


--Insert Problem List
INSERT INTO #temp_dp
        ( per_mon_id,
		  person_key,
          person_id,
		  snomed_id,
		  snomed_name,
		  chronic_dx_label, 
		  eff_date ,
          thru_date ,
          chronic_ind ,
		  dx_create_date,
          dx_prob_ind,
		  ng_data
        )
SELECT 
	  --Now that onset date is set for all problems, we can use it to match for first_mon_date
	  (SELECT TOP 1 per_mon_id
		FROM dwh.data_person_dp_month per
		WHERE per.person_id=t.person_id
		AND per.first_mon_date = CAST(CONVERT(CHAR(6),t.onset_date,112)+'01' AS DATE)),
	  t.person_key,
	  t.person_id,
	  t.concept_id,
	  t.fully_specified_name,
	  t.chronic_dx_label,
	  t.onset_date,
	  t.resolved_date,
	  CASE
		WHEN t.chronic_ind = 'N' THEN 0
		ELSE 1
	  END
		AS chronic_ind,
	  t.create_timestamp,
	  t.dx_prob_ind,
	  t.ng_data
FROM #temp_prob t



INSERT INTO #temp_dp
        ( per_mon_id ,
          person_key ,
          enc_appt_key ,
          person_id_ecw,
          icd_code ,
          diag_name ,
          eff_date ,
          thru_date ,
          chronic_dx_label ,
          dx_prob_ind,
		  t.ng_data
        )
SELECT
	app.per_mon_id,
	app.person_key,
	app.enc_appt_key,
	d.person_id_ecw,
	d.icd_code_trimmed,
	d.diagnosis_description,
	CASE
		WHEN ISDATE(d.start_date) = 1 THEN CAST(d.start_date AS DATE)
		ELSE NULL
	END
		AS eff_date,
	CASE
		WHEN ISDATE(d.stop_date) = 1 THEN CAST(d.stop_date AS DATE)
		ELSE NULL
	END
		thru_date,
	d.chronic_dx_label,
	'D' AS dx_prob_ind,
	0 AS ng_data
FROM dwh.data_diagnosis_ecw d
LEFT JOIN dwh.data_appointment app ON app.enc_nbr = d.encounter_id_ecw AND app.ng_data = 0







SELECT
	IDENTITY(INT,1,1) AS dx_prob_key,
	dp.*
INTO dwh.data_diagnosis_problem
FROM #temp_dp dp

END
GO
