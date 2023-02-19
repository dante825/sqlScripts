select * from dibots_v2.person_profile a, dibots_v2.person_nationality b 
where a.dbt_entity_id = b.dbt_entity_id and b.nationality = 'MYS' and a.is_pep = false and a.biography is not null 
and (lower(a.biography) like '%legal advisor%')

select * from dibots_v2.person_profile a, dibots_v2.person_nationality b 
where a.dbt_entity_id = b.dbt_entity_id and b.nationality = 'MYS' and a.is_pep = false and a.biography is not null 
and (lower(a.biography) like '%member of parliament%')

select * from dibots_v2.person_profile a, dibots_v2.person_nationality b 
where a.dbt_entity_id = b.dbt_entity_id and b.nationality = 'MYS' and a.is_pep = false and a.biography is not null 
and (lower(a.biography) like '%minister%' or lower(a.biography) like '%political party%')

--drop table possible_pep;
create table possible_pep (
dbt_entity_id uuid primary key,
external_id bigint,
wvb_person_id bigint,
display_name text,
biography text,
is_pep bool,
pep_entity_id uuid
);

insert into possible_pep (dbt_entity_id, external_id, wvb_person_id, display_name, biography)
select a.dbt_entity_id, a.external_id, a.wvb_person_id, a.display_name, a.biography from dibots_v2.person_profile a, dibots_v2.person_nationality b 
where a.dbt_entity_id = b.dbt_entity_id and b.nationality = 'MYS' and a.is_pep = false and a.biography is not null 
and (lower(a.biography) like '%legal advisor%')
--and (lower(a.biography) like '%legal adviser%')
--and (lower(a.biography) like '%political secretary%')
--and (lower(a.biography) like '%attorney general%')
--and (lower(a.biography) like '%ministry%')
--and (lower(a.biography) like '%state assembly%')
--and (lower(a.biography) like '%member of parliament%')
--and (lower(a.biography) like '%minister%' or lower(a.biography) like '%political party%')
on conflict do nothing

select count(*) from possible_pep

select * from possible_pep;

select * from dibots_v2.entity_link

select * from possible_pep a, dibots_v2.entity_link b
where a.dbt_entity_id = b.source_entity

update possible_pep a
set
is_pep = true
from dibots_v2.entity_link b
where a.dbt_entity_id = b.source_entity;

select count(*) from possible_pep where is_pep = true

delete from possible_pep where is_pep = true;

--=======================================

select * from possible_pep where pep_entity_id is not null

select * from possible_pep a, dibots_v2.person_profile b, dibots_v2.entity_master c
where lower(a.display_name) = lower(b.display_name) and b.is_pep = true and b.wvb_entity_type = 'PEP_PERS' and a.dbt_entity_id <> b.dbt_entity_id 
and b.dbt_entity_id = c.dbt_entity_id and c.refer_to is null

update possible_pep a
set pep_entity_id = b.dbt_entity_id
from dibots_v2.person_profile b
where lower(a.display_name) = lower(b.display_name) and b.is_pep = true and b.wvb_entity_type = 'PEP_PERS' and a.dbt_entity_id <> b.dbt_entity_id;
