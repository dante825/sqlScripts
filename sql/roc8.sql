--============================
-- import ROC 8 from WVB_CLONE
--============================

-- clone the table from wvb with pentaho, a 1 to 1 clone, no cleansing

select * from wvb_clone.roc8

select * from wvb_clone.roc8 where feeddate is null and filepath = 'FTP3 >/home/ftp/klssm/SSM/SSM_June2021.zip'

-- WVB didnt set the feeddate for this batch, update that
update wvb_clone.roc8
set
feeddate = '2021-06-16'
where filepath = 'FTP3 >/home/ftp/klssm/SSM/SSM_June2021.zip' and feeddate is null;

-- remove some invalid rows

select * from wvb_clone.roc8 where vchcompanyno is null

delete from wvb_clone.roc8 where vchcompanyno is null

select * from wvb_clone.roc8 where vchcompanyno like '%row%'

delete from wvb_clone.roc8 where vchcompanyno like '(16842 row(s) affected)'

select * from wvb_clone.roc8 where vchcompanyno = 'vchcompanyno'

delete from wvb_clone.roc8 where vchcompanyno = 'vchcompanyno'

-- some rows that need special attention

-- 7
select * from wvb_clone.roc8 where mnyauthorisedcapital like '%E%'

update wvb_clone.roc8
set
mnyauthorisedcapital = 100000000000000
where vchcompanyno = '993932' and filename = 'File1_21May2014_ROC8.csv';

update wvb_clone.roc8
set
mnyauthorisedcapital = 300000000000
where vchcompanyno = '993366' and filename = 'File1_21May2014_ROC8.csv';

update wvb_clone.roc8
set
mnyauthorisedcapital = 280000000000
where vchcompanyno = '993569' and filename = 'WVB File2_ROC8.csv';

update wvb_clone.roc8
set
mnyauthorisedcapital = 308000000000
where vchcompanyno = '994028' and filename = 'ROC8-SHARE CAPITAL.csv';

update wvb_clone.roc8
set
mnyauthorisedcapital = 169439000000
where vchcompanyno = '992365' and filename = 'ROC8-SHARE CAPITAL.csv';

update wvb_clone.roc8
set
mnyauthorisedcapital = 101050000000
where vchcompanyno = '706803' and filename = 'ROC8-SHARE CAPITAL.csv';

update wvb_clone.roc8
set
mnyauthorisedcapital = 2800000000000
where vchcompanyno = '993569' and filename = 'ROC8-SHARE CAPITAL.csv'

select * from wvb_clone.roc8 where vchcompanyno = '993569' and filename = 'ROC8-SHARE CAPITAL.csv'

-- 10
select * from wvb_clone.roc8 where intordnumberofshares like '%E%'

update wvb_clone.roc8
set
intordnumberofshares = 300000000000
where vchcompanyno = '8272' and filename = 'File1_21May2014_ROC8.csv';

update wvb_clone.roc8
set
intordnumberofshares = 4999910000000
where vchcompanyno = '3623' and filename = 'ROC8-SHARE CAPITAL.csv';

update wvb_clone.roc8
set
intordnumberofshares = 100000000000000
where vchcompanyno = '993932' and filename = 'File1_21May2014_ROC8.csv';

update wvb_clone.roc8
set
intordnumberofshares = 300000000000
where vchcompanyno = '993366' and filename = 'File1_21May2014_ROC8.csv';

update wvb_clone.roc8
set
intordnumberofshares = 557600000000
where vchcompanyno = '993569' and filename = 'WVB File2_ROC8.csv';

update wvb_clone.roc8
set
intordnumberofshares = 169439000000
where vchcompanyno = '992365' and filename = 'ROC8-SHARE CAPITAL.csv';

update wvb_clone.roc8
set
intordnumberofshares = 100000000000
where vchcompanyno = '706803' and filename = 'ROC8-SHARE CAPITAL.csv';

update wvb_clone.roc8
set
intordnumberofshares = 557600000000
where vchcompanyno = '993569' and filename = 'ROC8-SHARE CAPITAL.csv';

select * from wvb_clone.roc8 where vchcompanyno = '993569' and filename = 'ROC8-SHARE CAPITAL.csv'

-- 0
select * from wvb_clone.roc8 where mnyordnominalvalue like '%E%'

-- 4
select * from wvb_clone.roc8 where intprefnumberofshares like '%E%'

update wvb_clone.roc8
set
intprefnumberofshares = 100000000000
where vchcompanyno = '136570' and filename = 'WVB File2_ROC8.csv';

update wvb_clone.roc8
set
intprefnumberofshares = 100000000000
where vchcompanyno = '893349' and filename = 'WVB File2_ROC8.csv';

update wvb_clone.roc8
set
intprefnumberofshares = 105000000000
where vchcompanyno = '706803' and filename = 'ROC8-SHARE CAPITAL.csv';

select * from wvb_clone.roc8 where vchcompanyno = '706803' and filename = 'ROC8-SHARE CAPITAL.csv'

-- 0
select * from wvb_clone.roc8 where mnyprefnominalvalue like '%E%'

-- 0
select * from wvb_clone.roc8 where intothernumberofshares like '%E%'

-- 0
select * from wvb_clone.roc8 where mnyothernominalvalue like '%E%'

-- 5
select vchcompanyno, dblordissuedcash, filename from wvb_clone.roc8 where dblordissuedcash like '%E%'

update wvb_clone.roc8
set
dblordissuedcash = 107184000000
where vchcompanyno = '992337' and filename = 'WVB File2_ROC8.csv';

update wvb_clone.roc8
set
dblordissuedcash = 152450000000
where vchcompanyno = '994028' and filename = 'ROC8-SHARE CAPITAL.csv';

update wvb_clone.roc8
set
dblordissuedcash = 100000000000
where vchcompanyno = '993366' and filename = 'File1_21May2014_ROC8.csv';

select vchcompanyno, dblordissuedcash, filename from wvb_clone.roc8 where vchcompanyno = '993366' and filename = 'File1_21May2014_ROC8.csv';

-- 0
select * from wvb_clone.roc8 where dblordissuednoncash like '%E%'

-- 0
select * from wvb_clone.roc8 where mnyordissuednominal like '%E%'

-- 0
select * from wvb_clone.roc8 where dblprefissuedcash like '%E%'

-- 0
select * from wvb_clone.roc8 where dblprefissuednoncash like '%E%'

-- 0
select * from wvb_clone.roc8 where mnyprefissuednominal like '%E%'

-- 0
select * from wvb_clone.roc8 where dblotherissuedcash like '%E%'

-- 0
select * from wvb_clone.roc8 where dblotherissuednoncash like '%E%'

-- 0
select * from wvb_clone.roc8 where dblotherissuednominal like '%E%'


--===================
-- CLEANSE ROC8
--===================

--drop table tmp_roc8_cleansed;
create table tmp_roc8_cleansed (
id bigint generated by default as identity primary key,
company_no text,
dbt_entity_id uuid,
external_id bigint,
company_name text,
authorised_capital numeric(25,3),
ord_num_of_shares numeric(25,3),
ord_nominal_value numeric(25,3),
pref_num_of_shares numeric(25,3),
pref_nominal_value numeric(25,3),
other_num_of_shares numeric(25,3),
other_nominal_value numeric(25,3),
ord_issued_cash numeric(25,3),
ord_issued_non_cash numeric(25,3),
ord_issued_nominal numeric(25,3),
pref_issued_cash numeric(25,3),
pref_issued_non_cash numeric(25,3),
pref_issued_nominal numeric(25,3),
other_issued_cash numeric(25,3),
other_issued_non_cash numeric(25,3),
other_issued_nominal numeric(25,3),
filename text,
filepath text,
year int,
feed_date date,
deleted bool default false
);

select * from tmp_roc8_cleansed;

insert into tmp_roc8_cleansed (company_no, authorised_capital, ord_num_of_shares, ord_nominal_value, pref_num_of_shares, pref_nominal_value, other_num_of_shares, other_nominal_value, ord_issued_cash, ord_issued_non_cash, ord_issued_nominal,
pref_issued_cash, pref_issued_non_cash, pref_issued_nominal, other_issued_cash, other_issued_non_cash, other_issued_nominal, filename, filepath, year, feed_date)
select vchcompanyno, 
CASE WHEN upper(mnyauthorisedcapital) like '%NULL%' THEN null ELSE cast(mnyauthorisedcapital as numeric(25,3)) END, 
CASE WHEN upper(intordnumberofshares) like '%NULL%' THEN null ELSE cast(intordnumberofshares as numeric(25,3)) END, 
CASE WHEN upper(mnyordnominalvalue) like '%NULL%' THEN null ELSE cast(mnyordnominalvalue as numeric(25,3)) END, 
CASE WHEN upper(intprefnumberofshares) like '%NULL%' THEN null ELSE cast(intprefnumberofshares as numeric(25,3)) END, 
CASE WHEN upper(mnyprefnominalvalue) like '%NULL%' THEN null ELSE cast(mnyprefnominalvalue as numeric(25,3)) END, 
CASE WHEN upper(intothernumberofshares) like '%NULL%' THEN null ELSE cast(intothernumberofshares as numeric(25,3)) END, 
CASE WHEN upper(mnyothernominalvalue) like '%NULL%' THEN null ELSE cast(mnyothernominalvalue as numeric(25,3)) END,
CASE WHEN upper(dblordissuedcash) like '%NULL%' THEN null ELSE cast(dblordissuedcash as numeric(25,3)) END, 
CASE WHEN upper(dblordissuednoncash) like '%NULL%' THEN null ELSE cast(dblordissuednoncash as numeric(25,3)) END, 
CASE WHEN upper(mnyordissuednominal) like '%NULL%' THEN null ELSE cast(mnyordissuednominal as numeric(25,3)) END,
CASE WHEN upper(dblprefissuedcash) like '%NULL%' THEN null ELSE cast(dblprefissuedcash as numeric(25,3)) END,
CASE WHEN upper(dblprefissuednoncash) like '%NULL%' THEN null ELSE cast(dblprefissuednoncash as numeric(25,3)) END,
CASE WHEN upper(mnyprefissuednominal) like '%NULL%' THEN null ELSE cast(mnyprefissuednominal as numeric(25,3)) END,
CASE WHEN upper(dblotherissuedcash) like '%NULL%' THEN null ELSE cast(dblotherissuedcash as numeric(25,3)) END, 
CASE WHEN upper(dblotherissuednoncash) like '%NULL%' THEN null ELSE cast(dblotherissuednoncash as numeric(25,3)) END,
CASE WHEN upper(dblotherissuednominal) like '%NULL%' THEN null ELSE cast(dblotherissuednominal as numeric(25,3)) END, 
filename, filepath, cast(year as int), feeddate from wvb_clone.roc8;

select regexp_replace(dblotherissuednominal, '[\n\r]+', '', 'g') from wvb_clone.roc8 where dblotherissuednominal like 'NULL%'

select count(*) from tmp_roc8_cleansed

select count(*) from wvb_clone.roc8

-- match the company id
select a.id, a.company_no, b.identifier, regexp_replace(b.identifier, '[^0-9]', '', 'g'), b.dbt_entity_id, c.external_id, c.display_name from tmp_roc8_cleansed a
join dibots_v2.entity_identifier b on a.company_no = regexp_replace(b.identifier, '[^0-9]', '', 'g') and b.identifier_type = 'REGIST'
join dibots_v2.company_profile c on b.dbt_entity_id = c.dbt_entity_id
where (c.country_of_incorporation = 'MYS' or c.country_of_domicile = 'MYS') and a.dbt_entity_id is null


update tmp_roc8_cleansed roc
set
dbt_entity_id = res.dbt_entity_id,
external_id = res.external_id,
company_name = res.display_name
from (
select a.id, a.company_no, b.identifier, regexp_replace(b.identifier, '[^0-9]', '', 'g'), b.dbt_entity_id, c.external_id, c.display_name from tmp_roc8_cleansed a
join dibots_v2.entity_identifier b on a.company_no = regexp_replace(b.identifier, '[^0-9]', '', 'g') and b.identifier_type = 'REGIST'
join dibots_v2.company_profile c on b.dbt_entity_id = c.dbt_entity_id
where (c.country_of_incorporation = 'MYS' or c.country_of_domicile = 'MYS') and a.dbt_entity_id is null) res
where roc.id = res.id;

select * from tmp_roc8_cleansed where dbt_entity_id is null

select * from wvb_clone.roc1 where vchcompanyno in (
select company_no from tmp_roc8_cleansed where dbt_entity_id is null)

select vchcompanyno, vchangkauji, vchcompanyname, max(feeddate) from wvb_clone.roc1 where vchcompanyno in (
select company_no from tmp_roc8_cleansed where dbt_entity_id is null)
group by vchcompanyno, vchangkauji, vchcompanyname

-- Check duplication

alter table tmp_roc8_cleansed add column deleted bool default false;

select * from tmp_roc8_cleansed


select min(id), company_no, filename, count(*) from tmp_roc8_cleansed
where deleted = false
group by company_no, filename having count(*) > 1
order by company_no

select * from tmp_roc8_cleansed where company_no = '1036328' and filename = 'ROC8share_capital.txt'

-- run multiple times
update tmp_roc8_cleansed a
set
deleted = true
from (select min(id) as id, company_no, filename, count(*) from tmp_roc8_cleansed
WHERE deleted = false
group by company_no, filename having count(*) > 1) res
where a.id = res.id;

select min(id), company_no, feed_date, count(*) from tmp_roc8_cleansed
where deleted = false
group by company_no, feed_date having count(*) > 1
order by company_no

update tmp_roc8_cleansed a
set
deleted = true
from (select min(id) as id, company_no, feed_date, count(*) from tmp_roc8_cleansed
where deleted = false
group by company_no, feed_date having count(*) > 1) res
where a.id = res.id;

-- get only the latest for each company
select company_no, max(feed_date) from tmp_roc8_cleansed where deleted is false
group by company_no


select * from tmp_roc8_cleansed a join
(select company_no, max(feed_date) as max_date from tmp_roc8_cleansed where deleted is false
group by company_no) b
on a.company_no = b.company_no and a.feed_date = b.max_date
where a.deleted = false;

-- insert the final result into a prod table
create table dibots_v2.shares_capital_roc8 (
id bigint generated by default as identity primary key,
company_no text,
dbt_entity_id uuid,
external_id bigint,
company_name text,
authorised_capital numeric(25,3),
ord_num_of_shares numeric(25,3),
ord_nominal_value numeric(25,3),
pref_num_of_shares numeric(25,3),
pref_nominal_value numeric(25,3),
other_num_of_shares numeric(25,3),
other_nominal_value numeric(25,3),
ord_issued_cash numeric(25,3),
ord_issued_non_cash numeric(25,3),
ord_issued_nominal numeric(25,3),
pref_issued_cash numeric(25,3),
pref_issued_non_cash numeric(25,3),
pref_issued_nominal numeric(25,3),
other_issued_cash numeric(25,3),
other_issued_non_cash numeric(25,3),
other_issued_nominal numeric(25,3),
filename text,
filepath text,
year int,
feed_date date,
constraint share_capital_roc8_uniq unique (company_no, feed_date)
);

create index shares_capital_roc8_comp_idx on dibots_v2.shares_capital_roc8 (dbt_entity_id);
create index shares_capital_roc8_ext_idx on dibots_v2.shares_capital_roc8 (external_id);

select * from dibots_v2.shares_capital_roc8;

insert into dibots_v2.shares_capital_roc8 (company_no, dbt_entity_id, external_id, company_name, authorised_capital, ord_num_of_shares, ord_nominal_value, pref_num_of_shares, pref_nominal_value, 
other_num_of_shares, other_nominal_value, ord_issued_cash, ord_issued_non_cash, ord_issued_nominal, pref_issued_cash, pref_issued_non_cash, pref_issued_nominal, other_issued_cash, 
other_issued_non_cash, other_issued_nominal, filename, filepath, year, feed_date)
select a.company_no, a.dbt_entity_id, a.external_id, a.company_name, a.authorised_capital, a.ord_num_of_shares, a.ord_nominal_value, a.pref_num_of_shares, a.pref_nominal_value, 
a.other_num_of_shares, a.other_nominal_value, a.ord_issued_cash, a.ord_issued_non_cash, a.ord_issued_nominal, a.pref_issued_cash, a.pref_issued_non_cash, a.pref_issued_nominal, a.other_issued_cash, 
a.other_issued_non_cash, a.other_issued_nominal, a.filename, a.filepath, a.year, a.feed_date
from tmp_roc8_cleansed a join
(select company_no, max(feed_date) as max_date from tmp_roc8_cleansed where deleted is false
group by company_no) b
on a.company_no = b.company_no and a.feed_date = b.max_date
where a.deleted = false;

select * from dibots_v2.shares_capital_roc8

