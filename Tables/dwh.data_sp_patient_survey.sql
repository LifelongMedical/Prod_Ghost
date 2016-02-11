CREATE TABLE [dwh].[data_sp_patient_survey]
(
[survey_key] [int] NOT NULL IDENTITY(1, 1),
[encounter_num] [numeric] (18, 0) NULL,
[enc_appt_key] [int] NULL,
[survey_q1] [numeric] (18, 0) NULL,
[survey_q2] [numeric] (18, 0) NULL,
[survey_q3] [numeric] (18, 0) NULL,
[survey_q4] [numeric] (18, 0) NULL,
[survey_q5] [numeric] (18, 0) NULL,
[survey_q6] [numeric] (18, 0) NULL,
[survey_q7] [numeric] (18, 0) NULL,
[comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
