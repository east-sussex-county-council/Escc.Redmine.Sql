/****** Object:  View [Escc].[vwIssues_WebTeam_All]    Script Date: 10/18/2013 17:07:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Escc].[vwIssues_WebTeam_All]
AS
SELECT     t.name AS tracker, i.subject, i.description, s.name AS status, priorities.name AS priority, u.firstname + ' ' + u.lastname AS assigned_to, i.start_date, 
                      i.due_date, CAST(i.estimated_hours * 60 AS int) AS estimated_mins, i.done_ratio, ic.name AS category, requester.value AS requester, 
                      dept.value AS dept
FROM         dbo.issues AS i INNER JOIN
                      dbo.issue_statuses AS s ON i.status_id = s.id LEFT OUTER JOIN
                      dbo.users AS u ON i.assigned_to_id = u.id LEFT OUTER JOIN
                      dbo.custom_values AS requester ON requester.custom_field_id = 1 AND requester.customized_id = i.id AND 
                      requester.customized_type = 'Issue' LEFT OUTER JOIN
                      dbo.custom_values AS dept ON dept.custom_field_id = 17 AND dept.customized_id = i.id AND dept.customized_type = 'Issue' LEFT OUTER JOIN
                      dbo.issue_categories AS ic ON ic.id = i.category_id LEFT OUTER JOIN
                      dbo.trackers AS t ON i.tracker_id = t.id LEFT OUTER JOIN
                      dbo.enumerations AS priorities ON i.priority_id = priorities.id AND priorities.type = 'IssuePriority'
WHERE     (i.assigned_to_id IN (54, 61, 18, 19, 31, 39, 41, 56, 60, 38))

GO