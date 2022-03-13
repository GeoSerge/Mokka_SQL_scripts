create view tableau.V_B2B_ONLINE_FUNNEL_V2 as
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