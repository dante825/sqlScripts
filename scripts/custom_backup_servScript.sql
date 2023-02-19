--create schema custom_backup;

--entity_master
update custom_backup.entity_master custom
set
name = em.name,
native_name = em.native_name,
display_name = em.display_name,
entity_type = em.entity_type,
is_deleted = em.is_deleted,
active = em.active,
wvb_handling_code = em.wvb_handling_code,
wvb_last_update_dtime = em.wvb_last_update_dtime,
do_not_index = em.do_not_index,
is_sanctioned = em.is_sanctioned,
modified_dtime = em.modified_dtime,
modified_by = em.modified_by,
refer_to = em.refer_to,
data_source_id = em.data_source_id
from dibots_v2.entity_master em
where custom.dbt_entity_id = em.dbt_entity_id and custom.modified_dtime <> em.modified_dtime and em.modified_by = 'LKE';

insert into custom_backup.entity_master
select * from dibots_v2.entity_master where created_by = 'LKE' or modified_by = 'LKE' ON CONFLICT DO NOTHING;

--person_profile
update custom_backup.person_profile cust
set
wvb_person_id = pp.wvb_person_id,
first_name = pp.first_name,
last_name = pp.last_name,
middle_initial_or_name = pp.middle_initial_or_name,
fullname = pp.fullname,
display_name = pp.display_name,
biography = pp.biography,
marital_status = pp.marital_status,
no_of_children = pp.no_of_children,
native_last_name = pp.native_last_name,
native_first_name = pp.native_first_name,
native_middle_initial_or_name = pp.native_middle_initial_or_name, 
native_name_prefix = pp.native_name_prefix,
native_name_suffix = pp.native_name_suffix,
native_fullname = pp.native_fullname,
native_biography = pp.native_biography,
gender = pp.gender,
year_of_birth = pp.year_of_birth,
month_of_birth = pp.month_of_birth,
day_of_birth = pp.day_of_birth,
year_of_death = pp.year_of_death,
month_of_death = pp.month_of_death,
day_of_death = pp.day_of_death,
remarks = pp.remarks,
is_pep = pp.is_pep,
is_sanctioned = pp.is_sanctioned,
active = pp.active,
modified_dtime = pp.modified_dtime,
modified_by = pp.modified_by,
wvb_handling_code = pp.wvb_handling_code,
data_source_id = pp.data_source_id,
remarks2 = pp.remarks2,
actual_name = pp.actual_name, 
wvb_entity_type = pp.wvb_entity_type,
as_reported_name = pp.as_reported_name
from dibots_v2.person_profile pp
where pp.dbt_entity_id = cust.dbt_entity_id and pp.modified_dtime <> cust.modified_dtime and pp.modified_by = 'LKE';

insert into custom_backup.person_profile
select * from dibots_v2.person_profile where created_by = 'LKE' or modified_by = 'LKE' ON CONFLICT DO NOTHING;

--equity_security_owner
insert into custom_backup.equity_security_owner
select * from dibots_v2.equity_security_owner where created_by = 'LKE' or modified_by = 'LKE' ON CONFLICT DO NOTHING;

--wvb_dir_dealing
insert into custom_backup.wvb_dir_dealing
select * from dibots_v2.wvb_dir_dealing where created_by = 'LKE' or modified_by = 'LKE' ON CONFLICT DO NOTHING;

--company_person_role
insert into custom_backup.company_person_role
select * from dibots_v2.company_person_role where created_by = 'LKE' or modified_by = 'LKE' ON CONFLICT DO NOTHING;

-- person_misc_info
insert into custom_backup.person_misc_info
select * from dibots_v2.person_misc_info where created_by = 'LKE' or modified_by = 'LKE' ON CONFLICT DO NOTHING;

--person_salutation
insert into custom_backup.person_salutation
select * from dibots_v2.person_salutation where created_by = 'LKE' or modified_by = 'LKE' ON CONFLICT DO NOTHING;
