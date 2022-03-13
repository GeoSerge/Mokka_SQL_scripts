USE [Revo_DW]
GO

/****** Object:  View [tableau].[V_RISK_APPLICATION]    Script Date: 08.02.2022 15:45:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER view [tableau].[V_RISK_APPLICATION]
as

select
	 EOMONTH(start_dt) as eomonth_start_dt
	, dateadd(day,1-day(start_dt),start_dt) as somonth_start_dt
	, ra.store_key
	, ra.client_key
	, ra.loan_key
	, ra.loan_application_key
	, ra.application_dt
	, application_amt
	, application_repeat_type
	, pass_number
	, first_nm
	, middle_nm
	, last_nm
	, birth_dt
	, initial_mobile_phone_num
	, same_day_return_flg
	, return_dt
	, new_application_flg
	, first_loan_flg
	, fico_call_flg
	, ra.strategy_version
	, ra.risk_grade
	, ra.limit_post_bureau
	, ra.post_bureau_decline_reason
	, ra.pre_bureau_decline_reason
	, ra.final_decision
	, ra.retailer_chain
	, fico_retailer_chain
	, ra.bki_flg
	, start_dt
	, loan_term
	, principal_amt
	, full_amt
	, CASE WHEN ra.chain_nm = N'Сеть отсутствует в ChainLookup' THEN trader_nm
	WHEN ra.chain_nm = N'Мокка' THEN store_nm
	ELSE ra.chain_nm END chain_nm
	, trader_nm
	, branch_nm
	, region_nm
	, city_nm
	, federal_region_nm
	, ra.challenger
	, ra.first_decline_rule
	, POS_policy_group_desc
	, ra.POS_policy_group
	, has_fico_inquires_flg
	, has_fico_loan_flg
	, conversion_flg
	, approved_flg
	, null as eligible_to_FPD2_flg
	, null as eligible_to_FPD5_flg
	, null as eligible_to_FPD11_flg
	, eligible_to_FPD15_flg
	, null as FPD2_flg
	, null as FPD5_flg
	, null as FPD11_flg
	, FPD15_flg
	, eligible_to_MOB3_flg
	, eligible_to_MOB2_flg
	, eligible_to_MOB6_flg
	, null as MOB3_billing_dpd30_flg
	, null as MOB6_billing_dpd90_flg
	, principal_current_amt
	, principal_overdue_amt
	, interest_current_amt
	, interest_overdue_amt
	, penalties_amt
	, has_mng_balance_flg
	, loan_order_num
	, ra.score8
	, ra.score9
	, score_value
	, source_nm
	, ra.whitelist_flg
	, null as MOB3_billing_dt_interest_due_amt
	, null as MOB3_billing_dt_principal_due_amt
	, null as MOB6_billing_dt_interest_due_amt
	, null as MOB6_billing_dt_principal_due_amt
	, online_flg
	, ra.[MTS_score]
	, ra.[Mail_score]
	, ra.[score8_kari]
	, ra.[score8_mail]
	, ra.[score9_1]
	, ra.[score9_version]
	, ra.[score9_1_mail_mts]
	, ra.[score9_1_mail_megafon]
	, ra.[score9_1_mail_no_telecom]
	, ra.[megafon_score]
	, first_trader_nm
	, first_chain_nm
	, first_store_nm
	, agent_key
	, from_sait_flg
	, ra.[30_numerator_amt]
	, [30_denominator_amt]
	, ra.[60_numerator_amt]
	, [60_denominator_amt]
	, [20_numerator_amt]
	, [40_numerator_amt]
	, [20_denominator_amt]
	, [40_denominator_amt]
	, fpd10_numerator_cnt
	, fpd10_denominator_cnt
	, fpd10_numerator_amt
	, fpd10_denominator_amt
	, eligible_to_FPD10_flg
	, ra.decision_by
	, full_online_flg
	, first_decision_dt
	, ra.channel_type
	, ra.first_channel_type
	, ra.offline_approve
	, ra.online_approve
	, ra.virtual_card_approve
	, ra.psprt_okato
	, ra.psprt_year
	, ra.last_step
	, application_decision_reason
	, agent_flg
	, agent_chain_nm
	, fpd15_numerator_amt
    , fpd15_denominator_amt
	, fpd10_numerator_ps_amt
	, fpd15_numerator_ps_amt
	, suspected_fraud_flg
	, repeat_risk_grade_b2c repeat_risk_grade
	, error_type
	, repeat_risk_grade_b2b
	, first_application_amt
	, conversion_new_numerator
	, conversion_new_denominator
	, CASE WHEN case60.loan_application_key IS NOT NULL THEN 'case_60'
		ELSE ra.black_list_reason END AS black_list_reason
	,[30_numerator_principal_amt]
	,[60_numerator_principal_amt]
	,[30_denominator_principal_amt]
	,[60_denominator_principal_amt]
	,ra.product_code
	
	
--target_mob30
	,case when ra.chain_nm = N'Respect' then	0.00735388
   WHEN ra.chain_nm like N'%Hara'  then	0.00966783599730896
   WHEN ra.chain_nm = N'АДАМАС' then	0.00793612751530524
   WHEN ra.chain_nm = N'Евро Обувь' then	0.0075
   WHEN ra.chain_nm = N'Unichel' then	0.00891020863391421
   WHEN ra.chain_nm = N'MONRO' then	0.0129934313659337
   WHEN ra.chain_nm = N'Belwest' then	0.0084418798793195
   WHEN ra.chain_nm = N'Love Republic' then	0.014666601751849
   WHEN ra.chain_nm = N'Mvideo DirectCredit pick-up' then	0.0597202243037048
   WHEN ra.chain_nm = N'Точка зрения Пермь' then	0.022622347
   WHEN ra.chain_nm = N'Kari' then	0.02625
   WHEN ra.chain_nm = N'Ozon DirectCredit Full Online' then	0.0325758093515121
   WHEN ra.chain_nm = N'INCITY' then	0.033680141
   WHEN ra.chain_nm = N'Детский Мир' then	0.038152268
   WHEN ra.chain_nm = N'Profmax' then	0.03
   WHEN ra.chain_nm = N'Много Мебели' then	0.0335155116241553
   WHEN ra.chain_nm = N'Корпорация Центр OFFLINE' then	0.0311003698664806
   WHEN ra.chain_nm = N'Корпорация Центр ONLINE' then	0.03
   WHEN ra.chain_nm = N'Mvideo DirectCredit offline' then	0.0352043061906583
   WHEN ra.chain_nm = N'Eldorado DirectCredit offline' then	0.0352043061906583
   WHEN ra.chain_nm = N'Lamoda' then	0.0446987760413476
   WHEN ra.chain_nm = N'585' then	0.0449999141020807
   WHEN ra.chain_nm = N'Family' then	0.0423486511879284
   WHEN ra.chain_nm = N'IDB online' then	0.05625
   WHEN ra.chain_nm = N'Eldorado DirectCredit pick-up' then	0.0597202243037048
   WHEN ra.chain_nm = N'Eleganzza' then	0.00375
   when ra.chain_nm = N'Baon' THEN 0.03375
   when ra.chain_nm = N'Золотое Руно' THEN 0.03375
   when ra.chain_nm = N'Ennergiia' THEN 0.0375
   --when ra.chain_nm = N'OneTwoTrip' THEN 0.045
   when ra.chain_nm = N'OneTwoTrip Авиабилеты' THEN 0.03375
   when ra.chain_nm = N'Money Care' THEN 0.0375
   --when ra.chain_nm = N'Связной' THEN 0.03375
   when ra.chain_nm = N'Центр бронирования' THEN 0.03375
   when ra.chain_nm = N'Citilink DirectCredit Online' THEN 0.05625
   when ra.chain_nm = N'INCITY' THEN 0.0281768882386097
   when ra.chain_nm = N'Respect' THEN 0.00906112494466288
   when ra.chain_nm = N'Точка Зрения Пермь' THEN 0.00375
   when ra.chain_nm = N'ЗолотоМания' THEN 0.03
   WHEN ra.chain_nm in (
   N'585', N'36.6',N'Adidas',N'ALBA', N'BELWEST', N'Etaloni',N'Family',N'Finn-Flare',N'INCITY',N'INVITRO',N'Kari','Lanotti',N'Love Republic',
   N'Love Republic (франшиза)',N'MONRO',N'O''Hara',N'Profmax',N'Quiksilver',N'Respect',N'Sasha Fabiani',N'SONA',N'Spartak Shoes', N'Tom Tailor',N'Total',N'Unichel',N'Valtera',
   N'Vitacci',N'WoolHouse',N'ZEldoradoarina (франшиза)',N'Zenden',N'Автосервис Вилгуд',N'АДАМАС',N'Бегемот',N'Бравелли',N'Буду Мамой',N'Детский Мир',N'Евро Обувь',
   N'Зубная формула',N'Мосье Башмаков',N'Примадонна',N'Счастливый Взгляд',N'Точка Зрения Пермь',N'Траектория',N'ЦентрОбувь') then 0.035
   when ra.chain_nm in ('AnexShop','Intourist office','IQOS','LS Mobile','Mobilon','Mvideo DirectCredit offline','Total','Travel Times',N'Диван.ру',N'Коннект',
   N'Корпорация Центр',N'М.Видео',N'Много мебели',N'Радио-М',N'Техносклад',N'Ультра',N'Цифроград',N'OneTwoTrip',N'Связной',N'Связной Онлайн') then 0.05
   when ra.chain_nm in (N'AnnaPolly',N'Babysecret',N'Desporte.ru',N'Ecentr.travel',N'Groupprice',N'IDB online',N'Kcentr DirectCredit online',
   N'Lamoda',N'Mvideo DirectCredit Full Online',N'Mvideo DirectCredit pick-up',N'Ozon DirectCredit Full Online',N'Profmax Online',N'Pudra',
   N'RAMK',N'Total',N'Евро Обувь online',N'Эксклюзивная коллекция',N'Ювелирочка') then 0.05
   --when ra.chain_nm in ('RevoPay', N'Карта Рево-Онлайн',N'Карта Рево-Онлайн (Оле Лукойле)',N'Перевод на карту') then 0.103--0.075
   --when ra.chain_nm in (N'Оплата услуг') then 0.103/*0.05*/
   --новые таргеты 23.03.2021--
   when ra.chain_nm in (N'Перевод на карту' ,
N'Мокка — займ на карту (базовый)' ,
N'Мокка — займ на карту (расширенный)' ,
N'Мокка — займ на карту (среднее снижение ставок пилот)' ,
N'Мокка — займ на карту (существенное снижение ставок пилот)' ,
N'Мокка — займ на карту (базовый)_пилот_2,9%+199' ,
N'Мокка — займ на карту (базовый)_пилот_2,9%+299' ,
N'Мокка — займ на карту (расширенный)_пилот_2,9%+199',
N'Мокка — займ на карту (расширенный)_пилот_2,9%+299',
N'Мокка — займ на карту МИНБ_20.09.2021' ,
N'Мокка- займы на карту 15.07.2021_пилот_Ставки_пополам_R5_10%' ) THEN 0.126
   when ra.chain_nm in (N'RevoPay' ,
N'Мокка — Подарок другу' ,
N'Мокка — Подарок другу_Promo_Ставки_пополам_19.07.2021') THEN 0.158
   when ra.chain_nm in (N'Оплата услуг' ,
N'Мокка — оплата услуг (Mobile)' ,
N'Мокка — оплата услуг (Home)') THEN 0.118
   when ra.chain_nm in (N'Карта Рево-Онлайн' ,
N'Карта Рево-Онлайн (Оле Лукойле)' ,
N'Мокка — Виртуальная карта 2020' ,
N'Мокка — Виртуальная карта 2020 (promo)' ,
N'Мокка — Виртуальная карта Оферта' ,
N'Мокка — Виртуальная карта Оферта (promo)' ,
N'Мокка — Виртуальная карта 2020 (promo)_18.05.2021' ,
N'Мокка — Виртуальная карта 2020_18.05.2021' ,
N'Мокка — Виртуальная карта Оферта (promo)_18.05.2021' ,
N'Мокка — Виртуальная карта Оферта (promo)_03.09.2021' ,
N'Мокка — Виртуальная карта 2020 (promo)_03.09.2021' ) THEN 0.053
	end as [target_mob30]
,CASE
WHEN t_fpd15.chain_nm is not null THEN t_fpd15.tgt_fpd15_new
WHEN t_fpd15.chain_nm is null AND ra.sme_flg = 1 THEN (SELECT tgt_fpd15_new FROM [Revo_DW].[dbo].[dim_target_fpd15] WHERE chain_nm like N'SME project')
WHEN t_fpd15.chain_nm is null AND ra.sme_flg = 0 AND ra.channel_type like N'%offline%' THEN (SELECT tgt_fpd15_new FROM [Revo_DW].[dbo].[dim_target_fpd15] WHERE chain_nm like N'Other_offline')
WHEN t_fpd15.chain_nm is null AND ra.sme_flg = 0 AND ra.channel_type like N'%online%' THEN (SELECT tgt_fpd15_new FROM [Revo_DW].[dbo].[dim_target_fpd15] WHERE chain_nm like N'Other_online')
END AS target_fpd15
,
--target_EL
--case when ra.chain_nm = N'Eleganzza' THEN 0.005
--when ra.chain_nm = N'Baon' THEN 0.045
--when ra.chain_nm = N'Золотое Руно' THEN 0.045
--when ra.chain_nm = N'Ennergiia' THEN 0.05
--when ra.chain_nm = N'OneTwoTrip' THEN 0.045
--when ra.chain_nm = N'Money Care' THEN 0.05
--when ra.chain_nm = N'Связной' THEN 0.045
--when ra.chain_nm = N'Центр бронирования' THEN 0.045
--when ra.chain_nm = N'Ситилинк' THEN 0.04
--END [target_EL]
NULL AS [target_EL]
--target_AR
,CASE WHEN ra.channel_type = 'Offline' THEN 0.55
ELSE 0.45 END [target_AR]
, case when ra.chain_nm in ('Ekipka', 'Frenchnails', 'it71', 'Snowbars') then 1 
when ra.chain_nm = 'Gloria Jeans offline' then 0
when ra.chain_nm = N'Детский мир Online' then 0
else sme_flg end sme_flg
, insurance_amt
, application_decline_reason
, ra.request_amt
, ra.cost_amt
, CASE WHEN ra.cost_amt > 0 THEN 1 ELSE 0 end as eligible_cost
, ra.score5
, ra.score6
, ra.score7
, ra.product_code_requsted
, ra.loan_term_requsted
, ra.factoring_flg
, ra.application_source_key
, ra.repeat_b2c_score
, ra.purchase_sum
, ra.pilot
, ra.costs_on_loan_amt costs_on_loan_amt
, ra.avg_principal_amt
, ra.retro_bonus_amt
, ra.[mob6_90_amt]
, ra.avg_principal_amt_without_settlement
, ra.[penalties_fixed_allocation_amt]
, ra.[conversion_b2b_in_chain_cnt]
, ra.[conversion_b2b_cnt]
, ra.[conversion_b2c_cnt]
, ra.[conversion_b2b_in_chain_amt] 
, ra.[conversion_b2b_amt] 
, ra.[conversion_b2c_amt] 
, ra.[conversion_b2c_no_VC_cnt]
, ra.[conversion_b2c_no_VC_amt]
, ra.[score1]
      ,ra.[score2]
      ,ra.[score3]
      ,ra.[score4]

, null a_fpd15_EL
, rms.[regress_param_el] el_regression_a
, null el_regression_b
, fs.[forecast_el] el_numerator
, rps.[denominator_amt] el_denominator 
, rps.[param_reg]

,case when ra.chain_nm in (N'Перевод на карту',N'RevoPay',N'Оплата услуг') 
or ra.store_nm like N'%Мокка — займ на карту%'
or ra.store_nm like N'%Мокка — Подарок другу%'
or ra.store_nm like N'%Мокка — оплата услуг%'
or ra.store_nm like N'%Карта Рево-Онлайн%'
or ra.store_nm like N'%Мокка — Виртуальная карта%' 
or ra.store_nm like N'%Мокка- займы на карту%' 
then 1 else 0 end mokka_b2c_product

,case 

when ra.chain_nm = N'Перевод на карту' then N'Перевод на карту' 
when ra.store_nm like N'%Мокка — займ на карту%' then N'Мокка — займ на карту'
when ra.store_nm like  N'%Мокка- займы на карту%' then N'Мокка — займ на карту'

when ra.chain_nm = N'RevoPay' then N'Мокка — Подарок другу'
when ra.store_nm like N'%Мокка — Подарок другу%' then N'Мокка — Подарок другу'

when ra.chain_nm = N'Оплата услуг' then N'Оплата услуг' 
when ra.store_nm  = N'Мокка — оплата услуг (Mobile)' then N'Мокка — оплата услуг (Mobile)'
when ra.store_nm  = N'Мокка — оплата услуг (Home)' then N'Мокка — оплата услуг (Home)'

when ra.store_nm like N'%Карта Рево-Онлайн%' then N'Карта Рево-Онлайн'
when ra.store_nm like N'%Мокка — Виртуальная карта%'  then N'Мокка — Виртуальная карта'

else 
 CASE WHEN ra.chain_nm = N'Сеть отсутствует в ChainLookup' THEN trader_nm
 else ra.chain_nm end end mokka_b2c_product_group

, CASE WHEN gt_clients.client_key IS NOT NULL
	   THEN 1
	   ELSE 0
  END as garnet_flg
 ,null garnet_decision

--,fi.[garnet_flg]
  --,fi.[garnet_decision]
  ,ra.decline_rule --
  ,ra.request_juicy_amt
  ,d.loan_decision_code
,d.loan_decision_name
,d.loan_decision_type

,

case 

when ra.chain_nm = N'Перевод на карту' then 0.126
when ra.store_nm like N'%Мокка — займ на карту%' then 0.126
when ra.store_nm like  N'%Мокка- займы на карту%' then 0.126

when ra.chain_nm = N'RevoPay' then 0.158
when ra.store_nm like N'%Мокка — Подарок другу%' then 0.158

when ra.chain_nm = N'Оплата услуг' then 0.118
when ra.store_nm like N'%Мокка — оплата услуг%'  then 0.118




when ra.store_nm like N'%Карта Рево-Онлайн%' then 0.11
when ra.store_nm like N'%Мокка — Виртуальная карта%'  then 0.11

end mokka_b2c_target_2021





from Revo_DW.risk_DM.risk_application ra (NOLOCK)
			OUTER APPLY [dbo].[fn_regress_param_select](ra.[loan_key], ra.[fpd15_numerator_ps_amt], ra.[fpd15_denominator_amt], ra.[eligible_to_FPD15_flg]) AS rps -- определяем флаг регрессии
			OUTER APPLY [dbo].[fn_regress_master_select](ra.[application_dt], ra.[chain_nm], ra.[sme_flg], ra.[channel_type], rps.[param_reg]) AS rms -- определяем уровень просрочки для форкаста
			OUTER APPLY [dbo].[fn_forecast_el_select](rms.[regress_param_el], rps.[param_reg], ra.[fpd15_numerator_ps_amt], rps.[30_numerator_amt], rps.[60_numerator_amt], rps.[90_numerator_amt]) AS fs -- рассчитываем форкаст
LEFT JOIN dbo.xx_case60 case60 (NOLOCK) ON ra.loan_application_key = case60.loan_application_key
--left join [Revo_DW].[dbo].[fico_application] fi on fi.[Loan_Application_Key] = ra.loan_application_key 
left join [dbo].[loan_requests] lr on ra.loan_application_key=lr.loan_application_key
left join [dbo].[loan_request_loan_decision] ld on lr.id=ld.loan_requests_id
left join [dbo].[dim_loan_decision] d on d.loan_decision_id=ld.loan_decision_id
left join (
	SELECT la.client_key, la.loan_application_key, la.application_dt
	FROM cdm.loan_application AS la (NOLOCK)
	JOIN dbo.fico_application AS fa (NOLOCK) ON fa.Loan_Application_Key = la.loan_application_key
	WHERE ISNULL(fa.garnet_flg,0) = 1 	
	AND la.application_dt >='2021-11-01'
	) gt_clients on gt_clients.client_key = ra.client_key and gt_clients.application_dt <= ra.application_dt
left join [Revo_DW].[dbo].[dim_target_fpd15] AS t_fpd15 ON t_fpd15.chain_nm = ra.chain_nm


GO


