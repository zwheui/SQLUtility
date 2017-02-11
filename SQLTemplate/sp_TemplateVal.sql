IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE name = 'sp_TemplateVal'
          AND type = 'P'
)
    DROP PROCEDURE sp_TemplateVal;

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================  
-- Author:  Tom Zhu  
-- Create Date: Feb 11 2017
-- Description: Validation store procedure
-- =============================================  
CREATE PROCEDURE [dbo].sp_TemplateVal @Param01 INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RET BIT;
    DECLARE @ERRMSG NVARCHAR(100);
    SET @ERRMSG = '';

    IF EXISTS
    (
        SELECT 'X'
        FROM dbo.tbl_Table
        WHERE Param01 = @Param01
    )
    BEGIN
        SET @RET = 1;
    END;

    SELECT ISNULL(@ERRMSG, '');

    PRINT @RET;
    RETURN ISNULL(@RET, 0);
END;
GO