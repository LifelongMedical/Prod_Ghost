CREATE TABLE [fdt].[Fact Encounter]
(
[enc_key] [int] NOT NULL IDENTITY(1, 1),
[location_key] [int] NULL,
[enc_bill_date] [date] NULL,
[provider_key] [int] NULL,
[per_mon_id] [int] NULL,
[enc_comp_key] [bigint] NULL,
[enc_creator_key] [int] NULL,
[Number of Billable Encounters] [int] NOT NULL,
[Number of Qualified Encounters] [int] NOT NULL,
[Number of Encounters Any Type] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Encounter] ADD CONSTRAINT [enc_key_pk1] PRIMARY KEY CLUSTERED  ([enc_key]) ON [PRIMARY]
GO
