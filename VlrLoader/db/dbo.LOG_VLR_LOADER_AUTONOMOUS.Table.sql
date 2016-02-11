USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[LOG_VLR_LOADER_AUTONOMOUS]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOG_VLR_LOADER_AUTONOMOUS](
	[EVENT_TIME] [datetime] NOT NULL,
	[VLR_DATE] [date] NOT NULL,
	[ERROR_MESSAGE] [varchar](4000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LOG_VLR_LOADER_AUTONOMOUS] ADD  CONSTRAINT [DF_LOG_VLR_LOADER_AUTONOMOUS_EVENT_TIME]  DEFAULT (getdate()) FOR [EVENT_TIME]
GO
