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
from (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users')) u on u.id = dd.processed_by
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_personal_infos')) ddpi on ddpi.digitized_document_id = dd.id
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_registrations')) ddr on ddr.digitized_document_id = dd.id
left join (select * from openquery([APPMODULE-DWH], 'select * from v_digitalization_decisions')) vdd on vdd.task_id = dd.id
left join (select * from openquery([APPMODULE-DWH], 'select * from v_addresses')) va on va.id = dd.id

-- DATBI-21; sheet2 part 1
select dd.created_at
	 , dd.start_time
	 , dd.processed_at
	 , dd.updated_at
	 , DATEDIFF(second, dd.start_time, dd.processed_at)/60.0 as ANT
	 , u.login
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
	 , NULL as save_status
from (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents')) dd
left join (select * from openquery([APPMODULE-DWH], 'select * from users')) u on u.id = dd.processed_by
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_personal_infos')) ddpi on ddpi.digitized_document_id = dd.id
left join (select * from openquery([APPMODULE-DWH], 'select * from v_addresses')) va on va.id = dd.id

union all

-- DATBI-21; sheet2 part 2
select vdd.task_id
	 , vdd.photo_quality1
	 ---------------------------------предзаполненные поля
	 , ddr.address_raw
	 , ddr.issue_date as registration_date
	 --------------------------------------------------- исправленные поля
	 , vdd.photo_quality1
	 , vdd.photo_quality2
	 , vdd.photo_quality3
	 , vdd.series_eql_passport_man
	 , vdd.man_without_registration
	 , vdd.passport_man
	 , vdd.passport_differs_man
from (select * from openquery([APPMODULE-DWH], 'select * from v_digitalization_decisions')) vdd
left join (select * from openquery([APPMODULE-DWH], 'select * from digitized_documents_registrations')) ddr on ddr.digitized_document_id = vdd.task_id

select loan_key, start_dt, NULL as plan_end_dt
from CDM.loan
where loan_key = 10

union all

select loan_key, NULL as start_dt, plan_end_dt
from CDM.loan
where loan_key = 10
