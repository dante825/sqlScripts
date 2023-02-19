--=================================
-- EXCHANGE_OMTDBT_BROKER_AGE_BAND
--=================================

create table dibots_v2.exchange_omtdbt_broker_age_band (
trading_date date,
external_id int,
participant_code int,
participant_name varchar(100),
age_band varchar(100),
male_count int,
female_count int,
na_gender_count int,
total_vol bigint,
total_val numeric(25,2),
intraday_vol bigint,
intraday_val numeric(25,2)
);

alter table dibots_v2.exchange_omtdbt_broker_age_band add constraint eomtdbt_broker_age_band_pkey primary key (trading_date, participant_code, age_band);
create index eomtdbtbab_trading_date_idx on dibots_v2.exchange_omtdbt_broker_age_band (trading_date);
create index eomtdbtbab_participant_code_idx on dibots_v2.exchange_omtdbt_broker_age_band (participant_code);
create index eomtdbtbab_external_id_idx on dibots_v2.exchange_omtdbt_broker_age_band (external_id);
create index eomtdbtbab_age_band_idx on dibots_v2.exchange_omtdbt_broker_age_band (age_band);

insert into dibots_v2.exchange_omtdbt_broker_age_band (trading_date, external_id, participant_code, participant_name, age_band, male_count, female_count, na_gender_count, 
total_vol, total_val, intraday_vol, intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.external_id,b.external_id), coalesce(a.participant_code,b.participant_code), 
coalesce(a.participant_name,b.participant_name), coalesce(a.age_band,b.age_band), coalesce(a.male_count,0) + coalesce(b.male_count,0), coalesce(a.female_count,0) + coalesce(b.female_count,0),
coalesce(a.na_gender_count,0) + coalesce(b.na_gender_count,0), coalesce(a.total_buysell_volume,0) + coalesce(b.total_vol,0), coalesce(a.total_buysell_value,0) + coalesce(b.total_val,0), 
coalesce(a.intraday_volume,0) + coalesce(b.intraday_vol,0), coalesce(a.intraday_value,0) + coalesce(b.intraday_val,0)
from dibots_v2.exchange_demography_broker_age_band a
full join dibots_v2.exchange_dbt_broker_age_band b
on a.trading_date = b.trading_date and a.participant_code = b.participant_code and a.age_band = b.age_band
where (a.trading_date >= '2020-01-01' or b.trading_date >= '2020-01-01');

-- INSERT OMT data
insert into dibots_v2.exchange_omtdbt_broker_age_band (trading_date, external_id, participant_code, participant_name, age_band, male_count, female_count, na_gender_count, 
total_vol, total_val, intraday_vol, intraday_val)
select trading_date, external_id, participant_code, participant_name, age_band, male_count, female_count, na_gender_count, total_buysell_volume, total_buysell_value, intraday_volume, intraday_value 
from dibots_v2.exchange_demography_broker_age_band
where trading_date < '2020-01-01'

-- incremental update
insert into dibots_v2.exchange_omtdbt_broker_age_band (trading_date, external_id, participant_code, participant_name, age_band, male_count, female_count, na_gender_count, 
total_vol, total_val, intraday_vol, intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.external_id,b.external_id), coalesce(a.participant_code,b.participant_code), 
coalesce(a.participant_name,b.participant_name), coalesce(a.age_band,b.age_band), 
coalesce(a.male_count,0) + coalesce(b.male_count,0), coalesce(a.female_count,0) + coalesce(b.female_count,0),
coalesce(a.na_gender_count,0) + coalesce(b.na_gender_count,0), coalesce(a.total_buysell_volume,0) + coalesce(b.total_vol,0), coalesce(a.total_buysell_value,0) + coalesce(b.total_val,0), 
coalesce(a.intraday_volume,0) + coalesce(b.intraday_vol,0), coalesce(a.intraday_value,0) + coalesce(b.intraday_val,0)
from dibots_v2.exchange_demography_broker_age_band a
full join dibots_v2.exchange_dbt_broker_age_band b
on a.trading_date = b.trading_date and a.participant_code = b.participant_code and a.age_band = b.age_band
where (a.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_age_band) or 
b.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_age_band));

--===============================================
-- EXCHANGE_OMTDBT_STOCK_BROKER_NATIONALITY
--===============================================

create table dibots_v2.exchange_omtdbt_stock_broker_nationality (
trading_date date,
week_count varchar(10),
year int,
month int,
broker_code int,
broker_name varchar(255),
broker_ext_id bigint,
stock_code varchar(10),
stock_name varchar(50),
stock_num int,
nationality varchar(10),
volume bigint,
value numeric(25,3),
buy_vol bigint,
buy_val numeric(25,3),
sell_vol bigint,
sell_val numeric(25,3),
net_vol bigint,
net_val numeric(25,3),
intraday_vol bigint,
intraday_val numeric(25,3),
constraint eomtdbt_sb_nationality_pkey primary key (trading_date, broker_code, stock_code, nationality)
) partition by range (trading_date);

create index eomtdbt_sb_nationality_stock_idx on dibots_v2.exchange_omtdbt_stock_broker_nationality (trading_date, stock_num);
create index eomtdbt_sb_nationality_broker_idx on dibots_v2.exchange_omtdbt_stock_broker_nationality (trading_date, broker_code);
create index eomtdbt_sb_nationality_date_idx on dibots_v2.exchange_omtdbt_stock_broker_nationality (trading_date);

create table dibots_v2.exchange_omtdbt_stock_broker_nationality_y2017_2019 partition of dibots_v2.exchange_omtdbt_stock_broker_nationality
for values from ('2017-01-01') to ('2020-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_nationality_y2020_2022 partition of dibots_v2.exchange_omtdbt_stock_broker_nationality
for values from ('2020-01-01') to ('2023-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_nationality_y2023_2025 partition of dibots_v2.exchange_omtdbt_stock_broker_nationality
for values from ('2023-01-01') to ('2026-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_nationality_default partition of dibots_v2.exchange_omtdbt_stock_broker_nationality default;

-- fresh insertion
insert into dibots_v2.exchange_omtdbt_stock_broker_nationality (trading_date, week_count, year, month, broker_code, broker_name, broker_ext_id, stock_code, stock_name, stock_num, nationality, 
volume, value, buy_vol, buy_val, sell_vol, sell_val, net_vol, net_val, intraday_vol, intraday_val)
select coalesce(a.trading_date, b.trading_date), coalesce(a.week_count, b.week_count), coalesce(a.year, b.year), coalesce(a.month, b.month), coalesce(a.broker_code, b.broker_code), coalesce(a.broker_name, b.broker_name),
coalesce(a.broker_ext_id, b.broker_ext_id), coalesce(a.stock_code, b.stock_code), coalesce(a.stock_name, b.stock_name), coalesce(a.stock_num, b.stock_num), coalesce(a.nationality, b.nationality),
coalesce(a.volume,0) + coalesce(b.volume,0), coalesce(a.value,0) + coalesce(b.value,0), coalesce(a.buy_vol,0) + coalesce(b.buy_vol,0), coalesce(a.buy_val,0) + coalesce(b.buy_val,0), 
coalesce(a.sell_vol,0) + coalesce(b.sell_vol,0), coalesce(a.sell_val,0) + coalesce(b.sell_val,0), coalesce(a.net_vol,0) + coalesce(b.net_vol,0), coalesce(a.net_val,0) + coalesce(b.net_val,0), 
coalesce(a.intraday_vol,0) + coalesce(b.intraday_vol,0), coalesce(a.intraday_val,0) + coalesce(b.intraday_val,0)
from dibots_v2.exchange_demography_stock_broker_nationality a
full join dibots_v2.exchange_dbt_stock_broker_nationality b
on a.trading_date = b.trading_date and a.broker_code = b.broker_code and a.stock_code = b.stock_code and a.nationality = b.nationality;

-- INSERT OMT data
insert into dibots_v2.exchange_omtdbt_stock_broker_nationality (trading_date, week_count, year, month, broker_code, broker_name, broker_ext_id, stock_code, stock_name, stock_num, nationality, 
volume, value, buy_vol, buy_val, sell_vol, sell_val, net_vol, net_val, intraday_vol, intraday_val)
select trading_date, week_count, year, month, broker_code, broker_name, broker_ext_id, stock_code, stock_name, stock_num, nationality, 
volume, value, buy_vol, buy_val, sell_vol, sell_val, net_vol, net_val, intraday_vol, intraday_val
from dibots_v2.exchange_demography_stock_broker_nationality
where trading_date < '2020-01-01';

-- incremental updates
insert into dibots_v2.exchange_omtdbt_stock_broker_nationality (trading_date, week_count, year, month, broker_code, broker_name, broker_ext_id, stock_code, stock_name, stock_num, nationality, 
volume, value, buy_vol, buy_val, sell_vol, sell_val, net_vol, net_val, intraday_vol, intraday_val)
select coalesce(a.trading_date, b.trading_date), coalesce(a.week_count, b.week_count), coalesce(a.year, b.year), coalesce(a.month, b.month), coalesce(a.broker_code, b.broker_code), coalesce(a.broker_name, b.broker_name),
coalesce(a.broker_ext_id, b.broker_ext_id), coalesce(a.stock_code, b.stock_code), coalesce(a.stock_name, b.stock_name), coalesce(a.stock_num, b.stock_num), coalesce(a.nationality, b.nationality),
coalesce(a.volume,0) + coalesce(b.volume,0), coalesce(a.value,0) + coalesce(b.value,0), coalesce(a.buy_vol,0) + coalesce(b.buy_vol,0), coalesce(a.buy_val,0) + coalesce(b.buy_val,0), 
coalesce(a.sell_vol,0) + coalesce(b.sell_vol,0), coalesce(a.sell_val,0) + coalesce(b.sell_val,0), coalesce(a.net_vol,0) + coalesce(b.net_vol,0), coalesce(a.net_val,0) + coalesce(b.net_val,0), 
coalesce(a.intraday_vol,0) + coalesce(b.intraday_vol,0), coalesce(a.intraday_val,0) + coalesce(b.intraday_val,0)
from dibots_v2.exchange_demography_stock_broker_nationality a
full join dibots_v2.exchange_dbt_stock_broker_nationality b
on a.trading_date = b.trading_date and a.broker_code = b.broker_code and a.stock_code = b.stock_code and a.nationality = b.nationality
where (a.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker_nationality) or 
b.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker_nationality));

--==============================
-- EXCHANGE_OMTDBT_BROKER_STATS
--==============================

create table dibots_v2.exchange_omtdbt_broker_stats (
trading_date date,
participant_code int,
external_id int,
participant_name varchar(100),
locality varchar(20),
group_type varchar(20),
trades_count int,
total_val numeric(25,3),
net_val numeric(25,3),
min_buy_val numeric(25,3),
min_sell_val numeric(25,3),
max_buy_val numeric(25,3),
max_sell_val numeric(25,3),
total_intraday_vol bigint,
total_intraday_val numeric(25,3),
min_intraday_vol bigint,
min_intraday_val numeric(25,3),
max_intraday_vol bigint,
max_intraday_val numeric(25,3)
);

ALTER TABLE dibots_v2.exchange_omtdbt_broker_stats add constraint eomtdbt_broker_stats_pkey primary key (trading_date, participant_code, locality, group_type);
CREATE INDEX eomtdbt_broker_stats_trading_date_idx ON dibots_v2.exchange_omtdbt_broker_stats (trading_date);
CREATE INDEX eomtdbt_broker_stats_pcode_idx ON dibots_v2.exchange_omtdbt_broker_stats (participant_code);
CREATE INDEX eomtdbt_broker_stats_ext_idx ON dibots_v2.exchange_omtdbt_broker_stats (external_id);
CREATE INDEX eomtdbt_broker_stats_locality_idx ON dibots_v2.exchange_omtdbt_broker_stats (locality);
CREATE INDEX eomtdbt_broker_stats_group_idx ON dibots_v2.exchange_omtdbt_broker_stats (group_type);

insert into dibots_v2.exchange_omtdbt_broker_stats (trading_date, participant_code, external_id, participant_name, locality, group_type, 
trades_count, total_val, net_val, min_buy_val, min_sell_val, max_buy_val, max_sell_val, total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.participant_code,b.participant_code), coalesce(a.external_id,b.external_id), 
coalesce(a.participant_name, b.participant_name), coalesce(a.locality,b.locality), coalesce(a.group_type,b.group_type), 
coalesce(a.trades_count,0) + coalesce(b.trades_count,0), coalesce(a.total_traded_value,0) + coalesce(b.total_val,0),
coalesce(a.net_traded_value,0) + coalesce(b.net_val,0), least(a.min_traded_value_buy, b.min_buy_val), least(a.min_traded_value_sell, b.min_sell_val), greatest(a.max_traded_value_buy, b.max_buy_val), 
greatest(a.max_traded_value_sell, b.max_sell_val), coalesce(a.total_intraday_vol,0) + coalesce(b.total_intraday_vol,0), coalesce(a.total_intraday_val,0) + coalesce(b.total_intraday_val,0), 
least(a.min_intraday_vol, b.min_intraday_vol), least(a.min_intraday_val, b.min_intraday_val), greatest(a.max_intraday_vol, b.max_intraday_vol), greatest(a.max_intraday_val, b.max_intraday_val)
from dibots_v2.exchange_demography_broker_stats a
full join dibots_v2.exchange_dbt_broker_stats b
on a.trading_date = b.trading_date and a.participant_code = b.participant_code and a.locality = b.locality and a.group_type = b.group_type
where (a.trading_date >= '2020-01-01' or b.trading_date >= '2020-01-01');

-- INSERT OMT data
insert into dibots_v2.exchange_omtdbt_broker_stats (trading_date, participant_code, external_id, participant_name, locality, group_type, 
trades_count, total_val, net_val, min_buy_val, min_sell_val, max_buy_val, max_sell_val, total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, participant_code, external_id, participant_name, locality, group_type, trades_count, total_traded_value, net_traded_value, min_traded_value_buy, min_traded_value_sell, max_traded_value_buy,
max_traded_value_sell, total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val
from dibots_v2.exchange_demography_broker_stats
where trading_date < '2020-01-01';


-- incremental update
insert into dibots_v2.exchange_omtdbt_broker_stats (trading_date, participant_code, external_id, participant_name, locality, group_type, 
trades_count, total_val, net_val, min_buy_val, min_sell_val, max_buy_val, max_sell_val, total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.participant_code,b.participant_code), coalesce(a.external_id,b.external_id), 
coalesce(a.participant_name, b.participant_name), coalesce(a.locality,b.locality), coalesce(a.group_type,b.group_type), 
coalesce(a.trades_count,0) + coalesce(b.trades_count,0), coalesce(a.total_traded_value,0) + coalesce(b.total_val,0),
coalesce(a.net_traded_value,0) + coalesce(b.net_val,0), least(a.min_traded_value_buy, b.min_buy_val), least(a.min_traded_value_sell, b.min_sell_val), greatest(a.max_traded_value_buy, b.max_buy_val), 
greatest(a.max_traded_value_sell, b.max_sell_val), coalesce(a.total_intraday_vol,0) + coalesce(b.total_intraday_vol,0), coalesce(a.total_intraday_val,0) + coalesce(b.total_intraday_val,0), 
least(a.min_intraday_vol, b.min_intraday_vol), least(a.min_intraday_val, b.min_intraday_val), greatest(a.max_intraday_vol, b.max_intraday_vol), greatest(a.max_intraday_val, b.max_intraday_val)
from dibots_v2.exchange_demography_broker_stats a
full join dibots_v2.exchange_dbt_broker_stats b
on a.trading_date = b.trading_date and a.participant_code = b.participant_code and a.locality = b.locality and a.group_type = b.group_type
where (a.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_stats) or 
b.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_stats));

--==============================
-- EXCHANGE_OMTDBT_STOCK_BROKER
--==============================

create table dibots_v2.exchange_omtdbt_stock_broker (
trading_date date,
stock_code varchar(10),
stock_name varchar(25),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
external_id int,
participant_code int,
participant_name varchar(100),
locality varchar(20),
group_type varchar(20),
buy_vol bigint,
sell_vol bigint,
total_vol bigint,
net_vol bigint,
buy_val numeric(25,3),
sell_val numeric(25,3),
total_val numeric(25,3),
net_val numeric(25,3),
intraday_vol bigint,
intraday_val numeric(25,3)
) PARTITION BY RANGE (trading_date);

alter table dibots_v2.exchange_omtdbt_stock_broker add constraint eomtdbt_sb_pkey primary key (trading_date, stock_code, participant_code, locality, group_type);

create table dibots_v2.exchange_omtdbt_stock_broker_y2020 partition of dibots_v2.exchange_omtdbt_stock_broker 
for values from ('2020-01-01') to ('2021-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_y2021 partition of dibots_v2.exchange_omtdbt_stock_broker 
for values from ('2021-01-01') to ('2022-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_y2022 partition of dibots_v2.exchange_omtdbt_stock_broker 
for values from ('2022-01-01') to ('2023-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_y2023 partition of dibots_v2.exchange_omtdbt_stock_broker 
for values from ('2023-10-01') to ('2024-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_y2024 partition of dibots_v2.exchange_omtdbt_stock_broker 
for values from ('2024-01-01') to ('2025-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_y2025 partition of dibots_v2.exchange_omtdbt_stock_broker 
for values from ('2025-01-01') to ('2026-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_default partition of dibots_v2.exchange_omtdbt_stock_broker default;

create index eomtdbt_sb_trddate_idx on dibots_v2.exchange_omtdbt_stock_broker (trading_date);
create index eomtdbt_sb_ext_id_idx on dibots_v2.exchange_omtdbt_stock_broker (external_id);
create index eomtdbt_sb_partcpt_code_idx on dibots_v2.exchange_omtdbt_stock_broker(participant_code);
create index eomtdbt_sb_stock_code_idx on dibots_v2.exchange_omtdbt_stock_broker(stock_code);
create index eomtdbt_sb_board_idx on dibots_v2.exchange_omtdbt_stock_broker (board);
create index eomtdbt_sb_sector_idx on dibots_v2.exchange_omtdbt_stock_broker (sector);
create index eomtdbt_sb_locality_idx on dibots_v2.exchange_omtdbt_stock_broker(locality);
create index eomtdbt_sb_group_type_idx on dibots_v2.exchange_omtdbt_stock_broker(group_type);

insert into dibots_v2.exchange_omtdbt_stock_broker (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, 
external_id, participant_code, participant_name, locality, group_type, buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.stock_code,b.stock_code), coalesce(a.stock_name,b.stock_name), coalesce(a.stock_num,b.stock_num),
coalesce(a.board,b.board), coalesce(a.sector,b.sector), coalesce(a.klci_flag,b.klci_flag), coalesce(a.fbm100_flag,b.fbm100_flag), 
coalesce(a.shariah_flag,b.shariah_flag), coalesce(a.external_id,b.external_id), coalesce(a.participant_code,b.participant_code), 
coalesce(a.participant_name,b.participant_name), coalesce(a.locality,b.locality), coalesce(a.group_type,b.group_type), 
coalesce(a.buy_volume, 0) + coalesce(b.buy_vol,0), coalesce(a.sell_volume,0) + coalesce(b.sell_vol,0), coalesce(a.volume,0) + coalesce(b.total_vol,0), coalesce(a.net_volume,0) + coalesce(b.net_vol,0), 
coalesce(a.buy_value,0) + coalesce(b.buy_val,0), coalesce(a.sell_value,0) + coalesce(b.sell_val,0), coalesce(a.value,0) + coalesce(b.total_val,0), coalesce(a.net_value,0) + coalesce(b.net_val,0),
coalesce(a.intraday_volume,0) + coalesce(b.intraday_vol,0), coalesce(a.intraday_value,0) + coalesce(b.intraday_val,0)
from dibots_v2.exchange_demography_stock_broker a
full join dibots_v2.exchange_dbt_stock_broker b
on a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.participant_code = b.participant_code and a.locality = b.locality and a.group_type = b.group_type
where (a.trading_date >= '2020-01-01' or b.trading_date >= '2020-01-01');

-- INSERT OMT data
insert into dibots_v2.exchange_omtdbt_stock_broker (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, 
external_id, participant_code, participant_name, locality, group_type, buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, 
external_id, participant_code, participant_name, locality, group_type, buy_volume, sell_volume, volume, net_volume, buy_value, sell_value, value, net_value, intraday_volume, intraday_value
from dibots_v2.exchange_demography_stock_broker
where trading_date < '2020-01-01'

-- incremental update
insert into dibots_v2.exchange_omtdbt_stock_broker (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, 
external_id, participant_code, participant_name, locality, group_type, buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.stock_code,b.stock_code), coalesce(a.stock_name,b.stock_name), coalesce(a.stock_num,b.stock_num),
coalesce(a.board,b.board), coalesce(a.sector,b.sector), coalesce(a.klci_flag,b.klci_flag), coalesce(a.fbm100_flag,b.fbm100_flag), 
coalesce(a.shariah_flag,b.shariah_flag), coalesce(a.external_id,b.external_id), coalesce(a.participant_code,b.participant_code), 
coalesce(a.participant_name,b.participant_name), coalesce(a.locality,b.locality), coalesce(a.group_type,b.group_type), 
coalesce(a.buy_volume, 0) + coalesce(b.buy_vol,0), coalesce(a.sell_volume,0) + coalesce(b.sell_vol,0), coalesce(a.volume,0) + coalesce(b.total_vol,0), coalesce(a.net_volume,0) + coalesce(b.net_vol,0), 
coalesce(a.buy_value,0) + coalesce(b.buy_val,0), coalesce(a.sell_value,0) + coalesce(b.sell_val,0), coalesce(a.value,0) + coalesce(b.total_val,0), coalesce(a.net_value,0) + coalesce(b.net_val,0),
coalesce(a.intraday_volume,0) + coalesce(b.intraday_vol,0), coalesce(a.intraday_value,0) + coalesce(b.intraday_val,0)
from dibots_v2.exchange_demography_stock_broker a
full join dibots_v2.exchange_dbt_stock_broker b
on a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.participant_code = b.participant_code and a.locality = b.locality and a.group_type = b.group_type
where (a.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker) or b.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker));

--======================================
-- EXCHANGE_OMTDBT_STOCK_MOVEMENT
--======================================

create table dibots_v2.exchange_omtdbt_stock_movement (
trading_date date,
stock_code varchar(20),
stock_name varchar(100),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
locality varchar(20),
group_type varchar(20),
buy_vol bigint,
sell_vol bigint,
total_vol bigint,
net_vol bigint,
buy_val numeric(25,3),
sell_val numeric(25,3),
total_val numeric(25,3),
net_val numeric(25,3),
intraday_vol bigint,
intraday_val numeric(25,3)
) PARTITION BY RANGE(trading_date);

alter table dibots_v2.exchange_omtdbt_stock_movement add constraint eomtdbt_stock_movement_pkey primary key (trading_date, stock_code, locality, group_type);

create table dibots_v2.exchange_omtdbt_stock_movement_y2020_h1 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2020-01-01') to ('2020-07-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2020_h2 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2020-07-01') to ('2021-01-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2021_h1 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2021-01-01') to ('2021-07-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2021_h2 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2021-07-01') to ('2022-01-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2022_h1 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2022-01-01') to ('2022-07-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2022_h2 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2022-07-01') to ('2023-01-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2023_h1 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2023-01-01') to ('2023-07-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2023_h2 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2023-07-01') to ('2024-01-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2024_h1 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2024-01-01') to ('2024-07-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2024_h2 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2024-07-01') to ('2025-01-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2025_h1 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2025-01-01') to ('2025-07-01');
create table dibots_v2.exchange_omtdbt_stock_movement_y2025_h2 partition of dibots_v2.exchange_omtdbt_stock_movement
for values from ('2025-07-01') to ('2026-01-01');
create table dibots_v2.exchange_omtdbt_stock_movement_default partition of dibots_v2.exchange_omtdbt_stock_movement default;

create index eomtdbt_stock_movement_trading_date_idx on dibots_v2.exchange_omtdbt_stock_movement(trading_date);
create index eomtdbt_stock_movement_stock_code_idx on dibots_v2.exchange_omtdbt_stock_movement(stock_code);
create index eomtdbt_stock_movement_board_idx on dibots_v2.exchange_omtdbt_stock_movement(board);
create index eomtdbt_stock_movement_sector_idx on dibots_v2.exchange_omtdbt_stock_movement(sector);
create index eomtdbt_stock_movement_locality_idx on dibots_v2.exchange_omtdbt_stock_movement(locality);
create index eomtdbt_stock_movement_group_idx on dibots_v2.exchange_omtdbt_stock_movement(group_type);

insert into dibots_v2.exchange_omtdbt_stock_movement (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, locality, group_type, 
buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.stock_code,b.stock_code), coalesce(a.stock_name,b.stock_name), coalesce(a.stock_num,b.stock_num), coalesce(a.board,b.board), 
coalesce(a.sector,b.sector), coalesce(a.klci_flag,b.klci_flag), coalesce(a.fbm100_flag,b.fbm100_flag), coalesce(a.shariah_flag,b.shariah_flag), 
coalesce(a.locality,b.locality), coalesce(a.group_type,b.group_type), coalesce(a.buy_volume,0) + coalesce(b.buy_vol,0),
coalesce(a.sell_volume,0) + coalesce(b.sell_vol,0), coalesce(a.volume,0) + coalesce(b.total_vol,0), coalesce(a.net_volume,0) + coalesce(b.net_vol,0), coalesce(a.buy_value,0) + coalesce(b.buy_val,0),
coalesce(a.sell_value,0) + coalesce(b.sell_val,0), coalesce(a.value,0) + coalesce(b.total_val,0), coalesce(a.net_value,0) + coalesce(b.net_val,0), coalesce(a.intraday_volume,0) + coalesce(b.intraday_vol,0),
coalesce(a.intraday_value,0) + coalesce(b.intraday_val,0)
from dibots_v2.exchange_demography_stock_movement a
full join dibots_v2.exchange_dbt_stock_movement b
on a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.locality = b.locality and a.group_type = b.group_type
where (a.trading_date >= '2020-01-01' or b.trading_date >= '2020-01-01');

-- INSERT OMT data
insert into dibots_v2.exchange_omtdbt_stock_movement (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, locality, group_type, 
buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val)

select trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, locality, group_type, 
buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val
from dibots_v2.exchange_demography_stock_movement
where trading_date < '2020-01-01'

-- incremental update
insert into dibots_v2.exchange_omtdbt_stock_movement (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, locality, group_type, 
buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.stock_code,b.stock_code), coalesce(a.stock_name,b.stock_name), coalesce(a.stock_num,b.stock_num), coalesce(a.board,b.board), 
coalesce(a.sector,b.sector), coalesce(a.klci_flag,b.klci_flag), coalesce(a.fbm100_flag,b.fbm100_flag), coalesce(a.shariah_flag,b.shariah_flag), 
coalesce(a.locality,b.locality), coalesce(a.group_type,b.group_type), coalesce(a.buy_volume,0) + coalesce(b.buy_vol,0),
coalesce(a.sell_volume,0) + coalesce(b.sell_vol,0), coalesce(a.volume,0) + coalesce(b.total_vol,0), coalesce(a.net_volume,0) + coalesce(b.net_vol,0), coalesce(a.buy_value,0) + coalesce(b.buy_val,0),
coalesce(a.sell_value,0) + coalesce(b.sell_val,0), coalesce(a.value,0) + coalesce(b.total_val,0), coalesce(a.net_value,0) + coalesce(b.net_val,0), coalesce(a.intraday_volume,0) + coalesce(b.intraday_vol,0),
coalesce(a.intraday_value,0) + coalesce(b.intraday_val,0)
from dibots_v2.exchange_demography_stock_movement a
full join dibots_v2.exchange_dbt_stock_movement b
on a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.locality = b.locality and a.group_type = b.group_type
where (a.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_movement) or b.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_movement));

--=========================
-- EXCHANGE_OMTDBT_STOCK
--=========================

create table dibots_v2.exchange_omtdbt_stock (
trading_date date,
stock_code varchar(20),
stock_name varchar(100),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
total_vol bigint,
total_val numeric(25,2),
local_vol bigint,
local_val numeric(25,2),
foreign_vol bigint,
foreign_val numeric(25,2),
inst_vol bigint,
inst_val numeric(25,2),
local_inst_vol bigint,
local_inst_val numeric(25,2),
foreign_inst_vol bigint,
foreign_inst_val numeric(25,2),
retail_vol bigint,
retail_val numeric(25,2),
local_retail_vol bigint,
local_retail_val numeric(25,2),
foreign_retail_vol bigint,
foreign_retail_val numeric(25,2),
nominees_vol bigint,
nominees_val numeric(25,2),
local_nominees_vol bigint,
local_nominees_val numeric(25,2),
foreign_nominees_vol bigint,
foreign_nominees_val numeric(25,2),
ivt_vol bigint,
ivt_val numeric(25,2),
pdt_vol bigint,
pdt_val numeric(25,2),
net_inst_vol bigint,
net_inst_val numeric(25,2),
net_local_inst_vol bigint,
net_local_inst_val numeric(25,2),
net_foreign_inst_vol bigint,
net_foreign_inst_val numeric(25,2),
net_retail_vol bigint,
net_retail_val numeric(25,2),
net_local_retail_vol bigint,
net_local_retail_val numeric(25,2),
net_foreign_retail_vol bigint,
net_foreign_retail_val numeric(25,2),
net_nominees_vol bigint,
net_nominees_val numeric(25,2),
net_local_nominees_vol bigint,
net_local_nominees_val numeric(25,2),
net_foreign_nominees_vol bigint,
net_foreign_nominees_val numeric(25,2),
net_ivt_vol bigint,
net_ivt_val numeric(25,2),
net_pdt_vol bigint,
net_pdt_val numeric(25,2),
net_local_vol bigint,
net_local_val numeric(25,2),
net_foreign_vol bigint,
net_foreign_val numeric(25,2),
total_intraday_vol bigint,
total_intraday_val numeric(25,2),
local_intraday_vol bigint,
local_intraday_val numeric(25,2),
foreign_intraday_vol bigint,
foreign_intraday_val numeric(25,2),
inst_intraday_vol bigint,
inst_intraday_val numeric(25,2),
local_inst_intraday_vol bigint,
local_inst_intraday_val numeric(25,2),
foreign_inst_intraday_vol bigint,
foreign_inst_intraday_val numeric(25,2),
retail_intraday_vol bigint,
retail_intraday_val numeric(25,2),
local_retail_intraday_vol bigint,
local_retail_intraday_val numeric(25,2),
foreign_retail_intraday_vol bigint,
foreign_retail_intraday_val numeric(25,2),
nominees_intraday_vol bigint,
nominees_intraday_val numeric(25,2),
local_nominees_intraday_vol bigint,
local_nominees_intraday_val numeric(25,2),
foreign_nominees_intraday_vol bigint,
foreign_nominees_intraday_val numeric(25,2),
ivt_intraday_vol bigint,
ivt_intraday_val numeric(25,2),
pdt_intraday_vol bigint,
pdt_intraday_val numeric(25,2)
)PARTITION BY RANGE(trading_date);

alter table dibots_v2.exchange_omtdbt_stock add constraint eomtdbt_stock_pkey PRIMARY KEY (trading_date, stock_code);

create table dibots_v2.exchange_omtdbt_stock_y2020_2022 partition of dibots_v2.exchange_omtdbt_stock
for values from ('2020-01-01') to ('2023-01-01');
create table dibots_v2.exchange_omtdbt_stock_y2023_2025 partition of dibots_v2.exchange_omtdbt_stock
for values from ('2023-01-01') to ('2026-01-01');
create table dibots_v2.exchange_omtdbt_stock_default partition of dibots_v2.exchange_omtdbt_stock default;

create index eomtdbts_trading_date_idx on dibots_v2.exchange_omtdbt_stock (trading_date);
create index eomtdbts_stock_code_idx on dibots_v2.exchange_omtdbt_stock (stock_code);
create index eomtdbts_board_idx on dibots_v2.exchange_omtdbt_stock (board);
create index eomtdbts_sector_idx on dibots_v2.exchange_omtdbt_stock (sector);

insert into dibots_v2.exchange_omtdbt_stock (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val,
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, ivt_vol, ivt_val, pdt_vol, pdt_val, net_inst_vol, net_inst_val, 
net_local_inst_vol, net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val,
net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, 
net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, 
inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, 
local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, 
local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.stock_code,b.stock_code), coalesce(a.stock_name,b.stock_name), coalesce(a.stock_num,b.stock_num), coalesce(a.board,b.board), 
coalesce(a.sector,b.sector), coalesce(a.klci_flag,b.klci_flag), coalesce(a.fbm100_flag,b.fbm100_flag), coalesce(a.shariah_flag,b.shariah_flag), 
coalesce(a.total_vol,0) + coalesce(b.total_vol,0), coalesce(a.total_val,0) + coalesce(b.total_val,0),
coalesce(a.local_vol,0) + coalesce(b.local_vol,0), coalesce(a.local_val,0) + coalesce(b.local_val,0), 
coalesce(a.foreign_vol,0) + coalesce(b.foreign_vol,0), coalesce(a.foreign_val,0) + coalesce(b.foreign_val,0),
coalesce(a.inst_vol,0) + coalesce(b.inst_vol,0), coalesce(a.inst_val,0) + coalesce(b.inst_val,0), 
coalesce(a.local_inst_vol,0) + coalesce(b.local_inst_vol,0), coalesce(a.local_inst_val,0) + coalesce(b.local_inst_val,0),
coalesce(a.foreign_inst_vol,0) + coalesce(b.foreign_inst_vol,0), coalesce(a.foreign_inst_val,0) + coalesce(b.foreign_inst_val,0), 
coalesce(a.retail_vol,0) + coalesce(b.retail_vol,0), coalesce(a.retail_val,0) + coalesce(b.retail_val,0),
coalesce(a.local_retail_vol,0) + coalesce(b.local_retail_vol,0), coalesce(a.local_retail_val,0) + coalesce(b.local_retail_val,0), 
coalesce(a.foreign_retail_vol,0) + coalesce(b.foreign_retail_vol,0), coalesce(a.foreign_retail_val,0) + coalesce(b.foreign_retail_val,0), 
coalesce(a.nominees_vol,0) + coalesce(b.nominees_vol,0), coalesce(a.nominees_val,0) + coalesce(b.nominees_val,0),
coalesce(a.local_nominees_vol,0) + coalesce(b.local_nominees_vol,0), coalesce(a.local_nominees_val,0) + coalesce(b.local_nominees_val,0), 
coalesce(a.foreign_nominees_vol,0) + coalesce(b.foreign_nominees_vol,0), coalesce(a.foreign_nominees_val,0) + coalesce(b.foreign_nominees_val,0), 
coalesce(a.ivt_vol,0) + coalesce(b.ivt_vol,0), coalesce(a.ivt_val,0) + coalesce(b.ivt_val,0),
coalesce(a.pdt_vol,0) + coalesce(b.pdt_vol,0), coalesce(a.pdt_val,0) + coalesce(b.pdt_val,0), 
coalesce(a.net_inst_vol,0) + coalesce(b.net_inst_vol,0), coalesce(a.net_inst_val,0) + coalesce(b.net_inst_val,0), 
coalesce(a.net_local_inst_vol,0) + coalesce(b.net_local_inst_vol,0), coalesce(a.net_local_inst_val,0) + coalesce(b.net_local_inst_val,0), 
coalesce(a.net_foreign_inst_vol,0) + coalesce(b.net_foreign_inst_vol,0),coalesce(a.net_foreign_inst_val,0) + coalesce(b.net_foreign_inst_val,0),
coalesce(a.net_retail_vol,0) + coalesce(b.net_retail_vol,0), coalesce(a.net_retail_val,0) + coalesce(b.net_retail_val,0), 
coalesce(a.net_local_retail_vol,0) + coalesce(b.net_local_retail_vol,0), coalesce(a.net_local_retail_val,0) + coalesce(b.net_local_retail_val,0), 
coalesce(a.net_foreign_retail_vol,0) + coalesce(b.net_foreign_retail_vol,0), coalesce(a.net_foreign_retail_val,0) + coalesce(b.net_foreign_retail_val,0),
coalesce(a.net_nominees_vol,0) + coalesce(b.net_nominees_vol,0), coalesce(a.net_nominees_val,0) + coalesce(b.net_nominees_val,0),
coalesce(a.net_local_nominees_vol,0) + coalesce(b.net_local_nominees_vol,0), coalesce(a.net_local_nominees_val,0) + coalesce(b.net_local_nominees_val,0),
coalesce(a.net_foreign_nominees_vol,0) + coalesce(b.net_foreign_nominees_vol,0), coalesce(a.net_foreign_nominees_val,0) + coalesce(b.net_foreign_nominees_val,0), 
coalesce(a.net_ivt_vol,0) + coalesce(b.net_ivt_vol,0), coalesce(a.net_ivt_val,0) + coalesce(b.net_ivt_val,0), 
coalesce(a.net_pdt_vol,0) + coalesce(b.net_pdt_vol,0), coalesce(a.net_pdt_val,0) + coalesce(b.net_pdt_val,0), 
coalesce(a.net_local_vol,0) + coalesce(b.net_local_vol,0), coalesce(a.net_local_val,0) + coalesce(b.net_local_val,0), 
coalesce(a.net_foreign_vol,0) + coalesce(b.net_foreign_vol,0), coalesce(a.net_foreign_val,0) + coalesce(b.net_foreign_val,0), 
coalesce(a.total_intraday_vol,0) + coalesce(b.total_intraday_vol,0), coalesce(a.total_intraday_val,0) + coalesce(b.total_intraday_val,0),
coalesce(a.local_intraday_vol,0) + coalesce(b.local_intraday_vol,0), coalesce(a.local_intraday_val,0) + coalesce(b.local_intraday_val,0), 
coalesce(a.foreign_intraday_vol,0) + coalesce(b.foreign_intraday_vol,0), coalesce(a.foreign_intraday_val,0) + coalesce(b.foreign_intraday_val,0), 
coalesce(a.inst_intraday_vol,0) + coalesce(b.inst_intraday_vol,0), coalesce(a.inst_intraday_val,0) + coalesce(b.inst_intraday_val,0),
coalesce(a.local_inst_intraday_vol,0) + coalesce(b.local_inst_intraday_vol,0), coalesce(a.local_inst_intraday_val,0) + coalesce(b.local_inst_intraday_val,0), 
coalesce(a.foreign_inst_intraday_vol,0) + coalesce(b.foreign_inst_intraday_vol,0), coalesce(a.foreign_inst_intraday_val,0) + coalesce(b.foreign_inst_intraday_val,0), 
coalesce(a.retail_intraday_vol,0) + coalesce(b.retail_intraday_vol,0), coalesce(a.retail_intraday_val,0) + coalesce(b.retail_intraday_val,0),
coalesce(a.local_retail_intraday_vol,0) + coalesce(b.local_retail_intraday_vol,0), coalesce(a.local_retail_intraday_val,0) + coalesce(b.local_retail_intraday_val,0), 
coalesce(a.foreign_retail_intraday_vol,0) + coalesce(b.foreign_retail_intraday_vol,0), coalesce(a.foreign_retail_intraday_val,0) + coalesce(b.foreign_retail_intraday_val,0), 
coalesce(a.nominees_intraday_vol,0) + coalesce(b.nominees_intraday_vol,0), coalesce(a.nominees_intraday_val,0) + coalesce(b.nominees_intraday_val,0),
coalesce(a.local_nominees_intraday_vol,0) + coalesce(b.local_nominees_intraday_vol,0), coalesce(a.local_nominees_intraday_val,0) + coalesce(b.local_nominees_intraday_val,0), 
coalesce(a.foreign_nominees_intraday_vol,0) + coalesce(b.foreign_nominees_intraday_vol,0), coalesce(a.foreign_nominees_intraday_val,0) + coalesce(b.foreign_nominees_intraday_val,0),
coalesce(a.ivt_intraday_vol,0) + coalesce(b.ivt_intraday_vol,0), coalesce(a.ivt_intraday_val,0) + coalesce(b.ivt_intraday_val,0), 
coalesce(a.pdt_intraday_vol,0) + coalesce(b.pdt_intraday_vol,0), coalesce(a.pdt_intraday_val,0) + coalesce(b.pdt_intraday_val,0)
from dibots_v2.exchange_demography_stock_week a
full join dibots_v2.exchange_dbt_stock b
on a.trading_date = b.trading_date and a.stock_code = b.stock_code
where (a.trading_date >= '2020-01-01' or b.trading_date >= '2020-01-01');

-- INSERT OMT data
insert into dibots_v2.exchange_omtdbt_stock (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val,
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, ivt_vol, ivt_val, pdt_vol, pdt_val, net_inst_vol, net_inst_val, 
net_local_inst_vol, net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val,
net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, 
net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, 
inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, 
local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, 
local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val,
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, ivt_vol, ivt_val, pdt_vol, pdt_val, net_inst_vol, net_inst_val, 
net_local_inst_vol, net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val,
net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, 
net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, 
inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, 
local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, 
local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val
from dibots_v2.exchange_demography_stock_week 
where trading_date < '2020-01-01'

-- incremental update
insert into dibots_v2.exchange_omtdbt_stock (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val,
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, ivt_vol, ivt_val, pdt_vol, pdt_val, net_inst_vol, net_inst_val, 
net_local_inst_vol, net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val,
net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, 
net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, 
inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, 
local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, 
local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.stock_code,b.stock_code), coalesce(a.stock_name,b.stock_name), coalesce(a.stock_num,b.stock_num), coalesce(a.board,b.board), 
coalesce(a.sector,b.sector), coalesce(a.klci_flag,b.klci_flag), coalesce(a.fbm100_flag,b.fbm100_flag), coalesce(a.shariah_flag,b.shariah_flag), 
coalesce(a.total_vol,0) + coalesce(b.total_vol,0), coalesce(a.total_val,0) + coalesce(b.total_val,0),
coalesce(a.local_vol,0) + coalesce(b.local_vol,0), coalesce(a.local_val,0) + coalesce(b.local_val,0), 
coalesce(a.foreign_vol,0) + coalesce(b.foreign_vol,0), coalesce(a.foreign_val,0) + coalesce(b.foreign_val,0),
coalesce(a.inst_vol,0) + coalesce(b.inst_vol,0), coalesce(a.inst_val,0) + coalesce(b.inst_val,0), 
coalesce(a.local_inst_vol,0) + coalesce(b.local_inst_vol,0), coalesce(a.local_inst_val,0) + coalesce(b.local_inst_val,0),
coalesce(a.foreign_inst_vol,0) + coalesce(b.foreign_inst_vol,0), coalesce(a.foreign_inst_val,0) + coalesce(b.foreign_inst_val,0), 
coalesce(a.retail_vol,0) + coalesce(b.retail_vol,0), coalesce(a.retail_val,0) + coalesce(b.retail_val,0),
coalesce(a.local_retail_vol,0) + coalesce(b.local_retail_vol,0), coalesce(a.local_retail_val,0) + coalesce(b.local_retail_val,0), 
coalesce(a.foreign_retail_vol,0) + coalesce(b.foreign_retail_vol,0), coalesce(a.foreign_retail_val,0) + coalesce(b.foreign_retail_val,0), 
coalesce(a.nominees_vol,0) + coalesce(b.nominees_vol,0), coalesce(a.nominees_val,0) + coalesce(b.nominees_val,0),
coalesce(a.local_nominees_vol,0) + coalesce(b.local_nominees_vol,0), coalesce(a.local_nominees_val,0) + coalesce(b.local_nominees_val,0), 
coalesce(a.foreign_nominees_vol,0) + coalesce(b.foreign_nominees_vol,0), coalesce(a.foreign_nominees_val,0) + coalesce(b.foreign_nominees_val,0), 
coalesce(a.ivt_vol,0) + coalesce(b.ivt_vol,0), coalesce(a.ivt_val,0) + coalesce(b.ivt_val,0),
coalesce(a.pdt_vol,0) + coalesce(b.pdt_vol,0), coalesce(a.pdt_val,0) + coalesce(b.pdt_val,0), 
coalesce(a.net_inst_vol,0) + coalesce(b.net_inst_vol,0), coalesce(a.net_inst_val,0) + coalesce(b.net_inst_val,0), 
coalesce(a.net_local_inst_vol,0) + coalesce(b.net_local_inst_vol,0), coalesce(a.net_local_inst_val,0) + coalesce(b.net_local_inst_val,0), 
coalesce(a.net_foreign_inst_vol,0) + coalesce(b.net_foreign_inst_vol,0),coalesce(a.net_foreign_inst_val,0) + coalesce(b.net_foreign_inst_val,0),
coalesce(a.net_retail_vol,0) + coalesce(b.net_retail_vol,0), coalesce(a.net_retail_val,0) + coalesce(b.net_retail_val,0), 
coalesce(a.net_local_retail_vol,0) + coalesce(b.net_local_retail_vol,0), coalesce(a.net_local_retail_val,0) + coalesce(b.net_local_retail_val,0), 
coalesce(a.net_foreign_retail_vol,0) + coalesce(b.net_foreign_retail_vol,0), coalesce(a.net_foreign_retail_val,0) + coalesce(b.net_foreign_retail_val,0),
coalesce(a.net_nominees_vol,0) + coalesce(b.net_nominees_vol,0), coalesce(a.net_nominees_val,0) + coalesce(b.net_nominees_val,0),
coalesce(a.net_local_nominees_vol,0) + coalesce(b.net_local_nominees_vol,0), coalesce(a.net_local_nominees_val,0) + coalesce(b.net_local_nominees_val,0),
coalesce(a.net_foreign_nominees_vol,0) + coalesce(b.net_foreign_nominees_vol,0), coalesce(a.net_foreign_nominees_val,0) + coalesce(b.net_foreign_nominees_val,0), 
coalesce(a.net_ivt_vol,0) + coalesce(b.net_ivt_vol,0), coalesce(a.net_ivt_val,0) + coalesce(b.net_ivt_val,0), 
coalesce(a.net_pdt_vol,0) + coalesce(b.net_pdt_vol,0), coalesce(a.net_pdt_val,0) + coalesce(b.net_pdt_val,0), 
coalesce(a.net_local_vol,0) + coalesce(b.net_local_vol,0), coalesce(a.net_local_val,0) + coalesce(b.net_local_val,0), 
coalesce(a.net_foreign_vol,0) + coalesce(b.net_foreign_vol,0), coalesce(a.net_foreign_val,0) + coalesce(b.net_foreign_val,0), 
coalesce(a.total_intraday_vol,0) + coalesce(b.total_intraday_vol,0), coalesce(a.total_intraday_val,0) + coalesce(b.total_intraday_val,0),
coalesce(a.local_intraday_vol,0) + coalesce(b.local_intraday_vol,0), coalesce(a.local_intraday_val,0) + coalesce(b.local_intraday_val,0), 
coalesce(a.foreign_intraday_vol,0) + coalesce(b.foreign_intraday_vol,0), coalesce(a.foreign_intraday_val,0) + coalesce(b.foreign_intraday_val,0), 
coalesce(a.inst_intraday_vol,0) + coalesce(b.inst_intraday_vol,0), coalesce(a.inst_intraday_val,0) + coalesce(b.inst_intraday_val,0),
coalesce(a.local_inst_intraday_vol,0) + coalesce(b.local_inst_intraday_vol,0), coalesce(a.local_inst_intraday_val,0) + coalesce(b.local_inst_intraday_val,0), 
coalesce(a.foreign_inst_intraday_vol,0) + coalesce(b.foreign_inst_intraday_vol,0), coalesce(a.foreign_inst_intraday_val,0) + coalesce(b.foreign_inst_intraday_val,0), 
coalesce(a.retail_intraday_vol,0) + coalesce(b.retail_intraday_vol,0), coalesce(a.retail_intraday_val,0) + coalesce(b.retail_intraday_val,0),
coalesce(a.local_retail_intraday_vol,0) + coalesce(b.local_retail_intraday_vol,0), coalesce(a.local_retail_intraday_val,0) + coalesce(b.local_retail_intraday_val,0), 
coalesce(a.foreign_retail_intraday_vol,0) + coalesce(b.foreign_retail_intraday_vol,0), coalesce(a.foreign_retail_intraday_val,0) + coalesce(b.foreign_retail_intraday_val,0), 
coalesce(a.nominees_intraday_vol,0) + coalesce(b.nominees_intraday_vol,0), coalesce(a.nominees_intraday_val,0) + coalesce(b.nominees_intraday_val,0),
coalesce(a.local_nominees_intraday_vol,0) + coalesce(b.local_nominees_intraday_vol,0), coalesce(a.local_nominees_intraday_val,0) + coalesce(b.local_nominees_intraday_val,0), 
coalesce(a.foreign_nominees_intraday_vol,0) + coalesce(b.foreign_nominees_intraday_vol,0), coalesce(a.foreign_nominees_intraday_val,0) + coalesce(b.foreign_nominees_intraday_val,0),
coalesce(a.ivt_intraday_vol,0) + coalesce(b.ivt_intraday_vol,0), coalesce(a.ivt_intraday_val,0) + coalesce(b.ivt_intraday_val,0), 
coalesce(a.pdt_intraday_vol,0) + coalesce(b.pdt_intraday_vol,0), coalesce(a.pdt_intraday_val,0) + coalesce(b.pdt_intraday_val,0)
from dibots_v2.exchange_demography_stock_week a
full join dibots_v2.exchange_dbt_stock b
on a.trading_date = b.trading_date and a.stock_code = b.stock_code
where (a.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock) or b.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock));


--====================================
-- EXCHANGE_OMTDBT_STOCK_BROKER_GROUP
--====================================

create table dibots_v2.exchange_omtdbt_stock_broker_group (
trading_date date not null,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
external_id int,
participant_code int,
participant_name varchar(100),
total_vol bigint,
total_val numeric(25,2),
local_vol bigint,
local_val numeric(25,2),
foreign_vol bigint,
foreign_val numeric(25,2),
prop_vol bigint,
prop_val numeric(25,2),
inst_vol bigint,
inst_val numeric(25,2),
local_inst_vol bigint,
local_inst_val numeric(25,2),
foreign_inst_vol bigint,
foreign_inst_val numeric(25,2),
retail_vol bigint,
retail_val numeric(25,2),
local_retail_vol bigint,
local_retail_val numeric(25,2),
foreign_retail_vol bigint,
foreign_retail_val numeric(25,2),
nominees_vol bigint,
nominees_val numeric(25,2),
local_nominees_vol bigint,
local_nominees_val numeric(25,2),
foreign_nominees_vol bigint,
foreign_nominees_val numeric(25,2),
ivt_vol bigint,
ivt_val numeric(25,2),
pdt_vol bigint,
pdt_val numeric(25,2),
net_vol bigint,
net_val numeric(25,2),
net_local_vol bigint,
net_local_val numeric(25,2),
net_foreign_vol bigint,
net_foreign_val numeric(25,2),
net_prop_vol bigint,
net_prop_val numeric(25,2),
net_inst_vol bigint,
net_inst_val numeric(25,2),
net_local_inst_vol bigint,
net_local_inst_val numeric(25,2),
net_foreign_inst_vol bigint,
net_foreign_inst_val numeric(25,2),
net_retail_vol bigint,
net_retail_val numeric(25,2),
net_local_retail_vol bigint,
net_local_retail_val numeric(25,2),
net_foreign_retail_vol bigint,
net_foreign_retail_val numeric(25,2),
net_nominees_vol bigint,
net_nominees_val numeric(25,2),
net_local_nominees_vol bigint,
net_local_nominees_val numeric(25,2),
net_foreign_nominees_vol bigint,
net_foreign_nominees_val numeric(25,2),
net_ivt_vol bigint,
net_ivt_val numeric(25,2),
net_pdt_vol bigint,
net_pdt_val numeric(25,2),
total_intraday_vol bigint,
total_intraday_val numeric(25,2),
local_intraday_vol bigint,
local_intraday_val numeric(25,2),
foreign_intraday_vol bigint,
foreign_intraday_val numeric(25,2),
inst_intraday_vol bigint,
inst_intraday_val numeric(25,2),
local_inst_intraday_vol bigint,
local_inst_intraday_val numeric(25,2),
foreign_inst_intraday_vol bigint,
foreign_inst_intraday_val numeric(25,2),
retail_intraday_vol bigint,
retail_intraday_val numeric(25,2),
local_retail_intraday_vol bigint,
local_retail_intraday_val numeric(25,2),
foreign_retail_intraday_vol bigint,
foreign_retail_intraday_val numeric(25,2),
nominees_intraday_vol bigint,
nominees_intraday_val numeric(25,2),
local_nominees_intraday_vol bigint,
local_nominees_intraday_val numeric(25,2),
foreign_nominees_intraday_vol bigint,
foreign_nominees_intraday_val numeric(25,2),
ivt_intraday_vol bigint,
ivt_intraday_val numeric(25,2),
pdt_intraday_vol bigint,
pdt_intraday_val numeric(25,2)
)PARTITION BY RANGE (trading_date);

alter table dibots_v2.exchange_omtdbt_stock_broker_group add constraint eomtdbt_stock_broker_group_pkey primary key (trading_date, participant_code, stock_code);

create table dibots_v2.exchange_omtdbt_stock_broker_group_y2020q01 partition of dibots_v2.exchange_omtdbt_stock_broker_group
for values from ('2020-01-01') to ('2020-04-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2020q02 partition of dibots_v2.exchange_omtdbt_stock_broker_group
for values from ('2020-04-01') to ('2020-07-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2020q03 partition of dibots_v2.exchange_omtdbt_stock_broker_group
for values from ('2020-07-01') to ('2020-10-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2020q04 partition of dibots_v2.exchange_omtdbt_stock_broker_group
for values from ('2020-10-01') to ('2021-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2021q01 partition of dibots_v2.exchange_omtdbt_stock_broker_group
for values from ('2021-01-01') to ('2021-04-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2021q02 partition of dibots_v2.exchange_omtdbt_stock_broker_group
for values from ('2021-04-01') to ('2021-07-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2021q03 partition of dibots_v2.exchange_omtdbt_stock_broker_group
for values from ('2021-07-01') to ('2021-10-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2021q04 partition of dibots_v2.exchange_omtdbt_stock_broker_group
for values from ('2021-10-01') to ('2022-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2022q01 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2022-01-01') to ('2022-04-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2022q02 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2022-04-01') to ('2022-07-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2022q03 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2022-07-01') to ('2022-10-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2022q04 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2022-10-01') to ('2023-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2023q01 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2023-01-01') to ('2023-04-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2023q02 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2023-04-01') to ('2023-07-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2023q03 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2023-07-01') to ('2023-10-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2023q04 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2023-10-01') to ('2024-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2024q01 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2024-01-01') to ('2024-04-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2024q02 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2024-04-01') to ('2024-07-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2024q03 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2024-07-01') to ('2024-10-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2024q04 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2024-10-01') to ('2025-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2025q01 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2025-01-01') to ('2025-04-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2025q02 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2025-04-01') to ('2025-07-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2025q03 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2025-07-01') to ('2025-10-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_y2025q04 partition of dibots_v2.exchange_omtdbt_stock_broker_group 
for values from ('2025-10-01') to ('2026-01-01');
create table dibots_v2.exchange_omtdbt_stock_broker_group_default partition of dibots_v2.exchange_omtdbt_stock_broker_group default;

create index eomtdbtsbg_trading_date_idx on dibots_v2.exchange_omtdbt_stock_broker_group (trading_date);
create index eomtdbtsbg_stock_code_idx on dibots_v2.exchange_omtdbt_stock_broker_group (stock_code);
create index eomtdbtsbg_partcpt_code_idx on dibots_v2.exchange_omtdbt_stock_broker_group (participant_code);
create index eomtdbtsbg_ext_id_idx on dibots_v2.exchange_omtdbt_stock_broker_group (external_id);

insert into dibots_v2.exchange_omtdbt_stock_broker_group (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name, 
total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val, prop_vol, prop_val, inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, 
retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, 
ivt_vol, ivt_val, pdt_vol, pdt_val, net_vol, net_val, net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, net_prop_vol, net_prop_val, net_inst_vol, net_inst_val, net_local_inst_vol, 
net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val, 
net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, 
total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, 
local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, 
foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, 
ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val, buy_vol, buy_val, sell_vol, sell_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.stock_code,b.stock_code), coalesce(a.stock_name,b.stock_name), coalesce(a.stock_num,b.stock_num),
coalesce(a.board,b.board), coalesce(a.sector,b.sector), coalesce(a.klci_flag,b.klci_flag), coalesce(a.fbm100_flag,b.fbm100_flag), 
coalesce(a.shariah_flag,b.shariah_flag), coalesce(a.external_id,b.external_id), coalesce(a.participant_code,b.participant_code), coalesce(a.participant_name,b.participant_name),
coalesce(a.total_volume,0) + coalesce(b.total_vol,0), coalesce(a.total_value,0) + coalesce(b.total_val,0),
coalesce(a.local_volume,0) + coalesce(b.local_vol,0), coalesce(a.local_value,0) + coalesce(b.local_val,0), 
coalesce(a.foreign_volume,0) + coalesce(b.foreign_vol,0), coalesce(a.foreign_value,0) + coalesce(b.foreign_val,0),
coalesce(a.prop_volume,0) + coalesce(b.prop_vol,0), coalesce(a.prop_value,0) + coalesce(b.prop_val,0),
coalesce(a.total_inst_volume,0) + coalesce(b.inst_vol,0), coalesce(a.total_inst_value,0) + coalesce(b.inst_val,0), 
coalesce(a.local_inst_volume,0) + coalesce(b.local_inst_vol,0), coalesce(a.local_inst_value,0) + coalesce(b.local_inst_val,0),
coalesce(a.foreign_inst_volume,0) + coalesce(b.foreign_inst_vol,0), coalesce(a.foreign_inst_value,0) + coalesce(b.foreign_inst_val,0), 
coalesce(a.total_retail_volume,0) + coalesce(b.retail_vol,0), coalesce(a.total_retail_value,0) + coalesce(b.retail_val,0),
coalesce(a.local_retail_volume,0) + coalesce(b.local_retail_vol,0), coalesce(a.local_retail_value,0) + coalesce(b.local_retail_val,0), 
coalesce(a.foreign_retail_volume,0) + coalesce(b.foreign_retail_vol,0), coalesce(a.foreign_retail_value,0) + coalesce(b.foreign_retail_val,0), 
coalesce(a.total_nominees_volume,0) + coalesce(b.nominees_vol,0), coalesce(a.total_nominees_value,0) + coalesce(b.nominees_val,0),
coalesce(a.local_nominees_volume,0) + coalesce(b.local_nominees_vol,0), coalesce(a.local_nominees_value,0) + coalesce(b.local_nominees_val,0), 
coalesce(a.foreign_nominees_volume,0) + coalesce(b.foreign_nominees_vol,0), coalesce(a.foreign_nominees_value,0) + coalesce(b.foreign_nominees_val,0), 
coalesce(a.ivt_volume,0) + coalesce(b.ivt_vol,0), coalesce(a.ivt_value,0) + coalesce(b.ivt_val,0),
coalesce(a.pdt_volume,0) + coalesce(b.pdt_vol,0), coalesce(a.pdt_value,0) + coalesce(b.pdt_val,0), 
coalesce(a.net_volume,0) + coalesce(b.net_vol,0), coalesce(a.net_value,0) + coalesce(b.net_val,0), 
coalesce(a.net_local_volume,0) + coalesce(b.net_local_vol,0), coalesce(a.net_local_value,0) + coalesce(b.net_local_val,0), 
coalesce(a.net_foreign_volume,0) + coalesce(b.net_foreign_vol,0), coalesce(a.net_foreign_value,0) + coalesce(b.net_foreign_val,0), 
coalesce(a.net_prop_volume,0) + coalesce(b.net_prop_vol,0), coalesce(a.net_prop_value,0) + coalesce(b.net_prop_val,0), 
coalesce(a.net_inst_volume,0) + coalesce(b.net_inst_vol,0), coalesce(a.net_inst_value,0) + coalesce(b.net_inst_val,0), 
coalesce(a.net_local_inst_vol,0) + coalesce(b.net_local_inst_vol,0), coalesce(a.net_local_inst_val,0) + coalesce(b.net_local_inst_val,0), 
coalesce(a.net_foreign_inst_vol,0) + coalesce(b.net_foreign_inst_vol,0),coalesce(a.net_foreign_inst_val,0) + coalesce(b.net_foreign_inst_val,0),
coalesce(a.net_retail_volume,0) + coalesce(b.net_retail_vol,0), coalesce(a.net_retail_value,0) + coalesce(b.net_retail_val,0), 
coalesce(a.net_local_retail_vol,0) + coalesce(b.net_local_retail_vol,0), coalesce(a.net_local_retail_val,0) + coalesce(b.net_local_retail_val,0), 
coalesce(a.net_foreign_retail_vol,0) + coalesce(b.net_foreign_retail_vol,0), coalesce(a.net_foreign_retail_val,0) + coalesce(b.net_foreign_retail_val,0),
coalesce(a.net_nominees_volume,0) + coalesce(b.net_nominees_vol,0), coalesce(a.net_nominees_value,0) + coalesce(b.net_nominees_val,0),
coalesce(a.net_local_nominees_vol,0) + coalesce(b.net_local_nominees_vol,0), coalesce(a.net_local_nominees_val,0) + coalesce(b.net_local_nominees_val,0),
coalesce(a.net_foreign_nominees_vol,0) + coalesce(b.net_foreign_nominees_vol,0), coalesce(a.net_foreign_nominees_val,0) + coalesce(b.net_foreign_nominees_val,0), 
coalesce(a.net_ivt_volume,0) + coalesce(b.net_ivt_vol,0), coalesce(a.net_ivt_value,0) + coalesce(b.net_ivt_val,0), 
coalesce(a.net_pdt_volume,0) + coalesce(b.net_pdt_vol,0), coalesce(a.net_pdt_value,0) + coalesce(b.net_pdt_val,0), 
coalesce(a.total_intraday_vol,0) + coalesce(b.total_intraday_vol,0), coalesce(a.total_intraday_val,0) + coalesce(b.total_intraday_val,0),
coalesce(a.local_intraday_vol,0) + coalesce(b.local_intraday_vol,0), coalesce(a.local_intraday_val,0) + coalesce(b.local_intraday_val,0), 
coalesce(a.foreign_intraday_vol,0) + coalesce(b.foreign_intraday_vol,0), coalesce(a.foreign_intraday_val,0) + coalesce(b.foreign_intraday_val,0), 
coalesce(a.inst_intraday_vol,0) + coalesce(b.inst_intraday_vol,0), coalesce(a.inst_intraday_val,0) + coalesce(b.inst_intraday_val,0),
coalesce(a.local_inst_intraday_vol,0) + coalesce(b.local_inst_intraday_vol,0), coalesce(a.local_inst_intraday_val,0) + coalesce(b.local_inst_intraday_val,0), 
coalesce(a.foreign_inst_intraday_vol,0) + coalesce(b.foreign_inst_intraday_vol,0), coalesce(a.foreign_inst_intraday_val,0) + coalesce(b.foreign_inst_intraday_val,0), 
coalesce(a.retail_intraday_vol,0) + coalesce(b.retail_intraday_vol,0), coalesce(a.retail_intraday_val,0) + coalesce(b.retail_intraday_val,0),
coalesce(a.local_retail_intraday_vol,0) + coalesce(b.local_retail_intraday_vol,0), coalesce(a.local_retail_intraday_val,0) + coalesce(b.local_retail_intraday_val,0), 
coalesce(a.foreign_retail_intraday_vol,0) + coalesce(b.foreign_retail_intraday_vol,0), coalesce(a.foreign_retail_intraday_val,0) + coalesce(b.foreign_retail_intraday_val,0), 
coalesce(a.nominees_intraday_vol,0) + coalesce(b.nominees_intraday_vol,0), coalesce(a.nominees_intraday_val,0) + coalesce(b.nominees_intraday_val,0),
coalesce(a.local_nominees_intraday_vol,0) + coalesce(b.local_nominees_intraday_vol,0), coalesce(a.local_nominees_intraday_val,0) + coalesce(b.local_nominees_intraday_val,0), 
coalesce(a.foreign_nominees_intraday_vol,0) + coalesce(b.foreign_nominees_intraday_vol,0), coalesce(a.foreign_nominees_intraday_val,0) + coalesce(b.foreign_nominees_intraday_val,0),
coalesce(a.ivt_intraday_vol,0) + coalesce(b.ivt_intraday_vol,0), coalesce(a.ivt_intraday_val,0) + coalesce(b.ivt_intraday_val,0), 
coalesce(a.pdt_intraday_vol,0) + coalesce(b.pdt_intraday_vol,0), coalesce(a.pdt_intraday_val,0) + coalesce(b.pdt_intraday_val,0),
coalesce(a.buy_vol,0) + coalesce(b.buy_vol,0), coalesce(a.buy_val,0) + coalesce(b.buy_val,0),
coalesce(a.sell_vol,0) + coalesce(b.sell_vol,0), coalesce(a.sell_val,0) + coalesce(b.sell_val,0)
from dibots_v2.exchange_demography_stock_broker_group a
full join dibots_v2.exchange_dbt_stock_broker_group b
on a.trading_date = b.trading_date and a.participant_code = b.participant_code and a.stock_code = b.stock_code
where (a.trading_date >= '2020-01-01' or b.trading_date >= '2020-01-01');

-- INSERT OMT data
insert into dibots_v2.exchange_omtdbt_stock_broker_group (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name, 
total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val, prop_vol, prop_val, inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, 
retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, 
ivt_vol, ivt_val, pdt_vol, pdt_val, net_vol, net_val, net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, net_prop_vol, net_prop_val, net_inst_vol, net_inst_val, net_local_inst_vol, 
net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val, 
net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, 
total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, 
local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, 
foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, 
ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val, buy_vol, buy_val, sell_vol, sell_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name, 
total_volume, total_value, local_volume, local_value, foreign_volume, foreign_value, prop_volume, prop_value, total_inst_volume, total_inst_value, local_inst_volume, local_inst_value, foreign_inst_volume, foreign_inst_value, 
total_retail_volume, total_retail_value, local_retail_volume, local_retail_value, foreign_retail_volume, foreign_retail_value, total_nominees_volume, total_nominees_value, local_nominees_volume, local_nominees_value, 
foreign_nominees_volume, foreign_nominees_value, ivt_volume, ivt_value, pdt_volume, pdt_value, net_volume, net_value, net_local_volume, net_local_value, net_foreign_volume, net_foreign_value, 
net_prop_volume, net_prop_value, net_inst_volume, net_inst_value, net_local_inst_vol, net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_volume, net_retail_value, 
net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val, 
net_nominees_volume, net_nominees_value, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_volume, net_ivt_value, net_pdt_volume, net_pdt_value, 
total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, 
local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, 
foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, 
ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val, buy_vol, buy_val, sell_vol, sell_val
from dibots_v2.exchange_demography_stock_broker_group
where trading_date < '2020-01-01';

-- incremental update
insert into dibots_v2.exchange_omtdbt_stock_broker_group (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name, 
total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val, prop_vol, prop_val, inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, 
retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, 
ivt_vol, ivt_val, pdt_vol, pdt_val, net_vol, net_val, net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, net_prop_vol, net_prop_val, net_inst_vol, net_inst_val, net_local_inst_vol, 
net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val, 
net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, 
total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, 
local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, 
foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, 
ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val, buy_vol, buy_val, sell_vol, sell_val)
select coalesce(a.trading_date,b.trading_date), coalesce(a.stock_code,b.stock_code), coalesce(a.stock_name,b.stock_name), coalesce(a.stock_num,b.stock_num),
coalesce(a.board,b.board), coalesce(a.sector,b.sector), coalesce(a.klci_flag,b.klci_flag), coalesce(a.fbm100_flag,b.fbm100_flag), 
coalesce(a.shariah_flag,b.shariah_flag), coalesce(a.external_id,b.external_id), coalesce(a.participant_code,b.participant_code), coalesce(a.participant_name,b.participant_name),
coalesce(a.total_volume,0) + coalesce(b.total_vol,0), coalesce(a.total_value,0) + coalesce(b.total_val,0),
coalesce(a.local_volume,0) + coalesce(b.local_vol,0), coalesce(a.local_value,0) + coalesce(b.local_val,0), 
coalesce(a.foreign_volume,0) + coalesce(b.foreign_vol,0), coalesce(a.foreign_value,0) + coalesce(b.foreign_val,0),
coalesce(a.prop_volume,0) + coalesce(b.prop_vol,0), coalesce(a.prop_value,0) + coalesce(b.prop_val,0),
coalesce(a.total_inst_volume,0) + coalesce(b.inst_vol,0), coalesce(a.total_inst_value,0) + coalesce(b.inst_val,0), 
coalesce(a.local_inst_volume,0) + coalesce(b.local_inst_vol,0), coalesce(a.local_inst_value,0) + coalesce(b.local_inst_val,0),
coalesce(a.foreign_inst_volume,0) + coalesce(b.foreign_inst_vol,0), coalesce(a.foreign_inst_value,0) + coalesce(b.foreign_inst_val,0), 
coalesce(a.total_retail_volume,0) + coalesce(b.retail_vol,0), coalesce(a.total_retail_value,0) + coalesce(b.retail_val,0),
coalesce(a.local_retail_volume,0) + coalesce(b.local_retail_vol,0), coalesce(a.local_retail_value,0) + coalesce(b.local_retail_val,0), 
coalesce(a.foreign_retail_volume,0) + coalesce(b.foreign_retail_vol,0), coalesce(a.foreign_retail_value,0) + coalesce(b.foreign_retail_val,0), 
coalesce(a.total_nominees_volume,0) + coalesce(b.nominees_vol,0), coalesce(a.total_nominees_value,0) + coalesce(b.nominees_val,0),
coalesce(a.local_nominees_volume,0) + coalesce(b.local_nominees_vol,0), coalesce(a.local_nominees_value,0) + coalesce(b.local_nominees_val,0), 
coalesce(a.foreign_nominees_volume,0) + coalesce(b.foreign_nominees_vol,0), coalesce(a.foreign_nominees_value,0) + coalesce(b.foreign_nominees_val,0), 
coalesce(a.ivt_volume,0) + coalesce(b.ivt_vol,0), coalesce(a.ivt_value,0) + coalesce(b.ivt_val,0),
coalesce(a.pdt_volume,0) + coalesce(b.pdt_vol,0), coalesce(a.pdt_value,0) + coalesce(b.pdt_val,0), 
coalesce(a.net_volume,0) + coalesce(b.net_vol,0), coalesce(a.net_value,0) + coalesce(b.net_val,0), 
coalesce(a.net_local_volume,0) + coalesce(b.net_local_vol,0), coalesce(a.net_local_value,0) + coalesce(b.net_local_val,0), 
coalesce(a.net_foreign_volume,0) + coalesce(b.net_foreign_vol,0), coalesce(a.net_foreign_value,0) + coalesce(b.net_foreign_val,0), 
coalesce(a.net_prop_volume,0) + coalesce(b.net_prop_vol,0), coalesce(a.net_prop_value,0) + coalesce(b.net_prop_val,0), 
coalesce(a.net_inst_volume,0) + coalesce(b.net_inst_vol,0), coalesce(a.net_inst_value,0) + coalesce(b.net_inst_val,0), 
coalesce(a.net_local_inst_vol,0) + coalesce(b.net_local_inst_vol,0), coalesce(a.net_local_inst_val,0) + coalesce(b.net_local_inst_val,0), 
coalesce(a.net_foreign_inst_vol,0) + coalesce(b.net_foreign_inst_vol,0),coalesce(a.net_foreign_inst_val,0) + coalesce(b.net_foreign_inst_val,0),
coalesce(a.net_retail_volume,0) + coalesce(b.net_retail_vol,0), coalesce(a.net_retail_value,0) + coalesce(b.net_retail_val,0), 
coalesce(a.net_local_retail_vol,0) + coalesce(b.net_local_retail_vol,0), coalesce(a.net_local_retail_val,0) + coalesce(b.net_local_retail_val,0), 
coalesce(a.net_foreign_retail_vol,0) + coalesce(b.net_foreign_retail_vol,0), coalesce(a.net_foreign_retail_val,0) + coalesce(b.net_foreign_retail_val,0),
coalesce(a.net_nominees_volume,0) + coalesce(b.net_nominees_vol,0), coalesce(a.net_nominees_value,0) + coalesce(b.net_nominees_val,0),
coalesce(a.net_local_nominees_vol,0) + coalesce(b.net_local_nominees_vol,0), coalesce(a.net_local_nominees_val,0) + coalesce(b.net_local_nominees_val,0),
coalesce(a.net_foreign_nominees_vol,0) + coalesce(b.net_foreign_nominees_vol,0), coalesce(a.net_foreign_nominees_val,0) + coalesce(b.net_foreign_nominees_val,0), 
coalesce(a.net_ivt_volume,0) + coalesce(b.net_ivt_vol,0), coalesce(a.net_ivt_value,0) + coalesce(b.net_ivt_val,0), 
coalesce(a.net_pdt_volume,0) + coalesce(b.net_pdt_vol,0), coalesce(a.net_pdt_value,0) + coalesce(b.net_pdt_val,0), 
coalesce(a.total_intraday_vol,0) + coalesce(b.total_intraday_vol,0), coalesce(a.total_intraday_val,0) + coalesce(b.total_intraday_val,0),
coalesce(a.local_intraday_vol,0) + coalesce(b.local_intraday_vol,0), coalesce(a.local_intraday_val,0) + coalesce(b.local_intraday_val,0), 
coalesce(a.foreign_intraday_vol,0) + coalesce(b.foreign_intraday_vol,0), coalesce(a.foreign_intraday_val,0) + coalesce(b.foreign_intraday_val,0), 
coalesce(a.inst_intraday_vol,0) + coalesce(b.inst_intraday_vol,0), coalesce(a.inst_intraday_val,0) + coalesce(b.inst_intraday_val,0),
coalesce(a.local_inst_intraday_vol,0) + coalesce(b.local_inst_intraday_vol,0), coalesce(a.local_inst_intraday_val,0) + coalesce(b.local_inst_intraday_val,0), 
coalesce(a.foreign_inst_intraday_vol,0) + coalesce(b.foreign_inst_intraday_vol,0), coalesce(a.foreign_inst_intraday_val,0) + coalesce(b.foreign_inst_intraday_val,0), 
coalesce(a.retail_intraday_vol,0) + coalesce(b.retail_intraday_vol,0), coalesce(a.retail_intraday_val,0) + coalesce(b.retail_intraday_val,0),
coalesce(a.local_retail_intraday_vol,0) + coalesce(b.local_retail_intraday_vol,0), coalesce(a.local_retail_intraday_val,0) + coalesce(b.local_retail_intraday_val,0), 
coalesce(a.foreign_retail_intraday_vol,0) + coalesce(b.foreign_retail_intraday_vol,0), coalesce(a.foreign_retail_intraday_val,0) + coalesce(b.foreign_retail_intraday_val,0), 
coalesce(a.nominees_intraday_vol,0) + coalesce(b.nominees_intraday_vol,0), coalesce(a.nominees_intraday_val,0) + coalesce(b.nominees_intraday_val,0),
coalesce(a.local_nominees_intraday_vol,0) + coalesce(b.local_nominees_intraday_vol,0), coalesce(a.local_nominees_intraday_val,0) + coalesce(b.local_nominees_intraday_val,0), 
coalesce(a.foreign_nominees_intraday_vol,0) + coalesce(b.foreign_nominees_intraday_vol,0), coalesce(a.foreign_nominees_intraday_val,0) + coalesce(b.foreign_nominees_intraday_val,0),
coalesce(a.ivt_intraday_vol,0) + coalesce(b.ivt_intraday_vol,0), coalesce(a.ivt_intraday_val,0) + coalesce(b.ivt_intraday_val,0), 
coalesce(a.pdt_intraday_vol,0) + coalesce(b.pdt_intraday_vol,0), coalesce(a.pdt_intraday_val,0) + coalesce(b.pdt_intraday_val,0),
coalesce(a.buy_vol,0) + coalesce(b.buy_vol,0), coalesce(a.buy_val,0) + coalesce(b.buy_val,0),
coalesce(a.sell_vol,0) + coalesce(b.sell_vol,0), coalesce(a.sell_val,0) + coalesce(b.sell_val,0)
from dibots_v2.exchange_demography_stock_broker_group a
full join dibots_v2.exchange_dbt_stock_broker_group b
on a.trading_date = b.trading_date and a.participant_code = b.participant_code and a.stock_code = b.stock_code
where (a.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker_group) or 
b.trading_date > (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker_group));
