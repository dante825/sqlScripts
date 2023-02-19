--============================================
-- EXCHANGE_DEMOGRAPHY PARTITIIONING
--============================================

CREATE TABLE dibots_v2.exchange_demography
(
   trading_date date NOT NULL,
   market_transaction_type varchar(20) NOT NULL,
   stock_code varchar(20) NOT NULL,
   stock_name varchar(20),
   stock_num int,
   participant_code int NOT NULL,
   participant_name text NOT NULL,
   account_identifier bigint NOT NULL,
   intraday_account_type varchar(20),
   investor_identifier bigint NOT NULL,
   investor_type varchar(20) NOT NULL,
   account_type varchar(2) NOT NULL,
   age int NOT NULL,
   age_band varchar(30),
   gender varchar(30) NOT NULL,
   race varchar(20) NOT NULL,
   locality varchar(30) NOT NULL,
   nationality varchar(3) NOT NULL,
   gross_traded_volume_buy bigint NOT NULL,
   gross_traded_value_buy numeric(25,6) NOT NULL,
   gross_traded_volume_sell bigint NOT NULL,
   gross_traded_value_sell numeric(25,6) NOT NULL,
   intraday_volume bigint NOT NULL,
   intraday_value numeric(25,6) NOT NULL,
   dibots_age_band varchar(30),
   investor_type_custom varchar(20),
   board varchar(255),
   sector varchar(255),
   external_id bigint,
   locality_new varchar(20),
   group_type varchar(20),
   klci_flag bool default false,
   fbm100_flag bool default false,
   shariah_flag bool default false
) PARTITION BY RANGE (trading_date);

alter table dibots_v2.exchange_demography add constraint exchg_demography_pkey PRIMARY KEY (trading_date,market_transaction_type,stock_code,account_identifier,investor_identifier);
CREATE INDEX exchg_demography_locality_idx ON dibots_v2.exchange_demography(locality);
CREATE INDEX exchg_demography_partcpt_code_idx ON dibots_v2.exchange_demography(participant_code);
CREATE INDEX exchg_demography_investor_type_idx ON dibots_v2.exchange_demography(investor_type);
CREATE INDEX exchg_demography_participant_name_idx ON dibots_v2.exchange_demography(participant_name);
CREATE INDEX exchg_demography_nationality_idx ON dibots_v2.exchange_demography(nationality);
CREATE INDEX exchg_demography_investor_type_custom_idx ON dibots_v2.exchange_demography(investor_type_custom);
CREATE INDEX exchg_demography_age_band_idx ON dibots_v2.exchange_demography(age_band);
CREATE INDEX exchg_demography_locality_new_idx ON dibots_v2.exchange_demography(locality_new);
CREATE INDEX exchg_demography_group_type_idx ON dibots_v2.exchange_demography(group_type);
CREATE INDEX exchg_demography_trd_date_idx ON dibots_v2.exchange_demography(trading_date);
CREATE INDEX exchg_demography_stock_code_idx on dibots_v2.exchange_demography(stock_code);


create table dibots_v2.exchange_demography_y2017q02 partition of dibots_v2.exchange_demography 
for values from ('2017-04-01') to ('2017-07-01');
create table dibots_v2.exchange_demography_y2017q03 partition of dibots_v2.exchange_demography 
for values from ('2017-07-01') to ('2017-10-01');
create table dibots_v2.exchange_demography_y2017q04 partition of dibots_v2.exchange_demography 
for values from ('2017-10-01') to ('2018-01-01');
create table dibots_v2.exchange_demography_y2018q01 partition of dibots_v2.exchange_demography 
for values from ('2018-01-01') to ('2018-04-01');
create table dibots_v2.exchange_demography_y2018q02 partition of dibots_v2.exchange_demography 
for values from ('2018-04-01') to ('2018-07-01');
create table dibots_v2.exchange_demography_y2018q03 partition of dibots_v2.exchange_demography 
for values from ('2018-07-01') to ('2018-10-01');
create table dibots_v2.exchange_demography_y2018q04 partition of dibots_v2.exchange_demography 
for values from ('2018-10-01') to ('2019-01-01');
create table dibots_v2.exchange_demography_y2019q01 partition of dibots_v2.exchange_demography 
for values from ('2019-01-01') to ('2019-04-01');
create table dibots_v2.exchange_demography_y2019q02 partition of dibots_v2.exchange_demography 
for values from ('2019-04-01') to ('2019-07-01');
create table dibots_v2.exchange_demography_y2019q03 partition of dibots_v2.exchange_demography 
for values from ('2019-07-01') to ('2019-10-01');
create table dibots_v2.exchange_demography_y2019q04 partition of dibots_v2.exchange_demography 
for values from ('2019-10-01') to ('2020-01-01');
create table dibots_v2.exchange_demography_y2020q01 partition of dibots_v2.exchange_demography 
for values from ('2020-01-01') to ('2020-04-01');
create table dibots_v2.exchange_demography_y2020q02 partition of dibots_v2.exchange_demography 
for values from ('2020-04-01') to ('2020-07-01');
create table dibots_v2.exchange_demography_y2020q03 partition of dibots_v2.exchange_demography 
for values from ('2020-07-01') to ('2020-10-01');
create table dibots_v2.exchange_demography_y2020q04 partition of dibots_v2.exchange_demography 
for values from ('2020-10-01') to ('2021-01-01');
create table dibots_v2.exchange_demography_y2021q01 partition of dibots_v2.exchange_demography 
for values from ('2021-01-01') to ('2021-04-01');
create table dibots_v2.exchange_demography_y2021q02 partition of dibots_v2.exchange_demography 
for values from ('2021-04-01') to ('2021-07-01');
create table dibots_v2.exchange_demography_y2021q03 partition of dibots_v2.exchange_demography 
for values from ('2021-07-01') to ('2021-10-01');
create table dibots_v2.exchange_demography_y2021q04 partition of dibots_v2.exchange_demography 
for values from ('2021-10-01') to ('2022-01-01');
create table dibots_v2.exchange_demography_y2022q01 partition of dibots_v2.exchange_demography 
for values from ('2022-01-01') to ('2022-04-01');
create table dibots_v2.exchange_demography_y2022q02 partition of dibots_v2.exchange_demography 
for values from ('2022-04-01') to ('2022-07-01');
create table dibots_v2.exchange_demography_y2022q03 partition of dibots_v2.exchange_demography 
for values from ('2022-07-01') to ('2022-10-01');
create table dibots_v2.exchange_demography_y2022q04 partition of dibots_v2.exchange_demography 
for values from ('2022-10-01') to ('2023-01-01');
create table dibots_v2.exchange_demography_y2023q01 partition of dibots_v2.exchange_demography 
for values from ('2023-01-01') to ('2023-04-01');
create table dibots_v2.exchange_demography_y2023q02 partition of dibots_v2.exchange_demography 
for values from ('2023-04-01') to ('2023-07-01');
create table dibots_v2.exchange_demography_y2023q03 partition of dibots_v2.exchange_demography 
for values from ('2023-07-01') to ('2023-10-01');
create table dibots_v2.exchange_demography_y2023q04 partition of dibots_v2.exchange_demography 
for values from ('2023-10-01') to ('2024-01-01');
create table dibots_v2.exchange_demography_y2024q01 partition of dibots_v2.exchange_demography 
for values from ('2024-01-01') to ('2024-04-01');
create table dibots_v2.exchange_demography_y2024q02 partition of dibots_v2.exchange_demography 
for values from ('2024-04-01') to ('2024-07-01');
create table dibots_v2.exchange_demography_y2024q03 partition of dibots_v2.exchange_demography 
for values from ('2024-07-01') to ('2024-10-01');
create table dibots_v2.exchange_demography_y2024q04 partition of dibots_v2.exchange_demography 
for values from ('2024-10-01') to ('2025-01-01');
create table dibots_v2.exchange_demography_y2025q01 partition of dibots_v2.exchange_demography 
for values from ('2025-01-01') to ('2025-04-01');
create table dibots_v2.exchange_demography_y2025q02 partition of dibots_v2.exchange_demography 
for values from ('2025-04-01') to ('2025-07-01');
create table dibots_v2.exchange_demography_y2025q03 partition of dibots_v2.exchange_demography 
for values from ('2025-07-01') to ('2025-10-01');
create table dibots_v2.exchange_demography_y2025q04 partition of dibots_v2.exchange_demography 
for values from ('2025-10-01') to ('2026-01-01');
create table dibots_v2.exchange_demography_default partition of dibots_v2.exchange_demography default;

create trigger set_dibots_age_band before
insert
    or
update
    of age on
    dibots_v2.exchange_demography_y2021q04 for each row execute function dibots_v2.update_dibots_age_band();

insert into dibots_v2.trade_demography
select * from dibots_v2.exchange_trade_demography;

select min(trading_date) from dibots_v2.exchange_trade_demography;

select * from dibots_v2.exchange_trade_demography where trading_date = '2020-08-25'

update dibots_v2.exchange_short_selling
set
week_count = to_char(trading_date, 'IYYY-IW'), 
year = extract(year from trading_date), 
month = extract(month from trading_date)
where week_count is null;


--===============================================
-- EXCHANGE_DEMOGRAPHY_STOCK_BROKER PARTITIONING
--===============================================

create table dibots_v2.exchange_demography_stock_broker (
trading_date date,
stock_code varchar(10),
stock_name varchar(255),
board varchar(255),
sector varchar(255),
stock_num int,
external_id int,
participant_code int,
participant_name varchar(255),
locality varchar(20),
group_type varchar(20),
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
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false
) PARTITION BY RANGE (trading_date);

alter table dibots_v2.exchange_demography_stock_broker add constraint ed_sb_pkey primary key (trading_date, stock_code, participant_code, locality, group_type);

create index ed_sb_ext_id_idx on dibots_v2.exchange_demography_stock_broker (external_id);
create index ed_sb_board_idx on dibots_v2.exchange_demography_stock_broker (board);
create index ed_sb_sector_idx on dibots_v2.exchange_demography_stock_broker (sector);
create index ed_sb_single_trddate_idx on dibots_v2.exchange_demography_stock_broker (trading_date);
create index ed_sb_stock_code_idx on dibots_v2.exchange_demography_stock_broker(stock_code);
create index ed_sb_partcpt_code_idx on dibots_v2.exchange_demography_stock_broker(participant_code);
create index ed_sb_single_locality_idx on dibots_v2.exchange_demography_stock_broker(locality);
create index ed_sb_single_group_type_idx on dibots_v2.exchange_demography_stock_broker(group_type);

create table dibots_v2.exchange_demography_stock_broker_y2017q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2017-04-01') to ('2017-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2017q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2017-07-01') to ('2017-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2017q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2017-10-01') to ('2018-01-01');
create table dibots_v2.exchange_demography_stock_broker_y2018q01 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2018-01-01') to ('2018-04-01');
create table dibots_v2.exchange_demography_stock_broker_y2018q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2018-04-01') to ('2018-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2018q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2018-07-01') to ('2018-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2018q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2018-10-01') to ('2019-01-01');
create table dibots_v2.exchange_demography_stock_broker_y2019q01 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2019-01-01') to ('2019-04-01');
create table dibots_v2.exchange_demography_stock_broker_y2019q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2019-04-01') to ('2019-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2019q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2019-07-01') to ('2019-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2019q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2019-10-01') to ('2020-01-01');
create table dibots_v2.exchange_demography_stock_broker_y2020q01 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2020-01-01') to ('2020-04-01');
create table dibots_v2.exchange_demography_stock_broker_y2020q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2020-04-01') to ('2020-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2020q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2020-07-01') to ('2020-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2020q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2020-10-01') to ('2021-01-01');
create table dibots_v2.exchange_demography_stock_broker_y2021q01 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2021-01-01') to ('2021-04-01');
create table dibots_v2.exchange_demography_stock_broker_y2021q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2021-04-01') to ('2021-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2021q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2021-07-01') to ('2021-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2021q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2021-10-01') to ('2022-01-01');
create table dibots_v2.exchange_demography_stock_broker_y2022q01 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2022-01-01') to ('2022-04-01');
create table dibots_v2.exchange_demography_stock_broker_y2022q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2022-04-01') to ('2022-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2022q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2022-07-01') to ('2022-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2022q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2022-10-01') to ('2023-01-01');
create table dibots_v2.exchange_demography_stock_broker_y2023q01 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2023-01-01') to ('2023-04-01');
create table dibots_v2.exchange_demography_stock_broker_y2023q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2023-04-01') to ('2023-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2023q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2023-07-01') to ('2023-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2023q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2023-10-01') to ('2024-01-01');
create table dibots_v2.exchange_demography_stock_broker_y2024q01 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2024-01-01') to ('2024-04-01');
create table dibots_v2.exchange_demography_stock_broker_y2024q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2024-04-01') to ('2024-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2024q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2024-07-01') to ('2024-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2024q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2024-10-01') to ('2025-01-01');
create table dibots_v2.exchange_demography_stock_broker_y2025q01 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2025-01-01') to ('2025-04-01');
create table dibots_v2.exchange_demography_stock_broker_y2025q02 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2025-04-01') to ('2025-07-01');
create table dibots_v2.exchange_demography_stock_broker_y2025q03 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2025-07-01') to ('2025-10-01');
create table dibots_v2.exchange_demography_stock_broker_y2025q04 partition of dibots_v2.exchange_demography_stock_broker 
for values from ('2025-10-01') to ('2026-01-01');
create table dibots_v2.exchange_demography_stock_broker_default partition of dibots_v2.exchange_demography_stock_broker default;

--=========================================
-- EXCHANGE_DEMOGRAPHY_STOCK_BROKER_GROUP
--=========================================

CREATE TABLE dibots_v2.exchange_demography_stock_broker_group (
  trading_date date not null,
  stock_code varchar(10),
  stock_name varchar(100),
  board varchar(255),
  sector varchar(255),
  stock_num int,
  external_id int,
  participant_code int,
  participant_name varchar(255),
  total_volume bigint,
  total_value numeric(25,3),
  local_volume bigint,
  local_value numeric(25,3),
  foreign_volume bigint,
  foreign_value numeric(25,3),
  prop_volume bigint,
  prop_value numeric(25,3),
  total_inst_volume bigint,
  total_inst_value numeric(25,3),
  local_inst_volume bigint,
  local_inst_value numeric(25,3),
  foreign_inst_volume bigint,
  foreign_inst_value numeric(25,3),
  total_retail_volume bigint,
  total_retail_value numeric(25,3),
  local_retail_volume bigint,
  local_retail_value numeric(25,3),
  foreign_retail_volume bigint,
  foreign_retail_value numeric(25,3),
  total_nominees_volume bigint,
  total_nominees_value numeric(25,3),
  local_nominees_volume bigint,
  local_nominees_value numeric(25,3),
  foreign_nominees_volume bigint,
  foreign_nominees_value numeric(25,3),
  ivt_volume bigint,
  ivt_value numeric(25,3),
  pdt_volume bigint,
  pdt_value numeric(25,3),
  klci_flag bool default false,
  fbm100_flag bool default false,
  shariah_flag bool default false,
  net_volume bigint,
  net_value numeric(25,3),
  net_local_volume bigint,
  net_local_value numeric(25,3),
  net_foreign_volume bigint,
  net_foreign_value numeric(25,3),
  net_prop_volume bigint,
  net_prop_value numeric(25,3),
  net_inst_volume bigint,
  net_inst_value numeric(25,3),
  net_retail_volume bigint,
  net_retail_value numeric(25,3),
  net_nominees_volume bigint,
  net_nominees_value numeric(25,3),
  net_ivt_volume bigint,
  net_ivt_value numeric(25,3),
  net_pdt_volume bigint,
  net_pdt_value numeric(25,3),
  net_local_inst_vol bigint,
  net_local_inst_val numeric(25,3),
  net_foreign_inst_vol bigint,
  net_foreign_inst_val numeric(25,3),
  net_local_retail_vol bigint,
  net_local_retail_val numeric(25,3),
  net_foreign_retail_vol bigint,
  net_foreign_retail_val numeric(25,3),
  net_local_nominees_vol bigint,
  net_local_nominees_val numeric(25,3),
  net_foreign_nominees_vol bigint,
  net_foreign_nominees_val numeric(25,3),
  total_intraday_vol bigint,
  total_intraday_val numeric(25,3),
  local_intraday_vol bigint,
  local_intraday_val numeric(25,3),
  foreign_intraday_vol bigint,
  foreign_intraday_val numeric(25,3),
  inst_intraday_vol bigint,
  inst_intraday_val numeric(25,3),
  local_inst_intraday_vol bigint,
  local_inst_intraday_val numeric(25,3),
  foreign_inst_intraday_vol bigint,
  foreign_inst_intraday_val numeric(25,3),
  retail_intraday_vol bigint,
  retail_intraday_val numeric(25,3),
  local_retail_intraday_vol bigint,
  local_retail_intraday_val numeric(25,3),
  foreign_retail_intraday_vol bigint,
  foreign_retail_intraday_val numeric(25,3),
  nominees_intraday_vol bigint,
  nominees_intraday_val numeric(25,3),
  local_nominees_intraday_vol bigint,
  local_nominees_intraday_val numeric(25,3),
  foreign_nominees_intraday_vol bigint,
  foreign_nominees_intraday_val numeric(25,3),
  ivt_intraday_vol bigint,
  ivt_intraday_val numeric(25,3),
  pdt_intraday_vol bigint,
  pdt_intraday_val numeric(25,3)
) PARTITION BY RANGE (trading_date);

alter table dibots_v2.exchange_demography_stock_broker_group add constraint ed_sbg_pkey primary key (trading_date, stock_code, participant_code);

create index ed_sbg_ext_id_idx on dibots_v2.exchange_demography_stock_broker_group (external_id);
create index ed_sbg_board_idx on dibots_v2.exchange_demography_stock_broker_group (board);
create index ed_sbg_sector_idx on dibots_v2.exchange_demography_stock_broker_group (sector);
create index ed_sbg_stock_idx on dibots_v2.exchange_demography_stock_broker_group (stock_code);
create index ed_sbg_trd_date_idx on dibots_v2.exchange_demography_stock_broker_group(trading_date);
create index ed_sbg_prtcpt_code_idx on dibots_v2.exchange_demography_stock_broker_group(participant_code);
create index ed_sbg_cpst_idx on dibots_v2.exchange_demography_stock_broker_group(trading_date, sector, board)

create table dibots_v2.exchange_demography_stock_broker_group_y2017q02 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2017-04-01') to ('2017-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2017q03 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2017-07-01') to ('2017-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2017q04 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2017-10-01') to ('2018-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2018q01 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2018-01-01') to ('2018-04-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2018q02 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2018-04-01') to ('2018-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2018q03 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2018-07-01') to ('2018-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2018q04 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2018-10-01') to ('2019-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2019q01 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2019-01-01') to ('2019-04-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2019q02 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2019-04-01') to ('2019-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2019q03 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2019-07-01') to ('2019-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2019q04 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2019-10-01') to ('2020-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2020q01 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2020-01-01') to ('2020-04-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2020q02 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2020-04-01') to ('2020-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2020q03 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2020-07-01') to ('2020-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2020q04 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2020-10-01') to ('2021-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2021q01 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2021-01-01') to ('2021-04-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2021q02 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2021-04-01') to ('2021-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2021q03 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2021-07-01') to ('2021-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2021q04 partition of dibots_v2.exchange_demography_stock_broker_group
for values from ('2021-10-01') to ('2022-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2022q01 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2022-01-01') to ('2022-04-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2022q02 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2022-04-01') to ('2022-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2022q03 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2022-07-01') to ('2022-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2022q04 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2022-10-01') to ('2023-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2023q01 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2023-01-01') to ('2023-04-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2023q02 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2023-04-01') to ('2023-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2023q03 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2023-07-01') to ('2023-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2023q04 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2023-10-01') to ('2024-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2024q01 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2024-01-01') to ('2024-04-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2024q02 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2024-04-01') to ('2024-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2024q03 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2024-07-01') to ('2024-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2024q04 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2024-10-01') to ('2025-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2025q01 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2025-01-01') to ('2025-04-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2025q02 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2025-04-01') to ('2025-07-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2025q03 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2025-07-01') to ('2025-10-01');
create table dibots_v2.exchange_demography_stock_broker_group_y2025q04 partition of dibots_v2.exchange_demography_stock_broker_group 
for values from ('2025-10-01') to ('2026-01-01');
create table dibots_v2.exchange_demography_stock_broker_group_default partition of dibots_v2.exchange_demography_stock_broker_group default;


--===============================================
-- EXCHANGE_DEMOGRAPHY_STOCK_WEEK partitioning
--===============================================
create table dibots_v2.exchange_demography_stock_week (
trading_date date,
week_count varchar(10),
stock_code varchar(20),
stock_name varchar(100),
board varchar(100),
sector varchar(100),
klci_flag bool,
fbm100_flag bool,
shariah_flag bool,
stock_num int,
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
pdt_intraday_val numeric(25,2),
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
pdt_val numeric(25,2)
) PARTITION BY RANGE(trading_date);

alter table dibots_v2.exchange_demography_stock_week add constraint ed_stock_week_pkey PRIMARY KEY (trading_date,stock_code);
create unique index ed_stock_week_uniq on dibots_v2.exchange_demography_stock_week (trading_date, stock_num);
create index edsw_trading_date_idx on dibots_v2.exchange_demography_stock_week (trading_date);
create index edsw_week_count_idx on dibots_v2.exchange_demography_stock_week (week_count);
create index edsw_stock_code_idx on dibots_v2.exchange_demography_stock_week (stock_code);

create table dibots_v2.exchange_demography_stock_week_y2017_2019 partition of dibots_v2.exchange_demography_stock_week
for values from ('2017-01-01') to ('2020-01-01');
create table dibots_v2.exchange_demography_stock_week_y2020_2022 partition of dibots_v2.exchange_demography_stock_week
for values from ('2020-01-01') to ('2023-01-01');
create table dibots_v2.exchange_demography_stock_week_y2023_2025 partition of dibots_v2.exchange_demography_stock_week
for values from ('2023-01-01') to ('2026-01-01');
create table dibots_v2.exchange_demography_stock_week_default partition of dibots_v2.exchange_demography_stock_week default;

--==================================================
-- exchange_demography_stock_retail_prof
--==================================================

--drop table dibots_v2.exchange_demography_stock_retail_prof;
create table dibots_v2.exchange_demography_stock_retail_prof (
trading_date date,
week_count varchar(10),
year int,
month int,
stock_code varchar(10),
stock_name varchar(50),
stock_num int,
board text,
sector text,
race text,
bumi_flag bool default false,
age_band varchar(20),
total_vol bigint,
total_val numeric(25,6),
intraday_vol bigint,
intraday_val numeric(25,3),
male_count int,
female_count int,
na_gender_count int,
constraint ed_stock_retail_prof_pkey primary key (trading_date, stock_code, age_band, race)
) partition by range (trading_date);

create index ed_stock_retail_prof_idx on dibots_v2.exchange_demography_stock_retail_prof (trading_date, stock_num);
create index ed_stock_retail_prof_date_idx on dibots_v2.exchange_demography_stock_retail_prof (trading_date);
create index ed_stock_retail_prof_week_idx on dibots_v2.exchange_demography_stock_retail_prof (week_count);
create index ed_stock_retail_prof_year_idx on dibots_v2.exchange_demography_stock_retail_prof (year);
create index ed_stock_retail_prof_month_idx on dibots_v2.exchange_demography_stock_retail_prof (month);

create table dibots_v2.exchange_demography_stock_retail_prof_y2017q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2017-04-01') to ('2017-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2017q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2017-07-01') to ('2017-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2017q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2017-10-01') to ('2018-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2018q01 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2018-01-01') to ('2018-04-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2018q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2018-04-01') to ('2018-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2018q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2018-07-01') to ('2018-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2018q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2018-10-01') to ('2019-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2019q01 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2019-01-01') to ('2019-04-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2019q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2019-04-01') to ('2019-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2019q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2019-07-01') to ('2019-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2019q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2019-10-01') to ('2020-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2020q01 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2020-01-01') to ('2020-04-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2020q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2020-04-01') to ('2020-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2020q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2020-07-01') to ('2020-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2020q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2020-10-01') to ('2021-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2021q01 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2021-01-01') to ('2021-04-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2021q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2021-04-01') to ('2021-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2021q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2021-07-01') to ('2021-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2021q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2021-10-01') to ('2022-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2022q01 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2022-01-01') to ('2022-04-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2022q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2022-04-01') to ('2022-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2022q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2022-07-01') to ('2022-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2022q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2022-10-01') to ('2023-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2023q01 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2023-01-01') to ('2023-04-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2023q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2023-04-01') to ('2023-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2023q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2023-07-01') to ('2023-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2023q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2023-10-01') to ('2024-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2024q01 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2024-01-01') to ('2024-04-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2024q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2024-04-01') to ('2024-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2024q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2024-07-01') to ('2024-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2024q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2024-10-01') to ('2025-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2025q01 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2025-01-01') to ('2025-04-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2025q02 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2025-04-01') to ('2025-07-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2025q03 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2025-07-01') to ('2025-10-01');
create table dibots_v2.exchange_demography_stock_retail_prof_y2025q04 partition of dibots_v2.exchange_demography_stock_retail_prof
for values from ('2025-10-01') to ('2026-01-01');
create table dibots_v2.exchange_demography_stock_retail_prof_default partition of dibots_v2.exchange_demography_stock_retail_prof default;

insert into dibots_v2.exchange_demography_stock_retail_prof (trading_date, week_count, year, month, stock_code, stock_name, stock_num, board, sector, race, bumi_flag, age_band,
total_vol, total_val, intraday_vol, intraday_val)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), stock_code, stock_name, stock_num, board, sector, race, 
case when race = 'BUMIPUTRA' then TRUE else false END as bumi_flag, dibots_age_band,
sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_vol, 
sum(gross_traded_value_buy + gross_traded_value_sell) as total_val, sum(intraday_volume) as intraday_vol, sum(intraday_value) as intraday_val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, stock_code, stock_name, stock_num, board, sector, race, dibots_age_band;

update dibots_v2.exchange_demography_stock_retail_prof a
set
male_count = b.cnt
from (
select trading_date, stock_code, dibots_age_band, race, count(*) as cnt 
from dibots_v2.exchange_demography 
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'MALE'
group by trading_date, stock_code, dibots_age_band, race) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.age_band = b.dibots_age_band and a.race = b.race;

update dibots_v2.exchange_demography_stock_retail_prof a
set
female_count = b.cnt
from (
select trading_date, stock_code, dibots_age_band, race, count(*) as cnt 
from dibots_v2.exchange_demography 
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'FEMALE'
group by trading_date, stock_code, dibots_age_band, race) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.age_band = b.dibots_age_band and a.race = b.race;

update dibots_v2.exchange_demography_stock_retail_prof a
set
na_gender_count = b.cnt
from (
select trading_date, stock_code, dibots_age_band, race, count(*) as cnt 
from dibots_v2.exchange_demography 
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'GENDER NOT AVAILABLE'
group by trading_date, stock_code, dibots_age_band, race) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.age_band = b.dibots_age_band and a.race = b.race;



--===============================================
-- EXCHANGE_DEMOGRAPHY_STOCK_BROKER_NATIONALITY
--===============================================

create table dibots_v2.exchange_demography_stock_broker_nationality (
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
constraint ed_sb_nationality_pkey primary key (trading_date, broker_code, stock_code, nationality)
) partition by range (trading_date);

create index ed_sb_nationality_stock_idx on dibots_v2.exchange_demography_stock_broker_nationality (trading_date, stock_num);
create index ed_sb_nationality_broker_idx on dibots_v2.exchange_demography_stock_broker_nationality (trading_date, broker_code);
create index ed_sb_nationality_date_idx on dibots_v2.exchange_demography_stock_broker_nationality (trading_date);

create table dibots_v2.exchange_demography_stock_broker_nationality_y2017_2019 partition of dibots_v2.exchange_demography_stock_broker_nationality
for values from ('2017-01-01') to ('2020-01-01');
create table dibots_v2.exchange_demography_stock_broker_nationality_y2020_2022 partition of dibots_v2.exchange_demography_stock_broker_nationality
for values from ('2020-01-01') to ('2023-01-01');
create table dibots_v2.exchange_demography_stock_broker_nationality_y2023_2025 partition of dibots_v2.exchange_demography_stock_broker_nationality
for values from ('2023-01-01') to ('2026-01-01');
create table dibots_v2.exchange_demography_stock_broker_nationality_default partition of dibots_v2.exchange_demography_stock_broker_nationality default;

-- fresh insertion
insert into dibots_v2.exchange_demography_stock_broker_nationality (trading_date, week_count, year, month, broker_code, broker_name, broker_ext_id, stock_code, stock_name, stock_num, nationality, 
volume, value, buy_vol, buy_val, sell_vol, sell_val, net_vol, net_val, intraday_vol, intraday_val)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), participant_code, participant_name, external_id, stock_code, stock_name, stock_num, nationality, 
sum(coalesce(gross_traded_volume_buy,0) + coalesce(gross_traded_volume_sell,0)), sum(coalesce(gross_traded_value_buy,0) + coalesce(gross_traded_value_sell,0)),
sum(gross_traded_volume_buy), sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell), sum(coalesce(gross_traded_volume_buy,0) - coalesce(gross_traded_volume_sell,0)), 
sum(coalesce(gross_traded_value_buy,0) - coalesce(gross_traded_value_sell,0)), sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN'
group by trading_date, participant_code, participant_name, external_id, stock_code, stock_name, stock_num, nationality;

--=======================================
-- EXCHANGE_DEMOGRAPHY_STOCK_CUM_NET_VAL
--=======================================

-- DEPRECATED, REMOVED THE TABLE
CREATE TABLE dibots_v2.exchange_demography_stock_cum_net_val (
trading_date date,
stock_code text,
stock_num int,
day int,
local_cum_val numeric(25,6),
foreign_cum_val numeric(25,6),
local_inst_cum_val numeric(25,6),
local_retail_cum_val numeric(25,6),
local_nom_cum_val numeric(25,6),
foreign_inst_cum_val numeric(25,6),
foreign_retail_cum_val numeric(25,6),
foreign_nom_cum_val numeric(25,6),
prop_cum_val numeric(25,6),
ivt_cum_val numeric(25,6),
pdt_cum_val numeric(25,6),
local_inst_nom_cum_val numeric(25,6),
foreign_inst_nom_cum_val numeric(25,6),
local_retail_nom_cum_val numeric(25,6),
foreign_retail_nom_cum_val numeric(25,6),
constraint ed_stock_cum_net_val_pkey primary key (trading_date, stock_num)
) partition by range (trading_date);
create index edscnv_uniq on dibots_v2.exchange_demography_stock_cum_net_val (trading_date, stock_code);

create table dibots_v2.exchange_demography_stock_cum_net_val_y2017_2019 partition of dibots_v2.exchange_demography_stock_cum_net_val
for values from ('2017-01-01') to ('2020-01-01');
create table dibots_v2.exchange_demography_stock_cum_net_val_y2020_2022 partition of dibots_v2.exchange_demography_stock_cum_net_val
for values from ('2020-01-01') to ('2023-01-01');
create table dibots_v2.exchange_demography_stock_cum_net_val_y2023_2025 partition of dibots_v2.exchange_demography_stock_cum_net_val
for values from ('2023-01-01') to ('2026-01-01');
create table dibots_v2.exchange_demography_stock_cum_net_val_default partition of dibots_v2.exchange_demography_stock_cum_net_val default;

