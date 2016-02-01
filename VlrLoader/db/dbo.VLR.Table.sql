USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[VLR]    Script Date: 31.01.2016 18:58:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VLR](
	[ID] [bigint] NOT NULL,
	[CODREG] [varchar](5) NULL,
	[CODAREA] [varchar](4) NULL,
	[CODDISTR] [varchar](4) NULL,
	[IMSI] [varchar](40) NULL,
	[MSISDN] [varchar](40) NOT NULL,
	[IMEI] [varchar](40) NULL,
	[ID_VLR_FILE] [bigint] NOT NULL,
	[ACCESSING_DATE] [date] NULL,
	[ACCESSING_TIME] [time](7) NULL,
 CONSTRAINT [PK_VLR] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [I_VLR_AD]    Script Date: 31.01.2016 18:58:02 ******/
CREATE NONCLUSTERED INDEX [I_VLR_AD] ON [dbo].[VLR]
(
	[ACCESSING_DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
