USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01_total_by_day]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 21.09.2015
-- Description:	Fill TOTAL by DAY data of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01_total_by_day] 
	@date date, 
	@msisdn_table msisdn_table_type readonly
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	insert into REP_01_TOTAL_BY_DAY(ACCESSING_DATE, MSISDN_COUNT)
	select
		@date,
		count(distinct msisdn)
	from @msisdn_table;
	
END




GO
