SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife Doganay>
-- Create date: <Create Date,,4/14/2016>
-- Description:	<Description,,PAQ Fact and Dim Table>
-- =============================================

--Notes
-- =============================================
--
-- =============================================

--Updates
-- =============================================
--
-- =============================================

CREATE PROCEDURE [fdt].[update_PAQ] 
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET transaction isolation level read UNCOMMITTED;


	   IF OBJECT_ID('fdt.[Fact And Dim PAQ]') IS NOT NULL
            DROP TABLE fdt.[Fact And Dim PAQ];
	SELECT 
	   [paq_key] = IDENTITY( INT,1,1 )
	   ,[item_type]
      ,[item_id]
      ,[provider_key]
      ,[per_mon_id]
      ,[enc_appt_key]
	  ,user_key
      ,[item_name]
      ,[created_by]
      ,[modified_by]
      ,[signoff_user_id]
      ,[signoff_action]
      ,[signoff_desc]
      ,[reassigned_provider_id]
      ,[modify_timestamp]
      ,[signoffdate]
      ,[signoff_timestamp]
      ,[Item Creation Date]
	  ,CASE WHEN [HourstoCompeletion] IS NOT NULL THEN 
		 CASE
		     WHEN [HourstoCompeletion]<1   THEN 'Less than 1 Hour'
			 WHEN [HourstoCompeletion]<2   THEN 'Less than 2 Hours'
			 WHEN [HourstoCompeletion]<3   THEN 'Less than 3 Hours'
			 WHEN [HourstoCompeletion]<4  THEN 'Less than 4 Hours'
			 WHEN [HourstoCompeletion]<8  THEN 'Less than 8 hours'
			 WHEN [HourstoCompeletion]<12  THEN 'Less than 12 Hours'
			 WHEN [HourstoCompeletion]<12  THEN 'Less than 24 Hours'
			 WHEN [HourstoCompeletion]<48  THEN 'Less than 48 Hours'
			 WHEN [HourstoCompeletion]<48  THEN 'Less than 72 Hours'
			 ELSE (CAST([HourstoCompeletion] AS NVARCHAR(100)))
	      END  
		END AS [Hour Range]
		,CASE WHEN [HourstoCompeletion] IS NOT NULL THEN 
		 CASE
		     WHEN [HourstoCompeletion]<1   THEN 1
			 WHEN [HourstoCompeletion]<2   THEN 2
			 WHEN [HourstoCompeletion]<3   THEN 3
			 WHEN [HourstoCompeletion]<4  THEN  4
			 WHEN [HourstoCompeletion]<8  THEN  5
			 WHEN [HourstoCompeletion]<12  THEN 6
			 WHEN [HourstoCompeletion]<12  THEN 7
			 WHEN [HourstoCompeletion]<48  THEN 8
			 WHEN [HourstoCompeletion]<48  THEN 9
			 ELSE 0
	      END  
		END AS [Hour_Sort]
		,CASE WHEN [DaystoCompeletion] IS NOT NULL THEN
			CASE 
				WHEN [DaystoCompeletion]<7 THEN 'Less than 7 Days'
				WHEN [DaystoCompeletion]<14 THEN 'Less Than 14 Days'
				WHEN [DaystoCompeletion]>14 THEN 'Greater than 14 Days'
				ELSE (CAST([DaystoCompeletion] AS NVARCHAR(100)))
			END 
		END AS [Day Range]
		,CASE WHEN  [DaystoCompeletion] IS NOT NULL THEN
			CASE
				WHEN [DaystoCompeletion]<7 THEN 1
				WHEN [DaystoCompeletion]<14 THEN 2
				WHEN [DaystoCompeletion]>14 THEN 3
				ELSE 0
			END 
        END AS [Day_Sort]
      ,[active]
      ,[nbr_PAQ_by_Provider]
	  ,nbr_PAQ_Rejected
	  ,nbr_PAQ_Reassigned
      ,[nbr_PAQ_by_Covering_Provider]
      ,[nbr_Realted_to_encounter_flg]
      ,[nbr_PAQ_Reassigned_to_dif_Provider_flg]
	   INTO fdt.[Fact and Dim PAQ]
  FROM [dwh].[data_PAQ]

       ALTER TABLE fdt.[Fact And Dim PAQ] ADD PRIMARY KEY(paq_key);   
  
END



GO
