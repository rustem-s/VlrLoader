USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[VLR_TEMP]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VLR_TEMP](
	[IMSI] [varchar](100) NULL,
	[MSISDN] [varchar](100) NULL,
	[IMEI] [varchar](100) NULL,
	[ACCESSING_TIME] [varchar](100) NULL,
	[USER_CURRENT_STATUS] [varchar](100) NULL,
	[GCISAI] [varchar](100) NULL,
	[ID_VLR_FILE] [bigint] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[VLR_TEMP]  WITH NOCHECK ADD  CONSTRAINT [FK_VLR_TEMP_F] FOREIGN KEY([ID_VLR_FILE])
REFERENCES [dbo].[VLR_FILE] ([ID])
GO
ALTER TABLE [dbo].[VLR_TEMP] CHECK CONSTRAINT [FK_VLR_TEMP_F]
GO
