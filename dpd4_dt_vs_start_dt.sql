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
			--where lem.TransactionDate >= '2021-01-01'
			where lem.TransactionDate between '2021-11-22' and '2022-11-28'
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
		--where lem.TransactionDate >= '2021-01-01'
		where lem.TransactionDate between '2021-11-22' and '2022-11-28'
		group by l.client_key, lem.TransactionDate
		having max(lem.DpdCounterNoPenalties) = 0
		) max_dpd0
	on max_dpd4.client_key = max_dpd0.client_key and max_dpd4.dpd4_dt < max_dpd0.dpd4_dt
	--where max_dpd4.dpd4_dt between '2021-11-22' and '2022-11-28'
	group by max_dpd4.client_key, max_dpd4.dpd4_dt

----------------------------------------------
select l.client_key
		, lem.TransactionDate dpd4_dt
		, max(lem.DpdCounterNoPenalties) max_dpd
from dbo.LoanExposureManagement lem
left join CDM.loan l on l.loan_key = lem.LoanKey
--where lem.TransactionDate >= '2021-01-01'
where lem.TransactionDate between '2021-11-22' and '2022-11-28'
group by l.client_key, lem.TransactionDate
having max(lem.DpdCounterNoPenalties) = 4

----------------------------------------------
SELECT l.client_key, l.register_key, l.stage_key, l.send_dt
FROM [collection].loan AS l
where l.send_dt between '2021-11-22' and '2022-11-28'

---------------------------
select l.client_key
	, l.register_key
	, l.stage_key
	, l.send_dt
	, r.start_dt
	, 1 as register_start_clients_cnt
	, ddbc.dpd4_dt
FROM (SELECT r.register_key, MIN(r.start_dt) start_dt, MIN(r.stage_key) AS stage_key  FROM collection.register r GROUP BY r.register_key) AS r_min
JOIN [collection].register AS r ON r_min.register_key = r.register_key AND r_min.stage_key = r.stage_key
JOIN (
	SELECT l.client_key, l.register_key, l.stage_key, l.send_dt, SUM(sli.register_start_overdue_amt) AS start_overdue_amt,
	max(CASE WHEN trader_nm IN (N'Перевод на карту', N'Карта Рево-Онлайн', N'РевоПэй' , N'Оплата услуг', N'Мокка') 
	then 'b2c' else 'b2b' end) AS client_channel_type, risk_grade
	FROM [collection].loan AS l
	LEFT JOIN collection.status_loan_initial sli ON l.loan_key = sli.loan_key AND l.register_key = sli.register_key AND l.stage_key = sli.stage_key
	left join cdm.loan on cdm.loan.loan_key = l.loan_key
	where l.send_dt between '2021-11-01' and '2021-12-01'
	GROUP BY l.client_key, l.register_key, l.stage_key, l.send_dt, risk_grade
		) AS l ON r.register_key = l.register_key AND r.stage_key = l.stage_key
FULL OUTER JOIN (
		select l.client_key
				, lem.TransactionDate dpd4_dt
				, max(lem.DpdCounterNoPenalties) max_dpd
		from dbo.LoanExposureManagement lem
		left join CDM.loan l on l.loan_key = lem.LoanKey
		--where lem.TransactionDate >= '2021-01-01'
		where lem.TransactionDate between '2021-11-01' and '2021-12-01'
		group by l.client_key, lem.TransactionDate
		having max(lem.DpdCounterNoPenalties) = 4
) ddbc on ddbc.client_key = l.client_key and ddbc.dpd4_dt = l.send_dt