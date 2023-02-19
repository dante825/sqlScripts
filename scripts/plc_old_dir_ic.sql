-- The purpose of creating this table is to update the IC of old directors (directors with eff_end_date not null)
-- check their IC against bursa data

--drop table plc_old_dir_ic;
create table plc_old_dir_ic (
id serial primary key,
company_dbt_id uuid,
company_ext_id bigint,
stock_code varchar(10),
company_name varchar(255),
person_dbt_id uuid,
person_ext_id bigint,
person_name varchar(255),
eff_end_date date,
request bool default false,
nationality varchar(5),
gender varchar(10),
dibots_ic varchar(100),
bursa_ic varchar(100),
data_year int,
mismatched bool default false,
correct_ic varchar(100),
passport varchar(100),
sg_ic varchar(100),
old_ic varchar(100),
updated_ic bool default false,
updated_passport bool default false,
updated_sg_ic bool default false,
updated_old_ic bool default false
);

select * from plc_old_dir_ic;

insert into plc_old_dir_ic (company_dbt_id, company_ext_id, company_name, person_dbt_id, eff_end_date, dibots_ic)
select a.dbt_entity_id, a.external_id, a.display_name, a.person_id, a.eff_end_date, ei.identifier
from
(select cp.dbt_entity_id, cp.external_id, cp.display_name, cpr.company_id, cpr.person_id, cpr.eff_end_date
from dibots_v2.company_profile cp, dibots_v2.company_person_role cpr
where cp.dbt_entity_id = cpr.company_id and cp.country_of_incorporation = 'MYS' and cp.comp_status_desc = 'PUBLIC' and cp.active = true and cpr.eff_end_date is not null
and cpr.role_type in ('DIR', 'DIR1', 'DIR2', 'INDIR', 'MANDIR', 'OUTDIR', 'VCHAIR', 'VMANDIR')) a
left join dibots_v2.entity_identifier ei
on a.person_id = ei.dbt_entity_id and ei.deleted = false and ei.identifier_type IN ('MK', 'PASSPORT')
--where ei.id is null;

update plc_old_dir_ic a
set
person_ext_id = pp.external_id,
person_name = pp.display_name,
gender = pp.gender
from dibots_v2.person_profile pp
where a.person_dbt_id = pp.dbt_entity_id;

update plc_old_dir_ic a
set
nationality = pn.nationality
from dibots_v2.person_nationality pn
where a.person_dbt_id = pn.dbt_entity_id;

select * from plc_old_dir_ic a, dibots_v2.exchange_stock_profile b
where a.company_dbt_id = b.stock_identifier;

update plc_old_dir_ic a
set
stock_code = b.stock_code
from dibots_v2.exchange_stock_profile b
where a.company_dbt_id = b.stock_identifier;

select * from plc_old_dir_ic where stock_code is null;

-- ic from dibots db
update plc_old_dir_ic a
set
dibots_ic = b.identifier
from dibots_v2.entity_identifier b
where a.person_dbt_id = b.dbt_entity_id and b.identifier_type = 'MK' and b.deleted = false and a.dibots_ic is null; --a.dibots_ic <> b.identifier;

select * from plc_old_dir_ic a, dibots_v2.entity_identifier b
where a.person_dbt_id = b.dbt_entity_id and b.identifier_type = 'MK' and b.deleted = false and a.dibots_ic is null;

select a.company_dbt_id, a.company_name, a.person_dbt_id, a.dibots_ic, a.bursa_ic, b.identifier from plc_old_dir_ic a, dibots_v2.entity_identifier b
where a.person_dbt_id = b.dbt_entity_id and b.identifier_type = 'MK' and b.deleted = false and a.dibots_ic <> b.identifier;

-- ic from bursa

-- 1. update the data_year column first
update plc_old_dir_ic plc
set
data_year = tmp.max_submission_year
from (
select btrim(b.stock_code) as stock_code, lower(btrim(b.names_of_directors)) as dir_name, max(b.submission_year_int) as max_submission_year
from tmp_bursa_dir_shareholdings b
group by btrim(b.stock_code), lower(btrim(b.names_of_directors))) tmp
where plc.stock_code = tmp.stock_code and lower(btrim(plc.person_name)) = dir_name;

-- 2. update the bursa_ic based on name and data year
update plc_old_dir_ic a
set
bursa_ic = b.cleansed_ic
from tmp_bursa_dir_shareholdings b
where a.stock_code = b.stock_code and btrim(lower(a.person_name)) = btrim(lower(b.names_of_directors)) and a.data_year = b.submission_year_int and b.cleansed_ic is not null
and a.bursa_ic is null;

select * from plc_old_dir_ic a, tmp_bursa_dir_shareholdings b
where a.stock_code = b.stock_code and btrim(lower(a.person_name)) = btrim(lower(b.names_of_directors)) and a.data_year = b.submission_year_int and b.cleansed_ic is not null
and lower(a.person_name) = 'lee chee hoe'

-- 3. update the mismatched flag
update plc_old_dir_ic a
set
mismatched = true
where a.dibots_ic <> a.bursa_ic;

-- duplication removal
select company_dbt_id, person_dbt_id, min(id), count(*) from plc_old_dir_ic
group by company_dbt_id, person_dbt_id having count(*) > 1

delete from plc_old_dir_ic
where id in (
(select min(id) from plc_old_dir_ic
group by company_dbt_id, person_dbt_id having count(*) > 1))


-- 94
select count(*) from plc_old_dir_ic where mismatched = true;

-- 461
select * from plc_old_dir_ic where dibots_ic is null and bursa_ic is not null

-- 3780
select count(*) from plc_old_dir_ic where dibots_ic is not null and bursa_ic is null;

-- 4487
select count(*) from plc_old_dir_ic where dibots_ic is null and bursa_ic is null;


select id, company_ext_id, stock_code, company_name, person_ext_id, person_name, eff_end_date, dibots_ic as ic
from plc_old_dir_ic where eff_end_date >= '2000-01-01' and dibots_ic is null and bursa_ic is null


-- for those cases where dibots_ic is null and bursa_ic is not null
-- insert the bursa_ic into entity_identifier

insert into dibots_v2.entity_identifier (dbt_entity_id, identifier_type, identifier, data_type, eff_from_date, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by, original_eff_from_date) 
select person_dbt_id, 'MK', correct_ic, 'string', '1900-01-01', 1, '1900-01-01 00:00:00.0', now(), 'kangwei', '1900-01-01 00:00:00.0'
from 
(select distinct person_dbt_id, correct_ic
from plc_old_dir_ic where correct_ic is not null) a
ON CONFLICT DO NOTHING

select * from dibots_v2.entity_identifier where created_by = 'kangwei' and created_dtime::date = '2021-03-19'



-- to add the date of birth into person_profile

select count(*) from plc_old_dir_ic a, dibots_v2.person_profile b
where a.person_dbt_id = b.dbt_entity_id and a.correct_ic is not null and b.year_of_birth is null

select * from tmp_person_dob

update tmp_person_dob
set
update = true;

insert into tmp_person_dob (dbt_entity_id, display_name, mk)
select distinct person_dbt_id, person_name, correct_ic
from plc_old_dir_ic where correct_ic is not null

select * from tmp_person_dob where update = false;

update tmp_person_dob
set
year_str = '19' || substring(mk from 1 for 2), 
month_str = ltrim(substring(mk from 3 for 2), '0'),
day_str = ltrim(substring(mk from 5 for 2), '0')
where update = false

update tmp_person_dob
set
mk_year = cast(year_str as int), 
mk_month = cast(month_str as int),
mk_day = cast(day_str as int)
where update = false



select a.dbt_entity_id, a.display_name, b.display_name, a.mk_year, a.mk_month, a.mk_day, b.year_of_birth, b.month_of_birth, b.day_of_birth  from tmp_person_dob a, dibots_v2.person_profile b
where a.update = false and a.dbt_entity_id = b.dbt_entity_id

update dibots_v2.person_profile a
set
year_of_birth = b.mk_year,
month_of_birth = b.mk_month,
day_of_birth = b.mk_day,
modified_by = 'kangwei',
modified_dtime = now()
from tmp_person_dob b
where b.update = false and a.dbt_entity_id = b.dbt_entity_id;

select count(*) from dibots_v2.person_profile where modified_dtime::date = '2021-03-19' and modified_by = 'kangwei';
