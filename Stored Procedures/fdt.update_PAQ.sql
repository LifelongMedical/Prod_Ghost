
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
--4/23/2016 added lab flag and description
--4/27/2016 added fdt.[Dim NG PAQ User Action]
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
	   IF OBJECT_ID('fdt.[Dim NG PAQ User Action]') IS NOT NULL
            DROP TABLE fdt.[Dim NG PAQ User Action] ;


	SELECT 
	   [paq_key] = IDENTITY( INT,1,1 )
	   ,CASE [item_type] 
	    WHEN 'D' THEN 'Document'
	  WHEN 'S' THEN 'ICS Images'
      WHEN 'L' THEN 'Lab'
	   END AS [PAQ Type]
     -- ,[item_id] 
      ,[provider_key] 
      ,[per_mon_id]
      ,[enc_appt_key]
	  ,user_key AS PAQ_signoff_user_key  --If paq item is active user_key indicated document creation 
      ,[item_name] AS [PAQ Name] 
	  ,[PAQ_provider_key]
	  ,[PAQ_reassigned_provider_key]
    --  ,[created_by]
     -- ,[modified_by]
      --,[signoff_user_id]
      ,CASE [signoff_action]
	  WHEN 'A' THEN ' Accept'
	  WHEN 'R' THEN 'Rejected'
      WHEN 'E' THEN 'Reassigned'
	  ELSE 'Active'
	  END  AS [Signoff Action]
      ,[signoff_desc] AS [Signoff Description]
     -- ,[reassigned_provider_id]
     -- ,[modify_timestamp]
      ,[signoffdate] AS [Signoff Date]

      --,[signoff_timestamp]
      ,[Item Creation Date] as [PAQ Creation Date]
	  ,CAST([Item Creation Date] AS DATE) as [Key Date]
	  ,[HourstoCompeletion] AS [Hours PAQ Action]
	  ,CASE WHEN [HourstoCompeletion] IS NOT NULL THEN 
		 CASE
		     WHEN [HourstoCompeletion]<1   THEN 'Less than 1 Hour'
			 WHEN [HourstoCompeletion]<2   THEN 'Less than 2 Hours'
			 WHEN [HourstoCompeletion]<3   THEN 'Less than 3 Hours'
			 WHEN [HourstoCompeletion]<4  THEN 'Less than 4 Hours'
			 WHEN [HourstoCompeletion]<8  THEN 'Less than 8 hours'
			 WHEN [HourstoCompeletion]<12  THEN 'Less than 12 Hours'
			 WHEN [HourstoCompeletion]<24  THEN 'Less than 24 Hours'
			 WHEN [HourstoCompeletion]<48  THEN 'Less than 48 Hours'
			 WHEN [HourstoCompeletion]<72  THEN 'Less than 72 Hours'
			 WHEN [HourstoCompeletion]>=72 THEN 'More than or Equal to 72 Hours'
	      END 
		  ELSE 'Null Value'
		END AS [Hours to PAQ Action Range]
		,CASE WHEN [HourstoCompeletion] IS NOT NULL THEN 
		 CASE
		     WHEN [HourstoCompeletion]<1   THEN 1
			 WHEN [HourstoCompeletion]<2   THEN 2
			 WHEN [HourstoCompeletion]<3   THEN 3
			 WHEN [HourstoCompeletion]<4  THEN 4
			 WHEN [HourstoCompeletion]<8  THEN 5
			 WHEN [HourstoCompeletion]<12  THEN 6
			 WHEN [HourstoCompeletion]<24  THEN 7
			 WHEN [HourstoCompeletion]<48  THEN 8
			 WHEN [HourstoCompeletion]<72 THEN 9
			 WHEN [HourstoCompeletion]>=72 THEN 10
	      END  
		  ELSE 0
		END AS [Hours Sort]
	    ,DaystoCompeletion AS [PAQ Days to Action]
	   ,CASE WHEN [DaystoCompeletion] IS NOT NULL THEN
			CASE 
				WHEN [DaystoCompeletion]<7 THEN 'Less than 7 Days'
				WHEN [DaystoCompeletion]<14 THEN 'Less Than 14 Days'
				WHEN [DaystoCompeletion]>14 THEN 'Greater than 14 Days'
			END 
		ELSE 'Null Value'
		END AS [Days to PAQ Action Range]
		,CASE WHEN [DaystoCompeletion] IS NOT NULL THEN
			CASE 
				WHEN [DaystoCompeletion]<7 THEN 1
				WHEN [DaystoCompeletion]<14 THEN 2
				WHEN [DaystoCompeletion]>14 THEN 3
			END 
		ELSE 0
		END AS [Days Sort]
      ,[Active] [Nbr of Active PAQ]
	  ,[Lab Flag Description]
	  ,[Lab Flag]
      ,[nbr_PAQ_by_Provider] AS [Nbr of PAQ Signedoff by Provider]
	  ,nbr_PAQ_Rejected AS [Nbr of PAQ Rejected]
	  ,nbr_PAQ_Reassigned AS [Nbr of PAQ Reassigned]
      ,[nbr_PAQ_by_Covering_Provider] AS [Nbr of PAQ by Covering Provider]
      ,[nbr_Realted_to_encounter_flg] AS [Nbr of PAQ linked to Enc]
      ,[nbr_PAQ_Reassigned_to_dif_Provider_flg] AS [Nbr of PAQ Reassigned to Diff Provider]
	   INTO fdt.[Fact and Dim PAQ]
  FROM [dwh].[data_PAQ]

       ALTER TABLE fdt.[Fact And Dim PAQ] ADD PRIMARY KEY(paq_key);   
	
	

        SELECT  [user_key] ,
                [employee_key] ,
                [first_name] [NG User First Name] ,
                [last_name] [NG User Last Name] ,
                [FullName] [NG User Full Name]
          INTO fdt.[Dim NG PAQ User Action]
        FROM    [Prod_Ghost].[dwh].[data_user_v2];



END



GO
