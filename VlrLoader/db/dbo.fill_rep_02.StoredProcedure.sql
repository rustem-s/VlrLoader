USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_02]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 25.09.2015
-- Description:	Fill data of REP_02 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_02]
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare
		@id_ref_operator_win int,
		@id_ref_operator_mts int,
		@id_ref_operator_mts_new int,
		@id_ref_operator_others int;

	set @id_ref_operator_win =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '79789'
	);

	set @id_ref_operator_mts =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '7978(0,7,8)'
	);

	set @id_ref_operator_mts_new =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '7978(1,2)'
	);

	set @id_ref_operator_others =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = 'not 7978(0,1,2,7,8,9)'
	);

	declare 
		@tableDayCountByMsisdn table(
			msisdn varchar(40),
			day_count numeric(18,0)
		);

	insert into @tableDayCountByMsisdn(msisdn, day_count)
	select
		t.msisdn,
		count(distinct f.file_date) day_count
	from 
		vlr t,
		vlr_file f
	where
		t.id_vlr_file = f.id
	group by t.msisdn;


	truncate table rep_02;


	
	-- WIN

	insert into rep_02(id_ref_operator, day_count, msisdn_count)
	select 
		@id_ref_operator_win,
		day_count,
		count(msisdn) msisdn_count
	from @tableDayCountByMsisdn
	where
		msisdn like '79789%'
	group by day_count;



	-- MTS Russia

	insert into rep_02(id_ref_operator, day_count, msisdn_count)
	select 
		@id_ref_operator_mts,
		day_count,
		count(msisdn) msisdn_count
	from @tableDayCountByMsisdn
	where
		substring(msisdn, 1, 5) in ('79780', '79787', '79788')
	group by day_count;

	-- MTS Russia New

	insert into rep_02(id_ref_operator, day_count, msisdn_count)
	select 
		@id_ref_operator_mts_new,
		day_count,
		count(msisdn) msisdn_count
	from @tableDayCountByMsisdn
	where
		substring(msisdn, 1, 5) in ('79781', '79782')
	group by day_count;

	-- Others

	insert into rep_02(id_ref_operator, day_count, msisdn_count)
	select 
		@id_ref_operator_others,
		day_count,
		count(msisdn) msisdn_count
	from @tableDayCountByMsisdn
	where
		substring(msisdn, 1, 5) not in ('79780', '79781', '79782', '79787', '79788', '79789')
	group by day_count;

END


GO
