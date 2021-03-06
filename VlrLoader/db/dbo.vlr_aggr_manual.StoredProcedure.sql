USE [VLRDatabase]
GO
/****** Object:  StoredProcedure [dbo].[vlr_aggr_manual]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 31.01.2016
-- Description:	Manual aggregate reports data
-- =============================================
CREATE PROCEDURE [dbo].[vlr_aggr_manual] @start_date date, @end_date date
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare 
		@cur_date date = @start_date
		;

	while @cur_date <= @end_date 
	begin
		BEGIN TRAN;
		BEGIN TRY
			exec vlr_load_autonomous @cur_date;

		set @cur_date = 
		(
			select DATEADD(day,1,@cur_date)
		);

		COMMIT TRAN;	

		END TRY
		BEGIN CATCH
			 ROLLBACK TRAN;
			 insert into log_vlr_loader_autonomous(vlr_date, error_message) 
			 values (@cur_date, ERROR_MESSAGE());
		END CATCH

	end

	-- total by month
	exec fill_rep_01_month_by_period @start_date, @end_date;

	exec fill_rep_01_month_total_by_period @start_date, @end_date;

	exec fill_rep_01_others_month_total_by_period @start_date, @end_date;

	-- fill REP_02
	exec fill_rep_02;

	-- fill REP_03
	exec fill_rep_03 @start_date, @end_date;

END


GO
