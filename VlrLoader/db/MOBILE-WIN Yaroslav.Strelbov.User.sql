USE [VLRDatabase]
GO
/****** Object:  User [MOBILE-WIN\Yaroslav.Strelbov]    Script Date: 31.01.2016 18:58:02 ******/
CREATE USER [MOBILE-WIN\Yaroslav.Strelbov] FOR LOGIN [MOBILE-WIN\Yaroslav.Strelbov] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [MOBILE-WIN\Yaroslav.Strelbov]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [MOBILE-WIN\Yaroslav.Strelbov]
GO
ALTER ROLE [db_datareader] ADD MEMBER [MOBILE-WIN\Yaroslav.Strelbov]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [MOBILE-WIN\Yaroslav.Strelbov]
GO
