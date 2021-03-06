/****** Object:  UserDefinedFunction [Escc].[fn_IssuesMeetingDeadlines]    Script Date: 08/14/2013 13:15:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Mason, Digital Services
-- Create date: 13 August 2013
-- Description:	Compares expected and actual fields and selects
-- issues where the actual date is no later than the expected date
-- =============================================
CREATE FUNCTION [Escc].[fn_IssuesMeetingDeadlines]
(	
	@project_id int,
	@expectedFieldId int,
	@actualFieldId int,
	@start datetime
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT id, tracker_id 
	FROM Escc.fn_IssuesWithDeadlines(@project_id, @expectedFieldId, @actualFieldId, @start)
	WHERE actual <= expected -- don't CONVERT because causes problems and string comparison of YYYY-MM-DD works fine
)
GO
