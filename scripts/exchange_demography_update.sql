-- update the investor_type_custom_column in exchange_trade_demography before update the rest
-- this is handled by function and trigger

update dibots_v2.exchange_trade_demography
set investor_type_custom = 'INSTITUTIONAL'
where investor_type in ('INSTITUTIONAL', 'NOMINEES') and investor_type_custom is null;

update dibots_v2.exchange_trade_demography
set investor_type_custom = 'RETAIL'
where investor_type = 'RETAIL' and investor_type_custom is null;


--======================================================
-- TRIGGER TO AUTOMATE THE investor_type_custom COLUMN
--======================================================
-- SQUIRREL CAN'T EXECUTE THIS, RUN IT IN DBEAVER

CREATE OR REPLACE FUNCTION update_etd_investor_type_custom() 
RETURNS trigger AS $d$
BEGIN
	IF NEW.investor_type in ('INSTITUTIONAL', 'NOMINEES') THEN NEW.investor_type_custom = 'INSTITUTIONAL';
	ELSIF NEW.investor_type = 'RETAIL' THEN NEW.investor_type_custom = 'RETAIL';
	END IF;
	RETURN NEW;
END;
$d$ LANGUAGE plpgsql;

CREATE TRIGGER set_etd_investor_type_custom
before insert or update of investor_type
on dibots_v2.exchange_trade_demography
for each row execute procedure update_etd_investor_type_custom();

--=====================================
-- INCREMENTAL UPDATE FOR ETD_* TABLES
--=====================================

-- incremental update for exchange_demography_broker_age_band
insert into dibots_v2.exchange_demography_broker_age_band (trading_date, week_count, year, month, external_id, participant_code, participant_name, total_buysell_volume, 
total_buysell_value, age_band, intraday_volume, intraday_value)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), external_id, 
participant_code, participant_name, sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_buysell_volume, 
sum(gross_traded_value_buy + gross_traded_value_sell), dibots_age_band, sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_broker_age_band)
group by trading_date, external_id, participant_code, participant_name, dibots_age_band;

update dibots_v2.exchange_demography_broker_age_band a
set
male_count = b.cnt
from (select trading_date, participant_code, dibots_age_band, count(*) as cnt from dibots_v2.exchange_demography 
where gender = 'MALE' and locality_new = 'LOCAL' and group_type = 'RETAIL'
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_broker_age_band where male_count is not null)
group by trading_date, participant_code, dibots_age_band) b
where a.trading_date = b.trading_date and a.age_band = b.dibots_age_band and a.participant_code = b.participant_code;

update dibots_v2.exchange_demography_broker_age_band a
set
female_count = b.cnt
from (select trading_date, participant_code, dibots_age_band, count(*) as cnt from dibots_v2.exchange_demography 
where gender = 'FEMALE' and locality_new = 'LOCAL' and group_type = 'RETAIL' 
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_broker_age_band where female_count is not null)
group by trading_date, participant_code, dibots_age_band) b
where a.trading_date = b.trading_date and a.age_band = b.dibots_age_band and a.participant_code = b.participant_code;

update dibots_v2.exchange_demography_broker_age_band a
set
na_gender_count = b.cnt
from (select trading_date, participant_code, dibots_age_band, count(*) as cnt from dibots_v2.exchange_demography 
where gender = 'GENDER NOT AVAILABLE' and locality_new = 'LOCAL' and group_type = 'RETAIL' 
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_broker_age_band where na_gender_count is not null)
group by trading_date, participant_code, dibots_age_band) b
where a.trading_date = b.trading_date and a.age_band = b.dibots_age_band and a.participant_code = b.participant_code;

-- incremental update for exchange_demography_broker_movement
-- insert into dibots_v2.exchange_demography_broker_movement (trading_date, week_count, year, month, external_id, participant_code, participant_name, 
-- locality, group_type, board, sector, klci_flag, fbm100_flag, shariah_flag, total_volume, total_value, net_volume, net_value, 
-- intraday_volume, intraday_value, buy_volume, buy_value, sell_volume, sell_value)
-- select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), 
-- external_id, participant_code, participant_name, locality_new, group_type, board, sector, klci_flag, fbm100_flag, shariah_flag,
-- sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_value_buy + gross_traded_value_sell), 
-- sum(gross_traded_volume_buy - gross_traded_volume_sell), sum(gross_traded_value_buy - gross_traded_value_sell), sum(intraday_volume), sum(intraday_value), 
-- sum(gross_traded_volume_buy), sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell)
-- from dibots_v2.exchange_demography
-- where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_broker_movement)
-- group by trading_date, external_id, participant_code, participant_name, locality_new, group_type, board, sector, klci_flag, fbm100_flag, shariah_flag;

-- incremntal update for exchange_demography_broker_stats
insert into dibots_v2.exchange_demography_broker_stats (trading_date, participant_code, external_id, participant_name, locality, group_type, 
trades_count, total_traded_value, net_traded_value, min_traded_value_buy, min_traded_value_sell, max_traded_value_buy, max_traded_value_sell, 
total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, participant_code, external_id, participant_name, locality_new, group_type, count(*) as trades_count, 
sum(gross_traded_value_buy + gross_traded_value_sell) as total_traded_value,
sum(gross_traded_value_buy - gross_traded_value_sell) as net_traded_value,
min(nullif(gross_traded_value_buy,0)) as min_traded_value_buy, min(nullif(gross_traded_value_sell,0)) as min_traded_value_sell, 
max(gross_traded_value_buy) as max_traded_value_buy, max(gross_traded_value_sell) as max_traded_value_sell, 
sum(intraday_volume), sum(intraday_value), min(intraday_volume), min(intraday_value), max(intraday_volume), max(intraday_value)
from dibots_v2.exchange_demography
where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_broker_stats)
group by trading_date, participant_code, external_id, participant_name, locality_new, group_type;

-- incremental update for exchange_demography_stock_broker_nationality
insert into dibots_v2.exchange_demography_stock_broker_nationality (trading_date, week_count, year, month, broker_code, broker_name, broker_ext_id, stock_code, stock_name, stock_num, nationality, 
volume, value, buy_vol, buy_val, sell_vol, sell_val, net_vol, net_val, intraday_vol, intraday_val)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), participant_code, participant_name, external_id, stock_code, stock_name, stock_num, nationality, 
sum(coalesce(gross_traded_volume_buy,0) + coalesce(gross_traded_volume_sell,0)), sum(coalesce(gross_traded_value_buy,0) + coalesce(gross_traded_value_sell,0)),
sum(gross_traded_volume_buy), sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell), sum(coalesce(gross_traded_volume_buy,0) - coalesce(gross_traded_volume_sell,0)), 
sum(coalesce(gross_traded_value_buy,0) - coalesce(gross_traded_value_sell,0)), sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_nationality)
group by trading_date, participant_code, participant_name, external_id, stock_code, stock_name, stock_num, nationality;

-- incremental update for exchange_demography_stats
insert into dibots_v2.exchange_demography_stats (trading_date, stock_code, stock_name, stock_num, locality, group_type, trades_count, total_traded_value, net_traded_value,
min_traded_value_buy, min_traded_value_sell, max_traded_value_buy, max_traded_value_sell, 
total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, stock_code, stock_name, stock_num, locality_new, group_type, count(*) as trades_count, sum(gross_traded_value_buy + gross_traded_value_sell) as total_traded_value,
sum(gross_traded_value_buy - gross_traded_value_sell) as net_traded_value,
min(nullif(gross_traded_value_buy,0)) as min_traded_value_buy, min(nullif(gross_traded_value_sell,0)) as min_traded_value_sell, 
max(gross_traded_value_buy) as max_traded_value_buy, max(gross_traded_value_sell) as max_traded_value_sell, 
sum(intraday_volume), sum(intraday_value), min(intraday_volume), min(intraday_value), max(intraday_volume), max(intraday_value)
from dibots_v2.exchange_demography
where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stats)
group by trading_date, stock_code, stock_name, stock_num, locality_new, group_type;

-- incremental update for exchange_demography_stock_retail_prof
insert into dibots_v2.exchange_demography_stock_retail_prof (trading_date, week_count, year, month, stock_code, stock_name, stock_num, board, sector, race, bumi_flag, age_band,
total_vol, total_val, intraday_vol, intraday_val)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), stock_code, stock_name, stock_num, board, sector, race, 
case when race = 'BUMIPUTRA' then TRUE else false END as bumi_flag, dibots_age_band,
sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_vol, 
sum(gross_traded_value_buy + gross_traded_value_sell) as total_val, sum(intraday_volume) as intraday_vol, sum(intraday_value) as intraday_val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_retail_prof)
group by trading_date, stock_code, stock_name, stock_num, board, sector, race, dibots_age_band;

update dibots_v2.exchange_demography_stock_retail_prof a
set
male_count = b.cnt
from (
select trading_date, stock_code, dibots_age_band, race, count(*) as cnt 
from dibots_v2.exchange_demography 
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'MALE'
and trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_retail_prof)
group by trading_date, stock_code, dibots_age_band, race) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.age_band = b.dibots_age_band and a.race = b.race;

update dibots_v2.exchange_demography_stock_retail_prof a
set
female_count = b.cnt
from (
select trading_date, stock_code, dibots_age_band, race, count(*) as cnt 
from dibots_v2.exchange_demography 
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'FEMALE'
and trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_retail_prof)
group by trading_date, stock_code, dibots_age_band, race) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.age_band = b.dibots_age_band and a.race = b.race;

update dibots_v2.exchange_demography_stock_retail_prof a
set
na_gender_count = b.cnt
from (
select trading_date, stock_code, dibots_age_band, race, count(*) as cnt 
from dibots_v2.exchange_demography 
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'GENDER NOT AVAILABLE'
and trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_retail_prof)
group by trading_date, stock_code, dibots_age_band, race) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.age_band = b.dibots_age_band and a.race = b.race;

-- incremental update for exchange_demography_stock_broker
insert into dibots_v2.exchange_demography_stock_broker (trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality, group_type,
buy_volume, sell_volume, volume, net_volume, buy_value, sell_value, value, net_value, intraday_volume, intraday_value)
select trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality_new, group_type,
sum(gross_traded_volume_buy), sum(gross_traded_volume_sell), sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_volume_buy - gross_traded_volume_sell),
sum(gross_traded_value_buy), sum(gross_traded_value_sell), sum(gross_traded_value_buy + gross_traded_value_sell), sum(gross_traded_value_buy - gross_traded_value_sell), 
sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_demography
where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker)
group by trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality_new, group_type;

-- incremental update for exchange_demography_stock_broker_group
insert into dibots_v2.exchange_demography_stock_broker_group (trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, 
participant_name, total_volume, total_value, net_volume, net_value, klci_flag, fbm100_flag, shariah_flag, total_intraday_vol, total_intraday_val, 
buy_vol, buy_val, sell_vol, sell_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, 
sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_value_buy + gross_traded_value_sell),
sum(gross_traded_volume_buy - gross_traded_volume_sell), sum(gross_traded_value_buy - gross_traded_value_sell),
klci_flag, fbm100_flag, shariah_flag, sum(intraday_volume), sum(intraday_value), sum(gross_traded_volume_buy), sum(gross_traded_value_buy),
sum(gross_traded_volume_sell), sum(gross_traded_value_sell)
from dibots_v2.exchange_demography
where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group)
group by trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, klci_flag, fbm100_flag, shariah_flag;

update dibots_v2.exchange_demography_stock_broker_group a
set
local_volume = tmp.vol,
local_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'LOCAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where local_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
foreign_volume = tmp.vol,
foreign_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'FOREIGN' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where foreign_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
prop_volume = tmp.vol,
prop_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality_new = 'PROPRIETARY' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where prop_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
total_inst_volume = tmp.vol,
total_inst_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where total_inst_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where local_inst_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where foreign_inst_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where total_retail_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where local_retail_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where foreign_retail_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
total_nominees_volume = tmp.vol,
total_nominees_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where total_nominees_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where local_nominees_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where foreign_nominees_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where ivt_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
pdt_volume = tmp.vol,
pdt_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'PDT' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where pdt_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_local_volume = tmp.vol,
net_local_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality = 'LOCAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_local_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;


update dibots_v2.exchange_demography_stock_broker_group a
set
net_foreign_volume = tmp.vol,
net_foreign_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where locality = 'FOREIGN' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_foreign_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_prop_volume = tmp.vol,
net_prop_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography 
where locality = 'PROPRIETARY' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_prop_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_inst_volume = tmp.vol,
net_inst_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_inst_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_retail_volume = tmp.vol,
net_retail_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_retail_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_nominees_volume = tmp.vol,
net_nominees_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_nominees_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_ivt_volume = tmp.vol,
net_ivt_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'IVT' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_ivt_volume is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_demography_stock_broker_group a
set
net_pdt_volume = tmp.vol,
net_pdt_value = tmp.val
from 
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_demography
where group_type = 'PDT' and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_pdt_volume is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_local_inst_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_foreign_inst_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_local_retail_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_foreign_retail_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_local_nominees_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where net_foreign_nominees_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where local_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where foreign_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where inst_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where local_inst_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where foreign_inst_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where retail_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where local_retail_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where foreign_retail_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where nominees_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where local_nominees_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where foreign_nominees_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where ivt_intraday_vol is not null)
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
and trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group where pdt_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;


-- incremental update for exchange_demography_stock_broker_stats
insert into dibots_v2.exchange_demography_stock_broker_stats (trading_date, stock_code, stock_name, stock_num, participant_code, participant_name, locality, group_type,
trade_count, min_traded_value_buy, max_traded_value_buy, min_traded_value_sell, max_traded_value_sell, total_buysell_value, net_buysell_value,
total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, stock_code, stock_name, stock_num, participant_code, participant_name, locality_new, group_type, count(*),
COALESCE(min(nullif(gross_traded_value_buy,0)),0) as min_val_buy, COALESCE(max(nullif(gross_traded_value_buy,0)),0) AS max_val_buy, COALESCE(min(nullif(gross_traded_value_sell,0)),0) as min_val_sell,
COALESCE(max(nullif(gross_traded_value_sell,0)),0) as max_val_sell, sum(gross_traded_value_buy + gross_traded_value_sell) as total_buysell_value, sum(gross_traded_value_buy - gross_traded_value_sell) as net_buysell_value,
sum(intraday_volume), sum(intraday_value), min(intraday_volume), min(intraday_value), max(intraday_volume), max(intraday_value)
from dibots_v2.exchange_demography
where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_stats)
group by trading_date, stock_code,stock_name, stock_num, participant_code, participant_name, locality_new, group_type;

-- incremental update for exchange_demography_stock_movement
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
where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_movement)
group by trading_date, stock_code, stock_name, stock_num, board, sector, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag;

update dibots_v2.exchange_demography_stock_movement a
set
total_investors = b.inv
from 
(select trading_date, stock_code, locality_new, group_type, sum(total_investors) as inv, sum(total_traded_volume), sum(total_traded_value)
from dibots_v2.exchange_investor_stock_stats
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_movement)
group by trading_date, stock_code, locality_new, group_type) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.locality = b.locality_new and a.group_type = b.group_type;

-- incremental update for exchange_demography_stock_week
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
from dibots_v2.exchange_demography_stock_broker_group where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_week)
group by trading_date, stock_code, stock_name, stock_num;

update dibots_v2.exchange_demography_stock_week a 
set
board = b.board,
sector = b.sector,
klci_flag = b.klci_flag,
fbm100_flag = b.fbm100_flag,
shariah_flag = b.shariah_flag
from dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code 
and a.trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_week);


-- incremental update for the ranking of market cap in exchange_daily_transaction
update dibots_v2.exchange_daily_transaction a
set
rank_overall = tmp.rank
from (
select transaction_date, stock_code, rank() over (partition by transaction_date order by market_capitalisation desc) rank
from dibots_v2.exchange_daily_transaction where security_type in ('REAL ESTATE INVESTMENT TRUSTS', 'LOCAL ORDINARY', 'STAPLED SECURITY')
and transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction)
) tmp
where a.transaction_date = tmp.transaction_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_daily_transaction a
set
rank_board = tmp.rank
from (
select transaction_date, stock_code, rank() over (partition by transaction_date, board order by market_capitalisation desc) rank
from dibots_v2.exchange_daily_transaction where security_type in ('REAL ESTATE INVESTMENT TRUSTS', 'LOCAL ORDINARY', 'STAPLED SECURITY')
and transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction)
) tmp
where a.transaction_date = tmp.transaction_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_daily_transaction a
set
rank_sector = tmp.rank
from (
select transaction_date, stock_code, rank() over (partition by transaction_date, sector order by market_capitalisation desc) rank
from dibots_v2.exchange_daily_transaction where security_type in ('REAL ESTATE INVESTMENT TRUSTS', 'LOCAL ORDINARY', 'STAPLED SECURITY')
and transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction)
) tmp
where a.transaction_date = tmp.transaction_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_daily_transaction a
set
rank_board_sector = tmp.rank
from (
select transaction_date, stock_code, rank() over (partition by transaction_date, board, sector order by market_capitalisation desc) rank
from dibots_v2.exchange_daily_transaction where security_type in ('REAL ESTATE INVESTMENT TRUSTS', 'LOCAL ORDINARY', 'STAPLED SECURITY')
and transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction)
) tmp
where a.transaction_date = tmp.transaction_date and a.stock_code = tmp.stock_code;


-- incremental update for exchange_daily_transaction_velocity
insert into dibots_v2.exchange_daily_transaction_velocity (transaction_date, stock_code, stock_name_short, stock_num, volume_traded_market_transaction, shares_outstanding, velocity_per_day)
select transaction_date, stock_code, stock_name_short, stock_num, volume_traded_market_transaction, shares_outstanding, 
CASE WHEN shares_outstanding = 0 THEN 0 ELSE (cast(volume_traded_market_transaction as numeric(25,3)) / cast(shares_outstanding as numeric(25,5)) * 248 * 100) END as velocity_per_day 
from dibots_v2.exchange_daily_transaction
where transaction_date > (select max(transaction_date) from dibots_v2.exchange_daily_transaction_velocity);


-- incremental update for exchange_daily_avg
insert into dibots_v2.exchange_daily_avg (trading_date, stock_code, stock_name, stock_num, opening, high, low, closing, vwap, factor, adj_closing, adj_vwap)
select transaction_date, stock_code, stock_name_short, stock_num, opening_price, high_price, low_price, closing_price, vwap, factor, adj_closing, vwap * factor
from dibots_v2.exchange_daily_transaction
where transaction_date > (select max(trading_date) from dibots_v2.exchange_daily_avg);
