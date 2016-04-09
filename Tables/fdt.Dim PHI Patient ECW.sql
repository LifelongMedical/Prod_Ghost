CREATE TABLE [fdt].[Dim PHI Patient ECW]
(
[ecw_patient_key] [int] NOT NULL,
[pcp_key] [int] NULL,
[location_key] [int] NULL,
[Patient_Account_Number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Last Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First Name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Medical Record Number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address 1] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address 2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User Birth Date] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birth Date] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Race] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Patient is Deceased] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim PHI Patient ECW] ADD CONSTRAINT [PK__Dim PHI __83D72B915FA129C2] PRIMARY KEY CLUSTERED  ([ecw_patient_key]) ON [PRIMARY]
GO
