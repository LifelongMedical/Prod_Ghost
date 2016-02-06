SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_create_constraints]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here

	--Create constraints for the Fact Schedule slot table
	             

     ALTER TABLE fdt.[Fact Schedule]
        ADD CONSTRAINT FK_appt6 FOREIGN KEY ([slot_time] )
        REFERENCES fdt.[Dim Time of Day] ([Time of Slot]);

	     ALTER TABLE fdt.[Fact Schedule]
        ADD CONSTRAINT FK_appt_date FOREIGN KEY ([appt_date] )
        REFERENCES fdt.[Dim Time]([Key Date]);

	 	     ALTER TABLE fdt.[Fact Schedule]
        ADD CONSTRAINT FK_slot_loc_key  FOREIGN KEY ( [slot_loc_key]  )
        REFERENCES fdt.[Dim Location for Enc or Appt](location_key);

 	     ALTER TABLE fdt.[Fact Schedule]
        ADD CONSTRAINT FK_schedule_resource_key FOREIGN KEY ( [schedule_resource_key]  )
        REFERENCES fdt.[Dim Provider Rendering](user_key);

	 	 --Can not add category_id here because it is not a primary key, can still add it in the tabular solution


			--Related Fact Tables
				
       /* ALTER TABLE Prod_Ghost.fdt.[Dim Patient]
        ADD CONSTRAINT FK_mh_cur_key2 FOREIGN KEY (mh_cur_key )
        REFERENCES fdt.[Dim Medical Home Current] (location_key);


        ALTER TABLE Prod_Ghost.fdt.[Dim Patient]
        ADD CONSTRAINT FK_mh_hx_key3 FOREIGN KEY (mh_hx_key )
        REFERENCES fdt.[Dim Medical Home Historical] (location_key);
		
        ALTER TABLE Prod_Ghost.fdt.[Dim Patient]
        ADD CONSTRAINT FK_pcp_cur_key4 FOREIGN KEY (pcp_cur_key )
        REFERENCES fdt.[Dim PCP Current] (user_key);

        ALTER TABLE Prod_Ghost.fdt.[Dim Patient]
        ADD CONSTRAINT FK_pcp_hx_key5 FOREIGN KEY (pcp_hx_key )
        REFERENCES fdt.[Dim PCP Historical] (user_key);
		*/


        ALTER TABLE Prod_Ghost.fdt.[Dim PHI Patient]
        ADD CONSTRAINT FK_mh_cur_key6 FOREIGN KEY (mh_cur_key )
        REFERENCES fdt.[Dim Medical Home Current] (location_key);

		ALTER TABLE Prod_Ghost.fdt.[Dim PHI Patient]
        ADD CONSTRAINT FK_mh_hx_key7 FOREIGN KEY (mh_hx_key )
        REFERENCES fdt.[Dim Medical Home Historical] (location_key);
		
        ALTER TABLE Prod_Ghost.fdt.[Dim PHI Patient]
        ADD CONSTRAINT FK_pcp_cur_key8 FOREIGN KEY (pcp_cur_key )
        REFERENCES fdt.[Dim PCP Current] (user_key);

        ALTER TABLE Prod_Ghost.fdt.[Dim PHI Patient]
        ADD CONSTRAINT FK_pcp_hx_key9 FOREIGN KEY (pcp_hx_key )
        REFERENCES fdt.[Dim PCP Historical] (user_key);


		--Fact Patient

        ALTER TABLE Prod_Ghost.fdt.[Fact Patient]
        ADD CONSTRAINT FK_per_mon_id3 FOREIGN KEY (per_mon_id )
        REFERENCES fdt.[Dim PHI Patient];

        ALTER TABLE Prod_Ghost.fdt.[Fact Patient]
        ADD CONSTRAINT FK_first_mon_date FOREIGN KEY (first_mon_date )
        REFERENCES fdt.[Dim Time];

		/*
        ALTER TABLE Prod_Ghost.fdt.[Fact Patient]
        ADD CONSTRAINT FK_per_mon_id1 FOREIGN KEY (per_mon_id )
        REFERENCES fdt.[Dim Patient];
		*/

        
		/* Likely need to drop these relationships
		
		ALTER TABLE Prod_Ghost.fdt.[Fact Patient]
        ADD CONSTRAINT FK_mh_cur_key FOREIGN KEY (mh_cur_key )
        REFERENCES fdt.[Dim Medical Home Current] (location_key);

        ALTER TABLE Prod_Ghost.fdt.[Fact Patient]
        ADD CONSTRAINT FK_mh_hx_key FOREIGN KEY (mh_hx_key )
        REFERENCES fdt.[Dim Medical Home Historical] (location_key);
		
        ALTER TABLE Prod_Ghost.fdt.[Fact Patient]
        ADD CONSTRAINT FK_pcp_cur_key FOREIGN KEY (pcp_cur_key )
        REFERENCES fdt.[Dim PCP Current] (user_key);

        ALTER TABLE Prod_Ghost.fdt.[Fact Patient]
        ADD CONSTRAINT FK_pcp_hx_key FOREIGN KEY (pcp_hx_key )
        REFERENCES fdt.[Dim PCP Historical] (user_key);

		*/

		--Fact Encounter and Appointments

        ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_user_resource_key2 FOREIGN KEY (user_resource_key )
        REFERENCES fdt.[Dim User Schedule Resource] (user_key);

        ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_enc_rendering_key3 FOREIGN KEY (enc_rendering_key )
        REFERENCES fdt.[Dim Provider Rendering] (user_key);

        ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_location_key FOREIGN KEY (location_key )
        REFERENCES fdt.[Dim Location for Enc or Appt] (location_key);

		ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_per_mon_id FOREIGN KEY (per_mon_id )
        REFERENCES fdt.[Dim PHI Patient] (per_mon_id);
		
		ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_enc_appt_comp_key FOREIGN KEY (enc_appt_comp_key )
        REFERENCES fdt.[Dim Status Enc and Appt](enc_appt_comp_key);
		
			ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_event_key1 FOREIGN KEY (event_key )
        REFERENCES fdt.[Dim Category and Event] (cat_event_key);
		
		     ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_appt62 FOREIGN KEY (appt_time )
        REFERENCES fdt.[Dim Time of Day] ([Time of Slot]);



   /*
        ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_per_mon_id16 FOREIGN KEY (per_mon_id )
        REFERENCES fdt.[Dim Patient];
	*/
		
            --NEED TO ADD Event_id Dimension at some point

        ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_enc_app_date FOREIGN KEY (enc_app_date)
        REFERENCES fdt.[Dim Time] ([Key Date]);

		ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_user_enc_created3 FOREIGN KEY (user_enc_created)
        REFERENCES fdt.[Dim User Encounter Creator] (user_key);

		ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_user_appt_created FOREIGN KEY (user_appt_created)
        REFERENCES fdt.[Dim User Appointment Creator] (user_key);

        ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_user_checkout FOREIGN KEY (User_Checkout)
        REFERENCES fdt.[Dim User Checkout] (user_key);


        ALTER TABLE Prod_Ghost.fdt.[Fact Encounter and Appointment]
        ADD CONSTRAINT FK_User_ReadyforProvider FOREIGN KEY (User_ReadyforProvider)
        REFERENCES fdt.[Dim User Ready for Provider] (user_key);
		
          		 
			 
        ALTER TABLE Prod_Ghost.fdt.[Fact Employee]
        ADD CONSTRAINT FK_employee_month_key FOREIGN KEY (employee_month_key )
        REFERENCES fdt.[Dim Employee Historical] (employee_month_key);
		
        ALTER TABLE Prod_Ghost.fdt.[Fact Employee Hours]
        ADD CONSTRAINT FK_employee_month_key3 FOREIGN KEY (employee_month_key )
        REFERENCES fdt.[Dim Employee Historical] (employee_month_key);
		
     /*  
	 For some reason this is erroring out so I am commenting it out, I will return to this later as the relationship is necessary for the tabular model
	 
	  ALTER TABLE Prod_Ghost.fdt.[Fact Employee Hours]
        ADD CONSTRAINT FK_employee_hours_comp_key3  FOREIGN KEY (employee_hours_comp_key )
        REFERENCES fdt.[Dim Employee Hour Detail] (employee_hours_comp_key);
		*/
		
				
        ALTER TABLE Prod_Ghost.fdt.[Fact Employee Hours]
        ADD CONSTRAINT FK_pay_date1 FOREIGN KEY ([Pay Date] )
        REFERENCES fdt.[Dim Time] ([Key Date]);
			   
        ALTER TABLE Prod_Ghost.fdt.[Fact Employee]
        ADD CONSTRAINT FK_first_mon_date2 FOREIGN KEY (first_mon_date )
        REFERENCES fdt.[Dim Time] ([Key Date]);
 
        ALTER TABLE Prod_Ghost.fdt.[Dim Employee Historical]
        ADD CONSTRAINT FK_employee_key71 FOREIGN KEY (employee_key )
        REFERENCES fdt.[Dim Employee] (employee_key);
  
        --ALTER TABLE Prod_Ghost.fdt.[Dim Provider Rendering]
        --ADD CONSTRAINT FK_employee_key17 FOREIGN KEY (employee_key )
        --REFERENCES fdt.[Dim Employee] (employee_key);
 

    ALTER TABLE Prod_Ghost.fdt.[Fact Budget]
        ADD CONSTRAINT FK_location_key99 FOREIGN KEY (location_key )
        REFERENCES fdt.[Dim Location for Enc or Appt] (location_key);

   
    END;
GO
