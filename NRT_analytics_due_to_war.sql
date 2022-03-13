-- by traders (all applications)
SELECT 
	REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':') datetime
	, trader_nm
	, sum(requested_sum) requested_sum
	, count(loan_application_id) applications_count
FROM [Revo_DW].[report].[loan_application]
where application_dttm >= '2022-02-24 06:00:00'
group by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), trader_nm
order by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), trader_nm

-- by traders (only approved applications)
SELECT 
	REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':') datetime
	, trader_nm
	, sum(requested_sum) requested_sum
	, count(loan_application_id) applications_count
FROM [Revo_DW].[report].[loan_application]
where 1=1
	and application_dttm >= '2022-02-24 06:00:00'
	and status = 'approved'
group by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), trader_nm
order by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), trader_nm

-- by repeat type (all applications)
SELECT 
	REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':') datetime
	, application_repeat_type
	, sum(requested_sum) requested_sum
	, count(loan_application_id) applications_count
FROM [Revo_DW].[report].[loan_application]
where 1=1
	and application_dttm >= '2022-02-24 06:00:00'
group by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), application_repeat_type
order by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), application_repeat_type

-- by repeat type (all applications)
SELECT 
	REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':') datetime
	, application_repeat_type
	, sum(requested_sum) requested_sum
	, count(loan_application_id) applications_count
FROM [Revo_DW].[report].[loan_application]
where 1=1
	and application_dttm >= '2022-02-24 06:00:00'
	and status = 'approved'
group by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), application_repeat_type
order by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), application_repeat_type

-- by status
SELECT 
	REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':') datetime
	, status
	, sum(requested_sum) requested_sum
	, count(loan_application_id) applications_count
FROM [Revo_DW].[report].[loan_application]
where 1=1
	and application_dttm >= '2022-02-24 06:00:00'
group by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), status
order by REPLACE(CONVERT(VARCHAR(13), application_dttm, 120), ' ', ':'), status

-- tableau
create view tableau.V_NRT_ANALYTICS as
SELECT 
	CONVERT(VARCHAR(13), application_dttm, 120) + ':00' datetime
	, trader_nm
	, application_repeat_type
	, sum(requested_sum) requested_sum
	, count(loan_application_id) applications_count
FROM [Revo_DW].[report].[loan_application]
where 1=1
	and application_dttm >= '2022-02-20 06:00:00'
	and status = 'approved'
group by CONVERT(VARCHAR(13), application_dttm, 120) + ':00', trader_nm, application_repeat_type
--order by CONVERT(VARCHAR(13), application_dttm, 120) + ':00', trader_nm, application_repeat_type

select top(1000)	CONVERT(VARCHAR(13), application_dttm, 120) + ':00' datetime, application_dttm
from report.loan_application

select top(1000)*
from report.loan_application
order by application_dttm desc
--where application_dttm >= '2022-02-24 06:00:00'




select client_region_nm, count(*)
from report.loan_application
where application_dttm > '2022-02-23'
group by client_region_nm