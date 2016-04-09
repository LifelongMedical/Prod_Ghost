CREATE TABLE [fdt].[Dim Provider ECW]
(
[ecw_prov_key] [int] NOT NULL,
[location_key] [int] NULL,
[employee_key] [int] NOT NULL,
[provider_id] [int] NOT NULL,
[location_id] [numeric] (10, 0) NOT NULL,
[Provider Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First Name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Specialty] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[providerCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Provider E-Mail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upaddress] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Location] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[facility_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Location Nickname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deleted] [tinyint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Provider ECW] ADD CONSTRAINT [PK__Dim Prov__A71CEA9103F4EE1C] PRIMARY KEY CLUSTERED  ([ecw_prov_key]) ON [PRIMARY]
GO
