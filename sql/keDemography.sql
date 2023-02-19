-- DEMOGRAPHY breakdown by board, sector and group type

-- daily
select board, sector, sum(net_value) as net_val, sum(net_local_value) as net_local_val, sum(net_foreign_value) as net_foreign_val, 
sum(net_inst_value) as net_inst_val, sum(net_local_inst_val) as net_local_inst_val, sum(net_foreign_inst_val) as net_foreign_inst_val, 
sum(net_retail_value) as net_retail_val, sum(net_local_retail_val) as net_local_retail_val, sum(net_foreign_retail_val) as net_foreign_retail_val,
sum(net_nominees_value) as net_nominees_val, sum(net_local_nominees_val) as net_local_nom_val, sum(net_foreign_nominees_val) as net_foreign_nom_val,
sum(net_ivt_value) as net_ivt_val, sum(net_pdt_value) as net_pdt_val
from dibots_v2.exchange_demography_stock_broker_group where trading_date = '2021-02-16'
group by trading_date, board, sector
order by board, sector

-- week to date
select board, sector, sum(net_value) as net_val, sum(net_local_value) as net_local_val, sum(net_foreign_value) as net_foreign_val, 
sum(net_inst_value) as net_inst_val, sum(net_local_inst_val) as net_local_inst_val, sum(net_foreign_inst_val) as net_foreign_inst_val, 
sum(net_retail_value) as net_retail_val, sum(net_local_retail_val) as net_local_retail_val, sum(net_foreign_retail_val) as net_foreign_retail_val,
sum(net_nominees_value) as net_nominees_val, sum(net_local_nominees_val) as net_local_nom_val, sum(net_foreign_nominees_val) as net_foreign_nom_val,
sum(net_ivt_value) as net_ivt_val, sum(net_pdt_value) as net_pdt_val
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-02-15' and '2021-02-16'
group by board, sector
order by board, sector

-- month to date
select board, sector, sum(net_value) as net_val, sum(net_local_value) as net_local_val, sum(net_foreign_value) as net_foreign_val, 
sum(net_inst_value) as net_inst_val, sum(net_local_inst_val) as net_local_inst_val, sum(net_foreign_inst_val) as net_foreign_inst_val, 
sum(net_retail_value) as net_retail_val, sum(net_local_retail_val) as net_local_retail_val, sum(net_foreign_retail_val) as net_foreign_retail_val,
sum(net_nominees_value) as net_nominees_val, sum(net_local_nominees_val) as net_local_nom_val, sum(net_foreign_nominees_val) as net_foreign_nom_val,
sum(net_ivt_value) as net_ivt_val, sum(net_pdt_value) as net_pdt_val
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-02-01' and '2021-02-16'
group by board, sector
order by board, sector


-- year to date
select board, sector, sum(net_value) as net_val, sum(net_local_value) as net_local_val, sum(net_foreign_value) as net_foreign_val, 
sum(net_inst_value) as net_inst_val, sum(net_local_inst_val) as net_local_inst_val, sum(net_foreign_inst_val) as net_foreign_inst_val, 
sum(net_retail_value) as net_retail_val, sum(net_local_retail_val) as net_local_retail_val, sum(net_foreign_retail_val) as net_foreign_retail_val,
sum(net_nominees_value) as net_nominees_val, sum(net_local_nominees_val) as net_local_nom_val, sum(net_foreign_nominees_val) as net_foreign_nom_val,
sum(net_ivt_value) as net_ivt_val, sum(net_pdt_value) as net_pdt_val
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-01-01' and '2021-02-16'
group by board, sector
order by board, sector


-- number of warrants for each of the PLCs

-- overall
select a.count as number_of_warrants, count(*) as number_of_companies from (
select mother_code_identifier, mother_code_identifier_ex, count(*) as count
from dibots_v2.exchange_stock_profile where is_mother_code = false and eff_end_date is null and delisted_date is null and mother_code_identifier is not null
group by mother_code_identifier, mother_code_identifier_ex) a
group by a.count
order by a.count

-- structured warrants
select a.count as number_of_warrants, count(*) as number_of_companies from (
select mother_code_identifier, mother_code_identifier_ex, count(*) as count
from dibots_v2.exchange_stock_profile where is_mother_code = false and eff_end_date is null and delisted_date is null and mother_code_identifier is not null
and board = 'STRCWARR'
group by mother_code_identifier, mother_code_identifier_ex) a
group by a.count
order by a.count

-- not structured warrants
select a.count as number_of_warrants, count(*) as number_of_companies from (
select mother_code_identifier, mother_code_identifier_ex, count(*) as count
from dibots_v2.exchange_stock_profile where is_mother_code = false and eff_end_date is null and delisted_date is null and mother_code_identifier is not null
and board <> 'STRCWARR'
group by mother_code_identifier, mother_code_identifier_ex) a
group by a.count
order by a.count