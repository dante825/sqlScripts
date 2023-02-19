--==============
-- CHECKING
--==============

-- Check which stock in DEMOGRAPHY has a different trading volume or is missing, based on DAILY TRANSACTION
(select transaction_date, stock_code, sum(volume_traded_market_transaction) as vol from dibots_v2.exchange_daily_transaction
where transaction_date = (select max(trading_date) from staging.exchange_demography_verify)
group by transaction_date, stock_code) a
left join 
(select trading_date, stock_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol from staging.exchange_demography_verify
group by trading_date, stock_code) b
on a.transaction_date = b.trading_date and a.stock_code = b.stock_code
where a.vol* 2 <> b.vol;

-- Check which stock in DAILY TRANSACTION has a different trading volume or missing, based on the DEMOGRAPHY
select a.transaction_date, b.trading_date, a.stock_code, b.stock_code, a.vol*2, b.vol
from
(select transaction_date, stock_code, sum(volume_traded_market_transaction) as vol from dibots_v2.exchange_daily_transaction
where transaction_date = (select max(trading_date) from staging.exchange_demography_verify)
group by transaction_date, stock_code) a
right join 
(select trading_date, stock_code, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol from staging.exchange_demography_verify
group by trading_date, stock_code) b
on a.transaction_date = b.trading_date and a.stock_code = b.stock_code

--================
-- FABRICATION
--================
-- NOT RECOMMENDED, SHOULD JUST WAIT FOR BURSA DATA UPDATE
-- THIS IS ONLY IF YOU WANT QUICK RESULT
-- when DAILY_TRANSACTION data has problem and need to fabricate records into daily_trans
select max(transaction_date) from dibots_v2.exchange_daily_transaction;

select * from dibots_v2.exchange_weekly_transaction where max_trading_date = '2022-07-06';

select * from dibots_v2.exchange_daily_transaction_stock_date where transaction_date = '2022-07-06';

select * from dibots_v2.ref_demography_stock where trading_date = '2022-07-06';

select * from dibots_v2.ref_bursa_stock order by id desc;

select * from dibots_v2.exchange_stock_liquidity_median where max_trading_date = (select max(max_trading_date) from dibots_v2.exchange_stock_liquidity_median);

select * from dibots_v2.exchange_daily_avg where trading_date = (select max(trading_date) from dibots_v2.exchange_daily_avg);

select * from dibots_v2.exchange_stock_macd where trading_date = '2022-07-06';

select * from dibots_v2.exchange_stock_macd_short where trading_date = '2022-07-06'

select * from dibots_v2.exchange_stock_macd_long where trading_date = '2022-07-06'

-- FABRICATING RECORDS
insert into dibots_v2.ref_bursa_stock (stock_code, created_dtime, created_by)
--values ('5099LA', now(), 'kangwei')
--values ('5099WA', now(), 'kangwei')

insert into dibots_v2.exchange_daily_transaction (transaction_date, stock_code, stock_name_short, stock_name_long, board, sector, sub_sector, security_type, currency,
opening_price, high_price, low_price, closing_price, volume_traded_market_transaction, volume_traded_direct_business, value_traded_market_transaction, value_traded_direct_business, 
shares_outstanding, last_adjusted_closing_price, vwap, adj_closing, adj_lacp, stock_num)
--values ('2022-07-06', '5099LA', 'AIRASIA-WA', 'AIRASIA GROUP BERHAD - WARRANTS', 'LOANS', 'CONSUMES PRODUCTS & SERVICES', 'TRAVEL, LEISURE & HOSPITALITY', 'CONV. REDEEMABLE - R', 'MYR', 
0, 0, 0, 0, 39376509, 0, 0, 0, 0, 0, 0, 0, 0, 9557)

--values ('2022-07-06', '5099WA', 'AIRASIA-WA', 'AIRASIA GROUP BERHAD - WARRANTS', 'LOANS', 'CONSUMES PRODUCTS & SERVICES', 'TRAVEL, LEISURE & HOSPITALITY', 'CONV. REDEEMABLE - R', 'MYR', 
0, 0, 0, 0, 74520472, 0, 0, 0, 0, 0, 0, 0, 0, 9556)


--============== STOCK_TRANSACTION ==========
delete from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-06';
delete from dibots_v2.exchange_stock_liquidity_median where max_trading_date = '2022-07-06';
delete from dibots_v2.exchange_daily_transaction_velocity where transaction_date = '2022-07-06';
delete from dibots_v2.exchange_daily_avg where trading_date = '2022-07-06';
delete from dibots_v2.exchange_weekly_transaction where max_trading_date = '2022-07-06';
delete from dibots_v2.exchange_daily_transaction_stock_date where transaction_date = '2022-07-06';
delete from dibots_v2.ref_demography_stock where trading_date = '2022-07-06';
delete from dibots_v2.exchange_stock_macd where trading_date = '2022-07-06';
delete from dibots_v2.exchange_stock_macd_short where trading_date = '2022-07-06';
delete from dibots_v2.exchange_stock_macd_long where trading_date = '2022-07-06';

-- direct business trade

select max(trading_date) from dibots_v2.exchange_direct_business_trade;

--============= DBT =============
delete from dibots_v2.exchange_direct_business_trade where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_broker_age_band where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_broker_movement where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_stock_broker_nationality where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_broker_nationality where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_broker_stats where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_stock where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_stock_broker where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_stock_broker_group where trading_date = '2022-08-15';
delete from dibots_v2.exchange_dbt_stock_movement where trading_date = '2022-08-15';


-- WHEN DEMOGRAPHY DATA HAS PROBLEM
select max(trading_date) from dibots_v2.exchange_demography;

--================ DEMOGRAPHY =================
delete from dibots_v2.exchange_demography where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_broker_age_band where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_broker_movement where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_stock_broker_nationality where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_broker_stats where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_stats where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_stock_retail_prof where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_stock_broker_stats where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_stock_movement where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_stock_broker where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_stock_broker_group where trading_date = '2022-08-15';
delete from dibots_v2.exchange_demography_stock_week where trading_date = '2022-08-15';

--=================== OMTDBT =============================
delete from dibots_v2.exchange_omtdbt_broker_age_band where trading_date = '2022-08-15';
delete from dibots_v2.exchange_omtdbt_broker_movement where trading_date = '2022-08-15';
delete from dibots_v2.exchange_omtdbt_stock_broker_nationality where trading_date = '2022-08-15';
delete from dibots_v2.exchange_omtdbt_broker_stats where trading_date = '2022-08-15';
delete from dibots_v2.exchange_omtdbt_stock_broker where trading_date = '2022-08-15';
delete from dibots_v2.exchange_omtdbt_stock_movement where trading_date = '2022-08-15';
delete from dibots_v2.exchange_omtdbt_stock where trading_date = '2022-08-15';
delete from dibots_v2.exchange_omtdbt_stock_broker_group where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_day where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_day_totals where trading_date = '2022-08-15';


-- broker_rank_week need the week_count
select max(week_count) from dibots_v2.broker_rank_week;


--============ DELETE ==========
delete from dibots_v2.broker_rank_week where week_count = '2022-33';
delete from dibots_v2.broker_rank_week_totals where week_count = '2022-33';

select max(year_month) from dibots_v2.broker_rank_month_totals;

select * from dibots_v2.broker_rank_day order by trading_date desc

--============ DELETE ============
delete from dibots_v2.broker_rank_month where year_month = '2022-08';
delete from dibots_v2.broker_rank_month_totals where year_month = '2022-08';


select * from dibots_v2.broker_rank_qtr order by year_qtr desc;

--============= DELETE ===========
delete from dibots_v2.broker_rank_qtr where year_qtr = '2022-3';
delete from dibots_v2.broker_rank_qtr_totals where year_qtr = '2022-3';

select * from dibots_v2.broker_rank_year order by year desc

--============== DELETE =============
delete from dibots_v2.broker_rank_year  where year = '2022';
delete from dibots_v2.broker_rank_year_totals where year = '2022';
delete from dibots_v2.broker_rank_wtd where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_mtd where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_qtd where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_ytd where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_omtdbt_day where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_omtdbt_day_totals where trading_date = '2022-08-15';


select max(week_count) from dibots_v2.broker_rank_omtdbt_week

--============ DELETE ==============
delete from dibots_v2.broker_rank_omtdbt_week where week_count = '2022-33';
delete from dibots_v2.broker_rank_omtdbt_week_totals where week_count = '2022-33';

select max(year_month) from dibots_v2.broker_rank_omtdbt_month;

--=========== DELETE ============
delete from dibots_v2.broker_rank_omtdbt_month where year_month = '2022-08';
delete from dibots_v2.broker_rank_omtdbt_month_totals where year_month = '2022-08';

select max(year_qtr) from dibots_v2.broker_rank_omtdbt_qtr;

--========== DELETE ============
delete from dibots_v2.broker_rank_omtdbt_qtr where year_qtr = '2022-3';
delete from dibots_v2.broker_rank_omtdbt_qtr_totals where year_qtr = '2022-3';

select max(year) from dibots_v2.broker_rank_omtdbt_year;

--========== DELETE ===============
delete from dibots_v2.broker_rank_omtdbt_year  where year = '2022';
delete from dibots_v2.broker_rank_omtdbt_year_totals where year = '2022';
delete from dibots_v2.broker_rank_omtdbt_wtd where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_omtdbt_mtd where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_omtdbt_qtd where trading_date = '2022-08-15';
delete from dibots_v2.broker_rank_omtdbt_ytd where trading_date = '2022-08-15';

select * from dibots_v2.exchange_shareholdings where trading_date = '2022-08-15'

--============== DELETE ================
delete from dibots_v2.exchange_shareholdings where trading_date = '2022-08-15';
delete from dibots_v2.exchange_local_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_foreign_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_local_inst_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_local_retail_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_local_nominees_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_local_inst_nom_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_foreign_inst_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_foreign_inst_nom_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_prop_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_ivt_ma where trading_date = '2022-08-15';
delete from dibots_v2.exchange_pdt_ma where trading_date = '2022-08-15';


-- FIX
-- 1. run the DBT etl
-- 2. run the demography etl
-- 3. run the following script if the fix is done after investor stats
update dibots_v2.exchange_demography_stock_movement a
set
total_investors = b.inv
from 
(select trading_date, stock_code, locality_new, group_type, sum(total_investors) as inv, sum(total_traded_volume), sum(total_traded_value)
from dibots_v2.exchange_investor_stock_stats
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_movement)
group by trading_date, stock_code, locality_new, group_type) b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code and a.locality = b.locality_new and a.group_type = b.group_type;

select max(trading_date) from dibots_v2.exchange_direct_business_trade;

select * from dibots_v2.exchange_dbt_broker_age_band where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_broker_age_band);

select * from dibots_v2.exchange_dbt_broker_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_broker_movement);

select * from dibots_v2.exchange_dbt_broker_nationality where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_broker_nationality);

select * from dibots_v2.exchange_dbt_broker_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_broker_stats);

select * from dibots_v2.exchange_dbt_stock where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_stock);

select * from dibots_v2.exchange_dbt_stock_broker where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker);

select * from dibots_v2.exchange_dbt_stock_broker_group where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group);

select * from dibots_v2.exchange_dbt_stock_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_stock_movement);


select * from dibots_v2.exchange_demography where trading_date = (select max(trading_date) from dibots_v2.exchange_demography);

select * from dibots_v2.exchange_demography_broker_age_band where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_broker_age_band);

select * from dibots_v2.exchange_demography_broker_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_broker_movement);

select * from dibots_v2.exchange_demography_broker_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_broker_stats);

select * from dibots_v2.exchange_demography_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stats);

select * from dibots_v2.exchange_demography_stock_retail_prof where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_retail_prof);

select * from dibots_v2.exchange_demography_stock_broker_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_stats);

select * from dibots_v2.exchange_demography_stock_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_movement);

select * from dibots_v2.exchange_demography_stock_broker where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_broker);

select * from dibots_v2.exchange_demography_stock_broker_group where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group);

select * from dibots_v2.exchange_demography_stock_week where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_week);

select * from dibots_v2.exchange_omtdbt_broker_age_band where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_age_band);

select * from dibots_v2.exchange_omtdbt_broker_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_movement);

select * from dibots_v2.exchange_omtdbt_broker_nationality where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_nationality);

select * from dibots_v2.exchange_omtdbt_broker_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_stats);

select * from dibots_v2.exchange_omtdbt_stock_broker where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker);

select * from dibots_v2.exchange_omtdbt_stock_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_movement);

select * from dibots_v2.exchange_omtdbt_stock where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock);

select * from dibots_v2.exchange_omtdbt_stock_broker_group where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker_group);

select * from dibots_v2.broker_rank_day where trading_date = (select max(trading_date) from dibots_v2.broker_rank_day);

select * from dibots_v2.broker_rank_day_totals where trading_date = (select max(trading_date) from dibots_v2.broker_rank_day_totals);

select * from dibots_v2.broker_rank_week where week_count = (select max(week_count) from dibots_v2.broker_rank_week);

select * from dibots_v2.broker_rank_week_totals where week_count = (select max(week_count) from dibots_v2.broker_rank_week_totals);

select * from dibots_v2.broker_rank_month where year_month = (select max(year_month) from dibots_v2.broker_rank_month);

select * from dibots_v2.broker_rank_month_totals where year_month = (select max(year_month) from dibots_v2.broker_rank_month_totals);

select * from dibots_v2.broker_rank_qtr where year_qtr = (select max(year_qtr) from dibots_v2.broker_rank_qtr);

select * from dibots_v2.broker_rank_qtr_totals where year_qtr = (select max(year_qtr) from dibots_v2.broker_rank_qtr_totals);

select * from dibots_v2.broker_rank_year where year = (select max(year) from dibots_v2.broker_rank_year);

select * from dibots_v2.broker_rank_year_totals where year = (select max(year) from dibots_v2.broker_rank_year)

select * from dibots_v2.broker_rank_wtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_wtd);

select * from dibots_v2.broker_rank_mtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_mtd);

select * from dibots_v2.broker_rank_qtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_qtd);

select * from dibots_v2.broker_rank_ytd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_ytd);

select * from dibots_v2.broker_rank_omtdbt_day where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day);

select * from dibots_v2.broker_rank_omtdbt_day_totals where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day_totals);

select * from dibots_v2.broker_rank_omtdbt_week where week_count = (select max(week_count) from dibots_v2.broker_rank_omtdbt_week);

select * from dibots_v2.broker_rank_omtdbt_week_totals where week_count = (select max(week_count) from dibots_v2.broker_rank_omtdbt_week_totals);

select * from dibots_v2.broker_rank_omtdbt_month where year_month = (select max(year_month) from dibots_v2.broker_rank_omtdbt_month);

select * from dibots_v2.broker_rank_omtdbt_month_totals where year_month = (select max(year_month) from dibots_v2.broker_rank_omtdbt_month_totals);

select * from dibots_v2.broker_rank_omtdbt_qtr where year_qtr = (select max(year_qtr) from dibots_v2.broker_rank_omtdbt_qtr);

select * from dibots_v2.broker_rank_omtdbt_qtr_totals where year_qtr = (select max(year_qtr) from dibots_v2.broker_rank_omtdbt_qtr_totals);

select * from dibots_v2.broker_rank_omtdbt_year where year = (select max(year) from dibots_v2.broker_rank_omtdbt_year);

select * from dibots_v2.broker_rank_omtdbt_year_totals where year = (select max(year) from dibots_v2.broker_rank_omtdbt_year_totals);

select * from dibots_v2.broker_rank_omtdbt_wtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_wtd);

select * from dibots_v2.broker_rank_omtdbt_mtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_mtd);

select * from dibots_v2.broker_rank_omtdbt_qtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_qtd);

select * from dibots_v2.broker_rank_omtdbt_ytd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_ytd);

select * from dibots_v2.exchange_local_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_ma);

select * from dibots_v2.exchange_foreign_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_ma);

select * from dibots_v2.exchange_local_inst_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_inst_ma);

select * from dibots_v2.exchange_local_retail_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_retail_ma);

select * from dibots_v2.exchange_local_nominees_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_nominees_ma);

select * from dibots_v2.exchange_local_inst_nom_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_inst_nom_ma);

select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_inst_nom_ma);

select * from dibots_v2.exchange_foreign_inst_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_inst_ma);

select * from dibots_v2.exchange_prop_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_prop_ma);

select * from dibots_v2.exchange_ivt_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_ivt_ma);

select * from dibots_v2.exchange_pdt_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_pdt_ma);

select * from dibots_v2.exchange_shareholdings where trading_date = (select max(trading_date) from dibots_v2.exchange_shareholdings);

