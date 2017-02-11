IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE name = 'sp_TemplateLoop'
          AND type = 'P'
)
    DROP PROCEDURE sp_TemplateLoop;

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================  
-- Author:  Tom Zhu  
-- Create Date: Feb 11 2017
-- Description: Declare table variable and loop
-- =============================================  
CREATE PROCEDURE [dbo].[sp_TemplateLoop] @Param01 INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TBL_WHERE TABLE
    (ROWINDEX INT IDENTITY(1, 1),
        COLNAME NVARCHAR(100)
    );

    INSERT INTO @TBL_WHERE
    (COLNAME)
    SELECT [value]
    FROM dbo.fn_SplitToTable('A,B,C,D', ',');

    DECLARE @ROW_COUNT INT;
    DECLARE @I INT;
    DECLARE @COLNAME NVARCHAR(100);
    SET @I = 1;

    SELECT @ROW_COUNT = COUNT(*)
    FROM @TBL_WHERE;

    WHILE @I <= @ROW_COUNT
    BEGIN
        SELECT @COLNAME = COLNAME
        FROM @TBL_WHERE
        WHERE ROWINDEX = @I;

        -- Do something with @COLNAME

        SET @I = @I + 1;
    END;
END;
GO