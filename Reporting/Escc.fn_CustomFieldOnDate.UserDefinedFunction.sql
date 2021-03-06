/****** Object:  UserDefinedFunction [Escc].[fn_CustomFieldOnDate]    Script Date: 08/14/2013 13:15:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Rick Mason, Digital Services
-- Create date: 13 August 2013
-- Description:	Select the final value of a custom field on a given date
-- ============================================================
CREATE FUNCTION [Escc].[fn_CustomFieldOnDate]
(
	@customFieldId int,
	@date datetime
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT id AS issue_id, ISNULL(ISNULL(lastchange, originalvalue),currentvalue) AS [value] FROM
	(
		SELECT i.id, 

		(
			SELECT value FROM custom_values 
			WHERE customized_type = 'Issue' AND customized_id = i.id AND custom_field_id = @customFieldId
		) 
		AS currentvalue, 

		(
			SELECT TOP 1 journal_details.value FROM issues 
			inner join journals ON issues.id = journals.journalized_id AND journals.journalized_type = 'Issue'
			inner join journal_details ON journals.id = journal_details.journal_id
			WHERE issues.id = i.id
			and journal_details.property = 'cf'
			and journal_details.prop_key = CAST(@customFieldId AS varchar(30))
			and journals.created_on <= @date
			ORDER BY journals.created_on DESC
		)
		AS lastchange,		


		(SELECT TOP 1 journal_details.old_value FROM issues 
			inner join journals ON issues.id = journals.journalized_id AND journals.journalized_type = 'Issue'
			inner join journal_details ON journals.id = journal_details.journal_id
			WHERE journal_details.property = 'cf'
			and journal_details.prop_key = CAST(@customFieldId AS varchar(30))
			ORDER BY journals.created_on ASC
		 )
		 AS originalvalue

		FROM issues i
	)
	AS historical_status
)
GO
