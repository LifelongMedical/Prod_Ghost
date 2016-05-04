
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Julius Abate>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_dim_diagnosis]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --Allow for dirty reads

	IF OBJECT_ID('fdt.[Dim Diagnosis and Problem]') IS NOT NULL
		DROP TABLE fdt.[Dim Diagnosis and Problem]

	IF OBJECT_ID('fdt.[Bridge Diagnosis Problem]') IS NOT NULL
		DROP TABLE fdt.[Bridge Diagnosis Problem]

    SELECT [dx_prob_key]
      ,[per_mon_id]
	  ,[person_key]
      ,[enc_appt_key]
      ,[icd_code] AS [ICD Code]
      ,[diag_name] AS [Dx Name]
      ,[diag_full_name] AS [Dx Long]
      ,[chronic_ind] AS [Chronic Dx]
      ,[dx_create_date] AS [Diagnosis Date]
      ,[eff_date] AS [Problem Effective Date]
      ,[thru_date] AS [Problem Resolution Date]
      ,[snomed_id] AS [Snomed ID]
      ,[snomed_name] AS [Snomed Name]
      ,[chronic_dx_label] AS [Chronic Dx Label]
      ,[dx_status] AS [Dx NG Status]
      ,[dx_prob_ind] AS [Dx or Problem]
  INTO fdt.[Dim Diagnosis and Problem]
  FROM [Prod_Ghost].[dwh].[data_diagnosis_problem]


  SELECT
	dx_prob_key,
	per_mon_id,
	person_key
  INTO fdt.[Bridge Diagnosis Problem]
  FROM dwh.data_diagnosis_problem


END
GO
