CREATE TABLE [fdt].[Fact Patient]
(
[per_mon_id] [int] NOT NULL,
[first_mon_date] [date] NULL,
[mh_cur_key] [int] NULL,
[mh_hx_key] [int] NULL,
[pcp_cur_key] [int] NULL,
[pcp_hx_key] [int] NULL,
[med_rec_nbr] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number of New Patients this Month] [int] NOT NULL,
[Number of Patient Members] [int] NOT NULL,
[Number of Patients Deceased] [int] NOT NULL,
[Number of Patients Deceased this Month] [int] NOT NULL,
[Number Active Pt Past 3 Months] [int] NULL,
[Number Active Pt Past 6 Months] [int] NULL,
[Number Active Pt Past 12 Months] [int] NULL,
[Number Active Pt Past 18 Months] [int] NULL,
[Number Active Pt Past 24 Months] [int] NULL,
[Number Inactive Pt Past 3 Months] [int] NOT NULL,
[Number Inactive Pt Past 6 Months] [int] NOT NULL,
[Number Inactive Pt Past 12 Months] [int] NOT NULL,
[Number Inactive Pt Past 18 Months] [int] NOT NULL,
[Number Inactive Pt Past 24 Months] [int] NOT NULL,
[Number Pt Lost 3 Months] [int] NOT NULL,
[Number Pt Lost 6 Months] [int] NOT NULL,
[Number Pt Lost 12 Months] [int] NOT NULL,
[Number Pt Lost 18 Months] [int] NOT NULL,
[Number Pt Lost 24 Months] [int] NOT NULL,
[Number of Patients with Medical Home Change] [int] NOT NULL,
[Number of Patients with PCP Change] [int] NOT NULL,
[Number of Patients Never Active] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Patient] ADD CONSTRAINT [per_mon_id_pk2] PRIMARY KEY CLUSTERED  ([per_mon_id]) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Patient] ADD CONSTRAINT [FK_first_mon_date] FOREIGN KEY ([first_mon_date]) REFERENCES [fdt].[Dim Time] ([Key Date])
GO
ALTER TABLE [fdt].[Fact Patient] ADD CONSTRAINT [FK_per_mon_id3] FOREIGN KEY ([per_mon_id]) REFERENCES [fdt].[Dim PHI Patient] ([per_mon_id])
GO
