/****** Object:  UserDefinedFunction [Escc].[fn_IssuesCompletedSinceDate]    Script Date: 08/14/2013 13:15:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Author:		Rick Mason, Digital Services
-- Create date: 13 August 2013
-- Description:	Select issues completed since a given date
-- ===============================================
CREATE FUNCTION [Escc].[fn_IssuesCompletedSinceDate] 
(
	@project_id int, 
	@date datetime
)
RETURNS TABLE
AS
RETURN
(
	SELECT id, tracker_id 
	FROM issues 
	WHERE project_id IN (@project_id) 
	AND status_id = 4 
	AND id NOT IN (
		SELECT issue_id FROM Escc.fn_IssueStatusOnDate(@date) WHERE status_id = 4
	)
)
GO
