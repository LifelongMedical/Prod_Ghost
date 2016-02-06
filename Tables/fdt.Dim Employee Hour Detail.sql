CREATE TABLE [fdt].[Dim Employee Hour Detail]
(
[employee_hours_comp_key] [bigint] NOT NULL,
[Hours Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hours Category from Timecard] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hours Category from Payroll] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Employee Hour Detail] ADD CONSTRAINT [employee_hours_comp_key_pk] PRIMARY KEY CLUSTERED  ([employee_hours_comp_key]) ON [PRIMARY]
GO
