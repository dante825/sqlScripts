--1. mys private companies that don't have company_person_roles
--2. mys private companies that don't have shareholder
--3. mys private companies that has 2017 and 2018 hdr but don't have data_item_values

select * from dibots_v2.company_profile where country_of_incorporation = 'MYS' and comp_status_desc = 'PRIVATE'

select * from dibots_v2.analyst_hdr

select * from dibots_v2.wvb_calc_item_value;


--===============================
--==== COMP_NO_ROLE   ===========
--===============================
--drop table comp_no_role;
create table comp_no_role (
id serial primary key,
dbt_entity_id uuid,
external_id int,
wvb_company_id int,
company_name varchar(255)
);

insert into comp_no_role (dbt_entity_id, external_id, wvb_company_id, company_name)
select cp.dbt_entity_id, cp.external_id, cp.wvb_company_id, cp.company_name 
from dibots_v2.company_profile cp
left join dibots_v2.company_person_role cpr
on cp.dbt_entity_id = cpr.company_id
where cp.country_of_incorporation = 'MYS' and cp.comp_status_desc = 'PRIVATE' and cp.wvb_entity_type = 'COMP' and cpr.eff_end_date is null and cpr.company_id is null;

select * from dibots_v2.company_person_role where company_id = '4a95319a-210b-4bbb-b5cc-901ba24024af'

select * from comp_no_role;


--=======================
-- COMP_NO_SHAREHOLDERS
--=======================
create table comp_no_shareholders (
id serial primary key,
dbt_entity_id uuid,
external_id int,
wvb_company_id int,
company_name varchar(255)
);

insert into comp_no_shareholders (dbt_entity_id, external_id, wvb_company_id, company_name)
select cp.dbt_entity_id, cp.external_id, cp.wvb_company_id, cp.company_name 
from dibots_v2.company_profile cp 
left join dibots_v2.equity_security_owner eqo
on cp.dbt_entity_id = eqo.company_id
where cp.country_of_incorporation = 'MYS' and cp.comp_status_desc = 'PRIVATE' and cp.wvb_entity_type = 'COMP'
and eqo.eff_thru_date is null and eqo.company_id is null;

select * from comp_no_shareholders;

select * from dibots_v2.equity_security_owner where company_id = '3bd9e8b8-57be-44b1-a20f-4be2212adefe'


--=====================
-- COMP_HDR_NO_DATA
--=====================

create table comp_hdr_no_data (
id serial primary key,
dbt_entity_id uuid,
external_id int,
wvb_company_id int,
company_name varchar(255),
wvb_hdr_id int,
fiscal_period_end_date date
);

-- companies with 2017 or 2018 hdr
select * from dibots_v2.company_profile cp, dibots_v2.analyst_hdr hdr
where cp.country_of_incorporation = 'MYS' and cp.comp_status_desc = 'PRIVATE' and cp.dbt_entity_id = hdr.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) in (2017, 2018)

insert into comp_hdr_no_data (dbt_entity_id, external_id, wvb_company_id, company_name, wvb_hdr_id, fiscal_period_end_date)
select tmp.dbt_entity_id, tmp.external_id, tmp.wvb_company_id, tmp.company_name, tmp.wvb_hdr_id, tmp.fiscal_period_end_date from 
(select cp.dbt_entity_id, cp.external_id, cp.wvb_company_id, cp.company_name, hdr.wvb_hdr_id, hdr.fiscal_period_end_date from dibots_v2.company_profile cp, dibots_v2.analyst_hdr hdr
where cp.country_of_incorporation = 'MYS' and cp.comp_status_desc = 'PRIVATE' and cp.dbt_entity_id = hdr.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) in (2017, 2018)) tmp
left join dibots_v2.wvb_calc_item_value calc
on tmp.wvb_hdr_id = calc.wvb_hdr_id
where calc.data_item_id is null

-- all years hdr
insert into comp_hdr_no_data (dbt_entity_id, wvb_hdr_id, fiscal_period_end_date)
select hdr.dbt_entity_id, hdr.wvb_hdr_id, hdr.fiscal_period_end_date
from dibots_v2.analyst_hdr hdr
left join dibots_v2.wvb_calc_item_value calc
on hdr.wvb_hdr_id = calc.wvb_hdr_id 
where hdr.dbt_entity_id in (select dbt_entity_id from dibots_v2.company_profile where country_of_incorporation = 'MYS' and comp_status_desc = 'PRIVATE')
and calc.data_item_id is null;

select * from comp_hdr_no_data --where extract(year from fiscal_period_end_date) in (2017, 2018)

update comp_hdr_no_data tmp
set
external_id = cp.external_id,
wvb_company_id = cp.wvb_company_id,
company_name = cp.company_name
from dibots_v2.company_profile cp
where tmp.dbt_entity_id = cp.dbt_entity_id
