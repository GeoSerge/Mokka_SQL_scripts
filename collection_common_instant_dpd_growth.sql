with max_dpd as (
	select l.client_key
		 , lem.TransactionDate dpd4_dt
		 , max(lem.DpdCounterNoPenalties) max_dpd
	from dbo.LoanExposureManagement lem
	left join CDM.loan l on l.loan_key = lem.LoanKey
	where lem.TransactionDate between '2021-09-01' and '2021-09-30'-- and lem.LoanKey in (select distinct LoanKey from dbo.LoanExposureManagement where TransactionDate between '2021-09-10' and '2021-09-20' and DpdCounterNoPenalties > 0)
	--where lem.TransactionDate >= '2021-01-01'
	group by l.client_key, lem.TransactionDate
	),
	max_dpd_lag as (
	select md.*, ISNULL(LAG(max_dpd) OVER (PARTITION by client_key ORDER BY dpd4_dt), max_dpd) lag_dpd
	from max_dpd md
	)
select *
from max_dpd_lag where lag_dpd = 0 and max_dpd > 3