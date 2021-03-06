/****** Object:  UserDefinedFunction [Escc].[fn_CommsReporting]    Script Date: 08/14/2013 13:15:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Mason
-- Create date: 13 August 2013
-- Description:	Reporting for the Head of Communications
-- =============================================
CREATE FUNCTION [Escc].[fn_CommsReporting]()
RETURNS @returnData TABLE (label varchar(200), value int)
AS
BEGIN
	DECLARE @thisYearStart datetime, @lastQuarterStart datetime, @lastQuarterEnd datetime
	DECLARE @table TABLE (label varchar(200), value int)

	SET @thisYearStart = CAST('1 January ' + CAST(YEAR(GETDATE()) as char(4)) AS datetime)

	IF MONTH(GETDATE()) < 4
		BEGIN
			SET @lastQuarterStart = CAST('1 October ' + CAST(YEAR(GETDATE())-1 as char(4)) AS datetime)
			SET @lastQuarterEnd = CAST('31 December ' + CAST(YEAR(GETDATE())-1 as char(4)) AS datetime)
		END
	ELSE IF MONTH(GETDATE()) < 7
		BEGIN
			SET @lastQuarterStart = CAST('1 January ' + CAST(YEAR(GETDATE()) as char(4)) AS datetime)
			SET @lastQuarterEnd = CAST('31 March ' + CAST(YEAR(GETDATE()) as char(4)) AS datetime)
		END
	ELSE IF MONTH(GETDATE()) < 10
		BEGIN
			SET @lastQuarterStart = CAST('1 April ' + CAST(YEAR(GETDATE()) as char(4)) AS datetime)
			SET @lastQuarterEnd = CAST('30 June ' + CAST(YEAR(GETDATE()) as char(4)) AS datetime)
		END
	ELSE
		BEGIN
			SET @lastQuarterStart = CAST('1 July ' + CAST(YEAR(GETDATE()) as char(4)) AS datetime)
			SET @lastQuarterEnd = CAST('31 September ' + CAST(YEAR(GETDATE()) as char(4)) AS datetime)
		END

	DECLARE @comms int, @headlineProjects int, @keyProjects int
	SELECT @comms = 76, @headlineProjects = 32, @keyProjects = 33

	-- Section 1: Enquiries received
	DECLARE @total int
	SELECT @total = (SELECT COUNT(*) FROM issues WHERE project_id IN (@comms) AND start_date >= @lastQuarterStart AND start_date <= @lastQuarterEnd)
	INSERT INTO @table (label, value) VALUES ('Enquiries received - last quarter',@total)

	SELECT @total = (SELECT COUNT(*) FROM issues WHERE project_id IN (@comms) AND start_date >= @thisYearStart)
	INSERT INTO @table (label, value) VALUES ('Enquiries received - year to date',@total)

	-- Section 2: New, active and complete issues
	DECLARE @new int, @active int, @complete int
	SELECT @new = (SELECT COUNT(*) FROM Escc.fn_IssuesStartingInPeriod(@comms, @lastQuarterStart, @lastQuarterEnd) WHERE tracker_id IN (@headlineProjects)),
		   @active = (SELECT COUNT(*) FROM Escc.fn_IssuesOpenOnDate(@comms, @lastQuarterEnd) WHERE tracker_id IN (@headlineProjects)),
		   @complete = (SELECT COUNT(*) FROM Escc.fn_IssuesCompletedInPeriod(@comms, @lastQuarterStart, @lastQuarterEnd) WHERE tracker_id IN (@headlineProjects))
	INSERT INTO @table (label, value) VALUES ('Headline projects - last quarter (new)',@new)
	INSERT INTO @table (label, value) VALUES ('Headline projects - last quarter (active)',@active)
	INSERT INTO @table (label, value) VALUES ('Headline projects - last quarter (complete)',@complete)

	SELECT @new = (SELECT COUNT(*) FROM Escc.fn_IssuesStartingInPeriod(@comms, @thisYearStart, GETDATE()) WHERE tracker_id IN (@headlineProjects)),
		   @active = (SELECT COUNT(*) FROM Escc.fn_IssuesOpen(@comms) WHERE tracker_id IN (@headlineProjects)),
		   @complete = (SELECT COUNT(*) FROM Escc.fn_IssuesCompletedSinceDate(@comms, @thisYearStart) WHERE tracker_id IN (@headlineProjects))
	INSERT INTO @table (label, value) VALUES ('Headline projects - year to date (new)',@new)
	INSERT INTO @table (label, value) VALUES ('Headline projects - year to date (active)',@active)
	INSERT INTO @table (label, value) VALUES ('Headline projects - year to date (complete)',@complete)

	SELECT @new = (SELECT COUNT(*) FROM Escc.fn_IssuesStartingInPeriod(@comms, @lastQuarterStart, @lastQuarterEnd) WHERE tracker_id IN (@keyProjects)),
		   @active = (SELECT COUNT(*) FROM Escc.fn_IssuesOpenOnDate(@comms, @lastQuarterEnd) WHERE tracker_id IN (@keyProjects)),
		   @complete = (SELECT COUNT(*) FROM Escc.fn_IssuesCompletedInPeriod(@comms, @lastQuarterStart, @lastQuarterEnd) WHERE tracker_id IN (@keyProjects))
	INSERT INTO @table (label, value) VALUES ('Key projects - last quarter (new)',@new)
	INSERT INTO @table (label, value) VALUES ('Key projects - last quarter (active)',@active)
	INSERT INTO @table (label, value) VALUES ('Key projects - last quarter (complete)',@complete)

	SELECT @new = (SELECT COUNT(*) FROM Escc.fn_IssuesStartingInPeriod(@comms, @thisYearStart, GETDATE()) WHERE tracker_id IN (@keyProjects)),
		   @active = (SELECT COUNT(*) FROM Escc.fn_IssuesOpen(@comms) WHERE tracker_id IN (@keyProjects)),
		   @complete = (SELECT COUNT(*) FROM Escc.fn_IssuesCompletedSinceDate(@comms, @thisYearStart) WHERE tracker_id IN (@keyProjects))
	INSERT INTO @table (label, value) VALUES ('Key projects - year to date (new)',@new)
	INSERT INTO @table (label, value) VALUES ('Key projects - year to date (active)',@active)
	INSERT INTO @table (label, value) VALUES ('Key projects - year to date (complete)',@complete)

	SELECT @new = (SELECT COUNT(*) FROM Escc.fn_IssuesStartingInPeriod(@comms, @lastQuarterStart, @lastQuarterEnd) WHERE tracker_id NOT IN (@headlineProjects,@keyProjects)),
		   @active = (SELECT COUNT(*) FROM Escc.fn_IssuesOpenOnDate(@comms, @lastQuarterEnd) WHERE tracker_id NOT IN (@headlineProjects,@keyProjects)),
		   @complete = (SELECT COUNT(*) FROM Escc.fn_IssuesCompletedInPeriod(@comms, @lastQuarterStart, @lastQuarterEnd) WHERE tracker_id NOT IN (@headlineProjects,@keyProjects))
	INSERT INTO @table (label, value) VALUES ('Jobs - last quarter (new)',@new)
	INSERT INTO @table (label, value) VALUES ('Jobs - last quarter (active)',@active)
	INSERT INTO @table (label, value) VALUES ('Jobs - last quarter (complete)',@complete)

	SELECT @new = (SELECT COUNT(*) FROM Escc.fn_IssuesStartingInPeriod(@comms, @thisYearStart, GETDATE()) WHERE tracker_id NOT IN (@headlineProjects,@keyProjects)),
		   @active = (SELECT COUNT(*) FROM Escc.fn_IssuesOpen(@comms) WHERE tracker_id NOT IN (@headlineProjects,@keyProjects)),
		   @complete = (SELECT COUNT(*) FROM Escc.fn_IssuesCompletedSinceDate(@comms, @thisYearStart) WHERE tracker_id NOT IN (@headlineProjects,@keyProjects))
	INSERT INTO @table (label, value) VALUES ('Jobs - year to date (new)',@new)
	INSERT INTO @table (label, value) VALUES ('Jobs - year to date (active)',@active)
	INSERT INTO @table (label, value) VALUES ('Jobs - year to date (complete)',@complete)

	-- Section 3: Deadlines met
	DECLARE @expectedBriefField int, @actualBriefField int, 
			@expectedDeliveryField int, @actualDeliveryField int, 
			@expectedEvaluationField int, @actualEvaluationField int,
			@onTime int, @percent int
	SELECT @expectedBriefField = 30, @actualBriefField = 25,
		   @expectedDeliveryField = 31, @actualDeliveryField = 26,
		   @expectedEvaluationField = 27, @actualEvaluationField = 28

	SELECT @onTime = on_time, @percent = percentage FROM Escc.fn_IssuesMeetingDeadlines_Statistics(@comms, @headlineProjects, @expectedBriefField, @actualBriefField, @thisYearStart)
	INSERT INTO @table (label, value) VALUES ('Project briefs completed to agreed deadline - headline projects - year to date (total)',@onTime)
	INSERT INTO @table (label, value) VALUES ('Project briefs completed to agreed deadline - headline projects - year to date (%)',@percent)

	SELECT @onTime = on_time, @percent = percentage FROM Escc.fn_IssuesMeetingDeadlines_Statistics(@comms, @keyProjects, @expectedBriefField, @actualBriefField, @thisYearStart)
	INSERT INTO @table (label, value) VALUES ('Project briefs completed to agreed deadline - key projects - year to date (total)',@onTime)
	INSERT INTO @table (label, value) VALUES ('Project briefs completed to agreed deadline - key projects - year to date (%)',@percent)

	SELECT @onTime = on_time, @percent = percentage FROM Escc.fn_IssuesMeetingDeadlines_Statistics(@comms, @headlineProjects, @expectedDeliveryField, @actualDeliveryField, @thisYearStart)
	INSERT INTO @table (label, value) VALUES ('Delivery plans completed to agreed deadline - headline projects - year to date (total)',@onTime)
	INSERT INTO @table (label, value) VALUES ('Delivery plans completed to agreed deadline - headline projects - year to date (%)',@percent)

	SELECT @onTime = on_time, @percent = percentage FROM Escc.fn_IssuesMeetingDeadlines_Statistics(@comms, @keyProjects, @expectedDeliveryField, @actualDeliveryField, @thisYearStart)
	INSERT INTO @table (label, value) VALUES ('Delivery plans completed to agreed deadline - key projects - year to date (total)',@onTime)
	INSERT INTO @table (label, value) VALUES ('Delivery plans completed to agreed deadline - key projects - year to date (%)',@percent)

	SELECT @onTime = on_time, @percent = percentage FROM Escc.fn_IssuesMeetingDeadlines_Statistics(@comms, @headlineProjects, @expectedEvaluationField, @actualEvaluationField, @thisYearStart)
	INSERT INTO @table (label, value) VALUES ('Evaluations completed to agreed deadline - headline projects - year to date (total)',@onTime)
	INSERT INTO @table (label, value) VALUES ('Evaluations completed to agreed deadline - headline projects - year to date (%)',@percent)

	SELECT @onTime = on_time, @percent = percentage FROM Escc.fn_IssuesMeetingDeadlines_Statistics(@comms, @keyProjects, @expectedEvaluationField, @actualEvaluationField, @thisYearStart)
	INSERT INTO @table (label, value) VALUES ('Evaluations completed to agreed deadline - key projects - year to date (total)',@onTime)
	INSERT INTO @table (label, value) VALUES ('Evaluations completed to agreed deadline - key projects - year to date (%)',@percent)

	INSERT INTO @returnData
	SELECT * FROM @table

	RETURN
END
GO
