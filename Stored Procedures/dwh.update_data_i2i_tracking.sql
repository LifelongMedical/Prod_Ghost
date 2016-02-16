SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dwh].[update_data_i2i_tracking]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        IF OBJECT_ID('dwh.data_i2i_tracking') IS NOT NULL
            DROP TABLE dwh.data_employee;

 
 --This procedure will create a relationship to the Patient_fact table to select patient 
 --Need to account for the last status change for a certain status_id
 
 SELECT stt.Name, COUNT(*) FROM  [i2iTracks].[T_LifeLong].[dbo].[cli_PatientTrackingTypes]  ptt  INNER JOIN [i2iTracks].[T_LifeLong].[dbo].[cli_SetupTrackingTypes] stt ON  ptt.[TrackTypeID] =stt.[ID] WHERE status='A' AND enabled=1 GROUP BY stt.Name


 





    END;
GO
