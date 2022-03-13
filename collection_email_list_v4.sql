select top(1000)
	CONVERT(nvarchar(7), timestamp, 112) as month_year
	, internal_customer_id
	, client_key
	, status
	, min(timestamp) as min_ts
	, DENSE_RANK() OVER (PARTITION BY internal_customer_id ORDER BY timestamp) as [rank]
from exponea.campaign
where 1=1
	and timestamp between '2022-01-01' and '2022-01-31'
	and campaign_id = '5f773d2e538804a5f76124d1'
	and action_type = 'email'
	and status in ('enqueued', 'delivered', 'opened', 'clicked')
order by internal_customer_id, timestamp