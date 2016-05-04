CREATE TABLE [fdt].[Fact and Dim PAQ]
(
[paq_key] [int] NOT NULL IDENTITY(1, 1),
[PAQ Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[provider_key] [int] NULL,
[per_mon_id] [int] NULL,
[enc_appt_key] [int] NULL,
[PAQ_signoff_user_key] [int] NULL,
[PAQ Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAQ_provider_key] [int] NULL,
[PAQ_reassigned_provider_key] [int] NULL,
[Signoff Action] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Signoff Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Signoff Date] [date] NULL,
[PAQ Creation Date] [datetime] NULL,
[Key Date] [date] NULL,
[Hours PAQ Action] [int] NULL,
[Hours to PAQ Action Range] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hours Sort] [int] NULL,
[PAQ Days to Action] [int] NULL,
[Days to PAQ Action Range] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Days Sort] [int] NULL,
[Nbr of Active PAQ] [int] NOT NULL,
[Lab Flag Description] [varchar] (46) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lab Flag] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nbr of PAQ Signedoff by Provider] [int] NOT NULL,
[Nbr of PAQ Rejected] [int] NOT NULL,
[Nbr of PAQ Reassigned] [int] NOT NULL,
[Nbr of PAQ by Covering Provider] [int] NOT NULL,
[Nbr of PAQ linked to Enc] [int] NOT NULL,
[Nbr of PAQ Reassigned to Diff Provider] [int] NOT NULL
) ON [PRIMARY]
ALTER TABLE [fdt].[Fact and Dim PAQ] ADD 
CONSTRAINT [PK__Fact and__45260B6C0DB33533] PRIMARY KEY CLUSTERED  ([paq_key]) ON [PRIMARY]
GO
