USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[VLRTEMP]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VLRTEMP](
	[IMSI] [dbo].[D_CHAR40] NULL,
	[MSISDN] [dbo].[D_CHAR40] NULL,
	[IMEI] [dbo].[D_CHAR40] NULL,
	[LatestAccessingTime] [dbo].[D_CHAR34] NULL,
	[UserCurrentStatus] [dbo].[D_CHAR12] NULL,
	[GCISAI] [dbo].[D_CHAR23] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
