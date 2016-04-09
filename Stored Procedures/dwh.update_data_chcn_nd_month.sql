SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Hanife>
-- Create date: <Create Date,,>
-- Description:	<this procedure will historical update same month and same year data.>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_chcn_nd_month]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	DECLARE @totalUniqueMember INT 
	DECLARE @totalColumns int
	DECLARE @currentMemberId VARCHAR(20)
	DECLARE @currentColumnValue NVARCHAR(200)
	DECLARE @i INT
	DECLARE @sqlText NVARCHAR(500)
	DECLARE @latestSourceFileYear NVARCHAR(20)
	DECLARE @current_date_group NVARCHAR(30);
	

	IF OBJECT_ID('tempdb..#TempMemberIdTable') IS NOT NULL
		DROP TABLE #TempMemberIdTable;
	IF OBJECT_ID('tempdb..#chcn_same_month_year') IS NOT NULL
		DROP TABLE #chcn_same_month_year;
	IF OBJECT_ID('tempdb..#same_month_year') IS NOT NULL
 		DROP TABLE #same_month_year;
    IF OBJECT_ID('tempdb..#columnsName') IS NOT NULL
		DROP TABLE #columnsName;		
	 IF OBJECT_ID('#data_chcn_same_month_year') IS NOT NULL
		DROP TABLE #data_chcn_same_month_year;		



--delete all other clinics diffrent then LMC. I realized files has LA CLINICA DE LA RAZA patients informations. this way we will keep only  assigned LMC patients
	DELETE FROM [etl].[data_chcn_roster]
	WHERE REPLACE(chc,' ','')!='LMC'

--Deleting members dublicate by same day, month and year.There is no reason to keep the duplicate data by date 	
		; WITH  dublicateMembers
		AS( SELECT  membid,row_number() OVER ( PARTITION BY membid,SUBSTRING(sourcefile,14,8) ORDER BY membid ) AS nr FROM [etl].[data_chcn_roster])
		DELETE   FROM dublicateMembers WHERE nr>1	



--group the data  by same month and same year. 
	SELECT CAST(MONTH(roster_month) AS VARCHAR(3)) ++ CAST(YEAR(roster_month) AS VARCHAR(4)) AS date_group,COUNT(*) AS totalMember
	INTO #same_month_year
	FROM [etl].[data_chcn_roster] 
	GROUP BY CAST(MONTH(roster_month) AS VARCHAR(3)) + + CAST(YEAR(roster_month) AS VARCHAR(4))




--After grouping the date, open coursor to do make historical update&delete dublicate members in same month and year data.
	DECLARE date_cursor CURSOR FOR 
		SELECT date_group FROM #same_month_year
	OPEN date_cursor 

	FETCH NEXT FROM date_cursor 
	INTO @current_date_group
	WHILE @@FETCH_STATUS=0
	BEGIN 
		PRINT @current_date_group
		--set @totalColumns and @totalUniqueMember
	    --select all the member by that month and year 
		SELECT DISTINCT * INTO #data_chcn_same_month_year FROM  [etl].[data_chcn_roster]  WHERE [is_patient_imported_to_final_table]='FALSE' AND  (CAST(MONTH(roster_month) AS VARCHAR(3)) ++ CAST(YEAR(roster_month) AS VARCHAR(4)))=@current_date_group
		SET @totalUniqueMember=(SELECT COUNT(DISTINCT membid) FROM #data_chcn_same_month_year)
	
		

		--Historical update will be here 

		SET @i=1
		IF @totalUniqueMember>0
		BEGIN
			WHILE(@i<=@totalUniqueMember)
				BEGIN 
				 DECLARE @k INT 
				 --get all the column name that are not  needed to update
				  SELECT COLUMN_NAME INTO #columnsName FROM INFORMATION_SCHEMA.COLUMNS WHERE table_catalog ='proto_mart' AND TABLE_SCHEMA = 'dbo' and TABLE_NAME=' [etl].[data_chcn_roster] '
				  --delete the columns that no need historical update 
				  DELETE FROM #columnsName WHERE COLUMN_NAME  IN('seq_no','run_date','roster_month','active','is_patient_imported_to_final_table','is_patient_latest_date','sourcefile','match_info','match_candidate','ng_uniq_id')	
				 SET @totalColumns= (SELECT COUNT(COLUMN_NAME) FROM #columnsName)
				 --pick one member
				 SET @currentMemberId=(SELECT TOP 1 membid FROM #data_chcn_same_month_year)
				 --Brings member latest source file by day and if any column is empty, check another year to that column info. if the column is not empty or NULL, then replace with null value.  
				 SET @latestSourceFileYear=(SELECT TOP 1  SUBSTRING(sourcefile,14,8) FROM #data_chcn_same_month_year WHERE membid=@currentMemberId  ORDER BY   SUBSTRING(sourcefile,14,8) DESC)


				 --update the Flag, so if there are same day,same month and same year,knows which one is picked
				 UPDATE  [etl].[data_chcn_roster] 
				 SET is_patient_latest_date=1
				 WHERE is_patient_imported_to_final_table=0 AND membid=@currentMemberId AND SUBSTRING(sourcefile,14,8)=@latestSourceFileYear
				 
				
				DECLARE  @rowCountByMemberId INT
				SET @rowCountByMemberId=((SELECT COUNT(*) FROM  [etl].[data_chcn_roster]  WHERE membid=@currentMemberId AND   ((is_patient_latest_date IS NULL) OR (is_patient_latest_date='')) AND  is_patient_imported_to_final_table=0 AND  (CAST(MONTH(roster_month) AS VARCHAR(3)) ++ CAST(YEAR(roster_month) AS VARCHAR(4)))=@current_date_group)) 	
				 SET @k=1
				 --loop for the each cloumn values 
				 PRINT @rowCountByMemberId
				 IF(@rowCountByMemberId>0)
					BEGIN
					   PRINT N'Second Loop' 
						PRINT N'  Member ID :  '+@currentMemberId
						WHILE (@k<=(@totalColumns))
							BEGIN
								DECLARE @currentColumnName NVARCHAR(20)
								DECLARE @currentCalumnValueTable TABLE (Value VARCHAR (100))
								SET @currentColumnName=(SELECT TOP 1 COLUMN_NAME FROM #columnsName)
								PRINT N'CurrentColumnName:  '+@currentColumnName
								PRINT N'NumberOfColumn   :  '+CAST(@k AS NVARCHAR(20) )
								PRINT N'CurrentMember   :  '+CAST(@i AS NVARCHAR(20))
								PRINT N'TotalMember      : '+CAST(@totalUniqueMember AS NVARCHAR(20))
								PRINT N'RowMembers       :  '+CAST(@rowCountByMemberId AS NVARCHAR(20))
								--This query brings current calumn value. If value is empty or Null, then will look same year same month patient data to fill
								SET @sqlText=N' SELECT '+ @currentColumnName + 
								' FROM  [etl].[data_chcn_roster]   WHERE membid='+''''+@currentMemberId+''' and  SUBSTRING(sourcefile,14,8)='+@latestSourceFileYear+' and is_patient_latest_date=1 and is_patient_imported_to_final_table=0 and (CAST(MONTH(roster_month) AS VARCHAR(3)) ++ CAST(YEAR(roster_month) AS VARCHAR(4)))='+''''+@current_date_group+''''
								PRINT @sqlText
								INSERT INTO @currentCalumnValueTable
								EXEC sp_executesql @sqlText
								PRINT N'Sql Query'+@sqlText
								SET @currentColumnValue=(SELECT TOP 1 Value from @currentCalumnValueTable )
								PRINT N'CurrentColumnValue '+@currentColumnValue
								IF ((@currentColumnValue IS NULL) OR (@currentColumnValue='')) 
									BEGIN
										PRINT N'ColumnLookingNewValue---->'+@currentColumnName
										PRINT N'currentCalumnValue---->'+@currentColumnValue
										CREATE TABLE #leadValueTempTable (leadValue varchar(50))
										--This select statement brings all the current calumn value except the latest day. 
										SET @sqlText=N'
										SELECT '+@currentColumnName+' 
										FROM  [etl].[data_chcn_roster]  	
										WHERE  is_patient_imported_to_final_table=0 AND (is_patient_latest_date IS NULL)   AND  (CAST(MONTH(roster_month) AS VARCHAR(3)) ++ CAST(YEAR(roster_month) AS VARCHAR(4)))='+@current_date_group+'  and membid='+''''+@currentMemberId+'''
										ORDER BY SUBSTRING(sourcefile,14,8) DESC ;'
										PRINT @sqlText
										INSERT INTO #leadValueTempTable (leadValue)
										EXEC(@sqlText)
										DECLARE @newCalumnValue NVARCHAR(100)
										SELECT * FROM #leadValueTempTable
										--This select statement brings a value to replace it. 
										PRINT 'reading value'
										SET @newCalumnValue=(SELECT TOP 1 leadValue FROM #leadValueTempTable WHERE (leadValue IS NOT  NULL) AND leadValue!='')
										PRINT N'New Calumn value --->'+@newCalumnValue
										IF((@newCalumnValue IS NOT NULL) AND (@newCalumnValue<>''))
											BEGIN
											    --update latest day value
												PRINT 'Test'
												SET @sqlText= N'UPDATE  [etl].[data_chcn_roster]  SET '+@currentColumnName+'='+''''+@newCalumnValue+''' WHERE is_patient_imported_to_final_table=0 AND is_patient_latest_date=1  and  (CAST(MONTH(roster_month) AS VARCHAR(3)) ++ CAST(YEAR(roster_month) AS VARCHAR(4)))='+@current_date_group+' and membid='+''''+@currentMemberId+''' AND SUBSTRING(sourcefile,14,8)='+''''+@latestSourceFileYear+''''
												PRINT @sqlText
												EXEC(@sqlText)
											END  								
										DROP TABLE  #leadValueTempTable
									END

									
								DELETE from @currentCalumnValueTable
								DELETE FROM #columnsName WHERE COLUMN_NAME=@currentColumnName
								SET @k=@k+1
							END
					END
				DROP TABLE #columnsName 
				PRINT N'Deleting MemberID'+@currentMemberId
				DELETE FROM #data_chcn_same_month_year WHERE membid=@currentMemberId
				SET @i=@i+1
				 --delete currentMemberId after update
			  END
    END
		--Final Table will have unique member by month and year.
		--is_patient_latest_date column protects to import dublicate patient 


									INSERT INTO dwh.data_chcn_nd_month
										         ( 
										           memb_id,
										           first_month_date ,
										           chc ,
										           company ,
										           effdate ,
										           termdate ,
										           patid ,
										           mgd_care_plan ,
										           subssn ,
										           lastnm ,
										           firstnm ,
										           street ,
										           city ,
										           zip ,
										           dob ,
										           sex ,
										           phone ,
										           language ,
										           mcal10 ,
										           otherid2 ,
										           site ,
										           hic ,
										           mcarea ,
										           mcareb ,
										           ccs ,
										           ccsdt ,
										           cob ,
										           hfpcopay ,
										           ac ,
												   [transaction_code],
												   [transaction_date],
										           sourcefile ,
										           run_date,
												   person_id,
												   active 
										          
										         )							
									     SELECT membid,							
										   roster_month,
								            chc ,
								            company ,
								            effdate ,
								            termdate ,
								            patid ,
								            mgd_care_plan ,
								            subssn ,
								            lastnm ,
								            firstnm ,
								            street ,
								            city ,
								            zip ,
								            dob ,
								            sex ,
								            phone ,
								            language ,
								            mcal10 ,
								            otherid2 ,
								            site ,
								            hic ,
								            mcarea ,
								            mcareb ,
								            ccs ,
								            ccsdt ,
								            cob ,
								            hfpcopay ,
								            ac ,
											[transactionCode],
											[transactionDate],
								            sourcefile ,
								            run_date,
											ng_uniq_id,
											active								          
										 FROM  [etl].[data_chcn_roster] 
										 WHERE is_patient_imported_to_final_table=0 AND is_patient_latest_date=1 AND  SUBSTRING(sourcefile,14,8)=@latestSourceFileYear

										--mark updated file as imported. 
											UPDATE  [etl].[data_chcn_roster]  
											SET is_patient_imported_to_final_table='TRUE'
											WHERE is_patient_imported_to_final_table=0  AND (CAST(MONTH(roster_month) AS VARCHAR(3)) ++ CAST(YEAR(roster_month) AS VARCHAR(4)))=@current_date_group 

		DROP TABLE #data_chcn_same_month_year
		FETCH NEXT FROM date_cursor 
		INTO @current_date_group
	END
	CLOSE date_cursor;
	DEALLOCATE date_cursor

	
END
GO
