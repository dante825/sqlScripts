-- REVERSE the changes made by etl_lke (to an extent)
-- Only on the non-entity tables

update dibots_v2.equity_security_owner a
set
owner_id = result.dbt_entity_id,
modified_by = 'LKE',
modified_dtime = now()
from (select * from dibots_v2.equity_security_owner eso, dibots_v2.entity_master em
where eso.owner_id = em.refer_to and em.modified_by = 'LKE' and em.modified_by >= '2021-01-01') result
where a.id = result.id;


update dibots_v2.wvb_dir_dealing a
set
dealer_id = result.dbt_entity_id,
modified_by = 'LKE',
modified_dtime = now()
from (select * from dibots_v2.wvb_dir_dealing dir, dibots_v2.entity_master em 
where dir.dealer_id = em.refer_to and em.modified_by = 'LKE' and em.modified_dtime >= '2021-01-01') result
where a.id = result.id;


update dibots_v2.company_person_role a
set
person_id = result.dbt_entity_id,
modified_by = 'LKE',
modified_dtime = now()
from (select * from dibots_v2.company_person_role cpr, dibots_v2.entity_master em
where cpr.person_id = em.refer_to and em.modified_by = 'LKE' and em.modified_dtime >= '2021-01-01') result
where a.id = result.id;


update dibots_v2.company_person_role_sal_hdr a
set
person_id = result.dbt_entity_id,
modified_by = 'LKE',
modified_dtime = now()
from (select * from dibots_v2.company_person_role_sal_hdr cpr, dibots_v2.entity_master em
where cpr.person_id = em.refer_to and em.modified_by = 'LKE' and em.modified_dtime >= '2021-01-01') result
where a.person_role_sal_hdr_perm_id = result.person_role_sal_hdr_perm_id;


update dibots_v2.person_relationship a
set
dbt_entity_id = result.dbt_entity_id,
modified_by = 'LKE',
modified_dtime = now()
from (select * from dibots_v2.person_relationship pr, dibots_v2.entity_master em
where pr.dbt_entity_id = em.refer_to and em.modified_by = 'LKE' and em.modified_dtime >= '2021-01-01') result
where a.dbt_entity_id = result.refer_to;


update dibots_v2.person_relationship a
set
target_entity_id = result.dbt_entity_id,
modified_by = 'LKE',
modified_dtime = now()
from (select * from dibots_v2.person_relationship pr, dibots_v2.entity_master em
where pr.target_entity_id = em.refer_to and em.modified_by = 'LKE' and em.modified_dtime >= '2021-01-01') result
where a.target_entity_id = result.refer_to;


update dibots_v2.entity_image a
set
dbt_entity_id = result.dbt_entity_id,
modified_by = 'LKE',
modified_dtime = now()
from (select * from dibots_v2.entity_image ei, dibots_v2.entity_master em
where ei.dbt_entity_id = em.refer_to and em.modified_by = 'LKE' and em.modified_dtime >= '2021-01-01') result
where a.dbt_entity_id = result.refer_to;


update dibots_v2.entity_image ei
set
external_id =  em.external_id,
modified_by = 'LKE',
modified_dtime = now()
from dibots_v2.entity_master em
where ei.dbt_entity_id = em.dbt_entity_id and ei.external_id <> em.external_id;