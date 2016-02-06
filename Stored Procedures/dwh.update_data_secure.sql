SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dwh].[update_data_secure]


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

/*	
sp_configure 'Show Advanced Options', 1;
RECONFIGURE;
GO
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 0
GO

--iF YOU GET AN ERROR AND THE TXT OR EXCEL FILE db will not initialize, change the AllowinProcess from 0 to 1 or vice versa -- this seems to get it working again


EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO



SELECT * INTO dwh.secure_ADP FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
  'Text;Database=C:\temp;HDR=Yes;FORMAT=Delimited(,)', 'select * from [ADPDataset.csv]')




SELECT * INTO dwh.secure__ADP_allocation FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
  'Text;Database=C:\temp;HDR=Yes;FORMAT=Delimited(,)', 'select * from [AllocationDataset.csv]')

  */


SELECT * INTO dwh.data_secure FROM [SQL2014-DEV\SQLDEVGHOST].Staging_Ghost.dwh.secure

SELECT * INTO dwh.data_secure_allocation FROM [SQL2014-DEV\SQLDEVGHOST].Staging_Ghost.dwh.secure_allocation




END
GO
