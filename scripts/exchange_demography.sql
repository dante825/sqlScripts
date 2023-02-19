--=============================================================
--Creating tables derived from exchange_trade_demography table
--=============================================================

select * from dibots_v2.exchange_trade_demography;

--update the investor_type_custom column
update dibots_v2.exchange_trade_demography
set investor_type_custom = 'INSTITUTIONAL'
where investor_type in ('INSTITUTIONAL', 'NOMINEES') and investor_type_custom is null;

update dibots_v2.exchange_trade_demography
set investor_type_custom = 'RETAIL'
where investor_type = 'RETAIL' and investor_type_custom is null;

update dibots_v2.exchange_trade_demography 
set
locality_new = CASE WHEN intraday_account_type <> 'OTHERS' THEN 'PROPRIETARY'
WHEN intraday_account_type = 'OTHERS' THEN locality END,
group_type = CASE WHEN intraday_account_type <> 'OTHERS' THEN intraday_account_type
WHEN intraday_account_type = 'OTHERS' THEN investor_type END


--============================================
-- exchange_demography_broker_age_band
--============================================

select trading_date, participant_code, participant_name, sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_buysell_volume, 
sum(gross_traded_value_buy + gross_traded_value_sell) as total_buysell_value, dibots_age_band
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'RETAIL' and participant_code = 12 and trading_date between '2020-01-20' and '2020-02-20'
group by trading_date, participant_code, participant_name, dibots_age_band


drop table dibots_v2.exchange_demography_broker_age_band;
create table dibots_v2.exchange_demography_broker_age_band (
id serial primary key,
trading_date date,
week_count varchar(10),
year int,
month int,
external_id int,
participant_code int,
participant_name varchar,
total_buysell_volume bigint,
total_buysell_value numeric(32,6),
age_band varchar(100),
male_count int,
female_count int,
na_gender_count int,
intraday_volume bigint,
intraday_value numeric(25,3)
);

create index exchange_demography_broker_age_band_trading_date_idx on dibots_v2.exchange_demography_broker_age_band (trading_date);
create index exchange_demography_broker_age_band_ext_id_idx on dibots_v2.exchange_demography_broker_age_band (external_id);
create index exchange_demography_broker_age_band_week_idx on dibots_v2.exchange_demography_broker_age_band (week_count);
create index exchange_demography_broker_age_band_year_idx on dibots_v2.exchange_demography_broker_age_band (year);
create index exchange_demography_broker_age_band_month_idx on dibots_v2.exchange_demography_broker_age_band (month);
ALTER TABLE dibots_v2.exchange_demography_broker_age_band ADD CONSTRAINT ed_broker_age_band_uniq UNIQUE (trading_date, participant_code, age_band)

insert into dibots_v2.exchange_demography_broker_age_band (trading_date, week_count, year, month, external_id, participant_code, participant_name, total_buysell_volume, 
total_buysell_value, age_band, intraday_volume, intraday_value)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), external_id, 
participant_code, participant_name, sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_buysell_volume, 
sum(gross_traded_value_buy + gross_traded_value_sell), dibots_age_band, sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, external_id, participant_code, participant_name, dibots_age_band;

update dibots_v2.exchange_demography_broker_age_band a
set
male_count = b.cnt
from (
select trading_date, participant_code, dibots_age_band, count(*) as cnt 
from dibots_v2.exchange_demography 
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'MALE'
group by trading_date, participant_code, dibots_age_band) b
where a.trading_date = b.trading_date and a.age_band = b.dibots_age_band and a.participant_code = b.participant_code;

update dibots_v2.exchange_demography_broker_age_band a
set
female_count = b.cnt
from (select trading_date, participant_code, dibots_age_band, count(*) as cnt from dibots_v2.exchange_demography 
where gender = 'FEMALE' and locality_new = 'LOCAL' and group_type = 'RETAIL' group by trading_date, participant_code, dibots_age_band) b
where a.trading_date = b.trading_date and a.age_band = b.dibots_age_band and a.participant_code = b.participant_code;

update dibots_v2.exchange_demography_broker_age_band a
set
na_gender_count = b.cnt
from (select trading_date, participant_code, dibots_age_band, count(*) as cnt from dibots_v2.exchange_demography 
where gender = 'GENDER NOT AVAILABLE' and locality_new = 'LOCAL' and group_type = 'RETAIL' group by trading_date, participant_code, dibots_age_band) b
where a.trading_date = b.trading_date and a.age_band = b.dibots_age_band and a.participant_code = b.participant_code;

select age_band, sum(total_buysell_volume), sum(total_buysell_value) 
from dibots_v2.exchange_demography_broker_age_band
where trading_date between '2020-02-20' and '2020-03-20' and participant_code = 12
group by age_band;

--===============================================
-- exchange_demography_broker_nationality
--===============================================

select trading_date, participant_code, external_id, participant_name, nationality, sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_value_buy + gross_traded_value_sell)
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and trading_date between '2020-05-25' and '2020-08-25'
group by trading_date, participant_code, external_id, participant_name, nationality

create table dibots_v2.exchange_demography_broker_nationality (
trading_date date,
week_count varchar(10),
year int,
month int,
participant_code int,
external_id int,
participant_name varchar(255),
nationality varchar(10),
total_traded_volume bigint,
total_traded_value numeric(32,5),
intraday_volume bigint,
intraday_value numeric(25,3)
);

alter table dibots_v2.exchange_demography_broker_nationality add constraint ed_broker_nationality_pkey primary key (trading_date, participant_code, nationality);
create index ed_nationality_broker_code_idx on dibots_v2.exchange_demography_broker_nationality (external_id);
create index ed_nationality_broker_week_idx on dibots_v2.exchange_demography_broker_nationality (week_count);
create index ed_nationality_broker_year_idx on dibots_v2.exchange_demography_broker_nationality (year);
create index ed_nationality_broker_month_idx on dibots_v2.exchange_demography_broker_nationality (month);

insert into dibots_v2.exchange_demography_broker_nationality (trading_date, week_count, year, month, participant_code, external_id, participant_name, nationality, 
total_traded_volume, total_traded_value, intraday_volume, intraday_value)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), participant_code, 
external_id, participant_name, nationality, sum(gross_traded_volume_buy + gross_traded_volume_sell), 
sum(gross_traded_value_buy + gross_traded_value_sell), sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN'
group by trading_date, participant_code, external_id, participant_name, nationality


--=========================================
-- exchange_demography_broker_stats
--=========================================

--drop table dibots_v2.exchange_demography_broker_stats;
create table dibots_v2.exchange_demography_broker_stats (
id serial primary key,
trading_date date,
participant_code int,
external_id int,
participant_name varchar,
locality varchar(20),
group_type varchar(20),
trades_count int,
total_traded_value numeric(25,6),
net_traded_value numeric(25,6),
min_traded_value_buy numeric(25,6),
min_traded_value_sell numeric(25,6),
max_traded_value_buy numeric(25,6),
max_traded_value_sell numeric(25,6),
total_intraday_vol bigint,
total_intraday_val numeric(25,2),
min_intraday_vol bigint,
min_intraday_val numeric(25,2),
max_intraday_vol bigint,
max_intraday_val numeric(25,2)
);

CREATE INDEX ed_broker_stats_trading_date_idx ON dibots_v2.exchange_demography_broker_stats (trading_date);
CREATE INDEX ed_broker_stats_stock_code_idx ON dibots_v2.exchange_demography_broker_stats (participant_code);
ALTER TABLE dibots_v2.exchange_demography_broker_stats ADD CONSTRAINT ed_broker_stats_uniq UNIQUE (trading_date, participant_code, locality, group_type)

insert into dibots_v2.exchange_demography_broker_stats (trading_date, participant_code, external_id, participant_name, locality, group_type, 
trades_count, total_traded_value, net_traded_value, min_traded_value_buy, min_traded_value_sell, max_traded_value_buy, max_traded_value_sell,
total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, participant_code, external_id, participant_name, locality_new, group_type, count(*) as trades_count, sum(gross_traded_value_buy + gross_traded_value_sell) as total_traded_value,
sum(gross_traded_value_buy - gross_traded_value_sell) as net_traded_value,
min(nullif(gross_traded_value_buy,0)) as min_traded_value_buy, min(nullif(gross_traded_value_sell,0)) as min_traded_value_sell, max(gross_traded_value_buy) as max_traded_value_buy, 
max(gross_traded_value_sell) as max_traded_value_sell, 
sum(intraday_volume), sum(intraday_value), min(intraday_volume), min(intraday_value), max(intraday_volume), max(intraday_value)
from dibots_v2.exchange_demography
group by trading_date, participant_code, external_id, participant_name, locality_new, group_type;


--=======================================
-- exchange_demography_nationality
--=======================================

drop table dibots_v2.exchange_demography_nationality;
create table dibots_v2.exchange_demography_nationality (
id int generated always as identity primary key,
trading_date date,
week_count varchar(10),
year int,
month int,
stock_code varchar(20),
stock_name varchar(100),
stock_num int,
total_buysell_volume bigint,
total_buysell_value numeric(32,6),
nationality varchar,
intraday_volume bigint,
intraday_value numeric(25,3)
);

ALTER TABLE dibots_v2.exchange_demography_nationality ADD CONSTRAINT ed_nationality_uniq UNIQUE (trading_date, stock_code, nationality);
create index exchange_demography_nationality_trading_date_idx on dibots_v2.exchange_demography_nationality (trading_date);
create index exchange_demography_nationality_stock_code_idx on dibots_v2.exchange_demography_nationality (stock_code);
create index exchange_demography_nationality_week_idx on dibots_v2.exchange_demography_nationality (week_count);
create index exchange_demography_nationality_year_idx on dibots_v2.exchange_demography_nationality (year);
create index exchange_demography_nationality_month_idx on dibots_v2.exchange_demography_nationality (month);

insert into dibots_v2.exchange_demography_nationality (trading_date, week_count, year, month, stock_code, stock_name, stock_num, total_buysell_volume, total_buysell_value, 
nationality, intraday_volume, intraday_value)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), stock_code, stock_name, stock_num,
sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_buysell_volume, 
sum(gross_traded_value_buy + gross_traded_value_sell), nationality, sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN'
group by trading_date, stock_code, stock_name, stock_num, nationality;

--================================
-- exchange_demography_stats
--================================

select trading_date, stock_code, stock_name,  locality, group_type, count(*) as trades_count, sum(gross_traded_value_buy + gross_traded_value_sell) as total_traded_value,
min(nullif(gross_traded_value_buy,0)) as min_traded_value_buy, min(nullif(gross_traded_value_sell,0)) as min_traded_value_sell, max(gross_traded_value_buy) as max_traded_value_buy, max(gross_traded_value_sell) as max_traded_value_sell
from dibots_v2.exchange_demography
where group_type in ('INSTITUTIONAL', 'RETAIL') and stock_code = '0001' and trading_date between '2020-01-01' and '2020-01-10'
group by trading_date, stock_code, stock_name, locality, group_type

--drop table dibots_v2.exchange_demography_stats;
create table dibots_v2.exchange_demography_stats (
id serial primary key,
trading_date date,
stock_code varchar(20),
stock_name varchar(100),
stock_num int,
locality varchar(20),
group_type varchar(20),
trades_count int,
total_traded_value numeric(25,6),
net_traded_value numeric(25,6),
min_traded_value_buy numeric(25,6),
min_traded_value_sell numeric(25,6),
max_traded_value_buy numeric(25,6),
max_traded_value_sell numeric(25,6),
total_intraday_vol bigint,
total_intraday_val numeric(25,2),
min_intraday_vol bigint,
min_intraday_val numeric(25,2),
max_intraday_vol bigint,
max_intraday_val numeric(25,2)
);

CREATE INDEX ed_stats_trading_date_idx ON dibots_v2.exchange_demography_stats (trading_date);
CREATE INDEX ed_stats_stock_code_idx ON dibots_v2.exchange_demography_stats (stock_code);
ALTER TABLE dibots_v2.exchange_demography_stats add constraint ed_stats_uniq unique (trading_date, stock_code, locality, group_type);

insert into dibots_v2.exchange_demography_stats (trading_date, stock_code, stock_name, stock_num, locality, group_type, trades_count, total_traded_value, net_traded_value,
min_traded_value_buy, min_traded_value_sell, max_traded_value_buy, max_traded_value_sell, 
total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, stock_code, stock_name, stock_num, locality_new, group_type, count(*) as trades_count, sum(gross_traded_value_buy + gross_traded_value_sell) as total_traded_value,
sum(gross_traded_value_buy - gross_traded_value_sell) as net_traded_value,
min(nullif(gross_traded_value_buy,0)) as min_traded_value_buy, min(nullif(gross_traded_value_sell,0)) as min_traded_value_sell, 
max(gross_traded_value_buy) as max_traded_value_buy, max(gross_traded_value_sell) as max_traded_value_sell
sum(intraday_volume), sum(intraday_value), min(intraday_volume), min(intraday_value), max(intraday_volume), max(intraday_value)
from dibots_v2.exchange_demography
group by trading_date, stock_code, stock_name, stock_num, locality_new, group_type;

select * from dibots_v2.exchange_demography_stats;

select stock_code, stock_name, locality, group_type, sum(trades_count) as trades_count, sum(total_traded_value) as total_traded_value, sum(net_traded_value) as total_net_traded_value,
min(min_traded_value_buy) as min_traded_value_buy, min(min_traded_value_sell) as min_traded_value_sell, max(max_traded_value_buy) as max_traded_value_buy, max(max_traded_value_sell) as max_traded_value_sell,
(sum(total_traded_value) / sum(trades_count)) as avg_traded_value
from dibots_v2.exchange_demography_stats
where trading_date between '2020-02-01' and '2020-04-30' and stock_code = '5285'
group by stock_code, locality, group_type


--=======================================
-- exchange_demography_stock_broker
--=======================================

--  A PARTITIONED TABLE, CREATION SCRIPT REFER TO exchange_demography_partitioned_tables.sql

insert into dibots_v2.exchange_demography_stock_broker (trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality, group_type,
buy_volume, sell_volume, volume, net_volume, buy_value, sell_value, value, net_value, intraday_volume, intraday_value, klci_flag, fbm100_flag, shariah_flag)
select trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality_new, group_type,
sum(gross_traded_volume_buy), sum(gross_traded_volume_sell), sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_volume_buy - gross_traded_volume_sell),
sum(gross_traded_value_buy), sum(gross_traded_value_sell), sum(gross_traded_value_buy + gross_traded_value_sell), sum(gross_traded_value_buy - gross_traded_value_sell), 
sum(intraday_volume), sum(intraday_value), klci_flag, fbm100_flag, shariah_flag
from dibots_v2.exchange_demography
group by trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag;

--========================================
-- exchange_demography_stock_broker_group
--=======================================

--  A PARTITIONED TABLE, CREATION SCRIPT REFER TO exchange_demography_partitioned_tables.sql

insert into dibots_v2.exchange_demography_stock_broker_group (trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, 
participant_name, total_volume, total_value, klci_flag, fbm100_flag, shariah_flag, total_intraday_vol, total_intraday_val, buy_vol, buy_val, sell_vol, sell_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, 
sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_value_buy + gross_traded_value_sell), klci_flag, fbm100_flag, shariah_flag,
sum(intraday_volume), sum(intraday_value), sum(gross_traded_volume_buy), sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell)
from dibots_v2.exchange_demography
group by trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, klci_flag, fbm100_flag, shariah_flag;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_volume = tmp.vol,
local_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_volume = tmp.vol,
foreign_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
prop_volume = tmp.vol,
prop_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'PROPRIETARY' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
total_inst_volume = tmp.vol,
total_inst_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'INSTITUTIONAL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_inst_volume = tmp.vol,
local_inst_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_inst_volume = tmp.vol,
foreign_inst_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
total_retail_volume = tmp.vol,
total_retail_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'RETAIL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_retail_volume = tmp.vol,
local_retail_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'RETAIL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_retail_volume = tmp.vol,
foreign_retail_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'RETAIL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
total_nominees_volume = tmp.vol,
total_nominees_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'NOMINEES' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_nominees_volume = tmp.vol,
local_nominees_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'NOMINEES' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_nominees_volume = tmp.vol,
foreign_nominees_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'NOMINEES' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
ivt_volume = tmp.vol,
ivt_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'IVT' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
pdt_volume = tmp.vol,
pdt_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'PDT' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_volume = tmp.vol,
net_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_local_volume = tmp.vol,
net_local_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;


update dibots_v2.exchange_demography_stock_broker_group a
set
net_foreign_volume = tmp.vol,
net_foreign_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_prop_volume = tmp.vol,
net_prop_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'PROPRIETARY'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_inst_volume = tmp.vol,
net_inst_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_retail_volume = tmp.vol,
net_retail_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_nominees_volume = tmp.vol,
net_nominees_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_ivt_volume = tmp.vol,
net_ivt_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'IVT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_pdt_volume = tmp.vol,
net_pdt_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'PDT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_local_inst_vol = tmp.vol,
net_local_inst_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_foreign_inst_vol = tmp.vol,
net_foreign_inst_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_local_retail_vol = tmp.vol,
net_local_retail_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'RETAIL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_foreign_retail_vol = tmp.vol,
net_foreign_retail_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'RETAIL' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_local_nominees_vol = tmp.vol,
net_local_nominees_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'NOMINEES' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_foreign_nominees_vol = tmp.vol,
net_foreign_nominees_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'NOMINEES' 
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_intraday_vol = tmp.vol,
local_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_intraday_vol = tmp.vol,
foreign_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
inst_intraday_vol = tmp.vol,
inst_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_inst_intraday_vol = tmp.vol,
local_inst_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_inst_intraday_vol = tmp.vol,
foreign_inst_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
retail_intraday_vol = tmp.vol,
retail_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_retail_intraday_vol = tmp.vol,
local_retail_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_retail_intraday_vol = tmp.vol,
foreign_retail_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
nominees_intraday_vol = tmp.vol,
nominees_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_nominees_intraday_vol = tmp.vol,
local_nominees_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_nominees_intraday_vol = tmp.vol,
foreign_nominees_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
ivt_intraday_vol = tmp.vol,
ivt_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where group_type = 'IVT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
pdt_intraday_vol = tmp.vol,
pdt_intraday_val = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_demography
where group_type = 'PDT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

--===================================================
-- exchange_demography_stock_broker_stats
--===================================================

select trading_date, stock_code, participant_code, participant_name, locality_new, group_type, count(*) as numTrades, COALESCE(min(nullif(gross_traded_volume_buy,0)),0) AS min_vol_buy,
COALESCE(max(nullif(gross_traded_volume_buy,0)),0) AS max_vol_buy, COALESCE(min(nullif(gross_traded_volume_sell,0)),0) as min_vol_sell, COALESCE(max(nullif(gross_traded_volume_sell,0)),0) as max_vol_sell,
sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_buysell_volume,
COALESCE(min(nullif(gross_traded_value_buy,0)),0) as min_val_buy, COALESCE(max(nullif(gross_traded_value_buy,0)),0) AS max_val_buy, COALESCE(min(nullif(gross_traded_value_sell,0)),0) as min_val_sell,
COALESCE(max(nullif(gross_traded_value_sell,0)),0) as max_val_sell, sum(gross_traded_value_buy + gross_traded_value_sell) as total_buysell_value
from dibots_v2.exchange_demography
where stock_code = '6399' and trading_date between '2020-01-20' and '2020-02-20' and group_type in ('INSTITUTIONAL', 'RETAIL')
group by trading_date, stock_code, participant_code,participant_name, locality_new, group_type

--drop table dibots_v2.exchange_demography_stock_broker_stats;
create table dibots_v2.exchange_demography_stock_broker_stats (
id serial primary key,
trading_date date,
stock_code varchar(20),
stock_name varchar(100),
stock_num int,
participant_code int, 
participant_name varchar(255),
locality varchar(20),
group_type varchar(20),
trade_count int, 
min_traded_value_buy numeric(25,6),
max_traded_value_buy numeric(25,6),
min_traded_value_sell numeric(25,6),
max_traded_value_sell numeric(25,6),
total_buysell_value numeric(25,6),
net_buysell_value numeric(25,6),
total_intraday_vol bigint,
total_intraday_val numeric(25,2),
min_intraday_vol bigint,
min_intraday_val numeric(25,2),
max_intraday_vol bigint,
max_intraday_val numeric(25,2)
);

CREATE INDEX ed_sb_stats_stock_code_idx on dibots_v2.exchange_demography_stock_broker_stats(stock_code);
CREATE INDEX ed_sb_participant_code_idx on dibots_v2.exchange_demography_stock_broker_stats(participant_code);
CREATE INDEX ed_sb_trading_date_idx on dibots_v2.exchange_demography_stock_broker_stats(trading_date);
CREATE INDEX ed_sb_locality_idx on dibots_v2.exchange_demography_stock_broker_stats(locality);
CREATE INDEX ed_sb_group_type_idx on dibots_v2.exchange_demography_stock_broker_stats(group_type);
ALTER TABLE dibots_v2.exchange_demography_stock_broker_stats add constraint ed_sb_stats_uniq unique (trading_date, stock_code, participant_code, locality, group_type);

insert into dibots_v2.exchange_demography_stock_broker_stats (trading_date, stock_code, stock_name, stock_num, participant_code, participant_name, locality, group_type,
trade_count, min_traded_value_buy, max_traded_value_buy, min_traded_value_sell, max_traded_value_sell, total_buysell_value, net_buysell_value,
total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, stock_code, stock_name, stock_num, participant_code, participant_name, locality_new, group_type, count(*),
COALESCE(min(nullif(gross_traded_value_buy,0)),0) as min_val_buy, COALESCE(max(nullif(gross_traded_value_buy,0)),0) AS max_val_buy, COALESCE(min(nullif(gross_traded_value_sell,0)),0) as min_val_sell,
COALESCE(max(nullif(gross_traded_value_sell,0)),0) as max_val_sell, sum(gross_traded_value_buy + gross_traded_value_sell) as total_buysell_value, sum(gross_traded_value_buy - gross_traded_value_sell) as net_buysell_value,
sum(intraday_volume), sum(intraday_value), min(intraday_volume), min(intraday_value), max(intraday_volume), max(intraday_value)
from dibots_v2.exchange_demography
group by trading_date, stock_code,stock_name, stock_num, participant_code, participant_name, locality_new, group_type;

select stock_code, stock_name, participant_code, participant_name, locality, group_type, sum(trade_count) as total_trade, 
coalesce(min(nullif(min_traded_value_buy,0)),0) as min_traded_value_buy, coalesce(max(nullif(max_traded_value_buy,0)),0) as max_traded_value_buy,
coalesce(min(nullif(min_traded_value_sell,0)),0) as min_traded_value_sell, coalesce(max(nullif(max_traded_value_sell,0)),0) as max_traded_value_sell,
sum(total_buysell_value) as total_buysell_value, sum(net_buysell_value) as net_buysell_value, sum(total_buysell_value) / sum (trade_count) as avg_traded_value
from dibots_v2.exchange_demography_stock_broker_stats
where stock_code = '6399' and trading_date between '2020-02-20' and '2020-04-30' and participant_code = '12'
group by stock_code, stock_name, participant_code, participant_name, locality, group_type

--======================================
-- exchange_demography_stock_movement
--======================================

--drop table dibots_v2.exchange_demography_stock_movement;
create table dibots_v2.exchange_demography_stock_movement (
id bigint generated always as identity primary key,
trading_date date,
week_count varchar(10),
year int,
month int,
stock_code varchar(20),
stock_name varchar(255),
stock_num int,
board varchar(255),
sector varchar(255),
locality varchar(20),
group_type varchar(20),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
buy_volume bigint,
sell_volume bigint,
volume bigint,
net_volume bigint,
buy_value numeric(25,3),
sell_value numeric(25,3),
value numeric(25,3),
net_value numeric(25,3),
intraday_volume bigint,
intraday_value numeric(25,3),
total_investors int
);

alter table dibots_v2.exchange_demography_stock_movement add constraint ed_stock_movement_uniq unique (trading_date, stock_code, locality, group_type);

create unique index ed_stock_movement_2_uniq on dibots_v2.exchange_demography_stock_movement (trading_date, stock_num, locality, group_type);
create index ed_stock_movement_trading_date_idx on dibots_v2.exchange_demography_stock_movement(trading_date);
create index ed_stock_moveement_week_idx on dibots_v2.exchange_demography_stock_movement(week_count);
create index ed_stock_moveement_year_idx on dibots_v2.exchange_demography_stock_movement(year);
create index ed_stock_moveement_month_idx on dibots_v2.exchange_demography_stock_movement(month);
create index ed_stock_moveement_year_month_idx on dibots_v2.exchange_demography_stock_movement(year, month);
create index ed_stock_movement_stock_code_idx on dibots_v2.exchange_demography_stock_movement(stock_code);
create index ed_stock_movement_board_idx on dibots_v2.exchange_demography_stock_movement(board);
create index ed_stock_movement_sector_idx on dibots_v2.exchange_demography_stock_movement(sector);

insert into dibots_v2.exchange_demography_stock_movement (trading_date, week_count, year, month, stock_code, stock_name, stock_num, board, sector, 
locality, group_type, klci_flag, fbm100_flag, shariah_flag,
buy_volume, sell_volume, volume, net_volume, buy_value, sell_value, value, net_value, intraday_volume, intraday_value)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), 
stock_code, stock_name, stock_num, board, sector, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag,
sum(gross_traded_volume_buy), sum(gross_traded_volume_sell), sum(gross_traded_volume_buy + gross_traded_volume_sell), 
sum(gross_traded_volume_buy - gross_traded_volume_sell), sum(gross_traded_value_buy),
sum(gross_traded_value_sell), sum(gross_traded_value_buy + gross_traded_value_sell), sum(gross_traded_value_buy - gross_traded_value_sell),
sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_demography
group by trading_date, stock_code, stock_name, stock_num, board, sector, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag;

update dibots_v2.exchange_demography_stock_movement a
set
total_investors = b.inv
from 
(select trading_date, stock_code, locality_new, group_type, sum(total_investors) as inv, sum(total_traded_volume), sum(total_traded_value)
from dibots_v2.exchange_investor_stock_stats
--where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_movement)
group by trading_date, stock_code, locality_new, group_type) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.locality = b.locality_new and a.group_type = b.group_type;

--========================================
-- exchange_demography_stock_week
--========================================

--  A PARTITIONED TABLE, CREATION SCRIPT REFER TO exchange_demography_partitioned_tables.sql

insert into dibots_v2.exchange_demography_stock_week (trading_date, week_count, stock_code, stock_name, stock_num, net_inst_vol, net_inst_val, net_local_inst_vol, 
net_local_inst_val,	net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, 
net_foreign_retail_val, net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, 
net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, total_intraday_vol, total_intraday_val, 
local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, 
local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, local_retail_intraday_vol, 
local_retail_intraday_val, foreign_retail_intraday_vol, foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, local_nominees_intraday_vol, 
local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, ivt_intraday_vol, ivt_intraday_val, pdt_intraday_vol, pdt_intraday_val,
total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val, inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, 
retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, nominees_vol, nominees_val, local_nominees_vol, local_nominees_val,
foreign_nominees_vol, foreign_nominees_val, ivt_vol, ivt_val, pdt_vol, pdt_val)
select trading_date, to_char(trading_date, 'IYYY-IW'), stock_code, stock_name, stock_num, sum(net_inst_volume), sum(net_inst_value), 
sum(net_local_inst_vol), sum(net_local_inst_val), sum(net_foreign_inst_vol), sum(net_foreign_inst_val), sum(net_retail_volume), sum(net_retail_value), 
sum(net_local_retail_vol), sum(net_local_retail_val), sum(net_foreign_retail_vol), sum(net_foreign_retail_val), sum(net_nominees_volume), sum(net_nominees_value), 
sum(net_local_nominees_vol), sum(net_local_nominees_val), sum(net_foreign_nominees_vol), sum(net_foreign_nominees_val), sum(net_ivt_volume), sum(net_ivt_value), 
sum(net_pdt_volume), sum(net_pdt_value), sum(net_local_volume), sum(net_local_value), sum(net_foreign_volume), sum(net_foreign_value),
sum(total_intraday_vol), sum(total_intraday_val), sum(local_intraday_vol), sum(local_intraday_val), sum(foreign_intraday_vol), sum(foreign_intraday_val), 
sum(inst_intraday_vol), sum(inst_intraday_val), sum(local_inst_intraday_vol), sum(local_inst_intraday_val), sum(foreign_inst_intraday_vol), 
sum(foreign_inst_intraday_val), sum(retail_intraday_vol), sum(retail_intraday_val), sum(local_retail_intraday_vol), sum(local_retail_intraday_val), 
sum(foreign_retail_intraday_vol), sum(foreign_retail_intraday_val), sum(nominees_intraday_vol), sum(nominees_intraday_val), sum(local_nominees_intraday_vol), 
sum(local_nominees_intraday_val), sum(foreign_nominees_intraday_vol), sum(foreign_nominees_intraday_val), sum(ivt_intraday_vol), sum(ivt_intraday_val), 
sum(pdt_intraday_vol), sum(pdt_intraday_val), 
sum(total_volume), sum(total_value), sum(local_volume), sum(local_value), sum(foreign_volume), sum(foreign_value), sum(total_inst_volume), sum(total_inst_value),
sum(local_inst_volume), sum(local_inst_value), sum(foreign_inst_volume), sum(foreign_inst_value), sum(total_retail_volume), sum(total_retail_value), 
sum(local_retail_volume), sum(local_retail_value), sum(foreign_retail_volume), sum(foreign_retail_value), sum(total_nominees_volume), sum(total_nominees_value),
sum(local_nominees_volume), sum(local_nominees_value), sum(foreign_nominees_volume), sum(foreign_nominees_value), sum(ivt_volume), sum(ivt_value),
sum(pdt_volume), sum(pdt_value)
from dibots_v2.exchange_demography_stock_broker_group
group by trading_date, stock_code, stock_name, stock_num;

update dibots_v2.exchange_demography_stock_week a 
set
board = b.board,
sector = b.sector,
klci_flag = b.klci_flag,
fbm100_flag = b.fbm100_flag,
shariah_flag = b.shariah_flag
from dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code;

--=======================================
-- exchange_demography_stock_cum_net_val
--=======================================

-- DEPRECATED
-- fresh insertion
-- insert the trading_date and stock_code from exchange_daily_transaction to avoid the problem where there's no trading for a stock in demography table

insert into dibots_v2.exchange_demography_stock_cum_net_val (trading_date, stock_code, stock_num, day)
select transaction_date, stock_code, stock_num, 1 from dibots_v2.exchange_daily_transaction where transaction_date = '2017-05-02';

update dibots_v2.exchange_demography_stock_cum_net_val a
set
local_cum_val = b.local_cum_val,
foreign_cum_val = b.foreign_cum_val,
local_inst_cum_val = b.local_inst_cum_val,
local_retail_cum_val = b.local_retail_cum_val,
local_nom_cum_val = b.local_nom_cum_val,
foreign_inst_cum_val = b.foreign_inst_cum_val,
foreign_retail_cum_val = b.foreign_retail_cum_val,
foreign_nom_cum_val = b.foreign_nom_cum_val,
prop_cum_val = b.prop_cum_val,
ivt_cum_val = b.ivt_cum_val,
pdt_cum_val = b.pdt_cum_val,
local_inst_nom_cum_val = b.local_inst_nom_cum_val,
foreign_inst_nom_cum_val = b.foreign_inst_nom_cum_val,
local_retail_nom_cum_val = b.local_retail_nom_cum_val,
foreign_retail_nom_cum_val = b.foreign_retail_nom_cum_val
from (
SELECT edsw.trading_date, edsw.stock_num,
sum(COALESCE(edsw.net_local_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS local_cum_val,
sum(COALESCE(edsw.net_foreign_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS foreign_cum_val,
sum(COALESCE(edsw.net_local_inst_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS local_inst_cum_val,
sum(COALESCE(edsw.net_local_retail_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS local_retail_cum_val,
sum(COALESCE(edsw.net_local_nominees_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS local_nom_cum_val,
sum(COALESCE(edsw.net_foreign_inst_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS foreign_inst_cum_val,
sum(COALESCE(edsw.net_foreign_retail_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS foreign_retail_cum_val,
sum(COALESCE(edsw.net_foreign_nominees_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS foreign_nom_cum_val,
sum(COALESCE(edsw.net_ivt_val, 0) + COALESCE(edsw.net_pdt_val,0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS prop_cum_val,
sum(COALESCE(edsw.net_ivt_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS ivt_cum_val,
sum(COALESCE(edsw.net_pdt_val, 0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS pdt_cum_val,
sum(COALESCE(edsw.net_local_inst_val, 0) + COALESCE(edsw.net_local_nominees_val,0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS local_inst_nom_cum_val,
sum(COALESCE(edsw.net_foreign_inst_val, 0) + COALESCE(edsw.net_foreign_nominees_val,0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS foreign_inst_nom_cum_val,
sum(COALESCE(edsw.net_local_retail_val, 0) + COALESCE(edsw.net_local_nominees_val,0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS local_retail_nom_cum_val,
sum(COALESCE(edsw.net_foreign_retail_val, 0) + COALESCE(edsw.net_foreign_nominees_val,0)) OVER (PARTITION BY edsw.stock_num ORDER BY edsw.trading_date) AS foreign_retail_nom_cum_val
FROM dibots_v2.exchange_demography_stock_week edsw
where trading_date = '2017-05-02'
ORDER BY edsw.trading_date, edsw.stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_demography_stock_cum_net_val
set
local_cum_val = 0
where local_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
foreign_cum_val = 0
where foreign_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
local_inst_cum_val = 0
where local_inst_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
local_retail_cum_val = 0
where local_retail_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
local_nom_cum_val = 0
where local_nom_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
foreign_inst_cum_val = 0
where foreign_inst_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
foreign_retail_cum_val = 0
where foreign_retail_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
foreign_nom_cum_val = 0
where foreign_nom_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
prop_cum_val = 0
where prop_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
ivt_cum_val = 0
where ivt_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
pdt_cum_val = 0
where pdt_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
local_inst_nom_cum_val = 0
where local_inst_nom_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
foreign_inst_nom_cum_val = 0
where foreign_inst_nom_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
local_retail_nom_cum_val = 0
where local_retail_cum_val is null;

update dibots_v2.exchange_demography_stock_cum_net_val
set
foreign_retail_nom_cum_val = 0
where foreign_retail_nom_cum_val is null;

--======================================
-- exchange_daily transaction velocity
--======================================

select transaction_date, stock_code, stock_name_short, volume_traded_market_transaction, shares_outstanding, 
CASE WHEN shares_outstanding = 0 THEN 0 ELSE (cast(volume_traded_market_transaction as numeric(25,3)) / cast(shares_outstanding as numeric(25,5)) * 248 * 100) END as velocity_per_day
from dibots_v2.exchange_daily_transaction;

select * from dibots_v2.exchange_daily_transaction where shares_outstanding = 0;

--drop table dibots_v2.exchange_daily_transaction_velocity;
create table dibots_v2.exchange_daily_transaction_velocity (
id serial primary key,
transaction_date date,
stock_code varchar,
stock_name_short varchar,
stock_num int,
volume_traded_market_transaction bigint,
shares_outstanding bigint,
velocity_per_day numeric(25,5)
);

CREATE INDEX exchange_daily_transaction_velocity_transaction_date_idx ON dibots_v2.exchange_daily_transaction_velocity (transaction_date);
CREATE INDEX exchange_daily_transaction_velocity_stock_code_idx ON dibots_v2.exchange_daily_transaction_velocity (stock_code);
ALTER TABLE dibots_v2.exchange_daily_transaction_velocity ADD CONSTRAINT exchg_daily_trans_vel_unique UNIQUE (transaction_date, stock_code)

insert into dibots_v2.exchange_daily_transaction_velocity (transaction_date, stock_code, stock_name_short, stock_num, volume_traded_market_transaction, shares_outstanding, velocity_per_day)
select transaction_date, stock_code, stock_name_short, stock_num, volume_traded_market_transaction, shares_outstanding, 
CASE WHEN shares_outstanding = 0 THEN 0 ELSE (cast(volume_traded_market_transaction as numeric(25,3)) / cast(shares_outstanding as numeric(25,5)) * 248 * 100) END as velocity_per_day 
from dibots_v2.exchange_daily_transaction;

select count(*) from dibots_v2.exchange_daily_transaction_velocity;

select * from dibots_v2.exchange_daily_transaction_velocity where transaction_date = '2020-05-06'

--=================================
-- exchange_short_selling
--=================================

CREATE TABLE dibots_v2.exchange_short_selling
(
   id serial primary key,
   trading_date date,
   week_count varchar(10),
   year int,
   month int,
   stock_code varchar(20),
   stock_name varchar(100),
   stock_long_name varchar(255),
   stock_num int,
   board varchar(255),
   sector varchar(255),
   klci_flag bool,
   fbm100_flag bool,
   shariah_flag bool,
   rss_volume bigint,
   rss_value numeric(25,6),
   idss_volume bigint,
   idss_value numeric(25,6),
   pss_volume int,
   pss_value numeric(25,6),
   pdt_volume int,
   pdt_value numeric(25,6),
   total_volume int,
   total_value numeric(25,6)
);

CREATE UNIQUE INDEX exchange_short_selling_unique ON dibots_v2.exchange_short_selling (trading_date, stock_code);
CREATE INDEX exchange_short_selling_trading_date_idx ON dibots_v2.exchange_short_selling(trading_date);
CREATE INDEX exchange_short_selling_stock_idx ON dibots_v2.exchange_short_selling(stock_code);
CREATE INDEX exchange_short_selling_board_idx ON dibots_v2.exchange_short_selling(board);
CREATE INDEX exchange_short_selling_sector_idx ON dibots_v2.exchange_short_selling(sector);
create index exchg_short_selling_week_idx on dibots_v2.exchange_short_selling (week_count);
create index exchg_short_selling_year_idx on dibots_v2.exchange_short_selling (year);
create index exchg_short_selling_month_idx on dibots_v2.exchange_short_selling (month);
create index exchg_short_selling_year_month_idx on dibots_v2.exchange_short_selling (year, month);

insert into dibots_v2.exchange_short_selling (trading_date, stock_code, stock_name, stock_long_name, stock_num, rss_volume, rss_value, idss_volume, idss_value, pss_volume, pss_value, pdt_volume, pdt_value, total_volume, total_value)
select trading_date, stock_code, stock_name, stock_long_name, stock_num, rss_volume, rss_value, idss_volume, idss_value, pss_volume, pss_value, pdt_volume, pdt_value, total_volume, total_value
from tmp_exchg_short_selling;

--==============================
-- exchange_net_short_position
--==============================


create table dibots_v2.exchange_net_short_position (
trading_date date,
stock_code varchar(20),
stock_name varchar(100),
stock_long_name varchar(255),
net_short_position_vol bigint,
net_short_position_pct numeric(25,2)
);

alter table dibots_v2.exchange_net_short_position add constraint exchg_net_short_pos_pkey primary key (trading_date, stock_code);


--===========================================
-- exchange_holdings_by_investor spaces fixes
--===========================================

select count(*) from dibots_v2.exchange_holdings_by_investor where investor_type = 'INDIVIDUAL-I'

update dibots_v2.exchange_holdings_by_investor invt
set
market = trim(invt.market),
stock_code = trim(invt.stock_code),
investor_type = trim(invt.investor_type),
race_ownership = trim(race_ownership)

select investor_type, race_ownership, sum(securities_total_shares) as sum_of_securities_total_shares, sum(cds_total_market_value)
from dibots_v2.exchange_holdings_by_investor
where stock_code = '0001'
group by investor_type, race_ownership

update dibots_v2.exchange_holdings_by_investor
set
group_type = 'RETAIL'
where investor_type = 'INDIVIDUAL-I';

update dibots_v2.exchange_holdings_by_investor
set
group_type = 'NOMINEES'
where investor_type = 'NOMINEES-C8';

update dibots_v2.exchange_holdings_by_investor
set
group_type = 'INSTITUTIONAL'
where investor_type LIKE 'BODY CORPORATE%';

update dibots_v2.exchange_holdings_by_investor
set
locality = 'FOREIGN'
where race_ownership like 'FOREIGN%';

update dibots_v2.exchange_holdings_by_investor
set
locality = 'LOCAL'
where locality is null;

--============================================
--exchange_holdings_by_country space fixes
--============================================

select count(*) from dibots_v2.exchange_holdings_by_country where stock_code = '0001'

update dibots_v2.exchange_holdings_by_country exc
set
market = trim(exc.market),
stock_code = trim(stock_code),
country_of_incorporation = trim(country_of_incorporation)

select country_of_incorporation, sum(securities_total_shares) as sum_of_securities_total_shares, sum(cds_total_market_value)
from dibots_v2.exchange_holdings_by_country
where stock_code = '0017'
group by country_of_incorporation

select as_of_date, stock_code, country_of_incorporation, securities_total_shares from dibots_v2.exchange_holdings_by_country where stock_code = '0001'

--==============================
-- exchange_trade_origin
--==============================

create table dibots_v2.exchange_trade_origin (
trading_date date,
broker_code int,
broker_name varchar(255),
trade_origin varchar(10),
trade_origin_code int,
trade_value numeric(25,2),
trade_quantity bigint
);

alter table dibots_v2.exchange_trade_origin add constraint exchg_trade_origin_pkey primary key (trading_date, broker_code, trade_origin_code);
