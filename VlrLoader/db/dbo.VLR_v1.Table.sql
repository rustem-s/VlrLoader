USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[VLR_v1]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VLR_v1](
	[VLRID] [uniqueidentifier] NOT NULL,
	[CODCTR] [dbo].[D_CHAR3] NULL,
	[CODREG] [dbo].[D_CHAR5] NULL,
	[CODAREA] [dbo].[D_CHAR4] NULL,
	[CODDISTR] [dbo].[D_CHAR4] NULL,
	[IMSI] [dbo].[D_CHAR40] NULL,
	[MSISDN] [dbo].[D_CHAR40] NULL,
	[IMEI] [dbo].[D_CHAR40] NULL,
	[AccessingTime] [datetime2](7) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[VLR_v1] ADD  DEFAULT (newid()) FOR [VLRID]
GO
