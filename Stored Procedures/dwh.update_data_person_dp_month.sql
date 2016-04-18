
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ben Mansalis
-- Create date: 7/2015
-- Description:	This procedure builds the key table for Lifelong's DW solution.
--              This table is unique by patient and month identifier.
--              This table creates a number of Facts and dimensions
--              This table includes a set of special population flags and
--              slowly changing dimensions (SCD) of key attributes.  This table is the part of the 
--              building blocks for the building of the patient dimension table this
--              table helps build the SCD component of the patient dimension table.
--              This table includes joins to other tables to 
--              grab key identifiers by month with means there will be dependencies
--              that require building other tables first.
--
--UPDATE:  I am thinking about changing the design of the datawarehouse to have three tables associated with 
--         the patients table

--UPDATE: 4/11/2016 <Julius Abate>
--		Altered procedure so windowing functions use person_key instead of person_id, now that ECW patient data has been merged
--
--
--There are three kinds of data that we include -- Fact Data:
--												-- Fact table for patients which will derive patient counts for special populations with dependencies
--                                              ---like Controlled substances and Quality data is out of control HTN? Out of control DM2
--												-- and Facts that wont have a dependcy -- new patient visit?, Visit that month? Deceased that month
												-- Dimension Data:
												--											    -- Non dependent NG build SCD, Member months, Age
--												-- Dependent on processed NG SCD like is this a chronic pain patient that month or active patient that month?

-- I think the best architecture is to have one person_month database that has dependencies and one that does not and then merge the two into a final datamart at the end of the build
-- It is necessary to build the non-dependent person_table first so that it is available for merge onto other datamarts.  


-- Dependency:  data_pharmacy
--              data_time 
--
--Facts: -- can be summed but also included in a degenerate dimension of flags to count special populations
--Special populations:
--nbr_new_pt   --This uses the same logic as Membermonths--When MemberMonth =1 then Nbr_new_pt = 1 else it will be 0
               --MemberMonth 1 and Nbr_new_pt 1 is the month of the first encounter or person table record creation
			   --It is possible that a patient is enrolled into the person table and never has an encounter
			   --In which case this logic would count folks who never made an appointment and it might
			   --overstate our membership
--nbr_pt_ever_enrolled
               --This flag is set to 1 once a patient has a memberMonth >0

--nbr_pt_deceased --This is the number of patients that are deceased.  Once a patient is expired
                 --this flag is set to one for all subsequent visits
--nbr_pt_deceased_this_month -- This flag is set only the month of death to 1 else it is 0



--Fixed Dimensions:  Not sure if I need to keep cur dimensions in this table.  Could simple build that in the dimensions table
--                   In some ways it would be easier to build them all off this table.  Still deciding
--
--PCP_cur_id:
--MH_loc_cur_id:
--
--SCDs: The following are a list of the slowly changing dimensions that are pulled to the person table
 
--memberMonths -- Which is the number of months the patient has been a member, if there is no first office 
               --date in NG it uses the timestamp of the person table record as the first office date. 
			   --Patients that are expired are set to NULL 
                 --


--PCP_hx_ID -- this is the PCP of the current month and year.  Modeling historical PCP is a challenge.  I am including a place
--             holder for this dimension.  Here is a little bit of a dicussion around the difficulties of modeling this dimesion
--One approach:
--Use the sig_events table to model these changes in a separate table
--But how do you model changes that might not be recorded
--need to make a decision about what to do when the current PCP does not match the last SIG-EVENT, we need to use a fixed interval of time
--to keep the last SIG_EVENTS pcp and then switch over to the current PCP.  This creates a fiction in the history, but may be the only way we
--can model this.  Would want to get a sense of how frequently this happens before making this possible.
--
--MH_loc_hx_id -- same issue for changes as PCP_hx_id


-- Future:
-- Make sure to add foreign and primary key constraints and integer keys

-- =============================================







CREATE PROCEDURE [dwh].[update_data_person_dp_month]
AS
 BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
       IF OBJECT_ID('dwh.data_person_dp_month') IS NOT NULL
            DROP TABLE dwh.data_person_dp_month

	   IF OBJECT_ID('tempdb..#person_list') IS NOT NULL
            DROP TABLE #person_list

	   IF OBJECT_ID('tempdb..#last_visit') IS NOT NULL
            DROP TABLE #last_visit

     --Ok First go to the enc and appt table and grab all the per_mon_id with nbr_billable_enc =1
     --Then create a lagging variable for different counts
     --Then save back to the table dp table.
     --Then create new fact table with that data

     --Add counts of PCP changes (Probably should do that in NP)
     --Add countts of Medical Home Changes

        DECLARE @build_dt_start VARCHAR(8)

        SET @build_dt_start = '20100301';

         SELECT DISTINCT per_mon_id ,
                                nbr_bill_enc
                       INTO #enc_app
                       FROM     dwh.data_appointment
                       WHERE    nbr_bill_enc = 1

		SELECT DISTINCT person_key
			   INTO #person_list
			   FROM dwh.data_person_nd_month

		SELECT
			p.person_key,
			(SELECT TOP 1 enc_app_date
							FROM dwh.data_appointment app
							WHERE app.person_key = p.person_key
							AND app.nbr_bill_enc = 1
							AND app.enc_app_date < GETDATE()
							ORDER BY app.enc_app_date DESC) AS last_enc_date,

			(SELECT TOP 1 enc_app_date
							FROM dwh.data_appointment app
							WHERE app.person_key = p.person_key
							AND app.nbr_appts = 1
							AND app.enc_app_date < GETDATE()
							ORDER BY app.enc_app_date DESC) AS last_appt_date,

			(SELECT TOP 1 prov.FullName
							FROM dwh.data_appointment app
							INNER JOIN dwh.data_provider prov ON prov.provider_key = app.provider_key
							WHERE app.person_key = p.person_key
							AND app.nbr_bill_enc = 1
							AND app.enc_app_date < GETDATE()
							ORDER BY app.enc_app_date DESC) AS last_enc_provider,

			(SELECT TOP 1 prov.FullName
							FROM dwh.data_appointment app
							INNER JOIN dwh.data_provider prov ON prov.provider_key = app.provider_key
							WHERE app.person_key = p.person_key
							AND app.nbr_appts = 1
							AND app.enc_app_date < GETDATE()
							ORDER BY app.enc_app_date DESC) AS last_appt_provider,

			(SELECT TOP 1 enc_app_date
							FROM dwh.data_appointment app
							WHERE app.person_key = p.person_key
							AND app.nbr_appts = 1
							AND app.enc_app_date >= GETDATE()
							ORDER BY app.enc_app_date ASC) AS next_appt_date,

			(SELECT TOP 1 prov.FullName
							FROM dwh.data_appointment app
							INNER JOIN dwh.data_provider prov ON prov.provider_key = app.provider_key
							WHERE app.person_key = p.person_key
							AND app.nbr_appts = 1
							AND app.enc_app_date >= GETDATE()
							ORDER BY app.enc_app_date ASC) AS next_appt_provider


			INTO #last_visit
			FROM #person_list p





            SELECT 
                    dp.* ,
					--Checks if patients had an encounter over a certain period of time, making them active by LifeLong standards
					--person_key was created specifically to use in this situation, as it is an ID field which is not null for any patient
                    MAX(ISNULL(ea.nbr_bill_enc, 0)) OVER ( PARTITION BY dp.person_key ORDER BY dp.first_mon_date ASC  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) AS nbr_pt_act_3m ,
                    MAX(ISNULL(ea.nbr_bill_enc, 0)) OVER ( PARTITION BY dp.person_key ORDER BY dp.first_mon_date ASC  ROWS BETWEEN 5 PRECEDING AND CURRENT ROW ) AS nbr_pt_act_6m ,
                    MAX(ISNULL(ea.nbr_bill_enc, 0)) OVER ( PARTITION BY dp.person_key ORDER BY dp.first_mon_date ASC  ROWS BETWEEN 11 PRECEDING AND CURRENT ROW ) AS nbr_pt_act_12m ,
                    MAX(ISNULL(ea.nbr_bill_enc, 0)) OVER ( PARTITION BY dp.person_key ORDER BY dp.first_mon_date ASC  ROWS BETWEEN 17 PRECEDING AND CURRENT ROW ) AS nbr_pt_act_18m ,
                    MAX(ISNULL(ea.nbr_bill_enc, 0)) OVER ( PARTITION BY dp.person_key ORDER BY dp.first_mon_date ASC  ROWS BETWEEN 23 PRECEDING AND CURRENT ROW ) AS nbr_pt_act_24m ,
                    IIF(LAG(dp.mh_hx_key, 1) OVER ( PARTITION BY dp.person_key ORDER BY dp.first_mon_date ASC ) != dp.mh_hx_key, 1, 0) AS nbr_pt_mh_change ,
                    IIF(LAG(dp.pcp_hx_key, 1) OVER ( PARTITION BY dp.person_key ORDER BY dp.first_mon_date ASC ) != dp.pcp_hx_key, 1, 0) AS nbr_pt_pcp_change ,
                    IIF(MAX(ISNULL(ea.nbr_bill_enc, 0)) OVER ( PARTITION BY dp.person_key ) = 0, 1, 0) AS nbr_pt_never_active

            INTO #temp1
            FROM    dwh.data_person_nd_month dp
                    LEFT JOIN #enc_app ea ON ea.per_mon_id = dp.per_mon_id;

--clean up zip data by matching first 5 digits to zip data from a clean list of zip codes
UPDATE  dp

    set  zip = (SELECT TOP 1 ez.zipcode FROM etl.data_zipcode ez WHERE LEFT(dp.[zip],5) = LEFT(ez.zipcode,5) )

FROM  #temp1 dp

--Any patients not listed active in a period are listed as inactive
SELECT t.*, 
		--concatenate address fields into a long form address, to be used in geocoding reports
		t.[address_line_1] +' ' +t.[address_line_2]+' '+t.[city]+' '+ t.[state]+' '+t.[zip] AS [Address Full],
                    CASE WHEN COALESCE(t.nbr_pt_act_3m,0)=0 THEN 1 ELSE 0 end AS nbr_pt_inact_3m ,
                    CASE WHEN COALESCE(t.nbr_pt_act_6m,0)=0 THEN 1 ELSE 0 END AS nbr_pt_inact_6m ,
                    CASE WHEN COALESCE(t.nbr_pt_act_12m,0)=0 THEN 1 ELSE 0 END AS nbr_pt_inact_12m ,
                    CASE WHEN COALESCE(t.nbr_pt_act_18m,0)=0 THEN 1 ELSE 0 END AS nbr_pt_inact_18m ,
                    CASE WHEN COALESCE(t.nbr_pt_act_24m,0)=0 THEN 1 ELSE 0 END AS nbr_pt_inact_24m,
					v.last_enc_date,
					v.last_appt_date,
					v.last_enc_provider,
					v.last_appt_provider,
					v.next_appt_date,
					v.next_appt_provider

 INTO dwh.data_person_dp_month 
 FROM #temp1 t
 LEFT JOIN #last_visit v ON v.person_key = t.person_key 

        ALTER TABLE Prod_Ghost.dwh.data_person_dp_month
        ADD CONSTRAINT per_mon_id_pk32 PRIMARY KEY (per_mon_id);

    END;




                  

	
GO
