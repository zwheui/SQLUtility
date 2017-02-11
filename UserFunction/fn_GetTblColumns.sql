
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[fn_GetTblColumns]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
    DROP FUNCTION [dbo].fn_GetTblColumns
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Tom Zhu
-- Create date: Feb 08 2017
-- Description:	Return table column names with comma separated
-- SELECT dbo.fn_GetTblColumns('table_name')
-- =============================================
CREATE FUNCTION [dbo].fn_GetTblColumns ( @TBL_NAME NVARCHAR(500) )
RETURNS NVARCHAR(MAX)
AS
    BEGIN
        DECLARE @RET NVARCHAR(MAX)
        SET @RET = ''

        SELECT  @RET = @RET + '[' + [COLUMN_NAME] + '],'
        FROM    INFORMATION_SCHEMA.COLUMNS
        WHERE   TABLE_NAME = @TBL_NAME

        SET @RET = SUBSTRING(@RET, 1, LEN(@RET) - 1)

        RETURN ISNULL(@RET,'')
    END
GO
