SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Benjamin P Mansalis
-- Create date: 9/29/2015
-- Description:	
-- This routine creates a provider table for the data warehouse based on the NG provider master file

--Dependencies - none

-- =============================================
CREATE PROCEDURE [dwh].[update_data_sp_data]
AS
    BEGIN


        SET ANSI_NULLS ON;
        SET QUOTED_IDENTIFIER ON;

        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
        IF OBJECT_ID('dwh.data_provider_shift') IS NOT NULL
            DROP TABLE dwh.data_provider_shift;
        IF OBJECT_ID('fdt.[Dim Provider Shift]') IS NOT NULL
            DROP TABLE fdt.[Dim Provider Shift];


/****** Script for SelectTopNRows command from SSMS  ******/
        SELECT  DISTINCT fe_site_key ,
                ar.employee_key ,
                [TargetVisitsPerShift] AS [Target Visits per Shift] ,
                [NumberOfPCPShifts] AS [Expected Number of Primary Care Shifts per Week]
        INTO dwh.data_provider_shift
		FROM    [Prod_Ghost].[etl].[sp_provider_shift] sh
                LEFT JOIN dwh.data_employee_v2 ar ON ar.[File Number] = sh.[filenumber]
                LEFT JOIN dwh.data_site ds ON sh.SiteCode = ds.[site]
				WHERE ds.fe_site_key IS NOT NULL and ar.employee_key IS NOT null ;



SELECT * INTO fdt.[Dim Provider Shift] FROM  dwh.data_provider_shift


    END;
GO
