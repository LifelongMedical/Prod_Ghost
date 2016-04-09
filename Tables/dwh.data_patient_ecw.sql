CREATE TABLE [dwh].[data_patient_ecw]
(
[ecw_patient_key] [int] NOT NULL,
[patient_id] [int] NOT NULL,
[pcp_id] [int] NOT NULL,
[med_home_id] [numeric] (11, 0) NULL,
[patient_account_number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[last_name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ethnicity] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[med_rec_nbr] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ssn] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[home_phone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_phone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[address_line_1] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_line_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[state] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_of_birth] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expired_date] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[race] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[deceased] [int] NOT NULL,
[language] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sex] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[marital_status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[first_enc_date] [date] NULL
) ON [PRIMARY]
GO
