-- To obtain the stocks that has change in the net value trend from NOV 2020 to DEC 2020

select stock_code, stock_name, sum(net_local_inst_val), sum(net_foreign_inst_val), sum(net_inst_value), sum(net_local_retail_val), sum(net_foreign_retail_val), sum(net_retail_value), sum(net_foreign_value)
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2020-11-01' and '2020-11-30'
group by stock_code, stock_name

-- Create the tmp tables and insert the values

drop table if exists tmp_exchange_net_nov2020;
create table tmp_exchange_net_nov2020 (
id serial primary key,
stock_code varchar(10),
stock_name varchar(100),
net_local_inst_val numeric(25,3),
net_foreign_inst_val numeric(25,3),
net_inst_val numeric(25,3),
net_local_retail_val numeric(25,3),
net_foreign_retail_val numeric(25,3),
net_retail_val numeric(25,3),
net_foreign_val numeric(25,3)
);

select * from tmp_exchange_net_nov2020;

insert into tmp_exchange_net_nov2020 (stock_code, stock_name, net_local_inst_val, net_foreign_inst_val, net_inst_val, net_local_retail_val, net_foreign_retail_val, net_retail_val, net_foreign_val)
select stock_code, stock_name, sum(net_local_inst_val), sum(net_foreign_inst_val), sum(net_inst_value), sum(net_local_retail_val), sum(net_foreign_retail_val), sum(net_retail_value), sum(net_foreign_value)
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2020-11-01' and '2020-11-30'
group by stock_code, stock_name

drop table if exists tmp_exchange_net_dec2020;
create table tmp_exchange_net_dec2020 (
id serial primary key,
stock_code varchar(10),
stock_name varchar(100),
net_local_inst_val numeric(25,3),
net_foreign_inst_val numeric(25,3),
net_inst_val numeric(25,3),
net_local_retail_val numeric(25,3),
net_foreign_retail_val numeric(25,3),
net_retail_val numeric(25,3),
net_foreign_val numeric(25,3)
);

select * from tmp_exchange_net_dec2020;

insert into tmp_exchange_net_dec2020 (stock_code, stock_name, net_local_inst_val, net_foreign_inst_val, net_inst_val, net_local_retail_val, net_foreign_retail_val, net_retail_val, net_foreign_val)
select stock_code, stock_name, sum(net_local_inst_val), sum(net_foreign_inst_val), sum(net_inst_value), sum(net_local_retail_val), sum(net_foreign_retail_val), sum(net_retail_value), sum(net_foreign_value)
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2020-12-01' and '2020-12-30'
group by stock_code, stock_name

-- to get the list of stocks that has this change between these 2 months

--============
-- local_inst
--=============

-- NOV net_sell DEC net_buy
select a.stock_code, a.stock_name, a.net_local_inst_val::numeric(25,0) as nov_net_local_inst_val, b.net_local_inst_val::numeric(25,0) as dec_net_local_inst_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_local_inst_val < 0 and b.net_local_inst_val > 0
order by b.net_local_inst_val desc limit 10;

-- NOV net_buy DEC net_sell
select a.stock_code, a.stock_name, a.net_local_inst_val::numeric(25,0) as nov_net_local_inst_val, b.net_local_inst_val::numeric(25,0) as dec_net_local_inst_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_local_inst_val > 0 and b.net_local_inst_val < 0
order by b.net_local_inst_val asc limit 10;

--===============
-- foreign_inst
--===============

-- NOV net_sell DEC net_buy
select a.stock_code, a.stock_name, a.net_foreign_inst_val::numeric(25,0) as nov_net_foreign_inst_val, b.net_foreign_inst_val::numeric(25,0) as dec_net_foreign_inst_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_foreign_inst_val < 0 and b.net_foreign_inst_val > 0
order by b.net_foreign_inst_val desc limit 10;

-- NOV net_buy DEC net_sell
select a.stock_code, a.stock_name, a.net_foreign_inst_val::numeric(25,0) as nov_net_foreign_inst_val, b.net_foreign_inst_val::numeric(25,0) as dec_net_foreign_inst_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_foreign_inst_val > 0 and b.net_foreign_inst_val < 0
order by b.net_foreign_inst_val asc limit 10;

--===============
-- inst
--===============

-- NOV net_sell DEC net_buy
select a.stock_code, a.stock_name, a.net_inst_val::numeric(25,0) as nov_net_inst_val, b.net_inst_val::numeric(25,0) as dec_net_inst_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_inst_val < 0 and b.net_inst_val > 0
order by b.net_inst_val desc limit 10;

-- NOV net_buy DEC net_sell
select a.stock_code, a.stock_name, a.net_inst_val::numeric(25,0) as nov_net_inst_val, b.net_inst_val::numeric(25,0) as dec_net_inst_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_inst_val > 0 and b.net_inst_val < 0
order by b.net_inst_val asc limit 10;

--===============
-- local_retail
--===============

-- NOV net_sell DEC net_buy
select a.stock_code, a.stock_name, a.net_local_retail_val::numeric(25,0) as nov_net_local_retail_val, b.net_local_retail_val::numeric(25,0) as dec_net_local_retail_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_local_retail_val < 0 and b.net_local_retail_val > 0
order by b.net_local_retail_val desc limit 10;

-- NOV net_buy DEC net_sell
select a.stock_code, a.stock_name, a.net_local_retail_val::numeric(25,0) as nov_net_local_retail_val, b.net_local_retail_val::numeric(25,0) as dec_net_local_retail_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_local_retail_val > 0 and b.net_local_retail_val < 0
order by b.net_local_retail_val asc limit 10;

--===============
-- foreign_retail
--===============

-- NOV net_sell DEC net_buy
select a.stock_code, a.stock_name, a.net_foreign_retail_val::numeric(25,0) as nov_net_foreign_retail_val, b.net_foreign_retail_val::numeric(25,0) as dec_net_foreign_retail_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_foreign_retail_val < 0 and b.net_foreign_retail_val > 0
order by b.net_foreign_retail_val desc limit 10;

-- NOV net_buy DEC net_sell
select a.stock_code, a.stock_name, a.net_foreign_retail_val::numeric(25,0) as nov_net_foreign_retail_val, b.net_foreign_retail_val::numeric(25,0) as dec_net_foreign_retail_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_foreign_retail_val > 0 and b.net_foreign_retail_val < 0
order by b.net_foreign_retail_val asc limit 10;

--===============
-- retail
--===============

-- NOV net_sell DEC net_buy
select a.stock_code, a.stock_name, a.net_retail_val::numeric(25,0) as nov_net_retail_val, b.net_retail_val::numeric(25,0) as dec_net_retail_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_retail_val < 0 and b.net_retail_val > 0
order by b.net_retail_val desc limit 10;

-- NOV net_buy DEC net_sell
select a.stock_code, a.stock_name, a.net_retail_val::numeric(25,0) as nov_net_retail_val, b.net_retail_val::numeric(25,0) as dec_net_retail_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_retail_val > 0 and b.net_retail_val < 0
order by b.net_retail_val asc limit 10;

--===============
-- foreign
--===============

-- NOV net_sell DEC net_buy
select a.stock_code, a.stock_name, a.net_foreign_val::numeric(25,0) as nov_net_foreign_val, b.net_foreign_val::numeric(25,0) as dec_net_foreign_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_foreign_val < 0 and b.net_foreign_val > 0
order by b.net_foreign_val desc limit 10;

-- NOV net_buy DEC net_sell
select a.stock_code, a.stock_name, a.net_foreign_val::numeric(25,0) as nov_net_foreign_val, b.net_foreign_val::numeric(25,0) as dec_net_foreign_val from tmp_exchange_net_nov2020 a, tmp_exchange_net_dec2020 b
where a.stock_code = b.stock_code and a.net_foreign_val > 0 and b.net_foreign_val < 0
order by b.net_foreign_val asc limit 10;