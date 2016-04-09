CREATE TABLE [dwh].[data_employee_v2]
(
[employee_key] [int] NOT NULL IDENTITY(1, 1),
[File Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hire Date] [date] NULL,
[Termination Date] [date] NULL,
[Termination Reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Termination Reason Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Job Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payroll First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Home Cost Number - Check] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payroll Last Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payroll Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birth Date] [date] NULL,
[Gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEO Ethnic Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip/Postal Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager Last Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Standard Hours] [decimal] (38, 6) NULL,
[Hourly Rate ADP 1 (Direct hourly)] [decimal] (38, 4) NULL,
[Hourly Rate 2 ADP (Direct-biweekly salary)] [decimal] (38, 4) NULL,
[Hourly Rate ADP (Based on ADP Salary or Hourly)] [decimal] (38, 4) NULL,
[Annual Salary ADP not annualized] [decimal] (38, 4) NULL,
[Annual Salary ADP annualized] [decimal] (38, 4) NULL,
[UDS Table 5 Staffing Category ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 5 Line Number ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 8 Costs Category ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 8 Line Number ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_account_code_cur] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_account_code_sub_cur] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_site_cur] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_fund_cur] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_dir_indir_cur] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_category_cur] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_proj_grant_cur] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data Control] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rate_range_cur] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rate_range_cur_sort] [int] NULL,
[rate_direct_range_cur] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rate_direct_range_cur_sort] [int] NULL,
[salary_annualized_range_cur] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salary_annualized_range_cur_sort] [int] NULL,
[salary_not_annualized_range_cur] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salary_not_annualized_range_cur_sort] [int] NULL,
[Age_cur] [int] NULL,
[months_since_start_cur] [int] NULL,
[FTE based on Data Control] [numeric] (4, 3) NULL,
[FTE_Range_Cur] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FTE_Range_Cur_Sort] [int] NOT NULL,
[Age_range_cur] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[age_range_cur_sort] [int] NOT NULL,
[Months Since Hire Range Cur] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[months_since_hire_cur_sort] [int] NULL,
[domain] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
