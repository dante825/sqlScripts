-- Fixing the pct_of_shares column in equity_security_owner
-- The pct of shares show as 9999, 1, 100, may not be accurate, try to calculate that from the nbr_of_shares column

-- Add a column for the custom_pct_of_shares
alter table dibots_v2.equity_security_owner add column calc_pct_of_shares numeric(26,6), add column calc_pct_of_votes numeric(26,6);

-- a reset from wvb_clone
select * from dibots_v2.equity_security_owner eqo, wvb_clone.equity_security_owner clone
where eqo.wvb_owner_id = clone.owner_perm_id and eqo.wvb_equity_id = clone.equity_sec_perm_id and eqo.security_owner_type = clone.security_owner_type and eqo.eff_from_date = clone.eff_from_date::date
--and eqo.eff_thru_date <> clone.eff_thru_date::date

update dibots_v2.equity_security_owner eqo
set
eff_thru_date = clone.eff_thru_date::date,
modified_by = 'kangwei',
modified_dtime = now()
from wvb_clone.equity_security_owner clone
where eqo.wvb_owner_id = clone.owner_perm_id and eqo.wvb_equity_id = clone.equity_sec_perm_id and eqo.security_owner_type = clone.security_owner_type and eqo.eff_from_date = clone.eff_from_date::date


-- Might have some problem on some records where owner is duplicated but with different eff_from_date
-- when wvb_equity_id is the same
select owner_id, company_id, security_owner_type, wvb_equity_id from dibots_v2.equity_security_owner
where eff_thru_date is null and is_deleted = false
group by owner_id, company_id, security_owner_type, wvb_equity_id having count(owner_id) > 1 and count(distinct(owner_id)) = 1;

-- the solution is to set the old record eff_thru_date to the new record eff_from_date
select owner_id, company_id, security_owner_type, wvb_equity_id, min(eff_from_date) as min_from, max(eff_from_date) as max_from from dibots_v2.equity_security_owner
where eff_thru_date is null and is_deleted = false
group by owner_id, company_id, security_owner_type, wvb_equity_id having count(owner_id) > 1 and count(distinct(owner_id)) = 1;

select count(*) from dibots_v2.equity_security_owner where modified_by = 'kangwei' and modified_dtime::date = '2020-05-13'

select * from dibots_v2.equity_security_owner where owner_id = '0000f8bc-4e60-4040-82a8-233444053167' and company_id = '81f50d59-ad24-40d7-81fb-a7819d86f292' and security_owner_type = 'PERSON' and wvb_equity_id = 10424153

select * from wvb_clone.equity_security_owner where equity_sec_perm_id = 10424153

-- for the situation where there is same owner_id, same company_id, same wvb_equity_id, different_eff_thru_date
update dibots_v2.equity_security_owner eqo
set 
eff_thru_date = res.max_from,
--is_deleted = true,
modified_by = 'kangwei',
modified_dtime = now()
from 
(select owner_id, company_id, security_owner_type, wvb_equity_id, min(eff_from_date) as min_from, max(eff_from_date) as max_from from dibots_v2.equity_security_owner
where eff_thru_date is null and is_deleted = false
group by owner_id, company_id, security_owner_type, wvb_equity_id having count(owner_id) > 1 and count(distinct(owner_id)) = 1) res
where eqo.owner_id = res.owner_id and eqo.company_id = res.company_id and eqo.security_owner_type = res.security_owner_type and eqo.wvb_equity_id = res.wvb_equity_id
and eqo.eff_from_date = res.min_from and eqo.eff_thru_date is null and eqo.is_deleted = false;

-- Situation with same owner_id, company_id, wvb_equity_id, security_owner_type, eff_from_date but different eff_thru_date
-- This situation arises after etl_lke
select owner_id, company_id, security_owner_type, wvb_equity_id, eff_from_date from dibots_v2.equity_security_owner
where is_deleted = false and owner_id is not null
group by owner_id, company_id, security_owner_type, wvb_equity_id, eff_from_date having count(*) > 1

select * from dibots_v2.equity_security_owner where owner_id = '0300eae3-1f8d-41f2-b144-3f836ee49f4d' and company_id = '9237e30d-5b92-4d79-8af8-5273e846e47a'

select * from dibots_v2.equity_security_owner where company_id = '9237e30d-5b92-4d79-8af8-5273e846e47a'

-- Solution would be to apply the eff_thru_date existed into the record without the eff_thru_date
select owner_id, company_id, security_owner_type, wvb_equity_id, eff_from_date, max(eff_thru_date) from dibots_v2.equity_security_owner
where is_deleted = false and owner_id is not null
group by owner_id, company_id, security_owner_type, wvb_equity_id, eff_from_date having count(*) > 1

update dibots_v2.equity_security_owner eqo
set
eff_thru_date = tmp.max_eff_thru_date,
modified_by = 'kangwei',
modified_dtime = now()
from
(select owner_id, company_id, security_owner_type, wvb_equity_id, eff_from_date, max(eff_thru_date) as max_eff_thru_date from dibots_v2.equity_security_owner
where is_deleted = false and owner_id is not null
group by owner_id, company_id, security_owner_type, wvb_equity_id, eff_from_date having count(*) > 1) tmp
where eqo.owner_id = tmp.owner_id and eqo.company_id = tmp.company_id and eqo.security_owner_type = tmp.security_owner_type and eqo.wvb_equity_id = tmp.wvb_equity_id and
eqo.eff_from_date = tmp.eff_from_date and eqo.eff_thru_date is null;

select count(*) from dibots_v2.equity_security_owner where modified_by = 'kangwei' and modified_dtime >= '2020-05-28 14:51'

-- get the total nbr_of_shares for each company
select company_id, sum(nbr_of_shares), sum(nbr_of_votes) from dibots_v2.equity_security_owner where eff_thru_date is null
group by company_id;

drop table eqsec_total_shares;
create table eqsec_total_shares (
company_id uuid primary key,
total_shares bigint,
total_votes bigint,
created_dtime timestamp,
created_by varchar
);

insert into eqsec_total_shares
select company_id, sum(nbr_of_shares), sum(nbr_of_votes), now(), 'kangwei' from dibots_v2.equity_security_owner where eff_thru_date is null and is_deleted = false and company_id is not null
group by company_id;

select count(*) from eqsec_total_shares;

select * from eqsec_total_shares;

select count(distinct(company_id)) from dibots_v2.equity_security_owner where eff_thru_date is null

-- TESTING
select * from eqsec_total_shares;

select eqo.company_id, eqo.owner_id, eqo.nbr_of_shares, eqs.total_shares, ((cast(eqo.nbr_of_shares as numeric)/cast(eqs.total_shares as numeric))*100) as pct_shares 
from dibots_v2.equity_security_owner eqo, eqsec_total_shares eqs
where eqo.eff_thru_date is null  and eqo.company_id = '67e442b9-7ed2-4af9-9d49-57b260d4764c' and eqo.company_id = eqs.company_id


-- Updating the calc_pct_of_shares
update dibots_v2.equity_security_owner eqo
set
calc_pct_of_shares = ((cast(eqo.nbr_of_shares as numeric)/cast(eqs.total_shares as numeric))*100),
modified_by = 'kangwei_calc',
modified_dtime = now()
from eqsec_total_shares eqs
where eqo.eff_thru_date is null and eqo.is_deleted = false 
and eqo.company_id = eqs.company_id and eqs.total_shares <> 0 and eqs.total_shares is not null;

-- update the calc_pct_of_votes
update dibots_v2.equity_security_owner eqo
set
calc_pct_of_votes  = ((cast(eqo.nbr_of_votes as numeric)/cast(eqs.total_votes as numeric))*100),
modified_by = 'kangwei',
modified_dtime = now()
from eqsec_total_shares eqs
where eqo.eff_thru_date is null and eqo.is_deleted = false 
and eqo.company_id = eqs.company_id and eqs.total_votes <> 0 and eqs.total_votes is not null;


--Verifying the pct calculated
select * from dibots_v2.equity_security_owner where eff_thru_date is null and modified_dtime is not null order by modified_dtime desc--modified_by = 'pentaho_calc'

select * from dibots_v2.equity_security_owner where modified_by = 'pentaho_calc'

select owner_id, security_owner_type, wvb_equity_id, company_id, eff_from_date, eff_thru_date, nbr_of_shares, pct_of_shares, calc_pct_of_shares, nbr_of_votes, pct_of_votes, calc_pct_of_votes
from dibots_v2.equity_security_owner where company_id = '0147f172-455b-4adb-8a5a-a885a56d6839' and eff_thru_date is null and is_deleted = false;

select * from eqsec_total_shares where company_id = 'e63da172-be55-47ef-9351-59101507f82b'

select * from dibots_v2.equity_security_owner where company_id = '0147f172-455b-4adb-8a5a-a885a56d6839' and eff_thru_date is null;

select sum(nbr_of_shares) from dibots_v2.equity_security_owner where eff_thru_date is null and is_deleted = false and company_id = '0147f172-455b-4adb-8a5a-a885a56d6839'


--===============================
--RESET THE PLC COMPANY PCT
--===============================

select * from dibots_v2.company_profile where comp_status_desc like 'PUBLIC%'

select count(*) from dibots_v2.equity_security_owner where modified_by = 'kangwei' and modified_dtime::date = '2020-06-27'

update dibots_v2.equity_security_owner eqo
set
calc_pct_of_shares = pct_of_shares,
modified_by = 'kangwei',
modified_dtime = now()
where eqo.company_id in (
select dbt_entity_id from dibots_v2.company_profile where comp_status_desc like 'PUBLIC%') and eqo.eff_thru_date is not null;

update dibots_v2.equity_security_owner eqo
set
calc_pct_of_shares = pct_of_shares,
modified_by = 'kangwei',
modified_dtime = now()
where eqo.company_id in (
select dbt_entity_id from dibots_v2.company_profile where comp_status_desc like '%PREVIOUSLY PUBLIC%') and eqo.eff_thru_date is not null;

select * from dibots_v2.company_profile where comp_status_desc LIKE '%PREVIOUSLY%'


--=================================
--set the has_owner_profile flag
--=================================

update dibots_v2.equity_security_owner eqo
set
has_owner_profile = true,
modified_by = 'kangwei',
modified_dtime = now()
where
eqo.security_owner_type in ('PERSON', 'CMPY')

select distinct(security_owner_type) from dibots_v2.equity_security_owner

select count(*) from dibots_v2.equity_security_owner where has_owner_profile = true

update dibots_v2.equity_security_owner eqo
set
has_owner_profile = true,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where eqo.owner_id = cp.dbt_entity_id and eqo.security_owner_type = 'INST' and cp.wvb_entity_type = 'COMP'



-- BACKUP THE TABLE before making the changes
CREATE TABLE "equity_security_owner_backup20200506"
(
   id bigint PRIMARY KEY NOT NULL,
   wvb_owner_id bigint NOT NULL,
   owner_id uuid,
   wvb_equity_id bigint NOT NULL,
   security_owner_type varchar(8),
   wvb_company_id bigint NOT NULL,
   company_id uuid,
   closely_held_flag varchar(1),
   eff_from_date date NOT NULL,
   eff_thru_date date,
   nbr_of_shares bigint,
   nbr_of_votes bigint,
   pct_of_shares numeric(32,20),
   pct_of_votes numeric(32,20),
   indirect_nbr_of_shares bigint,
   indirect_nbr_of_votes bigint,
   indirect_pct_of_shares numeric(32,20),
   indirect_pct_of_votes numeric(32,20),
   handling_code varchar(1),
   scaling_factor_exponent numeric(32,20),
   original_eff_from_date timestamp,
   is_deleted bool DEFAULT false,
   is_approved bool DEFAULT true,
   wvb_last_updated_dtime timestamp NOT NULL,
   created_dtime timestamp NOT NULL,
   created_by varchar(100) NOT NULL,
   modified_dtime timestamp,
   modified_by varchar(100)
);

insert into equity_security_owner_backup20200506
select * from dibots_v2.equity_security_owner;


-- some of the owner id is null
select count(*) from dibots_v2.equity_security_owner where owner_id is null;

select count(*) from dibots_v2.equity_security_owner where owner_id is null and security_owner_type = 'PERSON'

select count(*) from dibots_v2.equity_security_owner where owner_id is null and security_owner_type = 'CMPY'

select count(*) from dibots_v2.equity_security_owner where owner_id is null and security_owner_type = 'INST'

update dibots_v2.equity_security_owner eqo
set
owner_id = ei.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.entity_identifier ei
where ei.identifier = cast(eqo.wvb_owner_id as varchar) and eqo.security_owner_type = 'CMPY' and ei.identifier_type = 'WVBCOMP' and eqo.owner_id is null

update dibots_v2.equity_security_owner eqo
set
owner_id = pp.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.person_profile pp
where pp.wvb_person_id = eqo.wvb_owner_id and eqo.security_owner_type = 'PERSON' and pp.wvb_entity_type = 'PERS' and eqo.owner_id is null;

update dibots_v2.equity_security_owner eqo
set
owner_id = ip.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.institution_profile ip
where ip.wvb_institution_id = eqo.wvb_owner_id and eqo.security_owner_type = 'INST' and ip.institution_type = 'INST' and eqo.owner_id is null;


-- some of the company_id is null
update dibots_v2.equity_security_owner eqo
set
company_id = cp.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile cp
where eqo.wvb_company_id = cp.wvb_company_id and cp.wvb_entity_type = 'COMP' and eqo.company_id is null;


select * from dibots_v2.equity_security_owner eqo, dibots_v2.company_profile cp
where eqo.company_id is null and cp.wvb_company_id = eqo.wvb_company_id and cp.wvb_entity_type = 'COMP'

--revert it back from the backup
update dibots_v2.equity_security_owner eqo
set 
pct_of_shares = bak.pct_of_shares,
modified_dtime = now(),
modified_by = 'kangwei'
from equity_security_owner_backup20200506 bak
where eqo.id = bak.id;
