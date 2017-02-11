IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE name = 'sp_TemplateTran'
          AND type = 'P'
)
    DROP PROCEDURE sp_TemplateTran;

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================  
-- Author:  Tom Zhu  
-- Create Date: Feb 11 2017
-- Description: Store Procedure with Transaction and Try catch
-- =============================================  
CREATE PROCEDURE [dbo].[sp_TemplateTran] @Param01 INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Err NVARCHAR(MAX);

    BEGIN TRY
        BEGIN TRAN T1;

        -- Do some Insert Update Delete

        COMMIT TRAN T1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN T1;

        SET @Err = ERROR_MESSAGE();

        -- Add Log
        -- EXEC dbo.sp_AddSysErr sp_TemplateTran, @Err

        PRINT @Err;
    END CATCH;
END;
GO