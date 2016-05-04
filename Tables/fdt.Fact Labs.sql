CREATE TABLE [fdt].[Fact Labs]
(
[lab_res_key] [int] NOT NULL IDENTITY(1, 1),
[enc_appt_key] [int] NULL,
[per_mon_id] [int] NULL,
[person_key] [int] NULL,
[ordering_prov_key] [int] NULL,
[create_user_key] [int] NULL,
[mod_user_key] [int] NULL,
[Order Status] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NG Order Status] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order Date] [datetime] NOT NULL,
[NG Completed] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Recency] [bigint] NULL,
[value_type] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[obs_id] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOINC] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result Value] [varchar] (608) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Numeric Value] [decimal] (10, 2) NULL,
[Units of Measurement] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result Date] [datetime] NULL,
[Clinical Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full Value] [varchar] (51) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result Dx] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lab Type] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Result Range] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Completed Orders] [int] NOT NULL,
[Total Orders] [int] NOT NULL,
[order_created_date] [date] NULL,
[result_created_date] [date] NULL
) ON [PRIMARY]
GO