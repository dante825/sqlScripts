-- Derived tables from exchange_contra_fund_flow

SELECT * from dibots_v2.exchange_contra_fund_flow where t0_date = '2021-09-01'

--==========================
-- EXCHANGE_CONTRA_FF_STOCK
--==========================

create table dibots_v2.exchange_contra_ff_stock (
t0_date date,
tminus1_date date,
tminus2_date date,
tminus3_date date,
tminus4_date date,
t0_week_count text,
stock_code text,
stock_name text,
stock_num int,
board text,
sector text,
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
f4gbm_flag bool default false,
t1_open_vol bigint,
t2_open_vol bigint,
t3_open_vol bigint,
t1_open_vol_next bigint,
t2_open_vol_next bigint,
t3_open_vol_next bigint,
t1_open_val numeric(25,3),
t2_open_val numeric(25,3),
t3_open_val numeric(25,3),
t1_open_val_next numeric(25,3),
t2_open_val_next numeric(25,3),
t3_open_val_next numeric(25,3),
local_t1_open_vol bigint,
local_t2_open_vol bigint,
local_t3_open_vol bigint,
local_t1_open_vol_next bigint,
local_t2_open_vol_next bigint,
local_t3_open_vol_next bigint,
local_t1_open_val numeric(25,3),
local_t2_open_val numeric(25,3),
local_t3_open_val numeric(25,3),
local_t1_open_val_next numeric(25,3),
local_t2_open_val_next numeric(25,3),
local_t3_open_val_next numeric(25,3),
foreign_t1_open_vol bigint,
foreign_t2_open_vol bigint,
foreign_t3_open_vol bigint,
foreign_t1_open_vol_next bigint,
foreign_t2_open_vol_next bigint,
foreign_t3_open_vol_next bigint,
foreign_t1_open_val numeric(25,3),
foreign_t2_open_val numeric(25,3),
foreign_t3_open_val numeric(25,3),
foreign_t1_open_val_next numeric(25,3),
foreign_t2_open_val_next numeric(25,3),
foreign_t3_open_val_next numeric(25,3),
inst_t1_open_vol bigint,
inst_t2_open_vol bigint,
inst_t3_open_vol bigint,
inst_t1_open_vol_next bigint,
inst_t2_open_vol_next bigint,
inst_t3_open_vol_next bigint,
inst_t1_open_val numeric(25,3),
inst_t2_open_val numeric(25,3),
inst_t3_open_val numeric(25,3),
inst_t1_open_val_next numeric(25,3),
inst_t2_open_val_next numeric(25,3),
inst_t3_open_val_next numeric(25,3),
local_inst_t1_open_vol bigint,
local_inst_t2_open_vol bigint,
local_inst_t3_open_vol bigint,
local_inst_t1_open_vol_next bigint,
local_inst_t2_open_vol_next bigint,
local_inst_t3_open_vol_next bigint,
local_inst_t1_open_val numeric(25,3),
local_inst_t2_open_val numeric(25,3),
local_inst_t3_open_val numeric(25,3),
local_inst_t1_open_val_next numeric(25,3),
local_inst_t2_open_val_next numeric(25,3),
local_inst_t3_open_val_next numeric(25,3),
foreign_inst_t1_open_vol bigint,
foreign_inst_t2_open_vol bigint,
foreign_inst_t3_open_vol bigint,
foreign_inst_t1_open_vol_next bigint,
foreign_inst_t2_open_vol_next bigint,
foreign_inst_t3_open_vol_next bigint,
foreign_inst_t1_open_val numeric(25,3),
foreign_inst_t2_open_val numeric(25,3),
foreign_inst_t3_open_val numeric(25,3),
foreign_inst_t1_open_val_next numeric(25,3),
foreign_inst_t2_open_val_next numeric(25,3),
foreign_inst_t3_open_val_next numeric(25,3),
retail_t1_open_vol bigint,
retail_t2_open_vol bigint,
retail_t3_open_vol bigint,
retail_t1_open_vol_next bigint,
retail_t2_open_vol_next bigint,
retail_t3_open_vol_next bigint,
retail_t1_open_val numeric(25,3),
retail_t2_open_val numeric(25,3),
retail_t3_open_val numeric(25,3),
retail_t1_open_val_next numeric(25,3),
retail_t2_open_val_next numeric(25,3),
retail_t3_open_val_next numeric(25,3),
local_retail_t1_open_vol bigint,
local_retail_t2_open_vol bigint,
local_retail_t3_open_vol bigint,
local_retail_t1_open_vol_next bigint,
local_retail_t2_open_vol_next bigint,
local_retail_t3_open_vol_next bigint,
local_retail_t1_open_val numeric(25,3),
local_retail_t2_open_val numeric(25,3),
local_retail_t3_open_val numeric(25,3),
local_retail_t1_open_val_next numeric(25,3),
local_retail_t2_open_val_next numeric(25,3),
local_retail_t3_open_val_next numeric(25,3),
foreign_retail_t1_open_vol bigint,
foreign_retail_t2_open_vol bigint,
foreign_retail_t3_open_vol bigint,
foreign_retail_t1_open_vol_next bigint,
foreign_retail_t2_open_vol_next bigint,
foreign_retail_t3_open_vol_next bigint,
foreign_retail_t1_open_val numeric(25,3),
foreign_retail_t2_open_val numeric(25,3),
foreign_retail_t3_open_val numeric(25,3),
foreign_retail_t1_open_val_next numeric(25,3),
foreign_retail_t2_open_val_next numeric(25,3),
foreign_retail_t3_open_val_next numeric(25,3),
nom_t1_open_vol bigint,
nom_t2_open_vol bigint,
nom_t3_open_vol bigint,
nom_t1_open_vol_next bigint,
nom_t2_open_vol_next bigint,
nom_t3_open_vol_next bigint,
nom_t1_open_val numeric(25,3),
nom_t2_open_val numeric(25,3),
nom_t3_open_val numeric(25,3),
nom_t1_open_val_next numeric(25,3),
nom_t2_open_val_next numeric(25,3),
nom_t3_open_val_next numeric(25,3),
local_nom_t1_open_vol bigint,
local_nom_t2_open_vol bigint,
local_nom_t3_open_vol bigint,
local_nom_t1_open_vol_next bigint,
local_nom_t2_open_vol_next bigint,
local_nom_t3_open_vol_next bigint,
local_nom_t1_open_val numeric(25,3),
local_nom_t2_open_val numeric(25,3),
local_nom_t3_open_val numeric(25,3),
local_nom_t1_open_val_next numeric(25,3),
local_nom_t2_open_val_next numeric(25,3),
local_nom_t3_open_val_next numeric(25,3),
foreign_nom_t1_open_vol bigint,
foreign_nom_t2_open_vol bigint,
foreign_nom_t3_open_vol bigint,
foreign_nom_t1_open_vol_next bigint,
foreign_nom_t2_open_vol_next bigint,
foreign_nom_t3_open_vol_next bigint,
foreign_nom_t1_open_val numeric(25,3),
foreign_nom_t2_open_val numeric(25,3),
foreign_nom_t3_open_val numeric(25,3),
foreign_nom_t1_open_val_next numeric(25,3),
foreign_nom_t2_open_val_next numeric(25,3),
foreign_nom_t3_open_val_next numeric(25,3),
ivt_t1_open_vol bigint,
ivt_t2_open_vol bigint,
ivt_t3_open_vol bigint,
ivt_t1_open_vol_next bigint,
ivt_t2_open_vol_next bigint,
ivt_t3_open_vol_next bigint,
ivt_t1_open_val numeric(25,3),
ivt_t2_open_val numeric(25,3),
ivt_t3_open_val numeric(25,3),
ivt_t1_open_val_next numeric(25,3),
ivt_t2_open_val_next numeric(25,3),
ivt_t3_open_val_next numeric(25,3),
pdt_t1_open_vol bigint,
pdt_t2_open_vol bigint,
pdt_t3_open_vol bigint,
pdt_t1_open_vol_next bigint,
pdt_t2_open_vol_next bigint,
pdt_t3_open_vol_next bigint,
pdt_t1_open_val numeric(25,3),
pdt_t2_open_val numeric(25,3),
pdt_t3_open_val numeric(25,3),
pdt_t1_open_val_next numeric(25,3),
pdt_t2_open_val_next numeric(25,3),
pdt_t3_open_val_next numeric(25,3)
) PARTITION by RANGE (t0_date);

create table dibots_v2.exchange_contra_ff_stock_y2016_2019 partition of dibots_v2.exchange_contra_ff_stock
for values from ('2016-01-01') to ('2019-01-01');
create table dibots_v2.exchange_contra_ff_stock_y2019_2021 partition of dibots_v2.exchange_contra_ff_stock
for values from ('2019-01-01') to ('2022-01-01');
create table dibots_v2.exchange_contra_ff_stock_y2022_2024 partition of dibots_v2.exchange_contra_ff_stock
for values from ('2022-01-01') to ('2025-01-01');
create table dibots_v2.exchange_contra_ff_stock_y2025_2027 partition of dibots_v2.exchange_contra_ff_stock
for values from ('2025-01-01') to ('2028-01-01');
create table dibots_v2.exchange_contra_ff_stock_default partition of dibots_v2.exchange_contra_ff_stock default;

alter table dibots_v2.exchange_contra_ff_stock add constraint cff_stock_pkey primary key (t0_date, stock_code);
create unique index cff_uniq on dibots_v2.exchange_contra_ff_stock (t0_date, stock_num);
create index cff_stock_date_idx on dibots_v2.exchange_contra_ff_stock (t0_date);
create index cff_stock_week_idx on dibots_v2.exchange_contra_ff_stock (t0_week_count);
create index cff_stock_stock_idx on dibots_v2.exchange_contra_ff_stock (stock_code);
create index cff_stock_stocknum_idx on dibots_v2.exchange_contra_ff_stock (stock_num);

insert into dibots_v2.exchange_contra_ff_stock (t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, t0_week_count, stock_code, stock_name, stock_num,
board, sector, klci_flag, fbm100_flag, shariah_flag, f4gbm_flag, t1_open_vol, t2_open_vol, t3_open_vol, t1_open_vol_next, t2_open_vol_next, t3_open_vol_next, 
t1_open_val, t2_open_val, t3_open_val, t1_open_val_next, t2_open_val_next, t3_open_val_next)
select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, to_char(t0_date, 'IYYY-IW'), stock_code, stock_name, stock_num, board, sector, klci_flag, 
fbm100_flag, shariah_flag, f4gbm_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, stock_num, 
board, sector, klci_flag, fbm100_flag, shariah_flag, f4gbm_flag;

update dibots_v2.exchange_contra_ff_stock a
set
local_t1_open_vol =  b.t1_open_vol,
local_t2_open_vol = b.t2_open_vol,
local_t3_open_vol = b.t3_open_vol,
local_t1_open_vol_next = b.t1_open_vol_next,
local_t2_open_vol_next = b.t2_open_vol_next,
local_t3_open_vol_next = b.t3_open_vol_next,
local_t1_open_val = b.t1_open_val,
local_t2_open_val = b.t2_open_val,
local_t3_open_val = b.t2_open_val,
local_t1_open_val_next = b.t1_open_val_next,
local_t2_open_val_next = b.t2_open_val_next,
local_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'LOCAL'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
foreign_t1_open_vol =  b.t1_open_vol,
foreign_t2_open_vol = b.t2_open_vol,
foreign_t3_open_vol = b.t3_open_vol,
foreign_t1_open_vol_next = b.t1_open_vol_next,
foreign_t2_open_vol_next = b.t2_open_vol_next,
foreign_t3_open_vol_next = b.t3_open_vol_next,
foreign_t1_open_val = b.t1_open_val,
foreign_t2_open_val = b.t2_open_val,
foreign_t3_open_val = b.t2_open_val,
foreign_t1_open_val_next = b.t1_open_val_next,
foreign_t2_open_val_next = b.t2_open_val_next,
foreign_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'FOREIGN'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;


update dibots_v2.exchange_contra_ff_stock a
set
inst_t1_open_vol =  b.t1_open_vol,
inst_t2_open_vol = b.t2_open_vol,
inst_t3_open_vol = b.t3_open_vol,
inst_t1_open_vol_next = b.t1_open_vol_next,
inst_t2_open_vol_next = b.t2_open_vol_next,
inst_t3_open_vol_next = b.t3_open_vol_next,
inst_t1_open_val = b.t1_open_val,
inst_t2_open_val = b.t2_open_val,
inst_t3_open_val = b.t2_open_val,
inst_t1_open_val_next = b.t1_open_val_next,
inst_t2_open_val_next = b.t2_open_val_next,
inst_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'INSTITUTIONAL'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
local_inst_t1_open_vol =  b.t1_open_vol,
local_inst_t2_open_vol = b.t2_open_vol,
local_inst_t3_open_vol = b.t3_open_vol,
local_inst_t1_open_vol_next = b.t1_open_vol_next,
local_inst_t2_open_vol_next = b.t2_open_vol_next,
local_inst_t3_open_vol_next = b.t3_open_vol_next,
local_inst_t1_open_val = b.t1_open_val,
local_inst_t2_open_val = b.t2_open_val,
local_inst_t3_open_val = b.t2_open_val,
local_inst_t1_open_val_next = b.t1_open_val_next,
local_inst_t2_open_val_next = b.t2_open_val_next,
local_inst_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;


update dibots_v2.exchange_contra_ff_stock a
set
foreign_inst_t1_open_vol =  b.t1_open_vol,
foreign_inst_t2_open_vol = b.t2_open_vol,
foreign_inst_t3_open_vol = b.t3_open_vol,
foreign_inst_t1_open_vol_next = b.t1_open_vol_next,
foreign_inst_t2_open_vol_next = b.t2_open_vol_next,
foreign_inst_t3_open_vol_next = b.t3_open_vol_next,
foreign_inst_t1_open_val = b.t1_open_val,
foreign_inst_t2_open_val = b.t2_open_val,
foreign_inst_t3_open_val = b.t2_open_val,
foreign_inst_t1_open_val_next = b.t1_open_val_next,
foreign_inst_t2_open_val_next = b.t2_open_val_next,
foreign_inst_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
retail_t1_open_vol =  b.t1_open_vol,
retail_t2_open_vol = b.t2_open_vol,
retail_t3_open_vol = b.t3_open_vol,
retail_t1_open_vol_next = b.t1_open_vol_next,
retail_t2_open_vol_next = b.t2_open_vol_next,
retail_t3_open_vol_next = b.t3_open_vol_next,
retail_t1_open_val = b.t1_open_val,
retail_t2_open_val = b.t2_open_val,
retail_t3_open_val = b.t2_open_val,
retail_t1_open_val_next = b.t1_open_val_next,
retail_t2_open_val_next = b.t2_open_val_next,
retail_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'RETAIL'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
local_retail_t1_open_vol =  b.t1_open_vol,
local_retail_t2_open_vol = b.t2_open_vol,
local_retail_t3_open_vol = b.t3_open_vol,
local_retail_t1_open_vol_next = b.t1_open_vol_next,
local_retail_t2_open_vol_next = b.t2_open_vol_next,
local_retail_t3_open_vol_next = b.t3_open_vol_next,
local_retail_t1_open_val = b.t1_open_val,
local_retail_t2_open_val = b.t2_open_val,
local_retail_t3_open_val = b.t2_open_val,
local_retail_t1_open_val_next = b.t1_open_val_next,
local_retail_t2_open_val_next = b.t2_open_val_next,
local_retail_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'LOCAL' and group_type = 'RETAIL'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
foreign_retail_t1_open_vol =  b.t1_open_vol,
foreign_retail_t2_open_vol = b.t2_open_vol,
foreign_retail_t3_open_vol = b.t3_open_vol,
foreign_retail_t1_open_vol_next = b.t1_open_vol_next,
foreign_retail_t2_open_vol_next = b.t2_open_vol_next,
foreign_retail_t3_open_vol_next = b.t3_open_vol_next,
foreign_retail_t1_open_val = b.t1_open_val,
foreign_retail_t2_open_val = b.t2_open_val,
foreign_retail_t3_open_val = b.t2_open_val,
foreign_retail_t1_open_val_next = b.t1_open_val_next,
foreign_retail_t2_open_val_next = b.t2_open_val_next,
foreign_retail_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'FOREIGN' and group_type = 'RETAIL'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
nom_t1_open_vol =  b.t1_open_vol,
nom_t2_open_vol = b.t2_open_vol,
nom_t3_open_vol = b.t3_open_vol,
nom_t1_open_vol_next = b.t1_open_vol_next,
nom_t2_open_vol_next = b.t2_open_vol_next,
nom_t3_open_vol_next = b.t3_open_vol_next,
nom_t1_open_val = b.t1_open_val,
nom_t2_open_val = b.t2_open_val,
nom_t3_open_val = b.t2_open_val,
nom_t1_open_val_next = b.t1_open_val_next,
nom_t2_open_val_next = b.t2_open_val_next,
nom_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'NOMINEES'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
local_nom_t1_open_vol =  b.t1_open_vol,
local_nom_t2_open_vol = b.t2_open_vol,
local_nom_t3_open_vol = b.t3_open_vol,
local_nom_t1_open_vol_next = b.t1_open_vol_next,
local_nom_t2_open_vol_next = b.t2_open_vol_next,
local_nom_t3_open_vol_next = b.t3_open_vol_next,
local_nom_t1_open_val = b.t1_open_val,
local_nom_t2_open_val = b.t2_open_val,
local_nom_t3_open_val = b.t2_open_val,
local_nom_t1_open_val_next = b.t1_open_val_next,
local_nom_t2_open_val_next = b.t2_open_val_next,
local_nom_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'LOCAL' and group_type = 'NOMINEES'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
foreign_nom_t1_open_vol =  b.t1_open_vol,
foreign_nom_t2_open_vol = b.t2_open_vol,
foreign_nom_t3_open_vol = b.t3_open_vol,
foreign_nom_t1_open_vol_next = b.t1_open_vol_next,
foreign_nom_t2_open_vol_next = b.t2_open_vol_next,
foreign_nom_t3_open_vol_next = b.t3_open_vol_next,
foreign_nom_t1_open_val = b.t1_open_val,
foreign_nom_t2_open_val = b.t2_open_val,
foreign_nom_t3_open_val = b.t2_open_val,
foreign_nom_t1_open_val_next = b.t1_open_val_next,
foreign_nom_t2_open_val_next = b.t2_open_val_next,
foreign_nom_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'FOREIGN' and group_type = 'NOMINEES'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
ivt_t1_open_vol =  b.t1_open_vol,
ivt_t2_open_vol = b.t2_open_vol,
ivt_t3_open_vol = b.t3_open_vol,
ivt_t1_open_vol_next = b.t1_open_vol_next,
ivt_t2_open_vol_next = b.t2_open_vol_next,
ivt_t3_open_vol_next = b.t3_open_vol_next,
ivt_t1_open_val = b.t1_open_val,
ivt_t2_open_val = b.t2_open_val,
ivt_t3_open_val = b.t2_open_val,
ivt_t1_open_val_next = b.t1_open_val_next,
ivt_t2_open_val_next = b.t2_open_val_next,
ivt_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'IVT'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_contra_ff_stock a
set
pdt_t1_open_vol =  b.t1_open_vol,
pdt_t2_open_vol = b.t2_open_vol,
pdt_t3_open_vol = b.t3_open_vol,
pdt_t1_open_vol_next = b.t1_open_vol_next,
pdt_t2_open_vol_next = b.t2_open_vol_next,
pdt_t3_open_vol_next = b.t3_open_vol_next,
pdt_t1_open_val = b.t1_open_val,
pdt_t2_open_val = b.t2_open_val,
pdt_t3_open_val = b.t2_open_val,
pdt_t1_open_val_next = b.t1_open_val_next,
pdt_t2_open_val_next = b.t2_open_val_next,
pdt_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'PDT'
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, board, sector, klci_flag, fbm100_flag, shariah_flag) b
where a.t0_date = b.t0_date and a.stock_code = b.stock_code;


vacuum (analyze) dibots_v2.exchange_contra_ff_stock;

-- verification
select * from dibots_v2.exchange_contra_ff_stock where t1_open_vol <> coalesce(inst_t1_open_vol,0) + coalesce(retail_t1_open_vol,0) 
+ coalesce(nom_t1_open_vol,0) + coalesce(ivt_t1_open_vol,0) + coalesce(pdt_t1_open_vol,0);

select * from dibots_v2.exchange_contra_ff_stock where t1_open_vol <> coalesce(local_inst_t1_open_vol,0) + coalesce(foreign_inst_t1_open_vol,0) + coalesce(local_retail_t1_open_vol,0) 
+ coalesce(foreign_retail_t1_open_vol,0) + + coalesce(local_nom_t1_open_vol,0) + coalesce(foreign_nom_t1_open_vol,0) + coalesce(ivt_t1_open_vol,0) + coalesce(pdt_t1_open_vol,0);

--================
-- INCREMENTAL
--================
insert into dibots_v2.exchange_contra_ff_stock (t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, t0_week_count, stock_code, stock_name, stock_num,
board, sector, klci_flag, fbm100_flag, shariah_flag, t1_open_vol, t2_open_vol, t3_open_vol, t1_open_vol_next, t2_open_vol_next, t3_open_vol_next, 
t1_open_val, t2_open_val, t3_open_val, t1_open_val_next, t2_open_val_next, t3_open_val_next)
select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, to_char(t0_date, 'IYYY-IW'), stock_code, stock_name, stock_num, board, sector, 
klci_flag, fbm100_flag, shariah_flag,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_code, stock_name, stock_num, board, sector, klci_flag, fbm100_flag, shariah_flag;

update dibots_v2.exchange_contra_ff_stock a
set
local_t1_open_vol =  b.t1_open_vol,
local_t2_open_vol = b.t2_open_vol,
local_t3_open_vol = b.t3_open_vol,
local_t1_open_vol_next = b.t1_open_vol_next,
local_t2_open_vol_next = b.t2_open_vol_next,
local_t3_open_vol_next = b.t3_open_vol_next,
local_t1_open_val = b.t1_open_val,
local_t2_open_val = b.t2_open_val,
local_t3_open_val = b.t2_open_val,
local_t1_open_val_next = b.t1_open_val_next,
local_t2_open_val_next = b.t2_open_val_next,
local_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'LOCAL' and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where local_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.local_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
foreign_t1_open_vol =  b.t1_open_vol,
foreign_t2_open_vol = b.t2_open_vol,
foreign_t3_open_vol = b.t3_open_vol,
foreign_t1_open_vol_next = b.t1_open_vol_next,
foreign_t2_open_vol_next = b.t2_open_vol_next,
foreign_t3_open_vol_next = b.t3_open_vol_next,
foreign_t1_open_val = b.t1_open_val,
foreign_t2_open_val = b.t2_open_val,
foreign_t3_open_val = b.t2_open_val,
foreign_t1_open_val_next = b.t1_open_val_next,
foreign_t2_open_val_next = b.t2_open_val_next,
foreign_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'FOREIGN' and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where foreign_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.foreign_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
inst_t1_open_vol =  b.t1_open_vol,
inst_t2_open_vol = b.t2_open_vol,
inst_t3_open_vol = b.t3_open_vol,
inst_t1_open_vol_next = b.t1_open_vol_next,
inst_t2_open_vol_next = b.t2_open_vol_next,
inst_t3_open_vol_next = b.t3_open_vol_next,
inst_t1_open_val = b.t1_open_val,
inst_t2_open_val = b.t2_open_val,
inst_t3_open_val = b.t2_open_val,
inst_t1_open_val_next = b.t1_open_val_next,
inst_t2_open_val_next = b.t2_open_val_next,
inst_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'INSTITUTIONAL' and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where inst_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.inst_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
local_inst_t1_open_vol =  b.t1_open_vol,
local_inst_t2_open_vol = b.t2_open_vol,
local_inst_t3_open_vol = b.t3_open_vol,
local_inst_t1_open_vol_next = b.t1_open_vol_next,
local_inst_t2_open_vol_next = b.t2_open_vol_next,
local_inst_t3_open_vol_next = b.t3_open_vol_next,
local_inst_t1_open_val = b.t1_open_val,
local_inst_t2_open_val = b.t2_open_val,
local_inst_t3_open_val = b.t2_open_val,
local_inst_t1_open_val_next = b.t1_open_val_next,
local_inst_t2_open_val_next = b.t2_open_val_next,
local_inst_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'LOCAL' and group_type = 'INSTITUTIONAL' 
and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where local_inst_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.local_inst_t1_open_vol is null;


update dibots_v2.exchange_contra_ff_stock a
set
foreign_inst_t1_open_vol =  b.t1_open_vol,
foreign_inst_t2_open_vol = b.t2_open_vol,
foreign_inst_t3_open_vol = b.t3_open_vol,
foreign_inst_t1_open_vol_next = b.t1_open_vol_next,
foreign_inst_t2_open_vol_next = b.t2_open_vol_next,
foreign_inst_t3_open_vol_next = b.t3_open_vol_next,
foreign_inst_t1_open_val = b.t1_open_val,
foreign_inst_t2_open_val = b.t2_open_val,
foreign_inst_t3_open_val = b.t2_open_val,
foreign_inst_t1_open_val_next = b.t1_open_val_next,
foreign_inst_t2_open_val_next = b.t2_open_val_next,
foreign_inst_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'FOREIGN' and group_type = 'INSTITUTIONAL' 
and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where foreign_inst_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.foreign_inst_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
retail_t1_open_vol =  b.t1_open_vol,
retail_t2_open_vol = b.t2_open_vol,
retail_t3_open_vol = b.t3_open_vol,
retail_t1_open_vol_next = b.t1_open_vol_next,
retail_t2_open_vol_next = b.t2_open_vol_next,
retail_t3_open_vol_next = b.t3_open_vol_next,
retail_t1_open_val = b.t1_open_val,
retail_t2_open_val = b.t2_open_val,
retail_t3_open_val = b.t2_open_val,
retail_t1_open_val_next = b.t1_open_val_next,
retail_t2_open_val_next = b.t2_open_val_next,
retail_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'RETAIL' and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where retail_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.retail_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
local_retail_t1_open_vol =  b.t1_open_vol,
local_retail_t2_open_vol = b.t2_open_vol,
local_retail_t3_open_vol = b.t3_open_vol,
local_retail_t1_open_vol_next = b.t1_open_vol_next,
local_retail_t2_open_vol_next = b.t2_open_vol_next,
local_retail_t3_open_vol_next = b.t3_open_vol_next,
local_retail_t1_open_val = b.t1_open_val,
local_retail_t2_open_val = b.t2_open_val,
local_retail_t3_open_val = b.t2_open_val,
local_retail_t1_open_val_next = b.t1_open_val_next,
local_retail_t2_open_val_next = b.t2_open_val_next,
local_retail_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'LOCAL' and group_type = 'RETAIL' 
and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where local_retail_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.local_retail_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
foreign_retail_t1_open_vol =  b.t1_open_vol,
foreign_retail_t2_open_vol = b.t2_open_vol,
foreign_retail_t3_open_vol = b.t3_open_vol,
foreign_retail_t1_open_vol_next = b.t1_open_vol_next,
foreign_retail_t2_open_vol_next = b.t2_open_vol_next,
foreign_retail_t3_open_vol_next = b.t3_open_vol_next,
foreign_retail_t1_open_val = b.t1_open_val,
foreign_retail_t2_open_val = b.t2_open_val,
foreign_retail_t3_open_val = b.t2_open_val,
foreign_retail_t1_open_val_next = b.t1_open_val_next,
foreign_retail_t2_open_val_next = b.t2_open_val_next,
foreign_retail_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'FOREIGN' and group_type = 'RETAIL' 
and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where foreign_retail_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.foreign_retail_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
nom_t1_open_vol =  b.t1_open_vol,
nom_t2_open_vol = b.t2_open_vol,
nom_t3_open_vol = b.t3_open_vol,
nom_t1_open_vol_next = b.t1_open_vol_next,
nom_t2_open_vol_next = b.t2_open_vol_next,
nom_t3_open_vol_next = b.t3_open_vol_next,
nom_t1_open_val = b.t1_open_val,
nom_t2_open_val = b.t2_open_val,
nom_t3_open_val = b.t2_open_val,
nom_t1_open_val_next = b.t1_open_val_next,
nom_t2_open_val_next = b.t2_open_val_next,
nom_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'NOMINEES' and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where nom_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.nom_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
local_nom_t1_open_vol =  b.t1_open_vol,
local_nom_t2_open_vol = b.t2_open_vol,
local_nom_t3_open_vol = b.t3_open_vol,
local_nom_t1_open_vol_next = b.t1_open_vol_next,
local_nom_t2_open_vol_next = b.t2_open_vol_next,
local_nom_t3_open_vol_next = b.t3_open_vol_next,
local_nom_t1_open_val = b.t1_open_val,
local_nom_t2_open_val = b.t2_open_val,
local_nom_t3_open_val = b.t2_open_val,
local_nom_t1_open_val_next = b.t1_open_val_next,
local_nom_t2_open_val_next = b.t2_open_val_next,
local_nom_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'LOCAL' and group_type = 'NOMINEES' 
and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where local_nom_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.local_nom_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
foreign_nom_t1_open_vol =  b.t1_open_vol,
foreign_nom_t2_open_vol = b.t2_open_vol,
foreign_nom_t3_open_vol = b.t3_open_vol,
foreign_nom_t1_open_vol_next = b.t1_open_vol_next,
foreign_nom_t2_open_vol_next = b.t2_open_vol_next,
foreign_nom_t3_open_vol_next = b.t3_open_vol_next,
foreign_nom_t1_open_val = b.t1_open_val,
foreign_nom_t2_open_val = b.t2_open_val,
foreign_nom_t3_open_val = b.t2_open_val,
foreign_nom_t1_open_val_next = b.t1_open_val_next,
foreign_nom_t2_open_val_next = b.t2_open_val_next,
foreign_nom_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where locality_new = 'FOREIGN' and group_type = 'NOMINEES' 
and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where foreign_nom_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.foreign_nom_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
ivt_t1_open_vol =  b.t1_open_vol,
ivt_t2_open_vol = b.t2_open_vol,
ivt_t3_open_vol = b.t3_open_vol,
ivt_t1_open_vol_next = b.t1_open_vol_next,
ivt_t2_open_vol_next = b.t2_open_vol_next,
ivt_t3_open_vol_next = b.t3_open_vol_next,
ivt_t1_open_val = b.t1_open_val,
ivt_t2_open_val = b.t2_open_val,
ivt_t3_open_val = b.t2_open_val,
ivt_t1_open_val_next = b.t1_open_val_next,
ivt_t2_open_val_next = b.t2_open_val_next,
ivt_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'IVT' and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where ivt_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.ivt_t1_open_vol is null;

update dibots_v2.exchange_contra_ff_stock a
set
pdt_t1_open_vol =  b.t1_open_vol,
pdt_t2_open_vol = b.t2_open_vol,
pdt_t3_open_vol = b.t3_open_vol,
pdt_t1_open_vol_next = b.t1_open_vol_next,
pdt_t2_open_vol_next = b.t2_open_vol_next,
pdt_t3_open_vol_next = b.t3_open_vol_next,
pdt_t1_open_val = b.t1_open_val,
pdt_t2_open_val = b.t2_open_val,
pdt_t3_open_val = b.t2_open_val,
pdt_t1_open_val_next = b.t1_open_val_next,
pdt_t2_open_val_next = b.t2_open_val_next,
pdt_t3_open_val_next = b.t3_open_val_next
from 
(select t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num,
sum(t1_open_volume) as t1_open_vol, sum(t2_open_volume) as t2_open_vol, sum(t3_open_volume) as t3_open_vol, 
sum(t1_open_volume_nexttradingday) as t1_open_vol_next, sum(t2_open_volume_nexttradingday) as t2_open_vol_next, sum(t3_open_volume_nexttradingday) as t3_open_vol_next,
sum(t1_open_value) as t1_open_val, sum(t2_open_value) as t2_open_val, sum(t3_open_value) as t3_open_val,
sum(t1_open_value_nexttradingday) as t1_open_val_next, sum(t2_open_value_nexttradingday) as t2_open_val_next, sum(t3_open_value_nexttradingday) as t3_open_val_next
from dibots_v2.exchange_contra_fund_flow
where group_type = 'PDT' and t0_date > (select max(t0_date) from dibots_v2.exchange_contra_ff_stock where pdt_t1_open_vol is not null)
group by t0_date, tminus1_date, tminus2_date, tminus3_date, tminus4_date, stock_num) b
where a.t0_date = b.t0_date and a.stock_num = b.stock_num and a.pdt_t1_open_vol is null;

--======================================
-- EXCHANGE_CONTRA_MOVEMENT_RATIO_MVIEW
--=======================================

REFRESH MATERIALIZED VIEW CONCURRENTLY dibots_v2.exchange_contra_movement_ratio_mview;

create materialized view dibots_v2.exchange_contra_movement_ratio_mview as
SELECT t0.t0_date,
    t1.t0_date AS tplus1_date,
    t2.t0_date AS tplus2_date,
    t0.stock_code,
    t0.stock_name,
    t0.stock_num,
    -- OVERALL
    t0.t1_open_vol_next,
    t1.t2_open_vol_next,
    t2.t3_open_vol_next,
    t0.t1_open_vol_next - t1.t2_open_vol_next as contra_tplus1_vol,
    t1.t2_open_vol_next - t2.t3_open_vol_next as contra_tplus2_vol,
    (cast(t0.t1_open_vol_next as numeric (25,2)) - cast(t1.t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.t1_open_vol_next as numeric (25,2)),0) + (cast(t1.t2_open_vol_next as numeric (25,2)) - cast(t2.t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.t1_open_vol_next as numeric (25,2)),0) as contra_ratio_vol,
    (cast(t0.t1_open_vol_next as numeric (25,2)) - cast(t1.t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.t1_open_vol_next as numeric (25,2)),0) as contra_ratio_tplus1_vol,
    (cast(t1.t2_open_vol_next as numeric (25,2)) - cast(t2.t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.t1_open_vol_next as numeric (25,2)),0) as contra_ratio_tplus2_vol,    
    -- LOCAL 
    t0.local_t1_open_vol_next,
    t1.local_t2_open_vol_next,
    t2.local_t3_open_vol_next,
    t0.local_t1_open_vol_next - t1.local_t2_open_vol_next as local_contra_tplus1_vol,
    t1.local_t2_open_vol_next - t2.local_t3_open_vol_next as local_contra_tplus2_vol,
    (cast(t0.local_t1_open_vol_next as numeric (25,2)) - cast(t1.local_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.local_t2_open_vol_next as numeric (25,2)) - cast(t2.local_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_t1_open_vol_next as numeric (25,2)),0) as local_contra_ratio_vol,
    (cast(t0.local_t1_open_vol_next as numeric (25,2)) - cast(t1.local_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_t1_open_vol_next as numeric (25,2)),0) as local_contra_ratio_tplus1_vol,
    (cast(t1.local_t2_open_vol_next as numeric (25,2)) - cast(t2.local_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_t1_open_vol_next as numeric (25,2)),0) as local_contra_ratio_tplus2_vol,      
    -- FOREIGN
	t0.foreign_t1_open_vol_next,
    t1.foreign_t2_open_vol_next,
    t2.foreign_t3_open_vol_next,
    t0.foreign_t1_open_vol_next - t1.foreign_t2_open_vol_next as foreign_contra_tplus1_vol,
    t1.foreign_t2_open_vol_next - t2.foreign_t3_open_vol_next as foreign_contra_tplus2_vol,
    (cast(t0.foreign_t1_open_vol_next as numeric (25,2)) - cast(t1.foreign_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.foreign_t2_open_vol_next as numeric (25,2)) - cast(t2.foreign_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_t1_open_vol_next as numeric (25,2)),0) as foreign_contra_ratio_vol,
    (cast(t0.foreign_t1_open_vol_next as numeric (25,2)) - cast(t1.foreign_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_t1_open_vol_next as numeric (25,2)),0) as foreign_contra_ratio_tplus1_vol,
    (cast(t1.foreign_t2_open_vol_next as numeric (25,2)) - cast(t2.foreign_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_t1_open_vol_next as numeric (25,2)),0) as foreign_contra_ratio_tplus2_vol,      
    -- INST
	t0.inst_t1_open_vol_next,
    t1.inst_t2_open_vol_next,
    t2.inst_t3_open_vol_next,
    t0.inst_t1_open_vol_next - t1.inst_t2_open_vol_next as inst_contra_tplus1_vol,
    t1.inst_t2_open_vol_next - t2.inst_t3_open_vol_next as inst_contra_tplus2_vol,
    (cast(t0.inst_t1_open_vol_next as numeric (25,2)) - cast(t1.inst_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.inst_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.inst_t2_open_vol_next as numeric (25,2)) - cast(t2.inst_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.inst_t1_open_vol_next as numeric (25,2)),0) as inst_contra_ratio_vol,
    (cast(t0.inst_t1_open_vol_next as numeric (25,2)) - cast(t1.inst_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.inst_t1_open_vol_next as numeric (25,2)),0) as inst_contra_ratio_tplus1_vol,
    (cast(t1.inst_t2_open_vol_next as numeric (25,2)) - cast(t2.inst_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.inst_t1_open_vol_next as numeric (25,2)),0) as inst_contra_ratio_tplus2_vol,      
    -- local_inst 
    t0.local_inst_t1_open_vol_next,
    t1.local_inst_t2_open_vol_next,
    t2.local_inst_t3_open_vol_next,
    t0.local_inst_t1_open_vol_next - t1.local_inst_t2_open_vol_next as local_inst_contra_tplus1_vol,
    t1.local_inst_t2_open_vol_next - t2.local_inst_t3_open_vol_next as local_inst_contra_tplus2_vol,
    (cast(t0.local_inst_t1_open_vol_next as numeric (25,2)) - cast(t1.local_inst_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_inst_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.local_inst_t2_open_vol_next as numeric (25,2)) - cast(t2.local_inst_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_inst_t1_open_vol_next as numeric (25,2)),0) as local_inst_contra_ratio_vol,
    (cast(t0.local_inst_t1_open_vol_next as numeric (25,2)) - cast(t1.local_inst_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_inst_t1_open_vol_next as numeric (25,2)),0) as local_inst_contra_ratio_tplus1_vol,
    (cast(t1.local_inst_t2_open_vol_next as numeric (25,2)) - cast(t2.local_inst_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_inst_t1_open_vol_next as numeric (25,2)),0) as local_inst_contra_ratio_tplus2_vol,      
    -- foreign_inst
	t0.foreign_inst_t1_open_vol_next,
    t1.foreign_inst_t2_open_vol_next,
    t2.foreign_inst_t3_open_vol_next,
    t0.foreign_inst_t1_open_vol_next - t1.foreign_inst_t2_open_vol_next as foreign_inst_contra_tplus1_vol,
    t1.foreign_inst_t2_open_vol_next - t2.foreign_inst_t3_open_vol_next as foreign_inst_contra_tplus2_vol,
    (cast(t0.foreign_inst_t1_open_vol_next as numeric (25,2)) - cast(t1.foreign_inst_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_inst_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.foreign_inst_t2_open_vol_next as numeric (25,2)) - cast(t2.foreign_inst_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_inst_t1_open_vol_next as numeric (25,2)),0) as foreign_inst_contra_ratio_vol,
    (cast(t0.foreign_inst_t1_open_vol_next as numeric (25,2)) - cast(t1.foreign_inst_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_inst_t1_open_vol_next as numeric (25,2)),0) as foreign_inst_contra_ratio_tplus1_vol,
    (cast(t1.foreign_inst_t2_open_vol_next as numeric (25,2)) - cast(t2.foreign_inst_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_inst_t1_open_vol_next as numeric (25,2)),0) as foreign_inst_contra_ratio_tplus2_vol,          
    -- retail
	t0.retail_t1_open_vol_next,
    t1.retail_t2_open_vol_next,
    t2.retail_t3_open_vol_next,
    t0.retail_t1_open_vol_next - t1.retail_t2_open_vol_next as retail_contra_tplus1_vol,
    t1.retail_t2_open_vol_next - t2.retail_t3_open_vol_next as retail_contra_tplus2_vol,
    (cast(t0.retail_t1_open_vol_next as numeric (25,2)) - cast(t1.retail_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.retail_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.retail_t2_open_vol_next as numeric (25,2)) - cast(t2.retail_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.retail_t1_open_vol_next as numeric (25,2)),0) as retail_contra_ratio_vol,
    (cast(t0.retail_t1_open_vol_next as numeric (25,2)) - cast(t1.retail_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.retail_t1_open_vol_next as numeric (25,2)),0) as retail_contra_ratio_tplus1_vol,
    (cast(t1.retail_t2_open_vol_next as numeric (25,2)) - cast(t2.retail_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.retail_t1_open_vol_next as numeric (25,2)),0) as retail_contra_ratio_tplus2_vol,      
    -- local_retail 
    t0.local_retail_t1_open_vol_next,
    t1.local_retail_t2_open_vol_next,
    t2.local_retail_t3_open_vol_next,
    t0.local_retail_t1_open_vol_next - t1.local_retail_t2_open_vol_next as local_retail_contra_tplus1_vol,
    t1.local_retail_t2_open_vol_next - t2.local_retail_t3_open_vol_next as local_retail_contra_tplus2_vol,
    (cast(t0.local_retail_t1_open_vol_next as numeric (25,2)) - cast(t1.local_retail_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_retail_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.local_retail_t2_open_vol_next as numeric (25,2)) - cast(t2.local_retail_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_retail_t1_open_vol_next as numeric (25,2)),0) as local_retail_contra_ratio_vol,
    (cast(t0.local_retail_t1_open_vol_next as numeric (25,2)) - cast(t1.local_retail_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_retail_t1_open_vol_next as numeric (25,2)),0) as local_retail_contra_ratio_tplus1_vol,
    (cast(t1.local_retail_t2_open_vol_next as numeric (25,2)) - cast(t2.local_retail_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_retail_t1_open_vol_next as numeric (25,2)),0) as local_retail_contra_ratio_tplus2_vol,      
    -- foreign_retail
	t0.foreign_retail_t1_open_vol_next,
    t1.foreign_retail_t2_open_vol_next,
    t2.foreign_retail_t3_open_vol_next,
    t0.foreign_retail_t1_open_vol_next - t1.foreign_retail_t2_open_vol_next as foreign_retail_contra_tplus1_vol,
    t1.foreign_retail_t2_open_vol_next - t2.foreign_retail_t3_open_vol_next as foreign_retail_contra_tplus2_vol,
    (cast(t0.foreign_retail_t1_open_vol_next as numeric (25,2)) - cast(t1.foreign_retail_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_retail_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.foreign_retail_t2_open_vol_next as numeric (25,2)) - cast(t2.foreign_retail_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_retail_t1_open_vol_next as numeric (25,2)),0) as foreign_retail_contra_ratio_vol,
    (cast(t0.foreign_retail_t1_open_vol_next as numeric (25,2)) - cast(t1.foreign_retail_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_retail_t1_open_vol_next as numeric (25,2)),0) as foreign_retail_contra_ratio_tplus1_vol,
    (cast(t1.foreign_retail_t2_open_vol_next as numeric (25,2)) - cast(t2.foreign_retail_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_retail_t1_open_vol_next as numeric (25,2)),0) as foreign_retail_contra_ratio_tplus2_vol,              
    -- nom
	t0.nom_t1_open_vol_next,
    t1.nom_t2_open_vol_next,
    t2.nom_t3_open_vol_next,
    t0.nom_t1_open_vol_next - t1.nom_t2_open_vol_next as nom_contra_tplus1_vol,
    t1.nom_t2_open_vol_next - t2.nom_t3_open_vol_next as nom_contra_tplus2_vol,
    (cast(t0.nom_t1_open_vol_next as numeric (25,2)) - cast(t1.nom_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.nom_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.nom_t2_open_vol_next as numeric (25,2)) - cast(t2.nom_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.nom_t1_open_vol_next as numeric (25,2)),0) as nom_contra_ratio_vol,
    (cast(t0.nom_t1_open_vol_next as numeric (25,2)) - cast(t1.nom_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.nom_t1_open_vol_next as numeric (25,2)),0) as nom_contra_ratio_tplus1_vol,
    (cast(t1.nom_t2_open_vol_next as numeric (25,2)) - cast(t2.nom_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.nom_t1_open_vol_next as numeric (25,2)),0) as nom_contra_ratio_tplus2_vol,      
    -- local_nom 
    t0.local_nom_t1_open_vol_next,
    t1.local_nom_t2_open_vol_next,
    t2.local_nom_t3_open_vol_next,
    t0.local_nom_t1_open_vol_next - t1.local_nom_t2_open_vol_next as local_nom_contra_tplus1_vol,
    t1.local_nom_t2_open_vol_next - t2.local_nom_t3_open_vol_next as local_nom_contra_tplus2_vol,
    (cast(t0.local_nom_t1_open_vol_next as numeric (25,2)) - cast(t1.local_nom_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_nom_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.local_nom_t2_open_vol_next as numeric (25,2)) - cast(t2.local_nom_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_nom_t1_open_vol_next as numeric (25,2)),0) as local_nom_contra_ratio_vol,
    (cast(t0.local_nom_t1_open_vol_next as numeric (25,2)) - cast(t1.local_nom_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_nom_t1_open_vol_next as numeric (25,2)),0) as local_nom_contra_ratio_tplus1_vol,
    (cast(t1.local_nom_t2_open_vol_next as numeric (25,2)) - cast(t2.local_nom_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.local_nom_t1_open_vol_next as numeric (25,2)),0) as local_nom_contra_ratio_tplus2_vol,      
    -- foreign_nom
	t0.foreign_nom_t1_open_vol_next,
    t1.foreign_nom_t2_open_vol_next,
    t2.foreign_nom_t3_open_vol_next,
    t0.foreign_nom_t1_open_vol_next - t1.foreign_nom_t2_open_vol_next as foreign_nom_contra_tplus1_vol,
    t1.foreign_nom_t2_open_vol_next - t2.foreign_nom_t3_open_vol_next as foreign_nom_contra_tplus2_vol,
    (cast(t0.foreign_nom_t1_open_vol_next as numeric (25,2)) - cast(t1.foreign_nom_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_nom_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.foreign_nom_t2_open_vol_next as numeric (25,2)) - cast(t2.foreign_nom_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_nom_t1_open_vol_next as numeric (25,2)),0) as foreign_nom_contra_ratio_vol,
    (cast(t0.foreign_nom_t1_open_vol_next as numeric (25,2)) - cast(t1.foreign_nom_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_nom_t1_open_vol_next as numeric (25,2)),0) as foreign_nom_contra_ratio_tplus1_vol,
    (cast(t1.foreign_nom_t2_open_vol_next as numeric (25,2)) - cast(t2.foreign_nom_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.foreign_nom_t1_open_vol_next as numeric (25,2)),0) as foreign_nom_contra_ratio_tplus2_vol,                  
    -- pdt
	t0.pdt_t1_open_vol_next,
    t1.pdt_t2_open_vol_next,
    t2.pdt_t3_open_vol_next,
    t0.pdt_t1_open_vol_next - t1.pdt_t2_open_vol_next as pdt_contra_tplus1_vol,
    t1.pdt_t2_open_vol_next - t2.pdt_t3_open_vol_next as pdt_contra_tplus2_vol,
    (cast(t0.pdt_t1_open_vol_next as numeric (25,2)) - cast(t1.pdt_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.pdt_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.pdt_t2_open_vol_next as numeric (25,2)) - cast(t2.pdt_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.pdt_t1_open_vol_next as numeric (25,2)),0) as pdt_contra_ratio_vol,
    (cast(t0.pdt_t1_open_vol_next as numeric (25,2)) - cast(t1.pdt_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.pdt_t1_open_vol_next as numeric (25,2)),0) as pdt_contra_ratio_tplus1_vol,
    (cast(t1.pdt_t2_open_vol_next as numeric (25,2)) - cast(t2.pdt_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.pdt_t1_open_vol_next as numeric (25,2)),0) as pdt_contra_ratio_tplus2_vol,          
    -- ivt
    t0.ivt_t1_open_vol_next,
    t1.ivt_t2_open_vol_next,
    t2.ivt_t3_open_vol_next,
    t0.ivt_t1_open_vol_next - t1.ivt_t2_open_vol_next as ivt_contra_tplus1_vol,
    t1.ivt_t2_open_vol_next - t2.ivt_t3_open_vol_next as ivt_contra_tplus2_vol,
    (cast(t0.ivt_t1_open_vol_next as numeric (25,2)) - cast(t1.ivt_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.ivt_t1_open_vol_next as numeric (25,2)),0) + (cast(t1.ivt_t2_open_vol_next as numeric (25,2)) - cast(t2.ivt_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.ivt_t1_open_vol_next as numeric (25,2)),0) as ivt_contra_ratio_vol,
    (cast(t0.ivt_t1_open_vol_next as numeric (25,2)) - cast(t1.ivt_t2_open_vol_next as numeric (25,2)))/nullif(cast(t0.ivt_t1_open_vol_next as numeric (25,2)),0) as ivt_contra_ratio_tplus1_vol,
    (cast(t1.ivt_t2_open_vol_next as numeric (25,2)) - cast(t2.ivt_t3_open_vol_next as numeric (25,2)))/nullif(cast(t0.ivt_t1_open_vol_next as numeric (25,2)),0) as ivt_contra_ratio_tplus2_vol,
    -- prop
    NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) as prop_t1_open_vol_next,
    NULLIF((COALESCE(t1.ivt_t2_open_vol_next,0) + COALESCE(t1.pdt_t2_open_vol_next,0)),0) as prop_t2_open_vol_next,
    NULLIF((COALESCE(t2.ivt_t3_open_vol_next,0) + COALESCE(t2.pdt_t3_open_vol_next,0)),0) as prop_t3_open_vol_next,
    NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t1.ivt_t2_open_vol_next,0) + COALESCE(t1.pdt_t2_open_vol_next,0)),0) as prop_contra_tplus1_vol,
	NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t2.ivt_t3_open_vol_next,0) + COALESCE(t2.pdt_t3_open_vol_next,0)),0) as prop_contra_tplus2_vol,
    (cast(NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.ivt_t2_open_vol_next,0) + COALESCE(t1.pdt_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.ivt_t2_open_vol_next,0) + COALESCE(t1.pdt_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.ivt_t3_open_vol_next,0) + COALESCE(t2.pdt_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) as numeric (25,2)),0) as prop_contra_ratio_vol,
    (cast(NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.ivt_t2_open_vol_next,0) + COALESCE(t1.pdt_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) as numeric (25,2)),0) as prop_contra_ratio_tplus1_vol,
    (cast(NULLIF((COALESCE(t1.ivt_t2_open_vol_next,0) + COALESCE(t1.pdt_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.ivt_t3_open_vol_next,0) + COALESCE(t2.pdt_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.ivt_t1_open_vol_next,0) + COALESCE(t0.pdt_t1_open_vol_next,0)),0) as numeric (25,2)),0) as prop_contra_ratio_tplus2_vol,
    -- inst_nom
    NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as inst_nom_t1_open_vol_next,
    NULLIF((COALESCE(t1.inst_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as inst_nom_t2_open_vol_next,
    NULLIF((COALESCE(t2.inst_t3_open_vol_next,0) + COALESCE(t2.nom_t3_open_vol_next,0)),0) as inst_nom_t3_open_vol_next,
    NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t1.inst_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as inst_nom_contra_tplus1_vol,
	NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t2.inst_t3_open_vol_next,0) + COALESCE(t2.nom_t3_open_vol_next,0)),0) as inst_nom_contra_tplus2_vol,
    (cast(NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.inst_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.inst_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.inst_t3_open_vol_next,0) + COALESCE(t2.nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as inst_nom_contra_ratio_vol,
    (cast(NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.inst_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as inst_nom_contra_ratio_tplus1_vol,
    (cast(NULLIF((COALESCE(t1.inst_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.inst_t3_open_vol_next,0) + COALESCE(t2.nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.inst_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as inst_nom_contra_ratio_tplus2_vol,
    -- local_inst_nom
    NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as local_inst_nom_t1_open_vol_next,
    NULLIF((COALESCE(t1.local_inst_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as local_inst_nom_t2_open_vol_next,
    NULLIF((COALESCE(t2.local_inst_t3_open_vol_next,0) + COALESCE(t2.local_nom_t3_open_vol_next,0)),0) as local_inst_nom_t3_open_vol_next,
    NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t1.local_inst_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as local_inst_nom_contra_tplus1_vol,
	NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t2.local_inst_t3_open_vol_next,0) + COALESCE(t2.local_nom_t3_open_vol_next,0)),0) as local_inst_nom_contra_tplus2_vol,
    (cast(NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.local_inst_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.local_inst_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.local_inst_t3_open_vol_next,0) + COALESCE(t2.local_nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as local_inst_nom_contra_ratio_vol,
    (cast(NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.local_inst_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as local_inst_nom_contra_ratio_tplus1_vol,
    (cast(NULLIF((COALESCE(t1.local_inst_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.local_inst_t3_open_vol_next,0) + COALESCE(t2.local_nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_inst_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as local_inst_nom_contra_ratio_tplus2_vol,
    -- foreign_inst_nom
    NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as foreign_inst_nom_t1_open_vol_next,
    NULLIF((COALESCE(t1.foreign_inst_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as foreign_inst_nom_t2_open_vol_next,
    NULLIF((COALESCE(t2.foreign_inst_t3_open_vol_next,0) + COALESCE(t2.foreign_nom_t3_open_vol_next,0)),0) as foreign_inst_nom_t3_open_vol_next,
    NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t1.foreign_inst_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as foreign_inst_nom_contra_tplus1_vol,
	NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t2.foreign_inst_t3_open_vol_next,0) + COALESCE(t2.foreign_nom_t3_open_vol_next,0)),0) as foreign_inst_nom_contra_tplus2_vol,
    (cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.foreign_inst_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.foreign_inst_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.foreign_inst_t3_open_vol_next,0) + COALESCE(t2.foreign_nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as foreign_inst_nom_contra_ratio_vol,
    (cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.foreign_inst_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as foreign_inst_nom_contra_ratio_tplus1_vol,
    (cast(NULLIF((COALESCE(t1.foreign_inst_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.foreign_inst_t3_open_vol_next,0) + COALESCE(t2.foreign_nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as foreign_inst_nom_contra_ratio_tplus2_vol,
    -- retail_nom
    NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as retail_nom_t1_open_vol_next,
    NULLIF((COALESCE(t1.retail_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as retail_nom_t2_open_vol_next,
    NULLIF((COALESCE(t2.retail_t3_open_vol_next,0) + COALESCE(t2.nom_t3_open_vol_next,0)),0) as retail_nom_t3_open_vol_next,
    NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t1.retail_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as retail_nom_contra_tplus1_vol,
    NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t2.retail_t3_open_vol_next,0) + COALESCE(t2.nom_t3_open_vol_next,0)),0) as retail_nom_contra_tplus2_vol,
    (cast(NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.retail_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.retail_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.retail_t3_open_vol_next,0) + COALESCE(t2.nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as retail_nom_contra_ratio_vol,
    (cast(NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.retail_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as retail_nom_contra_ratio_tplus1_vol,
    (cast(NULLIF((COALESCE(t1.retail_t2_open_vol_next,0) + COALESCE(t1.nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.retail_t3_open_vol_next,0) + COALESCE(t2.nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.retail_t1_open_vol_next,0) + COALESCE(t0.nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as retail_nom_contra_ratio_tplus2_vol,
    -- local_retail_nom
    NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as local_retail_nom_t1_open_vol_next,
    NULLIF((COALESCE(t1.local_retail_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as local_retail_nom_t2_open_vol_next,
    NULLIF((COALESCE(t2.local_retail_t3_open_vol_next,0) + COALESCE(t2.local_nom_t3_open_vol_next,0)),0) as local_retail_nom_t3_open_vol_next,
    NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t1.local_retail_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as local_retail_nom_contra_tplus1_vol,
    NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t2.local_retail_t3_open_vol_next,0) + COALESCE(t2.local_nom_t3_open_vol_next,0)),0) as local_retail_nom_contra_tplus2_vol,
    (cast(NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.local_retail_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.local_retail_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.local_retail_t3_open_vol_next,0) + COALESCE(t2.local_nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as local_retail_nom_contra_ratio_vol,
    (cast(NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.local_retail_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as local_retail_nom_contra_ratio_tplus1_vol,
    (cast(NULLIF((COALESCE(t1.local_retail_t2_open_vol_next,0) + COALESCE(t1.local_nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.local_retail_t3_open_vol_next,0) + COALESCE(t2.local_nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_retail_t1_open_vol_next,0) + COALESCE(t0.local_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as local_retail_nom_contra_ratio_tplus2_vol,
    -- foreign_retail_nom
    NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as foreign_retail_nom_t1_open_vol_next,
    NULLIF((COALESCE(t1.foreign_retail_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as foreign_retail_nom_t2_open_vol_next,
    NULLIF((COALESCE(t2.foreign_retail_t3_open_vol_next,0) + COALESCE(t2.foreign_nom_t3_open_vol_next,0)),0) as foreign_retail_nom_t3_open_vol_next,
    NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t1.foreign_retail_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as foreign_retail_nom_contra_tplus1_vol,
    NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) - NULLIF((COALESCE(t2.foreign_retail_t3_open_vol_next,0) + COALESCE(t2.foreign_nom_t3_open_vol_next,0)),0) as foreign_retail_nom_contra_tplus2_vol,
    (cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.foreign_retail_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.foreign_retail_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.foreign_retail_t3_open_vol_next,0) + COALESCE(t2.foreign_nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as foreign_retail_nom_contra_ratio_vol,
    (cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.foreign_retail_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as foreign_retail_nom_contra_ratio_tplus1_vol,
    (cast(NULLIF((COALESCE(t1.foreign_retail_t2_open_vol_next,0) + COALESCE(t1.foreign_nom_t2_open_vol_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.foreign_retail_t3_open_vol_next,0) + COALESCE(t2.foreign_nom_t3_open_vol_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_vol_next,0) + COALESCE(t0.foreign_nom_t1_open_vol_next,0)),0) as numeric (25,2)),0) as foreign_retail_nom_contra_ratio_tplus2_vol,
    -- OVERALL
    t0.t1_open_val_next,
    t1.t2_open_val_next,
    t2.t3_open_val_next,
    t0.t1_open_val_next - t1.t2_open_val_next as contra_tplus1_val,
    t1.t2_open_val_next - t2.t3_open_val_next as contra_tplus2_val,
    (cast(t0.t1_open_val_next as numeric (25,2)) - cast(t1.t2_open_val_next as numeric (25,2)))/nullif(cast(t0.t1_open_val_next as numeric (25,2)),0) + (cast(t1.t2_open_val_next as numeric (25,2)) - cast(t2.t3_open_val_next as numeric (25,2)))/nullif(cast(t0.t1_open_val_next as numeric (25,2)),0) as contra_ratio_val,
    (cast(t0.t1_open_val_next as numeric (25,2)) - cast(t1.t2_open_val_next as numeric (25,2)))/nullif(cast(t0.t1_open_val_next as numeric (25,2)),0) as contra_ratio_tplus1_val,
    (cast(t1.t2_open_val_next as numeric (25,2)) - cast(t2.t3_open_val_next as numeric (25,2)))/nullif(cast(t0.t1_open_val_next as numeric (25,2)),0) as contra_ratio_tplus2_val,    
    -- LOCAL 
    t0.local_t1_open_val_next,
    t1.local_t2_open_val_next,
    t2.local_t3_open_val_next,
    t0.local_t1_open_val_next - t1.local_t2_open_val_next as local_contra_tplus1_val,
    t1.local_t2_open_val_next - t2.local_t3_open_val_next as local_contra_tplus2_val,
    (cast(t0.local_t1_open_val_next as numeric (25,2)) - cast(t1.local_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.local_t1_open_val_next as numeric (25,2)),0) + (cast(t1.local_t2_open_val_next as numeric (25,2)) - cast(t2.local_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.local_t1_open_val_next as numeric (25,2)),0) as local_contra_ratio_val,
    (cast(t0.local_t1_open_val_next as numeric (25,2)) - cast(t1.local_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.local_t1_open_val_next as numeric (25,2)),0) as local_contra_ratio_tplus1_val,
    (cast(t1.local_t2_open_val_next as numeric (25,2)) - cast(t2.local_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.local_t1_open_val_next as numeric (25,2)),0) as local_contra_ratio_tplus2_val,      
    -- FOREIGN
	t0.foreign_t1_open_val_next,
    t1.foreign_t2_open_val_next,
    t2.foreign_t3_open_val_next,
    t0.foreign_t1_open_val_next - t1.foreign_t2_open_val_next as foreign_contra_tplus1_val,
    t1.foreign_t2_open_val_next - t2.foreign_t3_open_val_next as foreign_contra_tplus2_val,
    (cast(t0.foreign_t1_open_val_next as numeric (25,2)) - cast(t1.foreign_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_t1_open_val_next as numeric (25,2)),0) + (cast(t1.foreign_t2_open_val_next as numeric (25,2)) - cast(t2.foreign_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_t1_open_val_next as numeric (25,2)),0) as foreign_contra_ratio_val,
    (cast(t0.foreign_t1_open_val_next as numeric (25,2)) - cast(t1.foreign_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_t1_open_val_next as numeric (25,2)),0) as foreign_contra_ratio_tplus1_val,
    (cast(t1.foreign_t2_open_val_next as numeric (25,2)) - cast(t2.foreign_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_t1_open_val_next as numeric (25,2)),0) as foreign_contra_ratio_tplus2_val,      
    -- INST
	t0.inst_t1_open_val_next,
    t1.inst_t2_open_val_next,
    t2.inst_t3_open_val_next,
    t0.inst_t1_open_val_next - t1.inst_t2_open_val_next as inst_contra_tplus1_val,
    t1.inst_t2_open_val_next - t2.inst_t3_open_val_next as inst_contra_tplus2_val,
    (cast(t0.inst_t1_open_val_next as numeric (25,2)) - cast(t1.inst_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.inst_t1_open_val_next as numeric (25,2)),0) + (cast(t1.inst_t2_open_val_next as numeric (25,2)) - cast(t2.inst_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.inst_t1_open_val_next as numeric (25,2)),0) as inst_contra_ratio_val,
    (cast(t0.inst_t1_open_val_next as numeric (25,2)) - cast(t1.inst_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.inst_t1_open_val_next as numeric (25,2)),0) as inst_contra_ratio_tplus1_val,
    (cast(t1.inst_t2_open_val_next as numeric (25,2)) - cast(t2.inst_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.inst_t1_open_val_next as numeric (25,2)),0) as inst_contra_ratio_tplus2_val,      
    -- local_inst 
    t0.local_inst_t1_open_val_next,
    t1.local_inst_t2_open_val_next,
    t2.local_inst_t3_open_val_next,
    t0.local_inst_t1_open_val_next - t1.local_inst_t2_open_val_next as local_inst_contra_tplus1_val,
    t1.local_inst_t2_open_val_next - t2.local_inst_t3_open_val_next as local_inst_contra_tplus2_val,
    (cast(t0.local_inst_t1_open_val_next as numeric (25,2)) - cast(t1.local_inst_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.local_inst_t1_open_val_next as numeric (25,2)),0) + (cast(t1.local_inst_t2_open_val_next as numeric (25,2)) - cast(t2.local_inst_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.local_inst_t1_open_val_next as numeric (25,2)),0) as local_inst_contra_ratio_val,
    (cast(t0.local_inst_t1_open_val_next as numeric (25,2)) - cast(t1.local_inst_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.local_inst_t1_open_val_next as numeric (25,2)),0) as local_inst_contra_ratio_tplus1_val,
    (cast(t1.local_inst_t2_open_val_next as numeric (25,2)) - cast(t2.local_inst_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.local_inst_t1_open_val_next as numeric (25,2)),0) as local_inst_contra_ratio_tplus2_val,      
    -- foreign_inst
	t0.foreign_inst_t1_open_val_next,
    t1.foreign_inst_t2_open_val_next,
    t2.foreign_inst_t3_open_val_next,
    t0.foreign_inst_t1_open_val_next - t1.foreign_inst_t2_open_val_next as foreign_inst_contra_tplus1_val,
    t1.foreign_inst_t2_open_val_next - t2.foreign_inst_t3_open_val_next as foreign_inst_contra_tplus2_val,
    (cast(t0.foreign_inst_t1_open_val_next as numeric (25,2)) - cast(t1.foreign_inst_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_inst_t1_open_val_next as numeric (25,2)),0) + (cast(t1.foreign_inst_t2_open_val_next as numeric (25,2)) - cast(t2.foreign_inst_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_inst_t1_open_val_next as numeric (25,2)),0) as foreign_inst_contra_ratio_val,
    (cast(t0.foreign_inst_t1_open_val_next as numeric (25,2)) - cast(t1.foreign_inst_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_inst_t1_open_val_next as numeric (25,2)),0) as foreign_inst_contra_ratio_tplus1_val,
    (cast(t1.foreign_inst_t2_open_val_next as numeric (25,2)) - cast(t2.foreign_inst_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_inst_t1_open_val_next as numeric (25,2)),0) as foreign_inst_contra_ratio_tplus2_val,          
    -- retail
	t0.retail_t1_open_val_next,
    t1.retail_t2_open_val_next,
    t2.retail_t3_open_val_next,
    t0.retail_t1_open_val_next - t1.retail_t2_open_val_next as retail_contra_tplus1_val,
    t1.retail_t2_open_val_next - t2.retail_t3_open_val_next as retail_contra_tplus2_val,
    (cast(t0.retail_t1_open_val_next as numeric (25,2)) - cast(t1.retail_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.retail_t1_open_val_next as numeric (25,2)),0) + (cast(t1.retail_t2_open_val_next as numeric (25,2)) - cast(t2.retail_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.retail_t1_open_val_next as numeric (25,2)),0) as retail_contra_ratio_val,
    (cast(t0.retail_t1_open_val_next as numeric (25,2)) - cast(t1.retail_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.retail_t1_open_val_next as numeric (25,2)),0) as retail_contra_ratio_tplus1_val,
    (cast(t1.retail_t2_open_val_next as numeric (25,2)) - cast(t2.retail_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.retail_t1_open_val_next as numeric (25,2)),0) as retail_contra_ratio_tplus2_val,      
    -- local_retail 
    t0.local_retail_t1_open_val_next,
    t1.local_retail_t2_open_val_next,
    t2.local_retail_t3_open_val_next,
    t0.local_retail_t1_open_val_next - t1.local_retail_t2_open_val_next as local_retail_contra_tplus1_val,
    t1.local_retail_t2_open_val_next - t2.local_retail_t3_open_val_next as local_retail_contra_tplus2_val,
    (cast(t0.local_retail_t1_open_val_next as numeric (25,2)) - cast(t1.local_retail_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.local_retail_t1_open_val_next as numeric (25,2)),0) + (cast(t1.local_retail_t2_open_val_next as numeric (25,2)) - cast(t2.local_retail_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.local_retail_t1_open_val_next as numeric (25,2)),0) as local_retail_contra_ratio_val,
    (cast(t0.local_retail_t1_open_val_next as numeric (25,2)) - cast(t1.local_retail_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.local_retail_t1_open_val_next as numeric (25,2)),0) as local_retail_contra_ratio_tplus1_val,
    (cast(t1.local_retail_t2_open_val_next as numeric (25,2)) - cast(t2.local_retail_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.local_retail_t1_open_val_next as numeric (25,2)),0) as local_retail_contra_ratio_tplus2_val,      
    -- foreign_retail
	t0.foreign_retail_t1_open_val_next,
    t1.foreign_retail_t2_open_val_next,
    t2.foreign_retail_t3_open_val_next,
    t0.foreign_retail_t1_open_val_next - t1.foreign_retail_t2_open_val_next as foreign_retail_contra_tplus1_val,
    t1.foreign_retail_t2_open_val_next - t2.foreign_retail_t3_open_val_next as foreign_retail_contra_tplus2_val,
    (cast(t0.foreign_retail_t1_open_val_next as numeric (25,2)) - cast(t1.foreign_retail_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_retail_t1_open_val_next as numeric (25,2)),0) + (cast(t1.foreign_retail_t2_open_val_next as numeric (25,2)) - cast(t2.foreign_retail_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_retail_t1_open_val_next as numeric (25,2)),0) as foreign_retail_contra_ratio_val,
    (cast(t0.foreign_retail_t1_open_val_next as numeric (25,2)) - cast(t1.foreign_retail_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_retail_t1_open_val_next as numeric (25,2)),0) as foreign_retail_contra_ratio_tplus1_val,
    (cast(t1.foreign_retail_t2_open_val_next as numeric (25,2)) - cast(t2.foreign_retail_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_retail_t1_open_val_next as numeric (25,2)),0) as foreign_retail_contra_ratio_tplus2_val,              
    -- nom
	t0.nom_t1_open_val_next,
    t1.nom_t2_open_val_next,
    t2.nom_t3_open_val_next,
    t0.nom_t1_open_val_next - t1.nom_t2_open_val_next as nom_contra_tplus1_val,
    t1.nom_t2_open_val_next - t2.nom_t3_open_val_next as nom_contra_tplus2_val,
    (cast(t0.nom_t1_open_val_next as numeric (25,2)) - cast(t1.nom_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.nom_t1_open_val_next as numeric (25,2)),0) + (cast(t1.nom_t2_open_val_next as numeric (25,2)) - cast(t2.nom_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.nom_t1_open_val_next as numeric (25,2)),0) as nom_contra_ratio_val,
    (cast(t0.nom_t1_open_val_next as numeric (25,2)) - cast(t1.nom_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.nom_t1_open_val_next as numeric (25,2)),0) as nom_contra_ratio_tplus1_val,
    (cast(t1.nom_t2_open_val_next as numeric (25,2)) - cast(t2.nom_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.nom_t1_open_val_next as numeric (25,2)),0) as nom_contra_ratio_tplus2_val,      
    -- local_nom 
    t0.local_nom_t1_open_val_next,
    t1.local_nom_t2_open_val_next,
    t2.local_nom_t3_open_val_next,
    t0.local_nom_t1_open_val_next - t1.local_nom_t2_open_val_next as local_nom_contra_tplus1_val,
    t1.local_nom_t2_open_val_next - t2.local_nom_t3_open_val_next as local_nom_contra_tplus2_val,
    (cast(t0.local_nom_t1_open_val_next as numeric (25,2)) - cast(t1.local_nom_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.local_nom_t1_open_val_next as numeric (25,2)),0) + (cast(t1.local_nom_t2_open_val_next as numeric (25,2)) - cast(t2.local_nom_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.local_nom_t1_open_val_next as numeric (25,2)),0) as local_nom_contra_ratio_val,
    (cast(t0.local_nom_t1_open_val_next as numeric (25,2)) - cast(t1.local_nom_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.local_nom_t1_open_val_next as numeric (25,2)),0) as local_nom_contra_ratio_tplus1_val,
    (cast(t1.local_nom_t2_open_val_next as numeric (25,2)) - cast(t2.local_nom_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.local_nom_t1_open_val_next as numeric (25,2)),0) as local_nom_contra_ratio_tplus2_val,      
    -- foreign_nom
    t0.foreign_nom_t1_open_val_next,
    t1.foreign_nom_t2_open_val_next,
    t2.foreign_nom_t3_open_val_next,
    t0.foreign_nom_t1_open_val_next - t1.foreign_nom_t2_open_val_next as foreign_nom_contra_tplus1_val,
    t1.foreign_nom_t2_open_val_next - t2.foreign_nom_t3_open_val_next as foreign_nom_contra_tplus2_val,
    (cast(t0.foreign_nom_t1_open_val_next as numeric (25,2)) - cast(t1.foreign_nom_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_nom_t1_open_val_next as numeric (25,2)),0) + (cast(t1.foreign_nom_t2_open_val_next as numeric (25,2)) - cast(t2.foreign_nom_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_nom_t1_open_val_next as numeric (25,2)),0) as foreign_nom_contra_ratio_val,
    (cast(t0.foreign_nom_t1_open_val_next as numeric (25,2)) - cast(t1.foreign_nom_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_nom_t1_open_val_next as numeric (25,2)),0) as foreign_nom_contra_ratio_tplus1_val,
    (cast(t1.foreign_nom_t2_open_val_next as numeric (25,2)) - cast(t2.foreign_nom_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.foreign_nom_t1_open_val_next as numeric (25,2)),0) as foreign_nom_contra_ratio_tplus2_val,                  
    -- pdt
	t0.pdt_t1_open_val_next,
    t1.pdt_t2_open_val_next,
    t2.pdt_t3_open_val_next,
    t0.pdt_t1_open_val_next - t1.pdt_t2_open_val_next as pdt_contra_tplus1_val,
    t1.pdt_t2_open_val_next - t2.pdt_t3_open_val_next as pdt_contra_tplus2_val,
    (cast(t0.pdt_t1_open_val_next as numeric (25,2)) - cast(t1.pdt_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.pdt_t1_open_val_next as numeric (25,2)),0) + (cast(t1.pdt_t2_open_val_next as numeric (25,2)) - cast(t2.pdt_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.pdt_t1_open_val_next as numeric (25,2)),0) as pdt_contra_ratio_val,
    (cast(t0.pdt_t1_open_val_next as numeric (25,2)) - cast(t1.pdt_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.pdt_t1_open_val_next as numeric (25,2)),0) as pdt_contra_ratio_tplus1_val,
    (cast(t1.pdt_t2_open_val_next as numeric (25,2)) - cast(t2.pdt_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.pdt_t1_open_val_next as numeric (25,2)),0) as pdt_contra_ratio_tplus2_val,          
    -- ivt
    t0.ivt_t1_open_val_next,
    t1.ivt_t2_open_val_next,
    t2.ivt_t3_open_val_next,
    t0.ivt_t1_open_val_next - t1.ivt_t2_open_val_next as ivt_contra_tplus1_val,
    t1.ivt_t2_open_val_next - t2.ivt_t3_open_val_next as ivt_contra_tplus2_val,
    (cast(t0.ivt_t1_open_val_next as numeric (25,2)) - cast(t1.ivt_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.ivt_t1_open_val_next as numeric (25,2)),0) + (cast(t1.ivt_t2_open_val_next as numeric (25,2)) - cast(t2.ivt_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.ivt_t1_open_val_next as numeric (25,2)),0) as ivt_contra_ratio_val,
    (cast(t0.ivt_t1_open_val_next as numeric (25,2)) - cast(t1.ivt_t2_open_val_next as numeric (25,2)))/nullif(cast(t0.ivt_t1_open_val_next as numeric (25,2)),0) as ivt_contra_ratio_tplus1_val,
    (cast(t1.ivt_t2_open_val_next as numeric (25,2)) - cast(t2.ivt_t3_open_val_next as numeric (25,2)))/nullif(cast(t0.ivt_t1_open_val_next as numeric (25,2)),0) as ivt_contra_ratio_tplus2_val,
    -- prop
    NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) as prop_t1_open_val_next,
    NULLIF((COALESCE(t1.ivt_t2_open_val_next,0) + COALESCE(t1.pdt_t2_open_val_next,0)),0) as prop_t2_open_val_next,
    NULLIF((COALESCE(t2.ivt_t3_open_val_next,0) + COALESCE(t2.pdt_t3_open_val_next,0)),0) as prop_t3_open_val_next,
    NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) - NULLIF((COALESCE(t1.ivt_t2_open_val_next,0) + COALESCE(t1.pdt_t2_open_val_next,0)),0) as prop_contra_tplus1_val,
	NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) - NULLIF((COALESCE(t2.ivt_t3_open_val_next,0) + COALESCE(t2.pdt_t3_open_val_next,0)),0) as prop_contra_tplus2_val,
    (cast(NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.ivt_t2_open_val_next,0) + COALESCE(t1.pdt_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.ivt_t2_open_val_next,0) + COALESCE(t1.pdt_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.ivt_t3_open_val_next,0) + COALESCE(t2.pdt_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) as numeric (25,2)),0) as prop_contra_ratio_val,
    (cast(NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.ivt_t2_open_val_next,0) + COALESCE(t1.pdt_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) as numeric (25,2)),0) as prop_contra_ratio_tplus1_val,
    (cast(NULLIF((COALESCE(t1.ivt_t2_open_val_next,0) + COALESCE(t1.pdt_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.ivt_t3_open_val_next,0) + COALESCE(t2.pdt_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.ivt_t1_open_val_next,0) + COALESCE(t0.pdt_t1_open_val_next,0)),0) as numeric (25,2)),0) as prop_contra_ratio_tplus2_val,
    -- inst_nom
    NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as inst_nom_t1_open_val_next,
    NULLIF((COALESCE(t1.inst_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as inst_nom_t2_open_val_next,
    NULLIF((COALESCE(t2.inst_t3_open_val_next,0) + COALESCE(t2.nom_t3_open_val_next,0)),0) as inst_nom_t3_open_val_next,
    NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t1.inst_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as inst_nom_contra_tplus1_val,
	NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t2.inst_t3_open_val_next,0) + COALESCE(t2.nom_t3_open_val_next,0)),0) as inst_nom_contra_tplus2_val,
    (cast(NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.inst_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.inst_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.inst_t3_open_val_next,0) + COALESCE(t2.nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as inst_nom_contra_ratio_val,
    (cast(NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.inst_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as inst_nom_contra_ratio_tplus1_val,
    (cast(NULLIF((COALESCE(t1.inst_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.inst_t3_open_val_next,0) + COALESCE(t2.nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.inst_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as inst_nom_contra_ratio_tplus2_val,
    -- local_inst_nom
    NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as local_inst_nom_t1_open_val_next,
    NULLIF((COALESCE(t1.local_inst_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as local_inst_nom_t2_open_val_next,
    NULLIF((COALESCE(t2.local_inst_t3_open_val_next,0) + COALESCE(t2.local_nom_t3_open_val_next,0)),0) as local_inst_nom_t3_open_val_next,
    NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t1.local_inst_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as local_inst_nom_contra_tplus1_val,
	NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t2.local_inst_t3_open_val_next,0) + COALESCE(t2.local_nom_t3_open_val_next,0)),0) as local_inst_nom_contra_tplus2_val,
    (cast(NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.local_inst_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.local_inst_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.local_inst_t3_open_val_next,0) + COALESCE(t2.local_nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as local_inst_nom_contra_ratio_val,
    (cast(NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.local_inst_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as local_inst_nom_contra_ratio_tplus1_val,
    (cast(NULLIF((COALESCE(t1.local_inst_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.local_inst_t3_open_val_next,0) + COALESCE(t2.local_nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_inst_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as local_inst_nom_contra_ratio_tplus2_val,
    -- foreign_inst_nom
    NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as foreign_inst_nom_t1_open_val_next,
    NULLIF((COALESCE(t1.foreign_inst_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as foreign_inst_nom_t2_open_val_next,
    NULLIF((COALESCE(t2.foreign_inst_t3_open_val_next,0) + COALESCE(t2.foreign_nom_t3_open_val_next,0)),0) as foreign_inst_nom_t3_open_val_next,
    NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t1.foreign_inst_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as foreign_inst_nom_contra_tplus1_val,
	NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t2.foreign_inst_t3_open_val_next,0) + COALESCE(t2.foreign_nom_t3_open_val_next,0)),0) as foreign_inst_nom_contra_tplus2_val,
    (cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.foreign_inst_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.foreign_inst_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.foreign_inst_t3_open_val_next,0) + COALESCE(t2.foreign_nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as foreign_inst_nom_contra_ratio_val,
    (cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.foreign_inst_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as foreign_inst_nom_contra_ratio_tplus1_val,
    (cast(NULLIF((COALESCE(t1.foreign_inst_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.foreign_inst_t3_open_val_next,0) + COALESCE(t2.foreign_nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_inst_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as foreign_inst_nom_contra_ratio_tplus2_val,
    -- retail_nom
    NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as retail_nom_t1_open_val_next,
    NULLIF((COALESCE(t1.retail_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as retail_nom_t2_open_val_next,
    NULLIF((COALESCE(t2.retail_t3_open_val_next,0) + COALESCE(t2.nom_t3_open_val_next,0)),0) as retail_nom_t3_open_val_next,
    NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t1.retail_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as retail_nom_contra_tplus1_val,
    NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t2.retail_t3_open_val_next,0) + COALESCE(t2.nom_t3_open_val_next,0)),0) as retail_nom_contra_tplus2_val,
    (cast(NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.retail_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.retail_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.retail_t3_open_val_next,0) + COALESCE(t2.nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as retail_nom_contra_ratio_val,
    (cast(NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.retail_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as retail_nom_contra_ratio_tplus1_val,
    (cast(NULLIF((COALESCE(t1.retail_t2_open_val_next,0) + COALESCE(t1.nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.retail_t3_open_val_next,0) + COALESCE(t2.nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.retail_t1_open_val_next,0) + COALESCE(t0.nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as retail_nom_contra_ratio_tplus2_val,
    -- local_retail_nom
    NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as local_retail_nom_t1_open_val_next,
    NULLIF((COALESCE(t1.local_retail_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as local_retail_nom_t2_open_val_next,
    NULLIF((COALESCE(t2.local_retail_t3_open_val_next,0) + COALESCE(t2.local_nom_t3_open_val_next,0)),0) as local_retail_nom_t3_open_val_next,
    NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t1.local_retail_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as local_retail_nom_contra_tplus1_val,
    NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t2.local_retail_t3_open_val_next,0) + COALESCE(t2.local_nom_t3_open_val_next,0)),0) as local_retail_nom_contra_tplus2_val,
    (cast(NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.local_retail_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.local_retail_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.local_retail_t3_open_val_next,0) + COALESCE(t2.local_nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as local_retail_nom_contra_ratio_val,
    (cast(NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.local_retail_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as local_retail_nom_contra_ratio_tplus1_val,
    (cast(NULLIF((COALESCE(t1.local_retail_t2_open_val_next,0) + COALESCE(t1.local_nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.local_retail_t3_open_val_next,0) + COALESCE(t2.local_nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.local_retail_t1_open_val_next,0) + COALESCE(t0.local_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as local_retail_nom_contra_ratio_tplus2_val,
    -- foreign_retail_nom
    NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as foreign_retail_nom_t1_open_val_next,
    NULLIF((COALESCE(t1.foreign_retail_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as foreign_retail_nom_t2_open_val_next,
    NULLIF((COALESCE(t2.foreign_retail_t3_open_val_next,0) + COALESCE(t2.foreign_nom_t3_open_val_next,0)),0) as foreign_retail_nom_t3_open_val_next,
    NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t1.foreign_retail_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as foreign_retail_nom_contra_tplus1_val,
    NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) - NULLIF((COALESCE(t2.foreign_retail_t3_open_val_next,0) + COALESCE(t2.foreign_nom_t3_open_val_next,0)),0) as foreign_retail_nom_contra_tplus2_val,
    (cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.foreign_retail_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) + (cast(NULLIF((COALESCE(t1.foreign_retail_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.foreign_retail_t3_open_val_next,0) + COALESCE(t2.foreign_nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as foreign_retail_nom_contra_ratio_val,
    (cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t1.foreign_retail_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as foreign_retail_nom_contra_ratio_tplus1_val,
    (cast(NULLIF((COALESCE(t1.foreign_retail_t2_open_val_next,0) + COALESCE(t1.foreign_nom_t2_open_val_next,0)),0) as numeric (25,2)) - cast(NULLIF((COALESCE(t2.foreign_retail_t3_open_val_next,0) + COALESCE(t2.foreign_nom_t3_open_val_next,0)),0) as numeric (25,2)))/nullif(cast(NULLIF((COALESCE(t0.foreign_retail_t1_open_val_next,0) + COALESCE(t0.foreign_nom_t1_open_val_next,0)),0) as numeric (25,2)),0) as foreign_retail_nom_contra_ratio_tplus2_val
   FROM dibots_v2.exchange_contra_ff_stock t0
     LEFT JOIN dibots_v2.exchange_contra_ff_stock t1 ON t0.t0_date = t1.tminus1_date AND t0.stock_code = t1.stock_code
     LEFT JOIN dibots_v2.exchange_contra_ff_stock t2 ON t0.t0_date = t2.tminus2_date AND t0.stock_code = t2.stock_code;

create unique index contra_ratio_uniq on dibots_v2.exchange_contra_movement_ratio_mview (t0_date, stock_num);


--=====================
-- CONTRA_FORWARD_VIEW
--=====================

--drop view dibots_v2.contra_forward_view;
create or replace view dibots_v2.contra_forward_view as
SELECT t0.t0_date,
    t1.t0_date AS tplus1_date,
    t2.t0_date AS tplus2_date,
    t0.stock_code,
    t0.stock_name,
    t0.stock_num,
    t0.board,
    t0.sector,
    t0.klci_flag,
    t0.fbm100_flag,
    t0.shariah_flag,
    t0.f4gbm_flag,
    t0.t1_open_vol_next,
    t1.t2_open_vol_next,
    t2.t3_open_vol_next,
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.t2_open_vol_next, 0::bigint) - COALESCE(t0.t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.t3_open_vol_next, 0::bigint) - COALESCE(t1.t2_open_vol_next, 0::bigint) + (COALESCE(t1.t2_open_vol_next, 0::bigint) - COALESCE(t0.t1_open_vol_next, 0::bigint)))
        END AS vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else abs(COALESCE(t1.t2_open_vol_next, 0::bigint) - COALESCE(t0.t1_open_vol_next, 0::bigint)) end vol_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.t3_open_vol_next, 0::bigint) - COALESCE(t1.t2_open_vol_next, 0::bigint)) end  vol_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.local_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.local_t3_open_vol_next, 0::bigint) - COALESCE(t1.local_t2_open_vol_next, 0::bigint) + (COALESCE(t1.local_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_t1_open_vol_next, 0::bigint)))
        END AS local_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.local_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_t1_open_vol_next, 0::bigint)) end  local_vol_contra_forward_t1,             
case when   t2.t0_date is null  then null
else   
abs(COALESCE(t2.local_t3_open_vol_next, 0::bigint) - COALESCE(t1.local_t2_open_vol_next, 0::bigint)) end  local_vol_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.foreign_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.foreign_t3_open_vol_next, 0::bigint) - COALESCE(t1.foreign_t2_open_vol_next, 0::bigint) + (COALESCE(t1.foreign_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_t1_open_vol_next, 0::bigint)))
        END AS foreign_vol_contra_forward,
        case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.foreign_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_t1_open_vol_next, 0::bigint)) end  foreign_vol_contra_forward_t1,       
case when  t2.t0_date is null  then null
else 
abs(COALESCE(t2.foreign_t3_open_vol_next, 0::bigint) - COALESCE(t1.foreign_t2_open_vol_next, 0::bigint)) end  foreign_vol_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.inst_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.inst_t3_open_vol_next, 0::bigint) - COALESCE(t1.inst_t2_open_vol_next, 0::bigint) + (COALESCE(t1.inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.inst_t1_open_vol_next, 0::bigint)))
        END AS inst_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.inst_t1_open_vol_next, 0::bigint)) end  inst_vol_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.inst_t3_open_vol_next, 0::bigint) - COALESCE(t1.inst_t2_open_vol_next, 0::bigint)) end  inst_vol_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.local_inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_inst_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.local_inst_t3_open_vol_next, 0::bigint) - COALESCE(t1.local_inst_t2_open_vol_next, 0::bigint) + (COALESCE(t1.local_inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_inst_t1_open_vol_next, 0::bigint)))
        END AS local_inst_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.local_inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_inst_t1_open_vol_next, 0::bigint)) end  local_inst_vol_contra_forward_t1,          
case when  t2.t0_date is null  then null
else      
abs(COALESCE(t2.local_inst_t3_open_vol_next, 0::bigint) - COALESCE(t1.local_inst_t2_open_vol_next, 0::bigint)) end  local_inst_vol_contra_forward_t2,       
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.foreign_inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_inst_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.foreign_inst_t3_open_vol_next, 0::bigint) - COALESCE(t1.foreign_inst_t2_open_vol_next, 0::bigint) + (COALESCE(t1.foreign_inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_inst_t1_open_vol_next, 0::bigint)))
        END AS foreign_inst_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.foreign_inst_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_inst_t1_open_vol_next, 0::bigint)) end  foreign_inst_vol_contra_forward_t1,       
case when  t2.t0_date is null  then null
else 
abs(COALESCE(t2.foreign_inst_t3_open_vol_next, 0::bigint) - COALESCE(t1.foreign_inst_t2_open_vol_next, 0::bigint)) end  foreign_inst_vol_contra_forward_t2,         
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.retail_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.retail_t3_open_vol_next, 0::bigint) - COALESCE(t1.retail_t2_open_vol_next, 0::bigint) + (COALESCE(t1.retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.retail_t1_open_vol_next, 0::bigint)))
        END AS retail_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.retail_t1_open_vol_next, 0::bigint)) end  retail_vol_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.retail_t3_open_vol_next, 0::bigint) - COALESCE(t1.retail_t2_open_vol_next, 0::bigint)) end  retail_vol_contra_forward_t2,       
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.local_retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_retail_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.local_retail_t3_open_vol_next, 0::bigint) - COALESCE(t1.local_retail_t2_open_vol_next, 0::bigint) + (COALESCE(t1.local_retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_retail_t1_open_vol_next, 0::bigint)))
        END AS local_retail_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.local_retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_retail_t1_open_vol_next, 0::bigint)) end  local_retail_vol_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.local_retail_t3_open_vol_next, 0::bigint) - COALESCE(t1.local_retail_t2_open_vol_next, 0::bigint)) end  local_retail_vol_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.foreign_retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_retail_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.foreign_retail_t3_open_vol_next, 0::bigint) - COALESCE(t1.foreign_retail_t2_open_vol_next, 0::bigint) + (COALESCE(t1.foreign_retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_retail_t1_open_vol_next, 0::bigint)))
        END AS foreign_retail_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.foreign_retail_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_retail_t1_open_vol_next, 0::bigint)) end  foreign_retail_vol_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.foreign_retail_t3_open_vol_next, 0::bigint) - COALESCE(t1.foreign_retail_t2_open_vol_next, 0::bigint)) end  foreign_retail_vol_contra_forward_t2,             
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.nom_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.nom_t3_open_vol_next, 0::bigint) - COALESCE(t1.nom_t2_open_vol_next, 0::bigint) + (COALESCE(t1.nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.nom_t1_open_vol_next, 0::bigint)))
        END AS nom_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.nom_t1_open_vol_next, 0::bigint)) end  nom_vol_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.nom_t3_open_vol_next, 0::bigint) - COALESCE(t1.nom_t2_open_vol_next, 0::bigint)) end  nom_vol_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.local_nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_nom_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.local_nom_t3_open_vol_next, 0::bigint) - COALESCE(t1.local_nom_t2_open_vol_next, 0::bigint) + (COALESCE(t1.local_nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_nom_t1_open_vol_next, 0::bigint)))
        END AS local_nom_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.local_nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.local_nom_t1_open_vol_next, 0::bigint)) end  local_nom_vol_contra_forward_t1,       
case when  t2.t0_date is null  then null
else 
abs(COALESCE(t2.local_nom_t3_open_vol_next, 0::bigint) - COALESCE(t1.local_nom_t2_open_vol_next, 0::bigint)) end  local_nom_vol_contra_forward_t2,        
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.foreign_nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_nom_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.foreign_nom_t3_open_vol_next, 0::bigint) - COALESCE(t1.foreign_nom_t2_open_vol_next, 0::bigint) + (COALESCE(t1.foreign_nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_nom_t1_open_vol_next, 0::bigint)))
        END AS foreign_nom_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.foreign_nom_t2_open_vol_next, 0::bigint) - COALESCE(t0.foreign_nom_t1_open_vol_next, 0::bigint)) end  foreign_nom_vol_contra_forward_t1,       
case when  t2.t0_date is null  then null
else 
abs(COALESCE(t2.foreign_nom_t3_open_vol_next, 0::bigint) - COALESCE(t1.foreign_nom_t2_open_vol_next, 0::bigint)) end  foreign_nom_vol_contra_forward_t2,             
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.ivt_t2_open_vol_next, 0::bigint) - COALESCE(t0.ivt_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.ivt_t3_open_vol_next, 0::bigint) - COALESCE(t1.ivt_t2_open_vol_next, 0::bigint) + (COALESCE(t1.ivt_t2_open_vol_next, 0::bigint) - COALESCE(t0.ivt_t1_open_vol_next, 0::bigint)))
        END AS ivt_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.ivt_t2_open_vol_next, 0::bigint) - COALESCE(t0.ivt_t1_open_vol_next, 0::bigint)) end  ivt_vol_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.ivt_t3_open_vol_next, 0::bigint) - COALESCE(t1.ivt_t2_open_vol_next, 0::bigint)) end  ivt_vol_contra_forward_t2,           
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.pdt_t2_open_vol_next, 0::bigint) - COALESCE(t0.pdt_t1_open_vol_next, 0::bigint))
            ELSE abs(COALESCE(t2.pdt_t3_open_vol_next, 0::bigint) - COALESCE(t1.pdt_t2_open_vol_next, 0::bigint) + (COALESCE(t1.pdt_t2_open_vol_next, 0::bigint) - COALESCE(t0.pdt_t1_open_vol_next, 0::bigint)))
        END AS pdt_vol_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.pdt_t2_open_vol_next, 0::bigint) - COALESCE(t0.pdt_t1_open_vol_next, 0::bigint)) end  pdt_vol_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.pdt_t3_open_vol_next, 0::bigint) - COALESCE(t1.pdt_t2_open_vol_next, 0::bigint)) end  pdt_vol_contra_forward_t2,             
    t0.t1_open_val_next,
    t1.t2_open_val_next,
    t2.t3_open_val_next,
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.t2_open_val_next, 0::bigint) - COALESCE(t0.t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.t3_open_val_next, 0::bigint) - COALESCE(t1.t2_open_val_next, 0::bigint) + (COALESCE(t1.t2_open_val_next, 0::bigint) - COALESCE(t0.t1_open_val_next, 0::bigint)))
        END AS val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.t2_open_val_next, 0::bigint) - COALESCE(t0.t1_open_val_next, 0::bigint)) end  val_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.t3_open_val_next, 0::bigint) - COALESCE(t1.t2_open_val_next, 0::bigint)) end  val_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.local_t2_open_val_next, 0::bigint) - COALESCE(t0.local_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.local_t3_open_val_next, 0::bigint) - COALESCE(t1.local_t2_open_val_next, 0::bigint) + (COALESCE(t1.local_t2_open_val_next, 0::bigint) - COALESCE(t0.local_t1_open_val_next, 0::bigint)))
        END AS local_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.local_t2_open_val_next, 0::bigint) - COALESCE(t0.local_t1_open_val_next, 0::bigint)) end  local_val_contra_forward_t1,           
case when t2.t0_date is null  then null
else     
abs(COALESCE(t2.local_t3_open_val_next, 0::bigint) - COALESCE(t1.local_t2_open_val_next, 0::bigint)) end  local_val_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.foreign_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.foreign_t3_open_val_next, 0::bigint) - COALESCE(t1.foreign_t2_open_val_next, 0::bigint) + (COALESCE(t1.foreign_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_t1_open_val_next, 0::bigint)))
        END AS foreign_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.foreign_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_t1_open_val_next, 0::bigint))  end foreign_val_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.foreign_t3_open_val_next, 0::bigint) - COALESCE(t1.foreign_t2_open_val_next, 0::bigint)) end  foreign_val_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.inst_t2_open_val_next, 0::bigint) - COALESCE(t0.inst_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.inst_t3_open_val_next, 0::bigint) - COALESCE(t1.inst_t2_open_val_next, 0::bigint) + (COALESCE(t1.inst_t2_open_val_next, 0::bigint) - COALESCE(t0.inst_t1_open_val_next, 0::bigint)))
        END AS inst_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.inst_t2_open_val_next, 0::bigint) - COALESCE(t0.inst_t1_open_val_next, 0::bigint))  end inst_val_contra_forward_t1,       
case when  t2.t0_date is null  then null
else 
abs(COALESCE(t2.inst_t3_open_val_next, 0::bigint) - COALESCE(t1.inst_t2_open_val_next, 0::bigint)) end  inst_val_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.local_inst_t2_open_val_next, 0::bigint) - COALESCE(t0.local_inst_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.local_inst_t3_open_val_next, 0::bigint) - COALESCE(t1.local_inst_t2_open_val_next, 0::bigint) + (COALESCE(t1.local_inst_t2_open_val_next, 0::bigint) - COALESCE(t0.local_inst_t1_open_val_next, 0::bigint)))
        END AS local_inst_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.local_inst_t2_open_val_next, 0::bigint) - COALESCE(t0.local_inst_t1_open_val_next, 0::bigint))  end local_inst_val_contra_forward_t1,        
case when t1.t0_date is null and t2.t0_date is null  then null
else        
abs(COALESCE(t2.local_inst_t3_open_val_next, 0::bigint) - COALESCE(t1.local_inst_t2_open_val_next, 0::bigint)) end  local_inst_val_contra_forward_t2,       
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.foreign_inst_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_inst_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.foreign_inst_t3_open_val_next, 0::bigint) - COALESCE(t1.foreign_inst_t2_open_val_next, 0::bigint) + (COALESCE(t1.foreign_inst_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_inst_t1_open_val_next, 0::bigint)))
        END AS foreign_inst_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.foreign_inst_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_inst_t1_open_val_next, 0::bigint)) end  foreign_inst_val_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.foreign_inst_t3_open_val_next, 0::bigint) - COALESCE(t1.foreign_inst_t2_open_val_next, 0::bigint)) end  foreign_inst_val_contra_forward_t2,         
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.retail_t2_open_val_next, 0::bigint) - COALESCE(t0.retail_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.retail_t3_open_val_next, 0::bigint) - COALESCE(t1.retail_t2_open_val_next, 0::bigint) + (COALESCE(t1.retail_t2_open_val_next, 0::bigint) - COALESCE(t0.retail_t1_open_val_next, 0::bigint)))
        END AS retail_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.retail_t2_open_val_next, 0::bigint) - COALESCE(t0.retail_t1_open_val_next, 0::bigint)) end  retail_val_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.retail_t3_open_val_next, 0::bigint) - COALESCE(t1.retail_t2_open_val_next, 0::bigint)) end  retail_val_contra_forward_t2,       
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.local_retail_t2_open_val_next, 0::bigint) - COALESCE(t0.local_retail_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.local_retail_t3_open_val_next, 0::bigint) - COALESCE(t1.local_retail_t2_open_val_next, 0::bigint) + (COALESCE(t1.local_retail_t2_open_val_next, 0::bigint) - COALESCE(t0.local_retail_t1_open_val_next, 0::bigint)))
        END AS local_retail_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.local_retail_t2_open_val_next, 0::bigint) - COALESCE(t0.local_retail_t1_open_val_next, 0::bigint)) end  local_retail_val_contra_forward_t1,       
case when t2.t0_date is null  then null
else 
abs(COALESCE(t2.local_retail_t3_open_val_next, 0::bigint) - COALESCE(t1.local_retail_t2_open_val_next, 0::bigint)) end  local_retail_val_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.foreign_retail_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_retail_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.foreign_retail_t3_open_val_next, 0::bigint) - COALESCE(t1.foreign_retail_t2_open_val_next, 0::bigint) + (COALESCE(t1.foreign_retail_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_retail_t1_open_val_next, 0::bigint)))
        END AS foreign_retail_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.foreign_retail_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_retail_t1_open_val_next, 0::bigint)) end  foreign_retail_val_contra_forward_t1,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t2.foreign_retail_t3_open_val_next, 0::bigint) - COALESCE(t1.foreign_retail_t2_open_val_next, 0::bigint)) end  foreign_retail_val_contra_forward_t2,             
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.nom_t2_open_val_next, 0::bigint) - COALESCE(t0.nom_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.nom_t3_open_val_next, 0::bigint) - COALESCE(t1.nom_t2_open_val_next, 0::bigint) + (COALESCE(t1.nom_t2_open_val_next, 0::bigint) - COALESCE(t0.nom_t1_open_val_next, 0::bigint)))
        END AS nom_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.nom_t2_open_val_next, 0::bigint) - COALESCE(t0.nom_t1_open_val_next, 0::bigint)) end  nom_val_contra_forward_t1,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t2.nom_t3_open_val_next, 0::bigint) - COALESCE(t1.nom_t2_open_val_next, 0::bigint)) end  nom_val_contra_forward_t2,     
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.local_nom_t2_open_val_next, 0::bigint) - COALESCE(t0.local_nom_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.local_nom_t3_open_val_next, 0::bigint) - COALESCE(t1.local_nom_t2_open_val_next, 0::bigint) + (COALESCE(t1.local_nom_t2_open_val_next, 0::bigint) - COALESCE(t0.local_nom_t1_open_val_next, 0::bigint)))
        END AS local_nom_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.local_nom_t2_open_val_next, 0::bigint) - COALESCE(t0.local_nom_t1_open_val_next, 0::bigint)) end  local_nom_val_contra_forward_t1,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t2.local_nom_t3_open_val_next, 0::bigint) - COALESCE(t1.local_nom_t2_open_val_next, 0::bigint)) end  local_nom_val_contra_forward_t2,        
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.foreign_nom_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_nom_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.foreign_nom_t3_open_val_next, 0::bigint) - COALESCE(t1.foreign_nom_t2_open_val_next, 0::bigint) + (COALESCE(t1.foreign_nom_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_nom_t1_open_val_next, 0::bigint)))
        END AS foreign_nom_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.foreign_nom_t2_open_val_next, 0::bigint) - COALESCE(t0.foreign_nom_t1_open_val_next, 0::bigint)) end  foreign_nom_val_contra_forward_t1,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t2.foreign_nom_t3_open_val_next, 0::bigint) - COALESCE(t1.foreign_nom_t2_open_val_next, 0::bigint)) end  foreign_nom_val_contra_forward_t2,             
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.ivt_t2_open_val_next, 0::bigint) - COALESCE(t0.ivt_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.ivt_t3_open_val_next, 0::bigint) - COALESCE(t1.ivt_t2_open_val_next, 0::bigint) + (COALESCE(t1.ivt_t2_open_val_next, 0::bigint) - COALESCE(t0.ivt_t1_open_val_next, 0::bigint)))
        END AS ivt_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.ivt_t2_open_val_next, 0::bigint) - COALESCE(t0.ivt_t1_open_val_next, 0::bigint)) end  ivt_val_contra_forward_t1,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t2.ivt_t3_open_val_next, 0::bigint) - COALESCE(t1.ivt_t2_open_val_next, 0::bigint)) end  ivt_val_contra_forward_t2,           
        CASE
            WHEN t1.t0_date IS NULL AND t2.t0_date IS NULL THEN 0::bigint
            WHEN t2.t0_date IS NULL THEN abs(COALESCE(t1.pdt_t2_open_val_next, 0::bigint) - COALESCE(t0.pdt_t1_open_val_next, 0::bigint))
            ELSE abs(COALESCE(t2.pdt_t3_open_val_next, 0::bigint) - COALESCE(t1.pdt_t2_open_val_next, 0::bigint) + (COALESCE(t1.pdt_t2_open_val_next, 0::bigint) - COALESCE(t0.pdt_t1_open_val_next, 0::bigint)))
        END AS pdt_val_contra_forward,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t1.pdt_t2_open_val_next, 0::bigint) - COALESCE(t0.pdt_t1_open_val_next, 0::bigint)) end  pdt_val_contra_forward_t1,       
case when t1.t0_date is null and t2.t0_date is null  then null
else 
abs(COALESCE(t2.pdt_t3_open_val_next, 0::bigint) - COALESCE(t1.pdt_t2_open_val_next, 0::bigint)) end  pdt_val_contra_forward_t2
   FROM dibots_v2.exchange_contra_ff_stock t0
     LEFT JOIN dibots_v2.exchange_contra_ff_stock t1 ON t0.t0_date = t1.tminus1_date AND t0.stock_code = t1.stock_code
     LEFT JOIN dibots_v2.exchange_contra_ff_stock t2 ON t0.t0_date = t2.tminus2_date AND t0.stock_code = t2.stock_code;

