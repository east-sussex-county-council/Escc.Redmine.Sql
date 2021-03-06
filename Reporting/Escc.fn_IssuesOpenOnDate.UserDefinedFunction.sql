/****** Object:  UserDefinedFunction [Escc].[fn_IssuesOpenOnDate]    Script Date: 08/14/2013 13:15:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Author:		Rick Mason, Digital Services
-- Create date: 13 August 2013
-- Description:	Select issues open on a given date
-- ===============================================
CREATE FUNCTION [Escc].[fn_IssuesOpenOnDate] 
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
	AND id IN (
		SELECT issue_id FROM Escc.fn_IssueStatusOnDate(@date)
		WHERE 
		status_id IN (SELECT id FROM issue_statuses WHERE is_closed = 0)
	)
)
GO
