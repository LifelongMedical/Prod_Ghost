SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [etl].[update_chcn_roster]
	
AS
BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED;
	
--+++++++++++++++++++++  matching against NG

--delete all other clinics diffrent then LMC. I realized files has LA CLINICA DE LA RAZA patients informations. this way we will keep only  assigned LMC patients
	DELETE FROM [etl].[data_chcn_roster]
	WHERE REPLACE(chc,' ','')!='LMC'

--Deleting members dublicate by same day, month and year.There is no reason to keep the duplicate data by date 	
		; WITH  dublicateMembers
		AS( SELECT  membid,row_number() OVER ( PARTITION BY membid,SUBSTRING(sourcefile,14,8) ORDER BY membid ) AS nr FROM [etl].[data_chcn_roster])
		DELETE   FROM dublicateMembers WHERE nr>1	


update st
set st.match_candidate = pp.person_id
from [etl].[data_chcn_roster]  st
  inner join [10.183.0.94].NGProd.dbo.person_payer pp
    on st.patid = pp.policy_nbr
where st.patid in (
  select s.patid
  from etl.data_chcn_roster s
    inner join [10.183.0.94].NGProd.dbo.person_payer pp
      on s.patid = pp.policy_nbr
  group by s.patid
  having count(distinct pp.person_id) = 1
  ) AND st.is_patient_imported_to_final_table=0
    
-- match on first, last, dob, sex for those that match to uniq policy # on patid
update s
set s.ng_uniq_id = per.person_id
  ,s.match_info = 'A1: Pat ID = policy #, 1 person found, exact match 1st, last, DOB, sex'
from [etl].[data_chcn_roster]  s
  inner join [10.183.0.94].NGProd.dbo.person per
    on s.match_candidate = per.person_id
where replace(replace(s.firstnm, ' ', ''),'-','') = replace(replace(per.first_name, ' ', ''),'-','')
  and replace(replace(s.lastnm, ' ', ''),'-','') = replace(replace(per.last_name, ' ', ''),'-','')
  and s.dob = per.date_of_birth
  and s.sex = per.sex
  and s.ng_uniq_id is NULL 
  AND s.is_patient_imported_to_final_table=0

-- plan first name = left portion of NG name, exact match on last, dob, sex
update s
set s.ng_uniq_id = per.person_id
  ,s.match_info = 'A2: Pat ID = policy #, 1 person found, plan 1st = left part of NG first, exact match last, DOB, sex'
from [etl].[data_chcn_roster]  s
  inner join [10.183.0.94].NGProd.dbo.person per
    on s.match_candidate = per.person_id
where replace(replace(s.firstnm, ' ', ''),'-','') = 
      left(replace(replace(per.first_name, ' ', ''),'-',''), LEN(replace(replace(s.firstnm, ' ', ''),'-','')))
  and replace(replace(s.lastnm, ' ', ''),'-','') = replace(replace(per.last_name, ' ', ''),'-','')
  and s.dob = per.date_of_birth
  and s.sex = per.sex
  and s.ng_uniq_id is NULL
  AND s.is_patient_imported_to_final_table=0

-- left portion plan first name = NG name, exact match on last, dob, sex
update s
set s.ng_uniq_id = per.person_id
  ,s.match_info = 'A2: Pat ID = policy #, 1 person found, left part of plan 1st = NG first, exact match last, DOB, sex'
from [etl].[data_chcn_roster]  s
  inner join [10.183.0.94].NGProd.dbo.person per
    on s.match_candidate = per.person_id
where replace(replace(per.first_name, ' ', ''),'-','') = 
      left(replace(replace(s.firstnm, ' ', ''),'-',''), LEN(replace(replace(per.first_name, ' ', ''),'-','')))
  and replace(replace(s.lastnm, ' ', ''),'-','') = replace(replace(per.last_name, ' ', ''),'-','')
  and s.dob = per.date_of_birth
  and s.sex = per.sex
  and s.ng_uniq_id is NULL
  AND s.is_patient_imported_to_final_table=0


-- match on last, dob, sex for those that match to uniq policy # on patid
update s
set s.ng_uniq_id = per.person_id
  ,s.match_info = 'A3: Pat ID = policy #, 1 person found, exact match last, DOB, sex'
from [etl].[data_chcn_roster]  s
  inner join [10.183.0.94].NGProd.dbo.person per
    on s.match_candidate = per.person_id
where --replace(replace(s.firstnm, ' ', ''),'-','') = replace(replace(per.first_name, ' ', ''),'-','')
  replace(replace(s.lastnm, ' ', ''),'-','') = replace(replace(per.last_name, ' ', ''),'-','')
  and s.dob = per.date_of_birth
  and s.sex = per.sex
  and s.ng_uniq_id is NULL
  AND s.is_patient_imported_to_final_table=0

-- match on dob, sex for those that match to uniq policy # on patid
update s
set s.ng_uniq_id = per.person_id
  ,s.match_info = 'A4: Pat ID = policy #, 1 person found, exact DOB, sex'
from [etl].[data_chcn_roster]  s
  inner join [10.183.0.94].NGProd.dbo.person per
    on s.match_candidate = per.person_id
where s.dob = per.date_of_birth
  and s.sex = per.sex
  and s.ng_uniq_id is NULL
  AND s.is_patient_imported_to_final_table=0


-- identify those that match to multiple persons

update st
set st.match_info = 'Multiple persons matched on policy #'
from [etl].[data_chcn_roster]  st
  inner join [10.183.0.94].NGProd.dbo.person_payer pp
    on st.patid = pp.policy_nbr
where st.patid in (
  select s.patid
  from [etl].[data_chcn_roster]  s
    inner join [10.183.0.94].NGProd.dbo.person_payer pp
      on s.patid = pp.policy_nbr
  group by s.patid
  having count(distinct pp.person_id) > 1
  )  AND st.is_patient_imported_to_final_table=0
 


-- demographics only, no ID match
update s
set s.ng_uniq_id = per.person_id
  ,s.match_info = 'B1: No policy # match, but 1 person found on name, DOB, sex, SSN'
from [etl].[data_chcn_roster]  s
  inner join [10.183.0.94].NGProd.dbo.person per
    on replace(replace(s.firstnm, ' ', ''),'-','') = replace(replace(per.first_name, ' ', ''),'-','')
      and replace(replace(s.lastnm, ' ', ''),'-','') = replace(replace(per.last_name, ' ', ''),'-','')
      and s.dob = per.date_of_birth
      and s.sex = per.sex
      and s.subssn = per.ssn
where s.match_info is null
  and s.ng_uniq_id is NULL AND s.is_patient_imported_to_final_table=0
  and s.seq_no in (
-- test that only 1 NG record found
    select s.seq_no
    from [etl].[data_chcn_roster]  s
      inner join [10.183.0.94].NGProd.dbo.person per
        on replace(replace(s.firstnm, ' ', ''),'-','') = replace(replace(per.first_name, ' ', ''),'-','')
          and replace(replace(s.lastnm, ' ', ''),'-','') = replace(replace(per.last_name, ' ', ''),'-','')
          and s.dob = per.date_of_birth
          and s.sex = per.sex
          and s.subssn = per.ssn
    group by s.seq_no
    having COUNT(*) = 1
  )

update s
set s.ng_uniq_id = per.person_id
  ,s.match_info = 'B2: No policy # match, but 1 person found on name, DOB, sex'
from [etl].[data_chcn_roster]  s
  inner join [10.183.0.94].NGProd.dbo.person per
    on replace(replace(s.firstnm, ' ', ''),'-','') = replace(replace(per.first_name, ' ', ''),'-','')
      and replace(replace(s.lastnm, ' ', ''),'-','') = replace(replace(per.last_name, ' ', ''),'-','')
      and s.dob = per.date_of_birth
      and s.sex = per.sex
      --and s.subssn = per.ssn
where s.match_info is null
  and s.ng_uniq_id is NULL
  AND s.is_patient_imported_to_final_table=0
  and s.seq_no in (
-- test that only 1 NG record found
    select s.seq_no
    from [etl].[data_chcn_roster]  s
      inner join [10.183.0.94].NGProd.dbo.person per
        on replace(replace(s.firstnm, ' ', ''),'-','') = replace(replace(per.first_name, ' ', ''),'-','')
          and replace(replace(s.lastnm, ' ', ''),'-','') = replace(replace(per.last_name, ' ', ''),'-','')
          and s.dob = per.date_of_birth
          and s.sex = per.sex
          --and s.subssn = per.ssn
    group by s.seq_no
    having COUNT(*) = 1
  )

    -- Insert statements for procedure here
	
END
GO
