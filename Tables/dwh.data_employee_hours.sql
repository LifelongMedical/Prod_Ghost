CREATE TABLE [dwh].[data_employee_hours]
(
[employee_hours_key] [int] NOT NULL IDENTITY(1, 1),
[employee_key] [int] NULL,
[Pay Date] [date] NULL,
[status_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location_key] [int] NULL,
[site] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[provider_key] [int] NULL,
[status_ec_tc] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_ec_pr] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_rate] [float] NULL,
[Earnings Code Timecard] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Earnings Code Payroll] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rate] [float] NULL,
[Hours Timecard] [float] NULL,
[Hours Payroll] [float] NULL,
[Dollars] [float] NULL,
[Employee ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Worked Department] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[employee_hours_comp_key] [bigint] NULL
) ON [PRIMARY]
ALTER TABLE [dwh].[data_employee_hours] ADD 
CONSTRAINT [employee_hours_key_pk] PRIMARY KEY CLUSTERED  ([employee_hours_key]) ON [PRIMARY]
GO
