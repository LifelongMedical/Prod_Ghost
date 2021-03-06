CREATE TABLE [fdt].[Dim CHCN Patient]
(
[chcn_key] [int] NOT NULL IDENTITY(1, 1),
[CHCN Member ID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[first_month_date] [date] NULL,
[Health Center Acronym] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Health Center Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Effective Date] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Termination Date] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HMO Patient Identification Number] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CHCN Benefit Option Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Member Last Name] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Member First Name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Member Date of Birth] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Member Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone Number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[4 Digit MediCal Id] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIN#] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CHCN Site Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CHCN Site Code Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HIC #] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MediCare A Effective Date] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MediCare B Effective Date] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CCS Case# and/or Dx Code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CCS Effective Date] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Other Coverage] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Health Families Copay Code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Aid Code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transaction Code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transaction Date] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Member Active] [int] NULL,
[Number NG] [int] NOT NULL,
[per_mon_id] [bigint] NULL,
[dd] [bigint] NULL,
[Address Full] [varchar] (86) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
ALTER TABLE [fdt].[Dim CHCN Patient] ADD 
CONSTRAINT [PK__Dim CHCN__2852397ADD5B1F85] PRIMARY KEY CLUSTERED  ([chcn_key]) ON [PRIMARY]


GO
