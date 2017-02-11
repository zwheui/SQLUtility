-- =============================================  
-- Author:      Tom Zhu
-- Create date: Feb 11 2017
-- Description: Template for Link Server
-- ============================================= 

-- Create linkServer
EXEC sp_addlinkedserver 'lnk_Name','','SQLOLEDB','XXX.chinacloudapp.cn\SQLInstanse,1433' 
-- Login linkServer
EXEC sp_addlinkedsrvlogin 'lnk_Name','false',null,'sa','password'
EXEC sp_helpserver
-- EXEC sp_dropserver 'lnk_Name ', 'droplogins'