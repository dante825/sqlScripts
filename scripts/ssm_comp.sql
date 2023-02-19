--drop table tmp_ssm_comp_info;
create table tmp_ssm_comp_info (
company_no varchar,
angka_uji varchar,
company_name varchar,
status_of_company varchar,
dissolved_date varchar(20),
incorporation_date varchar,
company_type varchar,
old_company_name varchar,
date_of_change varchar,
rwup_type varchar,
company_status varchar,
local_foreign varchar(100),
company_country varchar,
business_description varchar,
last_updated_date varchar(100),
company_no_new varchar(100)
)

--drop table if exists dibots_v2.ssm_comp_prof;
create table dibots_v2.ssm_comp_prof (
id serial primary key,
ssm_company_no numeric(25,0),
dbt_entity_id uuid,
external_id integer,
roc_no varchar,
angka_uji varchar,
company_name varchar,
status_of_company varchar,
dissolved_date date,
incorporation_date date,
company_type varchar,
old_company_name varchar,
date_of_change date,
rwup_type varchar,
company_status varchar,
local_foreign varchar(10),
company_country varchar,
business_description varchar,
company_no_new varchar(100),
last_updated_date date,
loaded_date date,
source_file text
);

create index ssm_comp_prof_dbt_id_idx on dibots_v2.ssm_comp_prof (dbt_entity_id);

select count(*) from tmp_ssm_comp_info;

select * from tmp_ssm_comp_info where last_updated_date = '(null)'

select * from dibots_v2.ssm_comp_prof;

insert into dibots_v2.ssm_comp_prof (ssm_company_no, angka_uji, company_name, status_of_company, dissolved_date, incorporation_date, company_type, old_company_name, date_of_change, 
rwup_type, company_status, local_foreign, company_country, business_description, company_no_new, last_updated_date, loaded_date, source_file)
select 
CASE WHEN company_no = '' THEN null WHEN company_no = 'NULL' THEN null ELSE cast(company_no as int) END,
CASE WHEN angka_uji = 'NULL' THEN null ELSE angka_uji END, 
CASE WHEN company_name = 'NULL' THEN null ELSE company_name END, 
CASE WHEN status_of_company = 'NULL' THEN null ELSE status_of_company END, 
CASE WHEN dissolved_date = 'NULL' or dissolved_date = '(null)' THEN null ELSE to_date(dissolved_date, 'YYYY/MM/DD') END,
CASE WHEN incorporation_date = 'NULL' THEN null ELSE to_date(incorporation_date, 'YYYY/MM/DD') END,
CASE WHEN company_type = 'NULL' THEN null ELSE company_type END,
CASE WHEN old_company_name = 'NULL' OR old_company_name = '(null)' THEN null ELSE old_company_name END,
CASE WHEN date_of_change = '' OR date_of_change = '(null)' OR date_of_change = 'NULL' THEN null ELSE to_date(date_of_change, 'YYYY/MM/DD') END,
CASE WHEN rwup_type = 'NULL' OR rwup_type = '' OR rwup_type = '(null)' THEN null ELSE rwup_type END,
CASE WHEN company_status = 'NULL' THEN null ELSE company_status END,
CASE WHEN local_foreign = 'NULL' THEN null ELSE local_foreign END,
CASE WHEN company_country = 'NULL' THEN null ELSE company_country END,
CASE WHEN business_description = 'NULL' THEN null ELSE TRIM(business_description) END,
CASE WHEN company_no_new = 'NULL' OR trim(company_no_new) = '' THEN null ELSE trim(company_no_new) END,
CASE WHEN last_updated_date = 'NULL' OR trim(last_updated_date) = '' OR last_updated_date = '(null)' THEN null ELSE to_date(last_updated_date, 'YYYY-MM-DD') END,
'2020-11-25', 'RAMCi'
from tmp_ssm_comp_info;

select count(*) from dibots_v2.ssm_comp_prof

select * from dibots_v2.ssm_comp_prof where dbt_entity_id is null

select count(*) from tmp_ssm_comp_info --where date_of_change = ''

update dibots_v2.ssm_comp_prof ssm
set
dbt_entity_id = tmp.dbt_entity_id,
external_id = tmp.external_id,
roc_no = tmp.identifier
from
(select cp.dbt_entity_id, cp.external_id, ei.identifier, cp.company_name
from dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where ei.dbt_entity_id = cp.dbt_entity_id and cp.country_of_incorporation = 'MYS' and ei.identifier_type = 'REGIST') tmp
where cast(ssm.ssm_company_no as varchar) = regexp_replace(tmp.identifier, '[^0-9]', '', 'g') and ssm.dbt_entity_id is null;

select * from dibots_v2.ssm_comp_prof where source_file = 'SRM_13March2019'

-- some couldn't be updated so update it manually
update dibots_v2.ssm_comp_prof ssm
set
dbt_entity_id = '9b0e9b5c-3e3d-4067-bdd8-f65c5101f183',
external_id = 2769926,
roc_no = '994141-K'
where ssm.id = 148370;

select * from dibots_v2.ssm_comp_prof where id = 148370

select * from dibots_v2.entity_identifier ei where identifier like '994141%'

select * from dibots_v2.company_profile where dbt_entity_id = '9b0e9b5c-3e3d-4067-bdd8-f65c5101f183';

--====================
-- SSM_SHAREHOLDER
--====================

--drop table tmp_ssm_shareholder;
create table tmp_ssm_shareholder (
company_no varchar(50),
id_type2 varchar(50),
person_id varchar(50),
name varchar(255),
address1 varchar(255),
address2 varchar(255),
address3 varchar(255),
postcode varchar(100),
town varchar(100),
state varchar(100),
birth_date varchar(100),
shares varchar(30)
);

--drop table if exists dibots_v2.ssm_shareholder;
create table dibots_v2.ssm_shareholder (
id serial primary key,
company_no numeric(25,0),
dbt_entity_id uuid,
external_id integer,
roc_no varchar,
id_type2 varchar,
person_id varchar,
name varchar,
address1 varchar(255),
address2 varchar(255),
address3 varchar(255),
postcode int,
town varchar(255),
state varchar(10),
birth_date date,
shares numeric(28,3),
source_date date,
source_file text
);

alter table dibots_v2.ssm_shareholder add column person_entity_id uuid, add column person_ext_id int;

create index ssm_shareholder_dbt_entity_id_idx on dibots_v2.ssm_shareholder (dbt_entity_id);
create index ssm_shareholder_exteranl_id_idx on dibots_v2.ssm_shareholder (external_id);
create index ssm_shareholder_roc_no_idx on dibots_v2.ssm_shareholder (roc_no);
create index ssm_shareholder_person_id_idx on dibots_v2.ssm_shareholder (person_id);
create index ssm_shareholder_person_entity_id_idx on dibots_v2.ssm_shareholder (person_entity_id);
create index ssm_shareholder_person_ext_id_idx on dibots_v2.ssm_shareholder (person_ext_id);

insert into dibots_v2.ssm_shareholder (company_no, id_type2, person_id, name, address1, address2, address3, postcode, town, state, birth_date, shares, source_date, source_file)
select 
CAST(company_no as numeric(25,0)), 
trim(id_type2), 
trim(name),
CASE WHEN person_id = '' or person_id = 'NULL' OR person_id = '(null)' THEN null ELSE trim(person_id) END, 
CASE WHEN address1 = 'NULL' OR trim(address1) = '' OR address1 = '(null)' THEN null ELSE trim(address1) END,
CASE WHEN address2 = 'NULL' OR trim(address2) = '' OR address2 = '(null)' THEN null ELSE trim(address2) END,
CASE WHEN address3 = 'NULL' OR trim(address3) = '' OR address3 = '(null)' THEN null ELSE trim(address3) END,
CASE WHEN postcode = 'NULL' OR trim(postcode) = '' OR postcode = '(null)' OR postcode like '.%' OR postcode = '-' OR postcode like 'NIL%' THEN null ELSE cast(postcode as int) END,
CASE WHEN town = 'NULL' OR trim(town) = '' OR town = '(null)' THEN null ELSE town END,
CASE WHEN state = 'NULL' OR trim(state) = '' OR state = '(null)' THEN null ELSE state END,
CASE WHEN birth_date = 'NULL' OR trim(birth_date) = '' OR birth_date = '(null)' THEN null ELSE to_date(birth_date, 'YYYY-MM-DD') END,
CASE WHEN shares = 'NULL' or trim(shares) = '' OR shares = '(null)' THEN null ELSE cast(shares as numeric(25,2)) END, 
'2020-11-25', 'RAMCi' 
from tmp_ssm_shareholder;

select * from tmp_ssm_shareholder where postcode = '550OO'

update tmp_ssm_shareholder
set postcode = '55000'
where postcode = '550OO'

select count(*) from tmp_ssm_shareholder

select * from dibots_v2.ssm_shareholder

select count(*) from dibots_v2.ssm_shareholder;

select count(*) from dibots_v2.ssm_shareholder where dbt_entity_id is null;

select count(*) from dibots_v2.ssm_shareholder where person_entity_id is null

-- update the columns based on data from ssm_comp_prof
update dibots_v2.ssm_shareholder ss
set
dbt_entity_id = scp.dbt_entity_id,
external_id = scp.external_id,
roc_no = scp.roc_no
from
dibots_v2.ssm_comp_prof scp
where ss.company_no = scp.ssm_company_no and ss.dbt_entity_id is null;

--update the remaining null data based on dibots_v2
update dibots_v2.ssm_shareholder ssm
set
dbt_entity_id = tmp.dbt_entity_id,
external_id = tmp.external_id,
roc_no = tmp.identifier
from
(select cp.dbt_entity_id, cp.external_id, ei.identifier, cp.company_name
from dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where ei.dbt_entity_id = cp.dbt_entity_id and cp.country_of_incorporation = 'MYS' and ei.identifier_type = 'REGIST') tmp
where ssm.company_no = cast(regexp_replace(tmp.identifier, '[^0-9]', '', 'g') as numeric(25,0)) and ssm.dbt_entity_id is null;

-- update the dbt_entity_id based om company_no
update dibots_v2.ssm_shareholder ssm
set 
dbt_entity_id = ei.dbt_entity_id,
external_id = cp.external_id
from dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where regexp_replace(ei.identifier, '[^0-9]', '', 'g')  = cast(ssm.company_no as varchar) and ei.identifier_type = 'REGIST' and cp.dbt_entity_id = ei.dbt_entity_id and cp.country_of_incorporation = 'MYS'
and cp.wvb_entity_type = 'COMP';

-- update the external_id
update dibots_v2.ssm_shareholder ssm
set
external_id = cp.external_id
from dibots_v2.company_profile cp
where ssm.dbt_entity_id = cp.dbt_entity_id and cp.wvb_entity_type = 'COMP' and ssm.external_id is null;

-- use the IC no to update the person_entity_id
update dibots_v2.ssm_shareholder ssm
set
person_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei
where ssm.person_id = ei.identifier and ei.identifier_type = 'MK' and ssm.id_type2 = 'MK' and ssm.person_entity_id is null;

-- update the ext_id based on person_entity_id
update dibots_v2.ssm_shareholder ssm
set
person_ext_id = pp.external_id
from dibots_v2.person_profile pp
where ssm.person_entity_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ssm.person_ext_id is null;

-- some of the person_id is roc number
update dibots_v2.ssm_shareholder ssm
set
person_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei
where ei.identifier = ssm.person_id and ssm.person_entity_id is null and ei.identifier_type = 'REGIST' and ssm.id_type2 = 'C'
and person_entity_id is null;

-- when the person_id is roc no
update dibots_v2.ssm_shareholder ssm
set
person_ext_id = cp.external_id
from dibots_v2.company_profile cp
where cp.dbt_entity_id = ssm.person_entity_id and cp.wvb_entity_type = 'COMP' and ssm.person_ext_id is null;

-- some of the person_id is roc number without the alphabets
update dibots_v2.ssm_shareholder ssm
set
person_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei
where regexp_replace(ei.identifier, '[^0-9]', '', 'g') = ssm.person_id and ssm.id_type2 = 'C' and ei.identifier_type = 'REGIST' and ssm.person_entity_id is null;

-- some of the person_id is roc number without dash
update dibots_v2.ssm_shareholder ssm
set
person_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei
where regexp_replace(ei.identifier, '-', '', 'g') = ssm.person_id and ssm.id_type2 = 'C' and ei.identifier_type = 'REGIST' and ssm.person_entity_id is null;

-- update person_entity_id with passport and others
update dibots_v2.ssm_shareholder ssm
set
person_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei
where ssm.person_id = ei.identifier and ssm.person_entity_id is null and ei.identifier_type in ('PR', 'MK', 'GOVT_ID', 'PASSPORT');


update dibots_v2.ssm_shareholder ssm
set
person_ext_id = em.external_id
from dibots_v2.entity_master em
where ssm.person_entity_id = em.dbt_entity_id and ssm.person_entity_id is not null and ssm.person_ext_id is null;

select count(*) from dibots_v2.ssm_shareholder where person_ext_id is null


--======================
-- ssm_comp_buss_code
--======================

--drop table if exists ssm_buss_desc;
create table ssm_buss_desc (
id serial primary key,
buss_code varchar,
buss_desc text,
source_date date
load_date date,
source_file varchar(255)
);

create table tmp_ssm_comp_buss_code (
company_no integer,
bussiness_code varchar,
priority integer,
source_date date
);

update tmp_ssm_comp_buss_code
set
bussiness_code = '66191'
where bussiness_code = '�66191'

select count(*) from tmp_ssm_comp_buss_code

select * from tmp_ssm_comp_buss_code where bussiness_code = 'NULL'

select count(*) from dibots_v2.ssm_comp_buss_code;

insert into dibots_v2.ssm_comp_buss_code (ssm_company_no, buss_code, priority, source_date, source_file)
select company_no, 
CASE WHEN trim(bussiness_code) = '' THEN null ELSE trim(bussiness_code) END,
priority, '2020-11-25', 'RAMCi'
from tmp_ssm_comp_buss_code;

select * from dibots_v2.ssm_comp_buss_code where dbt_entity_id is null --and source_date = '2020-11-23'

select * from dibots_v2.ssm_comp_prof;

update dibots_v2.ssm_comp_buss_code a
set
dbt_entity_id = b.dbt_entity_id,
external_id = b.external_id,
company_name = b.company_name,
roc = b.roc_no
from dibots_v2.ssm_comp_prof b
where a.ssm_company_no = b.ssm_company_no and a.dbt_entity_id is null;

update dibots_v2.ssm_comp_buss_code ssm
set
dbt_entity_id = tmp.dbt_entity_id,
external_id = tmp.external_id,
roc = tmp.identifier,
company_name = tmp.company_name
from
(select cp.dbt_entity_id, cp.external_id, ei.identifier, cp.company_name
from dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where ei.dbt_entity_id = cp.dbt_entity_id and cp.country_of_incorporation = 'MYS' and ei.identifier_type = 'REGIST') tmp
where cast(ssm.ssm_company_no as varchar) = regexp_replace(tmp.identifier, '[^0-9]', '', 'g') and ssm.dbt_entity_id is null;

select * from dibots_v2.ssm_comp_buss_code where source_date = '2020-07-01' and dbt_entity_id is not null

select * from dibots_v2.ssm_comp_buss_code where buss_desc is null;

update dibots_v2.ssm_comp_buss_code ssm
set
buss_desc = buss.buss_desc
from ssm_buss_desc buss
where trim(ssm.buss_code) = trim(buss.buss_code) and ssm.buss_desc is null;

select count(*) from dibots_v2.ssm_comp_buss_code where buss_desc is null;

--===============
-- SSM_ADDRESS
--==============

create table tmp_ssm_address (
company_no integer,
address1 text,
address2 text,
address3 text,
postcode integer,
town varchar,
state varchar,
address_type varchar,
source_date date
);

--drop table if exists dibots_v2.ssm_address;
CREATE TABLE dibots_v2.ssm_address (
id serial primary key,
company_no integer,
address1 text,
address2 text,
address3 text,
postcode integer,
town varchar,
state varchar,
address_type varchar,
source_date date,
load_date date,
source_file varchar(255)
);

select count(*) from dibots_v2.ssm_address

select COUNT(*) from tmp_ssm_address;

select * from tmp_ssm_address where postcode = 'NIL'

update tmp_ssm_address add
set
address_type = 'REG',
source_date = '2020-11-25'
where add.address_type is null;

select count(*) from tmp_ssm_address where address_type = 'REG'

select count(*) from tmp_ssm_address where address_type = 'BUS'

select * from tmp_ssm_address --where postcode = '471--'

select count(*) from dibots_v2.ssm_address;

select * from dibots_v2.ssm_address;

insert into dibots_v2.ssm_address (company_no, address1, address2, address3, postcode, town, state, address_type, source_date, load_date, source_file)
select CAST(company_no AS int),
CASE WHEN address1 = 'NULL' OR trim(address1) = ''  OR address1 = 'NIL' OR address1 = '(null)' THEN null ELSE trim(address1) END,
CASE WHEN address2 = 'NULL' OR trim(address2) = ''  OR address2 = 'NIL' OR address2 = '(null)' THEN null ELSE trim(address2) END,
CASE WHEN address3 = 'NULL' OR trim(address3) = '' OR address3 = 'NIL' OR address3 = '(null)' THEN null ELSE trim(address3) END,
CASE WHEN trim(postcode) = '' OR postcode = 'NULL' OR postcode = 'NIL' OR postcode = '(null)' OR postcode = '.' OR postcode like '%-%' THEN null ELSE CAST(postcode AS int) END,
CASE WHEN town = 'NULL' OR trim(town) = '' OR town = '(null)' THEN null ELSE town END,
CASE WHEN state = 'NULL' OR trim(state) = '' OR state = '(null)' THEN null ELSE state END,
address_type, null, '2020-11-25', 'RAMCi'
from tmp_ssm_address;


--====================
-- SSM_BALANCE_SHEET
--====================

create table tmp_ssm_balance_sheet (
company_no varchar,
audit_firm_no varchar,
audit_firm_name varchar,
audit_firm_address1 varchar,
audit_firm_address2 varchar,
audit_firm_address3 varchar,
audit_firm_postcode varchar(10),
audit_firm_town varchar,
audit_firm_state varchar,
date_of_tabling varchar,
accrual_account varchar,
financial_year_end_date varchar,
financial_report_type varchar,
fixed_asset varchar(30),
total_investment varchar(30),
current_asset varchar(30),
other_asset varchar(30),
contigent_liability varchar,
paid_up_capital varchar(30),
share_premium varchar(30),
appropriate_profit varchar(30),
minority_interest varchar(30),
share_appl_account varchar(30), 
long_term_liability varchar(30),
liability varchar(30),
reserves varchar
);

--drop table dibots_v2.ssm_balance_sheet;
create table dibots_v2.ssm_balance_sheet (
company_no varchar,
comp_entity_id uuid,
comp_ext_id int,
comp_name varchar(255),
audit_firm_no varchar,
audit_firm_name varchar,
audit_firm_address1 varchar,
audit_firm_address2 varchar,
audit_firm_address3 varchar,
audit_firm_postcode int,
audit_firm_town varchar,
audit_firm_state varchar,
date_of_tabling date,
accrual_account varchar(5),
financial_year_end_date date,
financial_report_type varchar(10),
fixed_asset numeric(25,2),
total_investment numeric(25,2),
current_asset numeric(25,2),
other_asset numeric(25,2),
contigent_liability numeric(25,2),
paid_up_capital numeric(25,2),
share_premium numeric(25,2),
appropriate_profit numeric(25,2),
minority_interest numeric(25,2),
share_appl_account numeric(25,2), 
long_term_liability numeric(25,2),
liability numeric(25,2),
reserves numeric(25,2),
source_date date,
source_file varchar(255)
);

select * from tmp_ssm_balance_sheet;

select * from tmp_ssm_balance_sheet where date_of_tabling = '(null)'

select count(*) from tmp_ssm_balance_sheet;

select count(*) from dibots_v2.ssm_balance_sheet;

select * from dibots_v2.ssm_balance_sheet

insert into dibots_v2.ssm_balance_sheet (company_no, audit_firm_no, audit_firm_name, audit_firm_address1, audit_firm_address2, audit_firm_address3, audit_firm_postcode, audit_firm_town,
audit_firm_state, date_of_tabling, accrual_account, financial_year_end_date, financial_report_type, fixed_asset, total_investment, current_asset, other_asset, contigent_liability, paid_up_capital,
share_premium, appropriate_profit, minority_interest, share_appl_account, long_term_liability, liability, reserves, source_date, source_file)
select bs.company_no, 
CASE WHEN trim(bs.audit_firm_no) = '' then null ELSE trim(bs.audit_firm_no) END, 
CASE WHEN trim(bs.audit_firm_name) = '' OR bs.audit_firm_name = '(null)' then null ELSE trim(bs.audit_firm_name) END, 
CASE WHEN bs.audit_firm_address1 = 'NULL' OR trim(bs.audit_firm_address1) = '' OR bs.audit_firm_address1 = '(null)' THEN null ELSE trim(bs.audit_firm_address1) END,
CASE WHEN bs.audit_firm_address2 = 'NULL' OR trim(bs.audit_firm_address2) = '' OR bs.audit_firm_address2 = '(null)' THEN null ELSE trim(bs.audit_firm_address2) END, 
CASE WHEN bs.audit_firm_address3 = 'NULL' OR trim(bs.audit_firm_address3) = '' OR bs.audit_firm_address3 = '(null)' THEN null ELSE trim(bs.audit_firm_address3) END, 
CASE WHEN bs.audit_firm_postcode = 'NULL' OR bs.audit_firm_postcode = '' OR bs.audit_firm_postcode = '-' OR bs.audit_firm_postcode = '(null)' THEN null ELSE cast(trim(audit_firm_postcode) as int) END,
CASE WHEN bs.audit_firm_town = 'NULL' OR bs.audit_firm_town = '' OR bs.audit_firm_town = '-' OR bs.audit_firm_town = '(null)' THEN null ELSE trim(audit_firm_town) END,
CASE WHEN bs.audit_firm_state = 'NULL' OR bs.audit_firm_state = '' OR bs.audit_firm_state = '-' THEN null ELSE trim(audit_firm_state) END,
CASE WHEN bs.date_of_tabling = 'NULL' OR bs.date_of_tabling = '' OR bs.date_of_tabling = '(null)' THEN null ELSE to_date(trim(date_of_tabling), 'YYYY/MM/DD') END,
CASE WHEN bs.accrual_account = 'NULL' OR trim(bs.accrual_account) = '' OR bs.accrual_account = '(null)' THEN null ELSE trim(bs.accrual_account) END,
CASE WHEN bs.financial_year_end_date = 'NULL' OR bs.financial_year_end_date = '' OR bs.financial_year_end_date = '(null)' THEN null ELSE to_date(trim(bs.financial_year_end_date), 'YYYY/MM/DD') END,
CASE WHEN bs.financial_report_type = 'NULL' OR trim(bs.financial_report_type) = '' OR bs.financial_report_type = '(null)' THEN null ELSE trim(bs.financial_report_type) END,
CASE WHEN bs.fixed_asset = 'NULL' OR trim(bs.fixed_asset) = '' OR bs.fixed_asset = '(null)' THEN null ELSE cast(bs.fixed_asset as numeric(25,2)) END,
CASE WHEN bs.total_investment = 'NULL' OR trim(bs.total_investment) = '' OR bs.total_investment = '(null)' THEN null ELSE cast(bs.total_investment as numeric(25,2)) END,
CASE WHEN bs.current_asset = 'NULL' OR trim(bs.current_asset) = '' OR bs.current_asset = '(null)' THEN null ELSE cast(bs.current_asset as numeric(25,2)) END,
CASE WHEN bs.other_asset = 'NULL' OR trim(bs.other_asset) = '' OR bs.other_asset = '(null)' THEN null ELSE cast(bs.other_asset as numeric(25,2)) END,
CASE WHEN bs.contigent_liability = 'NULL' OR trim(bs.contigent_liability) = '' OR bs.contigent_liability = '(null)' THEN null ELSE CAST(bs.contigent_liability AS numeric(25,2)) END, 
CASE WHEN bs.paid_up_capital = 'NULL' OR trim(bs.paid_up_capital) = '' OR bs.paid_up_capital = '(null)' THEN null ELSE cast(bs.paid_up_capital as numeric(25,2)) END,
CASE WHEN bs.share_premium = 'NULL' OR trim(bs.share_premium) = '' OR bs.share_premium = '(null)' THEN null ELSE cast(bs.share_premium as numeric(25,2)) END,
CASE WHEN bs.appropriate_profit = 'NULL' OR trim(bs.appropriate_profit) = '' OR bs.appropriate_profit = '(null)' THEN null ELSE cast(bs.appropriate_profit as numeric(25,2)) END,
CASE WHEN bs.minority_interest = 'NULL' OR trim(bs.minority_interest) = '' OR bs.minority_interest = '(null)' THEN null ELSE cast(bs.minority_interest as numeric(25,2)) END,
CASE WHEN bs.share_appl_account = 'NULL' OR trim(bs.share_appl_account) = '' OR bs.share_appl_account = '(null)' THEN null ELSE cast(bs.share_appl_account as numeric(25,2)) END,
CASE WHEN bs.long_term_liability = 'NULL' OR trim(bs.long_term_liability) = '' OR bs.long_term_liability = '(null)' THEN null ELSE cast(bs.long_term_liability as numeric(25,2)) END,
CASE WHEN bs.liability = 'NULL' OR trim(bs.liability) = '' OR bs.liability = '(null)' THEN null ELSE cast(bs.liability as numeric(25,2)) END, 
CASE WHEN bs.reserves = 'NULL' OR bs.reserves = '(null)' THEN null ELSE CAST(bs.reserves AS numeric(25,2)) END,
'2020-11-25', 'RAMCi'
from tmp_ssm_balance_sheet bs;

select * from dibots_v2.ssm_balance_sheet where comp_entity_id is null;

select * from dibots_v2.ssm_comp_prof

update dibots_v2.ssm_balance_sheet bs
set
comp_entity_id = scp.dbt_entity_id,
comp_ext_id = scp.external_id,
comp_name = scp.company_name
from dibots_v2.ssm_comp_prof scp
where bs.company_no = cast(scp.ssm_company_no as varchar) and comp_entity_id is null;


--===================
-- SSM_PROFIT_LOSS
--===================

create table tmp_ssm_profit_loss (
company_no varchar, 
accrual_account varchar,
financial_year_end_date varchar,
financial_report_type varchar,
turn_over varchar(30),
revenue varchar(30),
profit_before_tax varchar(30),
profit_after_tax varchar(30),
extraordinary_item varchar(30),
minority_interest varchar(30),
profits_shareholder varchar(30),
prior_adjustment varchar(30),
net_dividend varchar(30),
transferred varchar(30),
other_fund varchar(30),
inappropriate_profit_cf varchar(30),
gross_dividend_rate varchar,
inappropriate_profit_bf varchar(30)
);

create table dibots_v2.ssm_profit_loss (
company_no varchar, 
comp_entity_id uuid,
comp_ext_id int,
comp_name varchar(255),
accrual_account varchar(100),
financial_year_end_date date,
financial_report_type varchar(100),
turn_over numeric(25,2),
revenue numeric(25,2),
profit_before_tax numeric(25,2),
profit_after_tax numeric(25,2),
extraordinary_item numeric(25,2),
minority_interest numeric(25,2),
profits_shareholder numeric(25,2),
prior_adjustment numeric(25,2),
net_dividend numeric(25,2),
transferred numeric(25,2),
other_fund numeric(25,2),
inappropriate_profit_cf numeric(25,2),
gross_dividend_rate numeric(25,2),
inappropriate_profit_bf numeric(25,2),
source_date date,
source_file varchar(255)
);


select * from tmp_ssm_profit_loss;

select to_date(financial_year_end_date, 'YYYY-MM-DD') from tmp_ssm_profit_loss;

select count(*) from tmp_ssm_profit_loss;

select count(*) from dibots_v2.ssm_profit_loss;

select * from dibots_v2.ssm_profit_loss;

insert into dibots_v2.ssm_profit_loss (company_no, accrual_account, financial_year_end_date, financial_report_type, turn_over, revenue, profit_before_tax, profit_after_tax, extraordinary_item, 
minority_interest, profits_shareholder,prior_adjustment, net_dividend, transferred, other_fund, inappropriate_profit_cf, gross_dividend_rate, inappropriate_profit_bf, source_date, source_file)
select cast(pl.company_no as varchar),
CASE WHEN pl.accrual_account = 'NULL' OR trim(pl.accrual_account) = '' then null ELSE trim(pl.accrual_account) END,
CASE WHEN pl.financial_year_end_date = 'NULL' OR trim(pl.financial_year_end_date) = '' then null ELSE to_date(financial_year_end_date, 'YYYY/MM/DD') END,
CASE WHEN pl.financial_report_type = 'NULL' OR trim(pl.financial_report_type) = '' then null ELSE trim(pl.financial_report_type) END,
CASE WHEN pl.turn_over = 'NULL' OR trim(pl.turn_over) = '' THEN null ELSE cast(pl.turn_over as numeric(25,2)) END,
CASE WHEN pl.revenue = 'NULL' OR trim(pl.revenue) = '' OR pl.revenue = ' ' THEN null ELSE cast(pl.revenue as numeric(25,2)) END,
CASE WHEN pl.profit_before_tax = 'NULL' OR trim(pl.profit_before_tax) = '' OR pl.profit_before_tax = ' ' THEN null ELSE cast(pl.profit_before_tax as numeric(25,2)) END,
CASE WHEN pl.profit_after_tax = 'NULL' OR trim(pl.profit_after_tax) = '' OR pl.profit_after_tax = ' ' THEN null ELSE cast(pl.profit_after_tax as numeric(25,2)) END,
CASE WHEN pl.extraordinary_item = 'NULL' OR trim(pl.extraordinary_item) = '' OR pl.extraordinary_item = ' ' THEN null ELSE cast(pl.extraordinary_item as numeric(25,2)) END,
CASE WHEN pl.minority_interest = 'NULL' OR trim(pl.minority_interest) = '' OR pl.minority_interest = ' ' THEN null ELSE cast(pl.minority_interest as numeric(25,2)) END,
CASE WHEN pl.profits_shareholder = 'NULL' OR trim(pl.profits_shareholder) = '' OR pl.profits_shareholder = ' ' THEN null ELSE cast(pl.profits_shareholder as numeric(25,2)) END,
CASE WHEN pl.prior_adjustment = 'NULL' OR trim(pl.prior_adjustment) = '' OR pl.prior_adjustment = ' ' THEN null ELSE cast(pl.prior_adjustment as numeric(25,2)) END,
CASE WHEN pl.net_dividend = 'NULL' OR trim(pl.net_dividend) = '' OR pl.net_dividend = ' ' THEN null ELSE cast(pl.net_dividend as numeric(25,2)) END,
CASE WHEN pl.transferred = 'NULL' OR trim(pl.transferred) = '' OR pl.transferred = ' ' THEN null ELSE cast(pl.transferred as numeric(25,2)) END,
CASE WHEN pl.other_fund = 'NULL' OR trim(pl.other_fund) = '' OR pl.other_fund = ' ' THEN null ELSE cast(pl.other_fund as numeric(25,2)) END,
CASE WHEN pl.inappropriate_profit_cf = 'NULL' OR trim(pl.inappropriate_profit_cf) = '' OR pl.inappropriate_profit_cf = ' ' THEN null ELSE cast(pl.inappropriate_profit_cf as numeric(25,2)) END,
CASE WHEN pl.gross_dividend_rate = 'NULL' OR trim(pl.gross_dividend_rate) = '' OR pl.gross_dividend_rate = '(null)' THEN null ELSE cast(pl.gross_dividend_rate as numeric(25,2)) END,
CASE WHEN pl.inappropriate_profit_bf = 'NULL' OR trim(pl.inappropriate_profit_bf) = '' OR pl.inappropriate_profit_bf = ' ' THEN null ELSE cast(pl.inappropriate_profit_bf as numeric(25,2)) END,
'2020-11-25', 'RAMCi'
from tmp_ssm_profit_loss pl;

select * from dibots_v2.ssm_profit_loss where comp_entity_id is null;

select * from dibots_v2.ssm_comp_prof;

update dibots_v2.ssm_profit_loss a
set
comp_entity_id = scp.dbt_entity_id,
comp_ext_id = scp.external_id,
comp_name = scp.company_name
from dibots_v2.ssm_comp_prof scp
where a.company_no = cast(scp.ssm_company_no as varchar) and a.comp_entity_id is null;


--=======================
-- SSM_CHARGES
--=======================

--drop table tmp_ssm_charges;
create table tmp_ssm_charges (
company_no varchar(255),
charge_no varchar(10),
prop_amount varchar(100),
charge_created_date varchar(10),
charge_name varchar(255),
charge_id varchar(255),
charge_status varchar(255),
form_40_printed_date varchar(10),
amend_no varchar(10),
amend_no2 varchar(10),
mortgage_type varchar(10),
prop_currency varchar(10)
);

--drop table dibots_v2.ssm_charges;
create table dibots_v2.ssm_charges (
company_no varchar(10),
dbt_entity_id uuid,
external_id int,
charge_no varchar(10),
amend_no varchar(10),
prop_amount bigint,
charge_created_date date,
charge_name varchar(255),
charge_id varchar(255),
charge_status varchar(255),
form_40_printed_date date,
mortgage_type varchar(10),
prop_currency varchar(10),
source_date date,
source_file varchar(255)
);

select count(*) from tmp_ssm_charges;

select * from tmp_ssm_charges where amend_no <> amend_no2;

select * from dibots_v2.ssm_charges

select count(*) from dibots_v2.ssm_charges

insert into dibots_v2.ssm_charges (company_no, charge_no, amend_no, prop_amount, charge_created_date, charge_name, charge_status, form_40_printed_date, mortgage_type, 
prop_currency, charge_id, source_date, source_file)
select
company_no, charge_no,
CASE WHEN trim(amend_no) = '' OR amend_no = 'NULL' OR amend_no = '(null)' THEN null ELSE trim(amend_no) END,
CASE WHEN prop_amount = 'NULL' OR trim(prop_amount) = '' OR prop_amount = '(null)' THEN null ELSE cast(prop_amount as numeric(25,0)) END,
CASE WHEN charge_created_date = 'NULL' or charge_created_date = '' OR charge_created_date = '(null)' THEN null ELSE to_date(charge_created_date, 'YYYY/MM/DD') END,
trim(charge_name), 
trim(charge_status),
CASE WHEN form_40_printed_date = '' OR form_40_printed_date = 'NULL' OR form_40_printed_date = '(null)' THEN null ELSE to_date(form_40_printed_date, 'YYYY/MM/DD') end,
CASE WHEN mortgage_type = '' OR mortgage_type = 'NULL' THEN null ELSE mortgage_type END,
CASE WHEN trim(prop_currency) = '' OR prop_currency = 'NULL' OR prop_currency = '-- Please' OR prop_currency = '(null)' THEN null ELSE prop_currency END,
CASE WHEN trim(charge_id) = '' OR charge_id = 'NULL' THEN null ELSE trim(charge_id) END,
'2020-11-25', 'RAMCi'
from tmp_ssm_charges;

select * from dibots_v2.ssm_charges

select * from dibots_v2.ssm_charges where external_id is null;

select * from dibots_v2.ssm_comp_prof;

update dibots_v2.ssm_charges ch
set
dbt_entity_id = a.dbt_entity_id,
external_id = a.external_id
from dibots_v2.ssm_comp_prof a
where ch.company_no = cast(a.ssm_company_no as varchar) and ch.dbt_entity_id is null;

update dibots_v2.ssm_charges ssm
set
dbt_entity_id = ei.dbt_entity_id
from
dibots_v2.entity_identifier ei
where ei.identifier_type = 'REGIST' and ssm.company_no = regexp_replace(ei.identifier, '[^0-9]', '', 'g') and ssm.dbt_entity_id is null;

update dibots_v2.ssm_charges ssm
set
external_id = cp.external_id
from dibots_v2.company_profile cp
where ssm.dbt_entity_id = cp.dbt_entity_id and cp.wvb_entity_type = 'COMP' and ssm.external_id is null;

--==========================
-- SSM_CAPITAL
--==========================

--drop table tmp_ssm_capital;
create table tmp_ssm_capital (
company_no varchar(255),
authorised_capital varchar(30),
number_of_shares varchar(30),
nominal_value varchar(30),
pref_number_of_shares varchar(30),
pref_nominal_value varchar(30),
other_number_of_shares varchar(30),
other_nominal_value varchar(30),
ord_issued_cash varchar(30),
ord_issued_non_cash varchar(30),
ord_issued_nominal varchar(30),
pref_issued_cash varchar(30),
pref_issued_non_cash varchar(30),
pref_issued_nominal varchar(30),
other_issued_cash varchar(30),
other_issued_non_cash varchar(30),
other_issued_nominal varchar(30)
);

--drop table dibots_v2.ssm_capital;
create table dibots_v2.ssm_capital (
company_no varchar(255),
dbt_entity_id uuid,
external_id int,
authorised_capital bigint,
number_of_shares bigint,
nominal_value bigint,
pref_number_of_shares bigint,
pref_nominal_value bigint,
other_number_of_shares bigint,
other_nominal_value bigint,
ord_issued_cash bigint,
ord_issued_non_cash bigint,
ord_issued_nominal bigint,
pref_issued_cash bigint,
pref_issued_non_cash bigint,
pref_issued_nominal bigint,
other_issued_cash bigint,
other_issued_non_cash bigint,
other_issued_nominal bigint,
source_date date
);

select count(*) from tmp_ssm_capital

select * from tmp_ssm_capital

select count(*) from dibots_v2.ssm_capital

insert into dibots_v2.ssm_capital (company_no, authorised_capital, number_of_shares, nominal_value, pref_number_of_shares, 
pref_nominal_value, other_number_of_shares, other_nominal_value, ord_issued_cash, ord_issued_non_cash, ord_issued_nominal, 
pref_issued_cash, pref_issued_non_cash, pref_issued_nominal, other_issued_cash, other_issued_non_cash, other_issued_nominal, source_date, source_file)
select company_no, 
CASE WHEN authorised_capital = 'NULL' OR authorised_capital = '' OR authorised_capital = '(null)' THEN null ELSE CAST(authorised_capital AS NUMERIC(25,0)) END, 
CASE WHEN number_of_shares = 'NULL' OR number_of_shares = '' OR number_of_shares = '(null)' THEN null ELSE CAST(number_of_shares AS NUMERIC(25,0)) END, 
CASE WHEN nominal_value = 'NULL' OR nominal_value = '' OR nominal_value = '(null)' THEN null ELSE CAST(nominal_value AS NUMERIC(25,0)) END, 
CASE WHEN pref_number_of_shares = 'NULL' OR pref_number_of_shares = '' OR pref_number_of_shares = '(null)' THEN null ELSE CAST(pref_number_of_shares AS NUMERIC(25,0)) END, 
CASE WHEN pref_nominal_value = 'NULL' OR pref_nominal_value = '' OR pref_nominal_value = '(null)' THEN null ELSE CAST(pref_nominal_value AS NUMERIC(25,0)) END, 
CASE WHEN other_number_of_shares = 'NULL' OR other_number_of_shares = '' OR other_number_of_shares = '(null)' THEN null ELSE CAST(other_number_of_shares AS NUMERIC(25,0)) END, 
CASE WHEN other_nominal_value = 'NULL' OR other_nominal_value = '' OR other_nominal_value = '(null)' THEN null ELSE CAST(other_nominal_value AS NUMERIC(25,0)) END, 
CASE WHEN ord_issued_cash = 'NULL' OR ord_issued_cash = '' OR ord_issued_cash = '(null)' THEN null ELSE CAST(ord_issued_cash AS NUMERIC(25,0)) END, 
CASE WHEN ord_issued_non_cash = 'NULL' OR ord_issued_non_cash = '' OR ord_issued_non_cash = '(null)' THEN null ELSE CAST(ord_issued_non_cash AS NUMERIC(25,0)) END, 
CASE WHEN ord_issued_nominal = 'NULL' OR ord_issued_nominal = '' OR ord_issued_nominal = '(null)' THEN null ELSE CAST(ord_issued_nominal AS NUMERIC(25,0)) END, 
CASE WHEN pref_issued_cash = 'NULL' OR pref_issued_cash = '' OR pref_issued_cash = '(null)' THEN null ELSE CAST(pref_issued_cash AS NUMERIC(25,0)) END, 
CASE WHEN pref_issued_non_cash = 'NULL' OR pref_issued_non_cash = '' OR pref_issued_non_cash = '(null)' THEN null ELSE CAST(pref_issued_non_cash AS NUMERIC(25,0)) END, 
CASE WHEN pref_issued_nominal = 'NULL' OR pref_issued_nominal = '' OR pref_issued_nominal = '(null)' THEN null ELSE CAST(pref_issued_nominal AS NUMERIC(25,0)) END, 
CASE WHEN other_issued_cash = 'NULL' OR other_issued_cash = '' OR other_issued_cash = '(null)' THEN null ELSE CAST(other_issued_cash AS NUMERIC(25,0)) END, 
CASE WHEN other_issued_non_cash = 'NULL' OR other_issued_non_cash = '' OR other_issued_non_cash  = '(null)' THEN null ELSE CAST(other_issued_non_cash AS NUMERIC(25,0)) END, 
CASE WHEN other_issued_nominal = 'NULL' OR other_issued_nominal = '' OR other_issued_nominal = '(null)' THEN null ELSE CAST(other_issued_nominal AS NUMERIC(25,0)) END,
'2020-11-25', 'RAMCi'
from tmp_ssm_capital

select * from dibots_v2.ssm_capital where dbt_entity_id is null;

update dibots_v2.ssm_capital c
set
dbt_entity_id = a.dbt_entity_id,
external_id = a.external_id
from dibots_v2.ssm_comp_prof a
where c.company_no = cast(a.ssm_company_no as varchar) and c.dbt_entity_id is null;


update dibots_v2.ssm_capital ssm
set
dbt_entity_id = ei.dbt_entity_id
from
dibots_v2.entity_identifier ei
where ei.identifier_type = 'REGIST' and ssm.company_no = regexp_replace(ei.identifier, '[^0-9]', '', 'g') and ssm.dbt_entity_id is null;

update dibots_v2.ssm_capital ssm
set
external_id = cp.external_id
from dibots_v2.company_profile cp
where ssm.dbt_entity_id = cp.dbt_entity_id and cp.wvb_entity_type = 'COMP' and ssm.external_id is null;

--==================
-- SSM_LAST_UPDATED
--==================

create table tmp_ssm_last_updated (
company_no varchar(255),
form_trx int,
max_date_received varchar(10)
);

create table dibots_v2.ssm_last_updated (
company_no varchar(255),
form_trx int,
max_date_received date,
source_date date,
source_file text
);

insert into dibots_v2.ssm_last_updated (company_no, form_trx, max_date_received, source_date, source_file)
select company_no, form_trx, to_date(max_date_received, 'YYYY-MM-DD'), '2020-11-25', 'RAMCi' 
from tmp_ssm_last_updated ON CONFLICT DO NOTHING;

select count(*) from dibots_v2.ssm_last_updated

select count(*) from tmp_ssm_last_updated;

select * from tmp_ssm_last_updated;


--===================
-- SSM_OFFICER
--===================

create table tmp_ssm_officer (
company_no varchar,
id_type2 varchar,
person_id varchar,
name varchar,
birth_date varchar,
address1 varchar,
address2 varchar,
address3 varchar,
postcode varchar(100),
town varchar,
state varchar,
designation_code varchar,
start_date varchar,
resign_date varchar
);

--drop table if exists dibots_v2.ssm_officer;
CREATE TABLE dibots_v2.ssm_officer
(
   id serial PRIMARY KEY NOT NULL,
   ssm_company_no numeric(25,0),
   ssm_id_type2 varchar,
   ssm_person_id varchar,
   name varchar,
   birth_date date,
   address1 text,
   address2 text,
   address3 text,
   postcode varchar,
   town varchar,
   state varchar,
   designation_code varchar,
   start_date date,
   resign_date date,
   source_date date,
   source_file varchar(255)
);

select * from tmp_ssm_officer where start_date = 'D'

select count(*) from tmp_ssm_officer;

select * from dibots_v2.ssm_officer;

select count(*) from dibots_v2.ssm_officer;

insert into dibots_v2.ssm_officer (ssm_company_no, ssm_id_type2, ssm_person_id, name, birth_date, address1, address2, address3, postcode, town, state, designation_code, 
start_date, resign_date, source_date, source_file)
select 
TRIM(company_no), id_type2, person_id, name, 
CASE WHEN birth_date = 'NULL' OR trim(birth_date) = '' OR birth_date = '(null)' THEN NULL ELSE to_date(birth_date, 'YYYY-MM-DD') END, 
CASE WHEN address1 = 'NULL' OR address1 = '(null)' THEN NULL ELSE address1 END,
CASE WHEN address2 = 'NULL' OR address2 = '(null)' THEN NULL ELSE address2 END, 
CASE WHEN address3 = 'NULL' OR trim(address3) = '' OR address3 = '(null)' THEN NULL ELSE address3 END, 
CASE WHEN postcode = 'NULL' OR postcode = '.' OR postcode = 'null' OR postcode = '-' OR postcode = 'NILL' OR postcode = '' OR postcode = 'nil' OR postcode = 'NIL'  OR postcode = '(null)' 
THEN NULL ELSE postcode END,
CASE WHEN town = 'NULL' OR town = '.' OR town = '-' OR town = 'NILL' OR town = '' OR town = '(null)' THEN NULL ELSE town END, 
CASE WHEN state = 'NULL' OR trim(state) = '' THEN NULL ELSE state END, 
CASE WHEN designation_code = 'NULL' OR trim(designation_code) = '' THEN NULL ELSE designation_code END, 
CASE WHEN start_date = 'NULL' OR trim(start_date) = '' OR start_date = '(null)' THEN NULL ELSE to_date(start_date, 'YYYY-MM-DD') END, 
CASE WHEN resign_date = 'NULL' OR trim(resign_date) = '' OR resign_date = '(null)' THEN NULL ELSE to_date(resign_date, 'YYYY-MM-DD') END,
'2020-11-25', 'RAMCi'
from tmp_ssm_officer

select count(*) from dibots_v2.ssm_officer where person_entity_id is null;

select count(*) from dibots_v2.ssm_officer where company_entity_id is null;

select * from dibots_v2.ssm_officer

-- update the company_entity_id based on the ssm_shareholder table
update dibots_v2.ssm_officer so
set
company_entity_id = ss.dbt_entity_id,
company_ext_id = ss.external_id
from dibots_v2.ssm_shareholder ss
where so.ssm_company_no = cast(ss.company_no as varchar) and so.company_entity_id is null;

-- update the person_entity_id
update dibots_v2.ssm_officer so
set
person_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei
where so.ssm_person_id = ei.identifier and ei.identifier_type = 'MK' and so.ssm_id_type2 = 'MK' and so.person_entity_id is null;

-- update the person_ext_id
update dibots_v2.ssm_officer so
set
person_ext_id = pp.external_id
from dibots_v2.person_profile pp
where so.person_entity_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and so.person_ext_id is null;

-- update the company_entity_id with ssm_company_no
update dibots_v2.ssm_officer so
set
company_entity_id = ei.dbt_entity_id,
company_ext_id = cp.external_id
from dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where regexp_replace(ei.identifier, '[^0-9]', '', 'g')  = cast(so.ssm_company_no as varchar) and ei.identifier_type = 'REGIST' and cp.dbt_entity_id = ei.dbt_entity_id and cp.country_of_incorporation = 'MYS'
and cp.wvb_entity_type = 'COMP' and so.company_entity_id is null

-- update the company_ext_id
update dibots_v2.ssm_officer so
set
company_ext_id = cp.external_id
from dibots_v2.company_profile cp
where cp.dbt_entity_id = so.company_entity_id and cp.wvb_entity_type = 'COMP' and so.company_ext_id is null;

-- update the person_entity_id, some of them is roc_no
update dibots_v2.ssm_officer so
set
person_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei
where regexp_replace(ei.identifier, '[^0-9]', '', 'g')  = cast(so.ssm_person_id as varchar) and ei.identifier_type = 'REGIST' and so.person_entity_id is null and so.ssm_id_type2 = 'C';

-- update the person_ext_id based on company
update dibots_v2.ssm_officer so
set
person_ext_id = cp.external_id
from dibots_v2.company_profile cp
where cp.dbt_entity_id = so.person_entity_id and cp.wvb_entity_type = 'COMP' and so.person_ext_id is null;

-- update the person_entity_id based on passport and others
update dibots_v2.ssm_officer ssm
set
person_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei
where ssm.person_entity_id is null and ssm.ssm_person_id = ei.identifier and ei.identifier_type in ('PR', 'MK', 'GOVT_ID', 'PASSPORT');

update dibots_v2.ssm_officer a
set
person_entity_id = em.dbt_entity_id,
person_ext_id = em.external_id
from dibots_v2.entity_master em 
where regexp_replace(a.name, '[^A-Za-z0-9]', '', 'g') = regexp_replace(em.display_name, '[^A-Za-z0-9]', '', 'g')
and a.person_entity_id is null;

update dibots_v2.ssm_officer a
set
person_entity_id = em.dbt_entity_id,
person_ext_id = em.external_id
from dibots_v2.entity_master em 
where a.name = em.name
and a.person_entity_id is null;

select count(*) from dibots_v2.ssm_officer where person_entity_id is null;

select * from dibots_v2.ssm_officer where ssm_id_type2 = 'MK' and person_entity_id is null
