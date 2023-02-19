select * from roc1

select count(*) from roc1

--======================
-- duplication removal
--======================

alter table roc1 add column id serial;

--alter table roc1 drop column id;

-- 248 distinct company
select count(distinct(vchcompanyno)) from roc1

-- getting the count of duplication for each vchcompanyno
select vchcompanyno, min(id), count(*) from roc1 
group by vchcompanyno having count(*) > 1

-- hard delete the records -> run the above count query again -> repeat till the above query no output
delete from roc1 where id in (select min(id) from roc1 
group by vchcompanyno having count(*) > 1)

--==================================
--flag for the existence in the db
--==================================

alter table roc1 add column exist_in_db bool default false;

-- using the roc_no column
select * from roc1 a, dibots_v2.entity_identifier ei 
where btrim(regexp_replace(a.roc_no,  ' ', '', 'g')) = btrim(regexp_replace(ei.identifier, ' ', '', 'g')) and ei.identifier_type = 'REGIST' and ei.deleted = false

update roc1 a
set
exist_in_db = true
from dibots_v2.entity_identifier ei
where btrim(regexp_replace(a.roc_no,  ' ', '', 'g')) = btrim(regexp_replace(ei.identifier, ' ', '', 'g')) and identifier_type = 'REGIST' and ei.deleted = false;

select * from roc1 where exist_in_db = false

-- for those that cannot get a match with roc_no, use vchcompanyno
-- none match though....
select * from roc1 a, dibots_v2.entity_identifier ei 
where btrim(vchcompanyno) = btrim(ei.identifier) and identifier_type in ('REGIST', 'REGISTMA') and ei.deleted = false --and a.exist_in_db = false

update roc1 a
set
exist_in_db = true
from dibots_v2.entity_identifier ei 
where btrim(vchcompanyno) = btrim(ei.identifier) and identifier_type in ('REGIST', 'REGISTMA') and ei.deleted = false --and a.exist_in_db = false;



-- Question: with the new roc or vchcompanyno, how many matches?
-- 51 not match if use vchcompanyno
select * from roc1 a
left join dibots_v2.entity_identifier ei 
on btrim(vchcompanyno) = btrim(ei.identifier) and identifier_type in ('REGIST', 'REGISTMA') and ei.deleted = false 
where ei.id is null

-- 220 matches with duplicate, because entity_identifier has duplicate
select * from roc1 a, dibots_v2.entity_identifier ei
where btrim(a.vchcompanyno) = btrim(ei.identifier) and ei.identifier_type in ('REGIST', 'REGISTMA') and ei.deleted = false 


select * from roc1 where exist_db_old is true

update roc1 a 
set 
exist_db_old = true 

select * 
from roc1 a, dibots_v2.entity_identifier ei 
where btrim(regexp_replace(a.roc_no, ' ', '', 'g')) = btrim(regexp_replace(ei.identifier, ' ', '', 'g')) and identifier_type = 'REGIST' and ei.deleted = false 
and ei.eff_from_date <= a.document_date - INTERVAL '3 years' and exist_in_db = true

