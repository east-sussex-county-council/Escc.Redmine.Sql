/****** Object:  UserDefinedFunction [Escc].[fn_IssuesMeetingDeadlines_Statistics]    Script Date: 08/14/2013 13:15:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Mason, Digital Services
-- Create date: 14 August 2013
-- Description:	Select total and % issues meeting deadline dates
-- =============================================
CREATE FUNCTION [Escc].[fn_IssuesMeetingDeadlines_Statistics]
(	
	@project_id int,
	@tracker_id int,
	@expectedField int, 
	@actualField int,
	@start datetime
)
RETURNS @table TABLE (on_time int, percentage int)
AS
BEGIN
	DECLARE @total int, @onTime int, @percent int

	SELECT @total = (SELECT COUNT(*) FROM Escc.fn_IssuesWithDeadlines(@project_id, @expectedField, @actualField, @start) WHERE tracker_id IN (@tracker_id))
	SELECT @onTime = (SELECT COUNT(*) FROM Escc.fn_IssuesMeetingDeadlines(@project_id, @expectedField, @actualField, @start) WHERE tracker_id IN (@tracker_id))

	IF @onTime > 0
		SELECT @percent = ((@total/@onTime)*100)
	ELSE
		SET @percent = 0

	INSERT @table
	SELECT @onTime, @percent

	RETURN 
END
GO
