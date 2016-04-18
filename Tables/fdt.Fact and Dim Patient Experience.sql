CREATE TABLE [fdt].[Fact and Dim Patient Experience]
(
[survey_key] [int] NOT NULL,
[Enc Nbr] [numeric] (18, 0) NULL,
[enc_appt_key] [int] NOT NULL,
[Location] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Survey Q1] [decimal] (18, 0) NULL,
[Survey Q2] [decimal] (18, 0) NULL,
[Survey Q3] [decimal] (18, 0) NULL,
[Survey Q4] [decimal] (18, 0) NULL,
[Survey Q5] [decimal] (18, 0) NULL,
[Survey Q6] [decimal] (18, 0) NULL,
[Survey Q7] [decimal] (18, 0) NULL,
[Value Q1] [int] NULL,
[Value Q2] [int] NULL,
[Value Q3] [int] NULL,
[Value Q4] [int] NULL,
[Value Q5] [int] NULL,
[Value Q6] [int] NULL,
[Total Q1] [int] NOT NULL,
[Total Q2] [int] NOT NULL,
[Total Q3] [int] NOT NULL,
[Total Q4] [int] NOT NULL,
[Total Q5] [int] NOT NULL,
[Total Q6] [int] NOT NULL,
[Total Q7] [int] NOT NULL,
[Total Promoters] [int] NOT NULL,
[Total Detractors] [int] NOT NULL,
[Comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [fdt].[Fact and Dim Patient Experience] ADD 
CONSTRAINT [PK__Fact and__61E7930DF34989E6] PRIMARY KEY CLUSTERED  ([survey_key]) ON [PRIMARY]
GO
