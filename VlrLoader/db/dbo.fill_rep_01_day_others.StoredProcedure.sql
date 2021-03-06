USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01_day_others]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 21.09.2015
-- Description:	Fill OTHERS data of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01_day_others] 
	@date date,
	@msisdn_table msisdn_table_type readonly
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare 
		@id_ref_operator int

	-- Others

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = 'not 7978(0,7,8,9)'
	);

	declare @msisdn_table_others table
	(
		msisdn varchar(40),
		msisdn_prefix varchar(4)
	);
	
	insert into @msisdn_table_others(msisdn, msisdn_prefix)
	select
		msisdn,
		substring(msisdn, 1 ,4)
	from @msisdn_table
	where
		substring(msisdn,1,5) not in ('79780', '79787', '79788', '79789') --'79781', 


	insert into rep_01_day_others(accessing_date, msisdn_prefix, msisdn_count, msisdn_adds_count)
	select 
		@date,
		msisdn_prefix,
		count(t.msisdn),
		(
			select count(msisdn)
			from @msisdn_table_others
			where
				msisdn_prefix = t.msisdn_prefix
				and msisdn not in
				(
					select msisdn from msisdn
				)
		)
	from 
		@msisdn_table_others t
	group by msisdn_prefix
	order by msisdn_prefix;


	insert into rep_01_day(ACCESSING_DATE, ID_REF_OPERATOR, MSISDN_COUNT, MSISDN_ADDS_COUNT)
	select 
		accessing_date,
		@ID_REF_OPERATOR,
		sum(msisdn_count),
		sum(msisdn_adds_count)
	from 
		rep_01_day_others
	where
		accessing_date = @date
	group by accessing_date;

END



GO
