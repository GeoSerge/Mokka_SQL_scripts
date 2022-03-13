 select top(1000)*
 from tableau.digitized_redox_new
 where status = 0
 --where created_at > '2021-12-01'

 status = 2?
 Время начала работы над анкетой?
 Как строится digitized_redoz_new? Что исправить?
 как считать очередь?
 результаты некорректны
 проверить все ли поля из экселя есть в источнике
 ---------------------------------------
 created - создана заявка
 processed - выполнено
 status 0 - approved
 status 2 - declined учитывать
 status 1 - done
 login processed_by - лежит в users

 поле start_time

digit..._decision
humans
предзаполненные поля - нужны ли?
клиент заполняет толко ФИО, номер паспорта
----------------------------------------

-- DATBI-21; sheet1
select cast(created_at as date) date
	  , count(distinct id) created_applications
	  , count(distinct case when status = 1 then id end) closed_applications
	  , count(distinct case when status = 1 and datediff(minute, created_at, processed_at) <= 1440 then id end) SL_24h
	  , count(distinct case when status = 1 and datediff(minute, created_at, processed_at) <= 2880 then id end) SL_48h
	  , avg((case when status = 1 then datediff(minute, dd.created_at, dd.processed_at)/1440 end)*1.0) SL_avg
from (select * from openquery ([APPMODULE-DWH], 'select * from digitized_documents')) dd
group by cast(created_at as date)
order by cast(created_at as date)

-- DATBI-21; sheet3 v1
with redox15 as (
select cast(dd.created_at as date) date
	  , count(distinct dd.id) created_applications
	  , count(distinct case when status = 1 then dd.id end) closed_applications
	  , avg((case when status = 1 then datediff(minute, dd.created_at, dd.processed_at)/1440 end)*1.0) SL_avg
from (select * from openquery ([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users where login like "%redox%"')) u on u.id = dd.processed_by
where u.id is not null
group by cast(dd.created_at as date)
	)
select cast(dd.created_at as date) date
	  , u.[login]
	  , count(distinct dd.id) created_applications
	  , avg(r.created_applications) redox15_created_applications
	  , count(distinct case when status = 1 then dd.id end) closed_applications
	  , avg(r.closed_applications) redox15_closed_applications
	  , avg((case when status = 1 then datediff(minute, dd.created_at, dd.processed_at)/1440 end)*1.0) SL_avg
	  , avg(r.SL_avg) redox15_SL_avg
from (select * from openquery ([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users where login like "%redox%"')) u on u.id = dd.processed_by
left join redox15 r on r.[date] = cast(dd.created_at as date)
where u.id is not null
group by cast(dd.created_at as date), u.[login]
order by cast(dd.created_at as date), u.[login]

-- DATBI-21; sheet3 v2; based on creation date
select cast(DATEADD(hour, 3, dd.created_at) as date) date
	  , u.[login]
	  , count(distinct dd.id) created_applications
	  , count(distinct case when status = 1 then dd.id end) closed_applications
	  , avg((case when status = 1 then datediff(minute, DATEADD(hour, 3, dd.created_at), DATEADD(hour, 3, dd.processed_at))/1440 end)*1.0) SL_avg
from (select * from openquery ([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users where login like "%redox%"')) u on u.id = dd.processed_by
where u.id is not null and cast(DATEADD(hour, 3, dd.created_at) as date) = '2022-01-25'
group by cast(DATEADD(hour, 3, dd.created_at) as date), u.[login]
order by cast(DATEADD(hour, 3, dd.created_at) as date), u.[login]

-- DATBI-21; sheet3 v2; based on processed date
select cast(DATEADD(hour, 3, dd.processed_at) as date) date
	  , u.[login]
	  , count(distinct dd.id) processed_applications
	  , count(distinct dd.client_id) clients
	  , count(*)
	  , count(distinct case when status = 1 then dd.id end) closed_applications
	  --, avg((case when status = 1 then datediff(minute, DATEADD(hour, 3, dd.created_at), DATEADD(hour, 3, dd.processed_at))/1440 end)*1.0) SL_avg
from (select * from openquery ([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users where login like "%redox%"')) u on u.id = dd.processed_by
where u.id is not null and DATEADD(hour, 3, dd.processed_at) between '2022-01-24 23:59:59' and '2022-01-26 00:00:01'
group by cast(DATEADD(hour, 3, dd.processed_at) as date), u.[login]
order by cast(DATEADD(hour, 3, dd.processed_at) as date), u.[login]

-- DATBI-21; sheet3 v2; based on processed date; explore
select dd.created_at
	  , dd.processed_at
	  , u.[login]
	  , dd.*
from (select * from openquery ([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users where login like "%redox%"')) u on u.id = dd.processed_by
where u.login = 'o-redox05'and DATEADD(hour, 3, dd.processed_at) between '2022-01-24 23:59:59' and '2022-01-26 00:00:01'
order by u.[login], dd.processed_at

-- DATBI-21; sheet2
select created_at
	 , start_time
	 , processed_at --max(processed_at, updated_at)
	 , DATEDIFF(second, start_at, processed_at)/60.0 as ANT
	 , u.login
	 , NULL as photo_type
	 , another_person_passport
	 , ddpi.surname --предзаполненные поля
	 , ddpi.first_name --предзаполненные поля
	 , ddpi.patronymic --предзаполненные поля
	 , ddpi.birth_date --предзаполненные поля
	 , ddpi.passport_series --предзаполненные поля
	 , ddpi.passport_number --предзаполненные поля
	 , ddpi.gender --предзаполненные поля
	 , ddpi.birth_place --предзаполненные поля
	 , ddpi.passport_issued_by --предзаполненные поля
	 , ddpi.passport_issue_date --предзаполненные поля
	 , ddpi.passport_code --предзаполненные поля
	 , ddr.address_result
	 , ddr.address_raw
	 --, исправленные поля
	 , first_name_not_match
	 , surname_not_match
	 , patronymic_not_match
	 , birth_date_not_match
	 , passport_series_not_match
	 , passport_number_not_match
	 , birth_place_not_readable
	 , passport_issued_by_not_readable
	 , passport_issue_date_not_readable
	 , passport_code_not_readable
	 , region_not_readable
	 , area_not_readable
	 , place_not_readable
	 , street_not_readable
	 , house_not_readable
	 , block_not_readable
	 , apartment_not_readable
	 , area_index_not_readable
	 , branch_name_not_readable
	 , issue_date_not_readable
	 , registration_series_number_eql
	 , client_with_id_document_series_number_eql
	 , first_page_document_status
	 , registration_document_status
	 , client_confirmation_document_status
	 , vdd.photo_status1
	 , vdd.photo_status2
from (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents') dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users')) u on u.id = dd.processed_by
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_personal_infos') ddpi on ddpi.digitized_document_id = dd.id
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_registrations') ddr on ddr.digitized_document_id = dd.id
left join (select * from openquery([APPMODULE-DWH], 'select * from v_v_digitalization_decisions') vdd on vdd.client_id = dd.client_id
left join v_address

select top(1000)*
from openquery([APPMODULE-DWH], 'select * from digitized_documents_personal_infos')
where created_at > '2021-12-01' and digitized_document_id = 274842


v_digitalization_clients
v_digitalization_decisions
v_digitalization_tasks


select top(1000)*
from (select top(1000)* from openquery([APPMODULE-DWH], 'select * from digitized_documents')) dd

select top(1000)*
from openquery([APPMODULE-DWH], 'select * from digitized_documents')
where id = 274842

select dd.created_at
	 , dd.start_time
	 , dd.processed_at
	 , dd.updated_at
	 , u.login
	 , ddpi.passport_series
	 , ddpi.passport_number
from (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_personal_infos')) ddpi on ddpi.digitized_document_id = dd.id
left join (select * from openquery([APPMODULE-DWH], 'select * from users')) u on u.id = dd.processed_by
where u.login like '%redox%' and dd.processed_at between '2022-02-03 02:59:59' and '2022-02-04 03:00:01' and ddpi.passport_number = 121257
order by u.login, start_time


select *
from (SELECT * FROM OPENQUERY ([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_personal_infos')) ddpi on ddpi.id = dd.id

SELECT top(1000)*  FROM OPENQUERY ([APPMODULE-DWH], 'select * from users where login like "%redox%"') 

select * from openquery ([APPMODULE-DWH], 'select * from passport')

SELECT top(1000)*  FROM OPENQUERY ([APPMODULE-DWH], 'select * from id_documents')

SELECT *  FROM OPENQUERY ([APPMODULE-DWH], 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE="BASE TABLE"')

SELECT *  FROM OPENQUERY ([APPMODULE-DWH], 'SELECT * FROM INFORMATION_SCHEMA.VIEWS')



 select top(1000)*
 from dbo.Task
 where TimeProcessing > '2021-12-01'

EXEC ('select * FROM users') AT [APPMODULE-DWH]
EXEC ('select * FROM v_users') AT [APPMODULE-DWH]
EXEC ('select * FROM v_digitalization_tasks where processed_by=12201 ') AT [APPMODULE-DWH] status = 1

--- кол-во выполненных задач за день
EXEC ('select COUNT(*), cast(updated_at as date) FROM digitized_documents WHERE status = 1 && updated_at>="2022-01-01"  && deleted_at is null
group by cast(updated_at as date)' ) AT [APPMODULE-DWH]

SELECT *  FROM OPENQUERY ([APPMODULE-DWH],'select * from digitized_documents_personal_infos WHERE status = 1 && updated_at>="2021-12-01"')
SELECT *  FROM OPENQUERY ([APPMODULE-DWH],'select COUNT(*), cast(updated_at as date) from digitized_documents_personal_infos WHERE status = 1 && updated_at>="2022-01-01" group by cast(updated_at as date)')

SELECT *  FROM OPENQUERY ([APPMODULE-DWH],'select *  from digitized_documents where status = 0 && deleted_at is null')
status = 0 - очередь

DigitizationReportNew
digitized_documents_personal_infos.status = 1 - обработано;
updated_at - время оцифровки. Поправка на 3 часа

select * from (
SELECT * FROM OPENQUERY ([APPMODULE-DWH], 'select * from v_digitalization_tasks where created_at' )
	) mdb
where mdb.processed_at > '2021-12-01'

select top(1000)*
from dbo.v_digitization_error

select top(1000)*
from dbo.DigitTask

Lobanov



SELECT * FROM OPENQUERY ([SUGARCRM-DWH], 'select * from sugarcrm_revoup.v_task_completeness_digitizing')

