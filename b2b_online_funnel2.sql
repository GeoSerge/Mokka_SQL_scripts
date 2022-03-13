create view tableau.V_B2B_ONLINE_FUNNEL as
with iframe_open as (
select internal_customer_id, client_key, category, trader, min(timestamp) min_ts, max(timestamp) max_ts
from exponea.iframe
where action = 'iFrame_open'
group by internal_customer_id, client_key, category, trader
),
	sms_confirm as (
select internal_customer_id, client_key, category, trader, min(timestamp) min_ts, max(timestamp) max_ts
from exponea.iframe
where action = 'sms_confirm'
group by internal_customer_id, client_key, category, trader
),
	payment_schedule as (
select internal_customer_id, client_key, category, trader, min(timestamp) min_ts, max(timestamp) max_ts
from exponea.iframe
where action = 'payment_schedule'
group by internal_customer_id, client_key, category, trader
),
	success_purchase as (
select internal_customer_id, client_key, category, trader, min(timestamp) min_ts, max(timestamp) max_ts
from exponea.iframe
where action = 'success_purchase'
group by internal_customer_id, client_key, category, trader
),
	success_auth as (
select internal_customer_id, client_key, category, trader, min(timestamp) min_ts, max(timestamp) max_ts
from exponea.iframe
where action = 'success_auth'
group by internal_customer_id, client_key, category, trader
),
	auth_page as (
select internal_customer_id, client_key, category, trader, min(timestamp) min_ts, max(timestamp) max_ts
from exponea.iframe
where action = 'auth_page'
group by internal_customer_id, client_key, category, trader
),
	success_reg as (
select internal_customer_id, client_key, category, trader, min(timestamp) min_ts, max(timestamp) max_ts
from exponea.iframe
where action = 'success_reg'
group by internal_customer_id, client_key, category, trader
)
select coalesce(io.category, ap.category, sc.category, sr.category, ps.category, sp.category) category
	 , coalesce(io.trader, ap.trader, sc.trader, sr.trader, ps.category, sp.category) trader
	 , io.internal_customer_id iframe_open
	 , ap.internal_customer_id auth_page
	 , sc.internal_customer_id sms_confirm
	 , sr.internal_customer_id reg_success
	 , ps.internal_customer_id payment_schedule
	 , sp.internal_customer_id success_purchase
	 , io.client_key iframe_open_client_key
	 , ap.client_key auth_page_client_key
	 , sc.client_key sms_confirm_client_key
	 , sr.client_key reg_success_client_key
	 , ps.client_key payment_schedule_client_key
	 , sp.client_key success_purchase_client_key
	 , io.min_ts iframe_min_ts
	 , ap.min_ts auth_min_ts
	 , sc.min_ts sms_min_ts
	 , sr.min_ts reg_min_ts
	 , ps.min_ts schedule_min_ts
	 , sp.min_ts purchase_min_ts
from iframe_open io
full outer join sms_confirm sc on sc.internal_customer_id = io.internal_customer_id
	and sc.category = io.category
	and sc.trader = io.trader-- and sc.min_ts > io.min_ts
full outer join auth_page ap on ap.internal_customer_id = coalesce(io.internal_customer_id, sc.internal_customer_id)
	and ap.category =  coalesce(io.category, sc.category)
	and ap.trader = coalesce(io.trader, sc.trader)
left join success_reg sr on sr.internal_customer_id = coalesce(io.internal_customer_id, sc.internal_customer_id)
	and sr.category = coalesce(io.category, sc.category)
	and sr.trader = coalesce(io.trader, sc.trader)
	and sr.min_ts > IIF(io.min_ts < sc.min_ts, io.min_ts, sc.min_ts)
--left join success_auth sa on sa.internal_customer_id = coalesce(io.internal_customer_id, ap.internal_customer_id, sc.internal_customer_id)
--	and sa.category = coalesce(io.category, ap.category, sc.category)
--	and sa.trader = coalesce(io.trader, ap.trader, sc.trader)
--	and sa.min_ts > ap.min_ts
left join payment_schedule ps on ps.internal_customer_id = coalesce(io.internal_customer_id, sc.internal_customer_id, ap.internal_customer_id)
	and ps.category = coalesce(io.category, sc.category, ap.category)
	and ps.trader = coalesce(io.trader, sc.trader, ap.trader)
	and ps.min_ts > IIF(ap.min_ts < coalesce(io.min_ts, sc.min_ts), ap.min_ts, coalesce(io.min_ts, sc.min_ts))
left join success_purchase sp on sp.internal_customer_id = coalesce(io.internal_customer_id, sc.internal_customer_id, ap.internal_customer_id, ps.internal_customer_id)
	and sp.category = coalesce(io.category, sc.category, ap.category, ps.category)
	and sp.trader = coalesce(io.trader, sc.trader, ap.trader, ps.trader)
	and sp.min_ts > IIF(coalesce(io.min_ts, sc.min_ts, ap.min_ts) < ps.min_ts, coalesce(io.min_ts, sc.min_ts, ap.min_ts), ps.min_ts)
where (case when coalesce(io.category, ap.category, sc.category, sr.category, ps.category, sp.category) = 'checkout'
				and coalesce(io.trader, ap.trader, sc.trader, sr.trader, ps.category, sp.category) = 'Lamoda' then 'exclude' else 'include' end) <> 'exclude'