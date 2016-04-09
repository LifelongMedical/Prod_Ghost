SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife>
-- Create date: <Create Date,,4/1/2016>
-- Description:	<Description,,Vital Signs>

--4/7/2016 Hanife Fact and Dim Vital Signs logic completely changed by request. added Type and Value
-- =============================================
CREATE PROCEDURE [fdt].[update_patient_vital_signs]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    IF OBJECT_ID('fdt.[Fact and Dim Vital Signs]') IS NOT NULL
		DROP TABLE fdt.[Fact and Dim Vital Signs];
    
	
	SELECT  
		vital_signs_key = IDENTITY( INT,1,1 ),
	   [create_timestamp],
		[BP_date],
		[Type],
		[Value],
		CASE WHEN ([Type]='BP Systolic') OR ([Type]='BP Diastolic') THEN 
		 CASE 
             WHEN  (CAST([Value] AS INT))>=40 AND (CAST([Value] AS INT))<=44  THEN  '40-44' 
			 WHEN (CAST([Value] AS INT))>=45 AND (CAST([Value] AS INT))<=49 THEN '45-49' 
			 WHEN (CAST([Value] AS INT))>=50 AND (CAST([Value] AS INT))<=54 THEN '50-54'
			 WHEN (CAST([Value] AS INT))>=55 AND (CAST([Value] AS INT))<=59 THEN '55-59'
			 WHEN (CAST([Value] AS INT))>=60 AND (CAST([Value] AS INT))<=64 THEN '60-64'
			 WHEN (CAST([Value] AS INT))>=65 AND (CAST([Value] AS INT))<=69 THEN '65-69'
			 WHEN (CAST([Value] AS INT))>=70 AND (CAST([Value] AS INT))<=74 THEN '70-74'
			 WHEN (CAST([Value] AS INT))>=75 AND (CAST([Value] AS INT))<=79 THEN '75-79'
			 WHEN (CAST([Value] AS INT))>=80 AND (CAST([Value] AS INT))<=84 THEN '80-84'
			 WHEN (CAST([Value] AS INT))>=85 AND (CAST([Value] AS INT))<=89 THEN '85-89'
			 WHEN (CAST([Value] AS INT))>=90 AND (CAST([Value] AS INT))<=94 THEN '90-94'
			 WHEN (CAST([Value] AS INT))>=95 AND (CAST([Value] AS INT))<=99 THEN '95-99'
			 WHEN (CAST([Value] AS INT))>=100 AND (CAST([Value] AS INT))<=104 THEN '100-104'
			 WHEN (CAST([Value] AS INT))>=105 AND (CAST([Value] AS INT))<=109 THEN '105-109'  
			 WHEN (CAST([Value] AS INT))>=110 AND (CAST([Value] AS INT))<=114 THEN '110-114'
			 WHEN (CAST([Value] AS INT))>=115 AND (CAST([Value] AS INT))<=119 THEN '115-119'
		     WHEN (CAST([Value] AS INT))>=120 AND (CAST([Value] AS INT))<=124 THEN '120-125'
			 WHEN (CAST([Value] AS INT))>=125 AND (CAST([Value] AS INT))<=129 THEN '125-129'
			 WHEN (CAST([Value] AS INT))>=130 AND (CAST([Value] AS INT))<=134 THEN '130-134'
			 WHEN (CAST([Value] AS INT))>=135 AND (CAST([Value] AS INT))<=139 THEN '135-139'
			 WHEN (CAST([Value] AS INT))>=140 AND (CAST([Value] AS INT))<=144 THEN '140-144'
			 WHEN (CAST([Value] AS INT))>=145 AND (CAST([Value] AS INT))<=149 THEN '145-149'
			 WHEN (CAST([Value] AS INT))>=150 AND (CAST([Value] AS INT))<=154 THEN '150-154'
			 WHEN (CAST([Value] AS INT))>=155 AND (CAST([Value] AS INT))<=159 THEN '155-159'
			 WHEN (CAST([Value] AS INT))>=160 AND (CAST([Value] AS INT))<=164 THEN '160-164'
			 WHEN (CAST([Value] AS INT))>=165 AND (CAST([Value] AS INT))<=169 THEN '165-169'
			 WHEN (CAST([Value] AS INT))>=170 AND (CAST([Value] AS INT))<=174 THEN '170-174'
			 WHEN (CAST([Value] AS INT))>=175 AND (CAST([Value] AS INT))<=179 THEN '175-179'
			 WHEN (CAST([Value] AS INT))>=180 AND (CAST([Value] AS INT))<=184 THEN '180-184'
			 WHEN (CAST([Value] AS INT))>=185 AND (CAST([Value] AS INT))<=189 THEN '185-189'
			 WHEN (CAST([Value] AS INT))>=190 AND (CAST([Value] AS INT))<=194 THEN '190-194'
			 WHEN (CAST([Value] AS INT))>=195 AND (CAST([Value] AS INT))<=199 THEN '195-199'
			 WHEN (CAST([Value] AS INT))>=200 AND (CAST([Value] AS INT))<=204 THEN '200-204'
			 WHEN (CAST([Value] AS INT))>=205 AND (CAST([Value] AS INT))<=209 THEN '205-209'
			 WHEN (CAST([Value] AS INT))>=210 AND (CAST([Value] AS INT))<=214 THEN '210-214'
			 WHEN (CAST([Value] AS INT))>=215 AND (CAST([Value] AS INT))<=219 THEN '215-219'
			 WHEN (CAST([Value] AS INT))>=220 AND (CAST([Value] AS INT))<=224 THEN '220-224'
			 WHEN (CAST([Value] AS INT))>=225 AND (CAST([Value] AS INT))<=229 THEN '225-229'
			 WHEN (CAST([Value] AS INT))>=230 AND (CAST([Value] AS INT))<=234 THEN '230-234'
			 WHEN (CAST([Value] AS INT))>=235 AND (CAST([Value] AS INT))<=239 THEN '235-239'
			 WHEN (CAST([Value] AS INT))>=240 AND (CAST([Value] AS INT))<=244 THEN '240-244'
			 ELSE (CAST([Value] AS NVARCHAR(100)))
	      END  
		END AS [Range],
		 CASE WHEN ([Type]='Blood Pressure Systolic' OR [Type]='Blood Pressure Diastolic') THEN 
		 CASE 
             WHEN  (CAST([Value] AS INT))>=40 AND (CAST([Value] AS INT))<=44  THEN  1
			 WHEN (CAST([Value] AS INT))>=45 AND (CAST([Value] AS INT))<=49 THEN 2 
			 WHEN (CAST([Value] AS INT))>=50 AND (CAST([Value] AS INT))<=54 THEN 3
			 WHEN (CAST([Value] AS INT))>=55 AND (CAST([Value] AS INT))<=59 THEN 4
			 WHEN (CAST([Value] AS INT))>=60 AND (CAST([Value] AS INT))<=64 THEN 5
			 WHEN (CAST([Value] AS INT))>=65 AND (CAST([Value] AS INT))<=69 THEN 6
			 WHEN (CAST([Value] AS INT))>=70 AND (CAST([Value] AS INT))<=74 THEN 7
			 WHEN (CAST([Value] AS INT))>=75 AND (CAST([Value] AS INT))<=79 THEN 8
			 WHEN (CAST([Value] AS INT))>=80 AND (CAST([Value] AS INT))<=84 THEN 9
			 WHEN (CAST([Value] AS INT))>=85 AND (CAST([Value] AS INT))<=89 THEN 10
			 WHEN (CAST([Value] AS INT))>=90 AND (CAST([Value] AS INT))<=94 THEN 11
			 WHEN (CAST([Value] AS INT))>=95 AND (CAST([Value] AS INT))<=99 THEN 12
			 WHEN (CAST([Value] AS INT))>=100 AND (CAST([Value] AS INT))<=104 THEN 13
			 WHEN (CAST([Value] AS INT))>=105 AND (CAST([Value] AS INT))<=109 THEN 14  
			 WHEN (CAST([Value] AS INT))>=110 AND (CAST([Value] AS INT))<=114 THEN 15
			 WHEN (CAST([Value] AS INT))>=115 AND (CAST([Value] AS INT))<=119 THEN 16
		     WHEN (CAST([Value] AS INT))>=120 AND (CAST([Value] AS INT))<=124 THEN 17
			 WHEN (CAST([Value] AS INT))>=125 AND (CAST([Value] AS INT))<=129 THEN 18
			 WHEN (CAST([Value] AS INT))>=130 AND (CAST([Value] AS INT))<=134 THEN 19
			 WHEN (CAST([Value] AS INT))>=135 AND (CAST([Value] AS INT))<=139 THEN 20
			 WHEN (CAST([Value] AS INT))>=140 AND (CAST([Value] AS INT))<=144 THEN 21
			 WHEN (CAST([Value] AS INT))>=145 AND (CAST([Value] AS INT))<=149 THEN 22
			 WHEN (CAST([Value] AS INT))>=150 AND (CAST([Value] AS INT))<=154 THEN 23
			 WHEN (CAST([Value] AS INT))>=155 AND (CAST([Value] AS INT))<=159 THEN 24
			 WHEN (CAST([Value] AS INT))>=160 AND (CAST([Value] AS INT))<=164 THEN 25
			 WHEN (CAST([Value] AS INT))>=165 AND (CAST([Value] AS INT))<=169 THEN 26
			 WHEN (CAST([Value] AS INT))>=170 AND (CAST([Value] AS INT))<=174 THEN 27
			 WHEN (CAST([Value] AS INT))>=175 AND (CAST([Value] AS INT))<=179 THEN 28
			 WHEN (CAST([Value] AS INT))>=180 AND (CAST([Value] AS INT))<=184 THEN 29
			 WHEN (CAST([Value] AS INT))>=185 AND (CAST([Value] AS INT))<=189 THEN 30
			 WHEN (CAST([Value] AS INT))>=190 AND (CAST([Value] AS INT))<=194 THEN 31
			 WHEN (CAST([Value] AS INT))>=195 AND (CAST([Value] AS INT))<=199 THEN 32
			 WHEN (CAST([Value] AS INT))>=200 AND (CAST([Value] AS INT))<=204 THEN 33
			 WHEN (CAST([Value] AS INT))>=205 AND (CAST([Value] AS INT))<=209 THEN 34
			 WHEN (CAST([Value] AS INT))>=210 AND (CAST([Value] AS INT))<=214 THEN 35
			 WHEN (CAST([Value] AS INT))>=215 AND (CAST([Value] AS INT))<=219 THEN 36
			 WHEN (CAST([Value] AS INT))>=220 AND (CAST([Value] AS INT))<=224 THEN 37
			 WHEN (CAST([Value] AS INT))>=225 AND (CAST([Value] AS INT))<=229 THEN 38
			 WHEN (CAST([Value] AS INT))>=230 AND (CAST([Value] AS INT))<=234 THEN 39
			 WHEN (CAST([Value] AS INT))>=235 AND (CAST([Value] AS INT))<=239 THEN 40
			 WHEN (CAST([Value] AS INT))>=240 AND (CAST([Value] AS INT))<=244 THEN 41
			 ELSE 0
	      END  
		END [Range_Sort],
		[Recency],
        [per_mon_id],
        [first_mon_date],
        [enc_appt_key]
		INTO fdt.[Fact and Dim Vital Signs]
		FROM [dwh].[data_vital_signs]
		

-- Need to alter this rountine so that it ensure no duplicates 
   ALTER TABLE fdt.[Fact and Dim Vital Signs] ADD PRIMARY KEY(vital_signs_key);   

END
GO
