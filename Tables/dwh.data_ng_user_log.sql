CREATE TABLE [dwh].[data_ng_user_log]
(
[sig_event_id] [uniqueidentifier] NOT NULL,
[Log Valid] [int] NOT NULL,
[user_key] [int] NULL,
[provider_id] [uniqueidentifier] NULL,
[enc_id] [uniqueidentifier] NULL,
[Login Datetime] [datetime] NULL,
[Logout Datetime] [datetime] NOT NULL,
[Log Minute] [int] NULL,
[Log Hour] [int] NULL,
[enc_count] [bigint] NULL,
[Log Case] [int] NULL,
[Login Time] [time] NULL,
[Start Time] [time] NULL,
[End Time] [time] NULL,
[Logout Time] [time] NULL,
[row_number_enc_id] [bigint] NULL,
[Max Hour] [int] NULL,
[Max Minutes] [int] NULL,
[Sum Hour] [int] NULL,
[Sum Minutes] [int] NULL,
[enc_appt_key] [int] NULL,
[provider_key] [int] NULL
) ON [PRIMARY]
GO
