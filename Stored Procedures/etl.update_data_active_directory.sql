SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[update_data_active_directory]
AS
SET NOCOUNT ON
/* AD is limited to send 1000 records in one batch. to work around this limit we loop through the alphabet. */

DECLARE @cmdstr varchar (255)

DECLARE @nAsciiValue smallint

DECLARE @sChar char (1)

SELECT @nAsciiValue = 65

WHILE @nAsciiValue < 91

BEGIN

SELECT @sChar= CHAR( @nAsciiValue)

/*Stores the query in a string for reuse, loops by SAMAccountName (a unique ID) first letter, from A-Z
  LDAP://DC=lmc, DC=local is connection string to Active Directory via LDAP protocol
  ADSI is the linked server which represents the Active Directory. It can only be queried from the server it
  is linked to, may not log into SSMS from another machine and attempt to run the query
  */
EXEC master ..xp_sprintf @cmdstr OUTPUT, 'SELECT mail, sn, givenName

FROM OPENQUERY( ADSI, ''SELECT givenName, sn, mail

FROM ''''LDAP://DC=lmc, DC=local''''WHERE objectCategory = ''''Person'''' AND SAMAccountName = ''''%s*'''''' )', @sChar


INSERT etl.data_active_directory EXEC ( @cmdstr )

--Increment the loop counter (in this case go to the next letter)
SELECT @nAsciiValue = @nAsciiValue + 1

END
GO
