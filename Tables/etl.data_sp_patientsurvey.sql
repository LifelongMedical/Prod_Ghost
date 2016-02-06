CREATE TABLE [etl].[data_sp_patientsurvey]
(
[encounter_num] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[confirm_encounter_num] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[survey_q1] [decimal] (18, 0) NULL,
[survey_q2] [decimal] (18, 0) NULL,
[survey_q3] [decimal] (18, 0) NULL,
[survey_q4] [decimal] (18, 0) NULL,
[survey_q5] [decimal] (18, 0) NULL,
[survey_q6] [decimal] (18, 0) NULL,
[survey_q7] [decimal] (18, 0) NULL,
[comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created] [datetime] NULL,
[Id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
