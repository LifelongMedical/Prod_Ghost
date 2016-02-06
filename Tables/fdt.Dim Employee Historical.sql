CREATE TABLE [fdt].[Dim Employee Historical]
(
[employee_key] [int] NOT NULL,
[employee_month_key] [int] NOT NULL IDENTITY(1, 1),
[Age Historical] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[age_hx_sort] [int] NOT NULL,
[Time as Employee] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[employee_time_sort] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Employee Historical] ADD CONSTRAINT [employee_month_key_pk10] PRIMARY KEY CLUSTERED  ([employee_month_key]) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Employee Historical] ADD CONSTRAINT [FK_employee_key71] FOREIGN KEY ([employee_key]) REFERENCES [fdt].[Dim Employee] ([employee_key])
GO
