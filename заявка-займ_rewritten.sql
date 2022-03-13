create view tableau.V_RISK_LOAN_APPLICATION as
select
--v_store
  vs.store_key
, vs.chain_nm
, vs.store_nm
, vs.store_num
, vs.store_nm_by_trader
, vs.full_store_address
, vs.federal_district_nm
, vs.group_nm
, vs.group_desc
, vs.online_flg
, vs.legal_entity_nm
, vs.SSDM_nm
, vs.store_email
, vs.phone_num
, vs.trader_key
, vs.trader_nm
, vs.chain_key
, vs.eligible_to_telemarketing_flg
, vs.not_eligible_to_telemarketing_flg
-- v_loan
, vl.loan_key
, vl.start_dt
, vl.loan_term
--, vl.loan_application_key as l_loan_application_key
, vl.plan_end_dt
, vl.loan_rate
, vl.penalty_amt
, vl.cession_flg
, vl.cession_dt
, vl.repeated_flg
, vl.sms_info_flg
, vl.sms_info_amt
, vl.PSK_rate
, vl.billing_plan_type
, vl.principal_amt
, vl.psk_excess_flg
, vl.loan_status
, vl.loan_60k_flg
, vl.trader_commission_amt
, vl.return_date
, vl.return_trader_comission_amt
, vl.additional_service_comission_amt
-- v_loan_application
, vla.loan_application_key --as la_loan_application_key
--, vla.store_key as la_store_key
, vla.presale_flg
, vla.first_application_flg
, vla.application_month_end_dt
, vla.eligible_to_conversion_in_day_flg
, vla.conversion_in_day_flg
, vla.eligible_to_conversion_in_month_flg
, vla.conversion_in_month_flg
, vla.eligible_to_utilization_in_day_flg
, vla.eligible_to_utilization_in_month_flg
, vla.preapplication_in_day_flg
, vla.preapplication_in_month_flg
, vla.virtual_card_flg
--, vla.channel_type
, vla.repeat_online_flg
, vla.repeat_virtual_card_flg
, vla.virtual_card_closed_dttm
, vla.virtual_card_status_type
, vla.eligible_to_approval_rate_flg
, vla.utilization_in_day_denominator_amt
, vla.utilization_in_day_numerator_amt
, vla.utilization_in_month_denominator_amt
, vla.utilization_in_month_numerator_amt
, vla.agent_nm
, vla.conversion_virtual_card_in_month_flg
, vla.eligible_to_conversion_virtual_card_in_month_flg
, vla.card_loan_flg
, vla.limit_after_application_amt
, vla.loan_application_guid
, vla.ApplicationStatusType
, vla.application_repeat_type_new
, vla.collateral_flg
, vla.partner_id
, vla.MerchantDiscount
-- v_client
, vcl.client_key
, vcl.city
, vcl.client_region_nm
, vcl.store_nm client_store_nm
, vcl.gender_nm
, vcl.age
, vcl.trader_nm as client_trader_nm
, vcl.chain_nm client_chain_nm
, vcl.conversion_45_day_flg
, vcl.eligible_to_conversion_45_day_flg
, vcl.first_application_chain_nm
, vcl.digitization_status
, vcl.calc_zont_limit
, vcl.Digit_error_type
, vcl.current_limit_amt
-- v_cession
, cl.loankey AS ces_l_loankey
, cl.loanguid AS ces_l_loanguid
, cl.clientkey AS ces_l_clientkey
, cl.cession_dt AS ces_l_cession_dt
, cl.cessionary_nm AS ces_l_cessionary_nm
, cl.principal AS ces_l_principal
, cl.interest AS ces_l_interest
, cl.interestafterenddate AS ces_l_interestafterenddate
, cl.penalties AS ces_l_penalties
, cl.sms_due AS ces_l_sms_due
, cl.total AS ces_l_total
, cl.price AS ces_l_price
, cl.DpdCounterNoPenalties AS ces_l_DpdCounterNoPenalties
, cl.bucket_nm AS ces_l_bucket_nm
-- v_risk_application
, vra.eomonth_start_dt
, vra.somonth_start_dt
--, vra.store_key as risk_store_key
, vra.client_key risk_client_key
--, vra.loan_key
--, vra.loan_application_key as risk_loan_application_key
, vra.application_dt
, vra.application_amt
, vra.application_repeat_type
, vra.same_day_return_flg
, vra.return_dt
, vra.new_application_flg
, vra.first_loan_flg
, vra.fico_call_flg
, vra.strategy_version
, vra.risk_grade
, vra.limit_post_bureau
, vra.post_bureau_decline_reason
, vra.pre_bureau_decline_reason
, vra.final_decision
, vra.retailer_chain
, vra.fico_retailer_chain
, vra.bki_flg
--, vra.start_dt
--, vra.loan_term
--, vra.principal_amt
, vra.full_amt
, vra.chain_nm risk_chain_nm
, vra.trader_nm risk_trader_nm
, vra.branch_nm
, vra.region_nm
, vra.city_nm
, vra.federal_region_nm
, vra.challenger
, vra.first_decline_rule
, vra.POS_policy_group_desc
, vra.POS_policy_group
, vra.has_fico_inquires_flg
, vra.has_fico_loan_flg
, vra.conversion_flg
, vra.approved_flg
, vra.eligible_to_FPD2_flg
, vra.eligible_to_FPD5_flg
, vra.eligible_to_FPD11_flg
, vra.eligible_to_FPD15_flg
, vra.FPD2_flg
, vra.FPD5_flg
, vra.FPD11_flg
, vra.FPD15_flg
, vra.eligible_to_MOB3_flg
, vra.eligible_to_MOB2_flg
, vra.eligible_to_MOB6_flg
, vra.MOB3_billing_dpd30_flg
, vra.MOB6_billing_dpd90_flg
, vra.principal_current_amt
, vra.principal_overdue_amt
, vra.interest_current_amt
, vra.interest_overdue_amt
, vra.penalties_amt
, vra.has_mng_balance_flg
, vra.loan_order_num
, vra.score8
, vra.score9
, vra.score_value
, vra.source_nm
, vra.whitelist_flg
, vra.MOB3_billing_dt_interest_due_amt
, vra.MOB3_billing_dt_principal_due_amt
, vra.MOB6_billing_dt_interest_due_amt
, vra.MOB6_billing_dt_principal_due_amt
, vra.[MTS_score]
, vra.[Mail_score]
, vra.[score8_kari]
, vra.[score8_mail]
, vra.[score9_1]
, vra.[score9_version]
, vra.[score9_1_mail_mts]
, vra.[score9_1_mail_megafon]
, vra.[score9_1_mail_no_telecom]
, vra.[megafon_score]
, vra.first_trader_nm
, vra.first_chain_nm 
, vra.first_store_nm
, vra.agent_key
, vra.from_sait_flg
, vra.[30_numerator_amt]
, vra.[30_denominator_amt]
, vra.[60_numerator_amt] 
, vra.[60_denominator_amt]
, vra.fpd10_numerator_cnt
, vra.fpd10_denominator_cnt
, vra.fpd10_numerator_amt
, vra.fpd10_denominator_amt
, vra.eligible_to_FPD10_flg
, vra.decision_by
, vra.full_online_flg
, vra.first_decision_dt
, vra.channel_type
, vra.first_channel_type    
, vra.offline_approve
, vra.online_approve
, vra.virtual_card_approve
, vra.psprt_okato
, vra.psprt_year
, vra.last_step    
, vra.[20_numerator_amt]
, vra.[40_numerator_amt]
, vra.[20_denominator_amt]
, vra.[40_denominator_amt]
, vra.agent_flg
, vra.agent_chain_nm
, vra.application_decision_reason
, vra.fpd15_numerator_amt
, vra.fpd15_denominator_amt
, vra.fpd10_numerator_ps_amt
, vra.fpd15_numerator_ps_amt
, vra.suspected_fraud_flg
, vra.repeat_risk_grade
, vra.error_type
, vra.repeat_risk_grade_b2b
, vra.first_application_amt
, vra.conversion_new_numerator
, vra.conversion_new_denominator
, vra.black_list_reason
, vra.[30_numerator_principal_amt]
, vra.[60_numerator_principal_amt] 
, vra.[30_denominator_principal_amt] 
, vra.[60_denominator_principal_amt]
, vra.product_code 
, vra.[target_mob30]
, vra.[target_EL]
, vra.[target_AR]
, vra.sme_flg
, vra.insurance_amt
, vra.application_decline_reason
, vra.request_amt
, vra.cost_amt
, vra.eligible_cost
, vra.score5
, vra.score6
, vra.score7
, vra.factoring_flg
, vra.application_source_key
, vra.repeat_b2c_score
, vra.[purchase_sum]
, vra.[pilot]
, vra.costs_on_loan_amt
, vra.avg_principal_amt
, vra.retro_bonus_amt 
, vra.mob6_90_amt
, vra.avg_principal_amt_without_settlement 
, vra.[penalties_fixed_allocation_amt]
, vra.[conversion_b2b_in_chain_cnt]
, vra.[conversion_b2b_cnt]
, vra.[conversion_b2c_cnt]
, vra.[conversion_b2b_in_chain_amt] 
, vra.[conversion_b2b_amt] 
, vra.[conversion_b2c_amt]
, vra.[conversion_b2c_no_VC_cnt]
, vra.[conversion_b2c_no_VC_amt]
, vra.[score1]
, vra.[score2]
, vra.[score3]
, vra.[score4]
, vra.a_fpd15_EL
, vra.el_regression_a
, vra.el_regression_b
, vra.el_numerator
, vra.el_denominator 
, vra.mokka_b2c_product
, vra.mokka_b2c_product_group
, vra.[garnet_flg]
, vra.[garnet_decision]
, vra.decline_rule --
, vra.request_juicy_amt
, vra.loan_decision_code
, vra.loan_decision_name
, vra.loan_decision_type
, vra.mokka_b2c_target_2021
, vra.target_fpd15
, vra.[target_decission_cost]
from tableau.V_RISK_APPLICATION vra
left join tableau.cession_loans cl on vra.loan_key = cl.loankey
left join tableau.V_CLIENT vcl on vra.client_key = vcl.client_key
left join tableau.V_LOAN_APPLICATION vla on vla.loan_application_key = vra.loan_application_key
left join tableau.V_LOAN vl on vl.loan_application_key = vla.loan_application_key
left join tableau.V_STORE vs on vs.store_key = vra.store_key

----v_store
--select
--    store_key
--    , chain_nm
--    , store_nm
--    , store_num
--    , store_nm_by_trader
--    , full_store_address
--    , federal_district_nm
--    , group_nm
--    , group_desc
--    , online_flg
--    , legal_entity_nm
--    , SSDM_nm
--    , store_email
--    , phone_num
--    , trader_key
--    , trader_nm
--    , chain_key
--    , eligible_to_telemarketing_flg
--    , not_eligible_to_telemarketing_flg
    
--from tableau.V_STORE

---- v_loan
--select
--    loan_key
--    , start_dt
--    , loan_term
--    , loan_application_key
--    , plan_end_dt
--    , loan_rate
--    , penalty_amt
--    , cession_flg
--    , cession_dt
--    , repeated_flg
--    , sms_info_flg
--    , sms_info_amt
--    , PSK_rate
--    , billing_plan_type
--    , principal_amt
--    , psk_excess_flg
--    , loan_status
--    , loan_60k_flg
--    , trader_commission_amt
--    , return_date
--	, return_trader_comission_amt
--,additional_service_comission_amt
--from [tableau].[V_LOAN]

---- v_loan_application
--select
--    loan_application_key
--    , store_key
--    , presale_flg
--    , first_application_flg
--    , application_month_end_dt
--    , eligible_to_conversion_in_day_flg
--    , conversion_in_day_flg
--    , eligible_to_conversion_in_month_flg
--    , conversion_in_month_flg
--    , eligible_to_utilization_in_day_flg
--    , eligible_to_utilization_in_month_flg
--    , preapplication_in_day_flg
--    , preapplication_in_month_flg
--    , virtual_card_flg
--    , channel_type
--    , repeat_online_flg
--    , repeat_virtual_card_flg
--    , virtual_card_closed_dttm
--    , virtual_card_status_type
--    , eligible_to_approval_rate_flg
--    , utilization_in_day_denominator_amt
--    , utilization_in_day_numerator_amt
--    , utilization_in_month_denominator_amt
--    , utilization_in_month_numerator_amt
--    , agent_nm
--    , conversion_virtual_card_in_month_flg
--    , eligible_to_conversion_virtual_card_in_month_flg
--    --, conversion_45_days_flg
--    --, eligible_to_conversion_in_45_days_flg
--    , card_loan_flg
--    , limit_after_application_amt
--    , loan_application_guid
--, ApplicationStatusType
--, application_repeat_type_new
--,collateral_flg
--,partner_id
--,MerchantDiscount
--from [tableau].[V_LOAN_APPLICATION]

---- v_client
--select 
--	client_key
--	, city
--	, client_region_nm
--	, store_nm
--	, gender_nm
--	, age
--        , trader_nm
--        , chain_nm
--        , conversion_45_day_flg
--        , eligible_to_conversion_45_day_flg
--        , first_application_chain_nm
--        , digitization_status
--        , calc_zont_limit
--        , Digit_error_type
--        ,current_limit_amt
--from tableau.V_CLIENT

---- v_cession
--SELECT loankey AS ces_l_loankey
-- ,loanguid AS ces_l_loanguid
-- ,clientkey AS ces_l_clientkey
-- ,cession_dt AS ces_l_cession_dt
-- ,cessionary_nm AS ces_l_cessionary_nm
-- ,principal AS ces_l_principal
-- ,interest AS ces_l_interest
-- ,interestafterenddate AS ces_l_interestafterenddate
-- ,penalties AS ces_l_penalties
-- ,sms_due AS ces_l_sms_due
-- ,total AS ces_l_total
-- ,price AS ces_l_price
-- ,DpdCounterNoPenalties AS ces_l_DpdCounterNoPenalties
-- ,bucket_nm AS ces_l_bucket_nm
--FROM tableau.cession_loans

---- v_risk_application
--select
--    eomonth_start_dt
--    , somonth_start_dt
--    , store_key
--    , client_key
--    , loan_key
--    , loan_application_key
--    , application_dt
--    , application_amt
--    , application_repeat_type
--    , same_day_return_flg
--    , return_dt
--    , new_application_flg
--    , first_loan_flg
--    , fico_call_flg
--    , strategy_version
--    , risk_grade
--    , limit_post_bureau
--    , post_bureau_decline_reason
--    , pre_bureau_decline_reason
--    , final_decision
--    , retailer_chain
--    , fico_retailer_chain
--    , bki_flg
--    , start_dt
--    , loan_term
--    , principal_amt
--    , full_amt
--    , chain_nm
--    , trader_nm
--    , branch_nm
--    , region_nm
--    , city_nm
--    , federal_region_nm
--    , challenger
--    , first_decline_rule
--    , POS_policy_group_desc
--    , POS_policy_group
--    , has_fico_inquires_flg
--    , has_fico_loan_flg
--    , conversion_flg
--    , approved_flg
--    , eligible_to_FPD2_flg
--    , eligible_to_FPD5_flg
--    , eligible_to_FPD11_flg
--    , eligible_to_FPD15_flg
--    , FPD2_flg
--    , FPD5_flg
--    , FPD11_flg
--    , FPD15_flg
--    , eligible_to_MOB3_flg
--    , eligible_to_MOB2_flg
--    , eligible_to_MOB6_flg
--    , MOB3_billing_dpd30_flg
--    , MOB6_billing_dpd90_flg
--    , principal_current_amt
--    , principal_overdue_amt
--    , interest_current_amt
--    , interest_overdue_amt
--    , penalties_amt
--    , has_mng_balance_flg
--    , loan_order_num
--    , score8
--    , score9
--    , score_value
--    , source_nm
--    , whitelist_flg
--    , MOB3_billing_dt_interest_due_amt
--    , MOB3_billing_dt_principal_due_amt
--    , MOB6_billing_dt_interest_due_amt
--    , MOB6_billing_dt_principal_due_amt
--    , [MTS_score]
--    , [Mail_score]
--    , [score8_kari]
--    , [score8_mail]
--    , [score9_1]
--    , [score9_version]
--    , [score9_1_mail_mts]
--    , [score9_1_mail_megafon]
--    , [score9_1_mail_no_telecom]
--    , [megafon_score]
--    , first_trader_nm
--    , first_chain_nm 
--    , first_store_nm
--    , agent_key
--    , from_sait_flg

--    , [30_numerator_amt]
--    , [30_denominator_amt]
--    , [60_numerator_amt] 
--    , [60_denominator_amt]
--    , fpd10_numerator_cnt
--    , fpd10_denominator_cnt
--    , fpd10_numerator_amt
--    , fpd10_denominator_amt
--    , eligible_to_FPD10_flg

--    , decision_by
--    , full_online_flg
--    , first_decision_dt
--    , channel_type
--    , first_channel_type
    
--    , offline_approve
--    , online_approve
--    , virtual_card_approve
--    , psprt_okato
--    , psprt_year
--    , last_step
    
--    , [20_numerator_amt]
--    , [40_numerator_amt]
--    , [20_denominator_amt]
--    , [40_denominator_amt]
--    , agent_flg
--    , agent_chain_nm
--    , application_decision_reason
--    , fpd15_numerator_amt
--    , fpd15_denominator_amt
--    , fpd10_numerator_ps_amt
--    , fpd15_numerator_ps_amt
--    , suspected_fraud_flg
--    , repeat_risk_grade
--    , error_type
--    , repeat_risk_grade_b2b
--    , first_application_amt
--    , conversion_new_numerator
--    , conversion_new_denominator
--    , black_list_reason
--    ,[30_numerator_principal_amt]
--    ,[60_numerator_principal_amt] 
--    ,[30_denominator_principal_amt] 
--    ,[60_denominator_principal_amt]
--    ,product_code 
--    ,[target_mob30]
--    ,[target_EL]
--    ,[target_AR]
--    ,sme_flg
--    ,insurance_amt
--    ,application_decline_reason
--    ,request_amt
--    ,cost_amt
--    , eligible_cost
--    , score5
--    , score6
--    , score7
--    , factoring_flg
--    , application_source_key
--    , repeat_b2c_score
--      ,[purchase_sum]
--      ,[pilot]
--,costs_on_loan_amt
--,avg_principal_amt
--,retro_bonus_amt 
--,mob6_90_amt
--,avg_principal_amt_without_settlement 
--, [penalties_fixed_allocation_amt]
--, [conversion_b2b_in_chain_cnt]
--, [conversion_b2b_cnt]
--, [conversion_b2c_cnt]
--, [conversion_b2b_in_chain_amt] 
--, [conversion_b2b_amt] 
--, [conversion_b2c_amt]

--,[conversion_b2c_no_VC_cnt]
--,[conversion_b2c_no_VC_amt]



--,[score1]
--      ,[score2]
--      ,[score3]
--      ,[score4]

--,a_fpd15_EL
--,el_regression_a
--,el_regression_b
--,el_numerator
--,el_denominator 
--,mokka_b2c_product
--,mokka_b2c_product_group

--,[garnet_flg]
--  ,[garnet_decision]
--  ,decline_rule --
--  ,request_juicy_amt
--  ,loan_decision_code
--,loan_decision_name
--,loan_decision_type
--,mokka_b2c_target_2021
--,target_fpd15
--,[target_decission_cost]

--from tableau.V_RISK_APPLICATION
