/****** Object:  UserDefinedFunction [Escc].[fn_IssueStatusOnDate]    Script Date: 08/14/2013 13:15:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Rick Mason, Digital Services
-- Create date: 13 August 2013
-- Description:	Select issues with their status on a given date
-- ============================================================
CREATE FUNCTION [Escc].[fn_IssueStatusOnDate] 
(
	@date datetime
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT id AS issue_id, ISNULL(ISNULL(lastchange, originalvalue),status_id) AS status_id FROM
	(
		SELECT i.id, i.status_id, 
		(
			SELECT TOP 1 journal_details.value FROM issues 
			inner join journals ON issues.id = journals.journalized_id AND journals.journalized_type = 'Issue'
			inner join journal_details ON journals.id = journal_details.journal_id
			WHERE issues.id = i.id
			and journal_details.property = 'attr'
			and journal_details.prop_key = 'status_id'
			and journals.created_on <= @date
			ORDER BY journals.created_on DESC
		) AS lastchange,

		(SELECT TOP 1 journal_details.old_value FROM issues 
			inner join journals ON issues.id = journals.journalized_id AND journals.journalized_type = 'Issue'
			inner join journal_details ON journals.id = journal_details.journal_id
			WHERE issues.id = i.id
			and journal_details.property = 'attr'
			and journal_details.prop_key = 'status_id'
			ORDER BY journals.created_on ASC) AS originalvalue

		FROM issues i
	)
	AS historical_status
)
GO
