USE [VLRDatabase]
GO
/****** Object:  User [MOBILE-WIN\Rustem.Saidaliyev]    Script Date: 11.02.2016 17:14:59 ******/
CREATE USER [MOBILE-WIN\Rustem.Saidaliyev] FOR LOGIN [MOBILE-WIN\Rustem.Saidaliyev] WITH DEFAULT_SCHEMA=[db_datareader]
GO
ALTER ROLE [db_owner] ADD MEMBER [MOBILE-WIN\Rustem.Saidaliyev]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [MOBILE-WIN\Rustem.Saidaliyev]
GO
ALTER ROLE [db_datareader] ADD MEMBER [MOBILE-WIN\Rustem.Saidaliyev]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [MOBILE-WIN\Rustem.Saidaliyev]
GO
