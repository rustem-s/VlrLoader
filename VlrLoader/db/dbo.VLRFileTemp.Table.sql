USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[VLRFileTemp]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VLRFileTemp](
	[Data] [dbo].[D_CHAR20] NULL DEFAULT (sysdatetime()),
	[NameFile] [dbo].[D_CHAR60] NULL,
	[Flag] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
