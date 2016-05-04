SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife Doganay>
-- Create date: <Create Date,,4/21/2016>
-- Description:	<Description,,creates table with all email enrollement data with enc_id>
-- =============================================


--Notes
-- =============================================
--Dependencies
-- **DQ** --47 records has created_by and modified_by -50. All the records dates are in 2015. Portal user(-50) overwrites user and time. 
-- =============================================


--Updates
-- =============================================
--
-- =============================================
CREATE PROCEDURE [dwh].[update_data_ngweb_enrollment]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	  IF OBJECT_ID('#ngweb_enrollment') IS NOT NULL
           DROP TABLE #ngweb_enrollment;
    IF OBJECT_ID('#ngweb_email') IS NOT NULL
           DROP TABLE #ngweb_email;
	 IF OBJECT_ID('dwh.data_ngweb_enrollment') IS NOT NULL
           DROP TABLE dwh.data_ngweb_enrollment;
   
 
  --create  ng_email address table unique. Enrollment table is unique by person
    SELECT e.enrollment_status,
	e.person_id,
	e.created_by AS enroll_created_by_org,
	e.modified_by AS enroll_modified_by_org,
	CASE
		WHEN e.modified_by=-50 THEN CAST(e.create_timestamp AS DATE)
		ELSE CAST(e.modify_timestamp AS DATE)
	END AS [enrollment_created_time],
	CASE 
		WHEN e.modified_by=-50 THEN e.created_by
		ELSE e.modified_by
	END AS [enrollment_created_by],
	e.create_timestamp,
	e.modify_timestamp
	INTO #ngweb_enrollment
	FROM [10.183.0.94].NGProd.dbo.ngweb_enrollments e
	WHERE (e.created_by!=-50 or e.modified_by!=-50) 


	--create  ng_email address table unique by person 
	SELECT *  
INTO #ngweb_email FROM 
(
	SELECT em.person_id,em.created_by AS email_created_by_org,
	em.modified_by AS email_modified_by_org,
	em.create_timestamp,
	em.modify_timestamp,
	em.email_address,
	rank_order=ROW_NUMBER() OVER(PARTITION BY em.person_id ORDER BY em.modify_timestamp DESC),
	CASE
		WHEN em.modified_by=-50  THEN CAST(em.create_timestamp AS DATE)
		ELSE CAST(em.modify_timestamp AS DATE)
	END AS [email_modified_time],
	CASE 
		WHEN em.modified_by=-50 THEN em.created_by
		ELSE em.modified_by
	END AS [email_modified_by]
	FROM [10.183.0.94].NGProd.dbo.ngweb_email_address em WHERE (em.created_by!=-50 or em.modified_by!=-50) 
) x 
WHERE x.rank_order=1



	--create the dwh enrollment table
	SELECT 
f.enc_id,
f.enc_created_by,
f.enc_create_timestamp,
f.enrollment_status,
f.enrollment_created_time,
f.enroll_modify_timestamp,
f.enrollment_created_by,
f.email_address,
f.email_modified_time,
f.email_modified_by,
f.email_create_timestamp
INTO dwh.data_ngweb_enrollment FROM
 (
	SELECT  en.enc_id,
	en.create_timestamp AS enc_create_timestamp,
	en.created_by AS enc_created_by,
	e.enrollment_status,
	e.enrollment_created_time,
	e.enrollment_created_by,
	e.create_timestamp AS enroll_create_timestamp,
	e.modify_timestamp AS enroll_modify_timestamp,
	em.email_modified_time,
	em.email_modified_by,
	em.create_timestamp AS email_create_timestamp,
	em.modify_timestamp AS email_modify_timestamp,
	em.email_address,
	enc_rank=ROW_NUMBER() OVER(PARTITION BY en.person_id ORDER BY en.billable_ind DESC)
	FROM #ngweb_enrollment e
	LEFT JOIN #ngweb_email em ON (em.person_id = e.person_id) --AND (em.email_modified_time=e.enrollment_created_time) 
	LEFT JOIN [10.183.0.94].NGProd.dbo.patient_encounter en ON en.person_id=e.person_id AND (CAST(en.create_timestamp AS DATE)=e.enrollment_created_time OR CAST(en.create_timestamp AS DATE)=CAST(e.create_timestamp AS DATE) OR CAST(en.create_timestamp AS DATE)=CAST(em.modify_timestamp AS DATE) OR  CAST(en.create_timestamp AS DATE)=CAST(em.create_timestamp AS DATE) )
  ) f 
  WHERE f.enc_rank=1 AND f.enc_id IS NOT NULL






END
GO
