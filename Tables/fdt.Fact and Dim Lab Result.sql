CREATE TABLE [fdt].[Fact and Dim Lab Result]
(
[lab_res_key] [int] NOT NULL IDENTITY(1, 1),
[lab_ord_key] [int] NULL,
[per_mon_id] [int] NULL,
[Observation ID] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOINC Code] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order Value] [varchar] (608) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result Value] [varchar] (51) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Observation Date] [datetime] NULL,
[Lab Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result Deleted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Result Date] [datetime] NOT NULL,
[Lab Clinical Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result Comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HIV Positive] [int] NOT NULL,
[HIV Inconclusive] [int] NOT NULL,
[T-Cell Tests] [int] NOT NULL,
[CD4 Range] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[A1C Range] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pre-Diabetic] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
