CREATE TABLE [dwh].[data_status]
(
[Checkin_Date] [date] NULL,
[cycle_min_kept_readyforprovider] [int] NULL,
[cycle_min_kept_checkedout] [int] NULL,
[cycle_min_kept_charted] [int] NULL,
[cycle_min_readyforprovider_checkout] [int] NULL,
[enc_id] [uniqueidentifier] NOT NULL,
[enc_key] [int] NOT NULL,
[user_readyforprovider] [int] NULL,
[user_checkout] [int] NULL,
[user_charted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dwh].[data_status] ADD CONSTRAINT [enc_key_pk20] PRIMARY KEY CLUSTERED  ([enc_key]) ON [PRIMARY]
GO
