/****** Object:  View [Escc].[vwIssues_WebTeam_All]    Script Date: 08/14/2013 13:15:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Escc].[vwIssues_WebTeam_All] as
SELECT  p.name as project, t.name AS tracker, i.subject, i.description, s.name AS status, 
priorities.name AS priority,u.firstname + ' ' + u.lastname AS assigned_to, 
 i.start_date, i.due_date, cast((i.estimated_hours * 60) as int) AS estimated_mins, i.done_ratio, ic.name AS category,
requester.value as requester, existing.value AS existing, dept.value AS dept, content_owner.value AS content_owner, 
editor.value AS editor, next_action.value AS next_action, next_action_notes.value AS next_action_notes,
published.value AS published, delay_reason.value AS delay_reason
FROM         dbo.issues AS i INNER JOIN
                      dbo.projects AS p ON i.project_id = p.id INNER JOIN
                      dbo.issue_statuses AS s ON i.status_id = s.id LEFT OUTER JOIN
                      dbo.users AS u ON i.assigned_to_id = u.id LEFT OUTER JOIN
                      dbo.custom_values AS requester ON (requester.custom_field_id = 1 AND requester.customized_id = i.id AND requester.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.custom_values AS existing ON (existing.custom_field_id = 20 AND existing.customized_id = i.id AND existing.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.custom_values AS dept ON (dept.custom_field_id = 17 AND dept.customized_id = i.id AND dept.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.custom_values AS content_owner ON (content_owner.custom_field_id = 18 AND content_owner.customized_id = i.id AND content_owner.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.custom_values AS editor ON (editor.custom_field_id = 19 AND editor.customized_id = i.id AND editor.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.custom_values AS next_action ON (next_action.custom_field_id = 13 AND next_action.customized_id = i.id AND next_action.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.custom_values AS next_action_notes ON (next_action_notes.custom_field_id = 14 AND next_action_notes.customized_id = i.id AND next_action_notes.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.custom_values AS published ON (published.custom_field_id = 15 AND published.customized_id = i.id AND published.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.custom_values AS delay_reason ON (delay_reason.custom_field_id = 16 AND delay_reason.customized_id = i.id AND delay_reason.customized_type = 'Issue') LEFT OUTER JOIN
                      dbo.issue_categories AS ic ON ic.id = i.category_id
			LEFT OUTER JOIN dbo.trackers t ON i.tracker_id = t.id
			LEFT OUTER JOIN dbo.enumerations priorities ON (i.priority_id = priorities.id AND priorities.type = 'IssuePriority')
WHERE     (p.id IN (28,37,38,51) or p.parent_id IN (28,38,51))
GO
