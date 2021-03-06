USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 14.08.2015
-- Description:	Fill tables of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01] 
	@date date,
	@msisdn_table msisdn_table_type readonly,
	@aggregate_months bit
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- basic mobile operators

	exec fill_rep_01_day @date, @msisdn_table;

	-- others
	
	exec fill_rep_01_day_others @date, @msisdn_table;

	-- total by days
	
	exec fill_rep_01_total_by_day @date, @msisdn_table;

	if @aggregate_months = 1
	begin

		-- total by month
		exec fill_rep_01_month_by_date @date;
		--exec fill_rep_01_month_by_period @start_date, @end_date;

		exec fill_rep_01_month_total_by_date @date;
		--exec fill_rep_01_month_total_by_period @start_date, @end_date;

		exec fill_rep_01_others_month_total_by_date @date;
		--exec fill_rep_01_others_month_total_by_period @start_date, @end_date;
	end
END


GO
