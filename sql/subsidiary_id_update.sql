-- Update the dibots_subsidiary_id in wvb_company_subsidiary
update dibots_v2.wvb_company_subsidiary compsub
set
dibots_subsidiary_id = res.target_uuid,
modified_by = 'kangwei',
modified_dtime = now()
from
(
select sub.id, sub.subsidiary_short_name, sub.dibots_subsidiary_id as target_uuid, tmp.id as target_id, tmp.subsidiary_short_name, tmp.dibots_subsidiary_id from dibots_v2.wvb_company_subsidiary sub
join
(select * from dibots_v2.wvb_company_subsidiary where subsidiary_id is null and dibots_subsidiary_id is null) tmp
on regexp_replace(sub.subsidiary_long_name, '[^A-Za-z0-9]', 'g') = regexp_replace(tmp.subsidiary_long_name, '[^A-Za-z0-9]', 'g')
where sub.dibots_subsidiary_id is not null) res
where compsub.id = res.target_id

update dibots_v2.wvb_company_subsidiary compsub
set
dibots_subsidiary_id = public.uuid_generate_v4(),
modified_by = 'kangwei',
modified_dtime = now()
where compsub.subsidiary_id is null and compsub.created_by = 'pentaho' and compsub.dibots_subsidiary_id is null;


-- From a clean slate where all dibots_subsidiary_id is null

--update dibots_v2.wvb_company_subsidiary
--set
--dibots_subsidiary_id = null

--drop table if exists tmp_wvb_company_subsidiary;
create table tmp_wvb_company_subsidiary (
id serial primary key,
short_name varchar,
country_iso_code varchar,
dibots_id uuid,
is_native boolean
)

insert into tmp_wvb_company_subsidiary (short_name, country_iso_code)
select distinct subsidiary_short_name, country_iso_code
from dibots_v2.wvb_company_subsidiary tmp 
where subsidiary_short_name is not null and country_iso_code <> 'UNK';

update tmp_wvb_company_subsidiary
set
dibots_id = public.uuid_generate_v4(),
is_native = false;

insert into tmp_wvb_company_subsidiary (short_name, country_iso_code)
select distinct native_subsidiary_short_name, country_iso_code
from dibots_v2.wvb_company_subsidiary tmp
where subsidiary_short_name is null and native_subsidiary_short_name is not null and country_iso_code <> 'UNK';

update tmp_wvb_company_subsidiary sub
set
dibots_id = public.uuid_generate_v4(),
is_native = true
where sub.dibots_id is null;

--truncate table tmp_wvb_company_subsidiary restart identity;

select * from dibots_v2.wvb_company_subsidiary sub, tmp_wvb_company_subsidiary tmp
where regexp_replace(sub.subsidiary_short_name, '[^A-Za-z0-9]', 'g') = regexp_replace(tmp.short_name, '[^A-Za-z0-9]', 'g') and sub.country_iso_code = tmp.country_iso_code
and sub.subsidiary_id is null and tmp.is_native = false;

-- join by subsidiary_short_name
update dibots_v2.wvb_company_subsidiary cmpsub
set
modified_dtime = now(),
modified_by = 'kangwei',
dibots_subsidiary_id = res.dibots_id
from
(select sub.id, sub.company_id, sub.wvb_company_id, sub.subsidiary_number, sub.subsidiary_id, sub.wvb_number_subsidiary, sub.subsidiary_short_name, sub.subsidiary_long_name, sub.country_iso_code, 
sub.dibots_subsidiary_id, tmp.short_name, tmp.country_iso_code, tmp.dibots_id
from dibots_v2.wvb_company_subsidiary sub, tmp_wvb_company_subsidiary tmp
where regexp_replace(sub.subsidiary_short_name, '[^A-Za-z0-9]', 'g') = regexp_replace(tmp.short_name, '[^A-Za-z0-9]', 'g') and sub.country_iso_code = tmp.country_iso_code
and sub.subsidiary_id is null and tmp.is_native = false) res
where cmpsub.id = res.id;


-- join by native_subsidiary_short_name
update dibots_v2.wvb_company_subsidiary cmpsub
set
modified_dtime = now(),
modified_by = 'kangwei',
dibots_subsidiary_id = res.dibots_id
from
(
select sub.id, sub.company_id, sub.wvb_company_id, sub.subsidiary_number, sub.subsidiary_id, sub.wvb_number_subsidiary, sub.subsidiary_short_name, sub.subsidiary_long_name, sub.native_subsidiary_short_name,
sub.native_subsidiary_long_name, sub.country_iso_code, sub.dibots_subsidiary_id, tmp.short_name, tmp.country_iso_code, tmp.dibots_id
from dibots_v2.wvb_company_subsidiary sub, tmp_wvb_company_subsidiary tmp
where sub.native_subsidiary_short_name = tmp.short_name and sub.country_iso_code = tmp.country_iso_code and sub.subsidiary_id is null and sub.dibots_subsidiary_id is null and tmp.is_native = true
) res
where cmpsub.id = res.id;

-- the remaining should be those with country_iso_code 'UNK', generate uuid for these
update dibots_v2.wvb_company_subsidiary cmpsub
set
modified_dtime = now(),
modified_by = 'kangwei',
dibots_subsidiary_id = public.uuid_generate_v4()
where
cmpsub.dibots_subsidiary_id is null and country_iso_code = 'UNK';

--============================
--subsidiary id based on name
--============================

select count(*) from dibots_v2.wvb_company_subsidiary where subsidiary_id is null;

select * from dibots_v2.wvb_company_subsidiary where subsidiary_id is null;

select * from dibots_v2.company_profile where company_name like 'CAE %'

select * from dibots_v2.wvb_company_subsidiary subs, dibots_v2.company_profile cp
where subs.subsidiary_short_name = cp.company_name and subs.subsidiary_id is null and cp.wvb_entity_type = 'COMP'

update dibots_v2.wvb_company_subsidiary subs
set
subsidiary_id = cp.dbt_entity_id,
wvb_number_subsidiary = cp.wvb_number,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where subs.subsidiary_short_name = cp.company_name and subs.subsidiary_id is null;

update dibots_v2.wvb_company_subsidiary subs
set
subsidiary_id = cp.dbt_entity_id,
wvb_number_subsidiary = cp.wvb_number,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where subs.subsidiary_long_name = cp.company_name and subs.subsidiary_id is null;

update dibots_v2.wvb_company_subsidiary subs
set
subsidiary_id = cp.dbt_entity_id,
wvb_number_subsidiary = cp.wvb_number,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where replace(lower(subs.subsidiary_long_name), '.', '') = replace(lower(cp.company_name), '.', '') and subs.subsidiary_id is null;

update dibots_v2.wvb_company_subsidiary subs
set
subsidiary_id = cp.dbt_entity_id,
wvb_number_subsidiary = cp.wvb_number,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where trim(replace(lower(subs.subsidiary_long_name), '.', ' ')) = trim(replace(lower(cp.company_name), '.', ' ')) and subs.subsidiary_id is null;

update dibots_v2.wvb_company_subsidiary subs
set
subsidiary_id = cp.dbt_entity_id,
wvb_number_subsidiary = cp.wvb_number,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where replace(lower(subs.subsidiary_short_name), '.', '') = replace(lower(cp.company_name), '.', '') and subs.subsidiary_id is null;

select * from dibots_v2.wvb_company_subsidiary where id = 1044342

select * from dibots_v2.company_profile where company_name = 'PGEO BIOTECH SDN BHD'