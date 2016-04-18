SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife>
-- Create date: <Create Date,,4/14/2016>
-- Description:	<Description,,Nextgen Task List>
-- =============================================

--Notes
-- =============================================

-- =============================================



--Updates
-- =============================================

-- =============================================
CREATE PROCEDURE [fdt].[update_task_lists]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET transaction isolation level read UNCOMMITTED
    -- Insert statements for procedure here
	IF OBJECT_ID('fdt.[Fact and Dim Task Lists]') IS NOT NULL
		DROP TABLE fdt.[Fact and Dim Task Lists];

	
	SELECT  [task_key] = IDENTITY( INT,1,1 )
	       ,[person_id]
		  ,[location_id]
		  ,[per_mon_id]
		  ,[enc_id]
		  ,[NG_task_id]
		  ,[create_timestamp]
		  ,[task_from_user_id]
		  ,[task_to_user_id]
		  ,[seq_date]
		  ,[Task_completed]
		  ,[Task_Assigned]
		  ,[Task_Read]
		  ,[Task_rejected]
		  ,[task_desc]
		  ,[task_subj]
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
		  ,[Request_Type]
		  ,active
	  INTO fdt.[Fact and Dim Task Lists]
	  FROM dwh.data_task_lists

	 ALTER TABLE fdt.[Fact and Dim Task Lists] ADD PRIMARY KEY(task_key);   

END
GO
