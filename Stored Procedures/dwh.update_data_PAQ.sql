SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife>
-- Create date: <Create Date,,3/30/3016>
-- Description:	<Descript,,Providers PQA list>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_PAQ]
	-- Add the parameters for the stored procedure here
	
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
		-- SET NOCOUNT ON added to prevent extra result sets from
	
	IF OBJECT_ID('dwh.data_PAQ') IS NOT NULL 
		DROP TABLE dwh.data_PAQ ;


--Provider Approval Queue
SELECT  [unique_id]
      ,q.[enterprise_id]
      ,q.[practice_id]
      ,q.[provider_id]
      ,q.[person_id]
      ,q.[enc_id]
      ,q.[item_type]
      ,q.[item_id]
      ,q.[item_name]
      ,q.[item_file]
      ,q.[item_format]
      ,q.[signoff_user_id]
      ,q.[signoff_action]
      ,q.[signoff_desc]
      ,q.[reassigned_provider_id]
      ,q.[created_by]
      ,q.[modified_by]
      ,q.[create_timestamp]
      ,q.[modify_timestamp]
      ,q.[row_timestamp]
      ,q.[app_created_by]
      ,q.[create_timestamp_tz]
      ,q.[modify_timestamp_tz]
	  , Cast(q.create_timestamp as date) as signoffdate
	  ,um.provider_id as signoffProvider
	  ,case when um.provider_id = q.provider_id then  1 else 0 end as nbr_PAQ_by_Provider
     ,case when um.provider_id != q.provider_id then  1 else 0 end as nbr_PAQ_by_Covering_Provider
	 ,case when enc_id is not null then 1 else 0 end as nbr_Realted_to_encounter_flg
	 ,case when reassigned_provider_id is not null then 1 else 0 end as nbr_PAQ_Reassigned_to_dif_Provider_flg
  INTO #temp_data_PAQ
  FROM  [10.183.0.94].NGPROD.dbo.[paq_signoff_history] q with (nolock)
  LEFT JOIN  [10.183.0.94].NGPROD.dbo.user_mstr um with (nolock) ON q.created_by = um.user_id 







  SELECT q.*,person_dp.per_mon_id,data_appointment.enc_appt_key
   FROM #temp_data_PAQ q
  LEFT OUTER JOIN  [dwh].[data_person_dp_month] person_dp with (nolock) ON person_dp.[person_id] = q.person_id  
  LEFT OUTER JOIN  [dwh].[data_appointment] data_appointment  with (nolock) ON  data_appointment.[enc_id]=q.enc_id
  --LEFT OUTER JOIN  [dwh].[data_user_v2] user_v2 WITH(NOLOCK) 

 --SELECT COUNT(*) FROM #temp_data_PAQ WHERE enc_id IS NULL

	
END
GO
