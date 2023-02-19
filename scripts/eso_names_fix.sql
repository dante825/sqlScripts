-- Updating the names in equity_security_owner

-- updating the company_name
select eso.id, eso.company_id, eso.company_name, cp.display_name 
from dibots_v2.equity_security_owner eso, dibots_v2.company_profile cp
where eso.company_id = cp.dbt_entity_id and eso.company_name <> cp.display_name;

update dibots_v2.equity_security_owner eso
set
company_name = cp.display_name,
comp_status_desc = cp.comp_status_desc,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where eso.company_id = cp.dbt_entity_id and eso.company_name <> cp.display_name;

select count(*) from dibots_v2.equity_security_owner where modified_dtime::date = '2021-02-03' and modified_by = 'kangwei'

--updating the owner_name

select eso.id, eso.owner_id, eso.owner_name, pp.display_name 
--select count(*)
from dibots_v2.equity_security_owner eso, dibots_v2.person_profile pp
where eso.security_owner_type = 'PERSON' and eso.owner_id = pp.dbt_entity_id and eso.owner_name <> pp.display_name;

update dibots_v2.equity_security_owner eso
set
owner_name = pp.display_name,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.person_profile pp
where eso.security_owner_type = 'PERSON' and eso.owner_id = pp.dbt_entity_id and eso.owner_name <> pp.display_name;



select eso.id, eso.owner_id, eso.owner_name, cp.display_name 
--select count(*)
from dibots_v2.equity_security_owner eso, dibots_v2.company_profile cp
where eso.security_owner_type = 'CMPY' and eso.owner_id = cp.dbt_entity_id and eso.owner_name <> cp.display_name;

update dibots_v2.equity_security_owner eso
set
owner_name = cp.display_name,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where eso.security_owner_type = 'CMPY' and eso.owner_id = cp.dbt_entity_id and eso.owner_name <> cp.display_name;


select eso.id, eso.owner_id, eso.owner_name, ip.institution_name 
--select count(*)
from dibots_v2.equity_security_owner eso, dibots_v2.institution_profile ip
where eso.security_owner_type = 'INST' and eso.owner_id = ip.dbt_entity_id and eso.owner_name <> ip.institution_name;

select eso.id, eso.owner_id, eso.owner_name, em.display_name
--select count(*)
from dibots_v2.equity_security_owner eso, dibots_v2.entity_master em
where eso.security_owner_type = 'INST' and em.entity_type = 'COMP_INST' and eso.owner_id = em.dbt_entity_id and eso.owner_name <> em.display_name;


update dibots_v2.equity_security_owner eso
set
owner_name = em.display_name,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.entity_master em
where eso.security_owner_type = 'INST' and em.entity_type = 'COMP_INST' and eso.owner_id = em.dbt_entity_id and eso.owner_name <> em.display_name;


-- those empty inst names

select count(*) from dibots_v2.equity_security_owner where owner_id is null and security_owner_type = 'INST'

select count(*) from dibots_v2.equity_security_owner where owner_name is null and security_owner_type = 'INST'

select eso.id, eso.wvb_owner_id, eso.owner_id, eso.owner_name, ip.dbt_entity_id, ip.institution_name, ip.reported_institution_name
from dibots_v2.equity_security_owner eso, dibots_v2.institution_profile ip
where eso.security_owner_type = 'INST' and eso.wvb_owner_id = ip.wvb_institution_id and eso.owner_id is null;

update dibots_v2.equity_security_owner eso
set
owner_id = ip.dbt_entity_id,
owner_name = ip.institution_name,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.institution_profile ip
where eso.security_owner_type = 'INST' and eso.wvb_owner_id = ip.wvb_institution_id and eso.owner_id is null;

select count(*) from dibots_v2.equity_security_owner where modified_dtime::date = '2021-04-07' and modified_by = 'kangwei';