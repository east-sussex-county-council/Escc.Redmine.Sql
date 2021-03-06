/****** Object:  UserDefinedFunction [Escc].[fn_IssuesWithDeadlines]    Script Date: 08/14/2013 13:15:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Mason, Digital Services
-- Create date: 13 August 2013
-- Description:	Selects issues where expected and actual dates are filled in
-- =============================================
CREATE FUNCTION [Escc].[fn_IssuesWithDeadlines]
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
	SELECT issues.id, tracker_id, actual.value AS actual, expected.value AS expected 
	FROM issues 
	INNER JOIN custom_values AS expected ON issues.id = expected.customized_id AND expected.customized_type = 'Issue' AND expected.custom_field_id = @expectedFieldId AND expected.value IS NOT NULL AND expected.value != ''
	INNER JOIN custom_values AS actual ON issues.id = actual.customized_id AND actual.customized_type = 'Issue' AND actual.custom_field_id = @actualFieldId AND actual.value IS NOT NULL AND actual.value != ''
	WHERE project_id IN (@project_id) 
	AND CONVERT(datetime,expected.value,20) >= @start
)
GO
