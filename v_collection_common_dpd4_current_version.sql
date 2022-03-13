--USE [Revo_DW]
--GO

--/****** Object:  View [tableau].[V_Collection_Common_Dpd4]    Script Date: 25.01.2022 16:23:42 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO










--ALTER view [tableau].[V_Collection_Common_Dpd4]
--as

--drop table if exists #cure_rate_new
select distinct 'Cure Rate vintages dpd4' as Name_Part
, r.register_key
, r.stage_key
, r.Register_Score_Level
, null as _null
, r.start_dt
, month(r.start_dt) month_start_dt
, year(r.start_dt ) year_start_dt
, agency_nm
--, r.avg_dpd_by_placement
, null as register_start_overdue_amt --, crz.register_start_cash_amt
, 1 register_start_clients_cnt
, coalesce(l.client_key, ddbc.client_key) as client_key
, ddbc.dpd4_dt
--, ddbc.repayment_dt
, case when datediff(day, ddbc.dpd4_dt, ddbc.repayment_dt) <= 7 then 1 else 0 end week1_clients
, case when datediff(day, ddbc.dpd4_dt, ddbc.repayment_dt) <= 28 then 1 else 0 end week4_clients
, case when datediff(day, ddbc.dpd4_dt, ddbc.repayment_dt) <= 56 then 1 else 0 end week8_clients
, null as week12_clients
, case when ddbc.repayment_dt is not null then 1 else 0 end client_status0
, null as week1_clients_cash
, null as week4_clients_cash
, null as week8_clients_cash
, null as week12_clients_cash
, null total_register_payment
, null as attempt_flg_sum  -----------------------
, null start_clients_cnt_operational
, null as Calls------------------------
, null as Ptp ---------------------
, null Ptp_kept
, null as Rpc
, null contact_cnt_cl
, null contact_weeks_from_startdt
, null contact_type
, null as start_clients_cnt_comission
, null as reward_amt
, null as reward_amt_surcharge
, null as Reward_with_surcharge
, null as payment_amt
 ,client_channel_type
 ,case when l.start_overdue_amt <= 5000 then '5k'
	   when l.start_overdue_amt <= 10000 then '10k'
	   when l.start_overdue_amt <= 15000 then '15k'
	   when l.start_overdue_amt <= 20000 then '20k'
	   when l.start_overdue_amt <= 30000 then '30k'
	   when l.start_overdue_amt <= 40000 then '40k'
	   when l.start_overdue_amt <= 50000 then '50k'
	   when l.start_overdue_amt <= 70000 then '70k'
	   when l.start_overdue_amt > 70000 then '70k+'
	   end  start_overdue_amt_type
, null last_paym_amount
, null as cost_related
, l.risk_grade collection_grade
, r.start_dt dt
--, ddbc.dpd4_dt
,null active_clients_cnt
,null first_agency_nm
--into #cure_rate_new
FROM (SELECT r.register_key, MIN(r.start_dt) start_dt, MIN(r.stage_key) AS stage_key  FROM collection.register r GROUP BY r.register_key) AS r_min
JOIN [collection].register AS r ON r_min.register_key = r.register_key AND r_min.stage_key = r.stage_key
JOIN [collection].collection_agency AS ca ON r.collection_agency_id = ca.agency_id
JOIN (
	SELECT l.client_key, l.register_key, l.stage_key, l.send_dt, SUM(sli.register_start_overdue_amt) AS start_overdue_amt,
	max(CASE WHEN trader_nm IN (N'Перевод на карту', N'Карта Рево-Онлайн', N'РевоПэй' , N'Оплата услуг', N'Мокка') 
	then 'b2c' else 'b2b' end) AS client_channel_type, risk_grade
	FROM [collection].loan AS l
	LEFT JOIN collection.status_loan_initial sli ON l.loan_key = sli.loan_key AND l.register_key = sli.register_key AND l.stage_key = sli.stage_key
	left join cdm.loan on cdm.loan.loan_key = l.loan_key
	where l.send_dt >= '2021-01-01'
	GROUP BY l.client_key, l.register_key, l.stage_key, l.send_dt, risk_grade
		) AS l ON r.register_key = l.register_key AND r.stage_key = l.stage_key
FULL OUTER JOIN (
	select max_dpd4.client_key, max_dpd4.dpd4_dt, min(max_dpd0.dpd4_dt) repayment_dt
	from (
		select *
		from (
			select max_dpd.*, ISNULL(LAG(max_dpd) OVER (PARTITION by client_key ORDER BY dpd4_dt), max_dpd) lag_dpd
			from (
				select l.client_key
						, lem.TransactionDate dpd4_dt
						, max(lem.DpdCounterNoPenalties) max_dpd
				from dbo.LoanExposureManagement lem
				left join CDM.loan l on l.loan_key = lem.LoanKey
				where lem.TransactionDate >= '2021-01-01'
				group by l.client_key, lem.TransactionDate
				--having max(lem.DpdCounterNoPenalties) = 4
				) max_dpd
		) max_dpd_lag
		where (max_dpd_lag.lag_dpd = 0 and max_dpd >=4) OR max_dpd = 4
	) max_dpd4
		left join
			(
			select l.client_key
					, lem.TransactionDate dpd4_dt
					, max(lem.DpdCounterNoPenalties) max_dpd
			from dbo.LoanExposureManagement lem
			left join CDM.loan l on l.loan_key = lem.LoanKey
			where lem.TransactionDate >= '2021-01-01'
			group by l.client_key, lem.TransactionDate
			having max(lem.DpdCounterNoPenalties) = 0
			) max_dpd0
		on max_dpd4.client_key = max_dpd0.client_key and max_dpd4.dpd4_dt < max_dpd0.dpd4_dt
		group by max_dpd4.client_key, max_dpd4.dpd4_dt
		) ddbc on ddbc.client_key = l.client_key and ddbc.dpd4_dt = l.send_dt
--GO


