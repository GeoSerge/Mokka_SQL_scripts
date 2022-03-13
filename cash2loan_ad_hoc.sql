with cash2loan as (
	 select distinct client_key
	 from risk_DM.risk_application
	 where application_dt between DATEADD(day, -180, getdate()) and GETDATE() and (chain_nm like N'%карту%' or store_nm like N'%карту%')
	 )
select crh.client_key, cl.FirstName, cl.MiddleName, cl.LastName, cpn.mobile_phone_num, cl.TotalLoanLimit, c.client_region_nm
from CDM.client_risk_hist crh
left join dbo.Client cl on cl.ClientKey = crh.client_key
left join CDM.client c on c.client_key = crh.client_key
left join CDM.client_phone_num cpn on cpn.client_key = crh.client_key
left join cash2loan c2l on c2l.client_key = crh.client_key
where ((effective_to_dttm between DATEADD(day, -180, GETDATE()) and GETDATE()) or (effective_from_dttm between DATEADD(day, -180, GETDATE()) and GETDATE()))
	 and (cash_2_card = 1 or cash_2_card_extended = 1)
	 and c2l.client_key is null
	 and cl.RegistrationDate between '2021-09-01' and '2021-12-31'

select count(distinct client_key)
from risk_DM.risk_application
where application_dt between DATEADD(day, -180, getdate()) and GETDATE() and (chain_nm like N'%карту%' or store_nm like N'%карту%')

select distinct chain_nm --store_nm
from CDM.loan_application
where application_dt > '2021-12-01' and chain_nm like N'%карту%'

select distinct chain_nm --store_nm
from CDM.loan_application
where application_dt > '2021-01-01' and chain_nm like N'%еревод%'