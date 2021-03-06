USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_03]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 24.11.2015
-- Description:	Fill data of REP_03 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_03] @start_date date, @end_date date
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare
		@msisdn varchar(40), 
		@year int, 
		@month int, 
		@accessing_count bigint,
		@id_ref_area_group_home bigint;

	delete from rep_03
	where 
		year between year(@start_date) and year(@end_date)
		and month between month(@start_date) and month(@end_date);

	delete from rep_03_home_area
	where 
		year between year(@start_date) and year(@end_date)
		and month between month(@start_date) and month(@end_date);


	-- WIN

	insert into rep_03 (msisdn, id_ref_area_group, month, year, accessing_count)
	select 
		t.msisdn,
		ag.id id_ref_area_group,
		month(t.accessing_date) month,
		year(t.accessing_date) year,
		count(distinct t.accessing_date) accessing_count
	from 
		(
			select
				msisdn,
				max(accessing_date) accessing_date
			from vlr 
			where
				year(accessing_date) between year(@start_date) and year(@end_date)
				and month(accessing_date) between month(@start_date) and month(@end_date)
			group by msisdn, accessing_date
		) t_01,
		vlr t,
		refarea r,
		ref_area_group ag,
		link_area_area_group l
	where
		t.msisdn like '79789%'
		and upper(r.codarea) = upper(t.codarea)
		and r.id = l.id_ref_area
		and ag.id = l.id_ref_area_group
		and year(t.accessing_date) between year(@start_date) and year(@end_date)
		and month(t.accessing_date) between month(@start_date) and month(@end_date)
		and t.msisdn = t_01.msisdn
		and t.accessing_date = t_01.accessing_date
	group by t.msisdn, year(t.accessing_date), month(t.accessing_date), ag.id
	order by t.msisdn, year(t.accessing_date), month(t.accessing_date), ag.id;

	insert into rep_03_home_area(msisdn, year, month, id_ref_area_group)
	select
		t.msisdn,
		t.year, 
		t.month,
		t.id_ref_area_group
	from rep_03 t
	where 
		t.year between year(@start_date) and year(@end_date)
		and t.month between month(@start_date) and month(@end_date)

		and cast(t.accessing_count as decimal)/ cast(
		(
			select sum(i.accessing_count)
			from rep_03 i
			where i.msisdn = t.msisdn
				and i.month = t.month
				and i.year = t.year
			group by i.msisdn, i.year, i.month
		) 

		as decimal) * 100 >= 70 
	group by t.msisdn, t.year, t.month, t.id_ref_area_group
	order by t.msisdn, t.year, t.month, t.id_ref_area_group;



/*	SET IMPLICIT_TRANSACTIONS OFF;

	BEGIN TRANSACTION;

	declare win_cursor cursor for
		select 
			msisdn, 
			year, 
			month,
			sum(accessing_count)
		from rep_03
		where
			month between month(@start_date) and month(@end_date)
			and year between year(@start_date) and year(@end_date)

		group by msisdn, year, month
		order by msisdn, year, month
			
	open win_cursor;

	fetch next from win_cursor into @msisdn, @year, @month, @accessing_count;
	while @@fetch_status = 0
	begin
		
		set @id_ref_area_group_home =
		(
			select id_ref_area_group
			from rep_03
			where
				msisdn = @msisdn
				and year = @year
				and month = @month
				and cast(accessing_count as decimal)/ cast(@accessing_count as decimal) * 100 >= 70
		);

		update rep_03
		set	id_ref_area_group_home = isNull(@id_ref_area_group_home, -1)
		where msisdn = @msisdn
			and year = @year
			and month = @month;

		fetch next from win_cursor into @msisdn, @year, @month, @accessing_count;
	end;

	close win_cursor;
	deallocate win_cursor;

	COMMIT TRANSACTION;*/

END


GO
