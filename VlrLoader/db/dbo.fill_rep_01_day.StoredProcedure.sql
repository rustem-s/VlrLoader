USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[fill_rep_01_day]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 14.08.2015
-- Description:	Fill tables of REP_01 report
-- =============================================
CREATE PROCEDURE [dbo].[fill_rep_01_day] 
	@date date, 
	@msisdn_table msisdn_table_type readonly
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare 
		@id_ref_operator int,
		@msisdn_count numeric(18,0),
		@msisdn_adds_count numeric(18,0);

	-- WIN

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '79789'
	);

	set @msisdn_count =
	(
		select count(1) 
		from @msisdn_table
		where
			msisdn like '79789%'
	);

	set @msisdn_adds_count = 
	(
		select count(1)
		from @msisdn_table
		where
			msisdn like '79789%'
			and msisdn not in
			(
				select msisdn 
				from msisdn
			)
	);

	insert into rep_01_day(accessing_date, id_ref_operator, msisdn_count, msisdn_adds_count)
	values (@date, @id_ref_operator, @msisdn_count, @msisdn_adds_count)

	
	-- MTS Russia

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '7978(0,7,8)'
	);

	set @msisdn_count =
	(
		select count(1) 
		from @msisdn_table
		where
			substring(msisdn,1,5) in ('79780', '79787', '79788')
	);

	set @msisdn_adds_count = 
	(
		select count(1)
		from @msisdn_table
		where
			substring(msisdn,1,5) in ('79780', '79787', '79788')
			and msisdn not in
			(
				select msisdn 
				from msisdn
			)
	);

	insert into rep_01_day(accessing_date, id_ref_operator, msisdn_count, msisdn_adds_count)
	values (@date, @id_ref_operator, @msisdn_count, @msisdn_adds_count)


	-- MTS Russia New

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '79781'
	);

	set @msisdn_count =
	(
		select count(1) 
		from @msisdn_table
		where
			msisdn like '79781%'
	);

	set @msisdn_adds_count = 
	(
		select count(1)
		from @msisdn_table
		where
			msisdn like '79781%'
			and msisdn not in
			(
				select msisdn 
				from msisdn
			)
	);

	insert into rep_01_day(accessing_date, id_ref_operator, msisdn_count, msisdn_adds_count)
	values (@date, @id_ref_operator, @msisdn_count, @msisdn_adds_count)


	-- MTS 

	set @id_ref_operator =
	(
		select id
		from ref_operator
		where ltrim(rtrim(prefix)) = '79782'
	);

	set @msisdn_count =
	(
		select count(1) 
		from @msisdn_table
		where
			msisdn like '79782%'
	);

	set @msisdn_adds_count = 
	(
		select count(1)
		from @msisdn_table
		where
			msisdn like '79782%'
			and msisdn not in
			(
				select msisdn 
				from msisdn
			)
	);

	insert into rep_01_day(accessing_date, id_ref_operator, msisdn_count, msisdn_adds_count)
	values (@date, @id_ref_operator, @msisdn_count, @msisdn_adds_count)

END


GO
