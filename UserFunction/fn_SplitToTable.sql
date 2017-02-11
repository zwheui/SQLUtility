IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[fn_SplitToTable]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
    DROP FUNCTION [dbo].fn_SplitToTable
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Tom Zhu
-- Create date: Nov 10 2014
-- Description:	Split by SQL
-- SELECT [ID], [VALUE] FROM [dbo].[fn_SplitToTable]('a,b,c,d', DEFAULT)
-- =============================================
CREATE FUNCTION [dbo].[fn_SplitToTable]
    (
      @SplitString NVARCHAR(MAX) ,
      @Separator NVARCHAR(10) = ','
    )
RETURNS @RET TABLE
    (
      [ID] INT IDENTITY(1, 1) ,
      [VALUE] NVARCHAR(MAX)
    )
AS
    BEGIN
        DECLARE @CurrentIndex INT
        DECLARE @NextIndex INT
        DECLARE @ReturnText NVARCHAR(MAX)
        SELECT  @CurrentIndex = 1
	
        WHILE ( @CurrentIndex <= LEN(@SplitString) )
            BEGIN
                SELECT  @NextIndex = CHARINDEX(@Separator, @SplitString,
                                               @CurrentIndex)
                IF ( @NextIndex = 0
                     OR @NextIndex IS NULL
                   )
                    SELECT  @NextIndex = LEN(@SplitString) + 1
                SELECT  @ReturnText = SUBSTRING(@SplitString, @CurrentIndex,
                                                @NextIndex - @CurrentIndex)
                INSERT  INTO @RET
                        ( [VALUE] )
                VALUES  ( @ReturnText )

                SELECT  @CurrentIndex = @NextIndex + 1
            END

        RETURN
    END
GO
