CREATE TABLE [dwh].[data_appointment]
(
[enc_appt_key] [int] NOT NULL IDENTITY(1, 1),
[user_resource_key] [int] NULL,
[resource_id] [uniqueidentifier] NULL,
[appt_loc_key] [int] NULL,
[appt_loc_id] [uniqueidentifier] NULL,
[enc_id] [uniqueidentifier] NULL,
[enc_id_ecw] [int] NULL,
[enc_loc_key] [int] NULL,
[enc_loc_id] [uniqueidentifier] NULL,
[enc_rendering_key] [int] NULL,
[provider_key] [int] NULL,
[enc_rendering_id] [uniqueidentifier] NULL,
[per_mon_id] [int] NULL,
[person_key] [int] NULL,
[location_key] [int] NULL,
[enc_appt_comp_key] [bigint] NULL,
[event_key] [int] NULL,
[event_name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[enc_app_date] [date] NULL,
[pcp_id] [uniqueidentifier] NULL,
[appt_person_id] [uniqueidentifier] NULL,
[enc_person_id] [uniqueidentifier] NULL,
[event_id] [uniqueidentifier] NULL,
[enc_date] [date] NULL,
[enc_checkin_datetime] [datetime] NULL,
[appt_nbr] [numeric] (18, 0) NULL,
[enc_nbr] [numeric] (18, 0) NULL,
[appt_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[enc_slot_type] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_date] [date] NULL,
[appt_date_last] [date] NULL,
[enc_date_last] [date] NULL,
[appt_time] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_duration] [int] NULL,
[appt_interval] [int] NULL,
[appt_kept_ind] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_cancel_ind] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_resched_ind] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_delete_ind] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[enc_status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[user_checkout] [int] NULL,
[user_readyforprovider] [int] NULL,
[user_charted] [int] NULL,
[user_appt_created] [int] NULL,
[user_enc_created] [int] NULL,
[person_id] [uniqueidentifier] NULL,
[first_mon_date] [date] NULL,
[appt_datetime] [datetime] NULL,
[appt_w_pcp_status_txt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[nbr_pcp_appts] [int] NOT NULL,
[nbr_nonpcp_appt] [int] NOT NULL,
[nbr_appts] [int] NOT NULL,
[nbr_appt_notlinked_toperson] [int] NOT NULL,
[nbr_appt_kept_and_linked_enc] [int] NOT NULL,
[nbr_appt_kept_not_linked_enc] [int] NOT NULL,
[nbr_appt_future] [int] NOT NULL,
[nbr_appt_no_show] [int] NOT NULL,
[nbr_appt_future_no_patient] [int] NOT NULL,
[nbr_appt_no_show_no_patient] [int] NOT NULL,
[nbr_appt_cancelled] [int] NOT NULL,
[nbr_appt_deleted] [int] NOT NULL,
[nbr_appt_rescheduled] [int] NOT NULL,
[nbr_enc] [int] NOT NULL,
[nbr_bill_enc] [int] NOT NULL,
[nbr_enc_or_appt] [int] NOT NULL,
[nbr_non_bill_enc] [int] NOT NULL,
[nbr_bill_enc_with_an_appt] [int] NOT NULL,
[nbr_non_bill_enc_with_an_appt] [int] NOT NULL,
[nbr_bill_enc_with_an_appt_and_kept] [int] NOT NULL,
[nbr_non_bill_enc_with_an_appt_and_kept] [int] NOT NULL,
[days_to_appt] [int] NULL,
[appt_create_time] [datetime] NULL,
[cycle_min_kept_checkedout] [int] NULL,
[cycle_min_kept_readyforprovider] [int] NULL,
[cycle_min_kept_charted] [int] NULL,
[cycle_min_readyforprovider_checkout] [int] NULL,
[cycle_min_slottime_to_kept] [int] NULL,
[pay1_name] [varchar] (110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay2_name] [varchar] (110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay3_name] [varchar] (110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay1_finclass] [varchar] (110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay2_finclass] [varchar] (110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay3_finclass] [varchar] (110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ng_data] [int] NULL,
[enrollment_status] [smallint] NULL,
[enrollment_created_time] [date] NULL,
[email_address] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_modified_time] [date] NULL,
[enrollment_users_match] [int] NOT NULL,
[diagnosis_1] [varchar] (266) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diagnosis_2] [varchar] (266) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diagnosis_3] [varchar] (266) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
ALTER TABLE [dwh].[data_appointment] ADD 
CONSTRAINT [enc_appt_key_PK] PRIMARY KEY CLUSTERED  ([enc_appt_key]) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_person_mon_id1] ON [dwh].[data_appointment] ([per_mon_id]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_person_mon_x_first_mon_date1] ON [dwh].[data_appointment] ([per_mon_id], [first_mon_date]) ON [PRIMARY]
















GO
