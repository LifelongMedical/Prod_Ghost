
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


--This procedure must be run before the fact table creation to set up all the FK


CREATE PROCEDURE [fdt].[update_dim_tables]
AS
    BEGIN

        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
        IF OBJECT_ID('fdt.[Dim NG User]') IS NOT NULL
            DROP TABLE  fdt.[Dim NG User];

        IF OBJECT_ID('fdt.[Dim Provider]') IS NOT NULL
            DROP TABLE  fdt.[Dim Provider];

        IF OBJECT_ID('fdt.[Dim NG Resource]') IS NOT NULL
            DROP TABLE  fdt.[Dim NG Resource];




        IF OBJECT_ID('fdt.[Dim Status Enc and Appt]') IS NOT NULL
            DROP TABLE  fdt.[Dim Status Enc and Appt];
 
        IF OBJECT_ID('fdt.[Dim Appt Event]') IS NOT NULL
            DROP TABLE   fdt.[Dim Appt Event];

        IF OBJECT_ID('fdt.[Dim Medical Home Current]') IS NOT NULL
            DROP TABLE fdt.[Dim Medical Home Current];
			
        IF OBJECT_ID('fdt.[Dim Medical Home Historical]') IS NOT NULL
            DROP TABLE fdt.[Dim Medical Home Historical];
			   
        IF OBJECT_ID('fdt.[Dim PCP Current]') IS NOT NULL
            DROP TABLE fdt.[Dim PCP Current];

        IF OBJECT_ID('fdt.[Dim PCP Historical]') IS NOT NULL
            DROP TABLE fdt.[Dim PCP Historical];
        IF OBJECT_ID('fdt.[Dim PHI Patient]') IS NOT NULL
            DROP TABLE fdt.[Dim PHI Patient];	 

        IF OBJECT_ID('fdt.[Dim Patient]') IS NOT NULL
            DROP TABLE fdt.[Dim Patient];	 

--Need to drop Fact and a few Dim Patient tables first because of FK constraints
		
        IF OBJECT_ID('fdt.[Dim Encounter Status]') IS NOT NULL
            DROP TABLE fdt.[Dim Encounter Status];
					
        IF OBJECT_ID('fdt.[Dim Location for Enc or Appt]') IS NOT NULL
            DROP TABLE  fdt.[Dim Location for Enc or Appt];
			    
        IF OBJECT_ID('fdt.[Dim User Encounter Creator]') IS NOT NULL
            DROP TABLE  fdt.[Dim User Encounter Creator];

        IF OBJECT_ID('fdt.[Dim Provider Rendering]') IS NOT NULL
            DROP TABLE fdt.[Dim Provider Rendering];

        IF OBJECT_ID('fdt.[Dim PHI Validate]') IS NOT NULL
            DROP TABLE fdt.[Dim PHI Validate];	 


        IF OBJECT_ID('fdt.[Dim Time]') IS NOT NULL
            DROP TABLE  fdt.[Dim Time];
			
        IF OBJECT_ID('fdt.[Dim User Schedule Resource]') IS NOT NULL
            DROP TABLE		 fdt.[Dim User Schedule Resource];
	
        IF OBJECT_ID('fdt.[Dim User Appointment Creator]') IS NOT NULL
            DROP TABLE	fdt.[Dim User Appointment Creator];
	 
        IF OBJECT_ID('fdt.[Dim User Checkout]') IS NOT NULL
            DROP TABLE	fdt.[Dim User Checkout];

        IF OBJECT_ID('fdt.[Dim User Checkin]') IS NOT NULL
            DROP TABLE	fdt.[Dim User Checkin];

        IF OBJECT_ID('fdt.[Dim User Ready for Provider]') IS NOT NULL
            DROP TABLE	 fdt.[Dim User Ready for Provider];


			
        IF OBJECT_ID('fdt.[Dim Employee Hour Detail]') IS NOT NULL
            DROP TABLE	fdt.[Dim Employee Hour Detail];


			
        --IF OBJECT_ID('fdt.[Dim Employee]') IS NOT NULL
        --    DROP TABLE	 fdt.[Dim Employee];

				
        --IF OBJECT_ID('fdt.[Dim Employee Historical]') IS NOT NULL
        --    DROP TABLE	 fdt.[Dim Employee Historical];


        --IF OBJECT_ID('fdt.bridge_emp_to_emp_mon') IS NOT NULL
        --    DROP TABLE	fdt.bridge_emp_to_emp_mon;
			
        --IF OBJECT_ID('fdt.bridge_usr_emp') IS NOT NULL
        --    DROP TABLE	fdt.bridge_usr_emp;
			
			
        IF OBJECT_ID('fdt.[Dim Category and Event]') IS NOT NULL
            DROP TABLE	fdt.[Dim Category and Event];
		
        IF OBJECT_ID('fdt.[Dim Time of Day]') IS NOT NULL
            DROP TABLE	fdt.[Dim Time of Day];
		
		
        SELECT  un.appt_time AS [Time of Slot] ,
                CASE WHEN SUBSTRING(un.appt_time, 1, 2) < 12 THEN 'AM'
                     ELSE 'PM'
                END AS meridiem
        INTO    fdt.[Dim Time of Day]
        FROM    ( SELECT    appt_time
                  FROM      dwh.data_appointment
                  UNION
                  SELECT    slot_time AS appt_time
                  FROM      dwh.data_schedule_slots
                ) un
        WHERE   un.appt_time IS NOT NULL
        ORDER BY un.appt_time;
	
        ALTER TABLE fdt.[Dim Time of Day]
        ALTER COLUMN [Time of Slot] VARCHAR(4) NOT NULL;
			
        ALTER TABLE   fdt.[Dim Time of Day]
        ADD CONSTRAINT appt_time_pk2 PRIMARY KEY ([Time of Slot]);
			
	
        SELECT  DISTINCT
                enc_comp_key ,
                enc_comp_key_name AS [Encounter Status]
        INTO    fdt.[Dim Encounter Status]
        FROM    dwh.data_encounter;   

        ALTER TABLE fdt.[Dim Encounter Status]
        ALTER COLUMN enc_comp_key BIGINT NOT NULL;

        ALTER TABLE  fdt.[Dim Encounter Status]
        ADD CONSTRAINT enc_comp_key_pk PRIMARY KEY (enc_comp_key);

		
        SELECT  [PK_date] AS [Key Date] ,
                [date_name_short_10] AS [MM-DD-YYYY] ,
                [date_name_short_08] AS [YYYYMMDD] ,
                [first_mon_date] AS [First Day of Month Date] ,
                [Date_Name] AS [Long Day Name] ,
                [Year] AS Year_sort ,
                [Year_Name] AS [Year] ,
                [Half_Year] ,
                [Half_Year_Name] AS [Half Year] ,
                [Quarter] AS Quarter_sort ,
                [Quarter_Name] AS [Quarter] ,
                [Month] AS Month_sort ,
                [Month_Name] AS [Month] ,
                [Week] AS week_sort ,
                [Week_Name] AS [Week] ,
                [MondayOfWeek] AS [Week - Monday] ,
                [Day_Of_Year] ,
                [Day_Of_Year_Name] AS [Day of Year] ,
                [Day_Of_Half_Year] ,
                [Day_Of_Half_Year_Name] AS [Day of Half-Year] ,
                [Day_Of_Quarter] ,
                [Day_Of_Quarter_Name] AS [Day of Quarter] ,
                [Day_Of_Month] ,
                [Day_Of_Month_Name] AS [Day of Month] ,
                [Day_Of_Week] ,
                [Day_Of_Week_Name] AS [Day of Week] ,
                [Week_Of_Year] ,
                [Week_Of_Year_Name] AS [Week of Year] ,
                [Month_Of_Year] ,
                [Month_Of_Year_Name] AS [Month of Year] ,
                [Month_Of_Half_Year] ,
                [Month_Of_Half_Year_Name] AS [Month of Half Year] ,
                [Month_Of_Quarter] ,
                [Month_Of_Quarter_Name] AS [Month of Quarter] ,
                [Quarter_Of_Year] ,
                [Quarter_Of_Year_Name] AS [Quarter of Year] ,
                [Quarter_Of_Half_Year] ,
                [Quarter_Of_Half_Year_Name] AS [Quarter of Half Year] ,
                [Half_Year_Of_Year] ,
                [Half_Year_Of_Year_Name] AS [Half Year of Year] ,
                [Fiscal_Year] ,
                [Fiscal_Year_Name] AS [Fiscal Year] ,
                [Fiscal_Half_Year] ,
                [Fiscal_Half_Year_Name] AS [Fiscal Half Year] ,
                [Fiscal_Quarter] ,
                [Fiscal_Quarter_Name] AS [Fiscal Quarter] ,
                [Fiscal_Month] ,
                [Fiscal_Month_Name] AS [Fiscal Month] ,
                [Fiscal_Week] ,
                [Fiscal_Week_Name] AS [Fiscal Week] ,
                [Fiscal_Day] ,
                [Fiscal_Day_Name] AS [Fiscal Day] ,
                [Fiscal_Day_Of_Year] ,
                [Fiscal_Day_Of_Year_Name] AS [Fiscal Day OF Year] ,
                [Fiscal_Day_Of_Half_Year] ,
                [Fiscal_Day_Of_Half_Year_Name] AS [Fiscal Day of Half Year] ,
                [Fiscal_Day_Of_Quarter] ,
                [Fiscal_Day_Of_Quarter_Name] AS [Fiscal Day of Quarter] ,
                [Fiscal_Day_Of_Month] ,
                [Fiscal_Day_Of_Month_Name] AS [Fiscal Day of Month] ,
                [Fiscal_Day_Of_Week] ,
                [Fiscal_Day_Of_Week_Name] AS [Fiscal Day of Week] ,
                [Fiscal_Week_Of_Year] ,
                [Fiscal_Week_Of_Year_Name] AS [Fiscal Week of Year] ,
                [Fiscal_Month_Of_Year] ,
                [Fiscal_Month_Of_Year_Name] AS [Fiscal Month of Year] ,
                [Fiscal_Month_Of_Half_Year] ,
                [Fiscal_Month_Of_Half_Year_Name] AS [Fiscal Month of Half Year] ,
                [Fiscal_Month_Of_Quarter] ,
                [Fiscal_Month_Of_Quarter_Name] AS [Fiscal Month OF Quarter] ,
                [Fiscal_Quarter_Of_Year] ,
                [Fiscal_Quarter_Of_Year_Name] AS [Fiscal Quarter of Year] ,
                [Fiscal_Quarter_Of_Half_Year] ,
                [Fiscal_Quarter_Of_Half_Year_Name] AS [Fiscal Quarter of Half Year] ,
                [Fiscal_Half_Year_Of_Year] ,
                [Fiscal_Half_Year_Of_Year_Name] AS [Fiscal Half Year of Year ] ,
                [Relative_days_to_CurrentDate] AS [Relative Days to Today] ,
                [Relative_months_to_CurrentDate] AS [Relative Months to Today] ,
                [Relative_weeks_to_CurrentDate] AS [Relative Weeks to Today]
        INTO    fdt.[Dim Time]
        FROM    dwh.data_time;


        ALTER TABLE   fdt.[Dim Time]
        ADD CONSTRAINT date_pk1 PRIMARY KEY ([Key Date]);


        SELECT  location_key ,
                site_id ,
                location_mstr_name AS [Location for Enc or Appt]
        INTO    fdt.[Dim Location for Enc or Appt]
        FROM    dwh.data_location;
		
        ALTER TABLE   fdt.[Dim Location for Enc or Appt]
        ADD CONSTRAINT location_key_33 PRIMARY KEY (location_key);

        SELECT  location_key ,
                location_mstr_name AS [Medical Home Current] ,
                site_id
        INTO    fdt.[Dim Medical Home Current]
        FROM    dwh.data_location;
		
        ALTER TABLE  fdt.[Dim Medical Home Current]	
        ADD CONSTRAINT location_key_pk2 PRIMARY KEY (location_key);

        SELECT  location_key ,
                site_id ,
                location_mstr_name AS [Medical Home Historical]
        INTO    fdt.[Dim Medical Home Historical]
        FROM    dwh.data_location;
		
        ALTER TABLE  fdt.[Dim Medical Home Historical]	
        ADD CONSTRAINT location_key_pk3 PRIMARY KEY (location_key);

        SELECT  user_key ,
                FullName AS [User Encounter Creator] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree
        INTO    fdt.[Dim User Encounter Creator]
        FROM    dwh.data_user;
		
        ALTER TABLE   fdt.[Dim User Encounter Creator]
        ADD CONSTRAINT user_key_pk231 PRIMARY KEY (user_key);
		
		
		







        SELECT  user_key ,
                employee_key ,
                FullName AS [PCP Current] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree ,
                [active_3m_provider] AS [Active Provider] ,
                [primary_loc_3m_provider] AS [Primary Location for Provider] ,
                [active_3m_provider] AS [Primary Site Active Provider 3m] ,
                [primary_loc_3m_provider] AS [Primary Location for Provider 3m] ,
                [active_3ms_provider] AS [Secondary Site Active Provider 3m] ,
                [secondary_loc_3m_provider] AS [Secondary Location for Provider 6m] ,
                [active_6m_provider] AS [Primary Active Provider 6m] ,
                [primary_loc_6m_provider] AS [Primary Location for Provider 6m] ,
                [active_12m_provider] AS [Active Provider 12m] ,
                [primary_loc_12m_provider] AS [Primary Location Provider 12m] ,
                [hr_employee_id] AS [HR Employee Number] ,
                [hr_job_title] AS [HR Employee Title] ,
                [hr_location_id] AS [HR Location ID] ,
                [hr_location_name] AS [HR Location Name]
        INTO    fdt.[Dim PCP Current]
        FROM    dwh.data_user;
		
        ALTER TABLE  fdt.[Dim PCP Current]
        ADD CONSTRAINT user_key_pk2 PRIMARY KEY (user_key);


        SELECT  user_key ,
                employee_key ,
                FullName AS [PCP Historical] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree ,
                [active_3m_provider] AS [Active Provider] ,
                [primary_loc_3m_provider] AS [Primary Location for Provider] ,
                [active_3m_provider] AS [Primary Site Active Provider 3m] ,
                [primary_loc_3m_provider] AS [Primary Location for Provider 3m] ,
                [active_3ms_provider] AS [Secondary Site Active Provider 3m] ,
                [secondary_loc_3m_provider] AS [Secondary Location for Provider 6m] ,
                [active_6m_provider] AS [Primary Active Provider 6m] ,
                [primary_loc_6m_provider] AS [Primary Location for Provider 6m] ,
                [active_12m_provider] AS [Active Provider 12m] ,
                [primary_loc_12m_provider] AS [Primary Location Provider 12m] ,
                [hr_employee_id] AS [HR Employee Number] ,
                [hr_job_title] AS [HR Employee Title] ,
                [hr_location_id] AS [HR Location ID] ,
                [hr_location_name] AS [HR Location Name]
        INTO    fdt.[Dim PCP Historical]
        FROM    dwh.data_user;
		
        ALTER TABLE  fdt.[Dim PCP Historical]
        ADD CONSTRAINT user_key_pk18 PRIMARY KEY (user_key);

		
        SELECT  user_key ,
                employee_key ,
                FullName AS [Provider Rendering] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree ,
                [active_3m_provider] AS [Active Provider] ,
                [primary_loc_3m_provider] AS [Primary Location for Provider] ,
                [active_3m_provider] AS [Primary Site Active Provider 3m] ,
                [primary_loc_3m_provider] AS [Primary Location for Provider 3m] ,
                [active_3ms_provider] AS [Secondary Site Active Provider 3m] ,
                [secondary_loc_3m_provider] AS [Secondary Location for Provider 6m] ,
                [active_6m_provider] AS [Primary Active Provider 6m] ,
                [primary_loc_6m_provider] AS [Primary Location for Provider 6m] ,
                [active_12m_provider] AS [Active Provider 12m] ,
                [primary_loc_12m_provider] AS [Primary Location Provider 12m] ,
                [hr_employee_id] AS [HR Employee Number] ,
                [hr_job_title] AS [HR Employee Title] ,
                [hr_location_id] AS [HR Location ID] ,
                [hr_location_name] AS [HR Location Name]
        INTO    fdt.[Dim Provider Rendering]
        FROM    dwh.data_user;
		
        ALTER TABLE  fdt.[Dim Provider Rendering]
        ADD CONSTRAINT user_key_pk17 PRIMARY KEY (user_key);

--New set of dim patient

        SELECT  [user_key] ,
                [employee_key] ,
                [first_name] [NG User First Name] ,
                [last_name] [NG User Last Name] ,
                [FullName] [NG User Full Name]
        INTO    fdt.[Dim NG User]
        FROM    [Prod_Ghost].[dwh].[data_user_v2];

        SELECT  [provider_key] ,
                user_key ,
                employee_key ,
                [role_status] [Role Status] ,
                [first_name] [NG Prov First Name] ,
                [last_name] [NG Prov Last Name] ,
                [FullName] [NG Prov Full Name] ,
                [provider_name] [NG Prov Provider Name] ,
            
                [first_name] [Prov First Name] ,
                [last_name] [Prov Last Name] ,
                [FullName] [Prov Full Name] ,
              --  [provider_name] [Prov Provider Name] ,
                
				
				
				
				[degree] [Degree] ,
                [active_3m_provider] AS [Active Provider] ,
                [primary_loc_3m_provider] AS [Primary Location for Provider] ,
                [active_3m_provider] AS [Primary Site Active Provider 3m] ,
                [primary_loc_3m_provider] AS [Primary Location for Provider 3m] ,
                [active_3ms_provider] AS [Secondary Site Active Provider 3m] ,
                [secondary_loc_3m_provider] AS [Secondary Location for Provider 6m] ,
                [active_6m_provider] AS [Primary Active Provider 6m] ,
                [primary_loc_6m_provider] AS [Primary Location for Provider 6m] ,
                [active_12m_provider] AS [Active Provider 12m] ,
                [primary_loc_12m_provider] AS [Primary Location Provider 12m]
        INTO    fdt.[Dim Provider]
        FROM    [Prod_Ghost].[dwh].[data_provider];

        SELECT  [resource_key] ,
                [resource_name] [NG Schedule Resource Name] ,
                [provider_key]
        INTO    fdt.[Dim NG Resource]
        FROM    [Prod_Ghost].[dwh].[data_resource];
  


  -------







        SELECT  user_key ,
                employee_key ,
                FullName AS [User Schedule Resource] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree
        INTO    fdt.[Dim User Schedule Resource]
        FROM    dwh.data_user;
		
        ALTER TABLE   fdt.[Dim User Schedule Resource]
        ADD CONSTRAINT user_key_pk16 PRIMARY KEY (user_key);
	
        SELECT  user_key ,
                FullName AS [User Appointment Creator] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree
        INTO    fdt.[Dim User Appointment Creator]
        FROM    dwh.data_user;
		
        ALTER TABLE  fdt.[Dim User Appointment Creator]
        ADD CONSTRAINT user_key_pk15 PRIMARY KEY (user_key);

	
        SELECT  user_key ,
                FullName AS [User Checkout] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree
        INTO    fdt.[Dim User Checkout]
        FROM    dwh.data_user;
		
        ALTER TABLE  fdt.[Dim User Checkout]
        ADD CONSTRAINT user_key_pk14 PRIMARY KEY (user_key);

		 
        SELECT  user_key ,
                FullName AS [User Checkin] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree
        INTO    fdt.[Dim User Checkin]
        FROM    dwh.data_user;
		
        ALTER TABLE  fdt.[Dim User Checkin]
        ADD CONSTRAINT user_key_pk13 PRIMARY KEY (user_key);
		 

        SELECT  [employee_hours_comp_key] ,
                [status_type] AS [Hours Type] ,
                [status_ec_tc] AS [Hours Category from Timecard] ,
                [status_ec_pr] AS [Hours Category from Payroll]
        INTO    fdt.[Dim Employee Hour Detail]
        FROM    [Prod_Ghost].[dwh].[data_employee_hours_status];

  
        ALTER TABLE  fdt.[Dim Employee Hour Detail]
        ADD CONSTRAINT employee_hours_comp_key_pk PRIMARY KEY ([employee_hours_comp_key]);
		
		
        --SELECT  [employee_key] ,
        --        [employee_month_key] ,
        --        CASE WHEN age_hx <= 18 THEN '0-18 Years'
        --             WHEN age_hx <= 29 THEN '19-29 Years'
        --             WHEN age_hx <= 39 THEN '30-39 Years'
        --             WHEN age_hx <= 49 THEN '40-49 Years'
        --             WHEN age_hx <= 59 THEN '50-59 Years'
        --             WHEN age_hx <= 64 THEN '60-64 Years'
        --             WHEN age_hx <= 74 THEN '65-74 Years'
        --             WHEN age_hx <= 79 THEN '75-79 Years'
        --             WHEN age_hx <= 89 THEN '80-89 Years'
        --             WHEN age_hx <= 99 THEN '90-99 Years'
        --             WHEN age_hx >= 100 THEN '>100 Years'
        --             ELSE 'Age Unknown'
        --        END AS [Age Historical] ,
        --        CASE WHEN age_hx <= 18 THEN 1
        --             WHEN age_hx <= 29 THEN 2
        --             WHEN age_hx <= 39 THEN 3
        --             WHEN age_hx <= 49 THEN 4
        --             WHEN age_hx <= 59 THEN 5
        --             WHEN age_hx <= 64 THEN 6
        --             WHEN age_hx <= 74 THEN 7
        --             WHEN age_hx <= 79 THEN 8
        --             WHEN age_hx <= 89 THEN 9
        --             WHEN age_hx <= 99 THEN 10
        --             WHEN age_hx >= 100 THEN 11
        --             ELSE 12
        --        END AS age_hx_sort ,
        --        CASE WHEN [months_since_start] <= 1 THEN '1 Month - New Employee'
        --             WHEN [months_since_start] <= 6 THEN '2-6 Months'
        --             WHEN [months_since_start] <= 12 THEN '7-12 Months - 1 Year'
        --             WHEN [months_since_start] <= 24 THEN '13-24 Months- 2 Years'
        --             WHEN [months_since_start] <= 36 THEN '25-36 Months- 3 Years'
        --             WHEN [months_since_start] <= 48 THEN '37-48 Months- 4 Years'
        --             WHEN [months_since_start] <= 60 THEN '49-60 Months- 5 Years'
        --             WHEN [months_since_start] <= 120 THEN '61-120 Months- 6-10 Years'
        --             WHEN [months_since_start] <= 180 THEN '121-180 Months- 11-15 Years'
        --             WHEN [months_since_start] <= 240 THEN '181-240 Months- 15-20 Years'
        --             WHEN [months_since_start] > 240 THEN '>240 Months- 20 Years'
        --        END AS [Time as Employee] ,
        --        CASE WHEN [months_since_start] <= 1 THEN 1
        --             WHEN [months_since_start] <= 6 THEN 2
        --             WHEN [months_since_start] <= 12 THEN 3
        --             WHEN [months_since_start] <= 24 THEN 4
        --             WHEN [months_since_start] <= 36 THEN 5
        --             WHEN [months_since_start] <= 48 THEN 6
        --             WHEN [months_since_start] <= 60 THEN 7
        --             WHEN [months_since_start] <= 120 THEN 8
        --             WHEN [months_since_start] <= 180 THEN 9
        --             WHEN [months_since_start] <= 240 THEN 10
        --             WHEN [months_since_start] > 240 THEN 11
        --        END AS employee_time_sort
        --INTO    fdt.[Dim Employee Historical]
        --FROM    [Prod_Ghost].[dwh].[data_employee_month];

        --ALTER TABLE  fdt.[Dim Employee Historical]
        --ADD CONSTRAINT employee_month_key_pk10 PRIMARY KEY ([employee_month_key]);

        --SELECT  [employee_key] ,
        --        [cn_account_code] AS [Cost Nbr Account Code] ,
        --        [cn_account_code_sub] AS [Cost Nbr Account Sub-Code] ,
        --        [cn_site] AS [Cost Nbr Site Code] ,
        --        [cn_fund] AS [Cost Nbr Fund] ,
        --        [cn_dir_indir] AS [Cost Nbr In/Direct] ,
        --        [cn_category] AS [Cost Nbr Category] ,
        --        [cn_proj_grant] AS [Cost Nbr Grant] ,
        --        [Home Cost Number] AS [Cost Nbr] ,
        --        [Home Department] ,
        --        [Location Code] ,
        --        [Location] AS [Location Name] ,
        --        [Payroll Name] ,
        --        [File Number] ,
        --        [Payroll First Name] AS [First Name] ,
        --        [Payroll Last Name] AS [Last Name] ,
        --        [Race] ,
        --        [Gender] ,
        --        CASE WHEN Age_cur <= 18 THEN '0-18 Years'
        --             WHEN Age_cur <= 29 THEN '19-29 Years'
        --             WHEN Age_cur <= 39 THEN '30-39 Years'
        --             WHEN Age_cur <= 49 THEN '40-49 Years'
        --             WHEN Age_cur <= 59 THEN '50-59 Years'
        --             WHEN Age_cur <= 64 THEN '60-64 Years'
        --             WHEN Age_cur <= 74 THEN '65-74 Years'
        --             WHEN Age_cur <= 79 THEN '75-79 Years'
        --             WHEN Age_cur <= 89 THEN '80-89 Years'
        --             WHEN Age_cur <= 99 THEN '90-99 Years'
        --             WHEN Age_cur >= 100 THEN '>100 Years'
        --             ELSE 'Age Unknown'
        --        END AS [Age Current] ,
        --        CASE WHEN Age_cur <= 18 THEN 1
        --             WHEN Age_cur <= 29 THEN 2
        --             WHEN Age_cur <= 39 THEN 3
        --             WHEN Age_cur <= 49 THEN 4
        --             WHEN Age_cur <= 59 THEN 5
        --             WHEN Age_cur <= 64 THEN 6
        --             WHEN Age_cur <= 74 THEN 7
        --             WHEN Age_cur <= 79 THEN 8
        --             WHEN Age_cur <= 89 THEN 9
        --             WHEN Age_cur <= 99 THEN 10
        --             WHEN Age_cur >= 100 THEN 11
        --             ELSE 12
        --        END AS age_cur_sort ,
        --        [Status] ,
        --        [Data Control] ,
        --        [flu_vac_2015_decline] AS [2015 Flu Vaccine Documented as Declined] ,
        --        [flu_vac_2015_received] AS [2015 Flu Vaccine Documented as Received] ,
        --        [tb_test_completed] AS [2015 TB Documentation] ,
        --        [Job Title] ,
        --        [Zip/Postal Code] ,
        --        [Manager Last Name First Name] ,
        --        [Manager Last Name] ,
        --        [Manager First Name] ,
        --        [Manager ID] ,
        --        [Rate Type] ,
        --        [rounded_salary] AS [Salary Current] ,
        --        [rate_cur] AS [Rate Current] ,
        --        [rate_cur_range] AS [Rate Range Current],
        --        [rate_cur_range_sort] ,
        --        [salary_cur_range] AS [Salary Range Current] ,
        --        [salary_cur_range_sort] ,
        --        CONVERT(VARCHAR(6), [Hire Date], 112) AS [Hire Year/Month] ,
        --        CONVERT(VARCHAR(6), [Termination Date], 112) AS [Termination Year/Month] ,
        --        [Termination Reason] ,
        --        [Termination Reason Code]
        --INTO    fdt.[Dim Employee]
        --FROM    [Prod_Ghost].[dwh].[data_employee];

        --ALTER TABLE  fdt.[Dim Employee]
        --ADD CONSTRAINT employee_key_pk3 PRIMARY KEY ([employee_key]);





        SELECT  user_key ,
                FullName AS [User Ready for Provider] ,
                resource_name AS [Resource Name] ,
                role_status AS [Role Status] ,
                degree AS Degree
        INTO    fdt.[Dim User Ready for Provider]
        FROM    dwh.data_user;
		
        ALTER TABLE  fdt.[Dim User Ready for Provider]
        ADD CONSTRAINT user_key_pk34 PRIMARY KEY (user_key);
		 
        SELECT  event_key ,
                event_name AS [Appt Event Name]
        INTO    fdt.[Dim Appt Event]
        FROM    dwh.data_event;
		
        ALTER TABLE   fdt.[Dim Appt Event]
        ADD CONSTRAINT event_key_pk1 PRIMARY KEY (event_key);
		 

        SELECT  [cat_event_key] ,
                [event_id] ,
                [category_id] ,
                [category_description] AS [Category Name] ,
                [event_description] [Event Name] ,
                [prevent_appt] AS [Prevent Appt]
        INTO    fdt.[Dim Category and Event]
        FROM    [Prod_Ghost].[dwh].[data_category_event];
	
	
		
        ALTER TABLE   fdt.[Dim Category and Event]
        ADD CONSTRAINT cat_event_keypk1 PRIMARY KEY ([cat_event_key]);



        SELECT  [enc_appt_comp_key] ,
                [status_appt] AS [Status of Appointment] ,
                [status_appt_pcp] AS [Appt booked with PCP] ,
                [status_appt_person] AS [Appt booked with a patient] ,
                [status_appt_enc] AS [Appt had encounter] ,
                [status_enc_appt] AS [Enc had appt] ,
                [status_enc_billable] AS [Enc billable status] ,
                [status_enc] AS [Status of Enc] ,
                [status_appt_kept] AS [Appt was Kept] ,
                [status_cancel_reason] AS [Appt cancel reason] ,
                [status_charges] AS [Enc had charges] ,
                [status_pcpcrossbook] AS [Can crossbook with PCP]
        INTO    fdt.[Dim Status Enc and Appt]
        FROM    [Prod_Ghost].[dwh].[data_enc_appt_status];
     
        ALTER TABLE fdt.[Dim Status Enc and Appt]
        ALTER COLUMN enc_appt_comp_key [BIGINT]  NOT NULL;

        ALTER TABLE  fdt.[Dim Status Enc and Appt]
        ADD CONSTRAINT enc_appt_comp_key_pk2 PRIMARY KEY ([enc_appt_comp_key]);









        SELECT  enc.enc_key ,
                CAST(RIGHT('00000000000' + LTRIM(RTRIM(enc.enc_nbr)), 10) AS VARCHAR(10)) AS [Encounter Number] ,
                per.med_rec_nbr AS [Medical Record Number] ,
                per.full_name AS [Full Name] ,
                loc.location_mstr_name AS [Location Name] ,
                prov.provider_name AS [Rendering Provider Name] ,
                enc.enc_bill_date AS [Encounter Bill Date] ,
                enc.enc_comp_key_name AS [Encounter Status]
        INTO    fdt.[Dim PHI Validate]
        FROM    dwh.data_encounter enc
                LEFT JOIN ( SELECT DISTINCT
                                    person_id ,
                                    full_name ,
                                    med_rec_nbr
                            FROM    dwh.data_person_dp_month
                          ) per ON enc.person_id = per.person_id
                LEFT JOIN dwh.data_location loc ON enc.location_key = loc.location_key
                LEFT JOIN dwh.data_user prov ON enc.provider_key = prov.user_key; 
				

		
        ALTER TABLE   fdt.[Dim PHI Validate]
        ADD CONSTRAINT enc_key_pk10 PRIMARY KEY (enc_key);
			
			


        SELECT  per_mon_id ,
                first_mon_date ,
                mh_cur_key ,
                mh_hx_key ,
                pcp_cur_key ,
                pcp_hx_key ,
                expired_date AS [Date of Death] ,
                status_hx_key AS [Patient Status Historical] ,
                status_cur_key AS [Patient Status Current] ,
                CASE WHEN First_enc_age_months <= 1 THEN '1 Month - New Patient'
                     WHEN First_enc_age_months <= 6 THEN '2-6 Months'
                     WHEN First_enc_age_months <= 12 THEN '7-12 Months - 1 Year'
                     WHEN First_enc_age_months <= 24 THEN '13-24 Months- 2 Years'
                     WHEN First_enc_age_months <= 36 THEN '25-36 Months- 3 Years'
                     WHEN First_enc_age_months <= 48 THEN '37-48 Months- 4 Years'
                     WHEN First_enc_age_months <= 60 THEN '49-60 Months- 5 Years'
                     WHEN First_enc_age_months <= 120 THEN '61-120 Months- 6-10 Years'
                     WHEN First_enc_age_months <= 180 THEN '121-180 Months- 11-15 Years'
                     WHEN First_enc_age_months <= 240 THEN '181-240 Months- 15-20 Years'
                     WHEN First_enc_age_months > 240 THEN '>240 Months- 20 Years'
                END AS [Time as Member] ,
                CASE WHEN First_enc_age_months <= 1 THEN 1
                     WHEN First_enc_age_months <= 6 THEN 2
                     WHEN First_enc_age_months <= 12 THEN 3
                     WHEN First_enc_age_months <= 24 THEN 4
                     WHEN First_enc_age_months <= 36 THEN 5
                     WHEN First_enc_age_months <= 48 THEN 6
                     WHEN First_enc_age_months <= 60 THEN 7
                     WHEN First_enc_age_months <= 120 THEN 8
                     WHEN First_enc_age_months <= 180 THEN 9
                     WHEN First_enc_age_months <= 240 THEN 10
                     WHEN First_enc_age_months > 240 THEN 11
                END AS membership_time_sort ,
                CASE WHEN nbr_new_pt = 1 THEN 'New Patient This Month'
                     WHEN nbr_pt_seen_office_ever = 1 THEN 'Established Patient'
                     ELSE 'Not a Patient Yet'
                END AS [Is Patient New] ,
                CASE WHEN nbr_pt_seen_office_ever = 1 THEN 'Established Patient'
                     ELSE 'Has not Established Care'
                END AS [Is Patient Established] ,
                CASE WHEN nbr_pt_deceased = 1 THEN 'Patient Deceased'
                     ELSE 'Patient Living'
                END AS [Is Patient Alive] ,
                CASE WHEN nbr_pt_deceased_this_month = 1 THEN 'Patient Deceased This Month'
                     WHEN nbr_pt_deceased = 1 THEN 'Patient Deceased'
                     ELSE 'Patient Living'
                END AS [Is Patient Deceased this Month] ,
                First_enc_age_months AS [Membership Month] ,
                age_hx AS [Age Hx] ,
                age_cur AS [Age Cur] ,

               
			    -- Age update -- 
                CASE WHEN age_hx <= 18 THEN '0-18 Years'
                     WHEN age_hx <= 29 THEN '19-29 Years'
                     WHEN age_hx <= 39 THEN '30-39 Years'
                     WHEN age_hx <= 49 THEN '40-49 Years'
                     WHEN age_hx <= 59 THEN '50-59 Years'
                     WHEN age_hx <= 64 THEN '60-64 Years'
                     WHEN age_hx <= 74 THEN '65-74 Years'
                     WHEN age_hx <= 79 THEN '75-79 Years'
                     WHEN age_hx <= 89 THEN '80-89 Years'
                     WHEN age_hx <= 99 THEN '90-99 Years'
                     WHEN age_hx >= 100 THEN '>100 Years'
                     ELSE 'Age Unknown'
                END AS [Age Historical] ,
                CASE WHEN age_hx <= 18 THEN 1
                     WHEN age_hx <= 29 THEN 2
                     WHEN age_hx <= 39 THEN 3
                     WHEN age_hx <= 49 THEN 4
                     WHEN age_hx <= 59 THEN 5
                     WHEN age_hx <= 64 THEN 6
                     WHEN age_hx <= 74 THEN 7
                     WHEN age_hx <= 79 THEN 8
                     WHEN age_hx <= 89 THEN 9
                     WHEN age_hx <= 99 THEN 10
                     WHEN age_hx >= 100 THEN 11
                     ELSE 12
                END AS Age_Hx_sort ,
                CASE WHEN age_cur <= 18 THEN '0-18 Years'
                     WHEN age_cur <= 29 THEN '19-29 Years'
                     WHEN age_cur <= 39 THEN '30-39 Years'
                     WHEN age_cur <= 49 THEN '40-49 Years'
                     WHEN age_cur <= 59 THEN '50-59 Years'
                     WHEN age_cur <= 64 THEN '60-64 Years'
                     WHEN age_cur <= 74 THEN '65-74 Years'
                     WHEN age_cur <= 79 THEN '75-79 Years'
                     WHEN age_cur <= 89 THEN '80-89 Years'
                     WHEN age_cur <= 99 THEN '90-99 Years'
                     WHEN age_cur >= 100 THEN '>100 Years'
                     ELSE 'Age Unknown'
                END AS [Age Current] ,
                CASE WHEN age_cur <= 18 THEN 1
                     WHEN age_cur <= 29 THEN 2
                     WHEN age_cur <= 39 THEN 3
                     WHEN age_cur <= 49 THEN 4
                     WHEN age_cur <= 59 THEN 5
                     WHEN age_cur <= 64 THEN 6
                     WHEN age_cur <= 74 THEN 7
                     WHEN age_cur <= 79 THEN 8
                     WHEN age_cur <= 89 THEN 9
                     WHEN age_cur <= 99 THEN 10
                     WHEN age_cur >= 100 THEN 11
                     ELSE 12
                END AS age_cur_sort ,
                patient_vintage AS [Patient Vintage Month] ,
                CASE WHEN patient_vintage <= '198912' THEN '<1990'
                     WHEN patient_vintage <= '199412' THEN '1990-1994'
                     WHEN patient_vintage <= '199912' THEN '1995-1999'
                     WHEN patient_vintage <= '200412' THEN '2000-2004'
                     WHEN patient_vintage <= '200912' THEN '2005-2009'
                     WHEN patient_vintage <= '201012' THEN '2010'
                     WHEN patient_vintage <= '201112' THEN '2011'
                     WHEN patient_vintage <= '201212' THEN '2012'
                     WHEN patient_vintage <= '201312' THEN '2013'
                     WHEN patient_vintage <= '201412' THEN '2014'
                     WHEN patient_vintage <= '201512' THEN '2015'
                     WHEN patient_vintage <= '201612' THEN '2016'
                     WHEN patient_vintage <= '201712' THEN '2017'
                     WHEN patient_vintage <= '201812' THEN '2018'
                     WHEN patient_vintage <= '201912' THEN '2019'
                     WHEN patient_vintage <= '202012' THEN '2020'
                     ELSE 'Unknown'
                END AS [Patient Vintage Month Range] ,
                CASE WHEN patient_vintage <= '198912' THEN 1
                     WHEN patient_vintage <= '199412' THEN 2
                     WHEN patient_vintage <= '199912' THEN 3
                     WHEN patient_vintage <= '200412' THEN 4
                     WHEN patient_vintage <= '200912' THEN 5
                     WHEN patient_vintage <= '201012' THEN 6
                     WHEN patient_vintage <= '201112' THEN 7
                     WHEN patient_vintage <= '201212' THEN 8
                     WHEN patient_vintage <= '201312' THEN 9
                     WHEN patient_vintage <= '201412' THEN 10
                     WHEN patient_vintage <= '201512' THEN 11
                     WHEN patient_vintage <= '201612' THEN 12
                     WHEN patient_vintage <= '201712' THEN 13
                     WHEN patient_vintage <= '201812' THEN 14
                     WHEN patient_vintage <= '201912' THEN 15
                     WHEN patient_vintage <= '202012' THEN 16
                     ELSE 17
                END AS [Patient Vintage Month sort] ,
                full_name AS [Full Name] ,
                first_name AS [First Name] ,
                last_name AS [Last Name] ,
                middle_name AS [Middle Name] ,
                address_line_1 AS [Address 1] ,
                address_line_2 AS [Adress 2] ,
                city AS [City] ,
                state AS [State] ,
                zip AS [Zipcode] ,
                home_phone [Home Phone Number] ,
                sex AS [Gender] ,
                ssn AS [SSN] ,
                dob AS [DOB] ,
                alt_phone AS [Alternate Phone Number] ,
                marital_status AS [Marital Status] ,
                race AS [Race] ,
                language AS [Language] ,
                med_rec_nbr AS [Medical Record Number],
				[Address Full]
        INTO    fdt.[Dim PHI Patient]
        FROM    dwh.data_person_dp_month;	
		
				
        ALTER TABLE    fdt.[Dim PHI Patient]
        ADD CONSTRAINT per_mon_id_pk5 PRIMARY KEY (per_mon_id);
	
	
        SELECT  per_mon_id ,
                first_mon_date ,
                mh_cur_key ,
                mh_hx_key ,
                pcp_cur_key ,
                pcp_hx_key ,
                status_hx_key AS [Patient Status Historical] ,
                status_cur_key AS [Patient Status Current] ,
                First_enc_age_months AS [Membership Month] ,
                CASE WHEN First_enc_age_months <= 1 THEN '1 Month - New Patient'
                     WHEN First_enc_age_months <= 6 THEN '2-6 Months'
                     WHEN First_enc_age_months <= 12 THEN '7-12 Months - 1 Year'
                     WHEN First_enc_age_months <= 24 THEN '13-24 Months- 2 Years'
                     WHEN First_enc_age_months <= 36 THEN '25-36 Months- 3 Years'
                     WHEN First_enc_age_months <= 48 THEN '37-48 Months- 4 Years'
                     WHEN First_enc_age_months <= 60 THEN '49-60 Months- 5 Years'
                     WHEN First_enc_age_months <= 120 THEN '61-120 Months- 6-10 Years'
                     WHEN First_enc_age_months <= 180 THEN '121-180 Months- 11-15 Years'
                     WHEN First_enc_age_months <= 240 THEN '181-240 Months- 15-20 Years'
                     WHEN First_enc_age_months > 240 THEN '>240 Months- 20 Years'
                END AS [Time as Member] ,
                CASE WHEN First_enc_age_months <= 1 THEN 1
                     WHEN First_enc_age_months <= 6 THEN 2
                     WHEN First_enc_age_months <= 12 THEN 3
                     WHEN First_enc_age_months <= 24 THEN 4
                     WHEN First_enc_age_months <= 36 THEN 5
                     WHEN First_enc_age_months <= 48 THEN 6
                     WHEN First_enc_age_months <= 60 THEN 7
                     WHEN First_enc_age_months <= 120 THEN 8
                     WHEN First_enc_age_months <= 180 THEN 9
                     WHEN First_enc_age_months <= 240 THEN 10
                     WHEN First_enc_age_months > 240 THEN 11
                END AS membership_time_sort ,
                CASE WHEN nbr_new_pt = 1 THEN 'New Patient This Month'
                     WHEN nbr_pt_seen_office_ever = 1 THEN 'Established Patient'
                     ELSE 'Not a Patient Yet'
                END AS [Is Patient New] ,
                CASE WHEN nbr_pt_seen_office_ever = 1 THEN 'Established Patient'
                     ELSE 'Has not Established Care'
                END AS [Is Patient Established] ,
                CASE WHEN nbr_pt_deceased = 1 THEN 'Patient Deceased'
                     ELSE 'Patient Living'
                END AS [Is Patient Alive] ,
                CASE WHEN nbr_pt_deceased_this_month = 1 THEN 'Patient Deceased This Month'
                     WHEN nbr_pt_deceased = 1 THEN 'Patient Deceased'
                     ELSE 'Patient Living'
                END AS [Is Patient Deceased this Month] ,
                patient_vintage AS [Patient Vintage Month] ,
                CASE WHEN patient_vintage <= '198912' THEN '<1990'
                     WHEN patient_vintage <= '199412' THEN '1990-1994'
                     WHEN patient_vintage <= '199912' THEN '1995-1999'
                     WHEN patient_vintage <= '200412' THEN '2000-2004'
                     WHEN patient_vintage <= '200912' THEN '2005-2009'
                     WHEN patient_vintage <= '201012' THEN '2010'
                     WHEN patient_vintage <= '201112' THEN '2011'
                     WHEN patient_vintage <= '201212' THEN '2012'
                     WHEN patient_vintage <= '201312' THEN '2013'
                     WHEN patient_vintage <= '201412' THEN '2014'
                     WHEN patient_vintage <= '201512' THEN '2015'
                     WHEN patient_vintage <= '201612' THEN '2016'
                     WHEN patient_vintage <= '201712' THEN '2017'
                     WHEN patient_vintage <= '201812' THEN '2018'
                     WHEN patient_vintage <= '201912' THEN '2019'
                     WHEN patient_vintage <= '202012' THEN '2020'
                     ELSE 'Unknown'
                END AS [Patient Vintage Month Range] ,
                CASE WHEN patient_vintage <= '198912' THEN 1
                     WHEN patient_vintage <= '199412' THEN 2
                     WHEN patient_vintage <= '199912' THEN 3
                     WHEN patient_vintage <= '200412' THEN 4
                     WHEN patient_vintage <= '200912' THEN 5
                     WHEN patient_vintage <= '201012' THEN 6
                     WHEN patient_vintage <= '201112' THEN 7
                     WHEN patient_vintage <= '201212' THEN 8
                     WHEN patient_vintage <= '201312' THEN 9
                     WHEN patient_vintage <= '201412' THEN 10
                     WHEN patient_vintage <= '201512' THEN 11
                     WHEN patient_vintage <= '201612' THEN 12
                     WHEN patient_vintage <= '201712' THEN 13
                     WHEN patient_vintage <= '201812' THEN 14
                     WHEN patient_vintage <= '201912' THEN 15
                     WHEN patient_vintage <= '202012' THEN 16
                     ELSE 17
                END AS [Patient Vintage Month sort] ,
                


			    -- Age update -- 
                CASE WHEN age_hx <= 18 THEN '0-18 Years'
                     WHEN age_hx <= 29 THEN '19-29 Years'
                     WHEN age_hx <= 39 THEN '30-39 Years'
                     WHEN age_hx <= 49 THEN '40-49 Years'
                     WHEN age_hx <= 59 THEN '50-59 Years'
                     WHEN age_hx <= 64 THEN '60-64 Years'
                     WHEN age_hx <= 74 THEN '65-74 Years'
                     WHEN age_hx <= 79 THEN '75-79 Years'
                     WHEN age_hx <= 89 THEN '80-89 Years'
                     WHEN age_hx <= 99 THEN '90-99 Years'
                     WHEN age_hx >= 100 THEN '>100 Years'
                     ELSE 'Age Unknown'
                END AS [Age Historical] ,
                CASE WHEN age_hx <= 18 THEN 1
                     WHEN age_hx <= 29 THEN 2
                     WHEN age_hx <= 39 THEN 3
                     WHEN age_hx <= 49 THEN 4
                     WHEN age_hx <= 59 THEN 5
                     WHEN age_hx <= 64 THEN 6
                     WHEN age_hx <= 74 THEN 7
                     WHEN age_hx <= 79 THEN 8
                     WHEN age_hx <= 89 THEN 9
                     WHEN age_hx <= 99 THEN 10
                     WHEN age_hx >= 100 THEN 11
                     ELSE 12
                END AS Age_Hx_sort ,
                CASE WHEN age_cur <= 18 THEN '0-18 Years'
                     WHEN age_cur <= 29 THEN '19-29 Years'
                     WHEN age_cur <= 39 THEN '30-39 Years'
                     WHEN age_cur <= 49 THEN '40-49 Years'
                     WHEN age_cur <= 59 THEN '50-59 Years'
                     WHEN age_cur <= 64 THEN '60-64 Years'
                     WHEN age_cur <= 74 THEN '65-74 Years'
                     WHEN age_cur <= 79 THEN '75-79 Years'
                     WHEN age_cur <= 89 THEN '80-89 Years'
                     WHEN age_cur <= 99 THEN '90-99 Years'
                     WHEN age_cur >= 100 THEN '>100 Years'
                     ELSE 'Age Unknown'
                END AS [Age Current] ,
                CASE WHEN age_cur <= 18 THEN 1
                     WHEN age_cur <= 29 THEN 2
                     WHEN age_cur <= 39 THEN 3
                     WHEN age_cur <= 49 THEN 4
                     WHEN age_cur <= 59 THEN 5
                     WHEN age_cur <= 64 THEN 6
                     WHEN age_cur <= 74 THEN 7
                     WHEN age_cur <= 79 THEN 8
                     WHEN age_cur <= 89 THEN 9
                     WHEN age_cur <= 99 THEN 10
                     WHEN age_cur >= 100 THEN 11
                     ELSE 12
                END AS age_cur_sort ,
                city AS [City] ,
                state AS [State] ,
                zip AS [Zipcode] ,
                sex AS [Gender] ,
                marital_status AS [Marital Status] ,
                race AS [Race] ,
                language AS [Language]
        INTO    fdt.[Dim Patient]
        FROM    dwh.data_person_dp_month;	
		
				
        ALTER TABLE    fdt.[Dim Patient]
        ADD CONSTRAINT per_mon_id_pk6 PRIMARY KEY (per_mon_id);
	
	

----
--Build Bridge Tables--


        --SELECT  employee_key ,
        --        employee_month_key
        --INTO    fdt.bridge_emp_to_emp_mon
        --FROM    dwh.data_employee_month;

        --SELECT  employee_key ,
        --        user_key
        --INTO    fdt.bridge_usr_emp
        --FROM    dwh.data_user;
				
/*



        SELECT  [ndc_id] ,
                COALESCE([gcn_seqno], -1) AS gcn_seqno ,
                COALESCE([hicl_seqno], '') AS [hicl_seqno] ,
                COALESCE([medid], -1) AS medid ,
                COALESCE([gcn], -1) AS gcn ,
                COALESCE([brand_name], '') AS brand_name ,
                COALESCE([generic_name], '') AS generic_name ,
                COALESCE([dose], '') AS dose ,
                COALESCE([dose_form_desc], '') AS dose_form_desc ,
                COALESCE([route_desc], '') AS route_desc ,
                COALESCE([med_cat_class_desc], '') AS med_class ,
                COALESCE([dea_id], '') AS med_sched ,
                COALESCE([generic_indicator], '') AS gen_ind ,
                COALESCE([delete_ind], '') AS del_ind
        INTO    fdt.dim_medication
        FROM    [10.183.0.94].[NGProd].[dbo].[fdb_medication];

		
        SELECT  [pharmacy_id] ,
                COALESCE([name], '') AS Name ,
                COALESCE([address_line_1], '') AS Address1 ,
                COALESCE([address_line_2], '') AS address2 ,
                COALESCE([city], '') AS city ,
                COALESCE([state], '') AS state ,
                COALESCE([zip], '') AS zipcode ,
                COALESCE([phone], '') AS phone ,
                COALESCE([fax], '') AS fax ,
                COALESCE([delete_ind], '') AS deleted_ind ,
                COALESCE([store_number], '') AS store_number ,
                COALESCE([active_erx_ind], '') AS accept_erx ,
                COALESCE([mail_order_ind], '') AS accept_rx_mail_order ,
                COALESCE(rx_by_fax_ind, '') AS accept_rx_fax
        INTO    fdt.dim_pharmacy
        FROM    [10.183.0.94].[NGProd].[dbo].[pharmacy_mstr]; 


	*/ 
	 
	 
	--  [operation_type] ,  -- will need to merge this back on to pharmacy as extra attribute
               
	 

	   
/*	   
      
        SELECT  [cpt4_code_id] ,
                ( FLOOR(RANK() OVER ( ORDER BY cpt4_code_id ) / 1000) + 1 ) AS CPT_Group ,
                [description] ,
                [type_of_service]
        INTO    [prod_ghost].fdt.dim_cpt4
        FROM    [10.183.0.94].[NGProd].[dbo].[cpt4_code_mstr]; 

	


SELECT  service_item_id ,
        ( FLOOR(RANK() OVER ( ORDER BY service_item_id ) / 1000) + 1 ) AS Service_Item_Group ,
        eff_date ,
        exp_date ,
        COALESCE(description, '') AS description ,
        cpt4_code_id ,
        current_price,
        COALESCE(revenue_code, '') AS revenue_code ,
        COALESCE(form, '') AS form ,
        COALESCE(rental_duration_per_unit, '') AS rental_duration_per_unit ,
        COALESCE(unassigned_benefit, 0) AS unassigned_benefit ,
        COALESCE(unassigned_benefit_fac, 0) AS unassigned_benefit_fac ,
        rental_ind,
        behavioral_billing_ind,
        self_pay_fqhc_ind,
        sliding_fee_fqhc_ind,
        clinic_rate_exempt_ind,
        sliding_fee_exempt_ind,
        fqhc_enc_ind,
        delete_ind
INTO    fdt.dim_service_item
FROM    [10.183.0.94].NGProd.dbo.service_item_mstr;
*/


    END;
GO
