USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01_others_month_total_by_date]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 17.09.2015
-- Description:	Fill OTHERS total by MONTH data of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01_others_month_total_by_date] @date date
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

	set @last_date_of_month = eomonth(@date);

	set @year = year(@date);
	set @month = month(@date);

	delete from rep_01_others_total_by_month
	where
		id_ref_year = @year
		and id_ref_month = @month;

	insert into rep_01_others_total_by_month(id_ref_year, id_ref_month, msisdn_prefix, msisdn_count)
	select 
		@year,
		@month,
		substring(msisdn, 1, 4),
		count(distinct MSISDN)
	from 
		VLR
	where 
		accessing_date between @min_date and @last_date_of_month
	and substring(MSISDN,1,5) not in ('79780', '79787', '79788', '79789') --'79781', 
	group by substring(msisdn, 1, 4)
	order by substring(msisdn, 1, 4);

END


GO
