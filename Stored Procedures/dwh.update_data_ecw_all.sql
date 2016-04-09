SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dwh].[update_data_ecw_all]

AS

BEGIN
/*
ECW data is ETL'd to development server, as the ecw MySql db can't be connected to production server.
This procedure copies the tables from development server to production
*/



SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF OBJECT_ID('dwh.data_provider_ecw') IS NOT NULL
	DROP TABLE dwh.data_provider_ecw

IF OBJECT_ID('dwh.data_appointment_ecw') IS NOT NULL
	DROP TABLE dwh.data_appointment_ecw

IF OBJECT_ID('dwh.data_location_ecw') IS NOT NULL
	DROP TABLE dwh.data_location_ecw

IF OBJECT_ID('dwh.data_patient_ecw') IS NOT NULL
	DROP TABLE dwh.data_patient_ecw


SELECT * INTO dwh.data_provider_ecw FROM [SQL2014-DEV\SQLDEVGHOST].Staging_Ghost.[dbo].[data_provider_ecw]

SELECT * INTO dwh.data_appointment_ecw FROM [SQL2014-DEV\SQLDEVGHOST].Staging_Ghost.dbo.data_appointment_ecw_etl

SELECT * INTO dwh.data_location_ecw FROM [SQL2014-DEV\SQLDEVGHOST].Staging_Ghost.dbo.data_location_ecw

SELECT * INTO dwh.data_patient_ecw FROM [SQL2014-DEV\SQLDEVGHOST].Staging_Ghost.dbo.data_patient_ecw


END 
GO
