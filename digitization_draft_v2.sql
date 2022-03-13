-- DATBI-21; sheet2
select dd.created_at
	 , dd.start_time
	 , dd.processed_at
	 , dd.updated_at
	 , DATEDIFF(second, dd.start_time, dd.processed_at)/60.0 as ANT
	 , u.login
	 , vdd.photo_quality1
	 , dd.another_person_passport
	 ---------------------------------предзаполненные поля
	 , ddpi.surname
	 , ddpi.first_name
	 , ddpi.patronymic
	 , ddpi.birth_date
	 , ddpi.passport_series
	 , ddpi.passport_number
	 , ddpi.gender
	 , ddpi.birth_place
	 , ddpi.passport_issued_by
	 , ddpi.passport_issue_date
	 , ddpi.passport_code
	 , ddr.address_raw
	 , va.country
	 , va.post_code
	 , va.region
	 , va.area
	 , va.settlement
	 , va.street
	 , va.house
	 , coalesce(va.building, va.[block]) as building
	 , va.flat
	 , va.owner_type
	 , NULL as registered_by
	 , ddr.issue_date as registration_date
	 --------------------------------------------------- исправленные поля
	 , dd.first_name_not_match
	 , dd.surname_not_match
	 , dd.patronymic_not_match
	 , dd.birth_date_not_match
	 , dd.passport_series_not_match
	 , dd.passport_number_not_match
	 , dd.birth_place_not_readable
	 , dd.passport_issued_by_not_readable
	 , dd.passport_issue_date_not_readable
	 , dd.passport_code_not_readable
	 , dd.region_not_readable
	 , dd.area_not_readable
	 , dd.place_not_readable
	 , dd.street_not_readable
	 , dd.house_not_readable
	 , dd.block_not_readable
	 , dd.apartment_not_readable
	 , dd.area_index_not_readable
	 , dd.branch_name_not_readable
	 , dd.issue_date_not_readable
	 , vdd.photo_quality1
	 , vdd.photo_quality2
	 , vdd.photo_quality3
	 , vdd.series_eql_passport_man
	 , vdd.man_without_registration
	 , vdd.passport_man
	 , vdd.passport_differs_man
	 , NULL as save_status
from (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents')) dd --dbo.digitalization_decisions + dbo.digitization_task !start_time
left join (select * from openquery([APPMODULE-DWH], 'select * from users')) u on u.id = dd.processed_by
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_personal_infos')) ddpi on ddpi.digitized_document_id = dd.id --dbo.v_digitalization_clients
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_registrations')) ddr on ddr.digitized_document_id = dd.id
left join (select * from openquery([APPMODULE-DWH], 'select * from v_digitalization_decisions')) vdd on vdd.task_id = dd.id --dbo.digitalization_decisions !start_time
left join (select * from openquery([APPMODULE-DWH], 'select * from v_addresses')) va on va.id = dd.id --dbo.Address

-- DATBI-21; sheet2
select dt.created_at
	 , NULL as start_time -- dd.start_time
	 , dt.processed_at
	 , dt.updated_at
	 , NULL as ANT --DATEDIFF(second, dt.start_time, dt.processed_at)/60.0 as ANT
	 , u.login
	 , dd.photo_quality1
	 , dd.another_person_passport
	 ---------------------------------предзаполненные поля
	 , vdc.surname
	 , vdc.first_name
	 , vdc.patronymic
	 , vdc.birth_date
	 , vdc.passport_series
	 , vdc.passport_number
	 , vdc.gender
	 , vdc.birth_place
	 , vdc.passport_issued_by
	 , vdc.passport_issue_date
	 , vdc.passport_code
	 , ddr.address_raw
	 , va.country
	 , va.Postcode
	 , NULL as region
	 , va.area
	 , va.settlement
	 , va.street
	 , va.house
	 , coalesce(va.[Building], va.[block]) as building
	 , va.flat
	 , NULL as owner_type --va.owner_type
	 , NULL as registered_by
	 , ddr.issue_date as registration_date
	 --------------------------------------------------- исправленные поля
	 , dd.first_name_not_match
	 , dd.surname_not_match
	 , dd.patronymic_not_match
	 , dd.birth_date_not_match
	 , dd.passport_series_not_match
	 , dd.passport_number_not_match
	 , dd.birth_place_not_readable
	 , dd.passport_issued_by_not_readable
	 , dd.passport_issue_date_not_readable
	 , dd.passport_code_not_readable
	 , dd.region_not_readable
	 , dd.area_not_readable
	 , dd.place_not_readable
	 , dd.street_not_readable
	 , dd.house_not_readable
	 , dd.block_not_readable
	 , dd.apartment_not_readable
	 , dd.area_index_not_readable
	 , dd.branch_name_not_readable
	 , dd.issue_date_not_readable
	 , dd.photo_quality1
	 , dd.photo_quality2
	 , dd.photo_quality3
	 , dd.series_eql_passport_man
	 , dd.man_without_registration
	 , dd.passport_man
	 , dd.passport_differs_man
	 , NULL as save_status
from dbo.digitalization_decisions dd --dd
left join dbo.digitization_task dt on dt.task_id = dd.task_id --dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users')) u on u.id = dt.processed_by
left join dbo.v_digitalization_clients vdc on vdc.task_id = dd.task_id --ddpi
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_registrations')) ddr on ddr.digitized_document_id = dd.task_id
left join dbo.Address va on va.AddressId = cast(dd.task_id as nvarchar(64)) --va

--start_time прокинуть в digitization_task
--dbo.Address.AddressId convert в bigint
--Address.owner_type
--Address.registered_by
--Address.region
--некорректные значения

-- DWH
select  u.[login], count(*)
from dbo.digitization_task dt
left join (select * from openquery([APPMODULE-DWH], 'select * from users where login like "%redox%"')) u on u.id = dt.processed_by
where DATEADD(hour, 3, dt.processed_at) between '2022-01-24 23:59:59' and '2022-01-26 00:00:01'
group by u.[login]

-- Модуль Выдачи
select  u.[login], count(*), count(distinct dd.id)
from (select * from openquery ([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users where login like "%redox%"')) u on u.id = dd.processed_by
where DATEADD(hour, 3, dd.processed_at) between '2022-01-24 23:59:59' and '2022-01-26 00:00:01'
group by u.[login]
