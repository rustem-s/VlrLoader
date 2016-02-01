USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[VLRdir]    Script Date: 31.01.2016 18:58:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VLRdir](
	[Data] [dbo].[D_CHAR12] NULL,
	[Ttime] [dbo].[D_CHAR10] NULL,
	[Tip] [dbo].[D_CHAR15] NULL,
	[NameDir] [dbo].[D_CHAR50] NOT NULL,
	[Priznak] [dbo].[D_CHAR2] NULL,
 CONSTRAINT [PK_VLRDir] PRIMARY KEY CLUSTERED 
(
	[NameDir] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
