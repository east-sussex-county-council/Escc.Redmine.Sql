/****** Object:  UserDefinedFunction [Escc].[fn_IssuesOpen]    Script Date: 08/14/2013 13:15:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================
-- Author:		Rick Mason, Digital Services
-- Create date: 14 August 2013
-- Description:	Selects all open issues in a given project
-- =======================================================
CREATE FUNCTION [Escc].[fn_IssuesOpen]
(	
	@project_id int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT id, tracker_id 
	FROM issues 
	WHERE project_id IN (@project_id)
	AND status_id IN (SELECT id FROM issue_statuses WHERE is_closed = 0)
)
GO
