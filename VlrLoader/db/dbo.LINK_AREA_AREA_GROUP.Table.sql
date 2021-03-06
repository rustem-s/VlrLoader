USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[LINK_AREA_AREA_GROUP]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LINK_AREA_AREA_GROUP](
	[ID] [bigint] NOT NULL,
	[ID_REF_AREA] [bigint] NOT NULL,
	[ID_REF_AREA_GROUP] [bigint] NOT NULL,
 CONSTRAINT [PK_LINK_AREA_AREA_GROUP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[LINK_AREA_AREA_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_LINK_AREA_AREA_GROUP_RA] FOREIGN KEY([ID_REF_AREA])
REFERENCES [dbo].[REFAREA] ([ID])
GO
ALTER TABLE [dbo].[LINK_AREA_AREA_GROUP] CHECK CONSTRAINT [FK_LINK_AREA_AREA_GROUP_RA]
GO
ALTER TABLE [dbo].[LINK_AREA_AREA_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_LINK_AREA_AREA_GROUP_RAG] FOREIGN KEY([ID_REF_AREA_GROUP])
REFERENCES [dbo].[REF_AREA_GROUP] ([ID])
GO
ALTER TABLE [dbo].[LINK_AREA_AREA_GROUP] CHECK CONSTRAINT [FK_LINK_AREA_AREA_GROUP_RAG]
GO
