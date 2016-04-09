CREATE TABLE [fdt].[Fact and Dim Vital Signs]
(
[vital_signs_key] [int] NOT NULL IDENTITY(1, 1),
[create_timestamp] [datetime] NOT NULL,
[BP_date] [date] NULL,
[Type] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [numeric] (16, 2) NULL,
[Range] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Range_Sort] [int] NULL,
[Recency] [bigint] NULL,
[per_mon_id] [int] NULL,
[first_mon_date] [date] NULL,
[enc_appt_key] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact and Dim Vital Signs] ADD CONSTRAINT [PK__Fact and__6688BB36A9AF11E5] PRIMARY KEY CLUSTERED  ([vital_signs_key]) ON [PRIMARY]
GO
