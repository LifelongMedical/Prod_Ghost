CREATE TABLE [fdt].[Fact Employee]
(
[employee_month_key] [int] NOT NULL IDENTITY(1, 1),
[employee_key] [int] NOT NULL,
[first_mon_date] [date] NULL,
[Nbr of Employees Active] [int] NOT NULL,
[Nbr of Employees Separated this Month] [int] NOT NULL,
[Nbr of Bad Hires] [int] NOT NULL,
[Months of Employment] [int] NULL,
[FTEs] [numeric] (4, 3) NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Employee] ADD CONSTRAINT [employee_month_key_pk4] PRIMARY KEY CLUSTERED  ([employee_month_key]) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Employee] ADD CONSTRAINT [FK_employee_month_key] FOREIGN KEY ([employee_month_key]) REFERENCES [fdt].[Dim Employee Historical] ([employee_month_key])
GO
ALTER TABLE [fdt].[Fact Employee] ADD CONSTRAINT [FK_first_mon_date2] FOREIGN KEY ([first_mon_date]) REFERENCES [fdt].[Dim Time] ([Key Date])
GO
