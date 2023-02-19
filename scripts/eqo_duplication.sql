
-- equity_security_owner duplicates handling

-- case 1: same owner, company, equity, security_owner_type, eff_from_date and eff_thru_date is null
select owner_id, company_id, wvb_equity_id, security_owner_type, eff_from_date from dibots_v2.equity_security_owner
where is_deleted = false and owner_id is not null and eff_thru_date is null
group by owner_id, company_id, wvb_equity_id, security_owner_type, eff_from_date having count(*) > 1

update dibots_v2.equity_security_owner
set
is_deleted = true,
modified_by = 'kangwei',
modified_dtime = now()
where id in
(select min(id) from dibots_v2.equity_security_owner
where is_deleted = false and eff_thru_date is null
group by owner_id, company_id, wvb_equity_id, security_owner_type, eff_from_date having count(*) > 1)

-- case 2: same owner, company, equity, security_owner_type, eff_from_date, eff_thru_date
select owner_id, company_id, wvb_equity_id, security_owner_type, eff_from_date, eff_thru_date from dibots_v2.equity_security_owner
where is_deleted = false and owner_id is not null
group by owner_id, company_id, wvb_equity_id, security_owner_type, eff_from_date, eff_thru_date having count(*) > 1

update dibots_v2.equity_security_owner
set
is_deleted = true,
modified_by = 'kangwei',
modified_dtime = now()
where id in
(select min(id) from dibots_v2.equity_security_owner
where is_deleted = false and owner_id is not null
group by owner_id, company_id, wvb_equity_id, security_owner_type, eff_from_date, eff_thru_date having count(*) > 1)



select * from dibots_v2.equity_security_owner
where owner_id = '05b54a97-724e-44d7-8435-a40a248436ce' and company_id = 'd82a671a-7774-4b7f-9ec7-707be71d647b' and wvb_equity_id = 568203 and security_owner_type = 'PERSON' and eff_from_date = '2013-04-08'

select wvb_owner_id, wvb_company_id, wvb_equity_id, security_owner_type, eff_from_date from dibots_v2.equity_security_owner
where is_deleted = false and owner_id is not null
group by wvb_owner_id, wvb_company_id, wvb_equity_id, security_owner_type, eff_from_date having count(*) > 1




select * from dibots_v2.equity_security_owner where owner_id = '30b46567-0116-4a2d-a6af-e039f38dcb45' and company_id = '312c1914-e339-452c-b5eb-83279fcbc9eb' and wvb_equity_id = '10558527' 
and security_owner_type = 'INST' and eff_from_date = '2009-10-08'

select * from dibots_v2.equity_security_owner where owner_id = '00032f17-ac75-40b4-b438-251668461a6c' and company_id = '2349fe32-8bc3-4ffb-9831-423890749d2b' and wvb_equity_id = '10780990' 
and security_owner_type = 'INST' and eff_from_date = '2013-12-31'

select * from dibots_v2.equity_security_owner where owner_id = '00a90aa9-9808-44ac-b987-81ac01f69fa6' and company_id = '4baca4a8-ed47-4236-a80a-af097d9149b1' and wvb_equity_id = '981886' 
and security_owner_type = 'INST' and eff_from_date = '2019-03-31'


-- try to do jeremy's way but no id
select eqo.id from dibots_v2.equity_security_owner eqo, (select max(created_dtime) max_date, owner_id, company_id, wvb_equity_id, security_owner_type, original_eff_from_date::date from dibots_v2.equity_security_owner
group by owner_id, company_id, wvb_equity_id, security_owner_type, original_eff_from_date::date having count(*) > 1) a
where eqo.owner_id = a.owner_id and eqo.wvb_equity_id = a.wvb_equity_id and eqo.security_owner_type = a.security_owner_type and eqo.original_eff_from_date::date = a.original_eff_from_date::date and eqo.created_dtime <> a.max_date

-- sample from jeremy to fix the timestamp issue
delete from dibots_v2.address_master xx
using (select abc.id from dibots_v2.address_master abc, (select max(created_dtime) max_date, dbt_entity_id, address_type, original_eff_from_date::date from dibots_v2.address_master 
group by dbt_entity_id, address_type, original_eff_from_date::date having count(*) > 1) txt
where
abc.dbt_entity_id = txt.dbt_entity_id and
abc.address_type = txt.address_type and
abc.original_eff_from_date::date = txt.original_eff_from_date::date and
abc.created_dtime <> txt.max_date) tes
where
xx.id = tes.id

-- fix all the timestamp after deletion
update dibots_v2.company_std_ind_code
set original_eff_end_date = (original_eff_end_date::date || ' 00:00:00')::timestamp
where extract(hour from original_eff_end_date) <> 0


-- update some null owner_id field
select count(*) from dibots_v2.equity_security_owner where owner_id is null and security_owner_type = 'CMPY'

select count(*) from dibots_v2.equity_security_owner where owner_id is null and security_owner_type = 'PERSON'

update dibots_v2.equity_security_owner eqo
set
owner_id = pp.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.person_profile pp
where eqo.wvb_owner_id = pp.wvb_person_id and pp.wvb_entity_type = 'PERS' and eqo.security_owner_type = 'PERSON'
--and eqo.owner_id is null;

select count(*) from dibots_v2.equity_security_owner where owner_id is null and security_owner_type = 'INST'

update dibots_v2.equity_security_owner eqo
set
owner_id = inst.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.institution_profile inst
where eqo.wvb_owner_id = inst.wvb_institution_id
and eqo.security_owner_type = 'INST' --and eqo.owner_id is null;

select count(*) from dibots_v2.equity_security_owner where owner_id is null and security_owner_type = 'CMPY'

update dibots_v2.equity_security_owner eqo
set
owner_id = cp.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where eqo.wvb_owner_id = cp.wvb_company_id
and eqo.security_owner_type = 'CMPY' and cp.wvb_entity_type = 'COMP' --and eqo.owner_id is null;

select count(*) from dibots_v2.equity_security_owner where company_id is null;

update dibots_v2.equity_security_owner eqo
set
company_id = cp.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where eqo.wvb_company_id = cp.wvb_company_id and cp.wvb_entity_type = 'COMP'
and eqo.company_id is null;


--==========================
-- ID mismatch
--==========================

--checking institution
select * from dibots_v2.equity_security_owner eqo
left join dibots_v2.institution_profile ip
on eqo.wvb_owner_id = ip.wvb_institution_id
where eqo.security_owner_type = 'INST' and --ip.dbt_entity_id is null and owner_id is not null
eqo.owner_id <> ip.dbt_entity_id


--checking company
select * from dibots_v2.equity_security_owner eqo
left join dibots_v2.company_profile cp
on eqo.wvb_owner_id = cp.wvb_company_id
where eqo.security_owner_type = 'CMPY' and cp.dbt_entity_id is null and eqo.owner_id is not null 
--and cp.wvb_entity_type = 'COMP'
--and eqo.owner_id <> cp.dbt_entity_id

update dibots_v2.equity_security_owner eqo
set
owner_id = null,
modified_by = 'kangwei',
modified_dtime = now()
where eqo.id in (
select eqo.id from dibots_v2.equity_security_owner eqo
left join dibots_v2.company_profile cp
on eqo.wvb_owner_id = cp.wvb_company_id
where eqo.security_owner_type = 'CMPY' and cp.dbt_entity_id is null and eqo.owner_id is not null)

--checking person (leave this, this might be changed by the merging of person id)
select * from dibots_v2.equity_security_owner eqo
left join dibots_v2.person_profile pp
on eqo.wvb_owner_id = pp.wvb_person_id
where eqo.security_owner_type = 'PERSON' --and pp.dbt_entity_id is null and eqo.owner_id is not null
and pp.wvb_entity_type = 'PERS' and eqo.owner_id <> pp.dbt_entity_id

-- checking company_id
select * from dibots_v2.equity_security_owner eqo
left join dibots_v2.company_profile cp
on eqo.wvb_company_id = cp.wvb_company_id
where wvb_entity_type = 'COMP' and eqo.company_id <> cp.dbt_entity_id
--cp.dbt_entity_id is null and eqo.company_id is not null

select * from dibots_v2.equity_security_owner where modified_by = 'kangwei' and modified_dtime > '2020-06-26 20:00'


-- join with clone to check those missing in dibots_v2 and insert those records
INSERT INTO dibots_v2.equity_security_owner (wvb_owner_id, wvb_equity_id, security_owner_type, wvb_company_id, closely_held_flag, eff_from_date, eff_thru_date, 
nbr_of_shares, nbr_of_votes, pct_of_shares, pct_of_votes, indirect_nbr_of_shares, indirect_nbr_of_votes, indirect_pct_of_shares, indirect_pct_of_votes, handling_code,
original_eff_from_date, is_approved,  wvb_last_updated_dtime, created_dtime, created_by)
select clone.owner_perm_id, clone.equity_sec_perm_id, clone.security_owner_type, clone.company_perm_id_for_equity_sec, clone.closely_held_flag, clone.eff_from_date::date, clone.eff_thru_date::date, 
clone.nbr_of_shares, clone.nbr_of_votes, clone.pct_of_shares, clone.pct_of_votes, clone.indirect_nbr_of_shares, clone.indirect_nbr_of_votes, clone.indirect_pct_of_shares, clone.indirect_pct_of_votes, cast(clone.handling_code as int),
clone.eff_from_date, CASE WHEN clone.dtime_approved_for_prod is not null THEN true ELSE false END, GREATEST(clone.dtime_approved_for_prod, clone.dtime_entered, clone.dtime_last_changed), now(), 'kangwei'
from dibots_v2.equity_security_owner eso
right join wvb_clone.equity_security_owner clone
on eso.wvb_owner_id = clone.owner_perm_id and eso.wvb_equity_id = clone.equity_sec_perm_id and eso.security_owner_type = clone.security_owner_type and eso.original_eff_from_date = clone.eff_from_date
where eso.id is null and clone.company_perm_id_for_equity_sec is not null ON CONFLICT DO NOTHING;


select clone.owner_perm_id, clone.equity_sec_perm_id, clone.security_owner_type, clone.company_perm_id_for_equity_sec, clone.closely_held_flag, clone.eff_from_date::date, clone.eff_thru_date::date, 
clone.nbr_of_shares, clone.nbr_of_votes, clone.pct_of_shares, clone.pct_of_votes, clone.indirect_nbr_of_shares, clone.indirect_nbr_of_votes, clone.indirect_pct_of_shares, clone.indirect_pct_of_votes, cast(clone.handling_code as int),
clone.eff_from_date, CASE WHEN clone.dtime_approved_for_prod is not null THEN true ELSE false END, GREATEST(clone.dtime_approved_for_prod, clone.dtime_entered, clone.dtime_last_changed), now(), 'kangwei'
from dibots_v2.equity_security_owner eso
right join wvb_clone.equity_security_owner clone
on eso.wvb_owner_id = clone.owner_perm_id and eso.wvb_equity_id = clone.equity_sec_perm_id and eso.security_owner_type = clone.security_owner_type and eso.original_eff_from_date = clone.eff_from_date
where eso.id is null and clone.company_perm_id_for_equity_sec is not null

select * from wvb_clone.equity_security_owner clone where
owner_perm_id = 20081622 and equity_sec_perm_id = 3304182 and clone.security_owner_type = 'PERSON' and clone.eff_from_date='2015-12-31 00:00:00'

select * from dibots_v2.equity_security_owner where 
wvb_owner_id = 20081622 and wvb_equity_id = 3304182 and security_owner_type = 'PERSON' and original_eff_from_date='2015-12-31 00:00:00'

