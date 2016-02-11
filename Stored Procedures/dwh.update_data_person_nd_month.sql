SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ben Mansalis
-- Create date: 7/2015
-- Description:	This procedure builds the nd (non-dependency) key table for Lifelong's DW solution.
--              This table builds the per_mon_id that is used in all of the other areas in the datawarehouse
--              The two exceptions to the dependency is the location table and provider tables from the dwh
--              must be built first.
--
--              This table includes all the person table data and key patient table data that is merged
--              in a denormalized form for ease of use.  
--              --The dimension fields with most recent data name _cur_ in the variable
--              --All fields that include hx are a reconstruction/best guess of historical dimension information.
--      
--              For historical dimension changes are of the last of the month
--              For example if the person died on the second of the month then the person
--              would be noted as living for that month, by deceased the following month
--
--              This table is unique by patient and month identifier.
--
--               
--              This table creates a number Fact flag fields (FFF for use in Fact Tables) and includes
--              A number of dimension fields that are repeated for each row (denormalized)
--              This table will encentually be merged with the SCD person table

--Dependencies:
--  dwh.data_locaton
--  dwh.data_user            
--
--Key or dimension fields:
-- per_mon_id = integer key unique by person_id/First_mon_date
-- first_mon_date = This is date of the first of the month 
-- mh_cur_key = This is the key for the most recent the medical home - references data_location table based on NG person_ud table, user_demo_ID3 field
-- mh_hx_key = This the key of historical medical home created from the sig_events table giving historical medical home information
-- pcp_cur_key = This is the most recent primary care provider references data_provider table based on NG table primarycareprovider_ID
-- pcp_hx_key =  This is the key of this historical pcp created from the NG sig_events table 
-- status_cur_key = Is a variable not integer of the patients most recent status
-- status_hx_key = Is a variable not integer of the patients historical status


--Calculated fields

--All month calculations roll the date based calculations to the first of the month for more consistency in counting
--For example if a patient first office visit is on 8/30/2015 then his member month for
--
--Special populations:
--nbr_new_pt  --This uses the same logic as First_enc_age_months --When First_enc_age_months  =1 then nbr_new_pt = 1 else it will be 0
               --First_enc_age_months = 1 and nbr_new_pt 1 is the month of the first encounter 
			   --It is possible that a patient is enrolled into the person table and never has an encounter

--nbr_pt_seen_office_ever
               --This flag is set to 1 once a patient has a memberMonth >0

--nbr_pt_deceased --This is the number of patients that are deceased.  Once a patient is expired
                 --this flag is set to one for all subsequent months
--nbr_pt_deceased_this_month -- This flag is set only the month of death to 1 else it is 0

--First_enc_age_months -- Which is the number of months the patient has been a member, if there is no first office encounter date
               -- populated in the person table it goes out to the encounter table and gets the first date of the encounter

--Pulled fields from patient and person tables -- currently we are not modeling hx data for these fields and the reflect only
--most recent data
--last_name 
--first_name 
--middle_name 
--address_line_1 
--address_line_2 
--city 
--state 
--zip 
--home_phone 
--sex 
--ssn 
--date_of_birth 
--alt_phone 
--marital_status 
--race 
--language 
--med_rec_nbr


-- Future:
-- Make sure to add foreign and primary key constraints and integer keys

-- =============================================




Create PROCEDURE [dwh].[update_data_person_nd_month]
AS
    BEGIN
	
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
        SET ANSI_NULLS ON;
        SET QUOTED_IDENTIFIER ON;

        IF OBJECT_ID('dwh.data_person_nd_month') IS NOT NULL
            DROP TABLE dwh.data_person_nd_month;

		--What date range to include in the person month table?
		--Since the earliest implementation date is 20100301 all data starts at that point to the current date
		
        DECLARE @build_dt_start VARCHAR(8) ,
            @build_dt_end VARCHAR(8) ,
            @Build_counter VARCHAR(8);


        SET @build_dt_start = CONVERT(VARCHAR(8), DATEADD(MONTH,6,GETDATE()));
        SET @build_dt_end = CONVERT(VARCHAR(8), GETDATE(), 112);
        SET @build_dt_start = '20100301';
		
        
                 SELECT   per.person_id ,
                                COALESCE(per.expired_date, '') AS expired_date ,
                                per.primarycare_prov_id ,
                                COALESCE(LTRIM(RTRIM(per.first_name)) + ' ' + LTRIM(RTRIM(per.middle_name)) + ' '
                                         + LTRIM(RTRIM(per.last_name)), '') AS full_name ,
                                COALESCE(per.last_name, '') AS last_name ,
                                COALESCE(per.first_name, '') AS first_name ,
                                COALESCE(per.middle_name, '') AS middle_name ,
                                COALESCE(per.date_of_birth, '') AS dob ,
                                COALESCE(per.address_line_1, '') AS address_line_1 ,
                                COALESCE(per.address_line_2, '') AS address_line_2 ,
                                COALESCE(per.city, '') AS city ,
                                COALESCE(per.state, '') AS state ,
                                COALESCE(per.zip, '') AS zip ,
                                COALESCE(per.home_phone, '') AS home_phone ,
                                COALESCE(per.sex, '') AS sex ,
                                COALESCE(per.ssn, '') AS ssn ,
                                COALESCE(per.alt_phone, '') AS alt_phone ,
                                COALESCE(per.marital_status, '') AS marital_status ,
                                COALESCE(per.race, '') AS race ,
                                COALESCE(per.language, '') AS language ,
                                COALESCE(per.ethnicity, '') AS ethnicity ,
                                COALESCE(pat.med_rec_nbr, '') AS med_rec_nbr
                      
					  into #person_patient
					  FROM     [10.183.0.94].NGProd.dbo.person per
                                LEFT JOIN [10.183.0.94].NGProd.dbo.patient pat ON per.person_id = pat.person_id
               



               
                  --DQ Issue -
                  -- This table brings in the actual visit data for first office encounter as the NG field appears on audit to be unreliable.
                 SELECT   per.person_id ,
                                enc.billable_timestamp AS cr_first_bill_enc_date ,
                                pat.first_office_enc_date ,
                                CASE WHEN ISDATE(enc.billable_timestamp) = 1
                                          AND ISDATE(pat.first_office_enc_date) = 1
                                          AND COALESCE(pat.first_office_enc_date, '') < COALESCE(enc.billable_timestamp,
                                                                                                 '')
                                     THEN CAST(pat.first_office_enc_date AS DATE)
                                     WHEN ISDATE(enc.billable_timestamp) = 1 THEN CAST(enc.billable_timestamp AS DATE)
                                     ELSE NULL
                                END AS cr_first_office_enc_date ,
                                ROW_NUMBER() OVER ( PARTITION BY per.person_id ORDER BY enc.billable_timestamp ASC ) AS Enc_row
                       INTO  #first_enc_date_scrub
					   FROM     [10.183.0.94].NGProd.dbo.person per
                                LEFT JOIN [10.183.0.94].NGProd.dbo.patient pat ON per.person_id = pat.person_id
                                LEFT JOIN [10.183.0.94].NGProd.dbo.patient_encounter enc ON per.person_id = enc.person_id
                       WHERE    enc.billable_ind = 'Y'
                    
                
                  -- Bring in location_key for medical_home 
                  SELECT   per.person_id AS person_id ,
                                loc.location_key AS mh_cur_key
                       
					   INTO #mh_location_id_remap
					   FROM     [10.183.0.94].NGProd.dbo.person per
                                LEFT JOIN [10.183.0.94].NGProd.dbo.person_ud ud ON per.person_id = ud.person_id
                                LEFT JOIN [10.183.0.94].NGProd.dbo.patient pat ON per.person_id = pat.person_id
                                LEFT JOIN Prod_Ghost.dwh.data_location loc ON loc.ud_demo3_id = ud.ud_demo3_id
								AND [location_id_unique_flag] =1
                    
                
                  -- Bring in location_key for medical_home 
                   SELECT   per.person_id AS person_id ,
                                pro.user_key AS pcp_cur_key
                       INTO #pcp_remap
					   FROM     [10.183.0.94].NGProd.dbo.person per
                                LEFT JOIN Prod_Ghost.dwh.data_user pro ON per.primarycare_prov_id = pro.provider_id
								WHERE pro.unique_provider_id_flag =1 
                    
                
                  -- This table brings in the actual visit data for first office encounter as the NG field appears on audit to be unreliable.
                   SELECT   ps.person_id ,
                                psm.description AS patient_status_cur
                       INTO #Status
					   FROM     [10.183.0.94].NGProd.dbo.patient_status ps
                                LEFT JOIN [10.183.0.94].NGProd.dbo.patient_status_mstr psm ON ps.patient_status_id = psm.patient_status_id
                  
	
				     
                
                   SELECT   pp.person_id ,
                                pp.full_name ,
                                pp.first_name ,
                                pp.last_name ,
                                pp.middle_name ,
                                CASE WHEN ISDATE(pp.dob) = 1 THEN CAST(pp.dob AS DATE)
                                     ELSE NULL
                                END AS dob ,
                                CASE WHEN ISDATE(pp.expired_date) = 1 THEN CAST(pp.expired_date AS DATE)
                                     ELSE NULL
                                END AS expired_date ,
                                pp.address_line_1 ,
                                pp.address_line_2 ,
                                pp.city ,
                                pp.state ,
                                pp.zip ,
                                pp.home_phone ,
                                pp.sex ,
                                pp.ssn ,
                                pp.alt_phone ,
                                pp.marital_status ,
                                pp.race ,
                                pp.ethnicity ,
                                pp.language ,
                                pp.med_rec_nbr ,
                                tim.first_mon_date ,
                                mh.mh_cur_key ,
                                pcp.pcp_cur_key ,
                                fed.cr_first_office_enc_date ,
                                CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112) AS patient_vintage ,
                                COALESCE(st.patient_status_cur, '') AS status_cur_key ,
                  
	              --First_Enc_Age_months can be time since first encounter or zero if no encounters ever
                                CASE 
				  --Expired, but not yet expired, Has had an encounter in the past -- calculate months since first encounter
                                     WHEN ISDATE(pp.expired_date) = 1
                                          --date of census is before the person expired
										  AND tim.first_mon_date < CAST(CONVERT(VARCHAR(6), pp.expired_date, 112)
                                          + '01' AS DATE)
                                         --date of census is after the first office encounter date
										  AND tim.first_mon_date >= CAST(CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112)
                                          + '01' AS DATE)
																		  
                                     THEN DATEDIFF(m,
                                                   CAST(CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112) + '01' AS DATE),
                                                   tim.first_mon_date) + 1



                  --Expired and has had encounter at some point -- Age is fixed to the number of months to death date
				  --I have commented out this section.  Once a person has expired they will no longer have a first enc AGE
				   -- This is similar to the logic I use for actual age

                           /*          WHEN ISDATE(pp.expired_date) = 1

									    --census date is after the person expired
                                          AND tim.first_mon_date >= CAST(CONVERT(VARCHAR(6), pp.expired_date, 112) + '01' AS DATE)
										  -- and the person has had a first visit
                                          AND fed.cr_first_office_enc_date IS  NOT NULL
										  AND CAST(CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112)
                                          + '01' AS DATE) >= tim.first_mon_date
                                     THEN DATEDIFF(m,
                                                   CAST(CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112) + '01' AS DATE),
                                                   CAST(CONVERT(VARCHAR(6), pp.expired_date, 112) + '01' AS DATE)) + 1
				  
				  */
				  
				   --Has never expired and has had an encounter in the past
                                     WHEN ISDATE(pp.expired_date) = 0
                                          AND fed.cr_first_office_enc_date IS  NOT NULL
                                          AND tim.first_mon_date >= CAST(CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112)
                                          + '01' AS DATE)
                                     THEN DATEDIFF(m,
                                                   CAST(CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112) + '01' AS DATE),
                                                   tim.first_mon_date) + 1
                                     ELSE NULL
				  
				  
				  --Expired, but not yet expired, But they havent yet had there first enounter
				  --Has expired and has never had an ecounter
                                END AS First_enc_age_months ,

				  				                
						--Create a New patient Flag 1 or 0 (expired patients do not get a NULL-- for the month the patient has their first encounter	
                                CASE  	                                 --This means when the first office visit is populated and is greater than the current date
                                     WHEN tim.first_mon_date = CAST(CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112)
                                          + '01' AS DATE) THEN 1
                                     ELSE 0
                                END AS nbr_new_pt ,
                                CASE  
	          --This means when the first office visit is populated and is greater than the current date
                                     WHEN cr_first_office_enc_date IS NOT NULL
                                          AND tim.first_mon_date >= CAST(CONVERT(VARCHAR(6), fed.cr_first_office_enc_date, 112)
                                          + '01' AS DATE) THEN 1
                                     ELSE 0
                                END AS nbr_pt_seen_office_ever ,
                                CASE WHEN ISDATE(pp.expired_date) = 1
                                          AND tim.first_mon_date >= CAST(CONVERT(VARCHAR(6), pp.expired_date, 112)
                                          + '01' AS DATE) THEN 1
                                     ELSE 0
                                END AS nbr_pt_deceased ,
                                CASE WHEN ISDATE(pp.expired_date) = 1
                                          AND CAST(CONVERT(CHAR(6), pp.expired_date, 112) + '01' AS DATE) = tim.first_mon_date
                                     THEN 1
                                     ELSE 0
                                END AS nbr_pt_deceased_this_month
                       INTO #ND_roll_up
					   FROM     #person_patient pp
                                LEFT JOIN #mh_location_id_remap mh ON pp.person_id = mh.person_id
                                LEFT JOIN #Status st ON st.person_id = pp.person_id
                                LEFT JOIN #pcp_remap pcp ON pcp.person_id = pp.person_id
                                LEFT JOIN ( SELECT  cr_first_office_enc_date ,
                                                    person_id ,
                                                    cr_first_bill_enc_date ,
                                                    first_office_enc_date
                                            FROM    #first_enc_date_scrub
                                            WHERE   #first_enc_date_scrub.Enc_row = 1
                                          ) fed ON fed.person_id = pp.person_id
                                CROSS JOIN ( SELECT DISTINCT
                                                    first_mon_date
                                             FROM   Prod_Ghost.dwh.data_time
                                             WHERE  first_mon_date >= CAST(@build_dt_start AS DATETIME)
                                                    AND first_mon_date <= CAST(@build_dt_end AS DATETIME)
                                           ) tim
                    

        
                   SELECT   mh.person_id ,
                                mh.mh_changed_from_name ,
                                mh.mh_changed_to_name ,
                                mh.last_changed_date ,
                                mh.next_changed_date ,
                                mh.mh_changed_date ,
                                mh.last_Change ,
                                ROW_NUMBER() OVER ( PARTITION BY mh.person_id ORDER BY mh.create_timestamp ASC ) AS change_count
                       INTO #Hx_med_home
					   FROM     ( SELECT    source1_id AS person_id ,
                                            pre_mod AS mh_changed_from_name ,
                                            post_mod AS mh_changed_to_name ,
                                            create_timestamp ,
                                            LAG(CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE), 1,
                                                CAST(@build_dt_start AS DATE)) OVER ( PARTITION BY source1_id ORDER BY create_timestamp ASC ) AS last_changed_date ,
                                            LEAD(CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE), 1,
                                                 CAST(@build_dt_end AS DATE)) OVER ( PARTITION BY source1_id ORDER BY create_timestamp ASC ) AS next_changed_date ,
                                            CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE) AS mh_changed_date ,
                                            ROW_NUMBER() OVER ( PARTITION BY source1_id,
                                                                CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE) ORDER BY create_timestamp DESC ) AS last_Change
                                  FROM      [10.183.0.94].NGProd.dbo.sig_events
                                  WHERE     CAST(sig_msg AS VARCHAR(18)) = 'Medical Home  from'
                                ) mh
                       WHERE    mh.last_Change = 1
                    

		
                  SELECT   hpcp.person_id ,
                                hpcp.pcp_changed_from_name ,
                                hpcp.pcp_changed_to_name ,
                                hpcp.last_changed_date ,
                                hpcp.next_changed_date ,
                                hpcp.pcp_changed_date ,
                                hpcp.last_Change ,
                                ROW_NUMBER() OVER ( PARTITION BY hpcp.person_id ORDER BY hpcp.create_timestamp ASC ) AS change_count
                       INTO #Hx_pcp
					   FROM     ( SELECT    source1_id AS person_id ,
                                            pre_mod AS pcp_changed_from_name ,
                                            post_mod AS pcp_changed_to_name ,
                                            create_timestamp ,
                                            LAG(CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE), 1,
                                                CAST(@build_dt_start AS DATE)) OVER ( PARTITION BY source1_id ORDER BY create_timestamp ASC ) AS last_changed_date ,
                                            LEAD(CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE), 1,
                                                 CAST(@build_dt_end AS DATE)) OVER ( PARTITION BY source1_id ORDER BY create_timestamp ASC ) AS next_changed_date ,
                                            CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE) AS pcp_changed_date ,
                                            ROW_NUMBER() OVER ( PARTITION BY source1_id,
                                                                CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE) ORDER BY create_timestamp DESC ) AS last_Change
                                  FROM      [10.183.0.94].NGProd.dbo.sig_events
                                  WHERE     CAST(sig_msg AS VARCHAR(29)) = 'Primary Care Provider Changed'
                                ) hpcp
                       WHERE    hpcp.last_Change = 1
                     
                                              			  
	
                   SELECT   nr.person_id ,
                                nr.first_mon_date ,
                               
				    -- next check if most recent medical home is the last medical home change
					-- if never medical home change then set all historical medical data to current medical home
					-- if there has been a change but last change does not == current medical home then keep the last
					-- change only for 3  months after the change (4 months total including change month)
					--  If mh does not appear in the look up key or it is set to unassigned or unknown clinic, then assigned key is NULL
                                CASE WHEN nr.pcp_cur_key != ( SELECT TOP 1  -- yes I wish I didn't have to use top, but the DQ issues are so prevelant that this is a work around.  
                                                                        user_key
                                                              FROM      Prod_Ghost.dwh.data_user
                                                              WHERE     COALESCE(pcp.pcp_changed_to_name,
                                                                                 pcp_pre.pcp_changed_from_name) = provider_name
																	    AND  [unique_provider_id_flag]=1
                                                              ORDER BY  provider_name ,
                                                                        delete_ind
                                                            )
                                          AND pcp.change_count >= 1
                                          AND MAX(pcp.change_count) OVER ( PARTITION BY nr.person_id ) = pcp.change_count
                                          AND DATEDIFF(m, COALESCE(pcp.pcp_changed_date, pcp_pre.pcp_changed_date),
                                                       nr.first_mon_date) > 3 THEN nr.pcp_cur_key
                                    --if the mh was never tracked change the assign it to the current key
                                     WHEN MAX(pcp.change_count) OVER ( PARTITION BY nr.person_id ) IS NULL
                                     THEN nr.pcp_cur_key
                                     ELSE ( SELECT TOP 1
                                                    user_key
                                            FROM    Prod_Ghost.dwh.data_user
                                            WHERE   COALESCE(pcp.pcp_changed_to_name, pcp_pre.pcp_changed_from_name) = provider_name
											           AND  [unique_provider_id_flag]=1
                                            ORDER BY provider_name ,
                                                    delete_ind)
                                          
                                END AS pcp_hx_key
                       INTO #Hx_pcp_process
					   FROM     #ND_roll_up nr --Populate change tracking data -- add it based on the date of the change going forward until the month before the next change
								--A few comments about changes -- There is a possibility that this could introduce duplicates if change tracking records
								--get merged onto same first_mon_date, my audit shows that based on typical behavior this is not happening
								--Would be worth checking for this constraint.
								--If this routine ever gets moved to production there could be an instance where the first_mon_date = @build_dt_end and 
								--a tracked change was made to the medical home on the same day, its possible that the change will not be tracked
                                LEFT JOIN #Hx_pcp pcp ON pcp.person_id = nr.person_id
                                                        AND nr.first_mon_date >= pcp.pcp_changed_date
                                                        AND nr.first_mon_date > pcp.last_changed_date
                                                        AND nr.first_mon_date < pcp.next_changed_date
                                
								--Populate Hx based on build date with changed from information if available up until the month before the next change date
                                LEFT JOIN #Hx_pcp pcp_pre ON pcp_pre.person_id = nr.person_id
                                                            AND pcp_pre.last_changed_date = CAST(@build_dt_start AS DATE)
                                                            AND nr.first_mon_date < pcp_pre.pcp_changed_date
                    
              
                   SELECT   hstatus.person_id ,
                                hstatus.status_changed_from_name ,
                                hstatus.status_changed_to_name ,
                                hstatus.last_changed_date ,
                                hstatus.next_changed_date ,
                                hstatus.status_changed_date ,
                                hstatus.last_Change ,
                                ROW_NUMBER() OVER ( PARTITION BY hstatus.person_id ORDER BY hstatus.create_timestamp ASC ) AS change_count
                       INTO #Hx_status
					   FROM     ( SELECT    source1_id AS person_id ,
                                            pre_mod AS status_changed_from_name ,
                                            post_mod AS status_changed_to_name ,
                                            create_timestamp ,
                                            LAG(CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE), 1,
                                                CAST(@build_dt_start AS DATE)) OVER ( PARTITION BY source1_id ORDER BY create_timestamp ASC ) AS last_changed_date ,
                                            LEAD(CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE), 1,
                                                 CAST(@build_dt_end AS DATE)) OVER ( PARTITION BY source1_id ORDER BY create_timestamp ASC ) AS next_changed_date ,
                                            CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE) AS status_changed_date ,
                                            ROW_NUMBER() OVER ( PARTITION BY source1_id,
                                                                CAST(CONVERT(VARCHAR(6), create_timestamp, 112) + '01' AS DATE) ORDER BY create_timestamp DESC ) AS last_Change
                                  
								  FROM      [10.183.0.94].NGProd.dbo.sig_events
                                  WHERE     sig_msg = 'Patient Status Changed'
                                ) hstatus
                       WHERE    hstatus.last_Change = 1
                   
				  
                
                  SELECT   nr.person_id ,
                                nr.first_mon_date ,
                               
				    -- next check if most recent medical home is the last medical home change
					-- if never medical home change then set all historical medical data to current medical home
					-- if there has been a change but last change does not == current medical home then keep the last
					-- change only for 3  months after the change (4 months total including change month)
					--  If mh does not appear in the look up key or it is set to unassigned or unknown clinic, then assigned key is NULL
                                CASE WHEN nr.status_cur_key != COALESCE(stat.status_changed_to_name,
                                                                        stat_pre.status_changed_from_name)
                                          AND stat.change_count >= 1
                                          AND MAX(stat.change_count) OVER ( PARTITION BY nr.person_id ) = stat.change_count
                                          AND DATEDIFF(m,
                                                       COALESCE(stat.status_changed_date, stat_pre.status_changed_date),
                                                       nr.first_mon_date) > 3 THEN nr.status_cur_key
                                    --if the mh was never tracked change the assign it to the current key
                                     WHEN MAX(stat.change_count) OVER ( PARTITION BY nr.person_id ) IS NULL
                                     THEN nr.status_cur_key
                                     ELSE COALESCE(stat.status_changed_to_name, stat_pre.status_changed_from_name)
                                END AS status_hx_key
                       
					   INTO #Hx_status_process
					   FROM     #ND_roll_up nr --Populate change tracking data -- add it based on the date of the change going forward until the month before the next change
								--A few comments about changes -- There is a possibility that this could introduce duplicates if change tracking records
								--get merged onto same first_mon_date, my audit shows that based on typical behavior this is not happening
								--Would be worth checking for this constraint.
								--If this routine ever gets moved to production there could be an instance where the first_mon_date = @build_dt_end and 
								--a tracked change was made to the medical home on the same day, its possible that the change will not be tracked
                                LEFT JOIN #Hx_status stat ON stat.person_id = nr.person_id
                                                            AND nr.first_mon_date >= stat.status_changed_date
                                                            AND nr.first_mon_date > stat.last_changed_date
                                                            AND nr.first_mon_date < stat.next_changed_date
                                
								--Populate Hx based on build date with changed from information if available up until the month before the next change date
                                LEFT JOIN #Hx_status stat_pre ON stat_pre.person_id = nr.person_id
                                                                AND stat_pre.last_changed_date = CAST(@build_dt_start AS DATE)
                                                                AND nr.first_mon_date < stat_pre.status_changed_date
                    
                 
				     	
                   SELECT   nr.person_id ,
                                nr.first_mon_date ,
                               
				    -- next check if most recent medical home is the last medical home change
					-- if never medical home change then set all historical medical data to current medical home
					-- if there has been a change but last change does not == current medical home then keep the last
					-- change only for 3  months after the change (4 months total including change month)
					--  If mh does not appear in the look up key or it is set to unassigned or unknown clinic, then assigned key is NULL
                                CASE WHEN nr.mh_cur_key != ( SELECT TOP 1 location_key
                                                             FROM   Prod_Ghost.dwh.data_location
                                                             WHERE  COALESCE(hmh.mh_changed_to_name,
                                                                             hmh_pre.mh_changed_from_name) = location_mh_name

																			AND [location_id_unique_flag] =1
                                                           )
                                          AND hmh.change_count >= 1
                                          AND MAX(hmh.change_count) OVER ( PARTITION BY nr.person_id ) = hmh.change_count
                                          AND DATEDIFF(m, COALESCE(hmh.mh_changed_date, hmh_pre.mh_changed_date),
                                                       nr.first_mon_date) > 3 THEN nr.mh_cur_key
                                    --if the mh was never tracked change the assign it to the current key
                                     WHEN MAX(hmh.change_count) OVER ( PARTITION BY nr.person_id ) IS NULL
                                     THEN nr.mh_cur_key
                                     ELSE ( SELECT  TOP 1 location_key
                                            FROM    Prod_Ghost.dwh.data_location
                                            WHERE   COALESCE(hmh.mh_changed_to_name, hmh_pre.mh_changed_from_name) = location_mh_name
											AND [location_id_unique_flag] =1
                                          )
                                END AS mh_hx_key
                       INTO  #Hx_med_home_process
					   FROM     #ND_roll_up nr --Populate change tracking data -- add it based on the date of the change going forward until the month before the next change
								--A few comments about changes -- There is a possibility that this could introduce duplicates if change tracking records
								--get merged onto same first_mon_date, my audit shows that based on typical behavior this is not happening
								--Would be worth checking for this constraint.
								--If this routine ever gets moved to production there could be an instance where the first_mon_date = @build_dt_end and 
								--a tracked change was made to the medical home on the same day, its possible that the change will not be tracked
                                LEFT JOIN #Hx_med_home hmh ON hmh.person_id = nr.person_id
                                                             AND nr.first_mon_date >= hmh.mh_changed_date
                                                             AND nr.first_mon_date > hmh.last_changed_date
															-- AND hmh.last_changed_date != CAST(@build_dt_start AS DATE)
                                                             AND nr.first_mon_date < hmh.next_changed_date
                                
								--Populate Hx based on build date with changed from information if available up until the month before the next change date
                                LEFT JOIN #Hx_med_home hmh_pre ON hmh_pre.person_id = nr.person_id
                                                                 AND hmh_pre.last_changed_date = CAST(@build_dt_start AS DATE)
                                                                 AND nr.first_mon_date < hmh_pre.mh_changed_date
                     
            SELECT  IDENTITY( INT, 1, 1 )  AS per_mon_id ,
                    nr.person_id ,
                    nr.first_mon_date ,
                    nr.mh_cur_key ,
                    hx_mh.mh_hx_key ,
                    nr.pcp_cur_key ,
                    hx_pcp.pcp_hx_key ,
                    nr.status_cur_key ,
                    hx_stat.status_hx_key ,
                    nr.cr_first_office_enc_date ,
                    nr.expired_date ,
                    nr.First_enc_age_months ,
                    nr.nbr_new_pt ,
                    nr.nbr_pt_seen_office_ever ,
                    nr.nbr_pt_deceased ,
                    nr.nbr_pt_deceased_this_month ,
                    nr.patient_vintage ,
					   
					   --Populate age if patient has not expired
                    CASE WHEN nr.dob IS NOT NULL
                              AND nr.nbr_pt_deceased != 1 THEN DATEDIFF(YY, nr.dob, nr.first_mon_date)
                         WHEN nr.dob IS NOT NULL
                              AND nr.nbr_pt_deceased = 1
                              AND nr.expired_date IS NOT NULL THEN DATEDIFF(YY, nr.dob, nr.expired_date)
                         ELSE NULL
                    END AS age_hx ,

					--If patient is deceased then age = null
                    CASE WHEN nr.dob IS NOT NULL
                              AND nr.nbr_pt_deceased != 1 THEN DATEDIFF(YY, nr.dob, GETDATE())
                         WHEN nr.dob IS NOT NULL
                              AND nr.nbr_pt_deceased = 1
                              AND nr.expired_date IS NOT NULL THEN DATEDIFF(YY, nr.dob, nr.expired_date)
                         ELSE NULL
                    END AS age_cur ,
                    nr.dob ,
                    nr.full_name ,
                    nr.first_name ,
                    nr.last_name ,
                    nr.middle_name ,
                    nr.address_line_1 ,
                    nr.address_line_2 ,
                    nr.city ,
                    nr.state ,
                    RIGHT('00000' + LTRIM(RTRIM(nr.zip)), 5) AS zip , --DQ Change
                    nr.home_phone ,
                    nr.sex ,
                    nr.ssn ,
                    nr.alt_phone ,
                    nr.marital_status ,
                    nr.race ,
                    REPLACE(nr.language, '*', '') AS language , --DQ Change
                    nr.med_rec_nbr
            INTO    Prod_Ghost.dwh.data_person_nd_month
            FROM    #ND_roll_up nr
                    LEFT JOIN #Hx_med_home_process hx_mh ON hx_mh.person_id = nr.person_id
                                                           AND hx_mh.first_mon_date = nr.first_mon_date
                    LEFT JOIN #Hx_pcp_process hx_pcp ON hx_pcp.person_id = nr.person_id
                                                       AND hx_pcp.first_mon_date = nr.first_mon_date
                    LEFT JOIN #Hx_status_process hx_stat ON hx_stat.person_id = nr.person_id
                                                           AND hx_stat.first_mon_date = nr.first_mon_date;
					 
             
		  
			 
			        

        ALTER TABLE Prod_Ghost.dwh.data_person_nd_month
        ADD CONSTRAINT per_mon_id_pk PRIMARY KEY (per_mon_id);
		
		 CREATE NONCLUSTERED INDEX IX_person_mon_x_first_mon_date2 
    ON Prod_Ghost.dwh.data_person_nd_month (per_mon_id, first_mon_date); 
        
    END;

GO