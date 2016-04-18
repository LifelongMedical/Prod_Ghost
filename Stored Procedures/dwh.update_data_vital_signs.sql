
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife>
-- Create date: <Create Date,,4/1/2016>
-- Description:	<Patients Vital Signs,,>

-- 4/7/2016 HD Added BMI,HEIGHT,WEIGHT 
-- =============================================
CREATE PROCEDURE [dwh].[update_data_vital_signs] 
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF OBJECT_ID('#temp_data_vital_signs') IS NOT NULL 
		DROP TABLE #temp_data_vital_signs;
	IF OBJECT_ID('dwh.data_vital_signs') IS NOT NULL 
		DROP TABLE dwh.data_vital_signs;


--Bring vital signs data. convert to numeric(16,2) all the vital signs because UNPIVOT only accepts same data type 
     SELECT  vital.person_id,
			 vital.encounterID,
	         vital.[create_timestamp],
             CAST(vital.create_timestamp AS DATE) AS BP_date ,
			 cast([vital].[bp_systolic] AS NUMERIC(16,2)) AS [Blood Pressure Systolic] , 
             CAST([vital].[bp_diastolic]AS NUMERIC(16,2)) AS [Blood Pressure Diastolic],
			 [vital].BMI_calc AS BMI,
			 [vital].height_cm AS [Height Cm],
			 CAST([vital].[weight_kg] AS NUMERIC(16,2))  AS [Weight Kg], 
			 [vital].weight_lb AS [Weight Lb],
             ROW_NUMBER() OVER ( PARTITION BY vital.person_id, CONVERT(CHAR(8), create_timestamp, 112) ORDER BY create_timestamp DESC ) AS Recency,
			  person_dp.per_mon_id,
			  person_dp.first_mon_date,
			  data_appointment.enc_appt_key
			  INTO #temp_data_vital_signs
    FROM [10.183.0.94].NGProd.dbo.[vital_signs_] vital with (nolock)
   LEFT OUTER JOIN  [dwh].[data_person_dp_month] person_dp with (nolock) ON person_dp.[person_id] = vital.person_id  AND person_dp.[first_mon_date]= (CAST(CONVERT(CHAR(6), vital.create_timestamp, 112) + '01' AS DATE))
   LEFT OUTER JOIN  [dwh].[data_appointment] data_appointment  with (nolock) ON  data_appointment.[enc_id]=vital.[encounterID]


--using UNPIVOT statetment to show vital signs as Type and Value
 ;WITH vital AS(
	  SELECT [encounterID],[person_id],[create_timestamp],BP_date,[Recency],per_mon_id,first_mon_date,enc_appt_key,Type,Value
FROM 
   (SELECT [encounterID],[person_id],[create_timestamp],BP_date,[Recency],per_mon_id,first_mon_date,enc_appt_key,
      [Blood Pressure Systolic]  ,[Blood Pressure Diastolic],[BMI],[Height Cm],[Weight Kg],[Weight Lb]
   FROM #temp_data_vital_signs) p

UNPIVOT
   (Value FOR Type IN 
       (   [Blood Pressure Systolic]  ,[Blood Pressure Diastolic],[BMI],[Height Cm],[Weight Kg],[Weight Lb])
)AS unpvt
) SELECT * INTO dwh.data_vital_signs  FROM vital 





	
END
GO
