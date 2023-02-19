-- Data for Affin Hwang

-- trade origin for market
select extract(year from trading_date) as year, extract(month from trading_date) as month, trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-03-01' and '2021-12-31'
group by extract(year from trading_date), extract(month from trading_date), trade_origin, trade_origin_code
order by extract(year from trading_date) asc, extract(month from trading_date) asc, trade_origin asc

-- trade origin for AFFIN

select extract(year from trading_date) as year, extract(month from trading_date) as month, trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-03-01' and '2021-12-31' and broker_code = 68
group by extract(year from trading_date), extract(month from trading_date), trade_origin, trade_origin_code
order by extract(year from trading_date) asc, extract(month from trading_date) asc, trade_origin asc

-- trade origin for AFFIN with pct

select a.year, a.month, a.trade_origin, b.value, b.volume, (b.value/a.value*100)::numeric(25,2) as val_pct, (b.volume/a.volume*100)::numeric(25,2) as vol_pct from
(select extract(year from trading_date) as year, extract(month from trading_date) as month, trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-03-01' and '2021-12-31'
group by extract(year from trading_date), extract(month from trading_date), trade_origin, trade_origin_code
order by extract(year from trading_date) asc, extract(month from trading_date) asc, trade_origin asc) a
left join
(select extract(year from trading_date) as year, extract(month from trading_date) as month, trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-03-01' and '2021-12-31' and broker_code = 68
group by extract(year from trading_date), extract(month from trading_date), trade_origin, trade_origin_code
order by extract(year from trading_date) asc, extract(month from trading_date) asc, trade_origin asc) b
on a.year = b.year and a.month = b.month and a.trade_origin = b.trade_origin