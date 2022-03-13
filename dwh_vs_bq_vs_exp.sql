--просто enqueued
select count(*), count(distinct internal_customer_id)
from exponea.campaign
where 1=1
	and timestamp between '2021-11-01 00:00:00' and '2021-11-30 23:59:59'
	and campaign_id = '5f773d2e538804a5f76124d1'
	and action_type = 'email'
	and status = 'enqueued'

--просто delivered
select count(*), count(distinct internal_customer_id)
from exponea.campaign
where 1=1
	and timestamp between '2021-11-01 00:00:00' and '2021-11-30 23:59:59'
	and campaign_id = '5f773d2e538804a5f76124d1'
	and action_type = 'email'
	and status = 'delivered'

--просто opened
select count(*), count(distinct internal_customer_id)
from exponea.campaign
where 1=1
	and timestamp between '2021-11-01 00:00:00' and '2021-11-30 23:59:59'
	and campaign_id = '5f773d2e538804a5f76124d1'
	and action_type = 'email'
	and status = 'opened'

--просто clicked
select count(*), count(distinct internal_customer_id)
from exponea.campaign
where 1=1
	and timestamp between '2021-11-01 00:00:00' and '2021-11-30 23:59:59'
	and campaign_id = '5f773d2e538804a5f76124d1'
	and action_type = 'email'
	and status = 'clicked'

--delivered from enqueued
--delivered within 3 days and in enqueued
--opened from delivered and delivered from enqueued
--opened within 3 days and in delivered