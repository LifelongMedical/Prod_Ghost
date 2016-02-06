CREATE TABLE [fdt].[Fact Budget]
(
[budget_enc_key] [int] NOT NULL IDENTITY(1, 1),
[location_key] [int] NULL,
[ActualLocalDateKey] [date] NULL,
[Budgeted Encounters] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Budget] ADD CONSTRAINT [FK_location_key99] FOREIGN KEY ([location_key]) REFERENCES [fdt].[Dim Location for Enc or Appt] ([location_key])
GO
