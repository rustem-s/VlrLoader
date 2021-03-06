USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01_day_others_v1]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 21.09.2015
-- Description:	Fill OTHERS data of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01_day_others_v1] @start_date date, @end_date date
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @accessing_date DATE,
		@msisdn_count varchar(10), 
		@msisdn_adds_count numeric(18,0),
		@id_ref_operator int

	-- Others

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = 'not 7978(0,7,8,9)'
	);

	delete from rep_01_day_others
	where accessing_date between @start_date and @end_date;

	declare @msisdn_prefix varchar(10);

	declare others_cursor cursor for
		SELECT 
			accessing_date,
			substring(msisdn, 1, 4),
			count(distinct MSISDN)
		from 
			VLR
		where 
			accessing_date between @start_date and @end_date
			and substring(MSISDN,1,5) not in ('79780', '79787', '79788', '79789') --'79781', 
		group by accessing_date, substring(msisdn, 1, 4)
		order by accessing_date, substring(msisdn, 1, 4)

	open others_cursor;

	fetch next from others_cursor into @accessing_date, @msisdn_prefix, @msisdn_count;
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
					substring(MSISDN, 1, 4) = @msisdn_prefix
					and substring(MSISDN,1,5) not in ('79780', '79787', '79788', '79789') --'79781', 
					and accessing_date = @accessing_date
				except
				select msisdn
				from
					vlr
				where
					substring(MSISDN, 1, 4) = @msisdn_prefix
					and substring(MSISDN,1,5) not in ('79780', '79787', '79788', '79789') --'79781', 
					and accessing_date < @accessing_date
			) t
		);

		insert into rep_01_day_others(accessing_date, msisdn_prefix, msisdn_count, msisdn_adds_count)
		values(@accessing_date, @msisdn_prefix, @msisdn_count, @msisdn_adds_count);

		fetch next from others_cursor into @accessing_date, @msisdn_prefix, @msisdn_count;
	end;

	close others_cursor;
	deallocate others_cursor;

END



GO
