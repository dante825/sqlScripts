--=============================
-- FIXING refer_to of refer_to
--=============================

select count(*) from dibots_v2.entity_master where refer_to is not null;

create table em_refer_to (
dbt_entity_id uuid,
refer_to1 uuid,
refer_to2 uuid,
refer_to3 uuid
);

insert into em_refer_to (dbt_entity_id, refer_to1)
select dbt_entity_id, refer_to from dibots_v2.entity_master where refer_to is not null;

select count(*) from em_refer_to

update em_refer_to a
set
refer_to3 = em.refer_to
from dibots_v2.entity_master em
where a.refer_to2 = em.dbt_entity_id and em.refer_to is not null and em.refer_to <> a.refer_to2;

select * from em_refer_to where refer_to3 is not null

select count(*) from em_refer_to a, dibots_v2.entity_master em
where a.refer_to3 = em.dbt_entity_id and em.refer_to is not null and em.refer_to <> a.refer_to3;

select * from dibots_v2.entity_master where dbt_entity_id = '91fca3ed-6de8-4524-8efe-cd84473ee9fc'


--================================================
-- UPDATING entity_master with the final refer_to
--================================================

-- when refer_to3 is not null
select * from em_refer_to where refer_to3 is not null;

select * from dibots_v2.entity_master where dbt_entity_id in ('2b336667-fa56-4e99-aa50-91c85da67414', 'dc26ff6c-9900-4c9d-a1e3-30d10471b8b9', 
'09f40f39-2d14-4ea5-a82e-d443b601aa49', '91fca3ed-6de8-4524-8efe-cd84473ee9fc')

update dibots_v2.entity_master em
set 
refer_to = a.refer_to3,
modified_by = 'LKE',
modified_dtime = now()
from em_refer_to a
where em.dbt_entity_id = a.refer_to1 and a.refer_to3 is not null;

update dibots_v2.entity_master em
set 
refer_to = a.refer_to3,
modified_by = 'LKE',
modified_dtime = now()
from em_refer_to a
where em.dbt_entity_id = a.refer_to2 and a.refer_to3 is not null;

update dibots_v2.entity_master em
set 
refer_to = a.refer_to3,
modified_by = 'LKE',
modified_dtime = now()
from em_refer_to a
where em.dbt_entity_id = a.dbt_entity_id and a.refer_to3 is not null;

-- when refer_to2 is not null and refer_to3 is null

select * from em_refer_to where refer_to2 is not null and refer_to3 is null

select * from dibots_v2.entity_master where dbt_entity_id in ('4485b110-675d-4373-8455-955495b10ecd', '4b156928-ab36-433c-90c1-24a3d558149e', 'afec62e7-27d0-4537-9720-dd3b207a2aa1')

update dibots_v2.entity_master em
set
refer_to = a.refer_to2,
modified_by = 'LKE',
modified_dtime = now()
from em_refer_to a
where em.dbt_entity_id = a.dbt_entity_id and a.refer_to2 is not null and refer_to3 is null;



--======================
-- RECURSIVE CTE
--======================

with recursive refer_to_cte (dbt_entity_id, refer_to) 
as (
select dbt_entity_id, refer_to from dibots_v2.entity_master where refer_to is not null
union all
select a.dbt_entity_id, em.refer_to from dibots_v2.entity_master em
join refer_to_cte a
on a.refer_to = em.dbt_entity_id and em.refer_to is not null and a.refer_to <> em.refer_to
)select * from refer_to_cte

--insert into em_refer_to2 (dbt_entity_id, refer_to)
--select dbt_entity_id, refer_to from refer_to_cte;

create table em_refer_to2 (
dbt_entity_id uuid,
refer_to uuid
);

select count(*) from em_refer_to2

select count(*) from em_refer_to;

select * from em_refer_to where refer_to2 is not null

select * from em_refer_to2 where dbt_entity_id = '4485b110-675d-4373-8455-955495b10ecd'

select * from em_refer_to where dbt_entity_id = '4b156928-ab36-433c-90c1-24a3d558149e'