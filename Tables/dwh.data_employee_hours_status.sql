CREATE TABLE [dwh].[data_employee_hours_status]
(
[employee_hours_comp_key] [bigint] NOT NULL,
[status_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_ec_tc] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_ec_pr] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_rate] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dwh].[data_employee_hours_status] ADD CONSTRAINT [employee_hours_comp_key_pk] PRIMARY KEY CLUSTERED  ([employee_hours_comp_key]) ON [PRIMARY]
GO
