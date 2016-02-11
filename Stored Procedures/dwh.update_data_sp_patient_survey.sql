
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

--Re create the table, no Foreign Key Consraints in this step, is it will interfere with dropping/re-creating other tables
CREATE TABLE dwh.data_sp_patient_survey(

	survey_key int IDENTITY(1,1),
	encounter_num numeric,
	enc_appt_key int,
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

/*
JOIN matches encounter numbers from etl.data_patientsurvey and dwh.data_appointment, to pull in enc_key, so survey data can be linked
to dwh.data_encounter in future queries.
encounter_num was created as text in Sharepoint, due to some idiosyncrasies with displaying numbers, so it is CAST() to a numeric in this stage  
*/

Insert into dwh.data_sp_patient_survey 
select CAST(e.encounter_num AS numeric), 
	s.enc_appt_key, e.survey_q1, e.survey_q2, e.survey_q3, e.survey_q4, e.survey_q5, e.survey_q6, e.survey_q7, e.comments, e.created 
	from etl.data_sp_patientsurvey e
	join dwh.data_appointment s 
	on CAST(e.encounter_num AS numeric)=enc_nbr


GO
