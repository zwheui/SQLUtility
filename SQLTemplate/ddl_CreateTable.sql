-- =============================================  
-- Author:      Tom Zhu
-- Create date: Feb 11 2017
-- Description: Template for CREATE TABLE
-- ============================================= 
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

PRINT 'Create Table';

CREATE TABLE [dbo].[tB_TemplateTable]
(
    [ID] [INT] IDENTITY(1, 1) NOT NULL,
    [NAME] [NVARCHAR](100) NULL,
    [CREATEDBY] NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    [CREATEDDATE] [DATETIME] NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_tB_TemplateTable]
        PRIMARY KEY CLUSTERED ([ID] ASC) ON [PRIMARY]
) ON [PRIMARY];

GO
