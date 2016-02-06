SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_pharmacy]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	
	SET NOCOUNT ON;
			
        IF OBJECT_ID('dwh.data_pharmacy_rx') IS NOT NULL
            DROP TABLE dwh.data_pharmacy_rx;
			 
        IF OBJECT_ID('tempdb..#temp_pharmacy') IS NOT NULL
            DROP TABLE #temp_pharmacy;
     
        



	DECLARE @start_date VARCHAR(8),
	@end_date VARCHAR(8)
 
	SET @start_date=CONVERT(CHAR(8),DATEADD(DAY,-1,GETDATE()),112);
	SET @end_date=@start_date
	PRINT @start_date

    CREATE TABLE dwh.data_pharmacy_rx
	(
	  
      [person_id] INT NOT NULL,
      [location_id] INT NOT NULL,
      [enc_id] INT NOT NULL,
      [provider_id] uniqueidentifier NOT null,
      [first_mon_date] date ,
      [md_id] numeric(8,0),
      [rx_id] uniqueidentifier,
      [gcnsecno] int,
      [drug_name] nvarchar(70),
      [ndc] CHAR(11),
      [med_rec_nbr] varchar(70),
      [store_id] uniqueidentifier,
      [start_date] date,
      [expire_date] date,
      [provider_name] varchar(75),
      [userName] varchar(32),
      [RxNotbyProv] int NOT null,
      [PatName] varchar(122) NOT null,
      [birth_date] varchar(122),
      [chart_id] varchar(6),
      [ssn] CHAR(9),
      [sig_text] varchar(512),
      [written_qty] int,
      [refills_left] int,
      [refills_orig] int,
      [SentTo] varchar(35),
      [clinic]varchar(40),
      [drug_dea_class] varchar(1),
      [operation_type] varchar(5),
      [mmyy] varchar(5),
      [Total_Non_Controlled] int NOT null,
      [Total_Controlled] int NOT null,
      [Sched_I] int NOT null,
      [Sched_II] int NOT null,
      [Sched_III] int NOT null,
      [Sched_IV] int NOT null,
      [Sched_V] int NOT null
	)

	  


--ndc drug billing number
--erx Electronic Prescribing

						SELECT DISTINCT 
						p.person_id,
						lm.location_id,
						prov.provider_id,
						CASE WHEN ISDATE(pm.start_date)=1 THEN CAST(CONVERT(CHAR(6),pm.start_date,112)+'01' AS date) ELSE NULL END AS first_mon_date,
						f.medid AS md_id,
						pm.enc_id,
						pm.medid AS rx_id,
						pm.gcn_seqno AS gcnsecno,
						pm.medication_name AS drug_name,
						pm.ndc_id AS ndc,
						p.med_rec_nbr,
						erx.pharmacy_id AS store_id,
						(CASE WHEN ISDATE(pm.start_date)=1 THEN cast (pm.start_date AS DATE) END) AS start_date,
						(CASE WHEN ISDATE(pm.expiration_date)=1 THEN cast(pm.expiration_date AS DATE) end) AS expire_date,
						prov.description AS provider_name,
						um.last_name+ ','+um.first_name AS userName,
						CASE WHEN prov.description LIKE ('%'+um.last_name+'%') THEN 0 ELSE 1 END RxNotbyProv,
						per.last_name + ', ' + per.first_name AS PatName ,
                        per.date_of_birth AS birth_date ,
                        RIGHT(p.med_rec_nbr, 6) AS chart_id ,
                        per.ssn ,
                        pm.sig_desc AS sig_text ,
                        ( CASE WHEN ISNUMERIC(pm.rx_quanity) = 1 THEN CAST(ROUND(pm.rx_quanity, 0) AS INT)
                               ELSE 0
                          END ) AS written_qty ,
                        ( CASE WHEN ISNUMERIC(pm.refills_left) = 1 THEN CAST(ROUND(pm.refills_left, 0) AS INT)
                               ELSE 0
                          END ) AS refills_left ,
                        ( CASE WHEN ISNUMERIC(pm.org_refills) = 1 THEN CAST(ROUND(pm.org_refills, 0) AS INT)
                               ELSE 0
                          END ) AS refills_orig ,
                        pharma.name AS SentTo ,
                        lm.location_name AS clinic ,
                        f.med_ref_dea_class_code AS drug_dea_class ,
                        CASE WHEN pa.operation_type = 'P' THEN 'Print'
                             WHEN pa.operation_type = 'E' THEN 'eRx'
                             WHEN pa.operation_type = 'F' THEN 'Fax'
                             WHEN pa.operation_type = 'D' THEN 'DAP'
                        END operation_type ,
                        SUBSTRING(CONVERT(VARCHAR(8), CONVERT(DATETIME, pm.start_date, 101), 3), 4, 5) AS mmyy ,
                        ( CASE WHEN f.med_ref_dea_class_code = 0 THEN 1
                               ELSE 0
                          END ) AS Total_Non_Controlled ,
                        ( CASE WHEN f.med_ref_dea_class_code <> 0 THEN 1
                               ELSE 0
                          END ) AS Total_Controlled ,
                        ( CASE WHEN f.med_ref_dea_class_code = 1 THEN 1
                               ELSE 0
                          END ) AS Sched_I ,
                        ( CASE WHEN f.med_ref_dea_class_code = 2 THEN 1
                               ELSE 0
                          END ) AS Sched_II ,
                        ( CASE WHEN f.med_ref_dea_class_code = 3 THEN 1
                               ELSE 0
                          END ) AS Sched_III ,
                        ( CASE WHEN f.med_ref_dea_class_code = 4 THEN 1
                               ELSE 0
                          END ) AS Sched_IV ,
                        ( CASE WHEN f.med_ref_dea_class_code = 5 THEN 1
                               ELSE 0
                          END ) AS Sched_V
						  INTO #temp_pharmacy
FROM [10.183.0.94].[NGProd].[dbo].person per
INNER JOIN [10.183.0.94].[NGProd].[dbo].patient_medication pm ON per.person_id=pm.person_id
INNER JOIN [10.183.0.94].[NGProd].dbo.patient p ON p.person_id=per.person_id
INNER JOIN [10.183.0.94].[NGProd].dbo.provider_mstr prov ON pm.provider_id=prov.provider_id
INNER JOIN [10.183.0.94].[NGProd].dbo.location_mstr lm ON pm.location_id=lm.location_id
INNER JOIN [10.183.0.94].[NGProd].dbo.fdb_med_mstr f ON pm.medid=f.medid AND pm.gcn_seqno=f.gcn_seqno
INNER JOIN [10.183.0.94].[NGProd].dbo.erx_message_history erx ON per.person_id=erx.person_id
INNER JOIN [10.183.0.94].[NGProd].dbo.med_rx_notes med ON erx.medication_id=med.medication_id
INNER JOIN [10.183.0.94].[NGProd].dbo.pharmacy_mstr pharma ON erx.pharmacy_id=pharma.pharmacy_id
INNER JOIN [10.183.0.94].[NGProd].dbo.user_mstr um ON pm.created_by=um.user_id
LEFT JOIN [10.183.0.94].[NGProd].dbo.prescription_audit pa ON pm.enc_id=pa.enc_id
WHERE pm.start_date >=@start_date
AND pm.start_date<=@end_date
AND pa.operation_type <>''
AND lm.location_id IN (SELECT location_id FROM dwh.data_location);




  INSERT  INTO dwh.data_pharmacy_rx
          (
            person_id ,
            location_id ,
            enc_id ,
            provider_id ,
            first_mon_date ,
            md_id ,
            rx_id ,
            gcnsecno ,
            drug_name ,
            ndc ,
            med_rec_nbr ,
            store_id ,
            start_date ,
            expire_date ,
            provider_name ,
            userName ,
            RxNotbyProv ,
            PatName ,
            birth_date ,
            chart_id ,
            ssn ,
            sig_text ,
            written_qty ,
            refills_left ,
            refills_orig ,
            SentTo ,
            clinic ,
            drug_dea_class ,
            operation_type ,
            mmyy ,
            Total_Non_Controlled ,
            Total_Controlled ,
            Sched_I ,
            Sched_II ,
            Sched_III ,
            Sched_IV ,
            Sched_V
          )
             
SELECT per.per_mon_id,
lc.location_key,
ph.enc_id,
ph.provider_id,
ph.first_mon_date,
ph.md_id,
ph.rx_id,
ph.gcnsecno,
ph.drug_name,
ph.ndc,
ph.med_rec_nbr,
ph.store_id,
ph.start_date,
ph.expire_date,
ph.provider_name,
ph.userName,
ph.RxNotbyProv,
ph.PatName,
ph.birth_date,
ph.chart_id,
ph.snn,
ph.sig_text,
ph.written_qty,
ph.refills_left,
ph.refills_orig,
ph.SentTo,
ph.clinic,
ph.drug_dea_class,
ph.operation_type,
ph.mmyy,
ph.Total_Non_Controlled,
ph.Total_Controlled,
ph.Sched_I,
ph.Sched_II,
ph.Sched_III,
ph.Sched_IV,
ph.Sched_V
FROM #temp_pharmacy ph 
LEFT OUTER JOIN [dwh].data_person_nd_month per ON ph.person_id=per.person_id
LEFT OUTER JOIN [dwh].data_appointment app ON ph.enc_id=app.enc_id AND ph.person_id= app.person_id
LEFT OUTER JOIN [dwh].data_location lc ON ph.location_id=lc.location_id 


		
        ALTER TABLE Prod_Ghost.dwh.data_pharmacy_rx
        ADD CONSTRAINT enc_appt_key_PK PRIMARY KEY (pharmacy_key);	 


END
GO
