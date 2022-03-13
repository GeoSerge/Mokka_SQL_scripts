with first_action as (
select internal_customer_id, min(timestamp) min_ts
from exponea.iframe
group by internal_customer_id
	), weird_customers as (
select distinct ifr.internal_customer_id
from exponea.iframe ifr
left join first_action fa on fa.internal_customer_id = ifr.internal_customer_id and ifr.timestamp = fa.min_ts
where fa.min_ts is not null and action not in ('iFrame_open', 'sms_confirm', 'resend_sms')--, 'auth_page', 'success_reg')
--where fa.min_ts is not null and action = 'payment_schedule'
	)
select internal_customer_id, timestamp, action, browser, os, device
--select count(distinct internal_customer_id)
from exponea.iframe
where internal_customer_id in (select internal_customer_id from weird_customers)
	--and timestamp >= '2021-12-01'
order by internal_customer_id, timestamp