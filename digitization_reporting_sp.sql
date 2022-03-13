USE [Revo_DW]
GO
/****** Object:  StoredProcedure [dbo].[usp_ReportDigitizing]    Script Date: 26.01.2022 16:49:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[usp_ReportDigitizing] @from date, @to date
AS	
declare @date_from as date
set @date_from = @from
declare @date_to as date
set @date_to = dateadd(dd,1,@to)
declare @sql nvarchar (max)
SET @sql = 'select user_name, guid, contact_fullname, phone_mobile, date_of_completion, completeness_digitizing from sugarcrm_revoup.v_task_completeness_digitizing where date_of_completion between '''''+cast(@date_from as char(10))+'''''  and '''''+cast(@date_to as char(10))+''''''
IF OBJECT_ID(N'tempdb..#table1', N'U') IS NOT NULL drop table #table1;
CREATE TABLE #table1 (
	[user_name] nvarchar(200),
	[guid] nvarchar(200),
	[contact_fullname] nvarchar(200),
	[phone_mobile] nvarchar(200),
	[date_of_completion] [datetime],
	[completeness_digitizing] [int]
);
--SMS
exec('INSERT INTO #table1 SELECT * FROM OPENQUERY([SUGARCRM-DWH],'''  + @sql + ''')')
DROP TABLE IF EXISTS #v_digitalization_tasks;
SELECT * INTO #v_digitalization_tasks
FROM OPENQUERY ([APPMODULE-DWH], 'select * from v_digitalization_tasks')
DROP TABLE IF EXISTS #tasks;
SELECT *
INTO #tasks
FROM #v_digitalization_tasks
WHERE cast(processed_at AS date) BETWEEN @date_from AND @date_to
DROP TABLE IF EXISTS #v_users;
SELECT * INTO #v_users
FROM OPENQUERY ([APPMODULE-DWH], 'select * from v_users')
IF OBJECT_ID(N'tempdb..#table2', N'U') IS NOT NULL drop table #table2;
select [user_name], [guid], [contact_fullname], [phone_mobile], cast([date_of_completion] as date) date, max([completeness_digitizing]) completeness_digitizing
into #table2
from #table1
group by [user_name], [guid], [contact_fullname], [phone_mobile], cast([date_of_completion] as date)
INSERT INTO #table2 ([user_name], [guid], [contact_fullname], [phone_mobile], DATE, completeness_digitizing)
SELECT v.[login], NULL, NULL, NULL, CAST(t.processed_at AS DATE) AS dttm, 0
FROM #tasks t
JOIN #v_users v ON t.processed_by = v.id
SELECT [user_name], [date], case when completeness_digitizing = 0 then N'Кол-во факт Оцифровка 0 полей'
when completeness_digitizing between 1 and 3 then N'Кол-во факт Оцифровка 1-3 поля'
when completeness_digitizing between 4 and 7 then N'Кол-во факт Оцифровка 4-7 поля'
when completeness_digitizing > 7 then N'Кол-во факт Оцифровка 8 и более' END [name], count(*) cnt
 from #table2
group BY [user_name], [date], case when completeness_digitizing = 0 then N'Кол-во факт Оцифровка 0 полей'
when completeness_digitizing between 1 and 3 then N'Кол-во факт Оцифровка 1-3 поля'
when completeness_digitizing between 4 and 7 then N'Кол-во факт Оцифровка 4-7 поля'
when completeness_digitizing > 7 then N'Кол-во факт Оцифровка 8 и более' END
IF OBJECT_ID(N'tempdb..#table1', N'U') IS NOT NULL drop table #table1;
IF OBJECT_ID(N'tempdb..#table2', N'U') IS NOT NULL drop table #table2;
GO