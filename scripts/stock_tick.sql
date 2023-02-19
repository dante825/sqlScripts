--=================
-- stock_tick
--================
drop table if exists staging.stock_tick;
create table staging.stock_tick (
id int generated always as identity primary key,
trading_date date,
day_num int, 
trd_time_str text,
trd_time time,
trans_code int,
stock_code text,
stock_name text,
exchange text,
price numeric(25,3),
quantity int,
trd_val numeric(25,3)
);

select * from staging.stock_tick;

update staging.stock_tick
set
trading_date = '2021-06-28'
where trading_date is null;

update staging.stock_tick
set
trd_time = cast(regexp_replace(trd_time_str, '\.', ':', 'g') as time)
where trd_time is null;


--====================
-- stock_tick_summary
--====================

drop table if exists staging.stock_tick_summary;
create table staging.stock_tick_summary (
id int generated always as identity primary key,
trd_date date,
day_num int,
trd_hour int,
exchange text,
num_trade int,
num_stock int,
quantity int,
trd_val numeric(25,3)
);

select * from staging.stock_tick_summary;

update staging.stock_tick_summary
set
trd_date = '2021-06-28'
where trd_date is null;