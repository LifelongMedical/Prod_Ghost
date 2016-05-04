SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife>
-- Create date: <Create Date,,2/25/2016>
-- Description:	<Description,,crea>
-- =============================================


--Notes
-- =============================================
--Dependencies
-- 
-- =============================================


--Updates
-- =============================================
-- 4/25/2016 HD added Recency
-- =============================================
CREATE  PROCEDURE [fdt].[update_case_managment]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --Allow for dirty reads
	
        IF OBJECT_ID('fdt.[Fact and Dim CMT Action Plan]') IS NOT NULL
            DROP TABLE fdt.[Fact and Dim CMT Action Plan];
	
        IF OBJECT_ID('fdt.[Fact and Dim CMT Alert]') IS NOT NULL
            DROP TABLE fdt.[Fact and Dim CMT Alert];

		 IF OBJECT_ID('fdt.[Fact and Dim CMT History Services]') IS NOT NULL
            DROP TABLE fdt.[Fact and Dim History Services];
	--Action Plan
		SELECT 
		[per_mon_id]
      ,[first_mon_date]
      ,[Goal]
      ,[Status]
      ,[Priority Area]
      ,[Completed Date]
      ,[Service Date]
      ,[Create_Time]
	  ,[Recency]
	  INTO fdt.[Fact and Dim CMT Action Plan]
  FROM [Prod_Ghost].[dwh].[data_action_plan]

  SELECT [per_mon_id]
      ,[first_mon_date]
      ,[Date of Service]
      ,[Staff FullName]
      ,[Services/Referrals Provided]
      ,[Notes]
      ,[Resource Type]
      ,[Service Type]
      ,[Interpreter Service]
      ,[Referral Placed]
      ,[Time Spent]
      ,[Internal Referral]
      ,[Created Date]
	  ,[Recency]
	INTO fdt.[Fact and Dim CMT History Services]
  FROM [Prod_Ghost].[dwh].[data_history_services]

  --Case Managment Main Template
  SELECT  [per_mon_id]
      ,[first_mon_date]
      ,[Enc Id]
      ,[Case Management Status Active]
      ,[Case Management Status Inactive]
      ,[Inactive Date]
      ,[Referal From Outsite Lifelong]
      ,[Ambulatory Disability]
      ,[Cognitive Disability]
      ,[Homelessness-Current]
      ,[Self-Care Disability]
      ,[AOD Use/Abuse - History*]
      ,[Complex Medical Needs]
      ,[Homelessness-History]
      ,[Trauma/Abuse-History]
      ,[AOD Use/Abuse - Current*]
      ,[Violence/Abuse-Current]
      ,[Independent Living Disability*]
      ,[Migrant/Seasonal Worker]
      ,[Behavioral Health Dx]
      ,[ED-High Utilizer]
      ,[Incarceration History]
      ,[Low Literacy]
      ,[Chronic Disease Dx]
      ,[Hearing Disability*]
      ,[Visual Disability*]
      ,[Language Prefered Not English]
      ,[Staff FullName]
      ,[Comment]
	  ,[Recency]
  INTO  fdt.[Fact and Dim CMT Alert]
  FROM [Prod_Ghost].[dwh].[data_case_managment]


    
	
END
GO
