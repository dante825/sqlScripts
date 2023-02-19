-- Pentaho transformation has errors, the company_id and person_id is incorrect
select cpr.company_id, cpr.person_id, cpr.wvb_company_person_id, ccpr.co_person_role_perm_id, cp.dbt_entity_id, pp.dbt_entity_id
from dibots_v2.company_person_role cpr, wvb_clone.company_person_role ccpr, dibots_v2.company_profile cp, dibots_v2.person_profile pp
where cpr.wvb_company_person_id = ccpr.co_person_role_perm_id and ccpr.company_perm_id = cp.wvb_company_id and cp.wvb_entity_type = 'COMP' and ccpr.person_perm_id = pp.wvb_person_id and pp.wvb_entity_type = 'PERS' and cpr.modified_by = 'pentaho'

update dibots_v2.company_person_role cpr
set
company_id = cp.dbt_entity_id,
person_id = pp.dbt_entity_id,
modified_dtime = now(),
modified_by = 'kangwei'
from wvb_clone.company_person_role ccpr, dibots_v2.company_profile cp, dibots_v2.person_profile pp
where cpr.wvb_company_person_id = ccpr.co_person_role_perm_id and ccpr.company_perm_id = cp.wvb_company_id and cp.wvb_entity_type = 'COMP' and ccpr.person_perm_id = pp.wvb_person_id and pp.wvb_entity_type = 'PERS' and cpr.modified_by = 'pentaho'


-- use left outer join to get the records that is in dibots_v2 but not in wvb_clone
select * from dibots_v2.company_person_role cpr
left outer join wvb_clone.company_person_role ccpr
on cpr.wvb_company_person_id = ccpr.co_person_role_perm_id
where ccpr.co_person_role_perm_id is null and deleted = false --and modified_by = 'pentaho'

-- soft delete those with wvb_company_person_id that is not in wvb_clone.company_person_role
update dibots_v2.company_person_role cpr
set
deleted = true,
modified_dtime = now(),
modified_by = 'kangwei'
where id in (
select id from dibots_v2.company_person_role cpr
left outer join wvb_clone.company_person_role ccpr
on cpr.wvb_company_person_id = ccpr.co_person_role_perm_id
where ccpr.co_person_role_perm_id is null and deleted = 'false' )--and modified_by = 'pentaho')
