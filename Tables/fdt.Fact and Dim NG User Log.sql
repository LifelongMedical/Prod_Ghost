CREATE TABLE [fdt].[Fact and Dim NG User Log]
(
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
[Max Hour] [int] NULL,
[Max Minutes] [int] NULL,
[Sum Hour] [int] NULL,
[Sum Minutes] [int] NULL,
[enc_appt_key] [int] NULL,
[provider_key] [int] NULL
) ON [PRIMARY]
GO
