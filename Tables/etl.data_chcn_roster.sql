CREATE TABLE [etl].[data_chcn_roster]
(
[seq_no] [int] NOT NULL IDENTITY(1, 1),
[chc] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[effdate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[termdate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[patid] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mgd_care_plan] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subssn] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastnm] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstnm] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dob] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sex] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[language] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mcal10] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[otherid2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[site] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[membid] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hic] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mcarea] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mcareb] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ccs] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ccsdt] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cob] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hfpcopay] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ac] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transactionCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transactionDate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sourcefile] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ng_uniq_id] [uniqueidentifier] NULL,
[run_date] [datetime] NULL,
[roster_month] [datetime] NULL,
[match_info] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[match_candidate] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_patient_imported_to_final_table] [bit] NULL,
[is_patient_latest_date] [bit] NULL,
[active] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [etl].[data_chcn_roster] ADD CONSTRAINT [PK__data_chc__4B660EB1698FA01E] PRIMARY KEY CLUSTERED  ([seq_no]) ON [PRIMARY]
GO