-- The data insertion script in in pentaho, refer to adhoc/refer_to_mk_fix.ktr

drop table if exists tmp_refer_mk;
create table tmp_refer_mk (
id serial primary key,
dbt_entity_id uuid,
external_id int,
wvb_person_id int,
display_name varchar(255),
entity_type varchar(255),
dbt_mk varchar(255),
dob int,
mob int,
yob int,
dob_ic int,
mob_ic int,
yob_ic int,
dob_matched bool default false,
refer_to uuid,
refer_ext_id int,
refer_wvb_person_id int,
refer_to_display_name varchar(255),
refer_to_mk varchar(255),
refer_dob int,
refer_mob int,
refer_yob int,
r_dob_ic int,
r_mob_ic int,
r_yob_ic int,
r_dob_matched bool default false
);

select * from tmp_refer_mk where refer_to_mk is null

select * from tmp_refer_mk where dob_ic is not null

select count(*) from tmp_refer_mk where dbt_mk = refer_to_mk --and (dob_matched = false or r_dob_matched = false)

select count(*) from tmp_refer_mk

-- insert those absolutely sure records into entity_identifier
select refer_to from tmp_refer_mk where dbt_mk is not null and refer_to_mk is null 
group by refer_to having count(*) = 1

insert into dibots_v2.entity_identifier (dbt_entity_id, identifier_type, identifier, data_type, eff_from_date, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by)
select refer_to, 'MK', dbt_mk, 'string', '1900-01-01'::date, 1, now(), now(), 'kangwei' from tmp_refer_mk where refer_to in (
select refer_to from tmp_refer_mk where dbt_mk is not null and refer_to_mk is null
group by refer_to having count(*) = 1) 

-- master no IC but conflicting IC from children
select dbt_entity_id, external_id, display_name, dbt_mk, dob, mob, yob, refer_to, refer_ext_id, refer_to_display_name, refer_to_mk, refer_dob, refer_mob, refer_yob
from tmp_refer_mk
where refer_to_mk is null and dbt_mk is not null
order by refer_ext_id

-- both master and child has IC but conflicting
select dbt_entity_id, external_id, display_name, dbt_mk, dob, mob, yob, refer_to, refer_ext_id, refer_to_display_name, refer_to_mk, refer_dob, refer_mob, refer_yob
from tmp_refer_mk
where refer_to_mk <> dbt_mk
order by refer_ext_id
