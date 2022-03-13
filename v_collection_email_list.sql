alter view tableau.V_COLLECTION_EMAIL_LIST as
with campaign as (
	select CONVERT(nvarchar(6), timestamp, 112) as month_year
		, client_key
		, internal_customer_id
		, status
		, min(timestamp) min_ts
	from exponea.campaign
	where 1=1
		and campaign_id = '5f773d2e538804a5f76124d1'
		and action_type = 'email'
		--and timestamp between '2022-02-01 00:00:00' and '2022-02-07 23:59:59'
	group by CONVERT(nvarchar(6), timestamp, 112), client_key, internal_customer_id, status
	), funnel as (
		select campaign.month_year 
			, campaign.client_key
			, campaign.internal_customer_id
			, status
			, campaign.min_ts
			, lead(status) over (partition by campaign.client_key order by campaign.min_ts) second_status
			, lead(campaign.min_ts) over (partition by campaign.client_key order by campaign.min_ts) second_min_ts
			, lead(status, 2) over (partition by campaign.client_key order by campaign.min_ts) third_status
			, lead(campaign.min_ts, 2) over (partition by campaign.client_key order by campaign.min_ts) third_min_ts
			, lead(status, 3) over (partition by campaign.client_key order by campaign.min_ts) fourth_status
			, lead(campaign.min_ts, 3) over (partition by campaign.client_key order by campaign.min_ts) fourth_min_ts
		from campaign
		where status in ('enqueued', 'delivered', 'opened', 'clicked')
		)
select f.*, pv_first.internal_customer_id as auth, pv_first.min_ts auth_min_ts
from funnel f
left join (
	select internal_customer_id, min(timestamp) min_ts
	from exponea.page_visit
	where path = '/cc/noauth-payment/'-- and timestamp between '2022-02-01 00:00:00' and '2022-02-07 23:59:59'
	group by internal_customer_id
	) pv_first on pv_first.internal_customer_id = f.internal_customer_id and pv_first.min_ts > f.fourth_min_ts
where f.status = 'enqueued'
--order by f.internal_customer_id, f.min_ts


