
--===================================================
-- TABLES derived from EXCHANGE_DIRECT_BUSINESS_TRADE
--==================================================

--==================================
-- exchange_direct_business_trade 
--==================================

CREATE TABLE dibots_v2.exchange_direct_business_trade
(
   id bigserial primary key,
   trading_date date NOT NULL,
   market_transaction_type varchar(20) NOT NULL,
   stock_code varchar(20) NOT NULL,
   stock_name varchar(20),
   stock_num int,
   board varchar(255),
   sector varchar(255),
   participant_code int NOT NULL,
   participant_name text NOT NULL,
   external_id bigint,
   account_identifier bigint NOT NULL,
   intraday_account_type varchar(20),
   investor_identifier bigint NOT NULL,
   investor_type varchar(20) NOT NULL,
   account_type varchar(2) NOT NULL,
   age int NOT NULL,
   dibots_age_band varchar(30),
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
   locality_new varchar(20),
   group_type varchar(20),
   klci_flag bool default false,
   fmb100_flag bool default false,
   shariah_flag bool default false
);

create unique index exchg_dbt_uniq_idx on dibots_v2.exchange_direct_business_trade(trading_date, market_transaction_type, stock_code, account_identifier, investor_identifier);
CREATE INDEX exchg_dbt_trd_date_idx ON dibots_v2.exchange_direct_business_trade(trading_date);
CREATE INDEX exchg_dbt_stock_code_idx on dibots_v2.exchange_direct_business_trade(stock_code);
CREATE INDEX exchg_dbt_partcpt_code_idx ON dibots_v2.exchange_direct_business_trade(participant_code);
CREATE INDEX exchg_dbt_ext_id_idx ON dibots_v2.exchange_direct_business_trade(external_id);
CREATE INDEX exchg_dbt_locality_idx ON dibots_v2.exchange_direct_business_trade(locality_new);
CREATE INDEX exchg_dbt_group_type_idx ON dibots_v2.exchange_direct_business_trade(group_type);
CREATE INDEX exchg_dbt_nationality_idx ON dibots_v2.exchange_direct_business_trade(nationality);
CREATE INDEX exchg_dbt_age_band_idx ON dibots_v2.exchange_direct_business_trade(dibots_age_band);

--=================================
-- exchange_dbt_stock_broker_group
--==================================

create table dibots_v2.exchange_dbt_stock_broker_group (
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
);

alter table dibots_v2.exchange_dbt_stock_broker_group add constraint edbt_stock_broker_group_pkey primary key (trading_date, stock_code, participant_code);
create index edbtsbg_trading_date_idx on dibots_v2.exchange_dbt_stock_broker_group (trading_date);
create index edbtsbg_stock_code_idx on dibots_v2.exchange_dbt_stock_broker_group (stock_code);
create index ebdtsbg_partcpt_code_idx on dibots_v2.exchange_dbt_stock_broker_group (participant_code);
create index edbtsbg_ext_id_idx on dibots_v2.exchange_dbt_stock_broker_group (external_id);

insert into dibots_v2.exchange_dbt_stock_broker_group (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name,
total_vol, total_val, total_intraday_vol, total_intraday_val, buy_vol, buy_val, sell_vol, sell_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name, 
sum(gross_traded_volume_buy+gross_traded_volume_sell), sum(gross_traded_value_buy+gross_traded_value_sell), sum(intraday_volume), sum(intraday_value),
sum(gross_traded_volume_buy), sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell)
from dibots_v2.exchange_direct_business_trade
group by trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_vol = tmp.vol,
local_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_vol = tmp.vol,
foreign_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
prop_vol = tmp.vol,
prop_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'PROPRIETARY'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
inst_vol = tmp.vol,
inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_inst_vol = tmp.vol,
local_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_inst_vol = tmp.vol,
foreign_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
retail_vol = tmp.vol,
retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_retail_vol = tmp.vol,
local_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_retail_vol = tmp.vol,
foreign_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
nominees_vol = tmp.vol,
nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_nominees_vol = tmp.vol,
local_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_nominees_vol = tmp.vol,
foreign_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
ivt_vol = tmp.vol,
ivt_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'IVT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
pdt_vol = tmp.vol,
pdt_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'PDT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_vol = tmp.vol,
net_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_local_vol = tmp.vol,
net_local_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_foreign_vol = tmp.vol,
net_foreign_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_prop_vol = tmp.vol,
net_prop_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'PROPRIETARY'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_inst_vol = tmp.vol,
net_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_local_inst_vol = tmp.vol,
net_local_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_foreign_inst_vol = tmp.vol,
net_foreign_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_retail_vol = tmp.vol,
net_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_local_retail_vol = tmp.vol,
net_local_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_foreign_retail_vol = tmp.vol,
net_foreign_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_nominees_vol = tmp.vol,
net_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_local_nominees_vol = tmp.vol,
net_local_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_foreign_nominees_vol = tmp.vol,
net_foreign_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_ivt_vol = tmp.vol,
net_ivt_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'IVT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_pdt_vol = tmp.vol,
net_pdt_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'PDT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
total_intraday_vol = tmp.vol,
total_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_intraday_vol = tmp.vol,
local_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_intraday_vol = tmp.vol,
foreign_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
inst_intraday_vol = tmp.vol,
inst_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_inst_intraday_vol = tmp.vol,
local_inst_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_inst_intraday_vol = tmp.vol,
foreign_inst_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
retail_intraday_vol = tmp.vol,
retail_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_retail_intraday_vol = tmp.vol,
local_retail_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_retail_intraday_vol = tmp.vol,
foreign_retail_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'RETAIL'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
nominees_intraday_vol = tmp.vol,
nominees_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_nominees_intraday_vol = tmp.vol,
local_nominees_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_nominees_intraday_vol = tmp.vol,
foreign_nominees_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'NOMINEES'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
ivt_intraday_vol = tmp.vol,
ivt_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'IVT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
pdt_intraday_vol = tmp.vol,
pdt_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'PDT'
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;


--=========================
-- exchange_dbt_stock
--=========================

create table dibots_v2.exchange_dbt_stock (
trading_date date,
week_count varchar(10),
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
);

alter table dibots_v2.exchange_dbt_stock add constraint edbt_stock_pkey PRIMARY KEY (trading_date, stock_code);
create index edbts_trading_date_idx on dibots_v2.exchange_dbt_stock (trading_date);
create index edbts_stock_code_idx on dibots_v2.exchange_dbt_stock (stock_code);

insert into dibots_v2.exchange_dbt_stock (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val,
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, ivt_vol, ivt_val, pdt_vol, pdt_val, net_inst_vol, net_inst_val, 
net_local_inst_vol, net_local_inst_val, net_foreign_inst_vol, net_foreign_inst_val, net_retail_vol, net_retail_val, net_local_retail_vol, net_local_retail_val, net_foreign_retail_vol, net_foreign_retail_val,
net_nominees_vol, net_nominees_val, net_local_nominees_vol, net_local_nominees_val, net_foreign_nominees_vol, net_foreign_nominees_val, net_ivt_vol, net_ivt_val, net_pdt_vol, net_pdt_val, 
net_local_vol, net_local_val, net_foreign_vol, net_foreign_val, total_intraday_vol, total_intraday_val, local_intraday_vol, local_intraday_val, foreign_intraday_vol, foreign_intraday_val, 
inst_intraday_vol, inst_intraday_val, local_inst_intraday_vol, local_inst_intraday_val, foreign_inst_intraday_vol, foreign_inst_intraday_val, retail_intraday_vol, retail_intraday_val, 
local_retail_intraday_vol, local_retail_intraday_val, foreign_retail_intraday_vol, foreign_retail_intraday_val, nominees_intraday_vol, nominees_intraday_val, 
local_nominees_intraday_vol, local_nominees_intraday_val, foreign_nominees_intraday_vol, foreign_nominees_intraday_val, ivt_intraday_vol, ivt_intraday_val,  pdt_intraday_vol, pdt_intraday_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, sum(total_vol), sum(total_val), sum(local_vol), sum(local_val), sum(foreign_vol), sum(foreign_val),
sum(inst_vol), sum(inst_val), sum(local_inst_vol), sum(local_inst_val), sum(foreign_inst_vol), sum(foreign_inst_val), sum(retail_vol), sum(retail_val), sum(local_retail_vol), sum(local_retail_val),
sum(foreign_retail_vol), sum(foreign_retail_val), sum(nominees_vol), sum(nominees_val), sum(local_nominees_vol), sum(local_nominees_val), sum(foreign_nominees_vol), sum(foreign_nominees_val),
sum(ivt_vol), sum(ivt_val), sum(pdt_vol), sum(pdt_val), sum(net_inst_vol), sum(net_inst_val), sum(net_local_inst_vol), sum(net_local_inst_val), sum(net_foreign_inst_vol), sum(net_foreign_inst_val),
sum(net_retail_vol), sum(net_retail_val), sum(net_local_retail_vol), sum(net_local_retail_val), sum(net_foreign_retail_vol), sum(net_foreign_retail_val), sum(net_nominees_vol), sum(net_nominees_val),
sum(net_local_nominees_vol), sum(net_local_nominees_val), sum(net_foreign_nominees_vol), sum(net_foreign_nominees_val), sum(net_ivt_vol), sum(net_ivt_val), sum(net_pdt_vol), sum(net_pdt_val),
sum(net_local_vol), sum(net_local_val), sum(net_foreign_vol), sum(net_foreign_val), sum(total_intraday_vol), sum(total_intraday_val), sum(local_intraday_vol), sum(local_intraday_val),
sum(foreign_intraday_vol), sum(foreign_intraday_val), sum(inst_intraday_vol), sum(inst_intraday_val), sum(local_inst_intraday_vol), sum(local_inst_intraday_val), 
sum(foreign_inst_intraday_vol), sum(foreign_inst_intraday_val), sum(retail_intraday_vol), sum(retail_intraday_val), sum(local_retail_intraday_vol), sum(local_retail_intraday_val),
sum(foreign_retail_intraday_vol), sum(foreign_retail_intraday_val), sum(nominees_intraday_vol), sum(nominees_intraday_val), sum(local_nominees_intraday_vol), sum(local_nominees_intraday_val),
sum(foreign_nominees_intraday_vol), sum(foreign_nominees_intraday_val), sum(ivt_intraday_vol), sum(ivt_intraday_val), sum(pdt_intraday_vol), sum(pdt_intraday_val)
from dibots_v2.exchange_dbt_stock_broker_group
group by trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag;

--=================================
-- exchange_dbt_broker_age_band
--=================================

create table dibots_v2.exchange_dbt_broker_age_band (
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

alter table dibots_v2.exchange_dbt_broker_age_band add constraint edbt_broker_age_band_pkey primary key (trading_date, participant_code, age_band);
create index edbtbab_trading_date_idx on dibots_v2.exchange_dbt_broker_age_band (trading_date);
create index edbtbab_participant_code_idx on dibots_v2.exchange_dbt_broker_age_band (participant_code);
create index edbtbab_external_id_idx on dibots_v2.exchange_dbt_broker_age_band (external_id);
create index edbtbab_age_band_idx on dibots_v2.exchange_dbt_broker_age_band (age_band);

insert into dibots_v2.exchange_dbt_broker_age_band (trading_date, external_id, participant_code, participant_name, age_band, total_vol, total_val, intraday_vol, intraday_val)
select trading_date, external_id, participant_code, participant_name, dibots_age_band, sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_value_buy+gross_traded_value_sell),
sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_direct_business_trade 
where locality_new = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, external_id, participant_code, participant_name, dibots_age_band;

update dibots_v2.exchange_dbt_broker_age_band a
set
male_count = b.cnt
from 
(select trading_date, participant_code, count(*) as cnt from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'MALE'
group by trading_date, participant_code) b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

update dibots_v2.exchange_dbt_broker_age_band a
set
female_count = b.cnt
from 
(select trading_date, participant_code, count(*) as cnt from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'FEMALE'
group by trading_date, participant_code) b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

update dibots_v2.exchange_dbt_broker_age_band a
set
na_gender_count = b.cnt
from 
(select trading_date, participant_code, count(*) as cnt from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'GENDER NOT AVAILABLE'
group by trading_date, participant_code) b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

--==================================
-- exchange_dbt_broker_nationality
--==================================

create table dibots_v2.exchange_dbt_broker_nationality (
trading_date date,
participant_code int,
external_id int,
participant_name varchar(100),
nationality varchar(10),
total_vol bigint,
total_val numeric(25,2),
intraday_vol bigint,
intraday_val numeric(25,2)
);

alter table dibots_v2.exchange_dbt_broker_nationality add constraint edbt_broker_nationality_pkey primary key (trading_date, participant_code, nationality);
create index edbt_broker_nationality_partcpt_code_idx on dibots_v2.exchange_dbt_broker_nationality (participant_code);
create index edbt_broker_nationality_ext_id_idx on dibots_v2.exchange_dbt_broker_nationality (external_id);
create index edbt_broker_nationality_nationality_idx on dibots_v2.exchange_dbt_broker_nationality (nationality);

insert into dibots_v2.exchange_dbt_broker_nationality (trading_date, participant_code, external_id, participant_name, nationality, 
total_vol, total_val, intraday_vol, intraday_val)
select trading_date, participant_code, external_id, participant_name, nationality, sum(gross_traded_volume_buy + gross_traded_volume_sell), 
sum(gross_traded_value_buy + gross_traded_value_sell), sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN'
group by trading_date, participant_code, external_id, participant_name, nationality;

--========================================
-- exchange_dbt_stock_broker_nationality
--========================================

create table dibots_v2.exchange_dbt_stock_broker_nationality (
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
constraint dbt_sb_nationality_pkey primary key (trading_date, broker_code, stock_code, nationality)
);

create index dbt_sb_nationality_stock_idx on dibots_v2.exchange_dbt_stock_broker_nationality (trading_date, stock_num);
create index dbt_sb_nationality_broker_idx on dibots_v2.exchange_dbt_stock_broker_nationality (trading_date, broker_code);
create index dbt_sb_nationality_date_idx on dibots_v2.exchange_dbt_stock_broker_nationality (trading_date);

-- fresh insertion
insert into dibots_v2.exchange_dbt_stock_broker_nationality (trading_date, week_count, year, month, broker_code, broker_name, broker_ext_id, stock_code, stock_name, stock_num, nationality, 
volume, value, buy_vol, buy_val, sell_vol, sell_val, net_vol, net_val, intraday_vol, intraday_val)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), participant_code, participant_name, external_id, stock_code, stock_name, stock_num, nationality, 
sum(coalesce(gross_traded_volume_buy,0) + coalesce(gross_traded_volume_sell,0)), sum(coalesce(gross_traded_value_buy,0) + coalesce(gross_traded_value_sell,0)),
sum(gross_traded_volume_buy), sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell), sum(coalesce(gross_traded_volume_buy,0) - coalesce(gross_traded_volume_sell,0)), 
sum(coalesce(gross_traded_value_buy,0) - coalesce(gross_traded_value_sell,0)), sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN'
group by trading_date, participant_code, participant_name, external_id, stock_code, stock_name, stock_num, nationality;

--==============================
-- exchange_dbt_broker_stats
--==============================

create table dibots_v2.exchange_dbt_broker_stats (
id serial primary key,
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

CREATE INDEX edbt_broker_stats_trading_date_idx ON dibots_v2.exchange_dbt_broker_stats (trading_date);
CREATE INDEX edbt_broker_stats_stock_code_idx ON dibots_v2.exchange_dbt_broker_stats (participant_code);
ALTER TABLE dibots_v2.exchange_dbt_broker_stats ADD CONSTRAINT edbt_broker_stats_uniq UNIQUE (trading_date, participant_code, locality, group_type);

insert into dibots_v2.exchange_dbt_broker_stats (trading_date, participant_code, external_id, participant_name, locality, group_type, 
trades_count, total_val, net_val, min_buy_val, min_sell_val, max_buy_val, max_sell_val, total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, participant_code, external_id, participant_name, locality_new, group_type, count(*) as trades_count, sum(gross_traded_value_buy + gross_traded_value_sell) as total_val,
sum(gross_traded_value_buy - gross_traded_value_sell) as net_val,
min(nullif(gross_traded_value_buy,0)) as min_buy_val, min(nullif(gross_traded_value_sell,0)) as min_sell_val, max(gross_traded_value_buy) as max_buy_val, 
max(gross_traded_value_sell) as max_sell_val, 
sum(intraday_volume), sum(intraday_value), min(intraday_volume), min(intraday_value), max(intraday_volume), max(intraday_value)
from dibots_v2.exchange_direct_business_trade
group by trading_date, participant_code, external_id, participant_name, locality_new, group_type;


--===========================
-- exchange_dbt_stock_broker
--===========================

create table dibots_v2.exchange_dbt_stock_broker (
id bigserial primary key,
trading_date date,
stock_code varchar(10),
stock_name varchar(25),
stock_num int,
board varchar(100),
sector varchar(100),
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
intraday_val numeric(25,3),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false
);

alter table dibots_v2.exchange_dbt_stock_broker add constraint edbt_sb_uniq unique (trading_date, stock_code, participant_code, locality, group_type);
create index edbt_sb_ext_id_idx on dibots_v2.exchange_dbt_stock_broker (external_id);
create index edbt_sb_board_idx on dibots_v2.exchange_dbt_stock_broker (board);
create index edbt_sb_sector_idx on dibots_v2.exchange_dbt_stock_broker (sector);
create index edbt_sb_trddate_idx on dibots_v2.exchange_dbt_stock_broker (trading_date);
create index edbt_sb_stock_code_idx on dibots_v2.exchange_dbt_stock_broker(stock_code);
create index edbt_sb_partcpt_code_idx on dibots_v2.exchange_dbt_stock_broker(participant_code);
create index edbt_sb_locality_idx on dibots_v2.exchange_dbt_stock_broker(locality);
create index edbt_sb_group_type_idx on dibots_v2.exchange_dbt_stock_broker(group_type);

insert into dibots_v2.exchange_dbt_stock_broker (trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality, group_type,
buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val, klci_flag, fbm100_flag, shariah_flag)
select trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality_new, group_type,
sum(gross_traded_volume_buy), sum(gross_traded_volume_sell), sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_volume_buy - gross_traded_volume_sell),
sum(gross_traded_value_buy), sum(gross_traded_value_sell), sum(gross_traded_value_buy + gross_traded_value_sell), sum(gross_traded_value_buy - gross_traded_value_sell), 
sum(intraday_volume), sum(intraday_value), klci_flag, fbm100_flag, shariah_flag
from dibots_v2.exchange_direct_business_trade
group by trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag;

--======================================
-- exchange_dbt_stock_movement
--======================================

create table dibots_v2.exchange_dbt_stock_movement (
id bigserial primary key,
trading_date date,
stock_code varchar(20),
stock_name varchar(100),
stock_num int,
board varchar(100),
sector varchar(100),
locality varchar(20),
group_type varchar(20),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
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
);

alter table dibots_v2.exchange_dbt_stock_movement add constraint edbt_stock_movement_uniq unique (trading_date, stock_code, locality, group_type);
create index edbt_stock_movement_trading_date_idx on dibots_v2.exchange_dbt_stock_movement(trading_date);
create index edbt_stock_movement_stock_code_idx on dibots_v2.exchange_dbt_stock_movement(stock_code);
create index edbt_stock_movement_board_idx on dibots_v2.exchange_dbt_stock_movement(board);
create index edbt_stock_movement_sector_idx on dibots_v2.exchange_dbt_stock_movement(sector);

insert into dibots_v2.exchange_dbt_stock_movement (trading_date, stock_code, stock_name, stock_num, board, sector, locality, group_type, klci_flag, fbm100_flag, shariah_flag,
buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag,
sum(gross_traded_volume_buy), sum(gross_traded_volume_sell), sum(gross_traded_volume_buy + gross_traded_volume_sell), 
sum(gross_traded_volume_buy - gross_traded_volume_sell), sum(gross_traded_value_buy),
sum(gross_traded_value_sell), sum(gross_traded_value_buy + gross_traded_value_sell), sum(gross_traded_value_buy - gross_traded_value_sell),
sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_direct_business_trade
group by trading_date, stock_code, stock_name, stock_num, board, sector, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag;
