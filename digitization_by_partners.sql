with cte as (
	select --count(distinct doc.id) --29027 --25156 --25162
		doc.id
		, doc.client_id
		, doc.created_at
		, doc.processed_at
		, la.loan_application_key
		, la.client_key
		, la.application_amt
		, la.application_repeat_type
		, la.application_dttm
		, la.chain_nm
		, la.online_order_id
		, l.start_dt
		, l.principal_amt
		, DATEDIFF(minute, la.application_dttm, DATEADD(hour, 3, doc.created_at)) as time_diff
		, ROW_NUMBER() OVER (PARTITION BY doc.id ORDER BY DATEDIFF(minute, la.application_dttm, DATEADD(hour, 3, doc.created_at)) ASC) rn
	from openquery([APPMODULE-DWH], 'select * from digitized_documents') doc
	left join dbo.digitalization_decisions [dec] on dec.task_id = doc.id
	left join CDM.loan_application la on la.client_key = dec.client_key and CAST(DATEADD(hour, 3, doc.created_at) as date) = la.application_dt
	left join CDM.loan l on l.loan_application_key = la.loan_application_key
	where 1=1
		and doc.created_at between '2022-01-01' and '2022-01-31'
		and (case when la.chain_nm not like '%Связной%' and (la.application_repeat_type = 'preapplication' or la.application_repeat_type = 'repeat preapplication')
				 then 'remove'
				 else 'ok'
			end) = 'ok'
		and DATEDIFF(minute, la.application_dttm, DATEADD(hour, 3, doc.created_at)) > 0
		--and doc.client_id = --7821437--5005308 --5265192 --3291672 join по min(datediff(application_dttm, created_at+3)) в сторону увеличения от application_dttm
		-- убираем repeat preapplication и preapplication
		)
select id
	, client_id
	, application_dttm
	, DATEADD(hour, 3, [created_at]) created_at
	, [processed_at]
	, cte.*
--chain_nm
	--, count(*) cnt
	--, count(distinct cte.id) cnt_dstnct
from cte
where rn = 1
--group by chain_nm
--order by cnt desc
order by client_id, created_at