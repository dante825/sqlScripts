
--drop table plc_dir_ic_bursa_mismatched;
create table plc_dir_ic_bursa_mismatched (
id serial primary key,
company_dbt_id uuid,
company_ext_id bigint,
stock_code varchar(10),
company_name varchar(255),
person_dbt_id uuid,
person_ext_id bigint,
person_name varchar(255),
dibots_ic varchar(100),
bursa_ic varchar(100),
mismatched bool default false,
data_year int
);

select * from plc_dir_ic_bursa_mismatched --where stock_code is null

insert into plc_dir_ic_bursa_mismatched (company_dbt_id, company_ext_id, company_name, person_dbt_id, dibots_ic)
select a.dbt_entity_id, a.external_id, a.display_name, a.person_id, ei.identifier
from
(select cp.dbt_entity_id, cp.external_id, cp.display_name, cpr.company_id, cpr.person_id
from dibots_v2.company_profile cp, dibots_v2.company_person_role cpr
where cp.dbt_entity_id = cpr.company_id and cp.country_of_incorporation = 'MYS' and cp.comp_status_desc = 'PUBLIC' and cp.active = true and cpr.eff_end_date is null
and cpr.role_type in ('DIR', 'DIR1', 'DIR2', 'INDIR', 'MANDIR', 'OUTDIR', 'VCHAIR', 'VMANDIR')) a
left join dibots_v2.entity_identifier ei
on a.person_id = ei.dbt_entity_id and ei.deleted = false and ei.identifier_type = 'MK'
where ei.id is not null;

update plc_dir_ic_bursa_mismatched a
set
stock_code = b.stock_code
from dibots_v2.exchange_stock_profile b
where a.company_dbt_id = b.stock_identifier;

update plc_dir_ic_bursa_mismatched a
set
person_ext_id = pp.external_id,
person_name = pp.display_name
from dibots_v2.person_profile pp
where a.person_dbt_id = pp.dbt_entity_id;

-- bursa ic souce table public.tmp_bursa_dir_shareholding

select * from tmp_bursa_dir_shareholdings;

select b.stock_code, b.names_of_directors, max(b.submission_year)
from tmp_bursa_dir_shareholdings b
group by b.stock_code, b.names_of_directors

select a.stock_code, b.stock_code, a.company_name, b.company_name, a.person_name, b.names_of_directors, max(submission_year) 
from plc_dir_ic_bursa_mismatched a, tmp_bursa_dir_shareholdings b
where a.stock_code = b.stock_code and lower(a.person_name) = lower(b.names_of_directors) and b.cleansed_ic is not null
group by a.stock_code, b.stock_code, a.company_name, b.company_name, a.person_name, b.names_of_directors


update plc_dir_ic_bursa_mismatched a
set
dibots_ic = b.identifier
from dibots_v2.entity_identifier b
where a.person_dbt_id = b.dbt_entity_id and b.identifier_type = 'MK' and b.deleted = false;

update plc_dir_ic_bursa_mismatched plc
set
data_year = tmp.max_submission_year
from (
select btrim(b.stock_code) as stock_code, lower(btrim(b.names_of_directors)) as dir_name, max(b.submission_year_int) as max_submission_year
from tmp_bursa_dir_shareholdings b
where lower(names_of_directors) like 'abdul khudus%'
group by btrim(b.stock_code), lower(btrim(b.names_of_directors))) tmp
where plc.stock_code = tmp.stock_code and lower(btrim(plc.person_name)) = dir_name;


update plc_dir_ic_bursa_mismatched a
set
bursa_ic = b.cleansed_ic
from tmp_bursa_dir_shareholdings b
where btrim(a.stock_code) = btrim(b.stock_code) and lower(btrim(a.person_name)) = lower(btrim(b.names_of_directors)) and a.data_year = b.submission_year_int
--and lower(btrim(a.company_name)) = lower(btrim(b.company_name));

select count(*) from plc_dir_ic_bursa_mismatched

select count(*) from plc_dir_ic_bursa_mismatched where bursa_ic is null;

select count(*) from plc_dir_ic_bursa_mismatched where bursa_ic is not null;

update plc_dir_ic_bursa_mismatched
set
mismatched = true
where btrim(dibots_ic) <> btrim(bursa_ic) and bursa_ic is not null;

update plc_dir_ic_bursa_mismatched
set
mismatched = false
where btrim(dibots_ic) = btrim(bursa_ic) and bursa_ic is not null;

select count(*) from plc_dir_ic_bursa_mismatched where mismatched = true and bursa_ic is not null;

select * from plc_dir_ic_bursa_mismatched where mismatched = true and bursa_ic is not null;

-- for those bursa_ic is null, try to match to tmp_bursa_dir_shareholdings with ic

select a.dibots_ic, a.bursa_ic, b.cleansed_ic from plc_dir_ic_bursa_mismatched a, tmp_bursa_dir_shareholdings b
where a.dibots_ic = b.cleansed_ic and a.bursa_ic is null

update plc_dir_ic_bursa_mismatched a
set
bursa_ic = b.cleansed_ic
from tmp_bursa_dir_shareholdings b
where a.dibots_ic = b.cleansed_ic and a.bursa_ic is null;

select * from plc_dir_ic_bursa_mismatched where bursa_ic is not null and mismatched = false

--========================================
-- cleanup tmp_bursa_dir_shareholdings
--========================================

select * from tmp_bursa_dir_shareholdings where nationality in ('Malaysian', 'PR')

alter table tmp_bursa_dir_shareholdings add column cleansed_ic varchar(100), add column submission_year_int int;

select submission_year::integer from tmp_bursa_dir_shareholdings;

update tmp_bursa_dir_shareholdings
set
submission_year_int = submission_year::integer;

select * from tmp_bursa_dir_shareholdings where nationality in ('Malaysian', 'PR')  and cleansed_ic is null and nric_no is not null

-- some nric no has .0 in it
select count(*) from tmp_bursa_dir_shareholdings where nric_no like '%.0'

select nric_no, regexp_replace(nric_no, '\.0', '', 'g') from tmp_bursa_dir_shareholdings where nric_no like '%.0'

update tmp_bursa_dir_shareholdings a
set
cleansed_ic = regexp_replace(nric_no, '\.0', '', 'g')
where nric_no like '%.0' and lower(nationality) in ('malaysian', 'pr', 'malaysia');

update tmp_bursa_dir_shareholdings a
set
cleansed_ic = regexp_replace(nric_no, '[^0-9]', '', 'g')
where lower(nationality) in ('malaysian', 'pr', 'malaysia') and length(btrim(nric_no)) = 14 and cleansed_ic is null;

update tmp_bursa_dir_shareholdings a
set
cleansed_ic = regexp_replace(nric_no, '[^0-9]', '', 'g')
where nationality is null and length(btrim(nric_no)) = 14 and cleansed_ic is null;

update tmp_bursa_dir_shareholdings a
set
cleansed_ic = regexp_replace(nric_no, '[^0-9]', '', 'g')
where lower(btrim(nationality)) = 'foreigner' and length(btrim(nric_no)) = 14 and cleansed_ic is null and nric_no like '%-%';

update tmp_bursa_dir_shareholdings a
set
cleansed_ic = regexp_replace(nric_no, '[^0-9]', '', 'g')
where length(btrim(nric_no)) = 14 and cleansed_ic is null and nric_no like '%-%';

update tmp_bursa_dir_shareholdings a
set
cleansed_ic = regexp_replace(nric_no, '[^0-9]', '', 'g')
where lower(nationality) in ('malaysian', 'pr', 'malaysia') and length(btrim(nric_no)) = 12 and cleansed_ic is null;

select * from tmp_bursa_dir_shareholdings where cleansed_ic is not null;

-- remove those length of the ic not 12
select * from tmp_bursa_dir_shareholdings where length(cleansed_ic) < 12

update tmp_bursa_dir_shareholdings a
set
cleansed_ic = null
where length(cleansed_ic) < 12;

select count(*) from tmp_bursa_dir_shareholdings;

select count(*) from tmp_bursa_dir_shareholdings where cleansed_ic is not null;

select * from tmp_bursa_dir_shareholdings where length(cleansed_ic) > 12

update tmp_bursa_dir_shareholdings a
set
cleansed_ic = null
where length(cleansed_ic) > 12;


