USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01_v1]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 14.08.2015
-- Description:	Fill tables of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01_v1] @start_date date, @end_date date
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @accessing_date DATE,
		@msisdn_count varchar(10), 
		@msisdn_adds_count numeric(18,0),
		@id_ref_operator int

	delete from rep_01_day
	where 
		accessing_date between @start_date and @end_date;
	
	-- WIN

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '79789'
	);

	declare win_cursor cursor for
		SELECT 
			accessing_date,
			count(distinct MSISDN)
		from 
			VLR
		where 
			accessing_date between @start_date and @end_date
			and substring(MSISDN,1,5) in ('79789')
		group by accessing_date
		order by accessing_date
			
	open win_cursor;

	fetch next from win_cursor into @accessing_date, @msisdn_count;
	while @@fetch_status = 0
	begin

		set @msisdn_adds_count =
		(
			select count(1) 
			from
			(
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 5) in ('79789')
					and accessing_date = @accessing_date
				except
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 5) in ('79789')
					and accessing_date < @accessing_date
			) t
		);

		insert into rep_01_day(ACCESSING_DATE, ID_REF_OPERATOR, MSISDN_COUNT, MSISDN_ADDS_COUNT)
		values(@accessing_date, @ID_REF_OPERATOR, @msisdn_count, @msisdn_adds_count);

		fetch next from win_cursor into @accessing_date, @msisdn_count;
	end;

	close win_cursor;
	deallocate win_cursor;

	-- MTS Russia

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '7978(0,7,8)'
	);

	declare mtsr_cursor cursor for
		SELECT 
			accessing_date,
			count(distinct MSISDN)
		from 
			VLR
		where 
			accessing_date between @start_date and @end_date
			and substring(MSISDN,1,5) in ('79780', '79787', '79788')
		group by accessing_date
		order by accessing_date
			
	open mtsr_cursor;

	fetch next from mtsr_cursor into @accessing_date, @msisdn_count;
	while @@fetch_status = 0
	begin

		set @msisdn_adds_count =
		(
			select count(1) 
			from
			(
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 5) in ('79780', '79787', '79788')
					and accessing_date = @accessing_date
				except
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 5) in ('79780', '79787', '79788')
					and accessing_date < @accessing_date
			) t
		);

		insert into rep_01_day(ACCESSING_DATE, ID_REF_OPERATOR, MSISDN_COUNT, MSISDN_ADDS_COUNT)
		values(@accessing_date, @ID_REF_OPERATOR, @msisdn_count, @msisdn_adds_count);

		fetch next from mtsr_cursor into @accessing_date, @msisdn_count;
	end;

	close mtsr_cursor;
	deallocate mtsr_cursor;

	-- MTS Russia New

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '79781'
	);

	declare mtsr_new_cursor cursor for
		SELECT 
			accessing_date,
			count(distinct MSISDN)
		from 
			VLR
		where 
			accessing_date between @start_date and @end_date
			and substring(MSISDN,1,5) in ('79781')
		group by accessing_date
		order by accessing_date
			
	open mts_new_cursor;

	fetch next from mtsr_new_cursor into @accessing_date, @msisdn_count;
	while @@fetch_status = 0
	begin

		set @msisdn_adds_count =
		(
			select count(1) 
			from
			(
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 5) in ('79781')
					and accessing_date = @accessing_date
				except
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 5) in ('79781')
					and accessing_date < @accessing_date
			) t
		);

		insert into rep_01_day(ACCESSING_DATE, ID_REF_OPERATOR, MSISDN_COUNT, MSISDN_ADDS_COUNT)
		values(@accessing_date, @ID_REF_OPERATOR, @msisdn_count, @msisdn_adds_count);

		fetch next from mtsr_new_cursor into @accessing_date, @msisdn_count;
	end;

	close mtsr_new_cursor;
	deallocate mtsr_new_cursor;

	-- MTS 

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '79782'
	);

	declare mts_cursor cursor for
		SELECT 
			accessing_date,
			count(distinct MSISDN)
		from 
			VLR
		where 
			accessing_date between @start_date and @end_date
			and substring(MSISDN,1,5) in ('79782')
		group by accessing_date
		order by accessing_date
			
	open mts_cursor;

	fetch next from mts_cursor into @accessing_date, @msisdn_count;
	while @@fetch_status = 0
	begin

		set @msisdn_adds_count =
		(
			select count(1) 
			from
			(
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 5) in ('79782')
					and accessing_date = @accessing_date
				except
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 5) in ('79782')
					and accessing_date < @accessing_date
			) t
		);

		insert into rep_01_day(ACCESSING_DATE, ID_REF_OPERATOR, MSISDN_COUNT, MSISDN_ADDS_COUNT)
		values(@accessing_date, @ID_REF_OPERATOR, @msisdn_count, @msisdn_adds_count);

		fetch next from mts_cursor into @accessing_date, @msisdn_count;
	end;

	close mts_cursor;
	deallocate mts_cursor;

	-- Others

	exec fill_rep_01_day_others @start_date, @end_date;

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = 'not 7978(0,7,8,9)'
	);

	insert into rep_01_day(ACCESSING_DATE, ID_REF_OPERATOR, MSISDN_COUNT, MSISDN_ADDS_COUNT)
	select 
		accessing_date,
		@ID_REF_OPERATOR,
		sum(msisdn_count),
		sum(msisdn_adds_count)
	from 
		rep_01_day_others
	where
		accessing_date between @start_date and @end_date
	group by accessing_date;


	-- total by days
	
	exec fill_rep_01_total_by_day @start_date, @end_date;

	-- total by month

	exec fill_rep_01_month_by_period @start_date, @end_date;

	exec fill_rep_01_month_total_by_period @start_date, @end_date;

	exec fill_rep_01_others_month_total_by_period @start_date, @end_date;

END


GO
