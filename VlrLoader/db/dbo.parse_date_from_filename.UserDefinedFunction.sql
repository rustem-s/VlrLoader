USE [VLRDatabase]
GO
/****** Object:  UserDefinedFunction [dbo].[parse_date_from_filename]    Script Date: 11.02.2016 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rustem Saidaliyev
-- Create date: 19.11.2015
-- Description:	parse_date_from_filename
-- =============================================
CREATE FUNCTION [dbo].[parse_date_from_filename] 
(
	-- Add the parameters for the function here
	@filename varchar(255)
)
RETURNS date
AS
BEGIN
	-- Declare the return variable here
	DECLARE 
		@year varchar(4), @month varchar(2), @day varchar(2), @key varchar(255);
	declare
		@position_key int, @position_underline_after_year int, @position_underline_after_month int, @position_underline_after_day int;
	declare
		@file_date date;
		
	--set @key = '_User data_';
	--set @key = 'Sim-';
	--set @key = 'Sev-';
	--set @key = 'Sev_';
	set @key = 'Sim_';


	set @position_key = charindex(@key, @filename);

	set @position_underline_after_year = charindex('-', @filename, @position_key + len(@key));

	set @year = substring(@filename, @position_key + len(@key), @position_underline_after_year - (@position_key + len(@key)));

	set @position_underline_after_month = charindex('-', @filename, @position_underline_after_year + 1);

	set @month = substring(@filename, @position_underline_after_year + 1, @position_underline_after_month - (@position_underline_after_year + 1));

	set @position_underline_after_day = charindex('-', @filename, @position_underline_after_month + 1);
                
	set @day = substring(@filename, @position_underline_after_month + 1, @position_underline_after_day - (@position_underline_after_month + 1));

	set @file_date = cast(@day + '-' + @month + '-' + @year as date);
	-- Return the result of the function
	RETURN @file_date;

END

GO
