--Sample window function
select f.wvb_hdr_id, f.dbt_entity_id, f.fiscal_period_end_date, now(), 'jeremy' from (
select * from (
select row_number() over (partition by dbt_entity_id, fiscal_period_end_date order by ranking asc), * 
from (select COALESCE((select hierarchy from dibots_v2.ref_report_type_hierarchy b where a.report_type = b.report_type), 999) ranking,* from dibots_v2.data_hdr a
WHERE a.periodicity = 'A' AND extract(year from fiscal_period_end_date) >= 2010 and a.report_type in (select c.report_type from dibots_v2.ref_report_type_hierarchy c where for_analyst=true)) with_ranking
) tmp2 WHERE row_number = 1
)  f left outer join dibots_v2.analyst_hdr_view g on f.dbt_entity_id = g.dbt_entity_id and f.fiscal_period_end_date = g.fiscal_period_end_date
where g.dbt_entity_id is null;


--soft delete those row_number != 1
update dibots_v2.company_person_role
set deleted = true
where id in (
select id from (
select row_number() over (partition by company_id, person_id, role_type, eff_from_date order by id asc) as row_number, *
from dibots_v2.company_person_role ou) tmp
where row_number <> 1);

-- First get those eff_end_date not null
update dibots_v2.company_person_role
set deleted = true
where id in (
select id from (
select row_number() over (partition by company_id, person_id, role_type, eff_from_date, eff_end_date order by id desc) as row_number, *
from dibots_v2.company_person_role ou
where eff_end_date is not null) tmp
where row_number <> 1);

-- second get those eff_end_date null
update dibots_v2.company_person_role
set deleted = true
where id in (
select id from (
select row_number() over (partition by company_id, person_id, role_type, eff_from_date, eff_end_date order by id desc) as row_number, *
from dibots_v2.company_person_role ou
where deleted = false) tmp
where row_number <> 1);

-- third without eff_end_date
update dibots_v2.company_person_role
set deleted = true
where id in (
select id from (
select row_number() over (partition by company_id, person_id, role_type, eff_from_date order by id desc) as row_number, *
from dibots_v2.company_person_role ou
where deleted = false) tmp