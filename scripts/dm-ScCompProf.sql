-- Task 2: get the sanctioned company in the sc list
-- getting all the company that has sanction in the tmp_sc_list
select * from tmp_sc_list sc, dibots_v2.sanction sa
where sc.dbt_entity_id = sa.dbt_entity_id;

select * from tmp_sc_list sc, dibots_v2.company_profile cp
where sc.dbt_entity_id = cp.dbt_entity_id and cp.wvb_entity_type = 'SANC_COMP'

-- with some regex matching
select * from tmp_sc_list sc, dibots_v2.company_profile cp
where regexp_replace(lower(sc.company), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(cp.company_name), '[^A-Za-z0-9]', '', 'g') and cp.wvb_entity_type = 'SANC_COMP';

--create a table for the sc sanction
create table tmp_sc_sanction (
id serial primary key,
dbt_entity_id uuid,
external_id integer,
company_name varchar,
sanction_entity_id uuid,
sanction_external_id integer,
sanction_company_name varchar,
news text
);

-- inserting data into the tmp_sc_sanction table
insert into tmp_sc_sanction (dbt_entity_id, external_id, company_name, sanction_entity_id, sanction_external_id, sanction_company_name)
select sc.dbt_entity_id, sc.external_id, sc.company, cp.dbt_entity_id, cp.external_id, cp.company_name from tmp_sc_list sc, dibots_v2.company_profile cp
where regexp_replace(lower(sc.company), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(cp.company_name), '[^A-Za-z0-9]', '', 'g') and cp.wvb_entity_type = 'SANC_COMP';

select * from tmp_sc_sanction;

-- task 3: create a profile information for the sc companies
--drop table if exists tmp_sc_comp_prof;
create table tmp_sc_comp_prof (
id serial primary key,
dbt_entity_id uuid,
external_id integer,
company_name varchar,
company_desc text,
year_of_incorporation integer,
company_type varchar,
country_of_domicile varchar(3),
country_of_incorporation varchar(3),
industry_type varchar,
std_industry_code varchar,
std_industry_desc text,
legal_address text,
web_address text, 
hq_address text
);

-- just have 201 records, while we have 303 records that has uuid
insert into tmp_sc_comp_prof (dbt_entity_id, external_id, company_name, company_desc, year_of_incorporation, company_type, country_of_domicile, country_of_incorporation, industry_type, std_industry_code,
std_industry_desc, legal_address)
select sc.dbt_entity_id, sc.external_id, sc.company, cd.description, cp.year_of_incorporation, cp.company_type, cp.country_of_domicile, cp.country_of_incorporation, cp.industry_type, 
ind.std_industry_code, std.std_industry_desc, concat_ws(', ', addr.address_line_1, addr.address_line_2, addr.address_line_3, addr.address_line_4, addr.postcode, addr.city, addr.state) as legal_address
from tmp_sc_list sc, dibots_v2.company_description cd, dibots_v2.company_profile cp, dibots_v2.company_std_ind_code ind, dibots_v2.ref_std_industrial_classif_codes std, dibots_v2.address_master addr
where sc.dbt_entity_id = cd.dbt_entity_id and sc.dbt_entity_id = cp.dbt_entity_id and cd.comp_desc_type = 'SHORT' and sc.dbt_entity_id = ind.dbt_entity_id and 
ind.std_industry_code = std.std_industrial_code and sc.dbt_entity_id = addr.dbt_entity_id and addr.address_type = 'LEGAL';

--insert the id and name first
insert into tmp_sc_comp_prof(dbt_entity_id, external_id, company_name)
select sc.dbt_entity_id, sc.external_id, sc.company from tmp_sc_list sc where sc.dbt_entity_id is not null;

update tmp_sc_comp_prof prof
set 
dbt_entity_id = sc.dbt_entity_id,
external_id = sc.external_id
from tmp_sc_list sc
where sc.old_roc = prof.roc and prof.dbt_entity_id is null;

-- then update column by column
update tmp_sc_comp_prof sc
set
company_desc = cd.description
from dibots_v2.company_description cd
where sc.dbt_entity_id = cd.dbt_entity_id and cd.comp_desc_type = 'SHORT';

update tmp_sc_comp_prof sc
set
year_of_incorporation = cp.year_of_incorporation,
company_type = cp.company_type, 
country_of_domicile = cp.country_of_domicile,
country_of_incorporation = cp.country_of_incorporation, 
industry_type = cp.industry_type
from dibots_v2.company_profile cp
where sc.dbt_entity_id = cp.dbt_entity_id;

update tmp_sc_comp_prof sc
set 
std_industry_code = ind.std_industry_code,
std_industry_desc = std.std_industry_desc
from dibots_v2.company_std_ind_code ind, dibots_v2.ref_std_industrial_classif_codes std
where sc.dbt_entity_id = ind.dbt_entity_id and ind.std_industry_code = std.std_industrial_code and ind.ranking = 1;

update tmp_sc_comp_prof sc
set legal_address = concat_ws(', ', addr.address_line_1, addr.address_line_2, addr.address_line_3, addr.address_line_4, addr.postcode, addr.city, addr.state)
from dibots_v2.address_master addr
where sc.dbt_entity_id = addr.dbt_entity_id and addr.address_type = 'LEGAL';

update tmp_sc_comp_prof sc
set hq_address = concat_ws(', ', addr.address_line_1, addr.address_line_2, addr.address_line_3, addr.address_line_4, addr.postcode, addr.city, addr.state)
from dibots_v2.address_master addr
where sc.dbt_entity_id = addr.dbt_entity_id and addr.address_type = 'CORP';

-- add 2 more descriptions from ssm tables
alter table tmp_sc_comp_prof add column business_desc text;

alter table tmp_sc_comp_prof add column buss_ind_desc text;

select sc.dbt_entity_id, sc.company_name, ssm.company_name, ssm.business_description 
from tmp_sc_comp_prof sc, dibots_v2.ssm_comp_prof ssm
where sc.dbt_entity_id = ssm.dbt_entity_id

select sc.dbt_entity_id, sc.company_name, ssm.company_name, ssm.buss_desc 
from tmp_sc_comp_prof sc, dibots_v2.ssm_comp_buss_code ssm
where sc.dbt_entity_id = ssm.dbt_entity_id and ssm.buss_desc is not null and priority = 1

update tmp_sc_comp_prof sc
set
business_desc = ssm.business_description
from dibots_v2.ssm_comp_prof ssm
where sc.dbt_entity_id = ssm.dbt_entity_id;

update tmp_sc_comp_prof sc
set
buss_ind_desc = ssm.buss_desc
from dibots_v2.ssm_comp_buss_code ssm
where sc.dbt_entity_id = ssm.dbt_entity_id and ssm.priority = 1

select count(*) from tmp_sc_comp_prof where (buss_ind_desc is not null or business_desc is not null or std_industry_desc is not null);

select count(*) from tmp_sc_comp_prof where (buss_ind_desc is null and business_desc is null and std_industry_desc is null) and dbt_entity_id is not null
