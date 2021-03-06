USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01_month_total_by_period]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 17.09.2015
-- Description:	Fill TOTAL by MONTH data of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01_month_total_by_period] @start_date date, @end_date date
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare 
		@min_date date,
		@last_date_of_month date,
		@year int,
		@month int,
		@msisdn_count varchar(10);

	set @min_date = 
	(
		select min(accessing_date)
		from vlr
	);

	delete from rep_01_total_by_month
	where
		datefromparts (id_ref_year, id_ref_month, 1) between dateadd(month, datediff(month, 0, @start_date), 0) and dateadd(month, datediff(month, 0, @end_date), 0);

	declare month_cursor cursor for
		select
		    year(accessing_date) year,
			month(accessing_date) month,
			eomonth( datefromparts(year(accessing_date), month(accessing_date), 1)) last_date_of_month
		from vlr
		where
			accessing_date between @start_date and @end_date
		group by year(accessing_date), month(accessing_date)
		order by year(accessing_date), month(accessing_date)
	open month_cursor;

	fetch next from month_cursor into @year, @month, @last_date_of_month;
	while @@fetch_status = 0
	begin

		insert into rep_01_total_by_month(id_ref_year, id_ref_month, msisdn_count)
		select 
			@year,
			@month,
			count(distinct MSISDN)
		from 
			VLR
		where 
			accessing_date between @min_date and @last_date_of_month

		fetch next from month_cursor into @year, @month, @last_date_of_month;
	end;

	close month_cursor;
	deallocate month_cursor;


END



GO
