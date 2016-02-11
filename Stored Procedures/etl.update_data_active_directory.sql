
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[update_data_active_directory]
AS
 -- =============================================
-- Author:    <Julius Abate>
-- Create date: <Feb 03, 2016>
-- Description: <A procedure to bring fields from Active Directory into a SQL Server Table>
-- Modified: 2/11/16 <Julius Abate> -  Added comments for documentation
-- =============================================



--Prevents row counts returned from SELECT statement slowing down the query
SET NOCOUNT ON

--Allow for "Dirty Reads"
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



/* AD is limited to send 1000 records in one batch. to work around this limit we loop through the alphabet. */

DECLARE @cmdstr varchar (255)

DECLARE @nAsciiValue smallint

DECLARE @sChar char (1)

SELECT @nAsciiValue = 65

WHILE @nAsciiValue < 91

BEGIN

SELECT @sChar= CHAR( @nAsciiValue)

/*Stores the query in a string for reuse, loops by SAMAccountName (a unique ID) first letter, from A-Z
  LDAP://DC=lmc, DC=local is a UNIQUE connection string to Active Directory via LDAP protocol, must be customized
  for your organization's directory.
  ADSI is a Linked Server to Active Directory, created in SSMS. You can only run queries on it when remoting into
  the server it is linked to, may not log into SSMS from a third machine and attempt to run the query
  */


--String to hold the query for each loop, @sChar is the first letter we are currently searching by
EXEC master ..xp_sprintf @cmdstr OUTPUT, 'SELECT mail, sn, givenName

FROM OPENQUERY( ADSI, ''SELECT givenName, sn, mail

FROM ''''LDAP://DC=lmc, DC=local''''WHERE objectCategory = ''''Person'''' AND SAMAccountName = ''''%s*'''''' )', @sChar

--For all available columns in active directory, see  http://www.kouti.com/tables/userattributes.htm


--Insert each dataset (A-Z) into the table holding active directory
INSERT etl.data_active_directory EXEC ( @cmdstr )

--Increment the loop counter (in this case go to the next letter)
SELECT @nAsciiValue = @nAsciiValue + 1

END
GO
