USE [VLRDatabase]
GO
/****** Object:  Table [dbo].[REP_01_TOTAL_BY_MONTH]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REP_01_TOTAL_BY_MONTH](
	[id_ref_year] [numeric](18, 0) NOT NULL,
	[id_ref_month] [numeric](18, 0) NOT NULL,
	[msisdn_count] [numeric](18, 0) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[REP_01_TOTAL_BY_MONTH]  WITH CHECK ADD  CONSTRAINT [fk_rep_01_total_by_month_m] FOREIGN KEY([id_ref_month])
REFERENCES [dbo].[REF_MONTH] ([ID])
GO
ALTER TABLE [dbo].[REP_01_TOTAL_BY_MONTH] CHECK CONSTRAINT [fk_rep_01_total_by_month_m]
GO
ALTER TABLE [dbo].[REP_01_TOTAL_BY_MONTH]  WITH CHECK ADD  CONSTRAINT [fk_rep_01_total_by_month_y] FOREIGN KEY([id_ref_year])
REFERENCES [dbo].[REF_YEAR] ([ID])
GO
ALTER TABLE [dbo].[REP_01_TOTAL_BY_MONTH] CHECK CONSTRAINT [fk_rep_01_total_by_month_y]
GO
