CREATE TABLE [fdt].[Dim Employee Cur]
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
[Name First] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name Last] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name Full] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birth Date] [date] NULL,
[Gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEO Ethnic Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip/Postal Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Domain Login] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Work email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager Last Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Standard Hours] [decimal] (38, 6) NULL,
[Rate Hourly Direct Cur] [decimal] (38, 4) NULL,
[Rate Hourly Direct Range] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rate_direct_range_cur_sort] [int] NULL,
[Rate Hourly Cur] [decimal] (38, 4) NULL,
[Rate Hourly Range Cur] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rate_range_cur_sort] [int] NULL,
[Hourly Rate 2 ADP (Direct-biweekly salary)] [decimal] (38, 4) NULL,
[Hourly Rate ADP (Based on ADP Salary or Hourly)] [decimal] (38, 4) NULL,
[Salary Actual Cur] [decimal] (38, 4) NULL,
[Salary Annualized Cur] [decimal] (38, 4) NULL,
[UDS Table 5 Staffing Category ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 5 Line Number ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 8 Costs Category ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 8 Line Number ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cost Number- Home] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account Cur] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account Sub-code Cur] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Site Cur] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fund Cur] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Direct or Indirect Cur] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category Cur] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Grant Cur] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data Control] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rate Range Cur] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salary Annualized Range Cur] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salary_annualized_range_cur_sort] [int] NULL,
[Salary Not Annualized Range Cur] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salary_not_annualized_range_cur_sort] [int] NULL,
[Age Cur] [int] NULL,
[Months Since Hire Cur] [int] NULL,
[FTE Cur] [numeric] (4, 3) NULL,
[FTE Range Cur ] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FTE_Range_Cur_Sort] [int] NOT NULL,
[Age Range Cur] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[age_range_cur_sort] [int] NOT NULL,
[Months Since Hire Range Cur] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[months_since_hire_cur_sort] [int] NULL
) ON [PRIMARY]
GO