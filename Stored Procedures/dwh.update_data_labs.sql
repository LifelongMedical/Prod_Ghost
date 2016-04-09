SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dwh].[update_data_labs]
AS
BEGIN 

-- =============================================
-- Author:		<Julius Abate>
-- Create date: <April 3, 2016>
-- Dependant On: person_dp_month, appointment, user_v2
-- Runtime 31 minutes w/o result comments, 41 with
/* Description:	
Procedure pulls lab orders into
the dwh. Also pull lab results with the key
corresponding to the lab order.
*/
-- =============================================

	IF OBJECT_ID('dwh.data_lab_order') IS NOT NULL
		DROP TABLE dwh.data_lab_order

	IF OBJECT_ID('dwh.data_lab_result') IS NOT NULL
		DROP TABLE dwh.data_lab_result

	IF OBJECT_ID('tempdb..#temp_res') IS NOT NULL
		DROP TABLE #temp_res

/*
Currently tracking labs results based on text match in the description,
but considering the move to loinc codes. Have to first do some digging to
see how consistently the codes are used/generated  4/4/16  JTA
*/


--Create a dwh table to hold Lab Orders
SELECT DISTINCT 
       app.enc_appt_key,
       per.per_mon_id,
	   --loc.location_key AS test_loc_key, --Slowed down the process, didn't seem like a useable value
	   prov.provider_key AS ordering_prov_key,
	   creat.user_key AS create_user_key,
	   mod.user_key AS mod_user_key
      ,ord.[order_num]
      ,ord.[test_status]
      ,ord.[ngn_status]
      ,ord.[test_desc]
      ,ord.[delete_ind]
      ,ord.[order_control]
      ,ord.[order_priority]
      ,ord.[time_entered]
      ,ord.[spec_action_code] --Don't know what this field is
      ,ord.[billing_type] --Don't know what this field is
      ,ord.[clinical_info]
      ,ord.[cancel_reason]
      ,ord.[ufo_num]
      ,ord.[lab_id]
      ,ord.[create_timestamp]
      ,ord.[modify_timestamp]
      ,ord.[generated_by]
      --,ord.[paq_provider_id]
      --,ord.[referring_provider_id]
      ,CASE
		WHEN ord.[order_type] LIKE 'L' THEN 'Lab'
		ELSE 'Radiology'
	   END
		AS order_type
      --,[general_comment] --Mostly NULL, otherwise text comments
      --,[order_comment] --Mostly NULL, otherwise text comments
      --,[patient_comment] --Mostly NULL, otherwise text comments
      --,[ng_order_ind] --All 'N'
      --,[abn_signed] -- value is 3 or NULL
      ,ord.[documents_ind]
      --,ord.[signoff_comments_ind]
      ,ord.[intrf_msg]
      ,
	  CASE
		WHEN ord.[completed_ind] = 'Y' THEN 'Complete'
		ELSE 'Incomplete'
	  END
		AS completed_ind
	  ,CASE
		WHEN ord.test_desc LIKE 'HIV%' THEN 1
		ELSE 0
	  END
		AS hiv_test_count
  INTO #temp_ord
  FROM [10.183.0.94] .[NGProd]. [dbo].[lab_nor] ord 
  LEFT JOIN dwh. data_appointment app  ON ord.enc_id = app.enc_id
  --LEFT JOIN dwh.data_location loc  ON loc.location_id = ord.test_location
  LEFT JOIN dwh.data_person_dp_month per ON (ord.person_id = per.person_id AND per.first_mon_date=CAST(CONVERT(CHAR(6),ord.create_timestamp,112)+'01' AS date))
  LEFT JOIN dwh.data_provider prov ON prov.provider_id=ord.ordering_provider
  LEFT JOIN dwh.data_user_v2 creat   ON creat.user_id=ord.created_by
  LEFT JOIN dwh.data_user_v2 mod  ON mod.user_id=ord.modified_by

  --Key must be inserted separately, otherwise it interferes with select distinct
  SELECT
	IDENTITY(INT,1,1) AS lab_ord_key,
	ord.*
  INTO dwh.data_lab_order
  FROM #temp_ord ord

  DROP TABLE #temp_ord

--Create a dwh table to hold Lab Results.
SELECT 
	   per.per_mon_id,
	   ord.lab_ord_key
      ,res.[unique_obr_num]
      ,res.[obx_seq_num]
      ,res.[value_type]
      ,res.[obs_id]
	  ,res.[loinc_code]
      ,res.[observ_value]
	  ,Try_CAST( LEFT(SUBSTRING(observ_value, PATINDEX('%[0-9.]%', observ_value), 8000),
		PATINDEX('%[^0-9.]%', SUBSTRING(observ_value, PATINDEX('%[0-9.]%', observ_value), 8000) + 'X') -1) AS DECIMAL(10,2)) 
		AS cleaned_value
      ,res.[units]
      ,res.[ref_range]
      ,res.[abnorm_flags]
      ,res.[nature_abnorm_chk1] -- NULL or 'N'
      ,res.[observ_result_stat]
      ,res.[last_change_dt]
      ,res.[obs_date_time]
      ,res.[prod_id_code1]
      ,res.[prod_id_code1_txt]
      ,res.[signed_off_ind]
      ,res.[result_desc]
      ,res.[delete_ind]
      ,res.[comment_ind]
      ,res.[result_seq_num] --65536 or NULL
      ,res.[created_by]
      ,res.[create_timestamp]
      ,res.[modified_by]
      ,res.[modify_timestamp]
      --,res.[last_change_dt_tz] --0 or NULL
      --,[obs_date_time_tz] --0 or NULL
      --,[create_timestamp_tz] --0 Only
      --,[modify_timestamp_tz] --0 Only
      ,res.[clinical_name]
      ,res.[result_comment]
      ,res.[units_batt_id],
	  --Couldn't find a distinctive code for an HIV test/result, so matching on test
	  CASE
		WHEN res.clinical_name like 'HIV%'
		and res.observ_value like '%POSITIVE%' THEN 1
		ELSE 0
	  END
		AS hiv_pos_res,
	  CASE
	   WHEN result_desc LIKE 'HIV%'
			AND (observ_value LIKE 'Reactive' 
			OR observ_value LIKE '%dly reactive' --Both Reapeatedly and rptdly show up in results
			OR observ_value LIKE 'INCONCLUSIVE') THEN 1
	   ELSE 0
	  END 
		AS hiv_inc_res,
	  CASE
		WHEN res.result_desc LIKE '%cd4%'
			OR res.result_desc LIKE '%cd3%'
			OR res.result_desc LIKE '%cd8%' THEN 1
		ELSE 0
	  END
		AS t_cell_test
  INTO #temp_res
  FROM [10.183.0.94] .[NGProd]. [dbo].lab_results_obx res
  --results_obr_p is the bridge which holds borth obr_num and order_num
  LEFT JOIN [10.183.0.94] .[NGProd].[dbo].[lab_results_obr_p] p WITH(NOLOCK) ON res.unique_obr_num=p.unique_obr_num
  LEFT JOIN dwh.data_lab_order ord ON ord.order_num=p.ngn_order_num
  LEFT JOIN dwh.data_person_dp_month per ON (res.person_id = per.person_id AND per.first_mon_date=CAST(CONVERT(CHAR(6),res.create_timestamp,112)+'01' AS date))


  SELECT
	IDENTITY (INT,1,1) AS lab_res_key,
	res.*,
	CASE
		WHEN res.cleaned_value IS NOT NULL THEN CAST(res.cleaned_value AS VARCHAR) + ' ' + res.units
		ELSE NULL
	  END
		AS value_long,
	CASE
		WHEN obs_id NOT LIKE '%cd4%'
			OR units NOT LIKE 'cells/uL' THEN NULL
		WHEN cleaned_value < 200 THEN 'Below 200'
		WHEN cleaned_value > 500 THEN 'Above 500'
		ELSE '200 to 500'
	END
		AS cd4_cell_range,
	--If running a hemoglobin a1c test for diabetes, record the range
	CASE
		WHEN 
			res.result_desc NOT LIKE '%a1c%'
			OR res.cleaned_value IS NULL
			OR res.cleaned_value > 15
			OR res.cleaned_value < 4 THEN NULL
		WHEN res.cleaned_value <= 15
			AND res.cleaned_value >=14 THEN '14 to 15'
		WHEN res.cleaned_value < 14
			AND res.cleaned_value >= 13 THEN '13 to 13.9'
		WHEN res.cleaned_value < 13
			AND res.cleaned_value >= 12 THEN '12 to 12.9'
		WHEN res.cleaned_value < 12
			AND res.cleaned_value >= 11 THEN '11 to 11.9'
		WHEN res.cleaned_value < 11
			AND res.cleaned_value >= 10 THEN '10 to 10.9'
		WHEN res.cleaned_value < 10
			AND res.cleaned_value >= 9 THEN '9 to 9.9'
		WHEN res.cleaned_value < 9
			AND res.cleaned_value >= 8 THEN '8 to 8.9'
		WHEN res.cleaned_value < 8 
			AND res.cleaned_value >= 7 THEN '7 to 7.9'
		WHEN res.cleaned_value < 7
			AND res.cleaned_value >= 6.6 THEN '6.6 to 6.9'
		WHEN res.cleaned_value < 6.6
			AND res.cleaned_value >= 5.8 THEN '5.8 to 6.5'
		ELSE '4 to 5.7'
	END
		AS hb_a1c_range,
	--The range 5.8-6.5 is pre-diabetic
	CASE
		WHEN res.result_desc NOT LIKE '%a1c%' THEN 0
		WHEN res.cleaned_value < 6.6
			AND res.cleaned_value >= 5.8 THEN 1
		ELSE 0
	END
		AS pre_diab_flag  
  INTO dwh.data_lab_result
  FROM #temp_res res



  END


GO
