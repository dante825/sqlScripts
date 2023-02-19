-- bursa loan checklist file

create table bursa_loan (
id serial primary key,
dbt_entity_id uuid,
external_id int,
wvb_company_id int,
company_name varchar(255),
roc varchar,
industry varchar,
principal_activities text,
gross_sales_2018 int,
gross_sales_2017 int,
gross_sales_2016 int,
sale_growth_2017_2018 numeric(22,2),
sale_growth_2017_2018_str varchar,
sale_growth_2016_2017 numeric(22,2),
sale_growth_2016_2017_str varchar,
year_of_business int,
company_address text,
loan_lead_1 varchar(1),
loan_lead_2 varchar(1),
loan_lead_3 varchar(1),
loan_lead_4 varchar(1),
loan_lead_5 varchar(1),
loan_lead_6 varchar(1),
loan_lead_7 varchar(1),
loan_lead_8 varchar(1),
loan_lead_9 varchar(1),
loan_lead_10 varchar(1),
loan_lead_11 varchar(1)
);

select * from bursa_loan

-- Update the ids
update bursa_loan bursa
set
dbt_entity_id = cp.dbt_entity_id,
external_id = cp.external_id,
wvb_company_id = cp.wvb_company_id
from 
dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where bursa.roc = ei.identifier and ei.identifier_type = 'REGIST' and ei.dbt_entity_id = cp.dbt_entity_id;

-- update the sales_growth fields
update bursa_loan 
set
sale_growth_2017_2018 = cast(regexp_replace(sale_growth_2017_2018_str, '%', '', 'g') as numeric(22,2)),
sale_growth_2016_2017 = CASE WHEN sale_growth_2016_2017_str = '' THEN 0.0 ELSE cast(regexp_replace(sale_growth_2016_2017_str, '%', '', 'g') as numeric(22,2)) END

alter table bursa_loan drop column sale_growth_2016_2017_str, drop column sale_growth_2017_2018_str;

-- listing status
alter table bursa_loan add column is_listed bool;

update bursa_loan bursa
set
is_listed = true
from dibots_v2.company_profile cp
where bursa.dbt_entity_id = cp.dbt_entity_id and cp.comp_status_desc = 'PUBLIC';

update bursa_loan bursa
set
is_listed = false
from dibots_v2.company_profile cp
where bursa.dbt_entity_id = cp.dbt_entity_id and cp.comp_status_desc = 'PRIVATE';

select * from bursa_loan

-- is a subsidiary of a listed company
alter table bursa_loan add column is_subsidiary bool default false, add column listed_parent_id uuid, add column listed_parent_name varchar;

select * from bursa_loan bursa, dibots_v2.wvb_company_subsidiary subs, dibots_v2.company_profile cp
where bursa.dbt_entity_id = subs.subsidiary_id and subs.company_id = cp.dbt_entity_id --and cp.comp_status_desc = 'PUBLIC'

update bursa_loan bursa
set
is_subsidiary = true,
listed_parent_id = subs.company_id,
listed_parent_name = cp.company_name
from dibots_v2.wvb_company_subsidiary subs, dibots_v2.company_profile cp
where bursa.dbt_entity_id = subs.subsidiary_id and subs.company_id = cp.dbt_entity_id --and cp.comp_status_desc = 'PUBLIC'

-- has a listed subsidiary
alter table bursa_loan add column has_subsidiary bool default false, add column subsidiary_id uuid, add column subsidiary_name varchar;

select * from bursa_loan bursa, dibots_v2.wvb_company_subsidiary subs, dibots_v2.company_profile cp
where bursa.dbt_entity_id = subs.company_id and subs.company_id = cp.dbt_entity_id

select * from bursa_loan bursa, dibots_v2.wvb_company_subsidiary subs, dibots_v2.equity_security_owner eqo
where bursa.dbt_entity_id = subs.company_id and subs.subsidiary_id = eqo.company_id and eqo.eff_thru_date is null and eqo.is_deleted = false

update bursa_loan
set
has_subsidiary = true,
subsidiary_id = subs.subsidiary_id,
subsidiary_name = cp.company_name
from bursa_loan bursa, dibots_v2.wvb_company_subsidiary subs, dibots_v2.company_profile cp
where bursa.dbt_entity_id = subs.company_id and subs.company_id = cp.dbt_entity_id

-- is_santioned
alter table bursa_loan add column is_sanctioned bool default false;

select * from bursa_loan bursa, dibots_v2.company_profile cp
where bursa.dbt_entity_id = cp.dbt_entity_id and cp.wvb_entity_type = 'SANC_COMP'

select * from bursa_loan bursa, dibots_v2.company_profile cp
where regexp_replace(lower(bursa.company_name), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(cp.company_name), '[^A-Za-z0-9]', '', 'g') and cp.wvb_entity_type = 'SANC_COMP';

update bursa_loan bursa
set 
is_sanctioned = true
from 
dibots_v2.company_profile cp
where regexp_replace(lower(bursa.company_name), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(cp.company_name), '[^A-Za-z0-9]', '', 'g') and cp.wvb_entity_type = 'SANC_COMP';

-- max_fin_year
alter table bursa_loan add column fin_year int;

select bursa.dbt_entity_id, max(hdr.fiscal_period_end_date) from bursa_loan bursa, dibots_v2.analyst_hdr_view hdr
where bursa.dbt_entity_id = hdr.dbt_entity_id
group by bursa.dbt_entity_id

update bursa_loan bursa
set
fin_year = extract(year from tmp.max_date)
from 
(select bursa.dbt_entity_id, max(hdr.fiscal_period_end_date) as max_date from bursa_loan bursa, dibots_v2.analyst_hdr_view hdr
where bursa.dbt_entity_id = hdr.dbt_entity_id
group by bursa.dbt_entity_id) tmp
where bursa.dbt_entity_id = tmp.dbt_entity_id

select dbt_entity_id from bursa_loan
group by dbt_entity_id having count(*) > 1

select * from bursa_loan where dbt_entity_id = 'c767efbf-b782-48d8-8b03-1f46487d6382'

-- add wvb_company_id
alter table bursa_loan add column wvb_company_id int;

update bursa_loan bursa
set
wvb_company_id = cp.wvb_company_id
from dibots_v2.company_profile cp
where bursa.dbt_entity_id = cp.dbt_entity_id;
