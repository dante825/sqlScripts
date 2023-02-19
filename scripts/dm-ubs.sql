-- UBS data mining

-- weekly net fund flow by sector, year 2020

select to_char(trading_date, 'IYYY-IW'), sector, sum(net_inst_value)::numeric(25,0) as inst, sum(net_retail_value)::numeric(25,0) as retail, sum(net_nominees_value)::numeric(25,0) as nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-01-31' and
sector not in ('CLOSED END FUND', 'STRUCTURED WARRANTS', 'EXCHANGE TRADED FUND-BOND', 'EXCHANGE TRADED FUND-COMMODITY', 'EXCHANGE TRADED FUND-EQUITY', 'EXCHANGE TRADED FUND-L&I', 'BOND ISLAMIC')
group by to_char(trading_date, 'IYYY-IW'), sector
order by to_char(trading_date, 'IYYY-IW'), sector


select to_char(trading_date, 'IYYY-IW'), sector, sum(buy_volume)::numeric(25,0) as buy_vol, sum(buy_value)::numeric(25,0) as buy_val, sum(sell_volume)::numeric(25,0) as sell_vol,
sum(sell_value)::numeric(25,0) as sell_val, sum(net_value)::numeric(25,0) as net_val 
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2020-01-01' and '2020-12-31' 
and LOCALITY = 'FOREIGN'
and sector not in ('CLOSED END FUND', 'STRUCTURED WARRANTS', 'EXCHANGE TRADED FUND-BOND', 'EXCHANGE TRADED FUND-COMMODITY', 'EXCHANGE TRADED FUND-EQUITY', 'EXCHANGE TRADED FUND-L&I', 'BOND ISLAMIC')
group by to_char(trading_date, 'IYYY-IW'), sector
order by to_char(trading_date, 'IYYY-IW'), sector

-- weekly net fund flow by sector, with latest sector classification
select to_char(a.trading_date, 'IYYY-IW'), b.sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a, (select * from dibots_v2.exchange_daily_transaction where transaction_date = '2021-09-13') b
where a.stock_code = b.stock_code and a.trading_date between '2017-05-02' and '2021-09-13' 
and a.locality = 'LOCAL' and a.group_type = 'INSTITUTIONAL'
--and a.group_type = 'IVT'
and b.sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES') and b.security_type = 'LOCAL ORDINARY'
group by to_char(a.trading_date, 'IYYY-IW'), b.sector
order by to_char(a.trading_date, 'IYYY-IW'), b.sector

select to_char(a.trading_date, 'IYYY-IW'), b.sector, sum(a.net_local_inst_val)::numeric(25,0) as local_inst, sum(a.net_local_retail_val)::numeric(25,0) as local_retail, 
sum(a.net_local_nominees_val)::numeric(25,0) as nominees, sum(a.net_foreign_val)::numeric(25,0) as foreign
from dibots_v2.exchange_demography_stock_week a, (select * from dibots_v2.exchange_daily_transaction where transaction_date = '2021-09-10') b
where a.stock_code = b.stock_code and a.trading_date between '2021-01-01' and '2021-09-10' and
b.sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by to_char(a.trading_date, 'IYYY-IW'), b.sector
order by to_char(a.trading_date, 'IYYY-IW'), b.sector

--======================================
-- daily sector fund flow by group_type
--======================================

-- LOCAL_INST
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'LOCAL' and group_type = 'INSTITUTIONAL'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- FOREIGN_INST
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'FOREIGN' and group_type = 'INSTITUTIONAL'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- LOCAL_RETAIL
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'LOCAL' and group_type = 'RETAIL'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- FOREIGN_RETAIL
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'FOREIGN' and group_type = 'RETAIL'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- LOCAL_NOMINEES
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'LOCAL' and group_type = 'NOMINEES'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- FOREIGN_NOMINEES
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'FOREIGN' and group_type = 'NOMINEES'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

--=================================================
-- daily sector fund flow by group_type for fbm100
--=================================================

-- LOCAL_INST
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'LOCAL' and group_type = 'INSTITUTIONAL' and a.fbm100_flag = true
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- FOREIGN_INST
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'FOREIGN' and group_type = 'INSTITUTIONAL' and a.fbm100_flag = true
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- LOCAL_RETAIL
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'LOCAL' and group_type = 'RETAIL' and a.fbm100_flag = true
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- FOREIGN_RETAIL
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'FOREIGN' and group_type = 'RETAIL' and a.fbm100_flag = true
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- LOCAL_NOMINEES
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'LOCAL' and group_type = 'NOMINEES' and a.fbm100_flag = true
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;

-- FOREIGN_NOMINEES
select trading_date, sector, sum(a.buy_volume)::numeric(25,0) as buy_vol, sum(a.buy_value)::numeric(25,0) as buy_val, sum(a.sell_volume)::numeric(25,0) as sell_vol,
sum(a.sell_value)::numeric(25,0) as sell_val, sum(a.net_volume) as net_vol, sum(a.net_value)::numeric(25,0) as net_val
from dibots_v2.exchange_demography_stock_broker a
where trading_date between '2020-01-01' and '2022-06-30' and locality = 'FOREIGN' and group_type = 'NOMINEES' and a.fbm100_flag = true
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by trading_date, sector
order by trading_date, sector;


-- monthly top net buy sell stocks

--NET BUY INST
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' and group_type = 'INSTITUTIONAL'
group by stock_code, stock_name
order by sum(net_value) desc limit 10;

-- NET BUY RETAIL
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' and group_type = 'RETAIL'
group by stock_code, stock_name
order by sum(net_value) desc limit 10;

--NET BUY NOMINEES
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' and group_type = 'NOMINEES'
group by stock_code, stock_name
order by sum(net_value) desc limit 10;

-- NET BUY FOREIGN
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' and locality = 'FOREIGN'
group by stock_code, stock_name
order by sum(net_value) desc limit 10;



select stock_code, stock_name, sum(gross_traded_volume_buy)::numeric(25,0) as buy_volume, sum(gross_traded_value_buy)::numeric(25,0) as buy_value, 
sum(gross_traded_volume_sell)::numeric(25,0) as sell_volume, sum(gross_traded_value_sell)::numeric(25,0) as sell_value, sum(gross_traded_value_buy - gross_traded_value_sell)::numeric(25,0) as net
from dibots_v2.exchange_demography
where trading_date between '2020-03-01' and '2020-03-30' and locality_new = 'FOREIGN'
group by stock_code, stock_name
order by sum(gross_traded_value_buy-gross_traded_value_sell) asc limit 10;

--NET SELL INST
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' and group_type = 'INSTITUTIONAL'
group by stock_code, stock_name
order by sum(net_value) asc limit 10;

-- NET SELL RETAIL
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' and group_type = 'RETAIL'
group by stock_code, stock_name
order by sum(net_value) ASC limit 10;

--NET SELL NOMINEES
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' and group_type = 'NOMINEES'
group by stock_code, stock_name
order by sum(net_value) ASC limit 10;

-- NET SELL FOREIGN
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' and locality = 'FOREIGN'
group by stock_code, stock_name
order by sum(net_value) asc limit 10;



-- daily short vol and val for company with market_cap > rm 1bn
select stock_code, stock_name, sum(total_volume), sum(total_value) from dibots_v2.exchange_short_selling where stock_code in (
select stock_code from dibots_v2.exchange_daily_transaction where transaction_date = '2021-01-21' and market_capitalisation > 1000000000)
and trading_date between '2021-01-01' and '2021-01-21'
group by stock_code, stock_name
order by sum(total_value) desc


-- net fund flow for a few health care stocks

-- INST
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' 
and group_type = 'INSTITUTIONAL' and stock_code in ('7113', '7106', '7153', '5168', '5225', '7148', '5878', '7191', '7081')
group by stock_code, stock_name
order by sum(net_value) desc limit 10;

-- RETAIL
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31'
and group_type = 'RETAIL' and stock_code in ('7113', '7106', '7153', '5168', '5225', '7148', '5878', '7191', '7081')
group by stock_code, stock_name
order by sum(net_value) desc limit 10;

--NOMINEES
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' 
and group_type = 'NOMINEES' and stock_code in ('7113', '7106', '7153', '5168', '5225', '7148', '5878', '7191', '7081')
group by stock_code, stock_name
order by sum(net_value) desc limit 10;

-- FOREIGN
select stock_code, stock_name, sum(buy_volume)::numeric(25,0) as buy_volume, sum(buy_value)::numeric(25,0) as buy_value, 
sum(sell_volume)::numeric(25,0) as sell_volume, sum(sell_value)::numeric(25,0) as sell_value, sum(net_value)::numeric(25,0) as net
from dibots_v2.exchange_demography_stock_broker
where trading_date between '2021-01-01' and '2021-01-31' 
and locality = 'FOREIGN' and stock_code in ('7113', '7106', '7153', '5168', '5225', '7148', '5878', '7191', '7081')
group by stock_code, stock_name
order by sum(net_value) desc limit 10;

--==========================================
-- 3 gloves stock, TOPGLOVE (7113), HARTA (5168), KOSSAN (7153)
--==========================================

select year, month, sum(buy_value) as buy_val, sum(sell_value) as sell_val, sum(value) as total_val, sum(net_value) as net_val
from dibots_v2.exchange_demography_stock_movement where trading_date >= '2020-01-01' and stock_code = '7113' and locality = 'FOREIGN' and group_type = 'NOMINEES'
group by year, month 
order by year asc, month asc

select year, month, sum(buy_value) as buy_val, sum(sell_value) as sell_val, sum(value) as total_val, sum(net_value) as net_val
from dibots_v2.exchange_demography_stock_movement where trading_date >= '2020-01-01' and stock_code = '5168' and locality = 'FOREIGN' and group_type = 'NOMINEES'
group by year, month 
order by year asc, month asc

select year, month, sum(buy_value) as buy_val, sum(sell_value) as sell_val, sum(value) as total_val, sum(net_value) as net_val
from dibots_v2.exchange_demography_stock_movement where trading_date >= '2020-01-01' and stock_code = '7153' and locality = 'FOREIGN' and group_type = 'NOMINEES'
group by year, month 
order by year asc, month asc

--====================
-- STOCKS IN SECTOR
--====================

select distinct sector from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21'

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'CONSTRUCTION' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'CONSUMER PRODUCTS & SERVICES' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'ENERGY' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'FINANCIAL SERVICES' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'HEALTH CARE' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'INDUSTRIAL PRODUCTS & SERVICES' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'PLANTATION' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'PROPERTY' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'REAL ESTATE INVESTMENT TRUSTS' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'TECHNOLOGY' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'TELECOMMUNICATIONS & MEDIA' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'TRANSPORTATION & LOGISTICS' order by stock_code;

select stock_code, stock_name_short from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-21' and sector = 'UTILITIES' order by stock_code;


--================
-- NET FUND FLOW 
--================

select trading_date, stock_code, stock_name,net_local_inst_val, net_local_retail_val, net_local_nominees_val, net_foreign_val, coalesce(net_ivt_val,0) + coalesce(net_pdt_val,0) as net_prop_val,
net_local_inst_vol, net_local_retail_vol, net_local_nominees_vol, net_foreign_vol, coalesce(net_ivt_vol,0) + coalesce(net_pdt_vol,0) as net_prop_vol
from dibots_v2.exchange_demography_stock_week where trading_date between '2017-05-02' and '2021-09-10' and stock_code = '7113'
order by trading_date asc

select trading_date,stock_code, stock_name, net_local_inst_val, net_local_retail_val, net_local_nominees_val, net_foreign_val, coalesce(net_ivt_val,0) + coalesce(net_pdt_val,0) as net_prop_val,
net_local_inst_vol, net_local_retail_vol, net_local_nominees_vol, net_foreign_vol, coalesce(net_ivt_vol,0) + coalesce(net_pdt_vol,0) as net_prop_vol
from dibots_v2.exchange_demography_stock_week where trading_date between '2017-05-02' and '2021-09-10' and stock_code = '4197'
order by trading_date asc
