CREATE TABLE [dwh].[data_ng_user_log]
(
[userLoginSigID] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[userLoginID] [int] NULL,
[userLoginDate] [datetime] NULL,
[UserValidLogInOut] [int] NOT NULL,
[UserLogoutDate] [datetime] NOT NULL,
[UserDate] [datetime] NULL,
[logoutTime] [datetime] NULL,
[logInTime] [datetime] NULL,
[sig_msg] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[userLogoutSigID] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sig_event_id] [uniqueidentifier] NOT NULL,
[user_key] [int] NULL,
[Checkin_Date] [date] NULL,
[cycle_min_kept_readyforprovider] [int] NULL,
[cycle_min_kept_checkedout] [int] NULL,
[cycle_min_kept_charted] [int] NULL,
[cycle_min_readyforprovider_checkout] [int] NULL,
[enc_id] [uniqueidentifier] NULL,
[enc_key] [int] NULL,
[user_readyforprovider] [int] NULL,
[user_checkout] [int] NULL,
[user_charted] [int] NULL,
[user_provider] [int] NULL,
[start_datetime] [datetime] NULL,
[end_datetime] [datetime] NULL
) ON [PRIMARY]
GO
