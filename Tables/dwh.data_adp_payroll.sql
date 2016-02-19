CREATE TABLE [dwh].[data_adp_payroll]
(
[Period Beginning Date] [date] NULL,
[Period End Date - Check] [date] NULL,
[Pay Date] [date] NULL,
[File Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Home Cost Number - Check] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Home Cost Number Desc - Check] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_account_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_account_code_sub] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_site] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_fund] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_dir_indir] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_category] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cn_proj_grant] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cost Number Worked In] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cost Number Worked In Desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hire Date] [date] NULL,
[Termination Date] [date] NULL,
[Termination Reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Termination Reason Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data Control] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Job Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 5 Staffing Category ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 5 Line Number ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 8 Costs Category ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Table 8 Line Number ] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UDS Person 2015 Count] [int] NOT NULL,
[UDS Person 2014 Count] [int] NOT NULL,
[UDS Person 2013 Count] [int] NOT NULL,
[UDS Person 2015 Tenure] [decimal] (38, 6) NULL,
[UDS Person 2014 Tenure] [decimal] (38, 6) NULL,
[Payroll First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payroll Last Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payroll Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birth Date] [date] NULL,
[Age_hx] [int] NULL,
[Age_cur] [int] NULL,
[Gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEO Ethnic Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip/Postal Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager Last Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Standard Hours] [decimal] (38, 4) NULL,
[Hourly Rate ADP 1 (Direct Hourly)] [decimal] (38, 4) NULL,
[Hourly Rate 2 ADP (Direct-biweekly salary)] [decimal] (38, 4) NULL,
[Hourly Rate ADP (Based on ADP Salary or Hourly)] [decimal] (38, 6) NULL,
[Hourly Rate Calculated based on Reg Earnings] [decimal] (38, 6) NULL,
[Hourly Rate Calculated based on Total Earnings] [decimal] (38, 6) NULL,
[Annual Salary ADP not annualized] [decimal] (38, 4) NULL,
[Annual Salary ADP annualized] [decimal] (38, 4) NULL,
[Calculated Salary (Reg Earnings) Annualized] [decimal] (38, 6) NULL,
[Total All Hours] [decimal] (38, 4) NULL,
[Regular Hours with s/v/f/h] [decimal] (38, 4) NULL,
[Regular Hours] [decimal] (38, 4) NULL,
[All Other Coded Hours] [decimal] (38, 4) NULL,
[Overtime Hours] [decimal] (38, 4) NULL,
[Regular Earnings] [decimal] (38, 4) NULL,
[Other Earnings] [decimal] (38, 4) NULL,
[Overtime Earnings] [decimal] (38, 4) NULL,
[Net Pay] [decimal] (38, 4) NULL,
[Gross Pay] [decimal] (38, 4) NULL,
[_Hours Coded1] [decimal] (38, 4) NULL,
[_Hours Coded2] [decimal] (38, 4) NULL,
[_Hours Coded3] [decimal] (38, 4) NULL,
[_Hours Coded4] [decimal] (38, 4) NULL,
[_Hours Coded5] [decimal] (38, 4) NULL,
[_Hours Coded6] [decimal] (38, 4) NULL,
[_Hours Coded7] [decimal] (38, 4) NULL,
[_Hours Coded8] [decimal] (38, 4) NULL,
[_Hours Coded9] [decimal] (38, 4) NULL,
[_Hours Coded10] [decimal] (38, 4) NULL,
[_Hours Coded11] [decimal] (38, 4) NULL,
[_Hours Coded12] [decimal] (38, 4) NULL,
[_Hours Coded13] [decimal] (38, 4) NULL,
[_Hours Coded14] [decimal] (38, 4) NULL,
[_Hours Coded15] [decimal] (38, 4) NULL,
[_Hours Coded16] [decimal] (38, 4) NULL,
[_Hours Coded17] [decimal] (38, 4) NULL,
[_Hours Coded18] [decimal] (38, 4) NULL,
[_Hours Coded19] [decimal] (38, 4) NULL,
[_Hours Coded20] [decimal] (38, 4) NULL,
[_Hours Coded21] [decimal] (38, 4) NULL,
[_Hours Coded22] [decimal] (38, 4) NULL,
[_Hours Coded23] [decimal] (38, 4) NULL,
[_Hours Coded24] [decimal] (38, 4) NULL,
[_Hours Coded25] [decimal] (38, 4) NULL,
[_Hours Coded26] [decimal] (38, 4) NULL,
[_Hours Coded27] [decimal] (38, 4) NULL,
[_Hours Coded28] [decimal] (38, 4) NULL,
[_Hours Coded29] [decimal] (38, 4) NULL,
[_Hours Coded30] [decimal] (38, 4) NULL,
[_Hours Coded31] [decimal] (38, 4) NULL,
[_Hours Coded32] [decimal] (38, 4) NULL,
[_Hours Coded33] [decimal] (38, 4) NULL,
[_Earnings Coded1] [decimal] (38, 4) NULL,
[_Earnings Coded2] [decimal] (38, 4) NULL,
[_Earnings Coded3] [decimal] (38, 4) NULL,
[_Earnings Coded4] [decimal] (38, 4) NULL,
[_Earnings Coded5] [decimal] (38, 4) NULL,
[_Earnings Coded6] [decimal] (38, 4) NULL,
[_Earnings Coded7] [decimal] (38, 4) NULL,
[_Earnings Coded8] [decimal] (38, 4) NULL,
[_Earnings Coded9] [decimal] (38, 4) NULL,
[_Earnings Coded10] [decimal] (38, 4) NULL,
[_Earnings Coded11] [decimal] (38, 4) NULL,
[_Earnings Coded12] [decimal] (38, 4) NULL,
[_Earnings Coded13] [decimal] (38, 4) NULL,
[_Earnings Coded14] [decimal] (38, 4) NULL,
[_Earnings Coded15] [decimal] (38, 4) NULL,
[_Earnings Coded16] [decimal] (38, 4) NULL,
[_Earnings Coded17] [decimal] (38, 4) NULL,
[_Earnings Coded18] [decimal] (38, 4) NULL,
[_Earnings Coded19] [decimal] (38, 4) NULL,
[_Earnings Coded20] [decimal] (38, 4) NULL,
[_Earnings Coded21] [decimal] (38, 4) NULL,
[_Earnings Coded22] [decimal] (38, 4) NULL,
[_Earnings Coded23] [decimal] (38, 4) NULL,
[_Earnings Coded24] [decimal] (38, 4) NULL,
[_Earnings Coded25] [decimal] (38, 4) NULL,
[_Earnings Coded26] [decimal] (38, 4) NULL,
[_Earnings Coded27] [decimal] (38, 4) NULL,
[_Earnings Coded28] [decimal] (38, 4) NULL,
[_Earnings Coded29] [decimal] (38, 4) NULL,
[_Earnings Coded30] [decimal] (38, 4) NULL,
[_Earnings Coded31] [decimal] (38, 4) NULL,
[_Earnings Coded32] [decimal] (38, 4) NULL,
[_Earnings Coded33] [decimal] (38, 4) NULL,
[_Earnings Coded34] [decimal] (38, 4) NULL,
[_Earnings Coded35] [decimal] (38, 4) NULL,
[_Earnings Coded36] [decimal] (38, 4) NULL,
[_Earnings Coded37] [decimal] (38, 4) NULL,
[_Earnings Coded38] [decimal] (38, 4) NULL,
[_Earnings Coded39] [decimal] (38, 4) NULL,
[_Earnings Coded40] [decimal] (38, 4) NULL,
[_Earnings Coded41] [decimal] (38, 4) NULL,
[_Earnings Coded42] [decimal] (38, 4) NULL,
[_Earnings Coded43] [decimal] (38, 4) NULL,
[_Earnings Coded44] [decimal] (38, 4) NULL,
[_Earnings Coded45] [decimal] (38, 4) NULL,
[_Earnings Coded46] [decimal] (38, 4) NULL,
[_Earnings Coded47] [decimal] (38, 4) NULL,
[_Earnings Coded48] [decimal] (38, 4) NULL,
[_Earnings Coded49] [decimal] (38, 4) NULL,
[_Earnings Coded50] [decimal] (38, 4) NULL,
[_Earnings Coded51] [decimal] (38, 4) NULL,
[_Earnings Coded52] [decimal] (38, 4) NULL,
[_Earnings Coded53] [decimal] (38, 4) NULL,
[_Earnings Coded54] [decimal] (38, 4) NULL,
[_Earnings Coded55] [decimal] (38, 4) NULL,
[_Earnings Coded56] [decimal] (38, 4) NULL,
[_Earnings Coded57] [decimal] (38, 4) NULL
) ON [PRIMARY]
GO
