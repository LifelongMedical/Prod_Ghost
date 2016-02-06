SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [fdt].[update_drop_constraints] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


DECLARE @SQL TABLE (Command VARCHAR(MAX))

INSERT @SQL
SELECT 'ALTER TABLE ['+fk.constraint_schema+'].[' + FK.TABLE_NAME + '] DROP CONSTRAINT [' + RTRIM(C.CONSTRAINT_NAME) +'];' + CHAR(13)
  FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
 INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK
    ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
 INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK
    ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
 INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU
    ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
 INNER JOIN (
            SELECT i1.TABLE_NAME, i2.COLUMN_NAME
              FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
             INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2
                ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
            WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
           ) PT
    ON PT.TABLE_NAME = PK.TABLE_NAME

DECLARE cmdCursor CURSOR
    FOR SELECT Command FROM @SQL
OPEN cmdCursor
DECLARE @Command VARCHAR(MAX)

FETCH NEXT FROM cmdCursor INTO @Command
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @Command
    EXEC (@Command)
    FETCH NEXT FROM cmdCursor INTO @Command
END

CLOSE cmdCursor;
DEALLOCATE cmdCursor;






    -- Insert statements for procedure here
	

END
GO
