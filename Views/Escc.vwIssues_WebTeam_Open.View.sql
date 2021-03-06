/****** Object:  View [Escc].[vwIssues_WebTeam_Open]    Script Date: 10/18/2013 17:08:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Escc].[vwIssues_WebTeam_Open]
AS
SELECT     tracker, subject, description, status, priority, assigned_to, start_date, due_date, estimated_mins, done_ratio, category, requester, dept
FROM         Escc.vwIssues_WebTeam_All
WHERE     (NOT (status IN ('Complete', 'Abandoned')))
GO
