--CREATE INDEX exponea_campaign_client_key
--ON exponea.campaign (client_key);

with enqueuers as (
	select client_key -- internal_customer_id
		 , min(timestamp) min_ts
	from exponea.campaign
	where campaign_id = '5f773d2e538804a5f76124d1'
	  and status = 'enqueued'
	  and action_type = 'email'
	  and timestamp between '2021-11-01 00:00:00' and '2021-11-30 23:59:59'
	group by client_key
	),
	 deliverers as (
	select c.client_key -- internal_customer_id
		 , min(c.timestamp) min_ts
	from enqueuers e
	inner join exponea.campaign c on c.client_key = e.client_key --and c.timestamp > e.min_ts
	where c.status = 'delivered'
	  and c.action_type = 'email'
	  and c.timestamp between '2021-11-01 00:00:00' and '2021-11-30 23:59:59' --remove
	group by c.client_key
	)
	,
	 openers as (
	select c.client_key
		 , min(c.timestamp) min_ts
	from deliverers d
	inner join exponea.campaign c on c.client_key = d.client_key
	where c.status = 'opened'
	  and c.action_type = 'email'
	  and c.timestamp between '2021-11-01 00:00:00' and '2021-11-30 23:59:59' --remove
	group by c.client_key
	),
	 clickers as (
	select c.client_key
		 , min(c.timestamp) min_ts
	from openers o
	inner join exponea.campaign c on c.client_key = o.client_key
	where c.status = 'clicked'
	  and c.action_type = 'email'
	  and c.timestamp between '2021-11-01 00:00:00' and '2021-11-30 23:59:59' --remove
	group by c.client_key
	)
--select count(distinct client_key) from enqueuers
--union
--select count(distinct client_key) from deliverers
--union
--select count(distinct client_key) from openers
--union
--select count(distinct client_key) from clickers
select e.client_key, e.min_ts, d.*, o.*, c.* from enqueuers e
left join (
select client_key, min_ts from deliverers) d on d.client_key = e.client_key
left join (
select client_key, min_ts from openers) o on o.client_key = e.client_key
left join (
select client_key, min_ts from clickers) c on c.client_key = e.client_key
where DATEDIFF(hour, e.min_ts, coalesce(c.min_ts, o.min_ts, d.min_ts)) <= 72
