CREATE TABLE [fdt].[Fact and Dim Vital Signs]
(
[vital_signs_key] [int] NOT NULL IDENTITY(1, 1),
[create_timestamp] [date] NULL,
[BP_date] [date] NULL,
[Type] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [numeric] (18, 0) NULL,
[Range] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Range_Sort] [int] NULL,
[Recency] [int] NOT NULL,
[person_key] [int] NULL,
[per_mon_id] [int] NULL,
[first_mon_date] [date] NULL,
[enc_appt_key] [int] NULL,
[Datetime of Measurement] [datetime] NULL,
[Date of Measurement] [date] NULL,
[Recency in a Day] [int] NOT NULL,
[Recency All Time] [int] NOT NULL
) ON [PRIMARY]
ALTER TABLE [fdt].[Fact and Dim Vital Signs] ADD 
CONSTRAINT [PK__Fact and__6688BB36B1E43FF7] PRIMARY KEY CLUSTERED  ([vital_signs_key]) ON [PRIMARY]


GO
