CREATE TABLE [fdt].[Bridge Labs]
(
[lab_res_key] [int] NOT NULL IDENTITY(1, 1),
[per_mon_id] [int] NULL,
[person_key] [int] NULL,
[order_date] [datetime] NOT NULL,
[result_date] [datetime] NULL
) ON [PRIMARY]
GO
