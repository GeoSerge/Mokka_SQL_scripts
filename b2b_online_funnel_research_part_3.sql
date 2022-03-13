with cte as (
select internal_customer_id, count(case when action = 'iFrame_open' then category end) ifr, count(case when action = 'sms_confirm' then category end) auth
from exponea.iframe
group by internal_customer_id
having count(case when action = 'iFrame_open' then category end) = 0 and count(case when action = 'sms_confirm' then category end) > 0
	)
select count(distinct internal_customer_id)
from cte

select count(distinct internal_customer_id)
from exponea.iframe

select top(1000)internal_customer_id, timestamp, trader, category, action
from exponea.iframe
where category = 'product_card'
order by internal_customer_id, timestamp

select top(1000)*
from exponea.iframe
where category = 'product_card' and internal_customer_id = '5cebd3bfc471420001a6b17e'
order by timestamp

-- count actual loans in DWH by application_dt
select 'b2b online loans: application in December', count(distinct l.loan_key) loans, count(distinct l.client_key) clients, count(*) total_count
from CDM.loan l
left join risk_DM.risk_application ra on ra.loan_application_key = l.loan_application_key
where ra.application_dt between '2021-12-01' and '2021-12-31'
	and ra.channel_type = 'Full_online'
	and (case when ra.chain_nm in (N'Перевод на карту', N'RevoPay', N'Оплата услуг')
			   or ra.store_nm like N'%Мокка — займ на карту%'
			   or ra.store_nm like N'%Мокка — Подарок другу%'
			   or ra.store_nm like N'%Мокка — оплата услуг%'
			   or ra.store_nm like N'%Карта Рево-Онлайн%'
			   or ra.store_nm like N'%Мокка — Виртуальная карта%'
			   or ra.store_nm like N'%Мокка- займы на карту%' then 1
		else 0 end) = 0

-- count actual loans in DWH by start_dt
select 'b2b online loans: start in December', count(distinct l.loan_key) loans, count(distinct l.client_key) clients, count(*) total_count
from CDM.loan l
left join risk_DM.risk_application ra on ra.loan_application_key = l.loan_application_key
where l.start_dt between '2021-12-01' and '2021-12-31'
	and ra.channel_type = 'Full_online'
	and (case when ra.chain_nm in (N'Перевод на карту', N'RevoPay', N'Оплата услуг')
			   or ra.store_nm like N'%Мокка — займ на карту%'
			   or ra.store_nm like N'%Мокка — Подарок другу%'
			   or ra.store_nm like N'%Мокка — оплата услуг%'
			   or ra.store_nm like N'%Карта Рево-Онлайн%'
			   or ra.store_nm like N'%Мокка — Виртуальная карта%'
			   or ra.store_nm like N'%Мокка- займы на карту%' then 1
		else 0 end) = 0

-- count successful purchases in iframe
select 'web (iframe)', count(distinct internal_customer_id) clients, count(*) total_count
from exponea.iframe
where timestamp between '2021-12-01' and '2021-12-31' and action = 'success_purchase'

-- count clicks on button in shops
select 'app & web (shops)', count(distinct internal_customer_id) clients_clicked, count(*) clicks_total_count
from exponea.shops
where timestamp between '2021-12-01' and '2021-12-31' and (user_action = 'click_button' or action = 'click_on_button')

-- intersection btw iframe and shops
--select ifr.internal_customer_id, sh.internal_customer_id, ifr.timestamp, ifr.action, ifr.device, sh.timestamp, sh.action, sh.user_action, sh.device
--from exponea.iframe ifr
--left join exponea.shops sh on sh.internal_customer_id = ifr.internal_customer_id and cast(ifr.timestamp as date) = cast(sh.timestamp as date)
--where sh.internal_customer_id is not null and sh.browser is null
--order by ifr.internal_customer_id, ifr.timestamp