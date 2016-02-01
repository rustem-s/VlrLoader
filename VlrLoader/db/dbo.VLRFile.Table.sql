USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[VLRFile]    Script Date: 31.01.2016 18:58:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VLRFile](
	[Data] [dbo].[D_CHAR12] NULL DEFAULT (sysdatetime()),
	[NameFile] [dbo].[D_CHAR60] NULL,
	[Flag] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
