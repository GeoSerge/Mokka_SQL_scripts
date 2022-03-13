-- option#1: on the level of internal_customer_id
--create view tableau.V_B2B_ONLINE_FUNNEL as
select internal_customer_id
	  , 'iframe' as source
	  , 'web' as app_or_web
	  , category
	  , os
	  , browser
	  , device
	  , trader
	  , NULL as site_category
	  , action
	  , min(timestamp) min_ts
into #b2b_online_funnel
from exponea.iframe
where action <> 'resend_sms'
group by internal_customer_id, category, os, browser, device, trader, action

union all

select internal_customer_id
	  , 'shops' as source
	  , case when browser IS NULL then 'app'
			 else 'web' end as app_or_web
	  , category
	  , os
	  , browser
	  , device
	  , coalesce(shop_name, brand_name) as trader
	  , site_category
	  , coalesce(action, user_action) as action
	  , min(timestamp) mint_ts
from exponea.shops
where coalesce(action, user_action) in ('view_trader_page', 'click_on_button', 'click_button')
group by internal_customer_id
	  , case when browser IS NULL then 'app' else 'web' end
	  , category
	  , os
	  , browser
	  , device
	  , coalesce(shop_name, brand_name)
	  , site_category
	  , coalesce(action, user_action)

-- option #2: grouped by stage levels

select category, action, count(*) cnt, count(distinct internal_customer_id) cnt_distinct
from #b2b_online_funnel
where source = 'iframe' and min_ts between '2021-12-01' and '2021-12-30'
group by category, action
order by category, cnt_distinct desc
-----------------------------------------------------------------------
select action, count(*) cnt, count(distinct internal_customer_id) cnt_distinct
from #b2b_online_funnel
where source = 'iframe' and min_ts between '2021-12-01' and '2021-12-30'
group by action
order by cnt_distinct desc

select action, count(*) cnt, count(distinct internal_customer_id) cnt_distinct
from exponea.iframe
where timestamp between '2021-12-01' and '2021-12-30'
group by action
order by cnt_distinct desc
--------------------------------------------------

select category, action, count(*) cnt, count(distinct internal_customer_id) cnt_distinct
from exponea.iframe
where timestamp between '2021-12-01' and '2021-12-30'
group by category, action
order by category, cnt_distinct desc

select top(1000)internal_customer_id
	 , timestamp
	 , os
	 , trader_keys
	 , action
	 , category
	 , device
from exponea.iframe
where timestamp between '2021-12-01' and '2021-12-30' and internal_customer_id in (
	select internal_customer_id
	from exponea.iframe
	where timestamp between '2021-12-01' and '2021-12-30'
	group by internal_customer_id
	having count(distinct category) > 1
	)
order by internal_customer_id, timestamp

select category, count(*), count(distinct internal_customer_id)
from exponea.iframe
where action = 'iFrame_open'
group by category

select CONVERT(nvarchar(6), timestamp, 112), count(*)
from exponea.iframe
where action = 'payment_schedule'
group by CONVERT(nvarchar(6), timestamp, 112)
order by CONVERT(nvarchar(6), timestamp, 112)