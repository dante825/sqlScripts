
--=================================
-- exchange_net_short_pos_latest
--=================================
-- This table is similar to exchange_net_short_position table but it only keeps the latest information not historical

create table dibots_v2.exchange_net_short_pos_latest (
trading_date date,
stock_code varchar(10) primary key,
stock_name varchar(100),
net_short_position_vol bigint,
net_short_position_pct numeric(25,2)
);

insert into dibots_v2.exchange_net_short_pos_latest (stock_code)
select distinct(stock_code) from dibots_v2.exchange_net_short_position;

update dibots_v2.exchange_net_short_pos_latest net
set
trading_date = tmp.max_date
from (select max(a.trading_date) as max_date, a.stock_code from dibots_v2.exchange_net_short_position a
group by a.stock_code) tmp
where net.stock_code = tmp.stock_code;

update dibots_v2.exchange_net_short_pos_latest a
set
stock_name = b.stock_name,
net_short_position_vol = b.net_short_position_vol,
net_short_position_pct = b.net_short_position_pct
from dibots_v2.exchange_net_short_position b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code;


--=====================
--INCREMENTAL UPDATE
--=====================

-- 1. insert if possible
insert into dibots_v2.exchange_net_short_pos_latest (trading_date, stock_code, net_short_position_vol, net_short_position_pct)
select trading_date, stock_code, net_short_position_vol, net_short_position_pct
from dibots_v2.exchange_net_short_position where trading_date = (select max(trading_date) from dibots_v2.exchange_net_short_position)
ON CONFLICT DO NOTHING;

-- 2. update the latest value
update dibots_v2.exchange_net_short_pos_latest a
set
trading_date = b.trading_date,
stock_name = b.stock_name,
net_short_position_vol = b.net_short_position_vol,
net_short_position_pct = b.net_short_position_pct
from dibots_v2.exchange_net_short_position b
where b.trading_date = (select max(trading_date) from dibots_v2.exchange_net_short_position) and a.stock_code = b.stock_code;



--==================================================
--updating net short cols in exchange_short_selling
--==================================================

-- Using different tables can never resolve the sorting problem
-- therefore, add the column into exchange_short_selling and make it always up to date

update dibots_v2.exchange_short_selling a
set
net_short_date = b.trading_date,
net_short_position_vol = b.net_short_position_vol,
net_short_position_pct = b.net_short_position_pct
from dibots_v2.exchange_net_short_position b
where a.stock_code = b.stock_code and b.trading_date = (select max(trading_date) from dibots_v2.exchange_net_short_position)