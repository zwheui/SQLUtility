
IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   name = 'sp_HelpTextPlus'
                    AND Type = 'P' )
    DROP PROCEDURE sp_HelpTextPlus

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================  
-- Author:		Tom Zhu
-- Create date: Feb 11 2017
-- Description: Since the sp_Helptext will break line if the line is too long
-- we can define this SP in the SSMS Keyboard shortcut setting
-- exec sp_HelpTextPlus
-- =============================================  
CREATE PROC sp_HelpTextPlus @SPNAME NVARCHAR(255)
AS
    BEGIN
        DECLARE @objname NVARCHAR(776) = @SPNAME;

        DECLARE @ObjectText NVARCHAR(MAX)= '';
        DECLARE @SyscomText NVARCHAR(MAX);
        DECLARE @LineLen INT;
        DECLARE @LineEnd BIT = 0;
        DECLARE @CommentText TABLE
            (
              LineId INT IDENTITY(1, 1) ,
              Text NVARCHAR(MAX) COLLATE catalog_default
            );

        DECLARE ms_crs_syscom CURSOR LOCAL
        FOR
            SELECT  text
            FROM    sys.syscomments
            WHERE   id = OBJECT_ID(@objname)
                    AND encrypted = 0
            ORDER BY number ,
                    colid FOR READ ONLY

        OPEN ms_crs_syscom
        FETCH NEXT FROM ms_crs_syscom INTO @SyscomText

        WHILE @@fetch_status >= 0
            BEGIN
                SET @LineLen = CHARINDEX(CHAR(10), @SyscomText);
                WHILE @LineLen > 0
                    BEGIN

                        SELECT  @ObjectText += LEFT(@SyscomText, @LineLen) ,
                                @SyscomText = SUBSTRING(@SyscomText,
                                                        @LineLen + 1, 4000) ,
                                @LineLen = CHARINDEX(CHAR(10), @SyscomText) ,
                                @LineEnd = 1;
             
                        INSERT  INTO @CommentText
                                ( Text )
                        VALUES  ( @ObjectText )

                        SET @ObjectText = '';
                    END

                IF @LineLen = 0
                    SET @ObjectText += @SyscomText;
                ELSE
                    SELECT  @ObjectText = @SyscomText ,
                            @LineLen = 0;

                FETCH NEXT FROM ms_crs_syscom INTO @SyscomText
            END

        CLOSE  ms_crs_syscom;
        DEALLOCATE    ms_crs_syscom;

        INSERT  INTO @CommentText
                ( Text )
                SELECT  @ObjectText;

        SELECT  text
        FROM    @CommentText
        ORDER BY LineId;

    END
GO
