
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_patient_survey]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --allow for dirty reads

	IF OBJECT_ID('[fdt].[Fact and Dim Patient Experience]', 'U') IS NOT NULL
DROP TABLE [fdt].[Fact and Dim Patient Experience]




	SELECT sur.[survey_key]
      ,sur.[enc_num] AS [Enc Nbr]
      ,sur.[enc_appt_key]
	  ,loc.location_mstr_name AS Location
	  ,sur.survey_critical
      ,sur.[survey_q1] AS [Survey Q1]
      ,sur.[survey_q2]  AS [Survey Q2]
      ,sur.[survey_q3]  AS [Survey Q3]
      ,sur.[survey_q4]  AS [Survey Q4]
      ,sur.[survey_q5] AS  [Survey Q5]
      ,sur.[survey_q6]  AS [Survey Q6]
      ,sur.[survey_q7]  AS [Survey Q7]
	  ,sur.[survey_critical] AS [Survey Critical]
      ,sur.[q1_val] AS [Value Q1]
      ,sur.[q2_val]  AS [Value Q2]
      ,sur.[q3_val]  AS [Value Q3]
      ,sur.[q4_val]  AS [Value Q4]
      ,sur.[q5_val]  AS [Value Q5]
      ,sur.[q6_val]  AS [Value Q6]
      ,sur.[total_q1] AS [Total Q1]
      ,sur.[total_q2] AS [Total Q2]
      ,sur.[total_q3] AS [Total Q3]
      ,sur.[total_q4] AS [Total Q4]
      ,sur.[total_q5] AS [Total Q5]
      ,sur.[total_q6] AS [Total Q6]
      ,sur.[total_q7] AS [Total Q7]
      ,sur.[promoter]  AS [Total Promoters]
      ,sur.[detractor] AS [Total Detractors]
      ,sur.[comments]  AS [Comments]
      ,sur.[created] AS [Created]
  INTO [Prod_Ghost].[fdt].[Fact and Dim Patient Experience]
  FROM [Prod_Ghost].[dwh].[data_sp_patient_survey] sur
  LEFT JOIN [Prod_Ghost].[dwh].[data_appointment] app on sur.enc_appt_key=app.enc_appt_key
  LEFT JOIN [Prod_Ghost].[dwh].[data_location] loc on loc.location_key=app.appt_loc_key

  ALTER TABLE fdt.[Fact and Dim Patient Experience] ADD PRIMARY KEY (survey_key)











END
GO
