
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Julius Abate>
-- Create date: <April 7, 2016>
-- Description:	
-- =============================================
CREATE PROCEDURE [fdt].[update_fact_and_dim_labs]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

   IF OBJECT_ID('fdt.[Fact Labs]') IS NOT NULL
		DROP TABLE fdt.[Fact Labs]

   IF OBJECT_ID('fdt.[Dim Labs]') IS NOT NULL
		DROP TABLE fdt.[Dim Labs]

   IF OBJECT_ID('fdt.[Bridge Labs]') IS NOT NULL
		DROP TABLE fdt.[Bridge Labs]

SELECT lab_res_key
      ,enc_appt_key
      ,per_mon_id
	  ,person_key
      ,ordering_prov_key
      ,create_user_key
      ,mod_user_key
	  ,test_ordered AS [Order Type]
      ,test_status AS [Order Status]
      ,ngn_status AS [NG Order Status]
      ,test_desc AS [Description]
      --,ord_delete_ind
      --,order_control
      ,order_priority AS [Priority]
      --,time_entered
      --,spec_action_code
      --,billing_type
      --,clinical_info
      --,cancel_reason
      --,ufo_num
      --,lab_id
      ,order_create_date AS [Order Date]
      --,order_modify_date
      --,generated_by
      --,order_type
      --,documents_ind
      --,intrf_msg
      ,ng_completed_ind AS [NG Completed]
      --,hiv_test_count
      ,Recency
      ,value_type
      ,obs_id
      ,loinc_code AS [LOINC]
      ,observ_value AS [Result Value]
      ,cleaned_value AS [Numeric Value]
      ,units AS [Units of Measurement]
      --,ref_range
      --,abnorm_flags
      --,nature_abnorm_chk1
      --,observ_result_stat
      --,last_change_dt
      --,obs_date_time
      --,prod_id_code1
      --,prod_id_code1_txt
      --,signed_off_ind
      ,result_desc AS [Result Description]
      ,result_date AS [Result Date]
      ,clinical_name AS [Clinical Name]
      ,value_long AS [Full Value]
      ,lab_result_dx AS [Result Dx]
      ,type AS [Lab Type]
      ,range AS [Result Range]
      ,count_complete_order AS [Completed Orders]
	  ,count_distinct_order AS [Total Orders]
	  ,CAST(order_create_date AS DATE) AS order_created_date
	  ,CAST(result_date AS DATE) AS result_created_date
  INTO Prod_Ghost.fdt.[Dim Labs]
  FROM Prod_Ghost.dwh.data_labs


  SELECT lab_res_key
      ,enc_appt_key
      ,per_mon_id
	  ,person_key
      ,ordering_prov_key
      ,create_user_key
      ,mod_user_key
	  ,test_ordered AS [Order Type]
      ,test_status AS [Order Status]
      ,ngn_status AS [NG Order Status]
      ,test_desc AS [Description]
      --,ord_delete_ind
      --,order_control
      ,order_priority AS [Priority]
      --,time_entered
      --,spec_action_code
      --,billing_type
      --,clinical_info
      --,cancel_reason
      --,ufo_num
      --,lab_id
      ,order_create_date AS [Order Date]
      --,order_modify_date
      --,generated_by
      --,order_type
      --,documents_ind
      --,intrf_msg
      ,ng_completed_ind AS [NG Completed]
      --,hiv_test_count
      ,Recency
      ,value_type
      ,obs_id
      ,loinc_code AS [LOINC]
      ,observ_value AS [Result Value]
      ,cleaned_value AS [Numeric Value]
      ,units AS [Units of Measurement]
      --,ref_range
      --,abnorm_flags
      --,nature_abnorm_chk1
      --,observ_result_stat
      --,last_change_dt
      --,obs_date_time
      --,prod_id_code1
      --,prod_id_code1_txt
      --,signed_off_ind
      ,result_desc AS [Result Description]
      ,result_date AS [Result Date]
      ,clinical_name AS [Clinical Name]
      ,value_long AS [Full Value]
      ,lab_result_dx AS [Result Dx]
      ,type AS [Lab Type]
      ,range AS [Result Range]
      ,count_complete_order AS [Completed Orders]
	  ,count_distinct_order AS [Total Orders]
	  ,CAST(order_create_date AS DATE) AS order_created_date
	  ,CAST(result_date AS DATE) AS result_created_date
  INTO Prod_Ghost.fdt.[Fact Labs]
  FROM Prod_Ghost.dwh.data_labs


  SELECT
	lab_res_key,
	per_mon_id,
	person_key,
	order_create_date AS order_date,
	result_date
  INTO fdt.[Bridge Labs]
  FROM Prod_Ghost.dwh.data_labs


END
GO
