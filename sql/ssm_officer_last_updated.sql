select * from public.tmp_sc_list;

alter table public.tmp_sc_list add column data_source varchar;

select distinct(designation_code) from dibots_v2.ssm_officer;

select count(*) from dibots_v2.ssm_officer where designation_code in ('V', 'R', 'D', 'A', 'T', 'L');

-- create ssm_officer_last_updated
select count(distinct(ssm_company_no)) from dibots_v2.ssm_officer;

select count(*) from dibots_v2.ssm_officer_last_updated where dbt_entity_id is not null; -- 72922

select * from dibots_v2.ssm_officer_last_updated where dbt_entity_id is not null

CREATE TABLE dibots_v2.ssm_officer_last_updated (
   ssm_company_no int PRIMARY KEY NOT NULL,
   dbt_entity_id uuid,
   external_id int,
   roc text,
   company_name text,
   last_updated date DEFAULT '2020-02-13'
);


insert into dibots_v2.ssm_officer_last_updated (ssm_company_no)
select distinct(ssm_company_no) from dibots_v2.ssm_officer ON CONFLICT DO NOTHING;

select count(*) from dibots_v2.ssm_officer_last_updated where company_name is null;

select * from dibots_v2.ssm_officer_last_updated

select * from dibots_v2.ssm_officer

update dibots_v2.ssm_officer_last_updated a
set
dbt_entity_id = b.company_entity_id,
external_id = b.company_ext_id
from dibots_v2.ssm_officer b
where a.ssm_company_no = b.ssm_company_no and a.dbt_entity_id is null;

update dibots_v2.ssm_officer_last_updated a
set
roc = b.identifier
from dibots_v2.entity_identifier b
where a.dbt_entity_id = b.dbt_entity_id and b.identifier_type = 'REGIST' and b.deleted = false and a.roc is null;

update dibots_v2.ssm_officer_last_updated a
set
company_name = b.display_name
from dibots_v2.company_profile b
where a.dbt_entity_id = b.dbt_entity_id and b.wvb_entity_type = 'COMP' and a.company_name is null;

update dibots_v2.ssm_officer_last_updated sol
set
dbt_entity_id = res.dbt_entity_id,
external_id = res.external_id,
roc = res.identifier,
company_name = res.company_name
from
(
select tmp.dbt_entity_id, tmp.external_id, tmp.identifier, tmp.roc, tmp.company_name from dibots_v2.ssm_officer_last_updated ssm
join
(
select ei.dbt_entity_id, cp.external_id, ei.identifier, cast(regexp_replace(identifier, '[^0-9]', '', 'g') as integer) as roc, cp.company_name from dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where ei.dbt_entity_id = cp.dbt_entity_id and cp.country_of_incorporation = 'MYS' and ei.identifier_type = 'REGIST') tmp
on ssm.ssm_company_no = tmp.roc) res
where res.roc = sol.ssm_company_no;

