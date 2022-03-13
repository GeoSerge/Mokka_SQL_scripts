with cat_cnt as (
select internal_customer_id, count(distinct category) categories
from exponea.iframe
where timestamp >= '2021-12-01'
group by internal_customer_id
having count(distinct category) > 2
)
select internal_customer_id, timestamp, category, action, browser, os, device
from exponea.iframe
where internal_customer_id in (select internal_customer_id from cat_cnt)
order by internal_customer_id, timestamp
