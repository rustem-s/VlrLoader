USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[REP_01_DAY_OTHERS]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[REP_01_DAY_OTHERS](
	[ACCESSING_DATE] [date] NOT NULL,
	[MSISDN_PREFIX] [varchar](6) NOT NULL,
	[MSISDN_COUNT] [numeric](18, 0) NOT NULL,
	[MSISDN_ADDS_COUNT] [numeric](18, 0) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
