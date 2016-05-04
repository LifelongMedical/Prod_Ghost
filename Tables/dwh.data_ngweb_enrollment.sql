CREATE TABLE [dwh].[data_ngweb_enrollment]
(
[enc_id] [uniqueidentifier] NULL,
[enc_created_by] [int] NULL,
[enc_create_timestamp] [datetime] NULL,
[enrollment_status] [smallint] NOT NULL,
[enrollment_created_time] [date] NULL,
[enroll_modify_timestamp] [datetime] NOT NULL,
[enrollment_created_by] [int] NOT NULL,
[email_address] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_modified_time] [date] NULL,
[email_modified_by] [int] NULL,
[email_create_timestamp] [datetime] NULL
) ON [PRIMARY]
GO
