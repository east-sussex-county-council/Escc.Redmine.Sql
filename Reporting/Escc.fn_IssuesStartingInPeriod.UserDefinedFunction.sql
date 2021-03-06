/****** Object:  UserDefinedFunction [Escc].[fn_IssuesStartingInPeriod]    Script Date: 08/14/2013 13:15:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Mason, Digital Services
-- Create date: 13 August 2013
-- Description:	Select issues created within a period
-- =============================================
CREATE FUNCTION [Escc].[fn_IssuesStartingInPeriod]
(	
	@project_id int,
	@start datetime,
	@end datetime
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT id, tracker_id 
	FROM issues 
	WHERE project_id IN (@project_id) 
	AND created_on >= @start AND created_on <= @end
)
GO
