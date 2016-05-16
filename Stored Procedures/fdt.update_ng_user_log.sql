SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_ng_user_log]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF OBJECT_ID('fdt.[Fact and Dim NG User Log]') IS NOT NULL
       DROP TABLE  fdt.[Fact and Dim NG User Log] ;

	SELECT 
	  -- [log_key]
     --  [sig_event_id]
       [Log Valid]
      ,[user_key]
      ,[provider_id]
      ,[enc_id]
      ,[Login Datetime]
      ,[Logout Datetime]
      ,[Log Minute]
      ,[Log Hour]
      ,[enc_count]
      ,[Log Case]
      ,[Login Time]
      ,[Start Time]
      ,[End Time]
      ,[Logout Time]
      --,[row_number_enc_id]
      ,[Max Hour]
      ,[Max Minutes]
      ,[Sum Hour]
      ,[Sum Minutes]
      ,[enc_appt_key]
      ,[provider_key]
  INTO fdt.[Fact and Dim NG User Log]
  FROM [dwh].[data_ng_user_log]


    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
END
GO
