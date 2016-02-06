CREATE TABLE [fdt].[Dim PHI Patient]
(
[per_mon_id] [int] NOT NULL,
[first_mon_date] [date] NULL,
[mh_cur_key] [int] NULL,
[mh_hx_key] [int] NULL,
[pcp_cur_key] [int] NULL,
[pcp_hx_key] [int] NULL,
[Date of Death] [date] NULL,
[Patient Status Historical] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patient Status Current] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Time as Member] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[membership_time_sort] [int] NULL,
[Is Patient New] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is Patient Established] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is Patient Alive] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is Patient Deceased this Month] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Membership Month] [int] NULL,
[Age Historical] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Age_Hx_sort] [int] NOT NULL,
[Age Current] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[age_cur_sort] [int] NOT NULL,
[Patient Vintage Month] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patient Vintage Month Range] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Patient Vintage Month sort] [int] NOT NULL,
[Full Name] [varchar] (147) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First Name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Last Name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Middle Name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address 1] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Adress 2] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Home Phone Number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [date] NULL,
[Alternate Phone Number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Marital Status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Race] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Medical Record Number] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim PHI Patient] ADD CONSTRAINT [per_mon_id_pk5] PRIMARY KEY CLUSTERED  ([per_mon_id]) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim PHI Patient] ADD CONSTRAINT [FK_mh_cur_key6] FOREIGN KEY ([mh_cur_key]) REFERENCES [fdt].[Dim Medical Home Current] ([location_key])
GO
ALTER TABLE [fdt].[Dim PHI Patient] ADD CONSTRAINT [FK_mh_hx_key7] FOREIGN KEY ([mh_hx_key]) REFERENCES [fdt].[Dim Medical Home Historical] ([location_key])
GO
ALTER TABLE [fdt].[Dim PHI Patient] ADD CONSTRAINT [FK_pcp_cur_key8] FOREIGN KEY ([pcp_cur_key]) REFERENCES [fdt].[Dim PCP Current] ([user_key])
GO
ALTER TABLE [fdt].[Dim PHI Patient] ADD CONSTRAINT [FK_pcp_hx_key9] FOREIGN KEY ([pcp_hx_key]) REFERENCES [fdt].[Dim PCP Historical] ([user_key])
GO
