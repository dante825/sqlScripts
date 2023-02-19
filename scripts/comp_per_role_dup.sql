-- First, handle those duplicated that have eff_end_date is null
select company_id, person_id, role_type, eff_from_date, role_desc from dibots_v2.company_person_role where eff_end_date is null and deleted = false
group by company_id, person_id, role_type, eff_from_date, role_desc having count(id) > 1 

-- First handle those eff_end_date is null and has duplicates
-- Might have to run several times for those that have more than 2 duplicates
update dibots_v2.company_person_role
set
deleted = true, 
modified_by = 'kangwei',
modified_dtime = now()
where
id in (select min(id) from dibots_v2.company_person_role where eff_end_date is null and deleted = false group by company_id, person_id, role_type, eff_from_date, role_desc having count(*) > 1);

-- Second, check those deleted is false and eff_end_date is the same
select company_id, person_id, role_type, eff_from_date, eff_end_date, role_desc from dibots_v2.company_person_role where deleted = false
group by company_id, person_id, role_type, eff_from_date, eff_end_date, role_desc having count(id) > 1 

-- Might have to run several times for those that have more than 2 duplicates
update dibots_v2.company_person_role 
set
deleted = true, 
modified_by = 'kangwei',
modified_dtime = now()
where
id in (select min(id) from dibots_v2.company_person_role where deleted = false group by company_id, person_id, role_type, eff_from_date, eff_end_date, role_desc having count(*) > 1);


-- Third, check those now deleted is false and still have duplicates
-- DON'T RUN THIS FOR NOW
select company_id, person_id, role_type, eff_from_date, role_desc from dibots_v2.company_person_role where deleted = false
group by company_id, person_id, role_type, eff_from_date, role_desc having count(id) > 1 

update dibots_v2.company_person_role comp_per
set
deleted = true, 
modified_by = 'kangwei',
modified_dtime = now()
where id in 
(select id from dibots_v2.company_person_role cpr,
(select company_id, person_id, role_type, eff_from_date, role_desc from dibots_v2.company_person_role where deleted = false group by company_id, person_id, role_type, eff_from_date, role_desc having count(*) > 1) tmp
where cpr.company_id = tmp.company_id and cpr.person_id = tmp.person_id and cpr.role_type = tmp.role_type and cpr.role_desc = tmp.role_desc and eff_end_date is not null)

-- Fourth, eff_end_date = 1900-01-01 or eff_end_date < eff_from_date
select * from dibots_v2.company_person_role where eff_end_date = '1900-01-01'

select count(*) from dibots_v2.company_person_role where eff_end_date < eff_from_date

-- checking
select * from dibots_v2.company_person_role where company_id = '00073b4a-7dcf-4bdf-914f-d7532295e05f' and person_id = '71ca0790-bf8e-478c-a6e0-95f786cd201d' and role_type = 'DIR' and eff_from_date = '1996-03-28'
