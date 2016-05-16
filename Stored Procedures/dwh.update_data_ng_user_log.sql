
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
--*DQ*  some users has only logout or login information in the table. assigned those login or logout 45 mins. 
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
    IF OBJECT_ID('#ng_log_categories') IS NOT NULL
       DROP TABLE  #ng_log_categories ;
	IF OBJECT_ID('#ng_log_categories_cal') IS NOT NULL
       DROP TABLE  #ng_log_categories_cal;
	IF OBJECT_ID('#ng_log_categories_match') IS NOT NULL
       DROP TABLE  #ng_log_categories_match;
	IF OBJECT_ID('#temp_log') IS NOT NULL
       DROP TABLE  #temp_log;
	IF OBJECT_ID('#temp_log_1') IS NOT NULL
       DROP TABLE  #temp_log_1;
	IF OBJECT_ID('#data_ng_user_log_unique') IS NOT NULL
       DROP TABLE  #data_ng_user_log_unique;

	

	   

 --It brings login/logout by users. if there is valid user login/logout,UserValidLogInOut is 1 else 0.  

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
	  INTO #temp_log
	  FROM [10.183.0.94].NGProd.dbo.[sig_events] se
	  WHERE  se.sig_id IN(73,74)



--this filter will bring user key in dwh.data_user table.It will help us to make join with data_status table.  data_status table keeps user_key 
--this filter brings only valid users login and logout, and also brings invalid login or logout.

 SELECT 
	       
	       u.userLoginSigID,
	       u.userLoginID,
		   u.userLoginDate,
		   u.UserValidLogInOut,
		   UserLogoutDate,
		   CASE WHEN  ISDATE(u.UserLogoutDate)=1 THEN CAST(u.UserLogoutDate AS DATE) ELSE u.UserLogoutDate  END AS UserDate,
		   CASE 
				WHEN u.UserValidLogInOut=1 THEN DATEDIFF(MINUTE,u.userLoginDate,u.UserLogoutDate)
				ELSE 45
		   END AS [Log Minute],
		   CASE 
				WHEN u.UserValidLogInOut=1 THEN DATEDIFF(MINUTE,u.userLoginDate,u.UserLogoutDate)/60
				ELSE 0
		   END AS [Log Hour],
		   u.sig_msg,
		   u.userLogoutSigID,
		   u.sig_event_id,
           du.user_key,
		   um.provider_id
	INTO #temp_log_1
	FROM  #temp_log u
	LEFT JOIN  dwh.data_user du  WITH(NOLOCK)  ON u.UserID = du.USER_ID 
	left join  [10.183.0.94].NGProd.dbo.user_mstr um  with (nolock)  ON  um.user_id=u.UserID 
	WHERE (u.UserValidLogInOut=1 AND u.userLogOutSigID=74) OR u.UserValidLogInOut=0 
	

--It creates dwh nextgen user login/logout table. data_status table holds user enc_id and their  starting and ending time. 
SELECT 
l.sig_event_id,
l.UserValidLogInOut AS [Log Valid],
l.user_key,
l.provider_id,
s.enc_id,
l.userLoginDate AS [Login Datetime],
l.UserLogoutDate AS [Logout Datetime],
l.[Log Minute],
l.[Log Hour],
ROW_NUMBER() OVER(PARTITION BY s.enc_id ORDER BY s.Checkin_Date) AS enc_count,
CASE 
	WHEN  l.UserValidLogInOut=1  AND DATEDIFF(MINUTE,s.start_datetime,s.end_datetime)<=90 THEN 1 --exact match
	WHEN  l.UserValidLogInOut=1  AND  DATEDIFF(MINUTE,s.start_datetime,s.end_datetime)>=90 THEN 2 --Only finds exact time matching
	WHEN  l.UserValidLogInOut=0  THEN 3 --looking only login or logout exact match
END AS [Log Case],
CAST(l.userLoginDate AS TIME) AS [Login Time],
CAST(s.start_datetime AS TIME) AS [Start Time], 
CAST(s.end_datetime AS TIME) AS [End Time],
CAST(l.UserLogoutDate AS TIME) AS  [Logout Time]
INTO #ng_log_categories_match
FROM #temp_log_1 l
LEFT JOIN dwh.data_status s ON s.[user_provider]=l.user_key  AND l.UserDate=s.Checkin_Date  
WHERE 
-- First case everthing is in order. Providers login and logout in encounter. 
(
	l.UserValidLogInOut=1  and
	--AND  
     DATEDIFF(MINUTE,s.start_datetime,s.end_datetime)<=120  AND 
	(
			--I give patient max 40 mins waiting time
			CAST(l.userLoginDate AS TIME)=
			( 
				   SELECT TOP 1 CAST(x.userLoginDate AS TIME)
				   FROM #temp_log_1 x
				   WHERE CAST(x.userLoginDate AS TIME)>CAST(s.start_datetime AS TIME) 
				   AND   CAST(x.userLoginDate AS TIME)<=(CAST(s.end_datetime AS TIME))  --CAST(DATEADD(mi,15,s.start_datetime)AS TIME)
				   AND s.[user_provider]=x.user_key  
				   AND  x.UserDate=s.Checkin_Date  
				   ORDER BY CAST(x.userLoginDate AS TIME) ASC
			)
			--AND 
			----I give 5 mins to logout after end time 
			--CAST(l.UserLogoutDate AS TIME)=
			--( 
			--   SELECT TOP 1 CAST(x.UserLogoutDate AS TIME)
			--   FROM #temp_log_1 x
			--   WHERE CAST(x.UserLogoutDate AS TIME)>=CAST(s.end_datetime AS TIME)  AND  (CAST(x.UserLogoutDate AS TIME)<=CAST(DATEADD(mi,5,s.end_datetime)AS TIME))  
			--   AND s.[user_provider]=x.user_key  
			--   AND  x.UserDate=s.Checkin_Date  
			--   ORDER BY CAST(x.UserLogoutDate AS TIME) ASC
			--)
	)		

)




--Second Case is about there is login and logout ,but  they did not do ready for provider to check out 
--OR 
--(
--	 l.UserValidLogInOut=1  AND  
--	  DATEDIFF(MINUTE,s.start_datetime,s.end_datetime)>=90  AND 
--	  (
--		  CAST(l.userLoginDate AS TIME)=
--				( 
--				   SELECT TOP 1 CAST(x.userLoginDate AS TIME)
--				   FROM #temp_log_1 x
--				   WHERE CAST(x.userLoginDate AS TIME)>CAST(s.start_datetime AS TIME)  
--				   AND s.[user_provider]=x.user_key  
--				   AND  x.UserDate=s.Checkin_Date  
--				   ORDER BY CAST(x.userLoginDate AS TIME) ASC
--				)	
--		)
--)
----Third Case is about there is login or logout with matching 
--OR 
--(l.UserValidLogInOut=0  AND
--		(
--				(  
--				   (l.userLoginDate IS NOT NULL) AND 
--					CAST(l.userLoginDate AS TIME)=
--					( 
--					   SELECT TOP 1 CAST(x.userLoginDate AS TIME)
--					   FROM #temp_log_1 x
--					   WHERE ( CAST(x.userLoginDate AS TIME)>CAST(s.start_datetime AS TIME)   AND  (CAST(x.userLoginDate AS TIME)<=CAST(DATEADD(mi,40,s.start_datetime)AS TIME)) ) 
--					   AND s.[user_provider]=x.user_key  
--					   AND  x.UserDate=s.Checkin_Date  
--					   ORDER BY CAST(x.userLoginDate AS TIME) ASC
--					)
			  
--				  OR
--				  (   
--						CAST(l.UserLogoutDate AS TIME)=
--						( 
--						   SELECT TOP 1 CAST(x.UserLogoutDate AS TIME)
--						   FROM #temp_log_1 x
--						   WHERE (CAST(x.UserLogoutDate AS TIME)>=CAST(s.end_datetime AS TIME)  AND 
--						   CAST(x.UserLogoutDate AS TIME)<=CAST(DATEADD(mi,5,s.end_datetime)AS TIME) )   
--						   AND s.[user_provider]=x.user_key  
--						   AND  x.UserDate=s.Checkin_Date  
--						   ORDER BY CAST(x.UserLogoutDate AS TIME) ASC
--						)
--				 )
--			)
--	     ) 
--)
ORDER BY l.userLoginDate ASC

--calculation 
SELECT l.*,
ROW_NUMBER() OVER(PARTITION BY l.enc_id ORDER BY l.[Log Case] ASC) AS row_number_enc_id,
MAX([Log Hour]) OVER (PARTITION BY l.enc_id ORDER BY l.[Log Case] ASC) AS [Max Hour],
MAX([Log Minute]) OVER (PARTITION BY l.enc_id ORDER BY l.[Log Case] ASC) AS [Max Minutes] ,
SUM([Log Hour]) OVER (PARTITION BY l.enc_id ORDER BY l.[Log Case] ASC) AS [Sum Hour],
SUM([Log Minute]) OVER (PARTITION BY l.enc_id ORDER BY l.[Log Case] ASC) AS [Sum Minutes]
INTO #ng_log_categories_cal
FROM #ng_log_categories_match l


--take only the most possible Log Case encounters. Get rid of dublicate date 

SELECT l.*,app.enc_appt_key,provider.provider_key
INTO  dwh.data_ng_user_log  --#data_ng_user_log_unique
FROM #ng_log_categories_cal l
LEFT JOIN #ng_log_categories_cal l1 ON (l.enc_id=l1.enc_id AND l.row_number_enc_id>l1.row_number_enc_id) OR (l.enc_id=l1.enc_id)
LEFT JOIN dwh.data_appointment app ON app.enc_id=l1.enc_id
LEFT OUTER JOIN [dwh].[data_provider] provider with (nolock) ON provider.provider_id = l1.provider_id
WHERE   l1.enc_id IS NOT NULL -- AND l1.enc_id='BB0F831F-A52C-456F-A49B-0C7527E4D74C'




--DROP TABLE #data_ng_user_log_unique


----This bring all the Log Data.It is including 
--SELECT 	IDENTITY(INT,1,1) AS log_key,
-- a.*,app.enc_appt_key,provider.provider_key
--  into dwh.data_ng_user_log
--	from 
--	(

--		(
--			select [sig_event_id]
--				  ,[Log Valid]
--				  ,[user_key]
--				  ,[provider_id]
--				  ,[enc_id]
--				  ,[Login Datetime]
--				  ,[Logout Datetime]
--				  ,[Log Minute]
--				  ,[Log Hour]
--				  ,[enc_count]
--				  ,[Log Case]
--				  ,[Login Time]
--				  ,[Start Time]
--				  ,[End Time]
--				  ,[Logout Time]
--				  ,[row_number_enc_id]
--				  ,[Max Hour]
--				  ,[Max Minutes]
--				  ,[Sum Hour]
--				  ,[Sum Minutes]
--			from #data_ng_user_log_unique
--		)
--		union all 
--		(
--			SELECT 
--				l.sig_event_id,
--				l.UserValidLogInOut AS [Log Valid],
--				l.user_key,
--				l.provider_id,
--				null,
--				l.userLoginDate AS [Login Datetime],
--				l.UserLogoutDate AS [Logout Datetime],
--				l.[Log Minute],
--				l.[Log Hour],
--				null,
--				4,
--				CAST(l.userLoginDate AS TIME) AS [Login Time],
--				null,
--				null,
--				CAST(l.UserLogoutDate AS TIME) AS  [Logout Time],
--				null,
--				null,
--				null,
--				null,
--				null
--				FROM #temp_log_1 l
--				where l.sig_event_id not in (select DISTINCT  sig_event_id from #data_ng_user_log_unique))
--) a
--LEFT JOIN dwh.data_appointment app ON app.enc_id=a.enc_id
-- LEFT OUTER JOIN [dwh].[data_provider] provider with (nolock) ON provider.provider_id = a.provider_id


















	






	
END


GO
