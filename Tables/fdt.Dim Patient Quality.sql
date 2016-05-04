CREATE TABLE [fdt].[Dim Patient Quality]
(
[per_mon_id] [int] NOT NULL,
[first_mon_date] [date] NULL,
[mh_cur_key] [int] NULL,
[pcp_cur_key] [int] NULL,
[Patient Status Cur] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Membership Month Cur] [int] NULL,
[Time as Member Cur] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[membership_time_sort] [int] NULL,
[Is Patient New] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is Patient Established] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is Patient Alive] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is Patient Deceased] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Patient Vintage Month] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patient Vintage Month Range] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Patient Vintage Month sort] [int] NOT NULL,
[Age Current] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Marital Status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Race] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
