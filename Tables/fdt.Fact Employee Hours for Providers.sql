CREATE TABLE [fdt].[Fact Employee Hours for Providers]
(
[employee_hours_key] [int] NOT NULL IDENTITY(1, 1),
[employee_hours_comp_key] [bigint] NULL,
[provider_key] [int] NULL,
[employee_key] [int] NULL,
[Site] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location_key] [int] NULL,
[Pay Date] [date] NULL,
[Hours Timecard] [float] NULL,
[Hours Payroll] [float] NULL,
[Dollars] [float] NULL
) ON [PRIMARY]
ALTER TABLE [fdt].[Fact Employee Hours for Providers] ADD 
CONSTRAINT [employee_hours_key_pk3] PRIMARY KEY CLUSTERED  ([employee_hours_key]) ON [PRIMARY]
GO
