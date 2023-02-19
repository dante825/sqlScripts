--========================
-- OMTDBT VERIFICATIONS
--========================

-- exchange_demography_stock_week
select a.trading_date, a.vol, b.vol, a.intraday, b.intraday from
(select trading_date, sum(total_vol) as vol, sum(total_intraday_vol) as intraday from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(gross_traded_volume_buy + gross_traded_volume_sell) as vol, sum(intraday_volume) as intraday from dibots_v2.exchange_demography where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and (a.vol <> b.vol or a.intraday <> b.intraday);

-- exchange_demography_broker_age_band
select a.trading_date, a.vol, b.vol from
(select trading_date, sum(total_buysell_volume) as vol from dibots_v2.exchange_demography_broker_age_band where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(local_retail_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol;

-- exchange_demography_broker_movement
select a.trading_date, a.vol, b.vol from 
(select trading_date, sum(total_volume) as vol from dibots_v2.exchange_demography_broker_movement where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol;

-- exchange_demography_stock_broker_nationality
select a.trading_date, a.vol, b.vol from
(select trading_date, sum(volume) as vol from dibots_v2.exchange_demography_stock_broker_nationality where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(foreign_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol;

-- exchange_demography_broker_stats
select a.trading_date, a.val, b.val from
(select trading_date, sum(total_traded_value) as val from dibots_v2.exchange_demography_broker_stats where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_val) as val from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.val <> b.val;

-- exchange_demography_stats
select a.trading_date, a.vol, b.vol from
(select trading_date, sum(total_intraday_vol) as vol from dibots_v2.exchange_demography_stats where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_intraday_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol

-- exchange_demography_stock_retail_prof
select a.trading_date, a.vol, b.vol from
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_demography_stock_retail_prof where trading_date >= '2022-09-01'
group by trading_date ) a,
(select trading_date, sum(local_retail_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol;

-- exchange_demography_stock_broker
select a.trading_date, a.vol, b.vol from
(select trading_date, sum(volume) as vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01'
group by trading_date ) a,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol;

-- exchange_demography_stock_broker_group
select a.trading_date, a.vol, b.vol from
(select trading_date, sum(total_volume) as vol from dibots_v2.exchange_demography_stock_broker_group where trading_date >= '2022-09-01'
group by trading_date ) a,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol;

-- exchange_demography_stock_broker_stats
select a.trading_date, a.vol, b.vol from
(select trading_date, sum(total_intraday_vol) as vol from dibots_v2.exchange_demography_stock_broker_stats where trading_date >= '2022-09-01'
group by trading_date ) a,
(select trading_date, sum(total_intraday_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol;

-- exchange_demography_stock_movement
select a.trading_date, a.vol, b.vol from
(select trading_date, sum(volume) as vol from dibots_v2.exchange_demography_stock_movement where trading_date >= '2022-09-01'
group by trading_date ) a,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b
where a.trading_date = b.trading_date and a.vol <> b.vol;

-- exchange_omtdbt_stock_broker_group
select a.trading_date, a.vol, b.vol + c.vol from
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_omtdbt_stock_broker_group where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_volume) as vol from dibots_v2.exchange_demography_stock_broker_group where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_dbt_stock_broker_group where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.vol <> b.vol + c.vol;

-- exchange_omtdbt_stock_broker
select a.trading_date, a.vol, b.vol + c.vol from
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_omtdbt_stock_broker where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(volume) as vol from dibots_v2.exchange_demography_stock_broker where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_dbt_stock_broker where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.vol <> b.vol + c.vol;

-- exchange_omtdbt_stock
select a.trading_date, a.vol, b.vol + c.vol from
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_omtdbt_stock where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_dbt_stock where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.vol <> b.vol + c.vol;

-- exchange_omtdbt_stock_movement
select a.trading_date, a.vol, b.vol + c.vol from
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_omtdbt_stock_movement where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(volume) as vol from dibots_v2.exchange_demography_stock_movement where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_dbt_stock_movement where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.vol <> b.vol + c.vol;

-- exchange_omtdbt_broker_stats
select a.trading_date, a.val, b.val + c.val from
(select trading_date, sum(total_val) as val from dibots_v2.exchange_omtdbt_broker_stats where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_traded_value) as val from dibots_v2.exchange_demography_broker_stats where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(total_val) as val from dibots_v2.exchange_dbt_broker_stats where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.val <> b.val + c.val
order by trading_date;

-- exchange_omtdbt_stock_broker_nationality
select a.trading_date, a.vol, b.vol + c.vol from
(select trading_date, sum(volume) as vol from dibots_v2.exchange_omtdbt_stock_broker_nationality where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(volume) as vol from dibots_v2.exchange_demography_stock_broker_nationality where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(volume) as vol from dibots_v2.exchange_dbt_stock_broker_nationality where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.vol <> b.vol + c.vol;

-- exchange_omtdbt_broker_movement
select a.trading_date, a.vol, b.vol + c.vol from
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_omtdbt_broker_movement where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_volume) as vol from dibots_v2.exchange_demography_broker_movement where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_dbt_broker_movement where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.vol <> b.vol + c.vol;

-- exchange_omtdbt_broker_age_band
select a.trading_date, a.vol, b.vol + c.vol from
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_omtdbt_broker_age_band where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_buysell_volume) as vol from dibots_v2.exchange_demography_broker_age_band where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_dbt_broker_age_band where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.vol <> b.vol + c.vol;

-- broker_rank_omtdbt_day
select a.trading_date, a.vol, b.vol + c.vol from
(select trading_date, sum(total_vol) as vol from dibots_v2.broker_rank_omtdbt_day where trading_date >= '2022-09-01'
group by trading_date) a,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_demography_stock_week where trading_date >= '2022-09-01'
group by trading_date) b,
(select trading_date, sum(total_vol) as vol from dibots_v2.exchange_dbt_stock where trading_date >= '2022-09-01'
group by trading_date) c
where a.trading_date = b.trading_date and a.trading_date = c.trading_date and a.vol <> b.vol + c.vol;

