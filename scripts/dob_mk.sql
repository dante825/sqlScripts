-- extract date of birth from ic number

drop table tmp_person_dob;
create table tmp_person_dob (
dbt_entity_id uuid,
external_id int,
display_name varchar(255),
year_of_birth int,
month_of_birth int,
day_of_birth int,
mk varchar,
mk_year int,
mk_month int,
mk_day int,
invalid bool default false,
mismatch bool default false,
year_str varchar(5),
month_str varchar(5),
day_str varchar(5)
);

insert into tmp_person_dob (dbt_entity_id, external_id, display_name, year_of_birth, month_of_birth, day_of_birth, mk)
select pp.dbt_entity_id, pp.external_id, pp.display_name, pp.year_of_birth, pp.month_of_birth, pp.day_of_birth, ei.identifier
from dibots_v2.entity_identifier ei, dibots_v2.person_profile pp 
where 
ei.dbt_entity_id = pp.dbt_entity_id and
ei.identifier_type = 'MK' and length(ei.identifier) = 12

-- extract the dob from mk into str fields
update tmp_person_dob
set
year_str = '19' || substring(mk from 1 for 2), 
month_str = ltrim(substring(mk from 3 for 2), '0'),
day_str = ltrim(substring(mk from 5 for 2), '0')

-- for cases where year is 20xx
update tmp_person_dob
set
year_str = '20' || substring(mk from 1 for 2)
where mk like '0%'

-- there are some invalid string
select * from tmp_person_dob where day_str = '';

update tmp_person_dob
set invalid = true
where month_str = '';

update tmp_person_dob
set invalid = true
where day_str = '';

select * from tmp_person_dob where mk like 'A%'

update tmp_person_dob
set invalid = true
where mk like 'A%';

select * from tmp_person_dob where mk like '''%'

update tmp_person_dob
set invalid = true
where mk like '''%'

-- cast the str fields into int
update tmp_person_dob
set
mk_year = cast(year_str as int), 
mk_month = cast(month_str as int),
mk_day = cast(day_str as int)
where invalid = false

-- find those that mismatch
update tmp_person_dob
set mismatch = true
where invalid = false  and year_of_birth <> mk_year

update tmp_person_dob
set mismatch = true
where invalid = false and month_of_birth <> mk_month 

update tmp_person_dob
set mismatch = true
where invalid = false and day_of_birth <> mk_day

-- LKE custom, set to not to update
select dbt_entity_id,count(*) from tmp_person_dob
group by dbt_entity_id having count(*) > 1

select * from tmp_person_dob where dbt_entity_id = '0e82d66f-7d41-4961-a3df-9f55695a172a'

update tmp_person_dob
set mismatch = false
where dbt_entity_id = '1fd50a81-765f-4ce3-adfe-a9bdb222fb2b' and mk = '730619145487'


-- which row should be updated
alter table tmp_person_dob add column update bool default false;

select * from tmp_person_dob where length(cast(year_of_birth as varchar)) < 4

select * from tmp_person_dob where mismatch = false and invalid = false --and year_of_birth <> mk_year

select count(*) from tmp_person_dob where mismatch = true

select * from tmp_person_dob where update = true

update tmp_person_dob
set
update = true
where length(cast(year_of_birth as varchar)) < 4 and mismatch = true and invalid = false;

select * from tmp_person_dob where mismatch = true and invalid = false and update = true

update tmp_person_dob
set
update = true
where year_of_birth is null and mk_year is not null and invalid = false;



-- output to LKE, need to be reviewed

alter table tmp_person_dob add column wvb_person_id int;

update tmp_person_dob a
set
wvb_person_id = pp.wvb_person_id
from dibots_v2.person_profile pp
where a.dbt_entity_id = pp.dbt_entity_id;

select dbt_entity_id, external_id, wvb_person_id, display_name, year_of_birth, month_of_birth, day_of_birth, mk, mk_year, mk_month, mk_day 
from tmp_person_dob where invalid = false and mismatch = true and update = false

select dbt_entity_id, external_id, wvb_person_id, display_name, year_of_birth, month_of_birth, day_of_birth, mk, mk_year, mk_month, mk_day 
from tmp_person_dob where invalid = false and year_of_birth <> mk_year and update = false

-- same year, diff month or day
select dbt_entity_id, external_id, wvb_person_id, display_name, year_of_birth, month_of_birth, day_of_birth, mk, mk_year, mk_month, mk_day 
from tmp_person_dob where invalid = false and year_of_birth = mk_year and (month_of_birth <> mk_month or day_of_birth <> mk_day) and update = false


select dbt_entity_id, external_id, wvb_person_id, display_name, year_of_birth, month_of_birth, day_of_birth, mk, mk_year, mk_month, mk_day 
from tmp_person_dob where invalid = false and (month_of_birth is null or day_of_birth is null) and update = false

-- diff year, same month and day
select dbt_entity_id, external_id, wvb_person_id, display_name, year_of_birth, month_of_birth, day_of_birth, mk, mk_year, mk_month, mk_day 
from tmp_person_dob where invalid = false and year_of_birth <> mk_year and month_of_birth = mk_month and day_of_birth = mk_day and update = false

-- diff year, month and day
select dbt_entity_id, external_id, wvb_person_id, display_name, year_of_birth, month_of_birth, day_of_birth, mk, mk_year, mk_month, mk_day 
from tmp_person_dob where invalid = false and year_of_birth <> mk_year and month_of_birth <> mk_month and day_of_birth <> mk_day and update = false

-- year month day null
select dbt_entity_id, external_id, wvb_person_id, display_name, year_of_birth, month_of_birth, day_of_birth, mk, mk_year, mk_month, mk_day 
from tmp_person_dob where invalid = false and year_of_birth is null and month_of_birth is null and day_of_birth is null and update = true


select * from tmp_person_dob where update = false and mismatch = true

-- a flag for those records that i updated
alter table tmp_person_dob add column updated bool default false;

select count(*) from tmp_person_dob where update = true

select * from dibots_v2.person_profile;

update dibots_v2.person_profile pp
set
year_of_birth = mk_year,
month_of_birth = mk_month,
day_of_birth = mk_day,
modified_by = 'LKE',
modified_dtime = now()
from tmp_person_dob b
where pp.dbt_entity_id = b.dbt_entity_id and b.update = true;

update tmp_person_dob
set
updated = true
where update = true;

select count(*) from dibots_v2.person_profile where modified_by = 'LKE' and modified_dtime::date = '2020-09-02'

select count(*) from tmp_person_dob where updated = true

select * from dibots_v2.person_profile pp, tmp_person_dob b
where pp.dbt_entity_id = b.dbt_entity_id and b.update = true


--==============================
-- 1 person multiple IC
--==============================

select dbt_entity_id from dibots_v2.entity_identifier where identifier_type = 'MK'
group by dbt_entity_id having count(*) > 1

select * from wvb_clone.person

select pp.dbt_entity_id, pp.external_id, pp.wvb_person_id, pp.display_name, ei.identifier, ei.created_by, ei.modified_by, wp.national_person_id
from dibots_v2.entity_identifier ei, dibots_v2.person_profile pp, wvb_clone.person_v2 wp
where ei.dbt_entity_id = pp.dbt_entity_id and pp.wvb_person_id = wp.person_perm_id and ei.identifier_type = 'MK'
and ei.dbt_entity_id in (select dbt_entity_id from dibots_v2.entity_identifier where identifier_type = 'MK' group by dbt_entity_id having count(*) > 1)

drop table tmp_person_dupli_ic;
create table tmp_person_dupli_ic (
dbt_entity_id uuid,
external_id int,
wvb_person_id int,
display_name varchar(255),
identifier varchar(20),
created_by varchar(20),
modified_by varchar(20),
national_person_id varchar(20),
delete bool default false
);

insert into tmp_person_dupli_ic 
select pp.dbt_entity_id, pp.external_id, pp.wvb_person_id, pp.display_name, ei.identifier, ei.created_by, ei.modified_by, wp.national_person_id
from dibots_v2.entity_identifier ei, dibots_v2.person_profile pp, wvb_clone.person_v2 wp
where ei.dbt_entity_id = pp.dbt_entity_id and pp.wvb_person_id = wp.person_perm_id and ei.identifier_type = 'MK'
and ei.dbt_entity_id in (select dbt_entity_id from dibots_v2.entity_identifier where identifier_type = 'MK' group by dbt_entity_id having count(*) > 1)


select * from tmp_person_dupli_ic where modified_by = 'LKE'

-- 18360
select count(*) from tmp_person_dupli_ic 

-- 9180
select dbt_entity_id, count(*) 
from tmp_person_dupli_ic 
group by dbt_entity_id having count(*) > 1

select * from tmp_person_dupli_ic where identifier <> national_person_id;

update tmp_person_dupli_ic
set delete = true
where identifier <> national_person_id;

update tmp_person_dupli_ic
set delete = false
where dbt_entity_id = '1fd50a81-765f-4ce3-adfe-a9bdb222fb2b' and identifier = '531005015539'

select * from tmp_person_dupli_ic where dbt_entity_id = '1fd50a81-765f-4ce3-adfe-a9bdb222fb2b'

select * from tmp_person_dupli_ic where delete = true

--delete from dibots_v2.entity_identifier b
--where b.id in (
select ei.id from dibots_v2.entity_identifier ei, tmp_person_dupli_ic a
where ei.dbt_entity_id = a.dbt_entity_id and ei.identifier = a.identifier and a.delete = true
