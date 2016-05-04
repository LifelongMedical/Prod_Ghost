
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
--4/27/2016 added [Dim NG Task User] and Hour and Day Sort
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
	IF OBJECT_ID('fdt.[Dim NG Task User Sent]') IS NOT NULL
		DROP TABLE fdt.[Dim NG Task User Sent];
	IF OBJECT_ID('fdt.[Dim NG Task User Recv]') IS NOT NULL
		DROP TABLE fdt.[Dim NG Task User Recv];

	
	SELECT  [task_key] = IDENTITY( INT,1,1 )
		   ,task_to_user_key
		   ,task_from_user_key
      ,[create_timestamp] AS [Created Date]
      ,[Task_completed] AS [Task Completed]
		  ,[Task_Assigned] AS [Task Assigned]
		  ,[Task_Read] AS [Task Read]
		  ,[Task_rejected] AS [Task Rejected]
		  ,[task_desc] as [Task Description]
		  ,[task_subj] AS [Task Subject]
      ,[Nbr of active Inbox]
	    ,[Request_Type] AS [Request Type]
		,[HourstoCompeletion] AS [Task Hours to Completion]
		,[DaystoCompeletion] AS [Task Days to Completion]
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
			  WHEN [HourstoCompeletion]>=72  THEN 'More than or Equal to 72 Hours'
	      END  
		  ELSE 'Null Value'
		END AS [Hour Range]
		  ,CASE WHEN [HourstoCompeletion] IS NOT NULL THEN 
		 CASE
		     WHEN [HourstoCompeletion]<1   THEN  1
			 WHEN [HourstoCompeletion]<2   THEN 2
			 WHEN [HourstoCompeletion]<3   THEN 3
			 WHEN [HourstoCompeletion]<4  THEN 4
			 WHEN [HourstoCompeletion]<8  THEN 5
			 WHEN [HourstoCompeletion]<12  THEN 6
			 WHEN [HourstoCompeletion]<24  THEN 7
			 WHEN [HourstoCompeletion]<48  THEN 8
			 WHEN [HourstoCompeletion]<72  THEN 9
			 WHEN [HourstoCompeletion]>72 THEN 10
	      END
		  ELSE 0   
		END AS [Hour Sort]
		,CASE WHEN [DaystoCompeletion] IS NOT NULL THEN
			CASE 
				WHEN [DaystoCompeletion]<7 THEN 'Less than 7 Days'
				WHEN [DaystoCompeletion]<14 THEN 'Less Than 14 Days'
				WHEN [DaystoCompeletion]>14 THEN 'Greater than 14 Days'
			END 
			ELSE 'Null Value'
		END AS [Day Range]
		,CASE WHEN [DaystoCompeletion] IS NOT NULL THEN
			CASE 
				WHEN [DaystoCompeletion]<7 THEN 1
				WHEN [DaystoCompeletion]<14 THEN 2
				WHEN [DaystoCompeletion]>14 THEN 3
			END
		ELSE 0 
		END AS [Day Sort]
	  INTO fdt.[Fact and Dim Task Lists]
	  FROM dwh.data_task_lists

	 ALTER TABLE fdt.[Fact and Dim Task Lists] ADD PRIMARY KEY(task_key);   



	 
        SELECT  [user_key] ,
                [employee_key] ,
                [first_name] [NG User First Name] ,
                [last_name] [NG User Last Name] ,
                [FullName] [NG User Full Name]
          INTO  fdt.[Dim NG Task User Sent]
        FROM    [Prod_Ghost].[dwh].[data_user_v2];
		
        SELECT  [user_key] ,
                [employee_key] ,
                [first_name] [NG User First Name] ,
                [last_name] [NG User Last Name] ,
                [FullName] [NG User Full Name]
          INTO fdt.[Dim NG Task User Recv]
        FROM    [Prod_Ghost].[dwh].[data_user_v2];



END
GO
