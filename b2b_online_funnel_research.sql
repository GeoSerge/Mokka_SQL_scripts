-- iframe funnel
select convert(nvarchar(6), timestamp, 112) month
	 , action
	 , count(*) users
	 , count(distinct internal_customer_id) unique_users
from exponea.iframe
group by convert(nvarchar(6), timestamp, 112), action
order by convert(nvarchar(6), timestamp, 112), action

-- application funnel
select convert(nvarchar(6), timestamp, 112) month
	 , count(*) records
	 , count(distinct a.internal_customer_id) application_unique_users
	 , count(distinct l.client_key) loan_unique_users
from exponea.application a
left join CDM.loan l on l.loan_application_guid = a.loan_application_guid
where a.timestamp >= '2021-08-01'
group by convert(nvarchar(6), timestamp, 112)
order by convert(nvarchar(6), timestamp, 112)

-- online b2b loans in Sep-21 105,820
select count(*)
from CDM.loan l
left join risk_DM.risk_application ra on ra.loan_application_key = l.loan_application_key
where (ra.channel_type = 'Full_online' or ra.channel_type = 'Online')
	and ra.application_dt between '2021-09-01' and '2021-09-30'
	and (case when ra.chain_nm in (N'Перевод на карту', N'RevoPay', N'Оплата услуг')
		 or ra.store_nm like N'%Мокка — займ на карту%'
		 or ra.store_nm like N'%Мокка — Подарок другу%'
		 or ra.store_nm like N'%Мокка — оплата услуг%'
		 or ra.store_nm like N'%Карта Рево-Онлайн%'
		 or ra.store_nm like N'%Мокка — Виртуальная карта%'
		 or ra.store_nm like N'%Мокка- займы на карту%' then 1
		else 0 end) = 0
	--and (case when ra.first_loan_flg = 1
	--	 or ra.first_application_flg = 1
	--	 or l.repeated_flg is null then ra.first_trader_nm
	--	else ra.trader_nm end) = N'Мокка'
	and ra.conversion_flg = 1

-- online applications in Sep-21 Full_online: 475,286 Full+online = 643,484
select count(*)
from risk_DM.risk_application ra
where (ra.channel_type = 'Full_online' or ra.channel_type = 'Online') and ra.application_dt between '2021-09-01' and '2021-09-30'

-- online applications in Sep-21 (exponea) 704,154
select count(*)
from exponea.application
where timestamp between '2021-09-01' and '2021-09-30'

-- successful online purchase in app in Sep-21 9,700
select top(1000)*
from exponea.shops

-- number of views and clicks in app in Sep-21 | views: 52,483 clicks: 35,410
select action, count(*), count(distinct internal_customer_id)
from exponea.shops
where action in ('click_on_button', 'view_trader_page') and timestamp between '2021-09-01' and '2021-09-30'
group by action

-- successful online purchase in browser 537
select *
from exponea.iframe
where timestamp between '2021-09-01' and '2021-09-30' and action = 'success_purchase'

-- b2b funnel online