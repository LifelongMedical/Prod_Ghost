SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_schedule-Not used]
	--
AS
    BEGIN

	 

 --Planning to leave this scheduling information for another day
 --Key steps here is that this routine will scheduling template data and make a database of slots (Date and duration) by resource and category and location.
 --The important metrics to derive form this database are unfilled slots and number of hours of schedule in each assigned resource, time, and category
 --A useful analysis that we are looking for is of the scheduled times we put into the schedule by category how much of that time is used by appointments
 --Meaning -- What percent of the category template is getting filled by appointment hours.  In 100% efficient system, evert minute of scheduled resource/category/time is occupied
 --           by appointments.  The the one issue that we come up with in this regard is how we are booking group visits as they can have multiple apppointments associated with them
 --           This may not amount to much as if we don't necessarily need to match appts with all categories
 --    Not sure how to get TNAA -- The challenge is that its not completely clear to me how to mark schedule as still having allowable appointments/events
 --    Probably need to go to the TNAA 

	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.

        SET NOCOUNT ON;

		
        IF OBJECT_ID('dwh.data_schedule') IS NOT NULL
            DROP TABLE dwh.data_schedule;


CREATE TABLE dwh.data_schedule (
	[seq_no] [UNIQUEIDENTIFIER] NOT NULL,
	[location_id] [UNIQUEIDENTIFIER] NULL,
	[prov_res_id] [UNIQUEIDENTIFIER] NULL,
	[provider_id] [UNIQUEIDENTIFIER] NULL,
	[resource_id] [UNIQUEIDENTIFIER] NULL,
	[slot_category_id] [UNIQUEIDENTIFIER] NULL,
	[appt_template_id] [UNIQUEIDENTIFIER] NULL,
	[practice_id] [CHAR](4) NULL,
	[created_by] [INT] NOT NULL,
	[create_timestamp] [DATETIME] NOT NULL DEFAULT (GETDATE()),
	[modified_by] [INT] NOT NULL,
	[modify_timestamp] [DATETIME] NOT NULL DEFAULT (GETDATE()),
	[create_timestamp_tz] [SMALLINT] NULL,
	[modify_timestamp_tz] [SMALLINT] NULL,
	[row_timestamp] [TIMESTAMP] NOT NULL,
	[appt_template_name] [VARCHAR](30) NULL,
	[appts_ind] [VARCHAR](3) NULL,
	[daily_template_ind] [VARCHAR](1) NULL,
	[exception_ind] [VARCHAR](1) NULL,
	[location_name] [VARCHAR](40) NULL,
	[patients_ind] [VARCHAR](3) NULL,
	[prevent_appts_ind] [VARCHAR](1) NULL,
	[provider_name] [VARCHAR](75) NULL,
	[resource_name] [VARCHAR](30) NULL,
	[rpt_mon] [VARCHAR](6) NULL,
	[rpt_week] [VARCHAR](8) NULL,
	[slot_begin_time] [VARCHAR](4) NULL,
	[slot_category] [VARCHAR](30) NULL,
	[slot_date] [VARCHAR](8) NULL,
	[slot_end_time] [VARCHAR](4) NULL,
	[working_ind] [VARCHAR](3) NULL,
	[slot_duration] [INT] NULL,
	[slot_date_dt] [DATE] NULL,
	[prov_res_name] [VARCHAR](75) NULL,
	[prov_res_ind] [VARCHAR](1) NULL,
	[category_group] [VARCHAR](40) NULL,
	[sched_min_tot_dur] [DECIMAL](16, 2) NULL,
	[sched_min_working_dur] [DECIMAL](16, 2) NULL,
	[sched_min_patients_dur] [DECIMAL](16, 2) NULL,
	[sched_min_no_appts_dur] [DECIMAL](16, 2) NULL,
	[sched_hrs_tot_dur] [DECIMAL](16, 2) NULL,
	[sched_hrs_working_dur] [DECIMAL](16, 2) NULL,
	[sched_hrs_clinical_dur] [DECIMAL](16, 2) NULL,
	[sched_hrs_no_appts_dur] [DECIMAL](16, 2) NULL
) ON [PRIMARY]


DROP TABLE #t

 -- Insert statements for procedure here
        DECLARE @dt_start VARCHAR(8) ,
            @dt_end VARCHAR(8);
        DECLARE @prac_id CHAR(4);
    --    SET @dt_start = CONVERT(VARCHAR(8), GETDATE(), 112); --This routine will build current and hx data from begin to end date 


SET @dt_start = '20151101' 
SET @prac_id = '0001';
SET @dt_end = ( SELECT  MAX(rt.week_end_date)
                        FROM    [10.183.0.94].[NGProd].[dbo].resource_templates rt
                      );
 



        DECLARE @u INT; -- user id to use as the created by
        DECLARE @t DATETIME;
		 
        SET @u = 0;
        SET @t = GETDATE();
        DECLARE @dt_inc VARCHAR(8);
        
		SET @dt_inc = @dt_start; 

      DELETE  FROM [dwh].[data_schedule]
    WHERE   slot_date BETWEEN @dt_start AND @dt_end;
       
	   
	   
	    WHILE @dt_inc <= @dt_end
            BEGIN
                
				SELECT DISTINCT
                        r.phys_id,
                        resource_name = r.description ,
                        resource_id = r.resource_id ,
                        appt_template_name = t.template ,
                        appt_template_id = t.appt_template_id ,
                        appt_template_interval = t.interval ,
                        appt_template_daily_ind = t.daily_template_ind ,
                        appt_template_exception_ind = t.exception_ind ,
                        rt.week_start_date ,
                        tm.day ,
                        slot_date = @dt_inc ,
                        tm.begintime ,
                        tm.endtime ,
                        tm.duration ,
                        c.prevent_appts_ind ,
                        cm.category_desc ,
                        cm.category_id ,
                        cm.working_ind ,
                        cm.patients_ind ,
                        cm.appts_ind ,
                    
                        ast.overbook_limit
                INTO    #t
                FROM    [10.183.0.94].[NGProd].[dbo].resources r
                           LEFT JOIN [10.183.0.94].[NGProd].[dbo].resource_templates rt ON r.resource_id = rt.resource_id
                                                                                        AND r.practice_id = rt.practice_id
                        LEFT JOIN [10.183.0.94].[NGProd].[dbo].appt_templates t ON rt.appt_template_id = t.appt_template_id
                                                                                   AND rt.practice_id = t.practice_id
                        LEFT JOIN [10.183.0.94].[NGProd].[dbo].template_members tm ON t.appt_template_id = tm.appt_template_id
                                                                                      AND t.practice_id = tm.practice_id
                        LEFT JOIN [10.183.0.94].[NGProd].[dbo].categories c ON tm.category_id = c.category_id
                        LEFT JOIN [10.183.0.94].[NGProd].[dbo].chcn_category_type_map_ep_ cm ON tm.category_id = cm.category_id
                        LEFT JOIN [10.183.0.94].[NGProd].[dbo].appt_slot_templates ast ON ast.practice_id = t.practice_id
                                                                                          AND ast.appt_template_id = t.appt_template_id
                                                                                          AND ast.day = tm.day
                                                                                          AND ast.begintime = tm.begintime
                WHERE   @dt_inc BETWEEN rt.week_start_date AND rt.week_end_date
                        AND r.practice_id = @prac_id
                        AND tm.day IN ( 0, DATEPART(dw, CAST(@dt_inc AS DATETIME)) ); 
						
						
					  SET @dt_inc = ( SELECT  CONVERT(VARCHAR(8), DATEADD(dd, 1, CAST(@dt_inc AS DATETIME)), 112)                        );
           
			
			
SELECT * FROM #t;

		/*	
			-- now update location info
	
						
						-- insert records, expanding multi-slot durations
              
			  
			  
			  
			    DECLARE @i INT ,
                    @z INT;
                SET @i = 1;
                SET @z = ( SELECT   MAX(duration / appt_template_interval)
                           FROM     #t
                         );
                WHILE @i <= @z
                    BEGIN
                        INSERT  INTO dwh.data_schedule
                                ( seq_no ,
                                  practice_id ,
                                  created_by ,
                                  create_timestamp ,
                                  modified_by ,
                                  modify_timestamp ,
                                  resource_name ,
                                  resource_id ,
                                  provider_name ,
                                  provider_id ,
                                  slot_category ,
                                  slot_category_id ,
                                  prevent_appts_ind ,
                                  working_ind ,
                                  patients_ind ,
                                  appts_ind ,
                                  location_name ,
                                  location_id ,
                                  slot_begin_time ,
                                  slot_end_time ,
                                  slot_duration ,
                                  slot_date ,
                                  rpt_week ,
                                  rpt_mon ,
                                  appt_template_name ,
                                  appt_template_id ,
                                  daily_template_ind ,
                                  exception_ind
                                )
                                SELECT  NEWID() ,
                                        @prac_id ,
                                        @u ,
                                        @t ,
                                        @u ,
                                        @t ,
                                        resource_name ,
                                        resource_id ,
                                        provider_name ,
                                        provider_id ,
                                        category_desc ,
                                        category_id ,
                                        prevent_appts_ind ,
                                        working_ind ,
                                        patients_ind ,
                                        appts_ind ,
                                        NULL --location_name
                                        ,
                                        NULL --location_id
                                        ,
                                        begintime = REPLACE(LEFT(CONVERT(VARCHAR(20), DATEADD(mi, 15 * ( @i - 1 ),
                                                                                              CAST(@dt_inc + ' '
                                                                                              + LEFT(begintime, 2) + ':'
                                                                                              + RIGHT(begintime, 2) AS DATETIME)), 114),
                                                                 5), ':', '') ,
                                        endtime ,
                                        duration = appt_template_interval ,
                                        slot_date ,
                                        rpt_week ,
                                        rpt_mon ,
                                        appt_template_name ,
                                        appt_template_id ,
                                        appt_template_daily_ind ,
                                        appt_template_exception_ind
                                FROM    #t
                                WHERE   duration / appt_template_interval >= @i;
         SET @i = @i + 1;
         END;
         
		        DROP TABLE #t;


				*/
    SET @dt_inc = ( SELECT  CONVERT(VARCHAR(8), DATEADD(dd, 1, CAST(@dt_inc AS DATETIME)), 112)
                              );
            END; -- now update location info



        UPDATE  d
        SET     d.location_id = tl.location_id ,
                d.location_name = loc.location_name
        FROM    dwh.data_schedule d
                LEFT JOIN [10.183.0.94].[NGProd].[dbo].template_locations tl ON d.appt_template_id = tl.appt_template_id
                                                                                AND ( DATEPART(dw,
                                                                                               CAST(d.slot_date AS DATETIME)) = tl.day
                                                                                      OR tl.day = 0
                                                                                    )
                                                                                AND d.slot_begin_time BETWEEN tl.begintime AND tl.endtime
                                                                                AND d.practice_id = tl.practice_id
                LEFT JOIN [10.183.0.94].[NGProd].[dbo].location_mstr loc ON tl.location_id = loc.location_id -- add in date filter
        WHERE   d.slot_date BETWEEN @dt_start AND @dt_end;



        UPDATE  sd
        SET     slot_date_dt = CAST(sd.slot_date AS DATE) ,
                prov_res_name = ISNULL(sd.provider_name, ISNULL(sd.resource_name, '')) ,
                prov_res_id = ISNULL(sd.provider_id, sd.resource_id) ,
                prov_res_ind = CASE WHEN sd.provider_id IS NULL THEN 'R'
                                    ELSE 'P'
                               END ,
                category_group = cmp.group1 ,
                sched_min_tot_dur = sd.slot_duration ,
                sched_min_working_dur = CASE WHEN sd.working_ind = 'Yes' THEN sd.slot_duration
                                             ELSE 0
                                        END ,
                sched_min_patients_dur = CASE WHEN sd.patients_ind = 'Yes' THEN sd.slot_duration
                                              ELSE 0
                                         END ,
                sched_min_no_appts_dur = CASE WHEN sd.appts_ind = 'No' THEN sd.slot_duration
                                              ELSE 0
                                         END ,
                sched_hrs_tot_dur = CAST(ISNULL(sched_min_tot_dur, 0) AS NUMERIC(12, 2)) / 60 ,
                sched_hrs_working_dur = CAST(ISNULL(sched_min_working_dur, 0) AS NUMERIC(12, 2)) / 60 ,
                sched_hrs_clinical_dur = CAST(ISNULL(sched_min_patients_dur, 0) AS NUMERIC(12, 2)) / 60 ,
                sched_hrs_no_appts_dur = CAST(ISNULL(sched_min_no_appts_dur, 0) AS NUMERIC(12, 2)) / 60
        FROM    dwh.data_schedule sd
                LEFT JOIN [10.183.0.94].[NGProd].[dbo].chcn_category_type_map_ep_ cmp ON sd.slot_category_id = cmp.category_id
        WHERE   sd.slot_date BETWEEN CONVERT(CHAR(8), @dt_start, 112)
                             AND     CONVERT(CHAR(8), @dt_end, 112);
        UPDATE  sd
        SET     sched_hrs_tot_dur = CAST(ISNULL(sched_min_tot_dur, 0) AS NUMERIC(12, 2)) / 60 ,
                sched_hrs_working_dur = CAST(ISNULL(sched_min_working_dur, 0) AS NUMERIC(12, 2)) / 60 ,
                sched_hrs_clinical_dur = CAST(ISNULL(sched_min_patients_dur, 0) AS NUMERIC(12, 2)) / 60 ,
                sched_hrs_no_appts_dur = CAST(ISNULL(sched_min_no_appts_dur, 0) AS NUMERIC(12, 2)) / 60
        FROM    dwh.data_schedule sd;



	
    END

GO
