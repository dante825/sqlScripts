-- exchange_entitlement has records of entitlements for the same stock_code and same date but entitlement of different length
-- the shorter length entitlement should be soft deleted.

select stock_code, stock_name, ex_date, lodgement_date, min(length(entitlements)) from dibots_v2.exchange_entitlement
where is_deleted = false
group by stock_code, stock_name, ex_date, lodgement_date having count(*) > 1

-- A temporary table for the records with min_length in entitlements
drop table entitlement_dup;
create table entitlement_dup (
stock_code varchar,
stock_name varchar,
ex_date date,
lodgement_date date,
min_ent_len int
);

insert into entitlement_dup (stock_code, stock_name, ex_date, lodgement_date, min_ent_len)
select stock_code, stock_name, ex_date, lodgement_date, min(length(entitlements)) from dibots_v2.exchange_entitlement
where is_deleted = false
group by stock_code, stock_name, ex_date, lodgement_date having count(*) > 1

select * from entitlement_dup


select * from dibots_v2.exchange_entitlement where stock_code = '9261' and ex_date = '2016-11-23' and lodgement_date = '2016-11-25' and is_deleted = false

select * from dibots_v2.exchange_entitlement where stock_code = '2186' and ex_date = '2018-12-12' and lodgement_date = '2018-12-14' and is_deleted = false

-- Join the entitlement table with the tmp table
select * from dibots_v2.exchange_entitlement ent, entitlement_dup tmp
where ent.stock_code = tmp.stock_code and ent.stock_name = tmp.stock_name and ent.ex_date = tmp.ex_date and ent.lodgement_date = tmp.lodgement_date and length(ent.entitlements) = tmp.min_ent_len

select count(*) from dibots_v2.exchange_entitlement where is_deleted = true;

update dibots_v2.exchange_entitlement 
set
is_deleted = true
where
id in 
(select id from dibots_v2.exchange_entitlement ent, entitlement_dup tmp
where ent.stock_code = tmp.stock_code and ent.stock_name = tmp.stock_name and ent.ex_date = tmp.ex_date and ent.lodgement_date = tmp.lodgement_date and length(ent.entitlements) = tmp.min_ent_len)

-- handle those with entitlement 'share exchange'
select * from dibots_v2.exchange_entitlement where lower(entitlements) = 'share exchange' and is_deleted = false

update dibots_v2.exchange_entitlement
set
is_deleted = true
where lower(entitlements) = 'share exchange' and is_deleted = false


select stock_code, stock_name, ex_date, min(length(entitlements)) from dibots_v2.exchange_entitlement
group by stock_code, stock_name, ex_date having count(*) > 1

alter table dibots_v2.exchange_entitlement add column is_deleted bool default false;

select length(entitlements) from dibots_v2.exchange_entitlement where stock_code = '2291' and stock_name = 'GENP' and ex_date = '2019-06-27'


-- delete the min id of the entitlement 

select min(id), stock_code, substring(entitlements, 0, 70), ex_date, count(*) from dibots_v2.exchange_entitlement 
where is_deleted = false
group by stock_code, substring(entitlements, 0, 70), ex_date having count(*) > 1

update dibots_v2.exchange_entitlement
set
is_deleted = true
where id in (select min(id) from dibots_v2.exchange_entitlement 
where is_deleted = false
group by stock_code, substring(entitlements, 0, 70), ex_date having count(*) > 1)