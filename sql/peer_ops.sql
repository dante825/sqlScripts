--=========================
-- DIBOTS_USER_PREF peers
--=========================

create unique index user_company_peer_uniq on dibots_user_pref.user_company_peer (parent_id, company_id);

-- company_details_view
create or replace view dibots_user_pref.company_details_view
as select a.dbt_entity_id, a.external_id, a.display_name, b.stock_code, b.short_name 
from dibots_v2.company_profile a, dibots_v2.exchange_stock_profile b
where a.dbt_entity_id = b.stock_identifier and b.operating_mic = 'XKLS' and b.eff_end_date is null and b.delisted_date is null;

-- company_roc_view
create or replace view dibots_user_pref.company_roc_view as
select row_number() over() as id, a.dbt_entity_id, a.identifier as roc from dibots_v2.entity_identifier a, dibots_v2.exchange_stock_profile b where
a.dbt_entity_id = b.stock_identifier and b.eff_end_date is null and b.delisted_date is null and b.operating_mic = 'XKLS' and 
a.identifier_type in ('REGIST', 'REGISTMA');

-- stock_median_liquidity_view
create or replace view dibots_user_pref.stock_median_liquidity_view as
select row_number() over() as id, year, month, min_trading_date, max_trading_date, stock_code, stock_name, median_volume, shares_issued, free_float, criteria
from dibots_v2.exchange_stock_liquidity_median

select * from dibots_user_pref.stock_median_liquidity_view;

-- user_company_ir_pref

create table dibots_user_pref.user_company_ir_pref (
parent_id int primary key,
free_float numeric(19,2),
shares_issued bigint,
criteria numeric(18,3) default 0.04
);

select * from dibots_user_pref.user_company_ir_pref;


-- company_peer_current

-- a table to keep track of the current dates of the peer of a company
-- checking for count of eligible edits, get number of update_date > 3 months 
-- editing, would set the minimum updated_date to current date

create table dibots_user_pref.company_peer_current (
id serial primary key,
parent_id int,
updated_date date
);

--initial insert
insert into dibots_user_pref.company_peer_current (parent_id, updated_date)
select parent_id, created_dtime::date from dibots_user_pref.user_company_peer;

-- company_peer_historical

-- a table to keep track of the history of the edits
-- a write only table, shouldn't update the values in the table
-- status is either A or R, A = Added, R = Removed

create table dibots_user_pref.company_peer_historical (
id serial primary key,
parent_id int,
peer_company_id uuid,
updated_date date,
status varchar(2)
);

insert into dibots_user_pref.company_peer_historical (parent_id, peer_company_id, updated_date, status)
select parent_id, company_id, created_dtime::date, 'A' from dibots_user_pref.user_company_peer;

--==========================
-- generic steps to get info
--==========================

-- 1. get the user_id
select * from dibots_user_pref.user_detail where username = 'internal_uem_test2'

-- 2. use the user_id, role and comp_ext_id to get the serial id aka parent_id
select * from dibots_user_pref.user_company_link where user_role = 'IR' and user_id = '226757a4-ee48-45fd-9346-8a962fcf9181' and company_ext_id = 3650

-- 3. use the parent_id to get the peers
select * from dibots_user_pref.user_company_peer where parent_id = 5

--====================
-- steps to get count
--====================
-- details given by user: role IR, user_name, company_ext_id

-- 4. use the parent_id to get the count
select count(*) from dibots_user_pref.company_peer_current where parent_id = 5 and updated_date <= current_date - interval '3 months'

--=======================
-- steps to add a peer
--=======================
-- details provided by user: IR, user_name, company_ext_id, new_peer_company_ext_id (to be added)

-- 4. insert a new record into user_company_peer
insert into dibots_user_pref.user_company_peer (parent_id, company_id, company_ext_id, created_dtime, created_by)
values (5, <new comp uuid>, <new comp ext id>, now(), 'user-query-client')

-- 5. insert a new record into company_peer_current
insert into dibots_user_pref.company_peer_current (parent_id, updated_date)
values (5, current_date)

-- 6. insert a new record into company_peer_historical
insert into dibots_user_pref.company_peer_historical(parent_id, peer_company_id, updated_date, status)
values (5, <new comp uuid>, current_date, 'A')

select * from dibots_user_pref.company_peer_historical

select * from dibots_user_pref.user_company_link

select * from dibots_user_pref.user_company_peer where parent_id = 5

select * from dibots_user_pref.company_peer_current where parent_id = 5

select * from dibots_user_pref.company_peer_historical where parent_id = 5

CREATE SEQUENCE dibots_user_pref.company_peer_current_id_seq START WITH 1 INCREMENT BY 10;


--delete from dibots_user_pref.user_company_peer where parent_id = 5 and company_ext_id = 7320

--delete from dibots_user_pref.company_peer_current where parent_id = 5 and updated_date = '2021-04-08'

--delete from dibots_user_pref.company_peer_historical where parent_id = 5 and peer_company_id = 'f260318d-a1e4-425a-ae5b-15b609dba8a2'

create unique index user_company_peer_uniq on dibots_user_pref.user_company_peer (parent_id, company_id);

--update dibots_user_pref.company_peer_current 
set
updated_date = '2021-01-02'
where id = 9


select * from dibots_user_pref.company_details_view where (lower(stock_code) like 'pbb%' or lower(comp_name) like 'pbb%' or lower(stock_name) like 'pbb%')

create table dibots_user_pref.user_company_max_peer (
parent_id int primary key,
max_peer int default 8,
no_of_month int default 3
);

select * from dibots_user_pref.user_company_max_peer

--insert into dibots_user_pref.user_company_max_peer (parent_id) select id from dibots_user_pref.user_company_link;

select * from dibots_user_pref.user_company_link

--========================
-- steps to remove a peer
--========================

-- 4. remove from user_company_peer
-- 5. remove from company_peer_current
-- 6. remove from company_peer_historical


--========================
-- steps to edit a peer
--========================
-- details provided by user: IR, user_name, company_ext_id, peer_company_ext_id (to be removed), new_peer_company_ext_id (to be added)

