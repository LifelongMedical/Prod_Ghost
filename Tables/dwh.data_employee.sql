CREATE TABLE [dwh].[data_employee]
(
[employee_key] [int] NOT NULL IDENTITY(1, 1),
[cn_account_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_account_code_sub] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_site] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_fund] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_dir_indir] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_category] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_proj_grant] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age_cur] [int] NULL,
[Company Code (Employee Custom Fields)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Home Cost Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Home Department] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business Unit Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business Unit Desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company Code (Payroll Information)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payroll Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[File Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payroll First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payroll Last Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Race] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Allocated Department Percent] [float] NULL,
[Data Control] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015 Flu Vaccine Declination Form] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015 Flu Vaccine Rec'd] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015 TB Test ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date of Birth] [datetime] NULL,
[Job Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip/Postal Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager Last Name First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager Last Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rate Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rate Amount] [money] NULL,
[Annual Salary] [float] NULL,
[Hire Date] [datetime] NULL,
[Termination Date] [datetime] NULL,
[Termination Reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Termination Reason Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flu_vac_2015_decline] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[flu_vac_2015_received] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tb_test_completed] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[rounded_rate] [int] NULL,
[rounded_salary] [int] NULL,
[rate_cur] [float] NULL,
[rate_cur_range] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rate_cur_range_sort] [int] NULL,
[salary_cur_range] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salary_cur_range_sort] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dwh].[data_employee] ADD CONSTRAINT [employee_key_pk] PRIMARY KEY CLUSTERED  ([employee_key]) ON [PRIMARY]
GO
