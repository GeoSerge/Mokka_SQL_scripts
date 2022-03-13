select partner_type
	, len(partner_type)
	, RIGHT(partner_type, iif(len(partner_type)-4 < 0, 0, len(partner_type)-4))
	, RIGHT(partner_type, iif(len(partner_type)-6 < 0, 0, len(partner_type)-6))
	, charindex(';', RIGHT(partner_type, iif(len(partner_type)-6 < 0, 0, len(partner_type)-6)))
	, case when charindex(';', RIGHT(partner_type, iif(len(partner_type)-6 < 0, 0, len(partner_type)-6))) = 0
		   then ''
		   else substring(RIGHT(partner_type, iif(len(partner_type)-6 < 0, 0, len(partner_type)-6)), charindex(';', RIGHT(partner_type, iif(len(partner_type)-6 < 0, 0, len(partner_type)-6)))+1,1)
	  end
	, replace(RIGHT(partner_type, iif(len(partner_type)-4 < 0, 0, len(partner_type)-4)), ';', '')
from Revo_DW.dbo.partner_loan

select case when
				(
				case when charindex(';', RIGHT(partner_type, iif(len(partner_type)-6 < 0, 0, len(partner_type)-6))) = 0
					 then ''
					 else substring(RIGHT(partner_type, iif(len(partner_type)-6 < 0, 0, len(partner_type)-6)), charindex(';', RIGHT(partner_type, iif(len(partner_type)-6 < 0, 0, len(partner_type)-6)))+1,1)
				end
				) = ''
			then replace(';', RIGHT(partner_type, iif(len(partner_type)-4 < 0, 0, len(partner_type)-4)))
			else
from Revo_DW.dbo.partner_loan

select right(partner_type, len(partner_type)-6), count(*) cnt
from dbo.partner_loan
where status = 'BUYBACK' and len(partner_type) > 6
group by right(partner_type, len(partner_type)-6)
order by cnt desc

select top(100)pl.period, pl.created_dttm, l.start_dt
from dbo.partner_loan pl
left join CDM.loan l on l.loan_key = pl.loan_key

select top(1000)*
from dbo.partner_loan