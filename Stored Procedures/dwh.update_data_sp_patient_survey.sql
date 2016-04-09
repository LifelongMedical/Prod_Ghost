
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dwh].[update_data_sp_patient_survey]
AS

 -- =============================================
-- Author:    <Julius Abate>
-- Create date: <Dec 04, 2012>
-- Description: <A Procedure to create a DWH table from Patient Survey ETL table>
-- Modified: 2/11/16 <Julius Abate> - Added comments for documentation
-- =============================================


SET NOCOUNT ON --Prevents row counts returned from SELECT statement slowing down the query

--Drop an existing table as warehouse is rebuilt daily
IF OBJECT_ID('dwh.data_sp_patient_survey', 'U') IS NOT NULL
DROP TABLE dwh.data_sp_patient_survey

--Allow for "Dirty Reads"
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



/*
JOIN matches encounter numbers from etl.data_patientsurvey and dwh.data_appointment, to pull in enc_key, so survey data can be linked
to encounter data in future queries.
encounter_num was created as text in Sharepoint, due to some idiosyncrasies with displaying numbers, so it is CAST() to a numeric in this stage  
*/

SELECT
	survey_key = IDENTITY(INT,1,1),
	CAST(e.encounter_num AS numeric) AS enc_num, 
	s.enc_appt_key, 
	e.survey_q1, 
	e.survey_q2, 
	e.survey_q3, 
	e.survey_q4, 
	e.survey_q5,
	e.survey_q6, 
	e.survey_q7,
	/*
	Values are defined by Quality Dept. as 1 = 0, 2 = 33, 3 = 67, 4 = 100
	*/
		CASE
		WHEN e.survey_q1 = 1 THEN 0
		WHEN e.survey_q1 = 2 THEN 33
		WHEN e.survey_q1 = 3 THEN 67
		WHEN e.survey_q1 = 4 THEN 100
		ELSE NULL
	END AS q1_val,
		CASE
		WHEN e.survey_q2 = 1 THEN 0
		WHEN e.survey_q2 = 2 THEN 33
		WHEN e.survey_q2 = 3 THEN 67
		WHEN e.survey_q2 = 4 THEN 100
		ELSE NULL
	END AS q2_val,
		CASE
		WHEN e.survey_q3 = 1 THEN 0
		WHEN e.survey_q3 = 2 THEN 33
		WHEN e.survey_q3 = 3 THEN 67
		WHEN e.survey_q3 = 4 THEN 100
		ELSE NULL
	END AS q3_val,
		CASE
		WHEN e.survey_q4 = 1 THEN 0
		WHEN e.survey_q4 = 2 THEN 33
		WHEN e.survey_q4 = 3 THEN 67
		WHEN e.survey_q4 = 4 THEN 100
		ELSE NULL
	END AS q4_val,
		CASE
		WHEN e.survey_q5 = 1 THEN 0
		WHEN e.survey_q5 = 2 THEN 33
		WHEN e.survey_q5 = 3 THEN 67
		WHEN e.survey_q5 = 4 THEN 100
		ELSE NULL
	END AS q5_val,
		CASE
		WHEN e.survey_q6 = 1 THEN 0
		WHEN e.survey_q6 = 2 THEN 33
		WHEN e.survey_q6 = 3 THEN 67
		WHEN e.survey_q6 = 4 THEN 100
		ELSE NULL
	END AS q6_val,
	--Count if patient answered questions, for use in DAX formulas
		CASE 
		WHEN e.survey_q1 IS NULL THEN 0
		ELSE 1
	END AS total_q1,
	CASE 
		WHEN e.survey_q2 IS NULL THEN 0
		ELSE 1
	END AS total_q2,
	CASE 
		WHEN e.survey_q3 IS NULL THEN 0
		ELSE 1
	END AS total_q3,
	CASE 
		WHEN e.survey_q4 IS NULL THEN 0
		ELSE 1
	END AS total_q4,
	CASE 
		WHEN e.survey_q5 IS NULL THEN 0
		ELSE 1
	END AS total_q5,
	CASE 
		WHEN e.survey_q6 IS NULL THEN 0
		ELSE 1
	END AS total_q6,
	CASE 
		WHEN e.survey_q7 IS NULL THEN 0
		ELSE 1
	END AS total_q7,
	/*
	Quality dept. lables a 9-10 a "promoter", and a 0-6 a "detractor"
	*/
	CASE
		WHEN e.survey_q7 BETWEEN 9 AND 10 THEN 1
		ELSE 0
	END AS promoter,
	CASE
		WHEN e.survey_q7 BETWEEN 0 AND 6 THEN 1
		ELSE 0
	END AS detractor,
	e.comments, 
	e.created 
	into dwh.data_sp_patient_survey
	from etl.data_sp_patientsurvey e
	join dwh.data_appointment s 
	on CAST(e.encounter_num AS numeric)=s.enc_nbr


GO
