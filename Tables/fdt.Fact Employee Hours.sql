CREATE TABLE [fdt].[Fact Employee Hours]
(
[employee_hours_key] [int] NOT NULL IDENTITY(1, 1),
[employee_hours_comp_key] [bigint] NULL,
[employee_key] [int] NOT NULL,
[employee_month_key] [int] NOT NULL,
[location_key] [int] NULL,
[Pay Date] [date] NULL,
[Hours Timecard] [float] NULL,
[Hours Payroll] [float] NULL,
[Dollars] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Employee Hours] ADD CONSTRAINT [employee_hours_key_pk] PRIMARY KEY CLUSTERED  ([employee_hours_key]) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Employee Hours] ADD CONSTRAINT [FK_employee_month_key3] FOREIGN KEY ([employee_month_key]) REFERENCES [fdt].[Dim Employee Historical] ([employee_month_key])
GO
ALTER TABLE [fdt].[Fact Employee Hours] ADD CONSTRAINT [FK_pay_date1] FOREIGN KEY ([Pay Date]) REFERENCES [fdt].[Dim Time] ([Key Date])
GO
