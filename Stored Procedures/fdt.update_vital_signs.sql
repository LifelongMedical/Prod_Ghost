
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
CREATE PROCEDURE [fdt].[update_vital_signs]
	-- Add the parameters for the stored procedure here
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

        IF OBJECT_ID('fdt.[Fact and Dim Vital Signs]') IS NOT NULL
            DROP TABLE fdt.[Fact and Dim Vital Signs];
    
	
        IF OBJECT_ID('fdt.[Bridge Vital Signs]') IS NOT NULL
            DROP TABLE fdt.[Bridge Vital Signs];
	
        SELECT    vital_signs_key,
                [create_timestamp] ,
                [BP_date] ,
             
                [Type] ,
                [Value] ,
              CASE WHEN ( CAST([Value] AS INT) ) <= 4 THEN '<=4'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 9 THEN '5-4'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 14 THEN '10-14'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 19 THEN '15-19'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 24 THEN '20-24'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 29 THEN '25-29'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 34 THEN '30-34'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 39 THEN '35-39'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 44 THEN '40-44'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 49 THEN '45-49'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 54 THEN '50-54'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 59 THEN '55-59'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 64 THEN '60-64'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 69 THEN '65-69'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 74 THEN '70-74'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 79 THEN '75-79'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 84 THEN '80-84'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 89 THEN '85-89'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 94 THEN '90-94'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 99 THEN '95-99'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 104 THEN '100-104'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 109 THEN '105-109'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 114 THEN '110-114'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 119 THEN '115-119'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 124 THEN '120-125'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 129 THEN '125-129'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 134 THEN '130-134'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 139 THEN '135-139'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 144 THEN '140-144'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 149 THEN '145-149'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 154 THEN '150-154'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 159 THEN '155-159'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 164 THEN '160-164'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 169 THEN '165-169'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 174 THEN '170-174'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 179 THEN '175-179'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 184 THEN '180-184'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 189 THEN '185-189'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 194 THEN '190-194'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 199 THEN '195-199'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 204 THEN '200-204'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 209 THEN '205-209'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 214 THEN '210-214'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 219 THEN '215-219'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 224 THEN '220-224'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 229 THEN '225-229'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 234 THEN '230-234'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 239 THEN '235-239'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 244 THEN '240-244'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 249 THEN '245-249'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 254 THEN '250-254'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 259 THEN '255-259'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 264 THEN '260-264'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 269 THEN '265-269'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 274 THEN '270-274'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 279 THEN '275-279'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 284 THEN '280-284'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 289 THEN '285-289'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 294 THEN '290-294'
                                                                   WHEN ( CAST([Value] AS INT) ) <= 299 THEN '295-299'
                                                                   ELSE 'Out of Range'
                                                          
                END AS [Range] ,
               CASE WHEN ( CAST([Value] AS INT) ) <= 4 THEN 1
                                      WHEN ( CAST([Value] AS INT) ) <= 9 THEN 2
                                      WHEN ( CAST([Value] AS INT) ) <= 14 THEN 3
                                      WHEN ( CAST([Value] AS INT) ) <= 19 THEN 4
                                      WHEN ( CAST([Value] AS INT) ) <= 24 THEN 5
                                      WHEN ( CAST([Value] AS INT) ) <= 29 THEN 6
                                      WHEN ( CAST([Value] AS INT) ) <= 34 THEN 7
                                      WHEN ( CAST([Value] AS INT) ) <= 39 THEN 8
                                      WHEN ( CAST([Value] AS INT) ) <= 44 THEN 9
                                      WHEN ( CAST([Value] AS INT) ) <= 49 THEN 10
                                      WHEN ( CAST([Value] AS INT) ) <= 54 THEN 11
                                      WHEN ( CAST([Value] AS INT) ) <= 59 THEN 12
                                      WHEN ( CAST([Value] AS INT) ) <= 64 THEN 13
                                      WHEN ( CAST([Value] AS INT) ) <= 69 THEN 14
                                      WHEN ( CAST([Value] AS INT) ) <= 74 THEN 15
                                      WHEN ( CAST([Value] AS INT) ) <= 79 THEN 16
                                      WHEN ( CAST([Value] AS INT) ) <= 84 THEN 17
                                      WHEN ( CAST([Value] AS INT) ) <= 89 THEN 18
                                      WHEN ( CAST([Value] AS INT) ) <= 94 THEN 19
                                      WHEN ( CAST([Value] AS INT) ) <= 99 THEN 20
                                      WHEN ( CAST([Value] AS INT) ) <= 104 THEN 21
                                      WHEN ( CAST([Value] AS INT) ) <= 109 THEN 22
                                      WHEN ( CAST([Value] AS INT) ) <= 114 THEN 23
                                      WHEN ( CAST([Value] AS INT) ) <= 119 THEN 24
                                      WHEN ( CAST([Value] AS INT) ) <= 124 THEN 25
                                      WHEN ( CAST([Value] AS INT) ) <= 129 THEN 26
                                      WHEN ( CAST([Value] AS INT) ) <= 134 THEN 27
                                      WHEN ( CAST([Value] AS INT) ) <= 139 THEN 28
                                      WHEN ( CAST([Value] AS INT) ) <= 144 THEN 29
                                      WHEN ( CAST([Value] AS INT) ) <= 149 THEN 30
                                      WHEN ( CAST([Value] AS INT) ) <= 154 THEN 31
                                      WHEN ( CAST([Value] AS INT) ) <= 159 THEN 32
                                      WHEN ( CAST([Value] AS INT) ) <= 164 THEN 33
                                      WHEN ( CAST([Value] AS INT) ) <= 169 THEN 34
                                      WHEN ( CAST([Value] AS INT) ) <= 174 THEN 35
                                      WHEN ( CAST([Value] AS INT) ) <= 179 THEN 36
                                      WHEN ( CAST([Value] AS INT) ) <= 184 THEN 37
                                      WHEN ( CAST([Value] AS INT) ) <= 189 THEN 38
                                      WHEN ( CAST([Value] AS INT) ) <= 194 THEN 39
                                      WHEN ( CAST([Value] AS INT) ) <= 199 THEN 40
                                      WHEN ( CAST([Value] AS INT) ) <= 204 THEN 41
                                      WHEN ( CAST([Value] AS INT) ) <= 209 THEN 42
                                      WHEN ( CAST([Value] AS INT) ) <= 214 THEN 43
                                      WHEN ( CAST([Value] AS INT) ) <= 219 THEN 44
                                      WHEN ( CAST([Value] AS INT) ) <= 224 THEN 45
                                      WHEN ( CAST([Value] AS INT) ) <= 229 THEN 46
                                      WHEN ( CAST([Value] AS INT) ) <= 234 THEN 47
                                      WHEN ( CAST([Value] AS INT) ) <= 239 THEN 48
                                      WHEN ( CAST([Value] AS INT) ) <= 244 THEN 49
                                      WHEN ( CAST([Value] AS INT) ) <= 249 THEN 50
                                      WHEN ( CAST([Value] AS INT) ) <= 254 THEN 51
                                      WHEN ( CAST([Value] AS INT) ) <= 259 THEN 52
                                      WHEN ( CAST([Value] AS INT) ) <= 264 THEN 53
                                      WHEN ( CAST([Value] AS INT) ) <= 269 THEN 54
                                      WHEN ( CAST([Value] AS INT) ) <= 274 THEN 55
                                      WHEN ( CAST([Value] AS INT) ) <= 279 THEN 56
                                      WHEN ( CAST([Value] AS INT) ) <= 284 THEN 57
                                      WHEN ( CAST([Value] AS INT) ) <= 289 THEN 58
                                      WHEN ( CAST([Value] AS INT) ) <= 294 THEN 59
                                      WHEN ( CAST([Value] AS INT) ) <= 299 THEN 60
                                     -- ELSE 'Out of Range'
                            
                END [Range_Sort] ,
                [Recency] ,
				person_key,
                [per_mon_id] ,
                [first_mon_date] ,
                [enc_appt_key],
				[Datetime of Measurement],
				[Date of Measurement],
				[RecencyDay] [Recency in a Day],
				[RecencyAllTime] [Recency All Time]

        INTO    fdt.[Fact and Dim Vital Signs]
        FROM    [dwh].[data_vital_signs];
		

SELECT person_key, vital_signs_key  INTO fdt.[Bridge Vital Signs] FROM  [dwh].[data_vital_signs];


-- Need to alter this rountine so that it ensure no duplicates 
        ALTER TABLE fdt.[Fact and Dim Vital Signs] ADD PRIMARY KEY(vital_signs_key);   

    END
GO
