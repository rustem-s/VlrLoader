USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[REFAREA]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[REFAREA](
	[CODCTR] [dbo].[D_CHAR3] NOT NULL,
	[CODREG] [dbo].[D_CHAR5] NOT NULL,
	[CODAREA] [dbo].[D_CHAR4] NOT NULL,
	[NAMEAREA] [dbo].[D_CHAR110] NULL,
	[DESCR] [dbo].[D_BLOB] NULL,
	[ID] [bigint] NOT NULL,
 CONSTRAINT [PK_REF_AREA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_REF_AREA_CRA] UNIQUE NONCLUSTERED 
(
	[CODCTR] ASC,
	[CODREG] ASC,
	[CODAREA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[REFAREA]  WITH CHECK ADD  CONSTRAINT [FK_REFAREA_R] FOREIGN KEY([CODCTR], [CODREG])
REFERENCES [dbo].[REFREG] ([CODCTR], [CODREG])
GO
ALTER TABLE [dbo].[REFAREA] CHECK CONSTRAINT [FK_REFAREA_R]
GO
