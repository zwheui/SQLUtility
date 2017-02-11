IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[fn_TrimEnd]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
    DROP FUNCTION [dbo].[fn_TrimEnd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Tom Zhu  
-- Create Date: Oct 18 2015
-- Description: 
-- SELECT [dbo].[fn_TrimEnd] ('ABCD,')
-- =============================================  
CREATE FUNCTION [dbo].[fn_TrimEnd] ( @INPUT NVARCHAR(MAX) )
RETURNS NVARCHAR(MAX)
    WITH ENCRYPTION
AS
    BEGIN
        DECLARE @RET NVARCHAR(MAX)

        IF LEN(@INPUT) > 0
            SET @RET = SUBSTRING(@INPUT, 0, LEN(@INPUT))
            			  
        RETURN ISNULL(@RET, '')
    END
GO
