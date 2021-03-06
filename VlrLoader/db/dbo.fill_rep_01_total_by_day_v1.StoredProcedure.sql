USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01_total_by_day_v1]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 21.09.2015
-- Description:	Fill TOTAL by DAY data of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01_total_by_day_v1] @start_date date, @end_date date
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	delete from REP_01_TOTAL_BY_DAY
	where accessing_date between @start_date and @end_date;

	insert into REP_01_TOTAL_BY_DAY(ACCESSING_DATE, MSISDN_COUNT)
	select
		accessing_date,
		count(distinct msisdn)
	from vlr
	where
		accessing_date between @start_date and @end_date
	group by accessing_date
	order by accessing_date;

END




GO
