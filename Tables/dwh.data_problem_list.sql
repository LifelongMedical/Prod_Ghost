CREATE TABLE [dwh].[data_problem_list]
(
[prob_key] [int] NOT NULL IDENTITY(1, 1),
[Dx_key] [int] NULL,
[enc_id] [uniqueidentifier] NULL,
[per_mon_id] [int] NULL,
[enc_appt_key] [int] NULL,
[eff_dt] [datetime] NULL,
[thru_dt] [datetime] NULL,
[diagnosis_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[icd9_description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_by] [int] NOT NULL,
[provider_id] [uniqueidentifier] NULL,
[diabetes_flag] [int] NOT NULL,
[hypertension_flag] [int] NOT NULL,
[hiv_flag] [int] NOT NULL,
[chronic_ind] [int] NULL,
[dx_status] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
