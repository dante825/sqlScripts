--====================
-- EXCHANGE_LOCAL_MA
--====================
create table dibots_v2.exchange_local_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_ma_pkey primary key (trading_date, stock_num)
);

create unique index exchg_local_ma_uniq on dibots_v2.exchange_local_ma (trading_date, stock_code);
create index exchg_local_ma_stock_num_idx on dibots_v2.exchange_local_ma (stock_num);
create index exchg_local_ma_stock_idx on dibots_v2.exchange_local_ma (stock_code);

select * from dibots_v2.exchange_local_ma --where volume is not null;

insert into dibots_v2.exchange_local_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_local_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_local_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_local_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_local_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_local_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- LOCAL TRANSIT
--==========================
create table staging.local_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint local_smax_pkey primary key (trading_date, stock_num)
);

create table staging.local_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_emax_pkey primary key (trading_date, stock_num)
);

-- verification

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_ma where trading_date >= '2021-11-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2021-11-01' and locality = 'LOCAL'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_local_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

--====================
-- EXCHANGE_FOREIGN_MA
--====================
create table dibots_v2.exchange_foreign_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint foreign_ma_pkey primary key (trading_date, stock_num)
);

create unique index exchg_foreign_ma_uniq on dibots_v2.exchange_foreign_ma (trading_date, stock_code);
create index exchg_foreign_ma_stock_num_idx on dibots_v2.exchange_foreign_ma (stock_num);
create index exchg_foreign_ma_stock_idx on dibots_v2.exchange_foreign_ma (stock_code);

select * from dibots_v2.exchange_foreign_ma --where volume is not null;

insert into dibots_v2.exchange_foreign_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_foreign_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'FOREIGN'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_foreign_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_foreign_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_foreign_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_foreign_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- FOREIGN TRANSIT
--==========================
create table staging.foreign_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint foreign_smax_pkey primary key (trading_date, stock_num)
);

create table staging.foreign_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint foreign_emax_pkey primary key (trading_date, stock_num)
);

-- verification

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_foreign_ma where trading_date >= '2021-11-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2021-11-01' and locality = 'FOREIGN'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_foreign_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

--========================
-- EXCHANGE_LOCAL_INST_MA
--========================
drop table dibots_v2.exchange_local_inst_ma;
create table dibots_v2.exchange_local_inst_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_inst_ma_pkey primary key (trading_date, stock_num)
);

create unique index exchg_local_inst_ma_uniq on dibots_v2.exchange_local_inst_ma (trading_date, stock_code);
create index exchg_local_inst_ma_stock_num_idx on dibots_v2.exchange_local_inst_ma (stock_num);
create index exchg_local_inst_ma_stock_idx on dibots_v2.exchange_local_inst_ma (stock_code);

select * from dibots_v2.exchange_local_inst_ma --where volume is not null;

insert into dibots_v2.exchange_local_inst_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_local_inst_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL' and group_type = 'INSTITUTIONAL'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_local_inst_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_local_inst_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_local_inst_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_local_inst_ma
set
avg_price = 0 
where avg_price is null;

update dibots_v2.exchange_local_inst_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;

--==========================
-- LOCAL INST TRANSIT
--==========================
drop table staging.local_inst_smax;
create table staging.local_inst_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint local_inst_smax_pkey primary key (trading_date, stock_num)
);

create table staging.local_inst_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_inst_emax_pkey primary key (trading_date, stock_num)
);

-- GET SMA in 1 query
-- sma_vol
select stock_code, vol/count from (
select stock_code, sum(volume) as vol, count(*) as count from (
select row_number() over (partition by stock_code order by trading_date desc) as row_num, trading_date, stock_code, volume
from dibots_v2.exchange_local_inst_ma where trading_date <= '2017-05-09'
) a
where a.row_num <= 5
group by stock_code) b where count = 5

-- sma_buy
select stock_code, buy/count from (
select stock_code, sum(adj_buy) as buy, count(*) as count from (
select row_number() over (partition by stock_code order by trading_date desc) as row_num, trading_date, stock_code, adj_buy
from dibots_v2.exchange_local_inst_ma where trading_date <= '2017-05-16' and adj_buy <> 0
) a
where a.row_num <= 5
group by stock_code order by stock_code asc) b where count = 5

-- sma_sell
select stock_code, sell/count from (
select stock_code, sum(adj_sell) as sell, count(*) as count from (
select row_number() over (partition by stock_code order by trading_date desc) as row_num, trading_date, stock_code, adj_sell
from dibots_v2.exchange_local_inst_ma where trading_date <= '2017-05-09' and adj_sell <> 0
) a
where a.row_num <= 5
group by stock_code) b where count = 5

select * from dibots_v2.exchange_local_inst_ma where sma_vol5 is not null

SELECT * from dibots_v2.exchange_local_inst_ma where stock_code = '0001' order by trading_date asc


update dibots_v2.exchange_local_inst_ma
set
sma_vol5 = null,
sma_buy5 = null,
sma_sell5 = null

-- verification

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_inst_ma) a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_local_inst_ma where trading_date <= '2021-11-05' and stock_num = 8084 order by trading_date desc limit 200) a

--==========================
-- EXCHANGE_LOCAL_RETAIL_MA
--==========================
create table dibots_v2.exchange_local_retail_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_retail_ma_pkey primary key (trading_date, stock_num)
);

create unique index exchg_local_retail_ma_uniq on dibots_v2.exchange_local_retail_ma (trading_date, stock_code);
create index exchg_local_retail_ma_stock_num_idx on dibots_v2.exchange_local_retail_ma (stock_num);
create index exchg_local_retail_ma_stock_idx on dibots_v2.exchange_local_retail_ma (stock_code);

select * from dibots_v2.exchange_local_retail_ma where volume is not null;

insert into dibots_v2.exchange_local_retail_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_local_retail_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL' and group_type = 'RETAIL'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_local_retail_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_local_retail_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_local_retail_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_local_retail_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- LOCAL RETAIL TRANSIT
--==========================
create table staging.local_retail_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint local_retail_smax_pkey primary key (trading_date, stock_num)
);

create table staging.local_retail_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_retail_emax_pkey primary key (trading_date, stock_num)
);

select * from staging.local_retail_emax;

-- verification
select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_retail_ma) a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108  order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_local_retail_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

--==========================
-- EXCHANGE_LOCAL_NOMINEES_MA
--==========================
create table dibots_v2.exchange_local_nominees_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_nominees_ma_pkey primary key (trading_date, stock_num)
);
create unique index exchg_local_nominees_ma_uniq on dibots_v2.exchange_local_nominees_ma (trading_date, stock_code);
create index exchg_local_nominees_ma_stock_num_idx on dibots_v2.exchange_local_nominees_ma (stock_num);
create index exchg_local_nominees_ma_stock_idx on dibots_v2.exchange_local_nominees_ma (stock_code);

select * from dibots_v2.exchange_local_nominees_ma where volume is not null;

insert into dibots_v2.exchange_local_nominees_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_local_nominees_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL' and group_type = 'NOMINEES'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_local_nominees_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_local_nominees_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_local_nominees_ma
set
avg_price = 0
where avg_price is null;

update dibots_v2.exchange_local_nominees_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_local_nominees_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- LOCAL NOMINEES TRANSIT
--==========================
create table staging.local_nominees_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint local_nominees_smax_pkey primary key (trading_date, stock_num)
);

select * from staging.local_nominees_smax;

create table staging.local_nominees_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_nominees_emax_pkey primary key (trading_date, stock_num)
);

select * from staging.local_nominees_emax;

-- verification

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_nominees_ma) a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL' and group_type = 'NOMINEES'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_local_nominees_ma where trading_date <= '2021-11-09' and stock_num = 596 order by trading_date desc limit 200) a

--==========================
-- EXCHANGE_LOCAL_INST_NOM_MA
--==========================
create table dibots_v2.exchange_local_inst_nom_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_inst_nom_ma_pkey primary key (trading_date, stock_num)
);
create unique index exchg_local_inst_nom_ma_uniq on dibots_v2.exchange_local_inst_nom_ma (trading_date, stock_code);
create index exchg_local_inst_nom_ma_stock_num_idx on dibots_v2.exchange_local_inst_nom_ma (stock_num);
create index exchg_local_inst_nom_ma_stock_idx on dibots_v2.exchange_local_inst_nom_ma (stock_code);

select * from dibots_v2.exchange_local_inst_nom_ma where volume is not null;

insert into dibots_v2.exchange_local_inst_nom_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_local_inst_nom_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL' and group_type in ('INSTITUTIONAL', 'NOMINEES')
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_local_inst_nom_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_local_inst_nom_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_local_inst_nom_ma
set
avg_price = 0
where avg_price is null;

update dibots_v2.exchange_local_inst_nom_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_local_inst_nom_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- LOCAL INST NOM TRANSIT
--==========================
create table staging.local_inst_nom_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint local_inst_nom_smax_pkey primary key (trading_date, stock_num)
);

select * from staging.local_inst_nom_smax;

create table staging.local_inst_nom_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint local_inst_nom_emax_pkey primary key (trading_date, stock_num)
);

select * from staging.local_inst_nom_emax;

-- verification
select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_inst_nom_ma) a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where locality = 'LOCAL' and group_type in ('INSTITUTIONAL', 'NOMINEES')
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108  order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_local_inst_nom_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

--====================
-- FOREIGN_INST_MA
--====================
create table dibots_v2.exchange_foreign_inst_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint foreign_inst_ma_pkey primary key (trading_date, stock_num)
);

create unique index exchg_foreign_inst_ma_uniq on dibots_v2.exchange_foreign_inst_ma (trading_date, stock_code);
create index exchg_foreign_inst_ma_stock_num_idx on dibots_v2.exchange_foreign_inst_ma (stock_num);
create index exchg_foreign_inst_ma_stock_idx on dibots_v2.exchange_foreign_inst_ma (stock_code);

select * from dibots_v2.exchange_foreign_inst_ma --where volume is not null;

insert into dibots_v2.exchange_foreign_inst_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_foreign_inst_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'FOREIGN' and group_type = 'INSTITUTIONAL'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_foreign_inst_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_foreign_inst_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_foreign_inst_ma
set
avg_price = 0
where avg_price is null;

update dibots_v2.exchange_foreign_inst_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_foreign_inst_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- FOREIGN INST TRANSIT
--==========================
create table staging.foreign_inst_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint foreign_inst_smax_pkey primary key (trading_date, stock_num)
);

create table staging.foreign_inst_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint foreign_inst_emax_pkey primary key (trading_date, stock_num)
);

-- verification
select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_foreign_inst_ma) a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where locality = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108  order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_foreign_inst_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

--==========================
-- EXCHANGE_FOREIGN_INST_NOM_MA
--==========================
create table dibots_v2.exchange_foreign_inst_nom_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint foreign_inst_nom_ma_pkey primary key (trading_date, stock_num)
);
create unique index exchg_foreign_inst_nom_ma_uniq on dibots_v2.exchange_foreign_inst_nom_ma (trading_date, stock_code);
create index exchg_foreign_inst_nom_ma_stock_num_idx on dibots_v2.exchange_foreign_inst_nom_ma (stock_num);
create index exchg_foreign_inst_nom_ma_stock_idx on dibots_v2.exchange_foreign_inst_nom_ma (stock_code);

select * from dibots_v2.exchange_foreign_inst_nom_ma --where volume is not null;

insert into dibots_v2.exchange_foreign_inst_nom_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_foreign_inst_nom_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'FOREIGN' and group_type in ('INSTITUTIONAL', 'NOMINEES')
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_foreign_inst_nom_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_foreign_inst_nom_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_foreign_inst_nom_ma
set
avg_price = 0
where avg_price = null;

update dibots_v2.exchange_foreign_inst_nom_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_foreign_inst_nom_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- FOREIGN INST NOM TRANSIT
--==========================
create table staging.foreign_inst_nom_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint foreign_inst_nom_smax_pkey primary key (trading_date, stock_num)
);

select * from staging.foreign_inst_nom_smax;

create table staging.foreign_inst_nom_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint foreign_inst_nom_emax_pkey primary key (trading_date, stock_num)
);

select * from staging.foreign_inst_nom_emax;

-- verification

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_foreign_inst_nom_ma where trading_date >= '2021-11-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2021-11-01' and locality = 'FOREIGN' and group_type in ('INSTITUTIONAL', 'NOMINEES')
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108  order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 200) a

--====================
-- EXCHANGE_PROP_MA
--====================
create table dibots_v2.exchange_prop_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint prop_ma_pkey primary key (trading_date, stock_num)
);
create unique index exchg_prop_ma_uniq on dibots_v2.exchange_prop_ma (trading_date, stock_code);
create index exchg_prop_ma_stock_num_idx on dibots_v2.exchange_prop_ma (stock_num);
create index exchg_prop_ma_stock_idx on dibots_v2.exchange_prop_ma (stock_code);

select * from dibots_v2.exchange_prop_ma;

insert into dibots_v2.exchange_prop_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_prop_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where locality = 'PROPRIETARY'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_prop_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_prop_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_prop_ma
set
avg_price = 0
where avg_price is null;

update dibots_v2.exchange_prop_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_prop_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- PROP TRANSIT
--==========================
create table staging.prop_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint prop_smax_pkey primary key (trading_date, stock_num)
);

select * from staging.prop_smax;

create table staging.prop_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint prop_emax_pkey primary key (trading_date, stock_num)
);

-- verification

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_prop_ma where trading_date >= '2021-11-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2021-11-01' and locality = 'PROPRIETARY'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108  order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_prop_ma where trading_date <= '2021-11-12' and stock_num = 108 order by trading_date desc limit 200) a

--==========================
-- EXCHANGE_IVT_MA
--==========================
create table dibots_v2.exchange_ivt_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint ivt_ma_pkey primary key (trading_date, stock_num)
);
create unique index exchg_ivt_ma_uniq on dibots_v2.exchange_ivt_ma (trading_date, stock_code);
create index exchg_ivt_ma_stock_num_idx on dibots_v2.exchange_ivt_ma (stock_num);
create index exchg_ivt_ma_stock_idx on dibots_v2.exchange_ivt_ma (stock_code);

select * from dibots_v2.exchange_ivt_ma --where volume is not null;

insert into dibots_v2.exchange_ivt_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_ivt_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where group_type = 'IVT'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_ivt_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_ivt_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_ivt_ma
set
avg_price = 0
where avg_price is null;

update dibots_v2.exchange_ivt_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_ivt_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- IVT TRANSIT
--==========================
create table staging.ivt_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint ivt_smax_pkey primary key (trading_date, stock_num)
);

select * from staging.ivt_smax;

create table staging.ivt_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint ivt_emax_pkey primary key (trading_date, stock_num)
);

select * from staging.ivt_emax;

-- verification

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_ivt_ma where trading_date >= '2021-11-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2021-11-01' and group_type = 'IVT'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108  order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_ivt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

--==========================
-- EXCHANGE_PDT_MA
--==========================
create table dibots_v2.exchange_pdt_ma (
trading_date date,
stock_code varchar(10),
stock_name varchar(100),
stock_num int,
volume numeric(25,10),
buy_price numeric(25,10),
sell_price numeric(25,10),
avg_price numeric(25,10),
factor numeric(25,10),
adj_buy numeric(25,10),
adj_sell numeric(25,10),
adj_avg numeric(25,10),
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint pdt_ma_pkey primary key (trading_date, stock_num)
);
create unique index exchg_pdt_ma_uniq on dibots_v2.exchange_pdt_ma (trading_date, stock_code);
create index exchg_pdt_ma_stock_num_idx on dibots_v2.exchange_pdt_ma (stock_num);
create index exchg_pdt_ma_stock_idx on dibots_v2.exchange_pdt_ma (stock_code);

select * from dibots_v2.exchange_pdt_ma --where volume is not null;

insert into dibots_v2.exchange_pdt_ma (trading_date, stock_code, stock_name, stock_num, factor)
select transaction_date, stock_code, stock_name_short, stock_num, factor from dibots_v2.exchange_daily_transaction
where transaction_date = '2017-05-02';

-- volume is single sided, just get buy vol
update dibots_v2.exchange_pdt_ma a
set
volume = b.vol,
buy_price = b.avg_buy_price,
sell_price = b.avg_sell_price,
avg_price = b.avg_price
from
(select trading_date, stock_num, sum(coalesce(buy_volume,0)) as vol,
sum(coalesce(buy_value,0)) / cast(coalesce(nullif(sum(buy_volume),0),1) as numeric(25,5)) as avg_buy_price,
sum(coalesce(sell_value,0)) / cast(coalesce(nullif(sum(sell_volume),0),1) as numeric(25,5)) as avg_sell_price,
sum(coalesce(value,0)) / cast(coalesce(nullif(sum(volume),0),1) as numeric(25,5)) as avg_price
from dibots_v2.exchange_demography_stock_broker where group_type = 'PDT'
and trading_date = '2017-05-02'
group by trading_date, stock_num) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num;

update dibots_v2.exchange_pdt_ma
set
buy_price = 0
where buy_price is null;

update dibots_v2.exchange_pdt_ma
set
sell_price = 0
where sell_price is null;

update dibots_v2.exchange_pdt_ma
set
avg_price = 0
where avg_price is null;

update dibots_v2.exchange_pdt_ma
set
volume = 0
where volume is null;

update dibots_v2.exchange_pdt_ma
set
adj_buy = buy_price * factor,
adj_sell = sell_price * factor,
adj_avg = avg_price * factor;


--==========================
-- PDT TRANSIT
--==========================
create table staging.pdt_smax (
trading_date date,
stock_num int,
sma_vol5 numeric(25,10),
sma_vol9 numeric(25,10),
sma_vol10 numeric(25,10),
sma_vol12 numeric(25,10),
sma_vol15 numeric(25,10),
sma_vol20 numeric(25,10),
sma_vol26 numeric(25,10),
sma_vol30 numeric(25,10),
sma_vol50 numeric(25,10),
sma_vol200 numeric(25,10),
sma_buy5 numeric(25,10),
sma_buy9 numeric(25,10),
sma_buy10 numeric(25,10),
sma_buy12 numeric(25,10),
sma_buy15 numeric(25,10),
sma_buy20 numeric(25,10),
sma_buy26 numeric(25,10),
sma_buy30 numeric(25,10),
sma_buy50 numeric(25,10),
sma_buy200 numeric(25,10),
sma_sell5 numeric(25,10),
sma_sell9 numeric(25,10),
sma_sell10 numeric(25,10),
sma_sell12 numeric(25,10),
sma_sell15 numeric(25,10),
sma_sell20 numeric(25,10),
sma_sell26 numeric(25,10),
sma_sell30 numeric(25,10),
sma_sell50 numeric(25,10),
sma_sell200 numeric(25,10),
sma_avg5 numeric(25,10),
sma_avg9 numeric(25,10),
sma_avg10 numeric(25,10),
sma_avg12 numeric(25,10),
sma_avg15 numeric(25,10),
sma_avg20 numeric(25,10),
sma_avg26 numeric(25,10),
sma_avg30 numeric(25,10),
sma_avg50 numeric(25,10),
sma_avg200 numeric(25,10),
constraint pdt_smax_pkey primary key (trading_date, stock_num)
);

select * from staging.pdt_smax;

create table staging.pdt_emax (
trading_date date,
stock_num int,
ema_buy5_y numeric(25,10),
ema_buy5 numeric(25,10),
ema_buy9_y numeric(25,10),
ema_buy9 numeric(25,10),
ema_buy10_y numeric(25,10),
ema_buy10 numeric(25,10),
ema_buy12_y numeric(25,10),
ema_buy12 numeric(25,10),
ema_buy15_y numeric(25,10),
ema_buy15 numeric(25,10),
ema_buy20_y numeric(25,10),
ema_buy20 numeric(25,10),
ema_buy26_y numeric(25,10),
ema_buy26 numeric(25,10),
ema_buy30_y numeric(25,10),
ema_buy30 numeric(25,10),
ema_buy50_y numeric(25,10),
ema_buy50 numeric(25,10),
ema_buy200_y numeric(25,10),
ema_buy200 numeric(25,10),
ema_sell5_y numeric(25,10),
ema_sell5 numeric(25,10),
ema_sell9_y numeric(25,10),
ema_sell9 numeric(25,10),
ema_sell10_y numeric(25,10),
ema_sell10 numeric(25,10),
ema_sell12_y numeric(25,10),
ema_sell12 numeric(25,10),
ema_sell15_y numeric(25,10),
ema_sell15 numeric(25,10),
ema_sell20_y numeric(25,10),
ema_sell20 numeric(25,10),
ema_sell26_y numeric(25,10),
ema_sell26 numeric(25,10),
ema_sell30_y numeric(25,10),
ema_sell30 numeric(25,10),
ema_sell50_y numeric(25,10),
ema_sell50 numeric(25,10),
ema_sell200_y numeric(25,10),
ema_sell200 numeric(25,10),
ema_avg5_y numeric(25,10),
ema_avg5 numeric(25,10),
ema_avg9_y numeric(25,10),
ema_avg9 numeric(25,10),
ema_avg10_y numeric(25,10),
ema_avg10 numeric(25,10),
ema_avg12_y numeric(25,10),
ema_avg12 numeric(25,10),
ema_avg15_y numeric(25,10),
ema_avg15 numeric(25,10),
ema_avg20_y numeric(25,10),
ema_avg20 numeric(25,10),
ema_avg26_y numeric(25,10),
ema_avg26 numeric(25,10),
ema_avg30_y numeric(25,10),
ema_avg30 numeric(25,10),
ema_avg50_y numeric(25,10),
ema_avg50 numeric(25,10),
ema_avg200_y numeric(25,10),
ema_avg200 numeric(25,10),
constraint pdt_emax_pkey primary key (trading_date, stock_num)
);

select * from staging.pdt_emax;

-- verification

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_pdt_ma where trading_date >= '2021-11-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2021-11-01' and group_type = 'PDT'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select trading_date, stock_num, stock_code, volume, sma_vol5, sma_vol9, sma_vol10, sma_vol12, sma_vol15, sma_vol20, sma_vol26, sma_vol30, sma_vol50, sma_vol200
from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(volume)/5 from (
select * from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(volume)/200 from (
select * from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_buy, sma_buy5, sma_buy9, sma_buy10, sma_buy12, sma_buy15, sma_buy20, sma_buy26, sma_buy30, sma_buy50, sma_buy200
from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_buy)/5 from (
select * from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_buy)/200 from (
select * from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a

select trading_date, stock_code, adj_sell, sma_sell5, sma_sell9, sma_sell10, sma_sell12, sma_sell15, sma_sell20, sma_sell26, sma_sell30, sma_sell50, sma_sell200
from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_sell)/5 from (
select * from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_sell)/200 from (
select * from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108  order by trading_date desc limit 200) a

select trading_date, stock_code, adj_avg, sma_avg5, sma_avg9, sma_avg10, sma_avg12, sma_avg15, sma_avg20, sma_avg26, sma_avg30, sma_avg50, sma_avg200
from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc

select sum(adj_avg)/5 from (
select * from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 5) a

select sum(adj_avg)/200 from (
select * from dibots_v2.exchange_pdt_ma where trading_date <= '2021-11-09' and stock_num = 108 order by trading_date desc limit 200) a


--===================
-- CHECKING
--===================

select * from dibots_v2.exchange_local_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_ma);

select * from dibots_v2.exchange_foreign_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_ma);

select * from dibots_v2.exchange_local_inst_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_inst_ma);

select * from dibots_v2.exchange_local_retail_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_retail_ma);

select * from dibots_v2.exchange_local_nominees_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_nominees_ma);

select * from dibots_v2.exchange_local_inst_nom_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_inst_nom_ma);

select * from dibots_v2.exchange_foreign_inst_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_inst_ma);

select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_inst_nom_ma);

select * from dibots_v2.exchange_prop_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_prop_ma);

select * from dibots_v2.exchange_ivt_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_ivt_ma);

select * from dibots_v2.exchange_pdt_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_pdt_ma);

vacuum (analyze) dibots_v2.exchange_local_ma;
vacuum (analyze) dibots_v2.exchange_foreign_ma;
vacuum (analyze) dibots_v2.exchange_local_inst_ma;
vacuum (analyze) dibots_v2.exchange_local_retail_ma;
vacuum (analyze) dibots_v2.exchange_local_nominees_ma;
vacuum (analyze) dibots_v2.exchange_local_inst_nom_ma;
vacuum (analyze) dibots_v2.exchange_foreign_inst_ma;
vacuum (analyze) dibots_v2.exchange_foreign_inst_nom_ma;
vacuum (analyze) dibots_v2.exchange_prop_ma;
vacuum (analyze) dibots_v2.exchange_ivt_ma;
vacuum (analyze) dibots_v2.exchange_pdt_ma;

vacuum (analyze) staging.local_smax;
vacuum (analyze) staging.local_emax;
vacuum (analyze) staging.foreign_smax;
vacuum (analyze) staging.foreign_emax;
vacuum (analyze) staging.local_inst_smax;
vacuum (analyze) staging.local_inst_emax;
vacuum (analyze) staging.local_retail_smax;
vacuum (analyze) staging.local_retail_emax;
vacuum (analyze) staging.local_nominees_smax;
vacuum (analyze) staging.local_nominees_emax;
vacuum (analyze) staging.local_inst_nom_smax;
vacuum (analyze) staging.local_inst_nom_emax;
vacuum (analyze) staging.foreign_inst_smax;
vacuum (analyze) staging.foreign_inst_emax;
vacuum (analyze) staging.foreign_inst_nom_smax;
vacuum (analyze) staging.foreign_inst_nom_emax;
vacuum (analyze) staging.prop_smax;
vacuum (analyze) staging.prop_emax;
vacuum (analyze) staging.ivt_smax;
vacuum (analyze) staging.ivt_emax;
vacuum (analyze) staging.pdt_smax;
vacuum (analyze) staging.pdt_emax;
