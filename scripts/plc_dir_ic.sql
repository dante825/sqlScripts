
--drop table plc_dir_ic;
create table plc_dir_ic (
id serial primary key,
company_dbt_id uuid,
company_ext_id bigint,
company_name varchar(255),
person_dbt_id uuid,
person_ext_id bigint,
person_name varchar(255),
ic varchar(100),
request bool default false
);

alter table plc_dir_ic add column nationality varchar(10), add column gender varchar(10);

select * from plc_dir_ic;

select count(*) from plc_dir_ic;

select * from dibots_v2.company_person_role where role_type in ('DIR', 'DIR1', 'DIR2', 'INDIR', 'MANDIR', 'OUTDIR', 'VCHAIR', 'VMANDIR')

insert into plc_dir_ic (company_dbt_id, company_ext_id, company_name, person_dbt_id)
select a.dbt_entity_id, a.external_id, a.display_name, a.person_id
from
(select cp.dbt_entity_id, cp.external_id, cp.display_name, cpr.company_id, cpr.person_id
from dibots_v2.company_profile cp, dibots_v2.company_person_role cpr
where cp.dbt_entity_id = cpr.company_id and cp.country_of_incorporation = 'MYS' and cp.comp_status_desc = 'PUBLIC' and cp.active = true and cpr.eff_end_date is null
and cpr.role_type in ('DIR', 'DIR1', 'DIR2', 'INDIR', 'MANDIR', 'OUTDIR', 'VCHAIR', 'VMANDIR')) a
left join dibots_v2.entity_identifier ei
on a.person_id = ei.dbt_entity_id and ei.deleted = false and ei.identifier_type IN ('MK', 'PASSPORT')
where ei.id is null;


update plc_dir_ic a
set
person_ext_id = pp.external_id,
person_name = pp.display_name
from dibots_v2.person_profile pp
where a.person_dbt_id = pp.dbt_entity_id;


select * from plc_dir_ic a, dibots_v2.person_nationality b
where a.person_dbt_id = b.dbt_entity_id;

update plc_dir_ic a
set
nationality = b.nationality
from dibots_v2.person_nationality b
where a.person_dbt_id = b.dbt_entity_id;

select a.*, b.gender from plc_dir_ic a, dibots_v2.person_profile b
where a.person_dbt_id = b.dbt_entity_id;

update plc_dir_ic a
set
gender = b.gender
from dibots_v2.person_profile b
where a.person_dbt_id = b.dbt_entity_id;


select * from plc_dir_ic a, dibots_v2.entity_identifier ei
where a.person_dbt_id = ei.dbt_entity_id and ei.identifier_type in ('MK', 'PASSPORT') and ei.deleted = false


select * from dibots_v2.entity_identifier where dbt_entity_id = 'a32407f7-b5e4-4ac6-a3c0-f4ec1f9254db'

select * from dibots_v2.company_person_role where company_id = '6dc7ae84-4147-4a60-a534-1a66a7af7ec8' and person_id = '7b56938f-c2ff-4289-8564-e60243c74e38'

select ic, split_part(ic, '/', 1) from plc_dir_ic where ic like '%(P)%' and passport is null

update plc_dir_ic
set
passport = btrim(replace(split_part(ic, '/', 4), '(P)', ''))
where ic like '%/%'

update plc_dir_ic
set
passport = null
where btrim(passport) = '';

select * from plc_dir_ic a, dibots_v2.entity_identifier b
where a.passport = b.identifier and b.identifier_type = 'PASSPORT' and a.passport is not null and a.updated_passport = false --and a.passport not like '%/%'

insert into dibots_v2.entity_identifier (dbt_entity_id, identifier_type, identifier, data_type, eff_from_date, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by, original_eff_from_date) 
select a.person_dbt_id, 'PASSPORT', a.passport, 'string', '1900-01-01', 1, '1900-01-01 00:00:00.0', now(), 'LKE', '1900-01-01 00:00:00.0'
from plc_dir_ic a
where a.passport is not null and a.updated_passport = false
on conflict do nothing;

select c.stock_code, d.dbt_entity_id, d.external_id, d.display_name, d.comp_status_desc
from 
dibots_v2.company_profile d 
left join (select a.stock_code, b.stock_identifier from dibots_v2.exchange_daily_transaction a, dibots_v2.exchange_stock_profile b
where a.stock_code = b.stock_code and a.transaction_date = '2021-02-24' and b.stock_identifier is not null and b.eff_end_date is null and b.delisted_date is null and is_mother_code = true) c
on c.stock_identifier = d.dbt_entity_id
where d.comp_status_desc = 'PUBLIC' and country_of_incorporation = 'MYS' and comp_status_desc = 'PUBLIC'
and stock_code is null


select c.stock_code, d.dbt_entity_id, d.external_id, d.display_name, d.comp_status_desc
from 
dibots_v2.company_profile d 
left join (
select a.stock_code, b.identifier, b.dbt_entity_id 
from dibots_v2.exchange_daily_transaction a, dibots_v2.entity_identifier b
where a.stock_code = b.identifier and a.transaction_date = '2021-02-24' and b.identifier_type = 'STOCKEX' and b.deleted = false
) c
on c.dbt_entity_id = d.dbt_entity_id
where d.comp_status_desc = 'PUBLIC' and country_of_incorporation = 'MYS' and comp_status_desc = 'PUBLIC'
and stock_code is null


--=====================
--after bursa replied
--=====================

select * from plc_dir_ic where ic is null

select * from bursa_plc_dir_ic where dibots_ic is not null

update bursa_plc_dir_ic
set
dibots_ic = null
where dibots_ic = ''

select * from bursa_plc_dir_ic where length(dibots_ic) < 12 --and nationality = 'MYS'

select * from plc_dir_ic a
left join bursa_plc_dir_ic b
on a.id = b.id 
where length(btrim(b.dibots_ic)) = 12 and b.nationality <> 'MYS' and a.ic is null

update plc_dir_ic a
set
ic = b.dibots_ic
from bursa_plc_dir_ic b
where a.id = b.id and length(btrim(b.dibots_ic)) = 12 and b.nationality = 'MYS' and a.ic is null;

update plc_dir_ic a
set
ic = b.dibots_ic
from bursa_plc_dir_ic b
where a.id = b.id and length(btrim(b.dibots_ic)) = 12 and b.nationality <> 'MYS' and a.ic is null;

update plc_dir_ic a
set
passport = b.dibots_ic
from bursa_plc_dir_ic b
where a.id = b.id and length(btrim(dibots_ic)) < 12;



select * from plc_dir_ic where ic is not null and length(ic) = 12 and updated_ic = false

insert into dibots_v2.entity_identifier (dbt_entity_id, identifier_type, identifier, data_type, eff_from_date, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by, original_eff_from_date) 
select a.person_dbt_id, 'MK', a.ic, 'string', '1900-01-01', 1, '1900-01-01 00:00:00.0', now(), 'LKE', '1900-01-01 00:00:00.0'
from plc_dir_ic a
where a.ic is not null and a.updated_ic = false and length(ic) = 12
on conflict do nothing;

update plc_dir_ic a
set
updated_ic = true
from dibots_v2.entity_identifier b
where a.person_dbt_id = b.dbt_entity_id and b.identifier_type = 'MK' and b.deleted = false and a.ic = b.identifier and a.updated_ic = false and length(a.ic) = 12;

select * from plc_dir_ic a, dibots_v2.entity_identifier b
where a.person_dbt_id = b.dbt_entity_id and b.identifier_type = 'MK' and b.deleted = false and a.ic = b.identifier and a.updated_ic = false and length(a.ic) = 12;


insert into dibots_v2.entity_identifier (dbt_entity_id, identifier_type, identifier, data_type, eff_from_date, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by, original_eff_from_date) 
select a.person_dbt_id, 'PASSPORT', a.passport, 'string', '1900-01-01', 1, '1900-01-01 00:00:00.0', now(), 'LKE', '1900-01-01 00:00:00.0'
from plc_dir_ic a
where a.passport is not null and a.updated_passport = false 
on conflict do nothing;


select * from plc_dir_ic a, dibots_v2.entity_identifier b
where a.person_dbt_id = b.dbt_entity_id and b.identifier_type = 'PASSPORT' and b.deleted = false and a.passport = b.identifier and a.updated_passport = false;


update plc_dir_ic a
set
updated_passport = true
from dibots_v2.entity_identifier b
where a.person_dbt_id = b.dbt_entity_id and b.identifier_type = 'PASSPORT' and b.deleted = false and a.passport = b.identifier and a.updated_passport = false;

