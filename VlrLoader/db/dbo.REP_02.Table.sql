USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[REP_02]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REP_02](
	[id_ref_operator] [int] NOT NULL,
	[day_count] [numeric](18, 0) NOT NULL,
	[msisdn_count] [numeric](18, 0) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[REP_02]  WITH CHECK ADD  CONSTRAINT [fk_rep_02_o] FOREIGN KEY([id_ref_operator])
REFERENCES [dbo].[REF_OPERATOR] ([ID])
GO
ALTER TABLE [dbo].[REP_02] CHECK CONSTRAINT [fk_rep_02_o]
GO
