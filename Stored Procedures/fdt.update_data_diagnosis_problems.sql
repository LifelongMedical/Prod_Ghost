SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Julius Abate>
-- Create date: <March 22, 2016>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_data_diagnosis_problems]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF OBJECT_ID('fdt.[Fact and Dim Diagnosis]') IS NOT NULL 
		DROP TABLE fdt.[Fact and Dim Diagnosis]

	IF OBJECT_ID('fdt.[Fact and Dim Problem List]') IS NOT NULL
		DROP TABLE fdt.[Fact and Dim Problem List]

--Create Fact and Dim table for Diagnosis
SELECT [Dx_key]
      ,[per_mon_id]
      ,[enc_appt_key]
      ,[ICD9_Name] AS [Diagnosis]
      ,[diagnosis_code] AS [Dx Code]
      ,[chronic_ind] AS [Chronic Dx]
      ,[dx_status] AS [Dx Status]
      ,[snomed_concept_id] AS [Snomed ID]
      ,[snomed_fully_specified_name] AS [Snomed Name]
      ,[Diag_Full_Name] AS [Full Diagnosis]
      ,[diabetes_flag] AS [Diabetes Dx Count]
      ,[hypertension_flag] AS [Hypertension Dx Count]
      ,[hiv_flag] AS [HIV Dx Count]
  INTO fdt.[Fact and Dim Diagnosis]
  FROM [Prod_Ghost].[dwh].[data_diagnosis]


--Create fact and dim table for Problem List
SELECT [prob_key]
      ,[Dx_key]
      ,[enc_id]
      ,[per_mon_id]
      ,[enc_appt_key]
      ,[eff_dt] AS [Dx Onset Date]
      ,[thru_dt] AS [Dx Resolution Date]
      ,[diagnosis_code] AS [Dx Code]
      ,[icd9_description] AS [Diagnosis]
      ,[diabetes_flag] AS [Diabetes Dx Count] 
      ,[hypertension_flag] AS [Hypertension Dx Count]
      ,[hiv_flag] AS [HIV Dx Count]
      ,[chronic_ind] AS [Chronic Dx]
      ,[dx_status] AS [Dx Status]
  INTO fdt.[Fact and Dim Problem List]
  FROM [Prod_Ghost].[dwh].[data_problem_list]

  ALTER TABLE fdt.[Fact and Dim Problem List] ADD PRIMARY KEY(prob_key)
  ALTER TABLE fdt.[Fact and Dim Diagnosis] ADD PRIMARY KEY(Dx_key)


END
GO
