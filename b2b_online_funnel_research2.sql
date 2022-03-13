USE [Revo_DW]
GO

/****** Object:  View [tableau].[V_B2B_ONLINE_FUNNEL]    Script Date: 31.01.2022 9:42:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [tableau].[V_B2B_ONLINE_FUNNEL] as
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
GO

with cte as (
select internal_customer_id
	 , count(distinct case when action = 'success_reg' then internal_customer_id end) reg_success_cnt
	 , count(distinct case when action = 'success_purchase' then internal_customer_id end) success_purchase_cnt
from exponea.iframe
where timestamp > '2021-12-01'
group by internal_customer_id
having count(distinct case when action = 'success_reg' then internal_customer_id end) > 0 and count(distinct case when action = 'success_purchase' then internal_customer_id end) > 0
	)
select ifr.internal_customer_id, ifr.timestamp, ifr.trader, action, category
from exponea.iframe ifr
left join cte on cte.internal_customer_id = ifr.internal_customer_id
where timestamp > '2021-12-01' and cte.internal_customer_id is not null
order by ifr.internal_customer_id, timestamp --'5cebd75523d7920001b945bd'

select *
from tableau.V_B2B_ONLINE_FUNNEL
where iframe_open = '5cebd75523d7920001b945bd'
	or auth_page = '5cebd75523d7920001b945bd'
	or sms_confirm = '5cebd75523d7920001b945bd'
	or reg_success = '5cebd75523d7920001b945bd'
	or payment_schedule = '5cebd75523d7920001b945bd'
	or success_purchase = '5cebd75523d7920001b945bd'

select timestamp, os, browser, trader, action, category, device
from exponea.iframe 
where internal_customer_id = '5cebd75523d7920001b945bd'
order by timestamp

select internal_customer_id, trader, category, action, min(timestamp)
from exponea.iframe 
where internal_customer_id = '5cebd75523d7920001b945bd'
group by internal_customer_id, trader, category, action
order by min(timestamp)

select internal_customer_id, category, action, min(timestamp), min(case when action = 'iFrame_open' then timestamp end)
from exponea.iframe 
where internal_customer_id = '5cebd75523d7920001b945bd'
group by internal_customer_id, category, action
order by min(timestamp)

select category, action, count(distinct internal_customer_id), min(case when action = 'iFrame_open' then timestamp end)
from exponea.iframe 
--where internal_customer_id = '5cebd75523d7920001b945bd'
group by category, action
order by category, action
--order by min(timestamp)

create view tableau.V_B2B_ONLINE_FUNNEL13 as
with cte as (
select internal_customer_id
	 , min(case when action = 'iFrame_open' then timestamp end) iframe_min_ts
	 , min(case when action = 'sms_confirm' then timestamp end) sms_min_ts
	 , min(case when action = 'payment_schedule' then timestamp end) schedule_min_ts
	 , min(case when action = 'success_purchase' then timestamp end) purchase_min_ts
	 , min(case when action = 'success_reg' then timestamp end) reg_min_ts
	 , min(case when category = 'product_card' then timestamp end) product_card_min_ts
	 , min(case when category = 'checkout' then timestamp end) checkout_min_ts
from exponea.iframe
--where internal_customer_id = '5cebd75523d7920001b945bd'
group by internal_customer_id
	), min_ts_by_id_trader_category as (
select internal_customer_id
	 , trader
	 , category
	 , min(case when action = 'iFrame_open' then timestamp end) iframe_min_ts_by_trader_category
	 , min(case when action = 'sms_confirm' then timestamp end) sms_min_ts_by_trader_category
	 , min(case when action = 'payment_schedule' then timestamp end) schedule_min_ts_by_trader_category
	 , min(case when action = 'success_purchase' then timestamp end) purchase_min_ts_by_trader_category
	 , min(case when action = 'success_reg' then timestamp end) reg_min_ts_by_trader_category
	 , min(case when category = 'product_card' then timestamp end) product_card_min_ts_by_trader_category
	 , min(case when category = 'checkout' then timestamp end) checkout_min_ts_by_trader_category
from exponea.iframe
--where internal_customer_id = '5cebd75523d7920001b945bd'
group by internal_customer_id, trader, category
	), cte2 as (
select ifr.internal_customer_id
	 , ifr.trader
	 , ifr.category
	 , ifr.action
	 , min(ifr.timestamp) min_ts
	 , min(cte.iframe_min_ts) iframe_min_ts
	 , min(cte.sms_min_ts) sms_min_ts
	 , min(cte.schedule_min_ts) schedule_min_ts
	 , min(cte.purchase_min_ts) purchase_min_ts
	 , min(cte.reg_min_ts) reg_min_ts
	 , min(cte.product_card_min_ts) product_card_min_ts
	 , min(cte.checkout_min_ts) checkout_min_ts
--into #check
from exponea.iframe ifr
left join cte on cte.internal_customer_id = ifr.internal_customer_id-- and cte.trader = ifr.trader and cte.category = ifr.category
--where ifr.internal_customer_id = '5cebd75523d7920001b945bd'
group by ifr.internal_customer_id, ifr.trader, ifr.category, ifr.action
--order by min(ifr.timestamp)
	)
select cte2.internal_customer_id
	 , cte2.trader
	 , cte2.category
	 , cte2.action
	 , cte2.min_ts
	 , DENSE_RANK() over (partition by cte2.internal_customer_id, cte2.trader, cte2.category order by cte2.min_ts) as dr_by_id_trader_category
	 , DENSE_RANK() over (partition by cte2.internal_customer_id, cte2.category order by cte2.min_ts) as dr_by_id_category
	 , DENSE_RANK() over (partition by cte2.internal_customer_id order by cte2.min_ts) as dr_by_id
	 , cte2.iframe_min_ts
	 , cte2.sms_min_ts
	 , cte2.schedule_min_ts
	 , cte2.purchase_min_ts
	 , cte2.reg_min_ts
	 , cte2.product_card_min_ts
	 , cte2.checkout_min_ts
	 , mt.iframe_min_ts_by_trader_category
	 , mt.sms_min_ts_by_trader_category
	 , mt.schedule_min_ts_by_trader_category
	 , mt.purchase_min_ts_by_trader_category
	 , mt.reg_min_ts_by_trader_category
	 , mt.product_card_min_ts_by_trader_category
	 , mt.checkout_min_ts_by_trader_category
from cte2
left join min_ts_by_id_trader_category mt on mt.internal_customer_id = cte2.internal_customer_id and mt.trader = cte2.trader and mt.category = cte2.category