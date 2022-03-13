with loans_dec_nov as (
select distinct l.client_key
from Revo_DW.dbo.LoanExposureManagement lem
left join Revo_DW.CDM.loan l on l.loan_key = lem.LoanKey
where TransactionDate between '2021-11-01' and '2021-12-31'
),
	client_phone_num_wf as (
select DENSE_RANK() OVER (partition by mobile_phone_num order by client_key) as dr
	 , client_key
	 , mobile_phone_num
from Revo_DW.CDM.client_phone_num
	 ),
	 client_phone_num as (
select *
from client_phone_num_wf
where dr = 1
	)
SELECT sms.phone_number
	 , sms.[count]
	 , cpn.client_key
	 , cpn.mobile_phone_num
	 , ldn.client_key
	 , case when cpn.client_key is not null then 1 else 0 end our_clients
	 , case when ldn.client_key is not null then 1 else 0 end our_clients_w_active_products
--SELECT count(distinct case when cpn.client_key is not null then sms.phone_number end) our_clients
--	 , count(distinct case when ldn.client_key is not null then sms.phone_number end) had_active_product_nov_dec21
--	 , count(distinct case when cpn.client_key is null then sms.phone_number end) not_our_clients
from [user_data].[ dbo].[sms_to_check] sms
left join client_phone_num  cpn on CAST(sms.phone_number as nvarchar(15)) = '7' + cpn.mobile_phone_num
left join loans_dec_nov ldn on ldn.client_key = cpn.client_key
order by sms.phone_number

