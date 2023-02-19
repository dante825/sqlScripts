-- etl_lke server script

-- preprocessing person_profle_lke columns
update dibots_v2.person_profile_lke
set
first_name = null
where trim(first_name) = '' and updated = false;

update dibots_v2.person_profile_lke
set
last_name = null
where trim(last_name) = '' and updated = false;

update dibots_v2.person_profile_lke
set
middle_initial_or_name = null
where trim(middle_initial_or_name) = '' and updated = false;

update dibots_v2.person_profile_lke
set
fullname = null
where trim(fullname) = '' and updated = false;

update dibots_v2.person_profile_lke
set
display_name = null
where trim(display_name) = '' and updated = false;

update dibots_v2.person_profile_lke
set
biography = null
where trim(biography) = '' and updated = false;

update dibots_v2.person_profile_lke
set
marital_status = null
where trim(marital_status) = '' and updated = false;

update dibots_v2.person_profile_lke
set
native_last_name = null
where trim(native_last_name) = '' and updated = false;

update dibots_v2.person_profile_lke
set
native_first_name = null
where trim(native_first_name) = '' and updated = false;

update dibots_v2.person_profile_lke
set
native_middle_initial_or_name = null
where trim(native_middle_initial_or_name) = '' and updated = false;

update dibots_v2.person_profile_lke
set
native_name_prefix = null
where trim(native_name_prefix) = '' and updated = false;

update dibots_v2.person_profile_lke
set
native_name_suffix = null
where trim(native_name_suffix) = '' and updated = false;

update dibots_v2.person_profile_lke
set
native_fullname = null
where trim(native_fullname) = '' and updated = false;

update dibots_v2.person_profile_lke
set
native_biography = null
where trim(native_biography) = '' and updated = false;

update dibots_v2.person_profile_lke
set
gender = null
where trim(gender) = '' and updated = false;

update dibots_v2.person_profile_lke
set
remarks = null
where trim(remarks) = '' and updated = false;

update dibots_v2.person_profile_lke
set
remarks2 = null
where trim(remarks2) = '' and updated = false;

update dibots_v2.person_profile_lke
set
actual_name = null
where trim(actual_name) = '' and updated = false;

update dibots_v2.person_profile_lke
set
as_reported_name = null
where trim(as_reported_name) = '' and updated = false;

-- Some person_mk has empty strings
update dibots_v2.person_profile_lke 
set
person_mk = null
where trim(person_mk) = '' and updated = false;

--==================
-- person_profile
--==================

-- update person_profile based on person_profile_lke
update dibots_v2.person_profile pp
set
first_name = a.first_name,
last_name = a.last_name,
middle_initial_or_name = a.middle_initial_or_name,
fullname = a.fullname,
display_name = a.display_name,
biography = a.biography,
marital_status = a.marital_status,
no_of_children = a.no_of_children,
native_last_name = a.native_last_name,
native_first_name = a.native_first_name,
native_middle_initial_or_name = a.native_middle_initial_or_name, 
native_name_prefix = a.native_name_prefix,
native_name_suffix = a.native_name_suffix,
native_fullname = a.native_fullname,
native_biography = a.native_biography,
gender = a.gender, 
year_of_birth = a.year_of_birth,
month_of_birth = a.month_of_birth,
day_of_birth = a.day_of_birth,
year_of_death = a.year_of_death,
month_of_death = a.month_of_death,
day_of_death = a.day_of_death,
active = (case when a.refer_to is not null then false when a.refer_to is null then true end),
wvb_handling_code = (case when a.refer_to is not null then 3 when a.refer_to is null then 2 end),
modified_by = 'LKE',
modified_dtime = now()
from dibots_v2.person_profile_lke a
where pp.dbt_entity_id = a.dbt_entity_id and a.updated = false;

--=================
-- entity_master
--=================

-- update entity_master based on person_profile_lke
update dibots_v2.entity_master em
set
name = a.fullname,
native_name = a.native_fullname,
display_name = a.display_name,
is_deleted = (case when a.refer_to is not null then true when a.refer_to is null then false end),
active = (case when a.refer_to is not null then false when a.refer_to is null then true end),
refer_to = a.refer_to,
wvb_handling_code = (case when a.refer_to is not null then 3 when a.refer_to is null then 2 end),
do_not_index = (case when a.refer_to is not null then true when a.refer_to is null then false end),
modified_by = 'LKE',
modified_dtime = now()
from dibots_v2.person_profile_lke a
where em.dbt_entity_id = a.dbt_entity_id and a.updated = false;

--=====================
-- entity_identifier
--=====================

-- update the entity_identifier if the MK stored is different from the one from LKE table
update dibots_v2.entity_identifier ei
set
identifier = a.person_mk,
modified_dtime = now(),
modified_by = 'LKE'
from dibots_v2.person_profile_lke a
where ei.dbt_entity_id = a.dbt_entity_id and ei.identifier_type = 'MK' and ei.deleted = false and a.updated = false
and a.person_mk is not null
and not exists (
select 1
from dibots_v2.entity_identifier e
where e.dbt_entity_id = a.dbt_entity_id
and e.identifier_type = 'MK'
and e.identifier = a.person_mk
);

update dibots_v2.entity_identifier ei
set
identifier = a.person_mk,
modified_dtime = now(),
modified_by = 'LKE'
from dibots_v2.person_profile_lke a
where ei.dbt_entity_id = a.refer_to and a.refer_to is not null and ei.identifier_type = 'MK' and ei.deleted = false and a.updated = false
and a.person_mk is not null
and not exists (
select 1
from dibots_v2.entity_identifier e
where e.dbt_entity_id = a.refer_to
and e.identifier_type = 'MK'
and e.identifier = a.person_mk
);

-- Insert into entity_identifier if possible
insert into dibots_v2.entity_identifier (dbt_entity_id, identifier_type, identifier, data_type, eff_from_date, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by, original_eff_from_date) 
select a.dbt_entity_id, 'MK', a.person_mk, 'string', '1900-01-01', 1, '1900-01-01 00:00:00.0', now(), 'LKE', '1900-01-01 00:00:00.0'
from dibots_v2.person_profile_lke a
where a.updated = false and a.person_mk is not null
and not exists (select 1 from dibots_v2.entity_identifier where dbt_entity_id = a.dbt_entity_id and identifier = a.person_mk and identifier_type = 'MK')
ON CONFLICT do nothing;

insert into dibots_v2.entity_identifier (dbt_entity_id, identifier_type, identifier, data_type, eff_from_date, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by, original_eff_from_date) 
select a.refer_to, 'MK', a.person_mk, 'string', '1900-01-01', 1, '1900-01-01 00:00:00.0', now(), 'LKE', '1900-01-01 00:00:00.0'
from dibots_v2.person_profile_lke a
where a.updated = false and a.person_mk is not null and a.refer_to is not null
and not exists (select 1 from dibots_v2.entity_identifier where dbt_entity_id = a.refer_to and identifier = a.person_mk and identifier_type = 'MK')
ON CONFLICT do nothing;


--===================
-- address_master
--===================

-- insert address to refer_to entity
insert into dibots_v2.address_master (dbt_entity_id, address_type, eff_from_date, address_line_1, address_line_2, address_line_3, address_line_4, raw_address, postcode, city, state, state_code, country,
native_address_line_1, native_address_line_2, native_address_line_3, native_address_line_4, native_city_name, created_dtime, created_by, wvb_handling_code, wvb_last_update_dtime, original_eff_from_date,
native_postal_code, native_state_province_code)
select b.refer_to, a.address_type, a.eff_from_date, a.address_line_1, a.address_line_2, a.address_line_3, a.address_line_4, a.raw_address, a.postcode, a.city, a.state, a.state_code, a.country,
a.native_address_line_1, a.native_address_line_2, a.native_address_line_3, a.native_address_line_4, a.native_city_name, now(), 'LKE', a.wvb_handling_code, '1900-01-01', '1900-01-01',
a.native_postal_code, a.native_state_province_code
from dibots_v2.address_master a, dibots_v2.person_profile_lke b
where a.dbt_entity_id = b.dbt_entity_id and b.refer_to is not null and b.updated = false and 
not exists (select 1 from dibots_v2.address_master 
where dbt_entity_id = b.refer_to and address_line_1 = a.address_line_1) ON CONFLICT DO NOTHING;


-- set the update flag to true
update dibots_v2.person_profile_lke a
set
updated = true,
updated_dtime = now()
where a.updated = false;

--========================
-- equity_security_owner
--========================

update dibots_v2.equity_security_owner eqo
set
owner_id = result.refer_to,
modified_by = 'etl_lke',
modified_dtime = now()
from
(select eq.id, em.refer_to from dibots_v2.equity_security_owner eq, dibots_v2.entity_master em
where em.modified_by = 'LKE' and em.is_deleted = true and em.dbt_entity_id = eq.owner_id and em.refer_to is not null) result 
where eqo.id = result.id;

-- owner_name
update dibots_v2.equity_security_owner eso
set
owner_name = pp.display_name,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.person_profile pp
where eso.security_owner_type = 'PERSON' and eso.owner_id = pp.dbt_entity_id and eso.owner_name <> pp.display_name;

update dibots_v2.equity_security_owner eso
set
owner_name = cp.display_name,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.company_profile cp
where eso.security_owner_type = 'CMPY' and eso.owner_id = cp.dbt_entity_id and eso.owner_name <> cp.display_name;

update dibots_v2.equity_security_owner eso
set
owner_name = em.display_name,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.entity_master em
where eso.security_owner_type = 'INST' and em.entity_type = 'COMP_INST' and eso.owner_id = em.dbt_entity_id and eso.owner_name <> em.display_name;

-- owner_nationality
--update dibots_v2.equity_security_owner eso
--set
--owner_nationality = pn.nationality,
--modified_by = 'etl_lke',
--modified_dtime = now()
--from dibots_v2.person_nationality pn
--where eso.owner_id = pn.dbt_entity_id and eso.security_owner_type = 'PERSON' and eso.owner_nationality <> pn.nationality and pn.is_deleted = false;

-- update dibots_v2.equity_security_owner eso
-- set
-- owner_nationality = cp.country_of_incorporation,
-- modified_by = 'etl_lke',
-- modified_dtime = now()
-- from dibots_v2.company_profile cp
-- where eso.owner_id = cp.dbt_entity_id and eso.security_owner_type = 'CMPY' and eso.owner_nationality <> cp.country_of_incorporation;

-- company_name
update dibots_v2.equity_security_owner eso
set
company_name = cp.display_name,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.company_profile cp
where eso.company_id = cp.dbt_entity_id and eso.company_name <> cp.display_name;

-- company_nationality
update dibots_v2.equity_security_owner eso
set
company_nationality = cp.country_of_incorporation,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.company_profile cp
where eso.company_id = cp.dbt_entity_id and eso.company_nationality <> cp.country_of_incorporation;

-- comp_status_desc
update dibots_v2.equity_security_owner eso
set
comp_status_desc = cp.comp_status_desc,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.company_profile cp
where eso.company_id = cp.dbt_entity_id and eso.comp_status_desc <> cp.comp_status_desc;


--==================
-- wvb_dir_dealing
--==================

update dibots_v2.wvb_dir_dealing dealing
set
dealer_id = result.refer_to,
modified_by = 'etl_lke',
modified_dtime = now()
from
(select deal.id, em.refer_to from dibots_v2.wvb_dir_dealing deal, dibots_v2.entity_master em
where deal.dealer_id = em.dbt_entity_id and em.modified_by = 'LKE' and em.is_deleted = true and em.refer_to is not null) result 
where dealing.id = result.id;

-- dealer_name in wvb_dir_dealing
update dibots_v2.wvb_dir_dealing dir
set
dealer_name = pp.display_name,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.person_profile pp
where dir.dealer_id = pp.dbt_entity_id and dir.dealer_name <> pp.display_name;

-- company_name
update dibots_v2.wvb_dir_dealing dir
set
company_name = cp.display_name,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.company_profile cp
where dir.company_id = cp.dbt_entity_id and dir.company_name <> cp.display_name;

-- company_nationality
update dibots_v2.wvb_dir_dealing dir
set
company_nationality = cp.country_of_incorporation,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.company_profile cp
where dir.company_id = cp.dbt_entity_id and dir.company_nationality <> cp.country_of_incorporation;

-- comp_status_desc
update dibots_v2.wvb_dir_dealing dir
set
comp_status_desc = cp.comp_status_desc,
modified_by = 'etl_lke',
modified_dtime = now()
from dibots_v2.company_profile cp
where dir.company_id = cp.dbt_entity_id and dir.comp_status_desc <> cp.comp_status_desc;

-- dealer_type (ENTITY_TYPE not the same spelling as DEALER TYPE) DON'T RUN THIS
update dibots_v2.wvb_dir_dealing a
set
dealer_type = b.entity_type,
modified_dtime = now(),
modified_by = 'etl_lke'
from dibots_v2.entity_master b
where a.dealer_id = b.dbt_entity_id and a.dealer_type <> b.entity_type;

--======================
-- company_person_role
--======================

update dibots_v2.company_person_role comperole
set
person_id = result.refer_to,
modified_by = 'etl_lke',
modified_dtime = now()
from
(
select cpr.id, em.refer_to from dibots_v2.company_person_role cpr, dibots_v2.entity_master em
where cpr.person_id = em.dbt_entity_id and em.modified_by = 'LKE' and em.is_deleted = true and em.refer_to is not null) result --and em.modified_dtime > '2020-04-10'
where comperole.id = result.id;

--==============================
-- company_person_role_sal_hdr
--==============================

update dibots_v2.company_person_role_sal_hdr sal_hdr
set
person_id = result.refer_to,
person_external_id = result.external_id,
modified_by = 'etl_lke',
modified_dtime = now()
from
(select sal.person_role_sal_hdr_perm_id, em.refer_to, em.external_id  from dibots_v2.company_person_role_sal_hdr sal, dibots_v2.entity_master em
where sal.person_id = em.dbt_entity_id and em.modified_by = 'LKE' and em.is_deleted = true and em.refer_to is not null) result
where result.person_role_sal_hdr_perm_id = sal_hdr.person_role_sal_hdr_perm_id;

--========================
-- person_relationship
--========================

update dibots_v2.person_relationship rel
set
dbt_entity_id = result.refer_to,
modified_by = 'etl_lke',
modified_dtime = now()
from
(select rel.dbt_entity_id, em.refer_to from dibots_v2.person_relationship rel, dibots_v2.entity_master em
where rel.dbt_entity_id = em.dbt_entity_id and em.modified_by = 'LKE' and em.is_deleted = true and em.refer_to is not null) result --and em.modified_dtime > '2020-04-10'
where rel.dbt_entity_id = result.dbt_entity_id
and not exists (
select 1
from dibots_v2.person_relationship pr
where pr.dbt_entity_id = result.refer_to
and pr.target_entity_id = rel.target_entity_id
and pr.relationship_type = rel.relationship_type
);

update dibots_v2.person_relationship rel
set
target_entity_id = result.refer_to,
modified_by = 'etl_lke',
modified_dtime = now()
from
(select rel.target_entity_id, em.refer_to from dibots_v2.person_relationship rel, dibots_v2.entity_master em
where rel.target_entity_id = em.dbt_entity_id and em.modified_by = 'LKE' and em.is_deleted = true and em.refer_to is not null) result --and em.modified_dtime > '2020-04-10'
where rel.target_entity_id = result.target_entity_id
and not exists (
select 1
from dibots_v2.person_relationship pr
where pr.dbt_entity_id = rel.dbt_entity_id
and pr.target_entity_id = result.refer_to
and pr.relationship_type = rel.relationship_type
);

--==============
-- entity_image
--==============

update dibots_v2.entity_image ei
set
dbt_entity_id = result.refer_to,
modified_by = 'etl_lke',
modified_dtime = now()
from
(select img.dbt_entity_id, em.refer_to from dibots_v2.entity_image img, dibots_v2.entity_master em
where img.dbt_entity_id = em.dbt_entity_id and em.modified_by = 'LKE' and em.is_deleted = true and em.refer_to is not null) result
where ei.dbt_entity_id = result.dbt_entity_id;

update dibots_v2.entity_image img
set
external_id = result.correct_ext,
modified_by = 'etl_lke',
modified_dtime = now()
from
(select ei.dbt_entity_id, ei.external_id, em.external_id as correct_ext from dibots_v2.entity_master em, dibots_v2.entity_image ei
where em.dbt_entity_id = ei.dbt_entity_id and em.external_id <> ei.external_id) result
where img.dbt_entity_id = result.dbt_entity_id;


--===============
-- checking if any refer_to is not reflected
--==============

-- checking if any refer_to in person_profile_lke not in entity_master
select * from 
(select * from dibots_v2.person_profile_lke where refer_to is not null and updated = true) a
left join 
(select * from dibots_v2.entity_master where refer_to is not null) b
on a.dbt_entity_id = b.dbt_entity_id 
where b.external_id is null;

-- check for refer_to of refer_to
select a.dbt_entity_id, a.display_name, a.refer_to, b.refer_to from dibots_v2.person_profile_lke a, dibots_v2.person_profile_lke b
where a.refer_to = b.dbt_entity_id and a.refer_to is not null and b.refer_to is not null and a.updated = true and b.updated = true;

select a.dbt_entity_id, a.refer_to, b.dbt_entity_id, b.refer_to from dibots_v2.entity_master a, dibots_v2.entity_master b
where a.refer_to = b.dbt_entity_id and a.refer_to is not null and b.refer_to is not null;

-- check for circular reference
select * from dibots_v2.person_profile_lke a, dibots_v2.person_profile_lke b
where a.refer_to = b.dbt_entity_id and a.refer_to is not null and b.refer_to is not null and b.refer_to = a.refer_to;

select * from dibots_v2.entity_master a, dibots_v2.entity_master b
where a.refer_to = b.dbt_entity_id and a.refer_to is not null and b.refer_to is not null and a.refer_to = b.refer_to;


--0
select count(*) from dibots_v2.person_profile_lke a, dibots_v2.company_person_role b
where a.dbt_entity_id = b.person_id and a.refer_to is not null and a.updated = true

select count(*) from dibots_v2.entity_master a, dibots_v2.company_person_role b
where a.dbt_entity_id = b.person_id and a.refer_to is not null

--0
select count(*) from dibots_v2.person_profile_lke a, dibots_v2.equity_security_owner b
where a.dbt_entity_id = b.owner_id and a.refer_to is not null and a.updated = true

select count(*) from dibots_v2.entity_master a, dibots_v2.equity_security_owner b
where a.dbt_entity_id = b.owner_id and a.refer_to is not null

-- 0
select count(*) from dibots_v2.person_profile_lke a, dibots_v2.wvb_dir_dealing b
where a.dbt_entity_id = b.dealer_id and a.refer_to is not null and a.updated = true

select count(*) from dibots_v2.entity_master a, dibots_v2.wvb_dir_dealing b
where a.dbt_entity_id = b.dealer_id and a.refer_to is not null

-- 0
select count(*) from dibots_v2.person_profile_lke a, dibots_v2.company_person_role_sal_hdr b
where a.dbt_entity_id = b.person_id and a.refer_to is not null and a.updated = true

select count(*) from dibots_v2.entity_master a, dibots_v2.company_person_role_sal_hdr b
where a.dbt_entity_id = b.person_id and a.refer_to is not null

--23
select count(*) from dibots_v2.person_profile_lke a, dibots_v2.person_relationship b
where a.dbt_entity_id = b.dbt_entity_id and a.refer_to is not null and a.updated = true

select count(*) from dibots_v2.entity_master a, dibots_v2.person_relationship b
where a.dbt_entity_id = b.dbt_entity_id and a.refer_to is not null

-- 11
select count(*) from dibots_v2.person_profile_lke a, dibots_v2.person_relationship b
where a.dbt_entity_id = b.target_entity_id and a.refer_to is not null and a.updated = true

select count(*) from dibots_v2.entity_master a, dibots_v2.person_relationship b
where a.dbt_entity_id = b.target_entity_id and a.refer_to is not null

-- 0
select count(*) from dibots_v2.person_profile_lke a, dibots_v2.entity_image b
where a.dbt_entity_id = b.dbt_entity_id and a.refer_to is not null and a.updated = true

select count(*) from dibots_v2.entity_master a, dibots_v2.entity_image b
where a.dbt_entity_id = b.dbt_entity_id and a.refer_to is not null

-- Some records in company_person_role_sal_hdr may have wrong person_id because KE changed these records personally (not refer_to)
select b.person_role_sal_hdr_perm_id, a.company_id, b.company_id, a.previous_person_id, b.person_id, a.person_id from 
(select * from dibots_v2.company_person_role where person_id <> previous_person_id) a
join dibots_v2.company_person_role_sal_hdr b
on a.company_id = b.company_id and a.previous_person_id = b.person_id;

select b.person_role_sal_hdr_perm_id, a.company_id, b.company_id, a.previous_person_id, b.person_id, a.person_id 
from dibots_v2.company_person_role a, dibots_v2.company_person_role_sal_hdr b
where a.person_id <> a.previous_person_id and a.company_id = b.company_id and a.previous_person_id = b.person_id;

update dibots_v2.company_person_role_sal_hdr a
set
person_id = b.person_id,
modified_dtime = now(),
modified_by = 'kangwei'
from dibots_v2.company_person_role b
where b.previous_person_id <> b.person_id and a.company_id = b.company_id and a.person_id = b.previous_person_id;

-- check if external_id in company_person_role_sal_hdr is correct
select em.dbt_entity_id, em.external_id from dibots_v2.entity_master em, dibots_v2.company_person_role_sal_hdr cpr
where em.dbt_entity_id = cpr.person_id and em.external_id <> cpr.person_external_id and em.entity_type = 'PERS'

update dibots_v2.company_person_role_sal_hdr sal
set
person_external_id = a.external_id,
modified_dtime = now(),
modified_by = 'etl_lke'
from (
select em.dbt_entity_id, em.external_id from dibots_v2.entity_master em, dibots_v2.company_person_role_sal_hdr cpr
where em.dbt_entity_id = cpr.person_id and em.external_id <> cpr.person_external_id and em.entity_type = 'PERS') a
where sal.person_id = a.dbt_entity_id;

-- check if entity_image external_id is correct
select ei.dbt_entity_id, ei.external_id, em.external_id as correct_ext from dibots_v2.entity_master em, dibots_v2.entity_image ei
where em.dbt_entity_id = ei.dbt_entity_id and em.external_id <> ei.external_id and em.entity_type = 'PERS'

update dibots_v2.entity_image img
set
external_id = result.correct_ext,
modified_by = 'etl_lke',
modified_dtime = now()
from
(select ei.dbt_entity_id, ei.external_id, em.external_id as correct_ext from dibots_v2.entity_master em, dibots_v2.entity_image ei
where em.dbt_entity_id = ei.dbt_entity_id and em.external_id <> ei.external_id and em.entity_type = 'PERS') result
where img.dbt_entity_id = result.dbt_entity_id;


-- check identifier
select a.dbt_entity_id, b.refer_to, a.identifier_type, a.identifier, b.person_mk, a.wvb_handling_code, a.deleted,b.updated, b.updated_dtime, a.modified_dtime, a.modified_by
from dibots_v2.entity_identifier a, dibots_v2.person_profile_lke b
where a.dbt_entity_id = b.dbt_entity_id and b.person_mk is not null and a.identifier_type = 'MK' 
and a.identifier = b.person_mk and (a.wvb_handling_code = 3 or a.deleted = true);

select * from 
(select * from dibots_v2.person_profile_lke where person_mk is not null) a
join dibots_v2.entity_identifier b
on a.dbt_entity_id = b.dbt_entity_id
where b.identifier_type = 'MK' and a.person_mk = b.identifier and (b.wvb_handling_code = 3 or b.deleted = true);

-- if all person_mk in person_profile_lke in entity_identifier
select * from
dibots_v2.person_profile_lke a left join dibots_v2.entity_identifier b
on a.dbt_entity_id = b.dbt_entity_id 
where a.person_mk is not null and b.id is null;

update dibots_v2.entity_identifier a
set
deleted = false,
wvb_handling_code = 2,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.person_profile_lke b
where a.dbt_entity_id = b.dbt_entity_id and b.person_mk is not null and a.identifier_type = 'MK' 
and a.identifier = b.person_mk and (a.wvb_handling_code = 3 or a.deleted = true);

-- duplicated IC
select max(id), dbt_entity_id, identifier, count(*) from dibots_v2.entity_identifier where identifier_type = 'MK' and deleted = false
group by dbt_entity_id, identifier having count(*) > 1

update dibots_v2.entity_identifier
set
deleted = true,
modified_dtime = now(),
modified_by = 'kangwei'
where id in (
select max(id) from dibots_v2.entity_identifier where identifier_type = 'MK' and deleted = false
group by dbt_entity_id, identifier having count(*) > 1);