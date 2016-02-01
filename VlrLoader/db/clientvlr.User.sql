USE [VLRDatabase]
GO
/****** Object:  User [clientvlr]    Script Date: 31.01.2016 18:58:02 ******/
CREATE USER [clientvlr] FOR LOGIN [clientvlr] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [clientvlr]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [clientvlr]
GO
ALTER ROLE [db_datareader] ADD MEMBER [clientvlr]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [clientvlr]
GO
