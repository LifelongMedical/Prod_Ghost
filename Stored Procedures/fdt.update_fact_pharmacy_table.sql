SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,hanife>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_fact_pharmacy_table] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
		SELECT *
        INTO  fdt.[Fact Pharmacy]
		FROM    [Prod_Ghost].[dwh].[data_pharmacy_rx];

--ALTER TABLE  fdt.[Fact Schedule]
--ADD CONSTRAINT slot_key_pk4 PRIMARY KEY ([slot_key]);

END
GO
