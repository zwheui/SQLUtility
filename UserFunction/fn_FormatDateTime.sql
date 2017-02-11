IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[fn_FormatDateTime]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
    DROP FUNCTION [dbo].fn_FormatDateTime
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Tom Zhu
-- Create date: Feb 11 2017
-- Description: SELECT  [dbo].[fn_FormatDateTime](GETDATE(), DEFAULT)
-- =============================================
CREATE FUNCTION [dbo].[fn_FormatDateTime]
    (
      @INPUT DATETIME ,
      @FORMAT NVARCHAR(50) = 'yyyy/MM/dd HH:mm:ss'
    )
RETURNS NVARCHAR(50)
AS
    BEGIN
        DECLARE @RET NVARCHAR(50)

        IF NOT @INPUT IS NULL
            SET @RET = FORMAT(@INPUT, @FORMAT)

        RETURN ISNULL(@RET, '')
    END
GO
