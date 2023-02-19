select count(*) from dibots_v2.exchange_entitlement

select * from dibots_v2.exchange_entitlement order by ex_date desc;

select * from dibots_v2.exchange_daily_transaction where transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction);

-- check stock_name changes
select a.stock_code, a.stock_name_short as old_name, b.stock_name_short as new_name, a.stock_name_long as old_long_name, b.stock_name_long as new_long_name from
(select * from dibots_v2.exchange_daily_transaction where transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction where transaction_date < (select max(transaction_date) from dibots_v2.exchange_daily_transaction))) a
left join 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction)) b
on a.stock_code = b.stock_code
where (a.stock_name_short <> b.stock_name_short or a.stock_name_long <> b.stock_name_long)

select * from dibots_v2.ref_demography_stock where trading_date = (select max(trading_date) from dibots_v2.ref_demography_stock);

select * from dibots_v2.exchange_weekly_transaction where max_trading_date = (select max(max_trading_date) from dibots_v2.exchange_weekly_transaction);

select * from dibots_v2.exchange_stock_liquidity_median where max_trading_date = (select max(max_trading_date) from dibots_v2.exchange_stock_liquidity_median);

select * from dibots_v2.exchange_daily_avg where trading_date = (select max(trading_date) from dibots_v2.exchange_daily_avg);

select * from dibots_v2.exchange_stock_macd where trading_date = (select max(trading_date) from dibots_v2.exchange_stock_macd);

select * from dibots_v2.exchange_stock_macd_short where trading_date = (select max(trading_date) from dibots_v2.exchange_stock_macd_short);

select * from dibots_v2.exchange_stock_macd_long where trading_date = (select max(trading_date) from dibots_v2.exchange_stock_macd_long);

select * from dibots_v2.plc_daily_pe;

select * from dibots_v2.exchange_contra_fund_flow where t0_date = (select max(t0_date) from dibots_v2.exchange_contra_fund_flow);

-- check missing date in contra
select a.trans_date, b.t0_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(t0_date) as t0_date from dibots_v2.exchange_contra_fund_flow
where t0_date >= '2022-09-01') b
on a.trans_date = b.t0_date
where b.t0_date is null
order by a.trans_date

select * from dibots_v2.exchange_contra_ff_stock where t0_date = (select max(t0_date) from dibots_v2.exchange_contra_ff_stock);

-- check missing date in contra_ff_stock
select a.trans_date, b.t0_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(t0_date) as t0_date from dibots_v2.exchange_contra_ff_stock
where t0_date >= '2022-09-01') b
on a.trans_date = b.t0_date
where b.t0_date is null
order by a.trans_date

select * from dibots_v2.exchange_contra_movement_ratio_mview where t0_date = (select max(t0_date) from dibots_v2.exchange_contra_movement_ratio_mview);

-- check missing date in contra_movement_ratio
select a.trans_date, b.t0_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(t0_date) as t0_date from dibots_v2.exchange_contra_movement_ratio_mview
where t0_date >= '2022-09-01') b
on a.trans_date = b.t0_date
where b.t0_date is null
order by a.trans_date

select * from dibots_v2.exchange_shareholdings where trading_date = (select max(trading_date) from dibots_v2.exchange_shareholdings);

select * from dibots_v2.exchange_daily_sector_index where transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_sector_index)

select * from dibots_v2.exchange_weekly_sector_index where max_trading_date = (select max(max_trading_date) from dibots_v2.exchange_weekly_sector_index);

select * from dibots_v2.exchange_market_summary where trd_date = (select max(trd_date) from dibots_v2.exchange_market_summary)

-- to verify market summary normal trade data
select a.trd_date, a.total_vol, b.total_vol
from 
(select trd_date, sum(trd_vol) as total_vol from dibots_v2.exchange_market_summary where trd_date >= '2022-09-01' and board = 'NM'
group by trd_date) a,
(select trading_date, sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_vol from dibots_v2.exchange_demography 
where trading_date >= '2022-09-01'
group by trading_date) b
where a.trd_date = b.trading_date and a.total_vol <> b.total_vol

-- to verify market summary direct business data
select a.trd_date, a.total_vol, b.total_vol
from 
(select trd_date, sum(trd_vol) as total_vol from dibots_v2.exchange_market_summary where trd_date >= '2022-09-01' and board = 'DB'
group by trd_date) a,
(select trading_date, sum(gross_traded_volume_buy + gross_traded_volume_sell) as total_vol from dibots_v2.exchange_direct_business_trade
where trading_date >= '2022-09-01'
group by trading_date) b
where a.trd_date = b.trading_date and a.total_vol <> b.total_vol

-- demography
select * from dibots_v2.exchange_demography where trading_date = (select max(trading_date) from dibots_v2.exchange_demography)

-- verify demography by volume
select b.trading_date, a.vol, b.vol
from
(select transaction_date, sum(volume_traded_market_transaction) as vol from dibots_v2.exchange_daily_transaction 
where transaction_date >= '2022-09-01'
group by transaction_date) a,
(select trading_date, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol from dibots_v2.exchange_demography
where trading_date >= '2022-09-01'
group by trading_date) b
where b.trading_date = a.transaction_date
and a.vol * 2 <> b.vol
order by b.trading_date;

-- verify demography by value
select b.trading_date, a.val*2, b.val
from
(select transaction_date, sum(value_traded_market_transaction) as val from dibots_v2.exchange_daily_transaction 
where transaction_date >= '2022-09-01'
group by transaction_date) a,
(select trading_date, sum(gross_traded_value_buy + gross_traded_value_sell) as val from dibots_v2.exchange_demography
where trading_date >= '2022-09-01'
group by trading_date) b
where b.trading_date = a.transaction_date
and a.val * 2 <> b.val
order by b.trading_date;

-- check missing date in demography
select a.trans_date, b.trading_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(trading_date) as trading_date from dibots_v2.exchange_demography
where trading_date >= '2022-09-01') b
on a.trans_date = b.trading_date
where b.trading_date is null
order by a.trans_date

-- demography derived
select * from dibots_v2.exchange_demography_stock_broker where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_broker)

select b.trading_date, a.vol, b.vol
from
(select trading_date, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol from dibots_v2.exchange_demography
where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(volume) as vol from dibots_v2.exchange_demography_stock_broker
where trading_date >= '2022-09-01'
group by trading_date) b
where b.trading_date = a.trading_date
and a.vol <> b.vol
order by b.trading_date;

select * from dibots_v2.exchange_demography_stock_broker_group where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_group)

select * from dibots_v2.exchange_demography_stock_week where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_week)

select * from dibots_v2.exchange_daily_transaction_velocity where transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction_velocity);

select * from dibots_v2.exchange_demography_stock_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_movement);

select * from dibots_v2.exchange_demography_broker_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_broker_movement);

select * from dibots_v2.exchange_demography_stock_broker_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_stats);

select * from dibots_v2.exchange_demography_stock_retail_prof where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_retail_prof);

select * from dibots_v2.exchange_demography_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stats);

select * from dibots_v2.exchange_demography_stock_broker_nationality where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_broker_nationality);

select * from dibots_v2.exchange_demography_stock_broker where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_broker);

select * from dibots_v2.exchange_demography_broker_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_broker_stats);

select * from dibots_v2.exchange_demography_broker_age_band where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_broker_age_band);

select * from dibots_v2.broker_rank_day where trading_date = (select max(trading_date) from dibots_v2.broker_rank_day)

select * from dibots_v2.broker_rank_week where week_count = (select max(week_count) from dibots_v2.broker_rank_week)

select * from dibots_v2.broker_rank_month where year_month = (select max(year_month) from dibots_v2.broker_rank_month);

select * from dibots_v2.broker_rank_qtr where year_qtr = (select max(year_qtr) from dibots_v2.broker_rank_qtr);

select * from dibots_v2.broker_rank_year where year = (select max(year) from dibots_v2.broker_rank_year);

select * from dibots_v2.broker_rank_wtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_wtd);

select * from dibots_v2.broker_rank_mtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_mtd);

select * from dibots_v2.broker_rank_qtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_qtd);

select * from dibots_v2.broker_rank_ytd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_ytd);

-- OMT + DBT
select * from dibots_v2.broker_rank_omtdbt_day where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day);

select * from dibots_v2.broker_rank_omtdbt_week where max_trading_date = (select max(max_trading_date) from dibots_v2.broker_rank_omtdbt_week);

select * from dibots_v2.broker_rank_omtdbt_month where year_month  = (select max(year_month) from dibots_v2.broker_rank_omtdbt_month);

select * from dibots_v2.broker_rank_omtdbt_qtr where year_qtr = (select max(year_qtr) from dibots_v2.broker_rank_omtdbt_qtr);

select * from dibots_v2.broker_rank_omtdbt_year where year = 2022;

select * from dibots_v2.broker_rank_omtdbt_wtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_wtd);

select * from dibots_v2.broker_rank_omtdbt_mtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_mtd);

select * from dibots_v2.broker_rank_omtdbt_qtd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_qtd);

select * from dibots_v2.broker_rank_omtdbt_ytd where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_ytd);

-- dbt
select * from dibots_v2.exchange_direct_business_trade where trading_date = (select max(trading_date) from dibots_v2.exchange_direct_business_trade)

-- verify dbt
select b.trading_date, a.vol, b.vol
from
(select transaction_date, sum(volume_traded_direct_business) as vol from dibots_v2.exchange_daily_transaction 
where transaction_date >= '2022-09-01'
group by transaction_date) a,
(select trading_date, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol from dibots_v2.exchange_direct_business_trade
where trading_date >= '2022-09-01'
group by trading_date) b
where b.trading_date = a.transaction_date
and a.vol * 2 <> b.vol
order by b.trading_date;

-- check missing date in dbt
select a.trans_date, b.trading_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(trading_date) as trading_date from dibots_v2.exchange_direct_business_trade
where trading_date >= '2022-09-01') b
on a.trans_date = b.trading_date
where b.trading_date is null
order by a.trans_date

select * from dibots_v2.exchange_dbt_broker_age_band where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_broker_age_band);

select * from dibots_v2.exchange_dbt_broker_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_broker_movement);

select * from dibots_v2.exchange_dbt_broker_nationality where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_broker_nationality);

select * from dibots_v2.exchange_dbt_broker_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_broker_stats);

select * from dibots_v2.exchange_dbt_stock where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_stock);

select * from dibots_v2.exchange_dbt_stock_broker where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker);

select * from dibots_v2.exchange_dbt_stock_broker_group where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_stock_broker_group);

select * from dibots_v2.exchange_dbt_stock_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_dbt_stock_movement);

-- OMT + DBT
select * from dibots_v2.exchange_omtdbt_broker_age_band where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_age_band);

select * from dibots_v2.exchange_omtdbt_broker_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_movement);

select * from dibots_v2.exchange_omtdbt_stock_broker_nationality where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker_nationality);

select * from dibots_v2.exchange_omtdbt_broker_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_broker_stats);

select * from dibots_v2.exchange_omtdbt_stock where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock);

select * from dibots_v2.exchange_omtdbt_stock_broker where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker);

select * from dibots_v2.exchange_omtdbt_stock_broker_group where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_broker_group);

select * from dibots_v2.exchange_omtdbt_stock_movement where trading_date = (select max(trading_date) from dibots_v2.exchange_omtdbt_stock_movement);

select * from dibots_v2.exchange_shareholdings where trading_date = (select max(trading_date) from dibots_v2.exchange_shareholdings);

-- shortselling
select * from dibots_v2.exchange_short_selling where trading_date = (select max(trading_date) from dibots_v2.exchange_short_selling)

select * from dibots_v2.exchange_net_short_position where trading_date = (select max(trading_date) from dibots_v2.exchange_net_short_position);

select * from dibots_v2.exchange_trade_origin where trading_date = (select max(trading_date) from dibots_v2.exchange_trade_origin);

-- check missing days from exchange_trade_origin
select a.trans_date, b.trading_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(trading_date) as trading_date from dibots_v2.exchange_trade_origin
where trading_date >= '2022-09-01') b
on a.trans_date = b.trading_date
where b.trading_date is null
order by a.trans_date;

select count(*) from dibots_v2.wvb_news_item_body where item_perm_id > 12209605;

-- group type sma
select * from dibots_v2.exchange_local_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'LOCAL'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_foreign_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_foreign_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'FOREIGN'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_local_inst_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_inst_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_inst_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_local_retail_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_retail_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_retail_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'LOCAL' and group_type = 'RETAIL'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_local_nominees_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_nominees_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_nominees_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'LOCAL' and group_type = 'NOMINEES'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_local_inst_nom_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_local_inst_nom_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_local_inst_nom_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'LOCAL' and group_type in ('INSTITUTIONAL', 'NOMINEES')
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_foreign_inst_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_inst_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_foreign_inst_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_foreign_inst_nom_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_foreign_inst_nom_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_foreign_inst_nom_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'FOREIGN' and group_type in ('INSTITUTIONAL', 'NOMINEES')
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_prop_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_prop_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_prop_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and locality = 'PROPRIETARY'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_ivt_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_ivt_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_ivt_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and group_type = 'IVT'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

select * from dibots_v2.exchange_pdt_ma where trading_date = (select max(trading_date) from dibots_v2.exchange_pdt_ma);

select a.trading_date, a.stock_num, a.volume, b.buy_vol from
(select trading_date, stock_num, volume from dibots_v2.exchange_pdt_ma where trading_date >= '2022-09-01') a,
(select trading_date, stock_num, sum(buy_volume) as buy_vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01' and group_type = 'PDT'
group by trading_date, stock_num ) b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and a.volume <> b.buy_vol
order by a.trading_date

-- exchange_investor_stats
select * from dibots_v2.exchange_investor_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_investor_stats)

select b.trading_date, a.vol * 2, b.vol from
(select transaction_date, sum(volume_traded_market_transaction) as vol from dibots_v2.exchange_daily_transaction 
where transaction_date >= '2022-09-01'
group by transaction_date) a,
(select trading_date, sum(total_traded_volume) as vol from dibots_v2.exchange_investor_stats
where trading_date >=  '2022-09-01'
group by trading_date) b
where a.transaction_date = b.trading_date and a.vol * 2 <> b.vol
order by b.trading_date

-- to check if there's any date that is missing in exchange_investor_stats
select a.trans_date, b.trading_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(trading_date) as trading_date from dibots_v2.exchange_investor_stats
where trading_date >= '2022-09-01') b
on a.trans_date = b.trading_date
where b.trading_date is null
order by a.trans_date

-- verify exchange_investor_stock_stats by volume
select * from dibots_v2.exchange_investor_stock_stats where trading_date = (select max(trading_date) from dibots_v2.exchange_investor_stock_stats)

select b.trading_date, a.vol * 2, b.vol from
(select transaction_date, sum(volume_traded_market_transaction) as vol from dibots_v2.exchange_daily_transaction 
where transaction_date >= '2022-09-01'
group by transaction_date) a,
(select trading_date, sum(total_traded_volume) as vol from dibots_v2.exchange_investor_stock_stats
where trading_date >=  '2022-09-01'
group by trading_date) b
where a.transaction_date = b.trading_date and a.vol * 2 <> b.vol
order by b.trading_date

-- to check if there's any date that is missing in exchange_investor_stock_stats
select a.trans_date, b.trading_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(trading_date) as trading_date from dibots_v2.exchange_investor_stock_stats
where trading_date >= '2022-09-01') b
on a.trans_date = b.trading_date
where b.trading_date is null
order by a.trans_date

-- exchange_investor_stats_week
select * from dibots_v2.exchange_investor_stats_week where last_date = (select max(last_date) from dibots_v2.exchange_investor_stats_week)

-- to check if there's any date that is missing in exchange_investor_stats_week
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stats_week
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date

-- exchange_investor_stock_stats_week
select * from dibots_v2.exchange_investor_stock_stats_week where last_date = (select max(last_date) from dibots_v2.exchange_investor_stock_stats_week)

-- to check if there's any date that is missing in exchange_investor_stock_stats_week
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stock_stats_week
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date

-- exchange_investor_stats_month
select * from dibots_v2.exchange_investor_stats_month where last_date = (select max(last_date) from dibots_v2.exchange_investor_stats_month)

-- to check if there's any date that is missing in exchange_investor_stats_month
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stats_month
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date

-- exchange_investor_stock_stats_month
select * from dibots_v2.exchange_investor_stock_stats_month where last_date = (select max(last_date) from dibots_v2.exchange_investor_stock_stats_month)

-- to check if there's any date that is missing in exchange_investor_stock_stats_month
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stock_stats_month
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date

-- exchange_investor_stats_qtr
select * from dibots_v2.exchange_investor_stats_qtr where last_date = (select max(last_date) from dibots_v2.exchange_investor_stats_qtr);

-- to check if there's any date that is missing in exchange_investor_stats_qtr
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stats_qtr
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date;

-- exchange_investor_stock_stats_qtr
select * from dibots_v2.exchange_investor_stock_stats_qtr where last_date = (select max(last_date) from dibots_v2.exchange_investor_stock_stats_qtr);

-- to check if there's any date that is missing in exchange_investor_stock_stats_qtr
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stock_stats_qtr
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date;

-- exchange_investor_stats_semi_annual
select * from dibots_v2.exchange_investor_stats_semi_annual where last_date = (select max(last_date) from dibots_v2.exchange_investor_stats_semi_annual);

-- to check if there's any date that is missing in exchange_investor_stats_semi_annual
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stats_semi_annual
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date;

-- exchange_investor_stock_stats_semi_annual
select * from dibots_v2.exchange_investor_stock_stats_semi_annual where last_date = (select max(last_date) from dibots_v2.exchange_investor_stock_stats_semi_annual);

-- to check if there's any date that is missing in exchange_investor_stock_stats_semi_annual
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stock_stats_semi_annual
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date;

-- exchange_investor_stats_year
select * from dibots_v2.exchange_investor_stats_year where last_date = (select max(last_date) from dibots_v2.exchange_investor_stats_year);

-- to check if there's any date that is missing in exchange_investor_stats_year
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stats_year
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date;

-- exchange_investor_stock_stats_year
select * from dibots_v2.exchange_investor_stock_stats_year where last_date = (select max(last_date) from dibots_v2.exchange_investor_stock_stats_year);

-- to check if there's any date that is missing in exchange_investor_stock_stats_year
select a.trans_date, b.last_date from
(select distinct(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
where transaction_date >= '2022-09-01') a
left join 
(select distinct(last_date) as last_date from dibots_v2.exchange_investor_stock_stats_year
where last_date >= '2022-09-01') b
on a.trans_date = b.last_date
where b.last_date is null
order by a.trans_date;