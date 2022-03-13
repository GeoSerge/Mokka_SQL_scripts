select sum(iframe_open_d), sum(auth_page_d), sum(sms_confirm_d), sum(success_auth_d), sum(payment_schedule_d), sum(success_purchase_d) from
(SELECT
 fo.client_key
,fo.internal_customer_id
,fo.date_action
,fo.os
,fo.device
,fo.trader_keys
,fo.browser
,fo.trader
,fo.iFrame_open
,ap.auth_page
,sms.sms_confirm
,sa.success_auth
,ps.payment_schedule
,sp.success_purchase
,fo.iframe_open_d
,ap.auth_page_d
,sms.sms_confirm_d
,sa.success_auth_d
,ps.payment_schedule_d
,sp.success_purchase_d
FROM (SELECT DISTINCT client_key
	,internal_customer_id
	,CAST([timestamp] AS DATE) AS date_action
	,os
	,trader_keys
	,browser
	,trader
	,device
	,COUNT(DISTINCT internal_customer_id) AS iframe_open_d
	,COUNT(internal_customer_id) AS iframe_open
	FROM [exponea].[iframe] (nolock) WHERE [action] = 'iframe_open'
	GROUP BY client_key, internal_customer_id, CAST([timestamp] AS DATE), os, trader_keys, browser, trader, device) AS fo
LEFT JOIN (SELECT DISTINCT client_key
	,internal_customer_id
	,CAST([timestamp] AS DATE) AS date_action
	,os
	,trader_keys
	,browser
	,trader
	,device
	,COUNT(DISTINCT internal_customer_id) AS auth_page_d
	,COUNT(internal_customer_id) AS auth_page
	FROM [exponea].[iframe] (nolock) WHERE [action] = 'auth_page'
	GROUP BY client_key, internal_customer_id, CAST([timestamp] AS DATE), os, trader_keys, browser, trader, device) AS ap ON ap.internal_customer_id = fo.internal_customer_id
																					AND ap.trader_keys = fo.trader_keys
																					AND ap.date_action = fo.date_action
LEFT JOIN (SELECT DISTINCT client_key
	,internal_customer_id
	,CAST([timestamp] AS DATE) AS date_action
	,os
	,trader_keys
	,browser
	,trader
	,device
	,COUNT(DISTINCT internal_customer_id) AS sms_confirm_d
	,COUNT(internal_customer_id) AS sms_confirm
	FROM [exponea].[iframe] (nolock) WHERE [action] = 'sms_confirm'
	GROUP BY client_key, internal_customer_id, CAST([timestamp] AS DATE), os, trader_keys, browser, trader, device) AS sms ON sms.internal_customer_id = fo.internal_customer_id
																					AND sms.trader_keys = fo.trader_keys
																					AND sms.date_action = fo.date_action
																					AND ap.auth_page_d = 1
LEFT JOIN (SELECT DISTINCT client_key
	,internal_customer_id
	,CAST([timestamp] AS DATE) AS date_action
	,os
	,trader_keys
	,browser
	,trader
	,device
	,COUNT(DISTINCT internal_customer_id) AS payment_schedule_d
	,COUNT(internal_customer_id) AS payment_schedule
	FROM [exponea].[iframe] (nolock) WHERE [action] = 'payment_schedule'
	GROUP BY client_key, internal_customer_id, CAST([timestamp] AS DATE), os, trader_keys, browser, trader, device) AS ps ON ps.internal_customer_id = fo.internal_customer_id
																					AND ps.trader_keys = fo.trader_keys
																					AND ps.date_action = fo.date_action
																					AND ap.auth_page_d = 1
LEFT JOIN (SELECT DISTINCT client_key
	,internal_customer_id
	,CAST([timestamp] AS DATE) AS date_action
	,os
	,trader_keys
	,browser
	,trader
	,device
	,COUNT(DISTINCT internal_customer_id) AS success_auth_d
	,COUNT(internal_customer_id) AS success_auth
	FROM [exponea].[iframe] (nolock) WHERE [action] = 'success_auth'
	GROUP BY client_key, internal_customer_id, CAST([timestamp] AS DATE), os, trader_keys, browser, trader, device) AS sa ON sa.internal_customer_id = fo.internal_customer_id
																					AND sa.trader_keys = fo.trader_keys
																					AND sa.date_action = fo.date_action
																					AND ap.auth_page_d = 1
LEFT JOIN (SELECT DISTINCT client_key
	,internal_customer_id
	,CAST([timestamp] AS DATE) AS date_action
	,os
	,trader_keys
	,browser
	,trader
	,device
	,COUNT(DISTINCT internal_customer_id) AS success_purchase_d
	,COUNT(internal_customer_id) AS success_purchase
	FROM [exponea].[iframe] (nolock) WHERE [action] = 'success_purchase'
	GROUP BY client_key, internal_customer_id, CAST([timestamp] AS DATE), os, trader_keys, browser, trader, device) AS sp ON sp.internal_customer_id = fo.internal_customer_id
																					AND sp.trader_keys = fo.trader_keys
																					AND sp.date_action = fo.date_action
																					AND ps.payment_schedule_d = 1) query
where date_action between '2021-09-01' and '2021-09-30'

select action, count(*), count(distinct internal_customer_id)
from exponea.iframe
where timestamp between '2021-09-01' and '2021-09-30'
group by action

--select *
--from exponea.iframe
--where action = 'success_auth' and trader <> 'Lamoda'

--select *
--from exponea.iframe
--where internal_customer_id in (
--select internal_customer_id
--from exponea.iframe
--where action = 'success_auth' and trader <> 'Lamoda'
--)
--order by internal_customer_id, timestamp
with cte as (
select internal_customer_id, os, browser, device, trader, action, min(timestamp) min_ts
from exponea.iframe
--where internal_customer_id = '5cebd10da12f110001e75503'
group by internal_customer_id, os, browser, device, trader, action
--order by internal_customer_id, min_ts
)
select action, count(distinct internal_customer_id)
from cte
where trader = 'Lamoda'
group by action

select top(1000)*
from exponea.iframe
where internal_customer_id = '5cebd10da12f110001e75503'
order by internal_customer_id, timestamp, action

select internal_customer_id, count(distinct trader) unique_traders, count(action)
from exponea.iframe
where action = 'iFrame_open'
group by internal_customer_id
having count(distinct trader) = 1 and count(action) > 1

create view tableau.V_B2B_ONLINE_FUNNEL as
select 'web', internal_customer_id, category, os, browser, device, trader, action, min(timestamp) min_ts
from exponea.iframe
where action in ('iFrame_open','auth_page','payment_schedule','success_purchase','success_auth', 'sms_confirm')
group by internal_customer_id, category, os, browser, device, trader, action

union all

select 'app', internal_customer_idaction, count(*) cnt, count(distinct internal_customer_id) unique_users
from exponea.shops
group by action
order by unique_users desc
where action in ('city_select', 'main_screen', 'filter', 'map', 'view_trader_page', 'click_on_button')




select top(1000)*
from exponea.application ea
left join exponea.shops sh on sh.internal_customer_id = ea.internal_customer_id
where sh.internal_customer_id is not null

select top(1000)*
from exponea.iframe
where trader = 'Lamoda'

select case
when ra.chain_nm in (N'Перевод на карту', N'RevoPay', N'Оплата услуг')
 or ra.store_nm like N'%Мокка — займ на карту%'
 or ra.store_nm like N'%Мокка — Подарок другу%'
 or ra.store_nm like N'%Мокка — оплата услуг%'
 or ra.store_nm like N'%Карта Рево-Онлайн%'
 or ra.store_nm like N'%Мокка — Виртуальная карта%'
 or ra.store_nm like N'%Мокка- займы на карту%' then 1
else 0 end mokka_b2c_product,
count(*)
from exponea.application ea
left join risk_DM.risk_application ra on ra.loan_application_guid = ea.loan_application_guid
where ea.timestamp > '2021-12-01' and ea.internal_customer_id in (select distinct internal_customer_id from exponea.shops where timestamp > '2021-12-01')
group by case
when ra.chain_nm in (N'Перевод на карту', N'RevoPay', N'Оплата услуг')
 or ra.store_nm like N'%Мокка — займ на карту%'
 or ra.store_nm like N'%Мокка — Подарок другу%'
 or ra.store_nm like N'%Мокка — оплата услуг%'
 or ra.store_nm like N'%Карта Рево-Онлайн%'
 or ra.store_nm like N'%Мокка — Виртуальная карта%'
 or ra.store_nm like N'%Мокка- займы на карту%' then 1
else 0 end



select top(1000)*
exponea.shops
where browser is null


select top(1000)*
from exponea.shops
where browser is null

select top(1000)apl.loan_application_guid, apl.timestamp, la.application_dt
from exponea.application apl
left join CDM.loan_application la on la.loan_application_guid = apl.loan_application_guid

select top(1000)*
from exponea.application

select *
from CDM.loan_application
where loan_application_guid = 492622190