--==========================================
-- EXCHANGE_DAILY_TRANSACTION partitioning
--==========================================

CREATE TABLE dibots_v2.exchange_daily_transaction (
   transaction_date date NOT NULL,
   week_count varchar(10),
   year int,
   month int,
   stock_code varchar(10) NOT NULL,
   stock_name_short varchar(100) NOT NULL,
   stock_name_long varchar(255) NOT NULL,
   board varchar(100) NOT NULL,
   sector varchar(100) NOT NULL,
   sub_sector varchar(100) NOT NULL,
   security_type varchar(100) NOT NULL,
   currency varchar(5) NOT NULL,
   opening_price numeric(25,3) NOT NULL,
   high_price numeric(25,3) NOT NULL,
   low_price numeric(25,3) NOT NULL,
   closing_price numeric(25,3) NOT NULL,
   volume_traded_market_transaction bigint NOT NULL,
   volume_traded_direct_business bigint NOT NULL,
   value_traded_market_transaction numeric(25,3) NOT NULL,
   value_traded_direct_business numeric(25,3) NOT NULL,
   shares_outstanding bigint NOT NULL,
   market_capitalisation numeric(25,3),
   klci_indicator varchar(10),
   fbm100_indicator varchar(10),
   last_adjusted_closing_price numeric(25,3) NOT NULL,
   vwap numeric(25,3) NOT NULL,
   shariah_indicator varchar(10),
   idss_approved varchar(10),
   idss_volume bigint,
   idss_value numeric(25,3),
   market_rank int,
   sector_rank int,
   price_changed numeric(25,3),
   closing_price_base numeric(25,3),
   klci_flag bool DEFAULT false,
   fbm100_flag bool DEFAULT false,
   shariah_flag bool DEFAULT false,
   y_closing numeric(32,6),
   y_factor numeric(32,6),
   factor numeric(32,6),
   adj_closing numeric(32,6),
   adj_lacp numeric(32,6),
   adj_price_changed numeric(32,6),
   direct_business_pct numeric(25,3),
   rank_overall int,
   rank_board int,
   rank_sector int,
   rank_board_sector int,
   esg_flag bool default false
   esg_rating int,
   stock_num int,
   board_num int,
   sector_num int,
   sec_type_num int;
) PARTITION BY RANGE (transaction_date);

alter table dibots_v2.exchange_daily_transaction add constraint edtrans_pkey primary key (transaction_date, stock_code);

create table dibots_v2.exchange_daily_transaction_y2015_2016 partition of dibots_v2.exchange_daily_transaction
for values from ('2015-01-01') to ('2017-01-01');
create table dibots_v2.exchange_daily_transaction_y2017_2018 partition of dibots_v2.exchange_daily_transaction
for values from ('2017-01-01') to ('2019-01-01');
create table dibots_v2.exchange_daily_transaction_y2019_2020 partition of dibots_v2.exchange_daily_transaction
for values from ('2019-01-01') to ('2021-01-01');
create table dibots_v2.exchange_daily_transaction_y2021_2022 partition of dibots_v2.exchange_daily_transaction
for values from ('2021-01-01') to ('2023-01-01');
create table dibots_v2.exchange_daily_transaction_y2023_2024 partition of dibots_v2.exchange_daily_transaction
for values from ('2023-01-01') to ('2025-01-01');
create table dibots_v2.exchange_daily_transaction_default partition of dibots_v2.exchange_daily_transaction default;

create index exchg_daily_trans_security_type_idx on dibots_v2.exchange_daily_transaction (security_type);
create index exchg_daily_trans_board_idx on dibots_v2.exchange_daily_transaction (board);
create index exchg_daily_trans_sector_idx on dibots_v2.exchange_daily_transaction (sector);
create index exchg_daily_trans_week_idx on dibots_v2.exchange_daily_transaction (week_count);
create index exchg_daily_trans_year_idx on dibots_v2.exchange_daily_transaction (year);
create index exchg_daily_trans_month_idx on dibots_v2.exchange_daily_transaction (month);
create index exchg_daily_trans_year_month_idx on dibots_v2.exchange_daily_transaction (year, month);

update dibots_v2.exchange_daily_transaction
set
week_count = to_char(transaction_date, 'IYYY-IW'), 
year = extract(year from transaction_date), 
month = extract(month from transaction_date)
where week_count is null;

--===================================
-- EXCHANGE_DAILY_AVG partitioning
--===================================

create table dibots_v2.exchange_daily_avg (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
closing numeric(25,5),
vwap numeric(25,5),
factor numeric(25,5),
adj_closing numeric(25,5),
adj_vwap numeric(25,5),
sma5 numeric(25,10),
sma6 numeric(25,10),
sma9 numeric(25,10),
sma10 numeric(25,10),
sma12 numeric(25,10),
sma15 numeric(25,10),
sma19 numeric(25,10),
sma20 numeric(25,10),
sma26 numeric(25,10),
sma30 numeric(25,10),
sma39 numeric(25,10),
sma50 numeric(25,10),
sma200 numeric(25,10),
sma_vwap5 numeric(25,10),
sma_vwap6 numeric(25,10),
sma_vwap9 numeric(25,10),
sma_vwap10 numeric(25,10),
sma_vwap12 numeric(25,10),
sma_vwap15 numeric(25,10),
sma_vwap19 numeric(25,10),
sma_vwap20 numeric(25,10),
sma_vwap26 numeric(25,10),
sma_vwap30 numeric(25,10),
sma_vwap39 numeric(25,10),
sma_vwap50 numeric(25,10),
sma_vwap200 numeric(25,10),
ema5_y numeric(25,10),
ema5 numeric(25,10),
ema6_y numeric(25,10),
ema6 numeric(25,10),
ema9_y numeric(25,10),
ema9 numeric(25,10),
ema10_y numeric(25,10),
ema10 numeric(25,10),
ema12_y numeric(25,10),
ema12 numeric(25,10),
ema15_y numeric(25,10),
ema15 numeric(25,10),
ema19_y numeric(25,10),
ema19 numeric(25,10),
ema20_y numeric(25,10),
ema20 numeric(25,10),
ema26_y numeric(25,10),
ema26 numeric(25,10),
ema30_y numeric(25,10),
ema30 numeric(25,10),
ema39_y numeric(25,10),
ema39 numeric(25,10),
ema50_y numeric(25,10),
ema50 numeric(25,10),
ema200_y numeric(25,10),
ema200 numeric(25,10),
ema_vwap5_y numeric(25,10),
ema_vwap5 numeric(25,10),
ema_vwap6_y numeric(25,10),
ema_vwap6 numeric(25,10),
ema_vwap9_y numeric(25,10),
ema_vwap9 numeric(25,10),
ema_vwap10_y numeric(25,10),
ema_vwap10 numeric(25,10),
ema_vwap12_y numeric(25,10),
ema_vwap12 numeric(25,10),
ema_vwap15_y numeric(25,10),
ema_vwap15 numeric(25,10),
ema_vwap19_y numeric(25,10),
ema_vwap19 numeric(25,10),
ema_vwap20_y numeric(25,10),
ema_vwap20 numeric(25,10),
ema_vwap26_y numeric(25,10),
ema_vwap26 numeric(25,10),
ema_vwap30_y numeric(25,10),
ema_vwap30 numeric(25,10),
ema_vwap39_y numeric(25,10),
ema_vwap39 numeric(25,10),
ema_vwap50_y numeric(25,10),
ema_vwap50 numeric(25,10),
ema_vwap200_y numeric(25,10),
ema_vwap200 numeric(25,10),
constraint ed_avg_pk primary key (trading_date, stock_num)
) PARTITION BY RANGE (trading_date);

create table dibots_v2.exchange_daily_avg_y2015_2016 partition of dibots_v2.exchange_daily_avg
for values from ('2015-01-01') to ('2017-01-01');
create table dibots_v2.exchange_daily_avg_y2017_2018 partition of dibots_v2.exchange_daily_avg
for values from ('2017-01-01') to ('2019-01-01');
create table dibots_v2.exchange_daily_avg_y2019_2020 partition of dibots_v2.exchange_daily_avg
for values from ('2019-01-01') to ('2021-01-01');
create table dibots_v2.exchange_daily_avg_y2021_2022 partition of dibots_v2.exchange_daily_avg
for values from ('2021-01-01') to ('2023-01-01');
create table dibots_v2.exchange_daily_avg_y2023_2024 partition of dibots_v2.exchange_daily_avg
for values from ('2023-01-01') to ('2025-01-01');
create table dibots_v2.exchange_daily_avg_default partition of dibots_v2.exchange_daily_avg default;

create unique index ed_avg_uniq on dibots_v2.exchange_daily_avg (trading_date, stock_code);

--==============
-- FRESH START
--==============
-- 0. stop the pentaho job from triggering the daily_avg ETL
-- 1. use staging to store the data first
-- 2. generate the MAs with the python script
-- 3. after it is done, recreate the production table with the script above for the new structure
-- 4. insert the data into production table

create table staging.exchange_daily_avg (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
closing numeric(25,5),
vwap numeric(25,5),
factor numeric(25,5),
adj_closing numeric(25,5),
adj_vwap numeric(25,5),
sma5 numeric(25,10),
sma6 numeric(25,10),
sma9 numeric(25,10),
sma10 numeric(25,10),
sma12 numeric(25,10),
sma15 numeric(25,10),
sma19 numeric(25,10),
sma20 numeric(25,10),
sma26 numeric(25,10),
sma30 numeric(25,10),
sma39 numeric(25,10),
sma50 numeric(25,10),
sma200 numeric(25,10),
sma_vwap5 numeric(25,10),
sma_vwap6 numeric(25,10),
sma_vwap9 numeric(25,10),
sma_vwap10 numeric(25,10),
sma_vwap12 numeric(25,10),
sma_vwap15 numeric(25,10),
sma_vwap19 numeric(25,10),
sma_vwap20 numeric(25,10),
sma_vwap26 numeric(25,10),
sma_vwap30 numeric(25,10),
sma_vwap39 numeric(25,10),
sma_vwap50 numeric(25,10),
sma_vwap200 numeric(25,10),
ema5_y numeric(25,10),
ema5 numeric(25,10),
ema6_y numeric(25,10),
ema6 numeric(25,10),
ema9_y numeric(25,10),
ema9 numeric(25,10),
ema10_y numeric(25,10),
ema10 numeric(25,10),
ema12_y numeric(25,10),
ema12 numeric(25,10),
ema15_y numeric(25,10),
ema15 numeric(25,10),
ema19_y numeric(25,10),
ema19 numeric(25,10),
ema20_y numeric(25,10),
ema20 numeric(25,10),
ema26_y numeric(25,10),
ema26 numeric(25,10),
ema30_y numeric(25,10),
ema30 numeric(25,10),
ema39_y numeric(25,10),
ema39 numeric(25,10),
ema50_y numeric(25,10),
ema50 numeric(25,10),
ema200_y numeric(25,10),
ema200 numeric(25,10),
ema_vwap5_y numeric(25,10),
ema_vwap5 numeric(25,10),
ema_vwap6_y numeric(25,10),
ema_vwap6 numeric(25,10),
ema_vwap9_y numeric(25,10),
ema_vwap9 numeric(25,10),
ema_vwap10_y numeric(25,10),
ema_vwap10 numeric(25,10),
ema_vwap12_y numeric(25,10),
ema_vwap12 numeric(25,10),
ema_vwap15_y numeric(25,10),
ema_vwap15 numeric(25,10),
ema_vwap19_y numeric(25,10),
ema_vwap19 numeric(25,10),
ema_vwap20_y numeric(25,10),
ema_vwap20 numeric(25,10),
ema_vwap26_y numeric(25,10),
ema_vwap26 numeric(25,10),
ema_vwap30_y numeric(25,10),
ema_vwap30 numeric(25,10),
ema_vwap39_y numeric(25,10),
ema_vwap39 numeric(25,10),
ema_vwap50_y numeric(25,10),
ema_vwap50 numeric(25,10),
ema_vwap200_y numeric(25,10),
ema_vwap200 numeric(25,10),
constraint stag_ed_avg_pkey primary key (trading_date, stock_num)
);

-- insert the first day data for the fresh 
insert into staging.exchange_daily_avg (trading_date, stock_code, stock_name, stock_num, closing, vwap, factor, adj_closing, adj_vwap, sma5, sma6, sma9, sma10, sma12, sma15, sma19, sma20, sma26, sma30, sma39, sma50, sma200, 
sma_vwap5, sma_vwap6, sma_vwap9, sma_vwap10, sma_vwap12, sma_vwap15, sma_vwap19, sma_vwap20, sma_vwap26, sma_vwap30, sma_vwap39, sma_vwap50, sma_vwap200, 
ema5_y, ema5, ema6_y, ema6, ema9_y, ema9, ema10_y, ema10, ema12_y, ema12, ema15_y, ema15, ema19_y, ema19, ema20_y, ema20, ema26_y, ema26, ema30_y, ema30, ema39_y, ema39, ema50_y, ema50, ema200_y, ema200,
ema_vwap5_y, ema_vwap5, ema_vwap6_y, ema_vwap6, ema_vwap9_y, ema_vwap9, ema_vwap10_y, ema_vwap10, ema_vwap12_y, ema_vwap12, ema_vwap15_y, ema_vwap15, ema_vwap19_y, ema_vwap19, ema_vwap20_y, ema_vwap20, 
ema_vwap26_y, ema_vwap26, ema_vwap30_y, ema_vwap30, ema_vwap39_y, ema_vwap39, ema_vwap50_y, ema_vwap50, ema_vwap200_y, ema_vwap200)
select transaction_date, stock_code, stock_name_short, stock_num, closing_price, vwap, factor, adj_closing, vwap * factor, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
from dibots_v2.exchange_daily_transaction 
where transaction_date = '2015-01-02';


-- TRANSIT table for exchange_daily_avg for SMAs

create table staging.daily_smax (
trading_date date,
stock_num int,
sma5 numeric(25,10),
sma6 numeric(25,10),
sma9 numeric(25,10),
sma10 numeric(25,10),
sma12 numeric(25,10),
sma15 numeric(25,10),
sma19 numeric(25,10),
sma20 numeric(25,10),
sma26 numeric(25,10),
sma30 numeric(25,10),
sma39 numeric(25,10),
sma50 numeric(25,10),
sma200 numeric(25,10),
sma_vwap5 numeric(25,10),
sma_vwap6 numeric(25,10),
sma_vwap9 numeric(25,10),
sma_vwap10 numeric(25,10),
sma_vwap12 numeric(25,10),
sma_vwap15 numeric(25,10),
sma_vwap19 numeric(25,10),
sma_vwap20 numeric(25,10),
sma_vwap26 numeric(25,10),
sma_vwap30 numeric(25,10),
sma_vwap39 numeric(25,10),
sma_vwap50 numeric(25,10),
sma_vwap200 numeric(25,10),
constraint stag_daily_smax_pkey primary key (trading_date, stock_num)
);


create table staging.daily_emax (
trading_date date,
stock_num int,
ema5_y numeric(25,10),
ema5 numeric(25,10),
ema6_y numeric(25,10),
ema6 numeric(25,10),
ema9_y numeric(25,10),
ema9 numeric(25,10),
ema10_y numeric(25,10),
ema10 numeric(25,10),
ema12_y numeric(25,10),
ema12 numeric(25,10),
ema15_y numeric(25,10),
ema15 numeric(25,10),
ema19_y numeric(25,10),
ema19 numeric(25,10),
ema20_y numeric(25,10),
ema20 numeric(25,10),
ema26_y numeric(25,10),
ema26 numeric(25,10),
ema30_y numeric(25,10),
ema30 numeric(25,10),
ema39_y numeric(25,10),
ema39 numeric(25,10),
ema50_y numeric(25,10),
ema50 numeric(25,10),
ema200_y numeric(25,10),
ema200 numeric(25,10),
ema_vwap5_y numeric(25,10),
ema_vwap5 numeric(25,10),
ema_vwap6_y numeric(25,10),
ema_vwap6 numeric(25,10),
ema_vwap9_y numeric(25,10),
ema_vwap9 numeric(25,10),
ema_vwap10_y numeric(25,10),
ema_vwap10 numeric(25,10),
ema_vwap12_y numeric(25,10),
ema_vwap12 numeric(25,10),
ema_vwap15_y numeric(25,10),
ema_vwap15 numeric(25,10),
ema_vwap19_y numeric(25,10),
ema_vwap19 numeric(25,10),
ema_vwap20_y numeric(25,10),
ema_vwap20 numeric(25,10),
ema_vwap26_y numeric(25,10),
ema_vwap26 numeric(25,10),
ema_vwap30_y numeric(25,10),
ema_vwap30 numeric(25,10),
ema_vwap39_y numeric(25,10),
ema_vwap39 numeric(25,10),
ema_vwap50_y numeric(25,10),
ema_vwap50 numeric(25,10),
ema_vwap200_y numeric(25,10),
ema_vwap200 numeric(25,10),
constraint stag_daily_emax_pkey primary key (trading_date, stock_num)
);

-- verification

select a.trading_date, a.stock_num, a.adj_closing, a.sma5, a.sma6, a.sma9, a.sma10, a.sma12, a.sma15, a.sma19, a.sma20, a.sma26, a.sma30, a.sma39, a.sma50, a.sma200 
from dibots_v2.exchange_daily_avg a where a.trading_date <= '2021-11-19' and a.stock_num = 8084 order by a.trading_date desc

select sum(adj_closing)/5 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_closing)/6 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 6) a

select sum(adj_closing)/9 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 9) a

select sum(adj_closing)/10 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 10) a

select sum(adj_closing)/12 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 12) a

select sum(adj_closing)/15 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 15) a

select sum(adj_closing)/19 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 19) a

select sum(adj_closing)/20 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 20) a

select sum(adj_closing)/26 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 26) a

select sum(adj_closing)/30 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 30) a

select sum(adj_closing)/39 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 39) a

select sum(adj_closing)/50 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 50) a

select sum(adj_closing)/200 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 200) a

select a.trading_date, a.stock_num, a.adj_closing, a.sma_vwap5, a.sma_vwap6, a.sma_vwap9, a.sma_vwap10, a.sma_vwap12, a.sma_vwap15, a.sma_vwap19, a.sma_vwap20, a.sma_vwap26, a.sma_vwap30, a.sma_vwap39, a.sma_vwap50, a.sma_vwap200 
from dibots_v2.exchange_daily_avg a where a.trading_date <= '2021-11-19' and a.stock_num = 8084 order by a.trading_date desc

select sum(adj_vwap)/5 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_vwap)/6 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 6) a

select sum(adj_vwap)/9 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 9) a

select sum(adj_vwap)/10 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 10) a

select sum(adj_vwap)/12 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 12) a

select sum(adj_vwap)/15 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 15) a

select sum(adj_vwap)/19 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 19) a

select sum(adj_vwap)/20 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 20) a

select sum(adj_vwap)/26 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 26) a

select sum(adj_vwap)/30 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 30) a

select sum(adj_vwap)/39 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 39) a

select sum(adj_vwap)/50 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 50) a

select sum(adj_vwap)/200 from (
select * from dibots_v2.exchange_daily_avg where trading_date <= '2021-11-19' and stock_num = 8084 order by trading_date desc limit 200) a

--==========================
-- EXCHANGE_STOCK_MACD
--==========================

create table dibots_v2.exchange_stock_macd (
trading_date date,
stock_code varchar(10),
stock_num int,
stock_name varchar(50),
ema12 numeric(25,10),
ema26 numeric(25,10),
macd numeric(25,10),
sma_macd numeric(25,10),
signal_y numeric(25,10),
signal numeric(25,10),
diff numeric(25,10),
bull_bear_int int,
macd_signal_cross int,
zero_line_cross int,
constraint stock_macd_pkey primary key (trading_date, stock_num)
);
create index stock_macd_uniq on dibots_v2.exchange_stock_macd (trading_date, stock_code);

-- bull_bear_int: bull => 1 bear => -1, if diff > 0 bull else bear
-- macd_signal_cross: today bull_bear_int - yesterday bull_bear_int, if +ve bullish crossover (1), if -ve bearish crossover (-1), if 0 no change (0)
-- zero_line_cross: if y_macd is -ve and macd is +ve then positive (1), if y_macd is +ve and macd is -ve then negative (-1) else 0
insert into dibots_v2.exchange_stock_macd (trading_date, stock_code, stock_num, stock_name, ema12, ema26, macd)
select trading_date, stock_code, stock_num, stock_name, coalesce(ema12,0), coalesce(ema26,0), 
case when coalesce(ema26,0) = 0 then 0
else coalesce(ema12,0)-coalesce(ema26,0) end from dibots_v2.exchange_daily_avg where trading_date = '2015-01-02';

update dibots_v2.exchange_stock_macd
set
ema12 = 0
where ema12 is null;

update dibots_v2.exchange_stock_macd
set
ema26 = 0
where ema26 is null;

update dibots_v2.exchange_stock_macd
set
macd = 0
where macd is null;


-- STOCK_MACD_TRANSIT
create table staging.stock_macdx (
trading_date date,
stock_num int,
sma_macd numeric(25,10),
signal_y numeric(25,10),
signal numeric(25,10),
diff numeric(25,10),
bull_bear_int int,
macd_signal_cross int,
zero_line_cross int,
constraint stock_macdx_pkey primary key (trading_date, stock_num)
);

-- verification
select trading_date, stock_num, macd/5.28725 as macd, signal/5.28725 as signal, macd/5.28725 - signal/5.28725 as diff, bull_bear_int, macd_signal_cross, zero_line_cross 
from dibots_v2.exchange_stock_macd where trading_date between '2021-06-01' and '2021-11-10' and stock_num = 596
order by trading_date asc

--============================
-- EXCHANGE_STOCK_MACD_SHORT
--============================

create table dibots_v2.exchange_stock_macd_short (
trading_date date,
stock_code varchar(10),
stock_num int,
stock_name varchar(50),
ema6 numeric(25,10),
ema19 numeric(25,10),
macd numeric(25,10),
sma_macd numeric(25,10),
signal_y numeric(25,10),
signal numeric(25,10),
diff numeric(25,10),
bull_bear_int int,
macd_signal_cross int,
zero_line_cross int,
constraint stock_macd_short_pkey primary key (trading_date, stock_num)
);
create index stock_macd_short_uniq on dibots_v2.exchange_stock_macd_short (trading_date, stock_code);

-- bull_bear_int: bull => 1 bear => -1, if diff > 0 bull else bear
-- macd_signal_cross: today bull_bear_int - yesterday bull_bear_int, if +ve bullish crossover (1), if -ve bearish crossover (-1), if 0 no change (0)
-- zero_line_cross: if y_macd is -ve and macd is +ve then positive (1), if y_macd is +ve and macd is -ve then negative (-1) else 0
insert into dibots_v2.exchange_stock_macd_short (trading_date, stock_code, stock_num, stock_name, ema6, ema19, macd)
select trading_date, stock_code, stock_num, stock_name, coalesce(ema6,0), coalesce(ema19,0), 
case when coalesce(ema19,0) = 0 then 0
else coalesce(ema6,0)-coalesce(ema19,0) end from dibots_v2.exchange_daily_avg where trading_date = '2015-01-02';

update dibots_v2.exchange_stock_macd_short
set
ema6 = 0
where ema6 is null;

update dibots_v2.exchange_stock_macd_short
set
ema19 = 0
where ema19 is null;

update dibots_v2.exchange_stock_macd_short
set
macd = 0
where macd is null;

-- STOCK_MACD_SHORT_TRANSIT
create table staging.stock_macd_shortx (
trading_date date,
stock_num int,
sma_macd numeric(25,10),
signal_y numeric(25,10),
signal numeric(25,10),
diff numeric(25,10),
bull_bear_int int,
macd_signal_cross int,
zero_line_cross int,
constraint stock_macd_shortx_pkey primary key (trading_date, stock_num)
);


--==========================
-- EXCHANGE_STOCK_MACD_LONG
--==========================

create table dibots_v2.exchange_stock_macd_long (
trading_date date,
stock_code varchar(10),
stock_num int,
stock_name varchar(50),
ema19 numeric(25,10),
ema39 numeric(25,10),
macd numeric(25,10),
sma_macd numeric(25,10),
signal_y numeric(25,10),
signal numeric(25,10),
diff numeric(25,10),
bull_bear_int int,
macd_signal_cross int,
zero_line_cross int,
constraint stock_macd_long_pkey primary key (trading_date, stock_num)
);
create index stock_macd_long_uniq on dibots_v2.exchange_stock_macd_long (trading_date, stock_code);

-- bull_bear_int: bull => 1 bear => -1, if diff > 0 bull else bear
-- macd_signal_cross: today bull_bear_int - yesterday bull_bear_int, if +ve bullish crossover (1), if -ve bearish crossover (-1), if 0 no change (0)
-- zero_line_cross: if y_macd is -ve and macd is +ve then positive (1), if y_macd is +ve and macd is -ve then negative (-1) else 0
insert into dibots_v2.exchange_stock_macd_long (trading_date, stock_code, stock_num, stock_name, ema19, ema39, macd)
select trading_date, stock_code, stock_num, stock_name, coalesce(ema19,0), coalesce(ema39,0), 
case when coalesce(ema39,0) = 0 then 0
else coalesce(ema19,0)-coalesce(ema39,0) end from dibots_v2.exchange_daily_avg where trading_date = '2015-01-02';

update dibots_v2.exchange_stock_macd_long
set
ema19 = 0
where ema19 is null;

update dibots_v2.exchange_stock_macd_long
set
ema39 = 0
where ema39 is null;

update dibots_v2.exchange_stock_macd_long
set
macd = 0
where macd is null;


-- STOCK_MACD_LONG_TRANSIT
create table staging.stock_macd_longx (
trading_date date,
stock_num int,
sma_macd numeric(25,10),
signal_y numeric(25,10),
signal numeric(25,10),
diff numeric(25,10),
bull_bear_int int,
macd_signal_cross int,
zero_line_cross int,
constraint stock_macd_longx_pkey primary key (trading_date, stock_num)
);

--=============================
-- EXCHANGE_DAILY_SECTOR_INDEX
--============================
-- the FBMT100 index need to be updated daily from dibots_v2.bursa_securities_index

-- just get the closing
insert into dibots_v2.exchange_daily_sector_index (transaction_date, sector, close, week_count, year, month)
select current_date as transaction_date, index_name, index_volume, to_char(current_date,'IYYY-IW') as week_count, 
extract(year from current_date)::int as year, extract(month from current_date)::int as month
from dibots_v2.bursa_securities_index where index_name = 'FBMT100' and crawled_date = (
select max(crawled_date) from dibots_v2.bursa_securities_index where index_name = 'FBMT100' and crawled_date::date = current_date)


--===============================
-- EXCHANGE_WEEKLY_SECTOR_INDEX
--===============================
-- derived from exchange_daily_sector_index

drop table dibots_v2.exchange_weekly_sector_index;
create table dibots_v2.exchange_weekly_sector_index (
week_count varchar(10),
min_trading_date date,
max_trading_date date,
sector varchar(100),
close numeric(25,6)
);

alter table dibots_v2.exchange_weekly_sector_index add constraint exchg_weekly_sector_index_pkey primary key (week_count, sector);

-- INITIAL INSERT
insert into dibots_v2.exchange_weekly_sector_index (week_count, sector, close)
select week_count, sector, close from dibots_v2.exchange_daily_sector_index
where transaction_date in (
select max(transaction_date) as max_date from dibots_v2.exchange_daily_sector_index 
group by week_count order by week_count)

update dibots_v2.exchange_weekly_sector_index a
set
min_trading_date = b.min,
max_trading_date = b.max
from
(select week_count, sector, min(transaction_date) as min, max(transaction_date) as max from dibots_v2.exchange_daily_sector_index
group by week_count, sector order by week_count asc) b
where a.week_count = b.week_count and a.sector = b.sector

select * from dibots_v2.exchange_weekly_sector_index where sector = 'FBMT100' order by week_count desc;

-- INCREMENTAL
insert into dibots_v2.exchange_weekly_sector_index (week_count, close)
select week_count, sector, close from dibots_v2.exchange_daily_sector_index
where transaction_date  in (
select max(transaction_date) from dibots_v2.exchange_daily_sector_index where transaction_date >= '?'
group by week_count);

update dibots_v2.exchange_weekly_sector_index a
set
min_trading_date = b.min,
max_trading_date = b.max
from
(select week_count, sector, min(transaction_date) as min, max(transaction_date) as max from dibots_v2.exchange_daily_sector_index
where transaction_date >= '?'
group by week_count, sector order by week_count asc) b
where a.week_count = b.week_count and a.sector = b.sector;


--==============================
-- EXCHANGE_WEEKLY_TRANSACTION
--==============================
-- factor would be the factor of the last day of the week

DROP TABLE dibots_v2.exchange_weekly_transaction;
CREATE TABLE dibots_v2.exchange_weekly_transaction (
   week_count varchar(10),
   min_trading_date date,
   max_trading_date date,
   stock_code varchar(10) NOT NULL,
   stock_name varchar(100),
   stock_num int,
   board varchar(100),
   sector varchar(100),
   sub_sector varchar(100),
   klci_flag bool DEFAULT false,
   fbm100_flag bool DEFAULT false,
   shariah_flag bool DEFAULT false,
   esg_flag bool default false,
   esg_rating int,
   security_type varchar(100),
   currency varchar(5),
   opening numeric(25,3),
   high numeric(25,3),
   low numeric(25,3),
   closing numeric(25,3),
   vwap numeric(25,3),
   factor numeric(25,6),
   adj_opening numeric(25,3),
   adj_high numeric(25,3),
   adj_low numeric(25,3),
   adj_closing numeric(25,3),
   adj_vwap numeric(25,3),
   volume_omt bigint,
   value_omt numeric(25,3),
   volume_dbt bigint,
   value_dbt numeric(25,3)
);

alter table dibots_v2.exchange_weekly_transaction add constraint exchg_weekly_trans_pkey primary key (week_count, stock_code);
create index exchg_weekly_trans_min_trd_date_idx on dibots_v2.exchange_weekly_transaction (min_trading_date);
create index exchg_weekly_trans_max_trd_date_idx on dibots_v2.exchange_weekly_transaction (max_trading_date);
create index exchg_weekly_trans_stock_idx on dibots_v2.exchange_weekly_transaction (stock_code);

-- INITITAL INSERTION
insert into dibots_v2.exchange_weekly_transaction (week_count, stock_code)
select distinct week_count, stock_code
from dibots_v2.exchange_daily_transaction;

-- UPDATES THE COLUMNS
update dibots_v2.exchange_weekly_transaction a
set
min_trading_date = b.min_trd_date,
max_trading_date = b.max_trd_date
from (
select week_count, stock_code, min(transaction_date) as min_trd_date, max(transaction_date) as max_trd_date
from dibots_v2.exchange_daily_transaction
group by week_count, stock_code) b
where a.week_count = b.week_count and a.stock_code = b.stock_code;

update dibots_v2.exchange_weekly_transaction a
set
stock_name = b.stock_name_short,
board = b.board,
sector = b.sector,
sub_sector = b.sub_sector,
klci_flag = b.klci_flag,
fbm100_flag = b.fbm100_flag,
shariah_flag = b.shariah_flag,
esg_flag = b.esg_flag,
esg_rating = b.esg_rating,
security_type = b.security_type,
currency = b.currency,
closing = b.closing_price,
adj_closing = b.adj_closing,
vwap = b.vwap,
factor = b.factor
from dibots_v2.exchange_daily_transaction b
where a.max_trading_date = b.transaction_date and a.stock_code = b.stock_code;

-- opening
update dibots_v2.exchange_weekly_transaction a
set
opening = b.opening_price
from dibots_v2.exchange_daily_transaction b
where a.min_trading_date = b.transaction_date and a.stock_code = b.stock_code;

-- high and low
update dibots_v2.exchange_weekly_transaction a
set
high = b.high,
low = b.low
from (
select week_count, stock_code, max(high_price) as high, min(low_price) as low from dibots_v2.exchange_daily_transaction
group by week_count, stock_code) b
where a.week_count = b.week_count and a.stock_code = b.stock_code;

-- adj columns
update dibots_v2.exchange_weekly_transaction a
set
adj_opening = opening * factor,
adj_high = high * factor,
adj_low = low * factor,
adj_vwap = vwap * factor
where adj_opening is null;

-- val vol columns
update dibots_v2.exchange_weekly_transaction a
set
volume_omt = b.vol_omt,
value_omt = b.val_omt,
volume_dbt = b.vol_dbt,
value_dbt = b.val_dbt
from (
select week_count, stock_code, sum(volume_traded_market_transaction) as vol_omt, sum(value_traded_market_transaction) as val_omt, sum(volume_traded_direct_business) as vol_dbt,
sum(value_traded_direct_business) as val_dbt
from dibots_v2.exchange_daily_transaction
group by week_count, stock_code) b
where a.week_count = b.week_count and a.stock_code = b.stock_code;

select * from dibots_v2.exchange_weekly_transaction order by week_count desc;
