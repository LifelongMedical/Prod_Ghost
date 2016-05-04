SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife>
-- Create date: <Create Date,,4/25/2016>
-- Description:	<Description,,Created related Case Managment Templates Tables>
-- =============================================


--Notes
-- =============================================
--Dependencies
-- --Case Management/Enabling Services Encounter table is created by each encounter 
-- =============================================


--Updates
-- =============================================
-- DATE initial and update info
-- =============================================
CREATE PROCEDURE [dwh].[update_data_case_managment]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --Allow for dirty reads
	
        IF OBJECT_ID('dwh.data_action_plan') IS NOT NULL
            DROP TABLE dwh.data_action_plan;
	    IF OBJECT_ID(' dwh.data_history_services') IS NOT NULL
            DROP TABLE  dwh.data_history_services ;
		IF OBJECT_ID('dwh.data_case_managment') IS NOT NULL
            DROP TABLE  dwh.data_case_managment ;



-- Action Plan 
--the user can not update any action plan.
SELECT person_dp.per_mon_id
,person_dp.[first_mon_date]
,a.txt_comments AS [Goal]
,a.txt_status AS [Status]
,a.txt_service AS [Priority Area]
,a.txt_comp_date AS [Completed Date]
,a.txt_date AS [Service Date] --it is supposed to be encounter date but we can not trust because the date can change by interface
 ,ROW_NUMBER() OVER ( PARTITION BY a.person_id, CONVERT(CHAR(8), a.create_timestamp, 112) ORDER BY a.create_timestamp DESC ) AS Recency 
,a.create_timestamp AS [Create_Time]
INTO dwh.data_action_plan
FROM [10.183.0.94].NGProd.dbo.[CHCN_Enab_Srvc_DM_EP_]  a
 LEFT OUTER JOIN [dwh].[data_person_dp_month] person_dp WITH ( NOLOCK ) ON person_dp.[person_id] =a.person_id   AND person_dp.[first_mon_date] =(CAST(CONVERT(CHAR(6),a.create_timestamp,112)+'01' AS date))

--History of Services 
SELECT  person_dp.per_mon_id,
person_dp.[first_mon_date],
s.txt_service_date AS [Date of Service],-- usually Encounter Date, but it can change by staff
s.[txt_user] AS [Staff FullName],
s.txt_services_provided AS [Services/Referrals Provided],
s.[xt_services_comment1] AS [Notes],
s.txt_resource_type AS [Resource Type],
s.txt_service_type AS [Service Type],
s.txt_interpreter_services AS [Interpreter Service],
s.[txt_referral_chk] AS [Referral Placed],
s.[txt_time_spent] AS [Time Spent],
s.[txt_internal_referral] AS [Internal Referral],
s.create_timestamp AS [Created Date],
ROW_NUMBER() OVER ( PARTITION BY s.person_id, CONVERT(CHAR(8), s.create_timestamp, 112) ORDER BY s.create_timestamp DESC ) AS Recency 
INTO dwh.data_history_services 
FROM [10.183.0.94].NGProd.dbo.[CHCN_Enab_Srvc_DM_EP2_] s
  LEFT OUTER JOIN [dwh].[data_person_dp_month] person_dp WITH ( NOLOCK ) ON person_dp.[person_id] =s.person_id   AND person_dp.[first_mon_date] =(CAST(CONVERT(CHAR(6),s.create_timestamp,112)+'01' AS date))

--Case Management/Enabling Services Encounter
SELECT  person_dp.per_mon_id,
person_dp.[first_mon_date],
c.enc_id AS [Enc Id],
c.chk_active_status AS [Case Management Status Active],
c.chk_status_inactive AS [Case Management Status Inactive],
c.txt_inactive_date AS [Inactive Date],
c.rb_iinternal_referral AS [Referal From Outsite Lifelong],
c.chk_ambul_disability AS [Ambulatory Disability],
c.chk_alert_cognitive AS [Cognitive Disability],
c.chk_alert_homeless AS [Homelessness-Current],
c.chk_aler_selfcare AS [Self-Care Disability],
c.chk_alert_aod AS [AOD Use/Abuse - History*],
c.chk_alert_medical AS [Complex Medical Needs],
c.chk_alert_homelesshx AS [Homelessness-History],
c.chk_alert_traumahx AS [Trauma/Abuse-History],
c.chk_alert_aodcur AS [AOD Use/Abuse - Current*],
c.chk_alert_domesvio AS [Violence/Abuse-Current],
c.chk_alert_independence AS [Independent Living Disability*],
c.chk_aler_migrantwrk AS [Migrant/Seasonal Worker],
c.chk_alert_bhdx AS [Behavioral Health Dx],
c.chk_alert_ed AS [ED-High Utilizer],
c.chk_alert_incarchx AS [Incarceration History],
c.chk_aler_literacy AS [Low Literacy],
c.chk_alert_chronicdx AS [Chronic Disease Dx],
c.chk_alert_hearing AS [Hearing Disability*],
c.chk_alert_vision AS [Visual Disability*],
c.chk_aler_preflang AS [Language Prefered Not English],
c.txt_activated_by AS [Staff FullName],
c.alert_comments AS [Comment],
ROW_NUMBER() OVER ( PARTITION BY c.person_id, CONVERT(CHAR(8), c.create_timestamp, 112) ORDER BY c.create_timestamp DESC ) AS Recency 
INTO dwh.data_case_managment
FROM [10.183.0.94].NGProd.dbo.[CHCN_Enabling_Srvc_] c
     LEFT OUTER JOIN [dwh].[data_person_dp_month] person_dp WITH ( NOLOCK ) ON person_dp.[person_id] = c.person_id   AND person_dp.[first_mon_date] =(CAST(CONVERT(CHAR(6),c.create_timestamp,112)+'01' AS date))
				
    
	
END
GO
