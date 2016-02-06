SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_fact_tables]
AS
    BEGIN

        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

        IF OBJECT_ID('fdt.[Fact Patient]') IS NOT NULL
            DROP TABLE fdt.[Fact Patient];
        IF OBJECT_ID('fdt.[Fact Encounter]') IS NOT NULL
            DROP TABLE fdt.[Fact Encounter];
        IF OBJECT_ID('fdt.[Fact Encounter and Appointment]') IS NOT NULL
            DROP TABLE fdt.[Fact Encounter and Appointment];
        IF OBJECT_ID('fdt.fact_charge') IS NOT NULL
            DROP TABLE fdt.fact_charge;    
        IF OBJECT_ID('fdt.fact_transaction') IS NOT NULL
            DROP TABLE fdt.fact_transaction;
        IF OBJECT_ID('fdt.[Fact Employee Hours]') IS NOT NULL
            DROP TABLE fdt.[Fact Employee Hours];
			
			
			       IF OBJECT_ID('fdt.[Fact Employee Hours for Providers]') IS NOT NULL
            DROP TABLE fdt.[Fact Employee Hours for Providers];    
        IF OBJECT_ID('fdt.[Fact Employee]') IS NOT NULL
            DROP TABLE fdt.[Fact Employee];
        
		IF OBJECT_ID('fdt.[Fact Budget]') IS NOT NULL
            DROP TABLE fdt.[Fact Budget];
		
		IF OBJECT_ID('fdt.[Fact Schedule]') IS NOT NULL
            DROP TABLE fdt.[Fact Schedule];
		
        SELECT  [slot_key],
		        [schedule_resource_key] ,
                [slot_loc_key] ,
                [category_key] ,
                [appt_date] ,
                [slot_time] ,
				[slot_duration] AS [Duration Min],
				[slot_duration] AS [NG Schedule Min],
				CAST([slot_duration] AS decimal(10,2))/60 AS [Duration Hr],
				CAST([slot_duration] AS decimal(10,2))/60 AS [NG Schedule Hr],
				[nbr_slots_can_appt] [Nbr Slots for Appt],
                [nbr_slots_open_07am] [Nbr Slots for Appt at 7am],
                [nbr_slots_open_final] [Nbr Slots for Appt Final],
				[nbr_slots_open_07am_any] [Nbr Slots Avail 7am],
                [nbr_slots_open_final_any] [Nbr Slots Avail Final],
				[nbr_slots_available] [Nbr Slots Any Kind],
                [nbr_slots_overbook] [Nbr Slots as Overbooked]
        INTO  fdt.[Fact Schedule]
		FROM    [Prod_Ghost].[dwh].[data_schedule_slots];

ALTER TABLE  fdt.[Fact Schedule]
ADD CONSTRAINT slot_key_pk4 PRIMARY KEY ([slot_key]);


        SELECT -- [payor]
     -- ,[site code]
                budget_enc_key ,
                [location_key] ,
                [ActualLocalDateKey] ,
                [enc] AS [Budgeted Encounters]
        INTO    fdt.[Fact Budget]
        FROM    dwh.data_budget_encounter;
  
			
        SELECT  [employee_month_key] ,
                [employee_key] ,
                [first_mon_date] ,
                [nbr_census_employee] AS [Nbr of Employees Active] ,
                [nbr_census_separated] AS [Nbr of Employees Separated this Month] ,
                [nbr_census_bad_hire] AS [Nbr of Bad Hires] ,
                [months_since_start] AS [Months of Employment] ,
                [fte_created] AS [FTEs]
        INTO    fdt.[Fact Employee]
        FROM    [Prod_Ghost].[dwh].[data_employee_month];
			
        ALTER TABLE  fdt.[Fact Employee]
        ADD CONSTRAINT employee_month_key_pk4 PRIMARY KEY ([employee_month_key]);

        SELECT  per_mon_id ,
                first_mon_date ,
                mh_cur_key ,
                mh_hx_key ,
                pcp_cur_key ,
                pcp_hx_key ,
                med_rec_nbr ,
                nbr_new_pt AS [Number of New Patients this Month] ,
                nbr_pt_seen_office_ever AS [Number of Patient Members] ,
                nbr_pt_deceased AS [Number of Patients Deceased] ,
                nbr_pt_deceased_this_month AS [Number of Patients Deceased this Month] ,
                nbr_pt_act_3m AS [Number Active Pt Past 3 Months] ,
                nbr_pt_act_6m AS [Number Active Pt Past 6 Months] ,
                nbr_pt_act_12m AS [Number Active Pt Past 12 Months] ,
                nbr_pt_act_18m AS [Number Active Pt Past 18 Months] ,
                nbr_pt_act_24m AS [Number Active Pt Past 24 Months] ,
                nbr_pt_inact_3m AS [Number Inactive Pt Past 3 Months] ,
                nbr_pt_inact_6m AS [Number Inactive Pt Past 6 Months] ,
                nbr_pt_inact_12m AS [Number Inactive Pt Past 12 Months] ,
                nbr_pt_inact_18m AS [Number Inactive Pt Past 18 Months] ,
                nbr_pt_inact_24m AS [Number Inactive Pt Past 24 Months] ,
                nbr_pt_lost_3m AS [Number Pt Lost 3 Months] ,
                nbr_pt_lost_6m AS [Number Pt Lost 6 Months] ,
                nbr_pt_lost_12m AS [Number Pt Lost 12 Months] ,
                nbr_pt_lost_18m AS [Number Pt Lost 18 Months] ,
                nbr_pt_lost_24m AS [Number Pt Lost 24 Months] ,
                nbr_pt_mh_change AS [Number of Patients with Medical Home Change] ,
                nbr_pt_pcp_change AS [Number of Patients with PCP Change] ,
                nbr_pt_never_active AS [Number of Patients Never Active]
        INTO    Prod_Ghost.fdt.[Fact Patient]
        FROM    Prod_Ghost.dwh.data_person_dp_month;


		
        ALTER TABLE Prod_Ghost.fdt.[Fact Patient]
        ADD CONSTRAINT per_mon_id_pk2 PRIMARY KEY (per_mon_id);
					
      

        SELECT  enc_key ,
                location_key ,
                enc_bill_date ,
                provider_key ,
                per_mon_id ,
                enc_comp_key ,
                enc_creator_key ,
                billable_enc_ct AS [Number of Billable Encounters] ,
                qual_enc_ct AS [Number of Qualified Encounters] ,
                enc_count AS [Number of Encounters Any Type]
        INTO    Prod_Ghost.fdt.[Fact Encounter]
        FROM    Prod_Ghost.dwh.data_encounter;


        ALTER TABLE Prod_Ghost.fdt.[Fact Encounter]
        ADD CONSTRAINT enc_key_pk1 PRIMARY KEY (enc_key);




		--Need to create Resource Table, or at least check if there every is a mismatch between resource_user_key and enc_rendering_key and also check location_keys
		--Need to at PCP_id -- Nay I can get that through the person table
		--Need to audit the appt cs enc person_id


        SELECT  enc_appt_key , --pk
                user_resource_key ,  --Definitely happens all the time where the rendering resource is not the rendering provider -- So need two dimensions
                enc_rendering_key ,
                location_key , --I only found one instance where the locatin of the appointment was different then the encounter.  I will merge this dimension
                per_mon_id , -- Dimension looks good as appt and encounter person always match.  I will note that this field is built from the enc_app time Dimension.
                enc_appt_comp_key ,
                event_id , -- Event ID bring it for building event analysis
                enc_app_date , -- User encounter Date preferrentially for Time reporting
                user_appt_created ,
                user_checkout ,
                user_readyforprovider ,
                user_enc_created ,
                user_charted ,
                enc_nbr , -- AS [Enc Number],
                enc_nbr  AS [Enc Number],
                
				event_key ,
				
	            --FUTURE -- These fields could be included as future dimensions or available just for drill through
                enc_status , -- might want to do Billable/Qualified/Historical thing
                appt_status ,
                appt_w_pcp_status_txt ,
                enc_slot_type ,
                appt_duration , 
                appt_duration as [Appt Duration], 
				appt_time , --Proable be useful to have a time of day metrics -- need to review a distinct Am appointments vs PM and Duration (Cycle time by Early AM Late AM Early PM and Late PM) for example
		        
				--- All the Counts
                nbr_pcp_appts AS [Appt Booked with PCP] ,
                nbr_nonpcp_appt AS [Appt Booked Not with PCP] ,
                nbr_appts AS [All Appt] ,
                nbr_appt_notlinked_toperson AS [Appt without a Pt] ,
                nbr_appt_kept_and_linked_enc AS [Appt Kept with Enc] ,
                nbr_appt_kept_not_linked_enc AS [Appt Kept with No Enc] ,
                nbr_appt_future AS [Appt in Future] ,
                nbr_appt_no_show AS [Appt No Show] ,
                nbr_appt_no_show_no_patient AS [Appt No Show with No Patient] ,
                nbr_appt_future_no_patient AS [Appt Future with No Patient] ,
                nbr_appt_cancelled AS [Appt Cancelled] ,
                nbr_appt_deleted AS [Appt Deleted] ,
                nbr_appt_rescheduled AS [Appt Rescheduled] ,
                nbr_enc_or_appt AS [Enc or Appt] ,
                nbr_enc AS [Encounters] ,
                nbr_bill_enc AS [Billable Encounters] ,
                nbr_non_bill_enc AS [Non-billable Encounters] ,
                nbr_bill_enc_with_an_appt AS [Billable Enc with Appt] ,
                nbr_non_bill_enc_with_an_appt AS [Non-Billable Enc with Appt] ,
                nbr_bill_enc_with_an_appt_and_kept AS [Billable Appts with Enc Kept] ,
                nbr_non_bill_enc_with_an_appt_and_kept AS [Non-Billable Appts with Enc Kept] ,



                
				--All the cycle time information
                days_to_appt AS [Days from Booked to Appt] ,
                cycle_min_slottime_to_kept AS [Min from Appt Time to Kept] ,
                cycle_min_kept_checkedout AS [Min from Kept to Checkout] ,
                cycle_min_kept_readyforprovider AS [Min Kept to Ready for Prov] ,
                cycle_min_kept_charted AS [Min from Kept to Charted] ,
                cycle_min_kept_charted AS [Mins from Kept to Charted] ,
                cycle_min_readyforprovider_checkout AS [Min from Ready for Prov to Checkout] ,
				CAST(appt_create_time AS DATE) AS [Date of Appointment Made]
              
				--Additional Fields considered but not included
				--COALESCE(CAST(enc_checkin_datetime AS date),appt_date,enc_date) AS Ops_Time  --For reporting when the actually work took place  Could be called Ops Time
				-- appt_date, --These two dates need to be included as the appt_date is an ops field and the counter date is actually a billing field.   Need this for appointments that don't have encounters
                -- enc_date,  --Note that the enc_date may be most preferable and cycle min kept to checkin is based of of this datetime
			    -- enc_checkin_datetime ,  --My audit shows that checkedindatetime is sometimes different the enc_date (enc that were moved or billed to a different date) and sometimes appt_date is different than enc date (265 records)
				--[appt_person_id]  -- These person_id are merged for matching to per_mon_id.  There are some '00000000-0000-0000-0000-000000000000' getting introduced in the database from the inset process.  Proobably need to redo it
                --[enc_person_id]  -- I did an audit and it appears these person_id are always matching in NG database
				--[pcp_id], -- not used as we are getting pcp information through the per_mon_id 
                --[enc_loc_id], I could only find one instance in all encounter where the appt location was different than the encounter location
                --[appt_loc_id]
        INTO    fdt.[Fact Encounter and Appointment]
        FROM    dwh.data_appointment;
		
			  
        ALTER TABLE fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT enc_appt_keypk PRIMARY KEY (enc_appt_key);
			  
			  
        SELECT  [employee_hours_key] ,
                [employee_hours_comp_key] ,
                [employee_key] ,
                [employee_month_key] ,
				location_key,
                [Pay Date] ,
                [Hours Timecard] ,
                [Hours Payroll] ,
                [Dollars]
        INTO    fdt.[Fact Employee Hours]
        FROM    dwh.data_employee_hours;
		
			  
        ALTER TABLE fdt.[Fact Employee Hours]
        ADD CONSTRAINT employee_hours_key_pk PRIMARY KEY ([employee_hours_key]);
		
		
					  
        SELECT  [employee_hours_key] ,
                [employee_hours_comp_key] ,
                [employee_key] ,
                [employee_month_key] ,
				location_key,
                [Pay Date] ,
                [Hours Timecard] ,
                [Hours Payroll] ,
                [Dollars]
        INTO    fdt.[Fact Employee Hours for Providers]
        FROM    dwh.data_employee_hours;
		
			  
        ALTER TABLE fdt.[Fact Employee Hours for Providers]
        ADD CONSTRAINT employee_hours_key_pk3 PRIMARY KEY ([employee_hours_key]);
		
			  	  
/*
        SELECT  per.per_mon_id ,
                pha.[person_id] ,
                pha.[location_id] ,
                [provider_id] ,
                [md_id] ,
                [enc_id] ,
                [rx_id] ,
                [gcnsecno] ,
                [ndc] ,
                [store_id] ,
                CAST([start_date] AS DATE) start_date ,
                CAST([expire_date] AS DATE) expire_date ,
                [RxNotbyProv] ,
                [written_qty] ,
                [refills_left] ,
                [refills_orig] ,
                [drug_dea_class] ,
                [operation_type] ,  -- needs a junk dim table
                [Total_Non_Controlled] ,
                [Total_Controlled] ,
                [Sched_I] ,
                [Sched_II] ,
                [Sched_III] ,
                [Sched_IV] ,
                [Sched_V]
        INTO    fds.fact_pharmacy
        FROM    dwh.data_pharmacy pha
                INNER JOIN dwh.data_person_month per ON per.person_id = pha.person_id
                                                        AND per.seq_date = CAST(CONVERT(CHAR(6), pha.start_date, 112)
                                                        + '01' AS DATE);
	 
	 
	   --Caveat here is that start_date can be set by the provider to a future date
	   --When we use person_mon_id to map data to will flow to start date, but the rx will get mapped to the encounter -- this may create some inconsistencies in the data displayed
	   


		SELECT 
	   [location_id]
      ,[person_id]
      ,[pcp_id_cur_mon]
      ,[per_mon_id]
      ,[seq_date]
      ,[first_mon_date]
      ,[CurMon_Pt_Age]
      ,[MemberMonths]
      ,[Nbr_new_pt]
      ,[Nbr_pt_ever_enrolled]
      ,[nbr_pt_deceased]
      ,[nbr_pt_deceased_this_month]
      ,[nbr_ap_controlled_rx]
      ,[nbr_ap_no_controlled_rx]
      ,[nbr_ap_no_show]
      ,[nbr_ap_cancelled]
      ,[nbr_ap_deleted]
      ,[nbr_ap_rescheduled]
      ,[nbr_ap_bill_w_appt]
      ,[nbr_ap_non_bill_w_appt]
      ,[nbr_ap_pcp_appt]
      ,[nbr_ap_nonpcp_Appt]
      ,[nbr_ap_kept_and_linked_enc]
      ,[nbr_ap_kept_not_linked_enc]
      ,[nbr_enc_w_charges_not_linked_appt]
      ,[nbr_enc_w_charges]
      ,[ap_avg_cycle_min_slottime_to_kept]
      ,[ap_avg_cycle_min_kept_checkedout]
      ,[nbr_chronic_pain_12m]
      ,[nbr_pt_act_3m]
      ,[nbr_pt_act_6m]
      ,[nbr_pt_act_12m]
      ,[nbr_pt_act_18m]
      ,[nbr_pt_act_24m]
      
	  FROM dwh.data_person_month


        SELECT  *
        INTO    fds.fact_charge
        FROM    [Staging_Ghost].[dwh].[data_charge];


		
		
        SELECT  *
        INTO    fds.fact_transaction
        FROM    [Staging_Ghost].[dwh].data_transaction; 

	   */


  



    END;
GO
