CREATE TABLE [fdt].[Fact and Dim PAQ]
(
[paq_key] [int] NOT NULL IDENTITY(1, 1),
[item_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[item_id] [uniqueidentifier] NOT NULL,
[provider_key] [int] NULL,
[per_mon_id] [int] NULL,
[enc_appt_key] [int] NULL,
[user_key] [int] NULL,
[item_name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_by] [int] NOT NULL,
[modified_by] [int] NOT NULL,
[signoff_user_id] [int] NULL,
[signoff_action] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[signoff_desc] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reassigned_provider_id] [uniqueidentifier] NULL,
[modify_timestamp] [datetime] NULL,
[signoffdate] [date] NULL,
[signoff_timestamp] [date] NULL,
[Item Creation Date] [datetime] NULL,
[Hour Range] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hour_Sort] [int] NULL,
[Day Range] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Day_Sort] [int] NULL,
[active] [int] NOT NULL,
[nbr_PAQ_by_Provider] [int] NOT NULL,
[nbr_PAQ_Rejected] [int] NOT NULL,
[nbr_PAQ_Reassigned] [int] NOT NULL,
[nbr_PAQ_by_Covering_Provider] [int] NOT NULL,
[nbr_Realted_to_encounter_flg] [int] NOT NULL,
[nbr_PAQ_Reassigned_to_dif_Provider_flg] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact and Dim PAQ] ADD CONSTRAINT [PK__Fact and__45260B6C32A01751] PRIMARY KEY CLUSTERED  ([paq_key]) ON [PRIMARY]
GO
