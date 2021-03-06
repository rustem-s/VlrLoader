USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[vlr_load_autonomous]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 11.01.2016
-- Description:	DB side logic of loading data of VLR
--				(worked autonomous, without VlrLoader.exe execution)
-- =============================================
CREATE PROCEDURE [dbo].[vlr_load_autonomous] @date date
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare 
		@msisdn_table msisdn_table_type;

	insert into @msisdn_table(msisdn)
	select
		distinct msisdn
	from 
		vlr v,
		vlr_file vf
	where
		vf.file_date = @date
		and vf.id = v.id_vlr_file
	
	-- fill REP_01 tables
	exec fill_rep_01 @date, @msisdn_table, 0;

	-- update msisdn table
	MERGE msisdn AS target
    USING (select msisdn from @msisdn_table) AS source (msisdn)
    ON (target.msisdn = source.msisdn)
	WHEN NOT MATCHED THEN
    INSERT (msisdn, create_date)
    VALUES (source.msisdn, @date);

END


GO
