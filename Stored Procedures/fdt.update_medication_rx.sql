SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Julius Abate>
-- Create date: <Feb 22, 2016>
-- Description:	Procedure to create a hybrid fact
--				and dimension table for our 
--				pharmacy prescription data. 
--              Primary Key is med_id
-- =============================================
CREATE PROCEDURE [fdt].[update_medication_rx]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --Allow for "Dirty Reads"

	--Drop the table as it is re created by the procedure
	IF OBJECT_ID('fdt.[Fact and Dim Medication]') IS NOT NULL
            DROP TABLE fdt.[Fact and Dim Medication];

    SELECT [med_key]= IDENTITY(INT,1,1) 
		,[per_mon_id]
      ,[appt_loc_key]  
      ,med.[prescribing_user_key] AS [provider_id]   
      ,[enc_appt_key] 
      ,[first_mon_date]
      ,[md_id]
	  ,[active_med_count]       AS [Rx Active Count] --counts total active prescriptions
      ,[active_med_all]         AS [Rx Active Flag] --single active prescription can be flagged multiple times
	  ,[active_count_lifelong]  AS [Rx Active Prescribed by LifeLong]--Where active count is 1, and prescribed elsewhere is 0
	  ,[active_count_elsewhere] AS [Rx Active Prescribed Elsewhere]--Active count is 1, and prescribed elsewhere is 1
	  ,[Rx_prescribe_else]      AS [Rx Prescribed Elsewhere Flag]--Flags all meds (including duplicates) which show as prescribed elsewhere in nextgen
      ,[rx_id]         AS [Rx ID]
      ,[gcnsecno]
      ,[drug_name]     AS [Drug Name]
      ,[ndc]           AS [NDC Class]
      ,[med_rec_nbr]   AS [Medical Record Number]
      ,[store_id]      AS [Store ID]
      ,[start_date]    AS [Rx Start Date]
      ,[expire_date]   AS [Rx Expiration Date]
	   --Pull name from user table for Provider Prescribing
      ,us.FullName AS [Licensed Prescriber]
      ,[userName]      AS [User Ordering]
      ,[RxNotbyProv]   AS [Rx Not Prescribed by Provider]
      ,[PatName]       
      ,[birth_date]
      ,[chart_id]
      ,[ssn]
      ,[sig_text]     AS [Rx Label]
      ,[written_qty]  AS [Qty Written by Licensee]
      ,[refills_left] AS [Refills Remaining]
      ,[refills_orig] AS [Original Refill Qty]
      ,[SentTo]       AS [Pharmacy Name]
      ,[clinic]       AS [Rx Location Name]
      ,[drug_dea_class] AS [DEA Class]
      ,[operation_type] AS [Operation Type]
      ,[mmyy]
      ,[Total_Non_Controlled] AS [Rx Non-Controlled]
      ,[Total_Controlled]     AS [Rx Controlled]
      ,[Sched_I]       AS [Rx Schedule I]
      ,[Sched_II]      AS [Rx Schedule II]
      ,[Sched_III]     AS [Rx Schedule III]
      ,[Sched_IV]      AS [Rx Schedule IV]
      ,[Sched_V]       AS [Rx Schedule V]
  INTO [Prod_Ghost].[fdt].[Fact and Dim Medication]
  FROM [Prod_Ghost].[dwh].[data_medication_rx] med
  LEFT OUTER JOIN [Prod_Ghost].[dwh].[data_user_v2] us
  ON med.prescribing_user_key = us.user_key

  ALTER TABLE fdt.[Fact and Dim Medication] ADD PRIMARY KEY(med_key)      --Use newly created column as Primary Key


   
END
GO
