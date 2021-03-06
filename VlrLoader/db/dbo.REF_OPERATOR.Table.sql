USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[REF_OPERATOR]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[REF_OPERATOR](
	[ID] [int] NOT NULL,
	[NAME] [varchar](50) NOT NULL,
	[PREFIX] [varchar](50) NULL,
 CONSTRAINT [PK_rep_01_ref_operator_01] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
