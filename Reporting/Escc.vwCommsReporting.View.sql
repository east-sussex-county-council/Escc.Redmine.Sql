/****** Object:  View [Escc].[vwCommsReporting]    Script Date: 08/14/2013 13:15:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Escc].[vwCommsReporting]
AS
SELECT     label, value
FROM         Escc.fn_CommsReporting() AS fn_CommsReporting_1
GO
