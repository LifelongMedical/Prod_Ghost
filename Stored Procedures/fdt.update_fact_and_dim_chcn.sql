SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_fact_and_dim_chcn]
	-- Add the parameters for the stored procedure here
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

		--Drop the table as it is re created by the procedure
        IF OBJECT_ID('fdt.[Dim CHCN Patient]') IS NOT  NULL
            DROP TABLE fdt.[Dim CHCN Patient];
        IF OBJECT_ID('fdt.[Fact CHCN Patient]') IS NOT  NULL
            DROP TABLE fdt.[Fact CHCN Patient];

        SELECT  [chcn_key] = IDENTITY( INT,1,1 ) 
      ,
                [memb_id] AS [CHCN Member ID] ,
                [first_month_date]
      --,person_dp.[per_mon_id] AS [per_mon_id]
                ,
                [chc] AS [Health Center Acronym] ,
                [company] AS [Health Center Name] ,
                [effdate] AS [Effective Date] ,
                [termdate] AS [Termination Date] ,
                [patid] AS [HMO Patient Identification Number] ,
                [mgd_care_plan] AS [CHCN Benefit Option Code] ,
                [subssn] AS [SSN] ,
                [lastnm] AS [Member Last Name] ,
                [firstnm] AS [Member First Name] ,
                [street] AS [Address] ,
                chcn.[city] AS [City] ,
                chcn.[zip] AS [Zip Code] ,
                chcn.[dob] AS [Member Date of Birth] ,
                chcn.[sex] AS [Member Gender] ,
                [phone] AS [Phone Number] ,
                chcn.[language] AS [Language] ,
                [mcal10] AS [4 Digit MediCal Id] ,
                [otherid2] AS [CIN#] ,
                [site] AS [CHCN Site Code] ,
                CASE WHEN [site] = 'LMC001' THEN 'LMC Ashby Health Center(Formerly Berkeley Primary)'
                     WHEN [site] = 'LMC002' THEN 'LMC East Oakland'
                     WHEN [site] = 'LMC003' THEN 'LMC Over 60 Health Center Over 60'
                     WHEN [site] = 'LMC004' THEN 'LMC West Berkeley Family Practice'
                     WHEN [site] = 'LMC005' THEN 'LMC Downtown Oakland'
                     WHEN [site] = 'LMC006' THEN 'LMC Howard Daniel Clinic'
                     WHEN [site] = 'LMC007' THEN 'LMC Brookside San Pablo'
                     WHEN [site] = 'LMC008' THEN 'LMC Brookside Richmond'
                     WHEN [site] = 'LMC009' THEN 'LMC WM Jenkins Pediatric CTR'
                     WHEN [site] = 'LMC010' THEN 'LMC Richmond'
                     ELSE 'Unknow Medical Home'
                END AS [CHCN Site Code Description] ,
                [hic] AS [HIC #] ,
                [mcarea] AS [MediCare A Effective Date] ,
                [mcareb] AS [MediCare B Effective Date] ,
                [ccs] AS [CCS Case# and/or Dx Code] ,
                [ccsdt] AS [CCS Effective Date] ,
                [cob] AS [Other Coverage] ,
                [hfpcopay] AS [Health Families Copay Code] ,
                [ac] AS [Aid Code] ,
                [transaction_code] AS [Transaction Code] ,
                [transaction_date] AS [Transaction Date] ,
                active AS [Member Active] ,
                CASE WHEN [per_mon_id] IS NULL THEN 0
                     WHEN [per_mon_id] = '' THEN 0
                     WHEN [per_mon_id] IS NOT NULL THEN 1
                     WHEN [per_mon_id] != '' THEN 1
                     ELSE 0
                END AS [Number NG] ,
                person_dp.per_mon_id
        INTO    #temp1
        FROM    [dwh].[data_chcn_nd_month] chcn
                LEFT OUTER JOIN [Prod_Ghost].[dwh].[data_person_dp_month] person_dp ON person_dp.[person_id] = chcn.person_id
                                                                                       AND person_dp.first_mon_date = chcn.first_month_date; 



        SELECT  chcn_key ,
                [CHCN Member ID] ,
                first_month_date ,
                [Health Center Acronym] ,
                [Health Center Name] ,
                [Effective Date] ,
                [Termination Date] ,
                [HMO Patient Identification Number] ,
                [CHCN Benefit Option Code] ,
                SSN ,
                [Member Last Name] ,
                [Member First Name] ,
                Address ,
                City ,
                [Zip Code] ,
                [Member Date of Birth] ,
                [Member Gender] ,
                [Phone Number] ,
                Language ,
                [4 Digit MediCal Id] ,
                CIN# ,
                [CHCN Site Code] ,
                [CHCN Site Code Description] ,
                [HIC #] ,
                [MediCare A Effective Date] ,
                [MediCare B Effective Date] ,
                [CCS Case# and/or Dx Code] ,
                [CCS Effective Date] ,
                [Other Coverage] ,
                [Health Families Copay Code] ,
                [Aid Code] ,
                [Transaction Code] ,
                [Transaction Date] ,
                [Member Active] ,
                [Number NG] ,
                COALESCE(t1.per_mon_id, MAX(t1.per_mon_id) OVER ( ) + ROW_NUMBER() OVER ( ORDER BY t1.per_mon_id )) AS per_mon_id
        INTO    #Temp2
        FROM    #temp1 t1; 



        SELECT  * ,
                ROW_NUMBER() OVER ( PARTITION BY per_mon_id ORDER BY per_mon_id ) AS dd
        INTO    #Temp3
        FROM    #Temp2;



        DELETE  #Temp3
        WHERE   dd > 1;





        UPDATE  dp
        SET     [Zip Code] = ( SELECT TOP 1
                                        zipcode
                               FROM     etl.data_zipcode ez
                               WHERE    LEFT(dp.[Zip Code], 5) = LEFT(ez.zipcode, 5)
                             )
        FROM    #Temp3 dp;

		SELECT *,[Address]+' '+[City]+' '+' CA ' + [Zip Code] AS [Address Full]
		
		INTO    [Prod_Ghost].fdt.[Dim CHCN Patient]
		FROM #Temp3




        SELECT  *
        INTO    [Prod_Ghost].[fdt].[Fact CHCN Patient]
        FROM    [Prod_Ghost].fdt.[Dim CHCN Patient];



-- Need to alter this rountine so that it ensure no duplicates 

        ALTER TABLE fdt.[Dim CHCN Patient] ADD PRIMARY KEY(chcn_key);   
        ALTER TABLE fdt.[Fact CHCN Patient] ADD PRIMARY KEY(chcn_key); 
    END;


GO
