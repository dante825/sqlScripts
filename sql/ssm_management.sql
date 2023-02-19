-- Create the 3 tmp_ssm_director, tmp_ssm_management, tmp_ssm_shareholders table

drop table if exists tmp_sc_ssm_director;
create table tmp_sc_ssm_director (
id serial primary key,
ssm_company_no integer,
dbt_entity_id uuid,
external_id integer,
roc varchar,
sc_company_name varchar,
dibots_company_name varchar,
industry varchar,
website varchar,
source varchar,
new_roc varchar, 
buss_code varchar,
buss_desc text,
priority integer,
ssm_id_type2 varchar,
ssm_person_id varchar,
officer_name varchar,
officer_birth_date date,
officer_address_1 text,
officer_address_2 text,
officer_address_3 text,
officer_postcode varchar,
officer_town varchar,
officer_state varchar,
officer_designation_code varchar,
officer_start_date date,
officer_resign_date date
);

-- joining tmp_sc_list, ssm_officer, and ssm_company to get the data for director, manager and owner
insert into tmp_sc_ssm_director(ssm_company_no,dbt_entity_id,external_id,roc,sc_company_name,dibots_company_name,industry,website,source,new_roc, buss_code,buss_desc,priority,ssm_id_type2,ssm_person_id,
officer_name,officer_birth_date,officer_address_1,officer_address_2,officer_address_3,officer_postcode,officer_town,officer_state,officer_designation_code,officer_start_date,officer_resign_date)
select ssm.ssm_company_no, ssm.dbt_entity_id, ssm.external_id, ssm.roc, sc.company, ssm.company_name as dibots_company_name, sc.industry, sc.website, sc.source, sc.new_roc,
ssm.buss_code, ssm.buss_desc, ssm.priority, ssm.ssm_id_type2, 
ssm.ssm_person_id, ssm.name as officer_name, ssm.birth_date as officer_birth_date, ssm.address1 as officer_address_1, ssm.address2 as officer_address_2, ssm.address3 as officer_officer_3, ssm.postcode as officer_postcode, 
ssm.town as officer_town, ssm.state as officer_state, ssm.designation_code as officer_designation_code, ssm.start_date as officer_start_date, ssm.resign_date as officer_resign_date
from public.tmp_sc_list sc
join
(select comp.ssm_company_no, comp.dbt_entity_id, comp.external_id, comp.roc, comp.company_name, comp.buss_code, comp.buss_desc, comp.priority, offi.ssm_id_type2, offi.ssm_person_id, offi.name, offi.birth_date, 
offi.address1, offi.address2, offi.address3, offi.postcode, offi.town, offi.state, offi.designation_code, offi.start_date, offi.resign_date
from dibots_v2.ssm_company comp
join dibots_v2.ssm_officer offi
on comp.ssm_company_no = offi.ssm_company_no
where offi.designation_code in ('Q', 'D')) ssm
on sc.dbt_entity_id = ssm.dbt_entity_id
where ssm.priority = 1;

update public.tmp_sc_list sc
set data_source = 'ssm'
from public.tmp_sc_ssm_management scssm
where sc.dbt_entity_id = scssm.dbt_entity_id

select * from public.tmp_sc_list where data_source is null;
