--===========================================
-- BURSA MARKETSHARE of some company groups
--===========================================

-- BM_RELATIONSHIP

--drop table dibots_ext.bm_relationship;
create table dibots_ext.bm_relationship (
id int generated by default as identity primary key,
comp_group text,
comp_dbt_id uuid,
comp_ext_id bigint,
account_name text,
ic text,
person_dbt_id uuid,
person_ext_id bigint,
cds_acc bigint,
broker text,
address1 text,
address2 text,
relationship text
);

select * from dibots_ext.bm_relationship

-- cleansing
update dibots_ext.bm_relationship
set
address1 = null
where btrim(address1) = '';

update dibots_ext.bm_relationship
set
address2 = null
where btrim(address2) = '';

update dibots_ext.bm_relationship
set
relationship = null
where btrim(relationship) = '';

-- mapping person

select * from dibots_ext.bm_relationship a
join dibots_v2.entity_identifier b
on regexp_replace(a.ic, '-', '', 'g') = b.identifier 
where b.identifier_type = 'MK' and b.deleted = false

update dibots_ext.bm_relationship a
set
person_dbt_id = b.dbt_entity_id
from dibots_v2.entity_identifier b
where regexp_replace(a.ic, '-', '', 'g') = b.identifier and b.identifier_type = 'MK' and b.deleted = false;

update dibots_ext.bm_relationship a
set
person_ext_id = b.external_id
from dibots_v2.person_profile b
where a.person_dbt_id = b.dbt_entity_id and a.person_dbt_id is not null;

select * from dibots_ext.bm_relationship where person_dbt_id is not null



-- BM_GROUP_TRADE_DETAILS

--drop table dibots_ext.bm_group_trade_details;
create table dibots_ext.bm_group_trade_details (
id int generated by default as identity primary key,
stock_code text,
stock_name text,
product text,
trd_date date,
trd_time time,
session_mode text,
event text,
currency text,
price numeric(25,5),
volume bigint,
adj_volume bigint,
volume_pct numeric(25,15),
value numeric(25,5),
adj_value numeric(25,5),
value_pct numeric(25,15),
vwap numeric(25,15),
price_change int,
last_trade_change numeric(25,5),
last_trade_net_change numeric(25,15),
per_change_from_closing numeric(25,15),
best_bid_price numeric(25,15),
best_ask_price numeric(25,15),
trade_id bigint,
flags text,
buy_order_entry_date date,
buy_entry_time time,
sell_order_entry_date date,
sell_entry_time time,
entry_time_diff time,
buy_order_id text,
sell_order_id text,
buy_broker text,
buy_broker_name text,
sell_broker text,
sell_broker_name text,
buy_trader text,
buy_trader_name text,
sell_trader text,
sell_trader_name text,
buy_client text,
buy_client_name text,
buy_acc text,
sell_acc text,
buyer text,
seller text,
buy_group text,
sell_client text,
sell_client_name text,
sell_syndicate text,
spread_indicator text,
underlying_combo_series_buy text,
underlying_combo_series_sell text,
multi_leg_reporting_type text,
buy_trade_link_id text,
buy_underlying_executed_price numeric(25,15),
buy_underlying_executed_size numeric(25,5),
sell_trade_link_id text,
sell_underlying_executed_price numeric(25,15),
sell_underlying_executed_size numeric(25,5)
);

select * from dibots_ext.bm_group_trade_details;


--==================
-- bm_group_trade
--==================

--drop table dibots_ext.bm_group_trade;
create table dibots_ext.bm_group_trade (
id int generated by default as identity primary key,
comp_group text,
stock_name text,
stock_code text,
event text,
cds_acc bigint,
name text,
broker text,
dealer text,
buy_vol_str text,
sell_vol_str text,
buy_vol numeric(25,5),
sell_vol numeric(25,5)
);

select * from dibots_ext.bm_group_trade;

update dibots_ext.bm_group_trade
set
buy_vol_str = null
where btrim(buy_vol_str) = '';

update dibots_ext.bm_group_trade
set
buy_vol_str = btrim(buy_vol_str);

update dibots_ext.bm_group_trade
set
sell_vol_str = btrim(sell_vol_str);

update dibots_ext.bm_group_trade
set
sell_vol_str = null
where sell_vol_str = '';

select cast(regexp_replace(buy_vol_str, ',', '', 'g') as numeric(25,5)) from dibots_ext.bm_group_trade;

update dibots_ext.bm_group_trade
set
buy_vol = cast(regexp_replace(buy_vol_str, ',', '', 'g') as numeric(25,5));

update dibots_ext.bm_group_trade
set
sell_vol = cast(regexp_replace(sell_vol_str, ',', '', 'g') as numeric(25,5));


select a.stock_name, b.stock_code from dibots_ext.bm_group_trade a, dibots_v2.exchange_daily_transaction b
where a.stock_name = b.stock_name_short and b.transaction_date = '2021-10-12'

update dibots_ext.bm_group_trade a
set
stock_code = b.stock_code
from dibots_v2.exchange_daily_transaction b
where a.stock_name = b.stock_name_short and b.transaction_date = '2021-04-19' and a.stock_code is null;

select * from dibots_ext.bm_group_trade where stock_code is null;

select max(transaction_date) from dibots_v2.exchange_daily_transaction where stock_name_short = 'WZSATU-PR'







--=======================
-- PERSON_RELATIONSHIP 
--=======================

CREATE TABLE dibots_ext.person_relationship (
	dbt_entity_id uuid NOT NULL,
	target_entity_id uuid NOT NULL,
	relationship_type text NOT NULL,
	remarks text NULL,
	created_dtime timestamptz NOT NULL,
	created_by varchar(100) NOT NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	relationship_source text NULL,
	pr_id bigint generated by default as identity,
	deleted bool NULL DEFAULT false,
	previous_dbt_entity_id uuid NULL,
	previous_target_entity_id varchar NULL,
	CONSTRAINT person_relationship_pk PRIMARY KEY (dbt_entity_id, target_entity_id, relationship_type),
	CONSTRAINT person_relationship_un UNIQUE (pr_id)
);

select * from dibots_ext.person_relationship


--================
-- ADDRESS_MASTER
--================

--drop table dibots_ext.address_master;
CREATE TABLE dibots_ext.address_master (
	id bigint generated by default as identity,
	dbt_entity_id uuid null,
	address_type text,
	eff_from_date date,
	eff_end_date date NULL,
	address_line_1 text NULL,
	address_line_2 text NULL,
	address_line_3 text NULL,
	address_line_4 text NULL,
	raw_address text NULL,
	postcode text NULL,
	city text NULL,
	state text NULL,
	state_code varchar(10) NULL,
	country varchar(3) NULL,
	native_address_line_1 text NULL,
	native_address_line_2 text NULL,
	native_address_line_3 text NULL,
	native_address_line_4 text NULL,
	native_city_name text NULL,
	created_dtime timestamptz NULL,
	created_by varchar(100) NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	wvb_handling_code int4 NULL,
	wvb_last_update_dtime timestamptz NULL,
	data_source_id varchar(10) NULL,
	--temp_id uuid NULL,
	"language" text NULL,
	original_eff_from_date timestamp NULL,
	original_eff_end_date timestamp NULL,
	native_postal_code text NULL,
	native_state_province_code text NULL
	--CONSTRAINT address_line_1_length CHECK ((length(address_line_1) <= 200)),
--	CONSTRAINT address_line_2_length CHECK ((length(address_line_2) <= 200)),
--	CONSTRAINT address_line_3_length CHECK ((length(address_line_3) <= 200)),
--	CONSTRAINT address_line_4_length CHECK ((length(address_line_4) <= 200)),
--	CONSTRAINT address_master_comp_un UNIQUE (dbt_entity_id, address_type, original_eff_from_date),
--	CONSTRAINT address_master_pkey PRIMARY KEY (id),
--	CONSTRAINT address_type_length CHECK ((length(address_type) <= 10)),
--	CONSTRAINT city_length CHECK ((length(city) <= 100)),
--	CONSTRAINT language_length CHECK ((length(language) <= 8)),
--	CONSTRAINT native_address_line_1_length CHECK ((length(native_address_line_1) <= 200)),
--	CONSTRAINT native_address_line_2_length CHECK ((length(native_address_line_2) <= 200)),
--	CONSTRAINT native_address_line_3_length CHECK ((length(native_address_line_3) <= 200)),
--	CONSTRAINT native_address_line_4_length CHECK ((length(native_address_line_4) <= 200)),
--	CONSTRAINT native_city_length CHECK ((length(native_city_name) <= 100)),
--	CONSTRAINT postcode_length CHECK ((length(postcode) <= 20)),
--	CONSTRAINT raw_address_length CHECK ((length(raw_address) <= 5000)),
--	CONSTRAINT state_length CHECK ((length(state) <= 80))
	--CONSTRAINT address_data_source_fkey FOREIGN KEY (data_source_id) REFERENCES dibots_v2.ref_data_source("source"),
	--CONSTRAINT address_master_address_type_fkey FOREIGN KEY (address_type) REFERENCES dibots_v2.ref_address_types(address_type),
	--CONSTRAINT address_master_country_fkey FOREIGN KEY (country) REFERENCES dibots_v2.ref_country_iso(country_iso_code),
	--CONSTRAINT address_master_dbt_entity_id_fkey FOREIGN KEY (dbt_entity_id) REFERENCES dibots_v2.entity_master(dbt_entity_id)
);

select * from dibots_ext.address_master;





select * from dibots_ext.bm_relationship


select distinct comp_group, account_name from dibots_ext.bm_relationship order by comp_group

select distinct person_dbt_id, address1, address2 from dibots_ext.bm_relationship


--=======================
-- ADDRESS_MASTER_COMMON
--=======================

CREATE TABLE dibots_ext.address_master_common (
	id bigint generated by default as identity,
	dbt_entity_id uuid null,
	address_line_1 text NULL,
	address_line_2 text NULL,
	address_line_3 text NULL,
	address_line_4 text NULL,
	raw_address text NULL,
	postcode text NULL,
	city text NULL,
	state text NULL,
	state_code varchar(10) NULL,
	country varchar(3) NULL,
	created_dtime timestamptz NULL,
	created_by varchar(100) NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	wvb_handling_code int4 NULL,
	wvb_last_update_dtime timestamptz NULL,
	data_source_id varchar(10) NULL,
	"language" text NULL
);

select * from dibots_ext.address_master_common;

--insert into dibots_ext.address_master_common (dbt_entity_id, address_line_1, address_line_2, address_line_3, address_line_4, raw_address, postcode, city, state, state_code, country, created_dtime, created_by, modified_dtime, modified_by,
wvb_handling_code, wvb_last_update_dtime, data_source_id, language)
select dbt_entity_id, address_line_1, address_line_2, address_line_3, address_line_4, raw_address, postcode, city, state, state_code, country, created_dtime, created_by, modified_dtime, modified_by,
wvb_handling_code, wvb_last_update_dtime, data_source_id, language
from dibots_ext.address_master;



--======================
-- GROUP_ENTITY_TABLE
--======================

create table dibots_ext.group_entity_table (
id bigint generated by default as identity primary key,
group_name text,
person_name text,
person_dbt_id uuid,
person_ext_id bigint,
remarks text,
data_source text
);

select * from dibots_ext.group_entity_table;

select distinct comp_group, account_name, person_dbt_id, person_ext_id, relationship from dibots_ext.bm_relationship

--insert into dibots_ext.group_entity_table (group_name, person_name, person_dbt_id, person_ext_id, remarks, data_source)
select distinct comp_group, account_name, person_dbt_id, person_ext_id, relationship, 'bursa' from dibots_ext.bm_relationship




--===================
-- ENTITY_CDS_ACC
--===================

CREATE table dibots_ext.entity_cds_acc (
id bigint generated by default as identity primary key,
person_name text,
person_dbt_id uuid,
person_ext_id bigint,
cds_acc bigint,
broker_name text,
broker_dbt_id uuid,
broker_ext_id bigint
);

select * from dibots_ext.entity_cds_acc;

--insert into dibots_ext.entity_cds_acc (cds_acc, person_name, broker_name)
select distinct cds_acc, name, broker from dibots_ext.bm_group_trade;


select * from dibots_ext.bm_relationship


update dibots_ext.entity_cds_acc a
set
person_dbt_id = b.person_dbt_id,
person_ext_id = b.person_ext_id
from dibots_ext.bm_relationship b
where a.person_name = b.account_name;

select * from dibots_ext.entity_cds_acc where person_dbt_id is null

select a.broker_name, b.participant_name, b.dbt_entity_id, b.external_id from dibots_ext.entity_cds_acc a, dibots_v2.broker_profile b
where lower(b.participant_name) like concat(substring(lower(a.broker_name), 1,5), '%') and b.eff_end_date is null and b.is_deleted = false

update dibots_ext.entity_cds_acc a
set
broker_dbt_id = b.dbt_entity_id,
broker_ext_id = b.external_id
from dibots_v2.broker_profile b
where lower(b.participant_name) like concat(substring(lower(a.broker_name), 1,5), '%') and a.broker_dbt_id is null and b.eff_end_date is null and b.is_deleted = false;

select * from dibots_ext.entity_cds_acc where broker_dbt_id is null;


--============
-- ROC5
--============

select regexp_replace(ic, '-', '', 'g') from (
select distinct(ic) from dibots_ext.bm_relationship) a

('680709015149','730727045256','730325025631','771116125434','570825106091','790101085533','620914086435','720707085024','620929055674','910722105510')


create table dibots_ext.roc5_subset (
id int generated by default as identity primary key,
company_no bigint,
comp_dbt_id uuid,
comp_ext_id bigint,
id_type text,
person_mk text,
person_dbt_id uuid,
person_ext_id bigint,
person_name text,
birth_date date,
address1 text,
address2 text,
address3 text,
postcode text,
town text,
state text,
designation_code text,
start_date date,
end_date date,
year int,
filename text,
filepath text,
row_no int,
office_start date,
feed_date date
);

select * from dibots_ext.roc5_subset

select * from dibots_ext.roc5_subset a, dibots_ext.bm_relationship b
where a.person_mk = regexp_replace(b.ic, '-', '', 'g')


update dibots_ext.roc5_subset a
set
person_dbt_id = b.person_dbt_id,
person_ext_id = b.person_ext_id
from dibots_ext.bm_relationship b
where a.person_mk = regexp_replace(b.ic, '-', '', 'g')


select * from dibots_ext.roc5_subset a, dibots_v2.entity_identifier b
where cast(a.company_no as text) = b.identifier and b.identifier_type = 'REGIST' and b.deleted = false

select * from dibots_ext.roc5_subset c, (
select a.dbt_entity_id, b.external_id, split_part(a.identifier, '-', 1) as comp_no from dibots_v2.entity_identifier a, dibots_v2.company_profile b
where a.dbt_entity_id = b.dbt_entity_id and b.country_of_incorporation = 'MYS' and  a.identifier_type = 'REGIST') d
where cast(c.company_no as text) = d.comp_no;

--============
-- roc6
--============

--drop table dibots_ext.roc6_subset;
create table dibots_ext.roc6_subset (
id int generated by default as identity primary key,
comp_no text,
id_type text,
person_mk text,
person_dbt_id uuid,
person_ext_id bigint,
person_name text,
address1 text,
address2 text,
address3 text,
postcode text,
town text,
state_code text,
birth_date date,
shares numeric(25,3),
filename text,
filepath text,
year int,
row_no int,
row_to int,
share_no int,
pct_of_shares numeric(25,3),
total_shares bigint,
feed_date date
);

select * from dibots_ext.roc6_subset;

select * from dibots_ext.roc6_subset a, dibots_v2.entity_identifier b
where a.person_mk = b.identifier and b.identifier_type = 'MK' and b.deleted = false

update dibots_ext.roc6_subset a
set
person_dbt_id = b.dbt_entity_id
from dibots_v2.entity_identifier b
where a.person_mk = b.identifier and b.identifier_type = 'MK' and b.deleted = false

select * from dibots_ext.roc6_subset where person_dbt_id is null;

update dibots_ext.roc6_subset a
set
person_ext_id = b.external_id
from dibots_v2.person_profile b
where a.person_dbt_id = b.dbt_entity_id
