-- Some columns in person_profile has whitespace in the columns

update dibots_v2.person_profile
set
first_name = null,
modified_dtime = now()
where trim(first_name) = '';

update dibots_v2.person_profile
set
last_name = null,
modified_dtime = now()
where trim(last_name) = '';

update dibots_v2.person_profile
set
middle_initial_or_name = null,
modified_dtime = now()
where trim(middle_initial_or_name) = '';

update dibots_v2.person_profile
set
fullname = null,
modified_dtime = now()
where trim(fullname) = '';

update dibots_v2.person_profile
set
display_name = null,
modified_dtime = now()
where trim(display_name) = '';

update dibots_v2.person_profile
set
biography = null,
modified_dtime = now()
where trim(biography) = '';

update dibots_v2.person_profile
set
marital_status = null,
modified_dtime = now()
where trim(marital_status) = '';

update dibots_v2.person_profile
set
native_last_name = null,
modified_dtime = now()
where trim(native_last_name) = '';

update dibots_v2.person_profile
set
native_first_name = null,
modified_dtime = now()
where trim(native_first_name) = '';

update dibots_v2.person_profile
set
native_middle_initial_or_name = null,
modified_dtime = now()
where trim(native_middle_initial_or_name) = '';

update dibots_v2.person_profile
set
native_name_prefix = null,
modified_dtime = now()
where trim(native_name_prefix) = '';

update dibots_v2.person_profile
set
native_name_suffix = null,
modified_dtime = now()
where trim(native_name_suffix) = '';

update dibots_v2.person_profile
set
native_fullname = null,
modified_dtime = now()
where trim(native_fullname) = '';

update dibots_v2.person_profile
set
native_biography = null,
modified_dtime = now()
where trim(native_biography) = '';

update dibots_v2.person_profile
set
gender = null,
modified_dtime = now()
where trim(gender) = '';

update dibots_v2.person_profile
set
remarks = null,
modified_dtime = now()
where trim(remarks) = '';

update dibots_v2.person_profile
set
remarks2 = null,
modified_dtime = now()
where trim(remarks2) = '';

update dibots_v2.person_profile
set
actual_name = null,
modified_dtime = now()
where trim(actual_name) = '';

update dibots_v2.person_profile
set
as_reported_name = null,
modified_dtime = now()
where trim(as_reported_name) = '';

--===================
-- entity_master
--===================

update dibots_v2.entity_master 
set
name = null,
modified_dtime = now()
where trim(name) = '';

update dibots_v2.entity_master 
set
native_name = null,
modified_dtime = now()
where trim(native_name) = '';

update dibots_v2.entity_master 
set
display_name = null,
modified_dtime = now()
where trim(display_name) = '';
