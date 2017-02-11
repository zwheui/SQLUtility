IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   name = 'sp_InitTopTables'
                    AND Type = 'P' )
    DROP PROCEDURE sp_InitTopTables

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================  
-- Author:		Tom Zhu
-- Create date: Feb 08 2017
-- Description: Loop all the tables from current database
-- clear the data which is not in the Top @Top
-- exec sp_InitTopTables
-- =============================================  
CREATE PROC sp_InitTopTables @Top INT = 1000
AS
    BEGIN
        DECLARE @SQL NVARCHAR(MAX)
        DECLARE @TBL NVARCHAR(500)
        DECLARE @TopSTR NVARCHAR(10)
        DECLARE @COL_NAMES NVARCHAR(MAX)

        SET @TopSTR = CAST(@top AS NVARCHAR(10))

        SET @SQL = ''

        DECLARE @TBL_Names TABLE
            (
              ROWINDEX INT IDENTITY(1, 1) ,
              TBL_NAME NVARCHAR(500)
            )

        INSERT  INTO @TBL_Names
                ( TBL_NAME
                )
                SELECT  [TABLE_NAME]
                FROM    INFORMATION_SCHEMA.TABLES
                WHERE   TABLE_TYPE = 'BASE TABLE'

        DECLARE @ROW_COUNT INT
        DECLARE @I INT

        SET @I = 1

        SELECT  @ROW_COUNT = COUNT(*)
        FROM    @TBL_Names


        WHILE @I <= @ROW_COUNT
            BEGIN
                SELECT  @TBL = TBL_NAME
                FROM    @TBL_Names
                WHERE   ROWINDEX = @I

                SET @COL_NAMES = dbo.fn_GetTblColumns(@TBL)


                SET @SQL = ''
                SET @SQL = @SQL + 'SELECT TOP ' + @TopSTR + ' * INTO [' + @TBL
                    + '_BackUpXXXX] FROM [' + @TBL + '];'
                SET @SQL = @SQL + 'TRUNCATE TABLE [' + @TBL + '];'

                IF EXISTS ( SELECT  *
                            FROM    syscolumns
                            WHERE   id = OBJECT_ID(@TBL)
                                    AND colstat & 1 = 1 )
                    BEGIN
                        SET @SQL = @SQL + 'SET IDENTITY_INSERT [' + @TBL
                            + '] ON;'
                    END

                SET @SQL = @SQL + 'INSERT  INTO [' + @TBL + '](' + @COL_NAMES
                    + ') SELECT ' + @COL_NAMES + ' FROM [' + @TBL
                    + '_BackUpXXXX];'

                IF EXISTS ( SELECT  *
                            FROM    syscolumns
                            WHERE   id = OBJECT_ID(@TBL)
                                    AND colstat & 1 = 1 )
                    BEGIN
                        SET @SQL = @SQL + 'SET IDENTITY_INSERT [' + @TBL
                            + '] OFF;'
                    END

                SET @SQL = @SQL + 'DROP TABLE [' + @TBL + '_BackUpXXXX];'

                PRINT @SQL

                EXEC sp_executesql @SQL

                SET @I = @I + 1

            END
    END
GO
