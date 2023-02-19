-- entity_mismatch between institution and company
--select ip.wvb_institution_id, ip.dbt_entity_id, ip.external_id, ip.institution_type, ip.reported_institution_name, cp.dbt_entity_id, cp.external_id, cp.wvb_company_id, cp.wvb_number, cp.company_name, cp.display_name

--================================
--company in institution_profile
--=================================

select count(*)
from dibots_v2.institution_profile ip, dibots_v2.company_profile cp
where ip.institution_name = cp.company_name and ip.institution_type <> 'COMPANY' and ip.country_of_incorporation = cp.country_of_incorporation;
-- count 30027

select * from dibots_v2.entity_master where dbt_entity_id in ('996ee03e-74c7-4cb9-8ac6-e1f8df88afcf', '5d889eee-2225-424a-b86f-75619ad60311');

create table inst_comp (
id serial primary key,
inst_entity_id uuid,
wvb_institution_id int,
inst_external_id int,
institution_name varchar(255),
institution_type varchar(10),
inst_country_of_incorporation varchar(5),
comp_entity_id uuid,
comp_external_id int,
wvb_company_id int, 
company_name varchar(255),
country_of_incorporation varchar(5),
is_deleted bool default false
);

insert into inst_comp (inst_entity_id, wvb_institution_id, inst_external_id, institution_name, institution_type, inst_country_of_incorporation, comp_entity_id, comp_external_id, wvb_company_id, company_name, country_of_incorporation)
select ip.dbt_entity_id, ip.wvb_institution_id, ip.external_id, ip.institution_name, ip.institution_type, ip.country_of_incorporation, cp.dbt_entity_id, cp.external_id, cp.wvb_company_id, cp.company_name, cp.country_of_incorporation
from dibots_v2.institution_profile ip, dibots_v2.company_profile cp
where ip.institution_name = cp.company_name and ip.institution_type <> 'COMPANY' and ip.country_of_incorporation = cp.country_of_incorporation;

select * from inst_comp;

create index inst_comp_inst_entity_id_idx on inst_comp (inst_entity_id);
create index inst_comp_comp_entity_id_idx on inst_comp (comp_entity_id);

-- there are some duplication within this table as well
select count(distinct(inst_entity_id)) from inst_comp;

select inst_entity_id, max(id), count(*) from inst_comp
where is_deleted = false
group by inst_entity_id having count(*) > 1

update inst_comp a
set is_deleted = true
from (select inst_entity_id, max(id) as max_id, count(*) as count from inst_comp 
where is_deleted = false
group by inst_entity_id having count(*) > 1) tmp
where a.id = tmp.max_id;

select count(*) from inst_comp where is_deleted = false


--Step 1: Change the institution type in institution_profile from INST to COMPANY
-- and the previous_dbt_entity_id. previous_external_id, previous_institution_type

update dibots_v2.institution_profile ip
set
institution_type = 'COMPANY',
previous_institution_type = tmp.institution_type,
previous_dbt_entity_id = tmp.inst_entity_id,
previous_external_id = tmp.inst_external_id,
modified_by = 'kangwei',
modified_dtime = now()
from inst_comp tmp
where ip.dbt_entity_id = tmp.inst_entity_id and ip.is_deleted = false;

-- Step 2: Update refer_to in entity_master, referring to the uuid of company
select * from dibots_v2.entity_master where dbt_entity_id in (select inst_entity_id from inst_comp where is_deleted = false)

update dibots_v2.entity_master em
set
refer_to = tmp.comp_entity_id,
is_deleted = true,
active = false,
do_not_index = true,
modified_dtime = now(),
modified_by = 'kangwei'
from inst_comp tmp
where em.dbt_entity_id = tmp.inst_entity_id and tmp.is_deleted = false;

select count(*) from dibots_v2.entity_master where modified_by = 'kangwei' and modified_dtime::date = '2020-06-23'

-- Step 3: change the dbt_entity_id in institution_profile

update dibots_v2.institution_profile ip
set
dbt_entity_id = tmp.comp_entity_id,
external_id = tmp.comp_external_id,
modified_by = 'kangwei',
modified_dtime = now()
from inst_comp tmp
where ip.dbt_entity_id = tmp.inst_entity_id and tmp.is_deleted = false;

select count(*) from dibots_v2.institution_profile where modified_by = 'kangwei' and modified_dtime > '2020-06-23 14:00:00'

select * from dibots_v2.institution_profile where modified_by = 'kangwei' and modified_dtime > '2020-06-23 14:00:00'

-- Step 4: Reflect the changes in the other tables
--query from jeremy;  once you updated the institution_profile and entity_master, run these query
update dibots_v2.entity_identifier a
set dbt_entity_id = b.dbt_entity_id,
modified_dtime = now(), modified_by = 'kangwei'
from dibots_v2.institution_profile b
where b.previous_dbt_entity_id = a.dbt_entity_id
and b.previous_dbt_entity_id is not null and b.propagated = false and b.modified_by = 'kangwei' and b.modified_dtime::date = '2020-06-23';

select * from dibots_v2.entity_identifier where modified_by = 'kangwei' and modified_dtime::date = '2020-06-23'

update dibots_v2.equity_security_owner a
set owner_id = b.dbt_entity_id,
modified_dtime = now(), modified_by = 'kangwei'
from dibots_v2.institution_profile b
where b.previous_dbt_entity_id = a.owner_id and a.security_owner_type = 'INST'
and b.previous_dbt_entity_id is not null and b.propagated = false and b.modified_by = 'kangwei' and b.modified_dtime::date = '2020-06-23';

select * from dibots_v2.equity_security_owner where modified_by = 'kangwei' and modified_dtime::date = '2020-06-23'

update dibots_v2.wvb_dir_dealing a
set dealer_id = b.dbt_entity_id,
modified_dtime = now(), modified_by = 'kangwei'
from dibots_v2.institution_profile b
where b.previous_dbt_entity_id = a.dealer_id and a.dealer_type = 'INST'
and b.previous_dbt_entity_id is not null and b.propagated = false and b.modified_by = 'kangwei' and b.modified_dtime::date = '2020-06-23';

select * from dibots_v2.wvb_dir_dealing where modified_by = 'kangwei' and modified_dtime::date = '2020-06-23'

--==========================
--same company name
--==========================
-- exact same name and same country in company_profile but not branch
select cp1.dbt_entity_id, cp1.external_id, cp1.company_name, cp1.company_type, cp1.country_of_incorporation, 
cp2.dbt_entity_id , cp2.external_id, cp2.company_name, cp2.company_type, cp2.country_of_incorporation
from dibots_v2.company_profile cp1, dibots_v2.company_profile cp2
where cp1.company_name = cp2.company_name and cp1.company_type <> 'BRANCHE' and cp2.company_type <> 'BRANCHE' and cp1.country_of_incorporation = cp2.country_of_incorporation
and cp1.dbt_entity_id <> cp2.dbt_entity_id




--==============================
-- company in person table
--=============================
select count(*) from wvb_clone.person where stat_note like '%ENTERPRI%' or STAT_NOTE like '%BHD%' or STAT_NOTE like '%LTD%' OR STAT_NOTE like '%bhd%' or STAT_NOTE like '%ltd%'

select * from dibots_v2.person_profile where wvb_person_id in (
select person_perm_id from wvb_clone.person where stat_note like '%ENTERPRI%' or STAT_NOTE like '%BHD%' or STAT_NOTE like '%LTD%' OR STAT_NOTE like '%bhd%' or STAT_NOTE like '%ltd%')

select * from dibots_v2.entity_master where dbt_entity_id = '45cd6d4d-8b1a-446a-a304-00e84e0be29a'

select * from dibots_v2.company_profile where company_name in (
select fullname from dibots_v2.person_profile where wvb_person_id in (
select person_perm_id from wvb_clone.person where stat_note like '%ENTERPRI%' or STAT_NOTE like '%BHD%' or STAT_NOTE like '%LTD%' OR STAT_NOTE like '%bhd%' or STAT_NOTE like '%ltd%')
and wvb_entity_type = 'PERS')

select * from dibots_v2.institution_profile where institution_name in (
select fullname from dibots_v2.person_profile where wvb_person_id in (
select person_perm_id from wvb_clone.person where stat_note like '%ENTERPRI%' or STAT_NOTE like '%BHD%' or STAT_NOTE like '%LTD%' OR STAT_NOTE like '%bhd%' or STAT_NOTE like '%ltd%')
and wvb_entity_type = 'PERS')

select * from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp 
where cpr.person_id = pp.dbt_entity_id and
cpr.role_type = 'SEC' and (pp.fullname like '%ENTERPRI%' or pp.fullname like '%BHD%' or pp.fullname like '%LTD%' OR pp.fullname like '%bhd%' or pp.fullname like '%ltd%')

select * from dibots_v2.company_profile where dbt_entity_id = '58a03812-1fdf-4de3-835b-bef580b0ccac'

select * from dibots_v2.institution_profile where dbt_entity_id = '58a03812-1fdf-4de3-835b-bef580b0ccac'

select ip.wvb_institution_id, ip.dbt_entity_id, ip.external_id, ip.institution_type, ip.reported_institution_name, cp.dbt_entity_id, cp.external_id, cp.wvb_company_id, cp.wvb_number, cp.company_name, cp.display_name
from dibots_v2.institution_profile ip, dibots_v2.company_profile cp
where ip.institution_name = cp.company_name and ip.institution_type <> 'COMPANY'