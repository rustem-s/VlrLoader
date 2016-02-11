USE [VLRDatabase]
GO
/****** Object:  User [clientvlr]    Script Date: 11.02.2016 17:14:59 ******/
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
