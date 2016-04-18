CREATE TABLE [dwh].[data_i2i_tracking]
(
[patientID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackTypeID] [int] NULL,
[per_mon_id] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_mon_date] [date] NULL
) ON [PRIMARY]
GO
