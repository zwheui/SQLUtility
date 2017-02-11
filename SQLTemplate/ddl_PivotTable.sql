-- =============================================  
-- Author:		Tom Zhu
-- Create date: Feb 11 2017
-- Description: Template for Declare a Table Variable and Loop it
-- ============================================= 
DECLARE @TBL_NAME NVARCHAR(50)
DECLARE @TOP NVARCHAR(10)

SET @TOP = '1'
SET @TBL_NAME = 'tbl_sources'

DECLARE @SQL NVARCHAR(MAX);

SET @SQL = '';
SET @SQL
    = @SQL + 'SELECT [column], [value] FROM (SELECT TOP ' + @TOP + ' ';

SELECT @SQL
    = @SQL + 'ISNULL(CAST([' + name + '] AS NVARCHAR(255)), '''') AS [' + name + '], '
FROM syscolumns
WHERE id =
      (
          SELECT MAX(id)
          FROM sysobjects
          WHERE xtype = 'u'
                AND name = @TBL_NAME
      );

SET @SQL = SUBSTRING(@SQL, 1, LEN(@SQL) - 1);
--PRINT @SQL
SET @SQL = @SQL + ' FROM ' + @TBL_NAME;
--SET @SQL = @SQL + ' WHERE TBL_NAME.Column = xx'
SET @SQL = @SQL + ' ) AS T1 UNPIVOT([Value] FOR [Column] IN( ';

SELECT @SQL = @SQL + '[' + name + '], '
FROM syscolumns
WHERE id =
      (
          SELECT MAX(id)
          FROM sysobjects
          WHERE xtype = 'u'
                AND name = @TBL_NAME
      );

SET @SQL = SUBSTRING(@SQL, 1, LEN(@SQL) - 1);

SET @SQL = @SQL + ' )) AS T2 ';

PRINT @SQL;

EXEC sp_executesql @SQL;

SET @SQL = 'SELECT TOP 1 * FROM ' + @TBL_NAME;
EXEC sp_executesql @SQL;
