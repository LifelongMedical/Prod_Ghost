SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dwh].[update_data_sp_patient_survey]
AS

SET NOCOUNT ON --Prevents row counts returned from SELECT statement slowing down the query

--Drop an existing table as warehouse is rebuilt daily
IF OBJECT_ID('dwh.data_sp_patient_survey', 'U') IS NOT NULL
DROP TABLE dwh.data_sp_patient_survey


CREATE TABLE dwh.data_sp_patient_survey(

	survey_key int IDENTITY(1,1),
	encounter_num numeric,
	enc_appt_key int,
	FOREIGN KEY (enc_appt_key) references dwh.data_appointment(enc_appt_key),
	survey_q1 numeric,
	survey_q2 numeric,
	survey_q3 numeric,
	survey_q4 numeric,
	survey_q5 numeric,
	survey_q6 numeric,
	survey_q7 numeric,
	comments nvarchar(max),
	created datetime,


) 

/*JOIN matches etl.data_patientsurvey.encounter_num with dwh.data_appointment.enc_nr, but pulls in Foreign Key enc_key to create a relationship
to dwh.data_encounter in future queries
encounter_num was created as text in Sharepoint due to lack of understanding of warehouse schema, so it is CAST() to a numeric in this stage  */

Insert into dwh.data_sp_patient_survey 
select CAST(e.encounter_num AS numeric), 
	s.enc_appt_key, e.survey_q1, e.survey_q2, e.survey_q3, e.survey_q4, e.survey_q5, e.survey_q6, e.survey_q7, e.comments, e.created 
	from etl.data_sp_patientsurvey e
	join dwh.data_appointment s 
	on CAST(e.encounter_num AS numeric)=enc_nbr


GO
