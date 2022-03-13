with client_phone_num_wf as (
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
SELECT sms.reciever as phone_num
	  , cpn.client_key
	  , cpn.mobile_phone_num
from [user_data].[dbo].[sms_to_check2] sms
left join client_phone_num  cpn on CAST(sms.reciever as nvarchar(15)) = '7' + cpn.mobile_phone_num
where cpn.client_key is null
order by phone_num
--sms by not reg clients: 305736
-- total sms: 909000
-- total clients: 309802
-- clients not reg: 104596



