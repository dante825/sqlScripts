--===============================================
--INCREMENTAL UPDATE for exchange_dbt_* tables
--===============================================

-- exchange_dbt_broker_movement
-- insert into dibots_v2.exchange_dbt_broker_movement (trading_date, external_id, participant_code, participant_name, board, sector, klci_flag, fbm100_flag, shariah_flag, locality, group_type, 
-- buy_vol, buy_val, sell_vol, sell_val, total_vol, total_val, net_vol, net_val, intraday_vol, intraday_val)
-- select trading_date, external_id, participant_code, participant_name, board, sector, klci_flag, fbm100_flag, shariah_flag, locality, group_type, sum(gross_traded_volume_buy),
-- sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell), sum(gross_traded_volume_buy+gross_traded_volume_sell), 
-- sum(gross_traded_value_buy+gross_traded_value_sell), sum(gross_traded_volume_buy-gross_traded_volume_sell), sum(gross_traded_value_buy-gross_traded_value_sell), 
-- sum(intraday_volume), sum(intraday_value)
-- from dibots_v2.exchange_direct_business_trade
-- where trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_broker_movement)
-- group by trading_date, external_id, participant_code, participant_name, board, sector, klci_flag, fbm100_flag, shariah_flag, locality, group_type;

-- exchange_dbt_stock_broker_group
insert into dibots_v2.exchange_dbt_stock_broker_group (trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name,
total_vol, total_val, total_intraday_vol, total_intraday_val, buy_vol, buy_val, sell_vol, sell_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name, 
sum(gross_traded_volume_buy+gross_traded_volume_sell), sum(gross_traded_value_buy+gross_traded_value_sell), sum(intraday_volume), sum(intraday_value),
sum(gross_traded_volume_buy), sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell)
from dibots_v2.exchange_direct_business_trade
where trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group)
group by trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag, external_id, participant_code, participant_name;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_vol = tmp.vol,
local_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where local_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_vol = tmp.vol,
foreign_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where foreign_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
prop_vol = tmp.vol,
prop_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'PROPRIETARY' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where prop_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
inst_vol = tmp.vol,
inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where inst_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_inst_vol = tmp.vol,
local_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where local_inst_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_inst_vol = tmp.vol,
foreign_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where foreign_inst_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
retail_vol = tmp.vol,
retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where retail_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_retail_vol = tmp.vol,
local_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where local_retail_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_retail_vol = tmp.vol,
foreign_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where foreign_retail_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
nominees_vol = tmp.vol,
nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where nominees_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_nominees_vol = tmp.vol,
local_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where local_nominees_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_nominees_vol = tmp.vol,
foreign_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where foreign_nominees_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
ivt_vol = tmp.vol,
ivt_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'IVT' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where ivt_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
pdt_vol = tmp.vol,
pdt_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(gross_traded_value_buy + gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'PDT' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where pdt_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_vol = tmp.vol,
net_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_local_vol = tmp.vol,
net_local_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL'  and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_local_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_foreign_vol = tmp.vol,
net_foreign_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_foreign_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_prop_vol = tmp.vol,
net_prop_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'PROPRIETARY' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_prop_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_inst_vol = tmp.vol,
net_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_inst_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_local_inst_vol = tmp.vol,
net_local_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_local_inst_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_foreign_inst_vol = tmp.vol,
net_foreign_inst_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_foreign_inst_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_retail_vol = tmp.vol,
net_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_retail_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_local_retail_vol = tmp.vol,
net_local_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_local_retail_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_foreign_retail_vol = tmp.vol,
net_foreign_retail_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_foreign_retail_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_nominees_vol = tmp.vol,
net_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_nominees_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_local_nominees_vol = tmp.vol,
net_local_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_local_nominees_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_foreign_nominees_vol = tmp.vol,
net_foreign_nominees_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_foreign_nominees_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_ivt_vol = tmp.vol,
net_ivt_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'IVT' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_ivt_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
net_pdt_vol = tmp.vol,
net_pdt_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(gross_traded_volume_buy - gross_traded_volume_sell) as vol, sum(gross_traded_value_buy - gross_traded_value_sell) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'PDT' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where net_pdt_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
total_intraday_vol = tmp.vol,
total_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade 
where trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where total_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_intraday_vol = tmp.vol,
local_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where local_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_intraday_vol = tmp.vol,
foreign_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where foreign_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
inst_intraday_vol = tmp.vol,
inst_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where inst_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_inst_intraday_vol = tmp.vol,
local_inst_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where local_inst_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_inst_intraday_vol = tmp.vol,
foreign_inst_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where foreign_inst_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
retail_intraday_vol = tmp.vol,
retail_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where retail_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_retail_intraday_vol = tmp.vol,
local_retail_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where local_retail_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_retail_intraday_vol = tmp.vol,
foreign_retail_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where foreign_retail_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
nominees_intraday_vol = tmp.vol,
nominees_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where nominees_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
local_nominees_intraday_vol = tmp.vol,
local_nominees_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'NOMINEES' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where local_nominees_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
foreign_nominees_intraday_vol = tmp.vol,
foreign_nominees_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and group_type = 'NOMINEES'  and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where foreign_nominees_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
ivt_intraday_vol = tmp.vol,
ivt_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'IVT' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where ivt_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

update dibots_v2.exchange_dbt_stock_broker_group a
set
pdt_intraday_vol = tmp.vol,
pdt_intraday_val = tmp.val
from
(select trading_date, stock_code, participant_code, sum(intraday_volume) as vol, sum(intraday_value) as val
from dibots_v2.exchange_direct_business_trade
where group_type = 'PDT' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group where pdt_intraday_vol is not null)
group by trading_date, stock_code, participant_code) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and a.participant_code = tmp.participant_code;

-- exchange_dbt_stock
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
where trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock)
group by trading_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag;

-- exchange_dbt_broker_age_band
insert into dibots_v2.exchange_dbt_broker_age_band (trading_date, external_id, participant_code, participant_name, age_band, total_vol, total_val, intraday_vol, intraday_val)
select trading_date, external_id, participant_code, participant_name, dibots_age_band, sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_value_buy+gross_traded_value_sell),
sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_direct_business_trade 
where locality_new = 'LOCAL' and group_type = 'RETAIL' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_broker_age_band)
group by trading_date, external_id, participant_code, participant_name, dibots_age_band;

update dibots_v2.exchange_dbt_broker_age_band a
set
male_count = b.cnt
from 
(select trading_date, participant_code, count(*) as cnt from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'MALE' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_broker_age_band where male_count is not null)
group by trading_date, participant_code) b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

update dibots_v2.exchange_dbt_broker_age_band a
set
female_count = b.cnt
from 
(select trading_date, participant_code, count(*) as cnt from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'FEMALE' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_broker_age_band where female_count is not null)
group by trading_date, participant_code) b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

update dibots_v2.exchange_dbt_broker_age_band a
set
na_gender_count = b.cnt
from 
(select trading_date, participant_code, count(*) as cnt from dibots_v2.exchange_direct_business_trade
where locality_new = 'LOCAL' and group_type = 'RETAIL' and gender = 'GENDER NOT AVAILABLE'
and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_broker_age_band where na_gender_count is not null)
group by trading_date, participant_code) b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

-- exchange_dbt_stock_broker_nationality
insert into dibots_v2.exchange_dbt_stock_broker_nationality (trading_date, week_count, year, month, broker_code, broker_name, broker_ext_id, stock_code, stock_name, stock_num, nationality, 
volume, value, buy_vol, buy_val, sell_vol, sell_val, net_vol, net_val, intraday_vol, intraday_val)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(year from trading_date), extract(month from trading_date), participant_code, participant_name, external_id, stock_code, stock_name, stock_num, nationality, 
sum(coalesce(gross_traded_volume_buy,0) + coalesce(gross_traded_volume_sell,0)), sum(coalesce(gross_traded_value_buy,0) + coalesce(gross_traded_value_sell,0)),
sum(gross_traded_volume_buy), sum(gross_traded_value_buy), sum(gross_traded_volume_sell), sum(gross_traded_value_sell), sum(coalesce(gross_traded_volume_buy,0) - coalesce(gross_traded_volume_sell,0)), 
sum(coalesce(gross_traded_value_buy,0) - coalesce(gross_traded_value_sell,0)), sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_nationality)
group by trading_date, participant_code, participant_name, external_id, stock_code, stock_name, stock_num, nationality;

-- exchange_dbt_broker_nationality
insert into dibots_v2.exchange_dbt_broker_nationality (trading_date, participant_code, external_id, participant_name, nationality, 
total_vol, total_val, intraday_vol, intraday_val)
select trading_date, participant_code, external_id, participant_name, nationality, sum(gross_traded_volume_buy + gross_traded_volume_sell), 
sum(gross_traded_value_buy + gross_traded_value_sell), sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_direct_business_trade
where locality_new = 'FOREIGN' and trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_broker_nationality)
group by trading_date, participant_code, external_id, participant_name, nationality;

-- exchange_dbt_broker_stats
insert into dibots_v2.exchange_dbt_broker_stats (trading_date, participant_code, external_id, participant_name, locality, group_type, 
trades_count, total_val, net_val, min_buy_val, min_sell_val, max_buy_val, max_sell_val, total_intraday_vol, total_intraday_val, min_intraday_vol, min_intraday_val, max_intraday_vol, max_intraday_val)
select trading_date, participant_code, external_id, participant_name, locality_new, group_type, count(*) as trades_count, sum(gross_traded_value_buy + gross_traded_value_sell) as total_val,
sum(gross_traded_value_buy - gross_traded_value_sell) as net_val,
min(nullif(gross_traded_value_buy,0)) as min_buy_val, min(nullif(gross_traded_value_sell,0)) as min_sell_val, max(gross_traded_value_buy) as max_buy_val, 
max(gross_traded_value_sell) as max_sell_val, 
sum(intraday_volume), sum(intraday_value), min(intraday_volume), min(intraday_value), max(intraday_volume), max(intraday_value)
from dibots_v2.exchange_direct_business_trade
where trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_broker_stats)
group by trading_date, participant_code, external_id, participant_name, locality_new, group_type;

-- exchange_dbt_stock_broker
insert into dibots_v2.exchange_dbt_stock_broker (trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality, group_type,
buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val, klci_flag, fbm100_flag, shariah_flag)
select trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality_new, group_type,
sum(gross_traded_volume_buy), sum(gross_traded_volume_sell), sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_volume_buy - gross_traded_volume_sell),
sum(gross_traded_value_buy), sum(gross_traded_value_sell), sum(gross_traded_value_buy + gross_traded_value_sell), sum(gross_traded_value_buy - gross_traded_value_sell), 
sum(intraday_volume), sum(intraday_value), klci_flag, fbm100_flag, shariah_flag
from dibots_v2.exchange_direct_business_trade
where trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker)
group by trading_date, stock_code, stock_name, stock_num, board, sector, external_id, participant_code, participant_name, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag;

-- exchange_dbt_stock_movement
insert into dibots_v2.exchange_dbt_stock_movement (trading_date, stock_code, stock_name, stock_num, board, sector, locality, group_type, klci_flag, fbm100_flag, shariah_flag,
buy_vol, sell_vol, total_vol, net_vol, buy_val, sell_val, total_val, net_val, intraday_vol, intraday_val)
select trading_date, stock_code, stock_name, stock_num, board, sector, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag,
sum(gross_traded_volume_buy), sum(gross_traded_volume_sell), sum(gross_traded_volume_buy + gross_traded_volume_sell), 
sum(gross_traded_volume_buy - gross_traded_volume_sell), sum(gross_traded_value_buy),
sum(gross_traded_value_sell), sum(gross_traded_value_buy + gross_traded_value_sell), sum(gross_traded_value_buy - gross_traded_value_sell),
sum(intraday_volume), sum(intraday_value)
from dibots_v2.exchange_direct_business_trade
where trading_date > (select max(trading_date) from dibots_v2.exchange_dbt_stock_movement)
group by trading_date, stock_code, stock_name, stock_num, board, sector, locality_new, group_type, klci_flag, fbm100_flag, shariah_flag;