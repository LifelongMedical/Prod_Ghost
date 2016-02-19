
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_i2i_tracking]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
        IF OBJECT_ID('dwh.data_i2i_tracking') IS NOT NULL
            DROP TABLE dwh.data_i2i_tracking;

 
 --This procedure will create a relationship to the Patient_fact table to select patient 
 
 --The next step for incorporating i2i tracking is to a create a bridgetable between
 --Dim PHI patient and Dim Tracking Type
 --Will need to add summarize functions to the DAX measures in the patient Fact Table to push
 --the many to many relationship through DIM PHI Patient.
 --This technique will need to be used across a number of new tables including lab and diagnosis Dimensions
 --Be nice to have Bidirectional filtering, but that is not a possibility yet in SQL2014 -- need sql 2016 for that.
 --Key i2i tables
 
--[T_LifeLong].[dbo].[cli_PatientVisits]-- Patient Vital signs and all historical from Merrit

-- [T_LifeLong].[dbo].[cli_Patients] -- Key patients
--[T_LifeLong].[dbo].[cli_PatientReferrals] -- Referaks
-- [T_LifeLong].[dbo].[cli_PatientProblems]
--[T_LifeLong].[dbo].[cli_PatientMedications]
-- [T_LifeLong].[dbo].[cli_PatientLabResults]
-- [T_LifeLong].[dbo].[cli_PatientImmunizations]
--[T_LifeLong].[dbo].[cli_SetupTrackingTypes]

        SELECT  ptt.patientID ,
                ptt.[TrackTypeID] ,
				pm.per_mon_id,
                stt.Name ,
                status ,
  
                pm.first_mon_date
		INTO dwh.data_i2i_tracking
		FROM    [i2iTracks].[T_LifeLong].[dbo].[cli_PatientTrackingTypes] ptt
                INNER JOIN [i2iTracks].[T_LifeLong].[dbo].[cli_SetupTrackingTypes] stt ON ptt.[TrackTypeID] = stt.[ID]
                INNER JOIN ( SELECT patientID ,
                                    [TrackTypeID] ,
                                    CAST(CONVERT(VARCHAR(6), [statusdate], 112) + '01' AS DATE) AS first_mon_date ,
                                    MAX([statusdate]) AS statusdate
                             FROM   [i2iTracks].[T_LifeLong].[dbo].[cli_PatientTrackingTypes]
                             WHERE  deleted = 0
                             GROUP BY patientID ,
                                    [TrackTypeID] ,
                                    status ,
                                    CAST(CONVERT(VARCHAR(6), [statusdate], 112) + '01' AS DATE) ,
                                    [statusdate]
                           ) st ON st.patientID = ptt.patientID
                                   AND st.tracktypeID = ptt.tracktypeID
                                   AND st.statusdate = ptt.statusdate
				 INNER JOIN dwh.data_person_nd_month pm ON pm.person_id=ptt.patientID AND pm.first_mon_date>= IIF(CAST(CONVERT(VARCHAR(6), ptt.[statusdate], 112) + '01' AS DATE) < CAST('20100301' AS DATE), CAST('20100301' AS DATE), CAST(CONVERT(VARCHAR(6), ptt.[statusdate], 112)
                + '01' AS DATE))
                

			
               


        WHERE   enabled = 1
                AND deleted = 0
				ORDER BY per_mon_id
		
		


 







    END;
GO
