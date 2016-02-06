CREATE TABLE [dwh].[data_person_dp_month]
(
[per_mon_id] [int] NOT NULL,
[person_id] [uniqueidentifier] NOT NULL,
[first_mon_date] [date] NULL,
[mh_cur_key] [int] NULL,
[mh_hx_key] [int] NULL,
[pcp_cur_key] [int] NULL,
[pcp_hx_key] [int] NULL,
[status_cur_key] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_hx_key] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cr_first_office_enc_date] [date] NULL,
[expired_date] [date] NULL,
[First_enc_age_months] [int] NULL,
[nbr_new_pt] [int] NOT NULL,
[nbr_pt_seen_office_ever] [int] NOT NULL,
[nbr_pt_deceased] [int] NOT NULL,
[nbr_pt_deceased_this_month] [int] NOT NULL,
[patient_vintage] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[age_hx] [int] NULL,
[age_cur] [int] NULL,
[dob] [date] NULL,
[full_name] [varchar] (147) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[last_name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[middle_name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_line_1] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_line_2] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[home_phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sex] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[marital_status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[race] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[language] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[med_rec_nbr] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nbr_pt_act_3m] [int] NULL,
[nbr_pt_act_6m] [int] NULL,
[nbr_pt_act_12m] [int] NULL,
[nbr_pt_act_18m] [int] NULL,
[nbr_pt_act_24m] [int] NULL,
[nbr_pt_inact_3m] [int] NOT NULL,
[nbr_pt_inact_6m] [int] NOT NULL,
[nbr_pt_inact_12m] [int] NOT NULL,
[nbr_pt_inact_18m] [int] NOT NULL,
[nbr_pt_inact_24m] [int] NOT NULL,
[nbr_pt_lost_3m] [int] NOT NULL,
[nbr_pt_lost_6m] [int] NOT NULL,
[nbr_pt_lost_12m] [int] NOT NULL,
[nbr_pt_lost_18m] [int] NOT NULL,
[nbr_pt_lost_24m] [int] NOT NULL,
[nbr_pt_mh_change] [int] NOT NULL,
[nbr_pt_pcp_change] [int] NOT NULL,
[nbr_pt_never_active] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dwh].[data_person_dp_month] ADD CONSTRAINT [per_mon_id_pk32] PRIMARY KEY CLUSTERED  ([per_mon_id]) ON [PRIMARY]
GO
