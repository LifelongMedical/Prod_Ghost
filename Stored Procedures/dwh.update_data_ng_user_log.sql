SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Hanife Doganay>
-- Create date: <Create Date,,5/2/2016>
-- Description:	<Description,,creates users log activities>
-- =============================================


--Notes
-- =============================================
--Dependencies
-- dwh_data_status
--*DQ*
-- =============================================


--Updates
-- =============================================
-- DATE initial and update info
-- =============================================
CREATE PROCEDURE [dwh].[update_data_ng_user_log]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	IF OBJECT_ID('dwh.data_ng_user_log ') IS NOT NULL
       DROP TABLE  dwh.data_ng_user_log ;

    
	
--It brings login/logout by users. if there is valid user login/logout,UserValidLogInOut is 1 else 0.  
;WITH UserLogInOutActivity as
( 
	 SELECT 
		se.created_by AS UserID,
		se.sig_event_id,
		se.sig_id AS [userLogoutSigID],
		se.sig_msg,
		se.create_timestamp AS UserLogoutDate,
		IIF(
		(se.sig_id=74 AND  ( LEAD( se.sig_id,1) OVER ( ORDER BY se.created_by ,se.create_timestamp DESC ))=73  AND se.created_by=LEAD(se.created_by)OVER(ORDER BY se.created_by ,se.create_timestamp DESC ))
		OR
		(se.sig_id=73 AND  ( LAG( se.sig_id,1) OVER ( ORDER BY se.created_by ,se.create_timestamp DESC ))=74  AND se.created_by=LAG(se.created_by)OVER(ORDER BY se.created_by ,se.create_timestamp DESC ))
		,1,0) AS UserValidLogInOut,
		IIF(se.sig_id=74 AND  ( LEAD( se.sig_id,1) OVER ( ORDER BY se.created_by ,se.create_timestamp DESC ))=73  AND se.created_by=LEAD(se.created_by)OVER(ORDER BY se.created_by ,se.create_timestamp DESC ),LEAD(se.create_timestamp)OVER(ORDER BY se.created_by ,se.create_timestamp DESC ),null)  AS userLoginDate,
		IIF(se.sig_id=74 AND  ( LEAD( se.sig_id,1) OVER ( ORDER BY se.created_by ,se.create_timestamp DESC ))=73  AND se.created_by=LEAD(se.created_by)OVER(ORDER BY se.created_by ,se.create_timestamp DESC ),LEAD(se.created_by)OVER(ORDER BY se.created_by ,se.create_timestamp DESC ),NULL)  AS userLoginID,
		IIF(se.sig_id=74 AND  ( LEAD( se.sig_id,1) OVER ( ORDER BY se.created_by ,se.create_timestamp DESC ))=73  AND se.created_by=LEAD(se.created_by)OVER(ORDER BY se.created_by ,se.create_timestamp DESC ),LEAD(se.sig_id)OVER(ORDER BY se.created_by ,se.create_timestamp DESC ),NULL)  AS userLoginSigID
	  FROM [10.183.0.94].NGProd.dbo.[sig_events] se
	  WHERE  se.sig_id IN(73,74)
),
--this filter brings only valid users login and logout, and also brings invalid login or logout.
filter1 AS
(
     SELECT u.* 
FROM UserLogInOutActivity u WHERE (u.UserValidLogInOut=1 AND u.userLogOutSigID=74) OR u.UserValidLogInOut=0 
),
--this filter will bring user key in dwh.data_user table.It will help us to make join with data_status table.  data_status table keeps user_key 
filter2 as 
(
    SELECT 
	       u.userLoginSigID,
	       u.userLoginID,
		   u.userLoginDate,
		   u.UserValidLogInOut,
		   UserLogoutDate,
		   CASE WHEN  ISDATE(u.UserLogoutDate)=1 THEN CAST(u.UserLogoutDate AS DATE) ELSE u.UserLogoutDate  END AS UserDate,
		   u.sig_msg,
		   u.userLogoutSigID,
		   u.sig_event_id,
           du.user_key 
	FROM filter1 u
	LEFT JOIN  dwh.data_user du ON u.UserID = du.USER_ID 
)
--It creates dwh nextgen user login/logout table. data_status table holds user enc_id and their  starting and ending time. 
SELECT * 
INTO dwh.data_ng_user_log 
FROM filter2 l
LEFT JOIN dwh.data_status s ON 
s.[user_provider]=l.user_key AND 
l.UserDate=s.Checkin_Date  
WHERE l.UserValidLogInOut=1 
AND 
 (CAST(l.userLoginDate AS TIME) >CAST(s.[start_datetime] AS TIME) AND CAST(l.userLoginDate AS TIME) <=CAST(DATEADD(hh,2,s.[start_datetime])AS TIME))  
AND (CAST(s.end_datetime AS TIME)<CAST(l.UserLogoutDate AS TIME) AND CAST(DATEADD(MINUTE,30,s.end_datetime)AS TIME)>=CAST(l.UserLogoutDate AS TIME))






	
END
GO
