with campaign as (
	select client_key
		, internal_customer_id
		, status
		, min(timestamp) min_ts
	from exponea.campaign WITH (Index(0))
	--IGNORE INDEX (IDX_campaign_key_time, exponea_campaign_client_key	)
	where 1=1
		and campaign_id = '5f773d2e538804a5f76124d1'
		and action_type = 'email'
		and timestamp between '2022-02-01 00:00:00' and '2022-02-07 23:59:59'
	group by client_key, internal_customer_id, status
	), funnel as (
		select client_key, internal_customer_id, status, min_ts, DENSE_RANK() over (partition by client_key order by min_ts) as rank
		from campaign
		where status in ('enqueued', 'delivered', 'opened', 'clicked')
		)
select *
from funnel
order by client_key, rank