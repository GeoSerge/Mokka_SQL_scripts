--USE [Revo_DW]
--GO

--/****** Object:  View [tableau].[V_COLLECTION_DPD4]    Script Date: 18.01.2022 16:10:04 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--ALTER view [tableau].[V_COLLECTION_DPD4] as
-----------------------------------------------------------------------------------
with max_dpd as (
	select l.client_key
		 , lem.TransactionDate dpd4_dt
		 , max(lem.DpdCounterNoPenalties) max_dpd
	from dbo.LoanExposureManagement lem
	left join CDM.loan l on l.loan_key = lem.LoanKey
	--where lem.TransactionDate between '2021-09-01' and '2021-09-30'-- and lem.LoanKey in (select distinct LoanKey from dbo.LoanExposureManagement where TransactionDate between '2021-09-10' and '2021-09-20' and DpdCounterNoPenalties > 0)
	--where lem.TransactionDate >= '2021-01-01' and l.client_key = 570349
	where lem.TransactionDate >= '2021-01-01' and l.client_key = 160914
	group by l.client_key, lem.TransactionDate
	),
	max_dpd_lag as (
	select md.*, ISNULL(LAG(max_dpd) OVER (PARTITION by client_key ORDER BY dpd4_dt), max_dpd) lag_dpd
	from max_dpd md
	),
--	select *
--	from max_dpd_lag
--	order by client_key, dpd4_dt
--------------------------------------------
	first_dpd as (
	select *
	from max_dpd_lag
	where (lag_dpd = 0 and max_dpd > 4) OR max_dpd = 4
	)
select fd.dpd4_dt
	 , l.client_key
	 --, l.loan_key
	 --, lem.TransactionDate
	 --, lem.DpdCounter
	 --, lem.DpdCounterNoPenalties
	 --, cl.register_key
	 --, cl.stage_key
	 , cl.risk_grade
	 , ca.agency_nm
	 , r.Register_Score_Level
	 , sli.register_start_overdue_amt
	 --, lem.*
	 , (case when DATEDIFF(DAY, fd.dpd4_dt, lem.TransactionDate) between 0 and 7 and DpdCounterNoPenalties = 0 then l.client_key end) as week1
	 , (case when DATEDIFF(DAY, fd.dpd4_dt, lem.TransactionDate) between 0 and 28 and DpdCounterNoPenalties = 0 then l.client_key end) as week4
	 , (case when DATEDIFF(DAY, fd.dpd4_dt, lem.TransactionDate) between 0 and 56 and DpdCounterNoPenalties = 0 then l.client_key end) as week8
from dbo.LoanExposureManagement lem
left join CDM.loan l on l.loan_key = lem.LoanKey
left join collection.loan cl on cl.loan_key = lem.LoanKey
left join collection.register r on r.register_key = cl.register_key and r.stage_key = cl.stage_key
left join collection.collection_agency ca on ca.agency_id = r.collection_agency_id
left join first_dpd fd on fd.client_key = l.client_key
left join collection.status_loan_initial sli ON cl.loan_key = sli.loan_key AND cl.register_key = sli.register_key AND cl.stage_key = sli.stage_key
--where lem.TransactionDate >= '2021-01-01' and l.client_key = 570349
where lem.TransactionDate >= '2021-01-01' and l.client_key = 160914
--where lem.TransactionDate between '2021-09-01' and '2021-09-30'
--where lem.TransactionDate >= '2021-01-01'-- and cl.loan_key = 182028--and l.client_key = 79135
--order by lem.TransactionDate
--GO

