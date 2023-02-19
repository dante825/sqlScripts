--===================================
-- ease of dropping and creating the several views that have a dependency on one another
--====================================

--=============  WARNING  ===================
-- CAUTION: Do check each view source to make sure it is the latest
--============  WARNING =====================

drop materialized view dibots_v2.growth_and_value_stock_medians;
drop view dibots_v2.growth_and_value_stock_master_view;
drop view staging.plc_annual_financial_ratio;
drop materialized view staging.plc_annual_financial_item;

--================================================================================

CREATE MATERIALIZED VIEW staging.plc_annual_financial_item
AS SELECT t3.wvb_hdr_id,
    t3.dbt_entity_id,
    t3.external_id,
    t3.wvb_company_id,
    t3.stock_code,
    t3.display_name,
    t3.fiscal_period_end_date,
    t3.months_in_period,
    t3.period_multiplier,
    t3.exchange_multiplier_used,
    t3.data_type,
    t3.data_type_adj,
    t3.profit * t3.period_multiplier AS profit,
    t3.dividend,
    t3.equity - coalesce(t3.minequity,0) as equity,
    t3_prev_period.fiscal_period_end_date AS date_prev,
    t3_prev_period.wvb_hdr_id AS wvb_hdr_id_prev,
    t3_prev_period.profit AS profit_prev,
    t3_prev_period.dividend AS dividend_prev,
    t3_prev_period.equity - coalesce(t3_prev_period.minequity) AS equity_prev
   FROM ( SELECT t2.wvb_hdr_id,
            t2.dbt_entity_id,
            t2.external_id,
            t2.wvb_company_id,
            t2.stock_code,
            t2.display_name,
            t2.fiscal_period_end_date,
            t2.months_in_period,
            12.00000000 / t2.months_in_period::numeric AS period_multiplier,
            usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate AS exchange_multiplier_used,
                CASE
                    WHEN wvb_calc_item_value_profit.data_type IS NOT NULL THEN wvb_calc_item_value_profit.data_type
                    ELSE wvb_calc_item_value_profit2.data_type
                END AS data_type,
                CASE
                    WHEN
                    CASE
                        WHEN wvb_calc_item_value_profit.data_type IS NOT NULL THEN wvb_calc_item_value_profit.data_type
                        ELSE wvb_calc_item_value_profit2.data_type
                    END::text = 'MYR'::text THEN 'MYR'::text
                    ELSE 'MYR-Converted'::text
                END AS data_type_adj,
                CASE
                    WHEN wvb_calc_item_value_profit.numeric_value IS NOT NULL THEN round(wvb_calc_item_value_profit.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                    ELSE round(wvb_calc_item_value_profit2.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                END AS profit,
                CASE
                    WHEN wvb_calc_item_value_dividend.numeric_value IS NOT NULL THEN round(wvb_calc_item_value_dividend.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                    ELSE round(wvb_calc_item_value_dividend2.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                END AS dividend,
                CASE
                    WHEN wvb_calc_item_value_equity.numeric_value IS NOT NULL THEN round(wvb_calc_item_value_equity.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                    ELSE round(wvb_calc_item_value_equity2.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                END AS equity,
                CASE
                    WHEN wvb_calc_item_value_minequity.numeric_value IS NOT NULL THEN round(wvb_calc_item_value_minequity.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                    ELSE round(wvb_calc_item_value_minequity2.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                END AS minequity
           FROM ( SELECT t1.wvb_hdr_id,
                    t1.dbt_entity_id,
                    t1.external_id,
                    t1.wvb_company_id,
                    t1.stock_code,
                    t1.display_name,
                    t1.fiscal_period_end_date,
                    t1.months_in_period,
                    t1.report_order
                   FROM ( SELECT analyst_hdr_view.wvb_hdr_id,
                            company_profile.dbt_entity_id,
                            company_profile.external_id,
                            company_profile.display_name,
                            company_profile.wvb_company_id,
                            company_stock.stock_code,
                            analyst_hdr_view.fiscal_period_end_date,
                            analyst_hdr_view.months_in_period,
                            dense_rank() OVER (PARTITION BY analyst_hdr_view.dbt_entity_id ORDER BY analyst_hdr_view.fiscal_period_end_date DESC) AS report_order,
                            rank() OVER (PARTITION BY analyst_hdr_view.dbt_entity_id, analyst_hdr_view.fiscal_period_end_date ORDER BY analyst_hdr_view.wvb_dtime_approved_for_prod DESC) AS fiscal_period_order
                           FROM dibots_v2.company_profile
                             JOIN dibots_v2.company_stock ON company_profile.dbt_entity_id = company_stock.dbt_entity_id
                             JOIN dibots_v2.analyst_hdr_view ON company_profile.dbt_entity_id = analyst_hdr_view.dbt_entity_id) t1
                  WHERE t1.report_order = 1 AND t1.fiscal_period_order = 1) t2
             LEFT JOIN dibots_v2.wvb_calc_item_value wvb_calc_item_value_profit ON wvb_calc_item_value_profit.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_profit.data_item_id = 3045 AND wvb_calc_item_value_profit.numeric_value IS NOT NULL
             LEFT JOIN dibots_v2.wvb_custom_item_value wvb_calc_item_value_profit2 ON wvb_calc_item_value_profit2.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_profit2.data_item_id = 3045 AND wvb_calc_item_value_profit2.numeric_value IS NOT NULL
             LEFT JOIN dibots_v2.wvb_calc_item_value wvb_calc_item_value_dividend ON wvb_calc_item_value_dividend.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_dividend.data_item_id = 3046 AND wvb_calc_item_value_dividend.numeric_value IS NOT NULL
             LEFT JOIN dibots_v2.wvb_custom_item_value wvb_calc_item_value_dividend2 ON wvb_calc_item_value_dividend2.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_dividend2.data_item_id = 3046 AND wvb_calc_item_value_dividend2.numeric_value IS NOT NULL
             LEFT JOIN dibots_v2.wvb_calc_item_value wvb_calc_item_value_equity ON wvb_calc_item_value_equity.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_equity.data_item_id = 4041 AND wvb_calc_item_value_equity.numeric_value IS NOT NULL
             LEFT JOIN dibots_v2.wvb_custom_item_value wvb_calc_item_value_equity2 ON wvb_calc_item_value_equity2.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_equity2.data_item_id = 4041 AND wvb_calc_item_value_equity2.numeric_value IS NOT null
             LEFT JOIN dibots_v2.wvb_calc_item_value wvb_calc_item_value_minequity ON wvb_calc_item_value_minequity.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_minequity.data_item_id = 4057 AND wvb_calc_item_value_minequity.numeric_value IS NOT NULL
             LEFT JOIN dibots_v2.wvb_custom_item_value wvb_calc_item_value_minequity2 ON wvb_calc_item_value_minequity2.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_minequity2.data_item_id = 4057 AND wvb_calc_item_value_minequity2.numeric_value IS NOT null
             LEFT JOIN dibots_v2.oanda_currency_rates ON t2.fiscal_period_end_date = oanda_currency_rates.rate_date AND COALESCE(wvb_calc_item_value_profit.data_type, wvb_calc_item_value_profit2.data_type)::text = oanda_currency_rates.iso_currency_code::text
             LEFT JOIN ( SELECT oanda_currency_rates_1.rate_date AS usdmyr_date,
                    oanda_currency_rates_1.iso_currency_code AS usdmyr_currency,
                    oanda_currency_rates_1.rate AS usdmyr_rate
                   FROM dibots_v2.oanda_currency_rates oanda_currency_rates_1) usdmyr_currency ON t2.fiscal_period_end_date = usdmyr_currency.usdmyr_date AND usdmyr_currency.usdmyr_currency::text = 'MYR'::text) t3
     LEFT JOIN ( SELECT DISTINCT t3_1.wvb_hdr_id,
            t3_1.dbt_entity_id,
            t3_1.external_id,
            t3_1.wvb_company_id,
            t3_1.stock_code,
            t3_1.display_name,
            t3_1.fiscal_period_end_date,
            t3_1.months_in_period,
            t3_1.period_multiplier,
            t3_1.exchange_multiplier_used,
            t3_1.data_type,
            t3_1.data_type_adj,
            t3_1.profit * t3_1.period_multiplier AS profit,
            t3_1.dividend,
            t3_1.equity,
            coalesce(t3_1.minequity,0) as minequity
           FROM ( SELECT t2.wvb_hdr_id,
                    t2.dbt_entity_id,
                    t2.external_id,
                    t2.wvb_company_id,
                    t2.stock_code,
                    t2.display_name,
                    t2.fiscal_period_end_date,
                    t2.months_in_period,
                    12.00000000 / t2.months_in_period::numeric AS period_multiplier,
                    usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate AS exchange_multiplier_used,
                        CASE
                            WHEN wvb_calc_item_value_profit.data_type IS NOT NULL THEN wvb_calc_item_value_profit.data_type
                            ELSE wvb_calc_item_value_profit2.data_type
                        END AS data_type,
                        CASE
                            WHEN
                            CASE
                                WHEN wvb_calc_item_value_profit.data_type IS NOT NULL THEN wvb_calc_item_value_profit.data_type
                                ELSE wvb_calc_item_value_profit2.data_type
                            END::text = 'MYR'::text THEN 'MYR'::text
                            ELSE 'MYR-Converted'::text
                        END AS data_type_adj,
                        CASE
                            WHEN wvb_calc_item_value_profit.numeric_value IS NOT NULL THEN round(wvb_calc_item_value_profit.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                            ELSE round(wvb_calc_item_value_profit2.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                        END AS profit,
                        CASE
                            WHEN wvb_calc_item_value_dividend.numeric_value IS NOT NULL THEN round(wvb_calc_item_value_dividend.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                            ELSE round(wvb_calc_item_value_dividend2.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                        END AS dividend,
                        CASE
                            WHEN wvb_calc_item_value_equity.numeric_value IS NOT NULL THEN round(wvb_calc_item_value_equity.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                            ELSE round(wvb_calc_item_value_equity2.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                        END AS equity,
                        CASE
                            WHEN wvb_calc_item_value_minequity.numeric_value IS NOT NULL THEN round(wvb_calc_item_value_minequity.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                            ELSE round(wvb_calc_item_value_minequity2.numeric_value * usdmyr_currency.usdmyr_rate / oanda_currency_rates.rate)
                        END AS minequity
                   FROM ( SELECT t1.wvb_hdr_id,
                            t1.dbt_entity_id,
                            t1.external_id,
                            t1.wvb_company_id,
                            t1.stock_code,
                            t1.display_name,
                            t1.fiscal_period_end_date,
                            t1.months_in_period,
                            t1.report_order
                           FROM ( SELECT analyst_hdr_view.wvb_hdr_id,
                                    company_profile.dbt_entity_id,
                                    company_profile.external_id,
                                    company_profile.display_name,
                                    company_profile.wvb_company_id,
                                    company_stock.stock_code,
                                    analyst_hdr_view.fiscal_period_end_date,
                                    analyst_hdr_view.months_in_period,
                                    dense_rank() OVER (PARTITION BY analyst_hdr_view.dbt_entity_id ORDER BY analyst_hdr_view.fiscal_period_end_date DESC) AS report_order,
                                    rank() OVER (PARTITION BY analyst_hdr_view.dbt_entity_id, analyst_hdr_view.fiscal_period_end_date ORDER BY analyst_hdr_view.wvb_dtime_approved_for_prod DESC) AS fiscal_period_order
                                   FROM dibots_v2.company_profile
                                     JOIN dibots_v2.company_stock ON company_profile.dbt_entity_id = company_stock.dbt_entity_id
                                     JOIN dibots_v2.analyst_hdr_view ON company_profile.dbt_entity_id = analyst_hdr_view.dbt_entity_id) t1
                          WHERE t1.report_order = 2 AND t1.fiscal_period_order = 1) t2
                     LEFT JOIN dibots_v2.wvb_calc_item_value wvb_calc_item_value_profit ON wvb_calc_item_value_profit.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_profit.data_item_id = 3045 AND wvb_calc_item_value_profit.numeric_value IS NOT NULL
                     LEFT JOIN dibots_v2.wvb_custom_item_value wvb_calc_item_value_profit2 ON wvb_calc_item_value_profit2.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_profit2.data_item_id = 3045 AND wvb_calc_item_value_profit2.numeric_value IS NOT NULL
                     LEFT JOIN dibots_v2.wvb_calc_item_value wvb_calc_item_value_dividend ON wvb_calc_item_value_dividend.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_dividend.data_item_id = 3046 AND wvb_calc_item_value_dividend.numeric_value IS NOT NULL
                     LEFT JOIN dibots_v2.wvb_custom_item_value wvb_calc_item_value_dividend2 ON wvb_calc_item_value_dividend2.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_dividend2.data_item_id = 3046 AND wvb_calc_item_value_dividend2.numeric_value IS NOT NULL
                     LEFT JOIN dibots_v2.wvb_calc_item_value wvb_calc_item_value_equity ON wvb_calc_item_value_equity.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_equity.data_item_id = 4041 AND wvb_calc_item_value_equity.numeric_value IS NOT NULL
                     LEFT JOIN dibots_v2.wvb_custom_item_value wvb_calc_item_value_equity2 ON wvb_calc_item_value_equity2.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_equity2.data_item_id = 4041 AND wvb_calc_item_value_equity2.numeric_value IS NOT null
                     LEFT JOIN dibots_v2.wvb_calc_item_value wvb_calc_item_value_minequity ON wvb_calc_item_value_minequity.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_minequity.data_item_id = 4057 AND wvb_calc_item_value_minequity.numeric_value IS NOT NULL
                     LEFT JOIN dibots_v2.wvb_custom_item_value wvb_calc_item_value_minequity2 ON wvb_calc_item_value_minequity2.wvb_hdr_id = t2.wvb_hdr_id AND wvb_calc_item_value_minequity2.data_item_id = 4057 AND wvb_calc_item_value_minequity2.numeric_value IS NOT null
                     LEFT JOIN dibots_v2.oanda_currency_rates ON t2.fiscal_period_end_date = oanda_currency_rates.rate_date AND COALESCE(wvb_calc_item_value_profit.data_type, wvb_calc_item_value_profit2.data_type)::text = oanda_currency_rates.iso_currency_code::text
                     LEFT JOIN ( SELECT oanda_currency_rates_1.rate_date AS usdmyr_date,
                            oanda_currency_rates_1.iso_currency_code AS usdmyr_currency,
                            oanda_currency_rates_1.rate AS usdmyr_rate
                           FROM dibots_v2.oanda_currency_rates oanda_currency_rates_1) usdmyr_currency ON t2.fiscal_period_end_date = usdmyr_currency.usdmyr_date AND usdmyr_currency.usdmyr_currency::text = 'MYR'::text) t3_1) t3_prev_period ON t3.dbt_entity_id = t3_prev_period.dbt_entity_id;


CREATE UNIQUE INDEX plc_ann_fin_uniq on staging.plc_annual_financial_item (dbt_entity_id);
CREATE INDEX plc_ann_fin_stock_idx on staging.plc_annual_financial_item (stock_code);
CREATE INDEX plc_ann_fin_ext_idx on staging.plc_annual_financial_item (external_id);


--=====================================================================

CREATE OR REPLACE VIEW staging.plc_annual_financial_ratio
AS SELECT a.dbt_entity_id,
    a.stock_code,
    a.display_name,
    a.board,
    a.sector,
    a.sub_sector,
    a.klci_flag,
    a.fbm100_flag,
    a.shariah_flag,
    a.esg_flag,
    (b.profit < 0::numeric) IS TRUE AS negative_profit,
    (b.equity < 0::numeric) IS TRUE AS negative_equity,
    a.ipo_date,
    b.fiscal_period_end_date,
    a.market_capitalisation,
    abs(b.dividend * 1000::numeric / NULLIF(a.market_capitalisation, 0::numeric) * 100::numeric) AS dy_latest_fy,
    a.market_capitalisation / NULLIF(b.equity * 1000::numeric, 0::numeric) AS ptbv_latest_fy,
    a.market_capitalisation / NULLIF(b.profit * 1000::numeric, 0::numeric) AS pe_latest_fy,
    b.date_prev AS fiscal_period_end_date_last_fy,
    t1.transaction_date AS market_cap_date_last_fy,
    (b.profit_prev < 0::numeric) IS TRUE AS negative_profit_prev,
    (b.equity_prev < 0::numeric) IS TRUE AS negative_equity_prev,
    t1.market_capitalisation AS market_capitalisation_last_fy,
    abs(b.dividend_prev * 1000::numeric / NULLIF(t1.market_capitalisation, 0::numeric) * 100::numeric) AS dy_last_fy,
    t1.market_capitalisation / NULLIF(b.equity_prev * 1000::numeric, 0::numeric) AS ptbv_last_fy,
    t1.market_capitalisation / NULLIF(b.profit_prev * 1000::numeric, 0::numeric) AS pe_last_fy,
    t1.board AS board_last_fy,
    t1.sector AS sector_last_fy
   FROM staging.plc_marketcap_maxdate a
     LEFT JOIN staging.plc_annual_financial_item b ON a.stock_code::text = b.stock_code::text
     LEFT JOIN ( SELECT c.stock_code,
            c.board,
            c.sector,
            c.market_capitalisation,
            c.shares_outstanding,
            c.transaction_date
           FROM dibots_v2.exchange_daily_transaction c
             JOIN ( SELECT a_1.stock_code,
                    max(a_1.transaction_date) AS transaction_date
                   FROM dibots_v2.exchange_daily_transaction a_1
                     JOIN staging.plc_annual_financial_item fin ON a_1.stock_code::text = fin.stock_code::text
                  WHERE a_1.transaction_date <= fin.date_prev
                  GROUP BY a_1.stock_code) d ON c.stock_code::text = d.stock_code::text AND c.transaction_date = d.transaction_date) t1 ON t1.stock_code::text = b.stock_code::text;

--======================================================================

CREATE OR REPLACE VIEW dibots_v2.growth_and_value_stock_master_view
AS SELECT mc.dbt_entity_id,
    mc.external_id,
    mc.stock_code,
    mc.company_short_name,
    mc.company_name,
    mc.board,
    mc.sector,
    mc.klci_flag,
    mc.fbm100_flag,
    mc.shariah_flag,
    mc.esg_flag,
    mc.f4gbm_flag,
    mc.market_capitalisation,
    mc.shares_outstanding,
    mc.difference_with_last_transaction_date AS market_cap_difference_with_last_transaction_date,
    an_ratio.market_capitalisation_last_fy AS prev_fy_marketcap,
    oyg.net_profit_growth AS latest_fy_one_year_growth,
    tyg.net_profit_growth AS latest_fy_three_year_growth,
    tyg.profitablein3y AS profitable_in_3y,
    fyg.net_profit_growth AS latest_fy_five_year_growth,
    fyg.profitablein5y AS profitable_in_5y,
    oyg.last_fy_net_profit_growth AS prev_fy_one_year_growth,
    tyg.last_fy_net_profit_growth AS prev_fy_three_year_growth,
    fyg.last_fy_net_profit_growth AS prev_fy_five_year_growth,
    oyg.net_profit_growth - oyg.last_fy_net_profit_growth AS latest_fy_one_year_growth_diff_with_prev_fy,
    tyg.net_profit_growth - tyg.last_fy_net_profit_growth AS latest_fy_three_year_growth_diff_with_prev_fy,
    fyg.net_profit_growth - fyg.last_fy_net_profit_growth AS latest_fy_five_year_growth_diff_with_prev_fy,
    lqnp.curr_net_profit AS latest_qr_net_profit,
    lqnp.quarter_to_quarter_net_profit AS qoq_net_profit,
    lqnp.quarter_on_quarter_growth_rate AS qoq_net_profit_growth_rate,
    lqnp.quarter_to_quarter_net_profit AS q2q_net_profit,
    lqnp.quarter_to_quarter_growth_rate AS q2q_net_profit_growth_rate,
    qr_ratio.ttm_profit AS ttm_net_profit,
    oyg.latest_fy_net_profit,
    oyg.prev_fy_net_profit,
        CASE
            WHEN qr_ratio.ttm_profit > oyg.latest_fy_net_profit THEN abs((qr_ratio.ttm_profit - oyg.latest_fy_net_profit) / NULLIF(oyg.latest_fy_net_profit, 0::numeric)) * 100::numeric
            WHEN qr_ratio.ttm_profit < oyg.latest_fy_net_profit THEN (- abs((qr_ratio.ttm_profit - oyg.latest_fy_net_profit) / NULLIF(oyg.latest_fy_net_profit, 0::numeric))) * 100::numeric
            ELSE NULL::numeric
        END AS ttm_fy_net_profit_growth_rate,
    ptp12m.trailing_pat_12m AS ttm_pat,
    lfpat.fiscal_period_end_date AS latest_fy_fye_date,
    lfpat.latest_fy_date_released,
    lfpat.curr_pat AS latest_fy_pat,
    lfpat.last_fy_pat AS prev_fy_pat,
    lqpat.curr_fiscal_period_end_date AS latest_qr_fye_date,
    lqnp.latest_qr_date_released,
    lqpat.curr_pat AS latest_qr_pat,
    lqpat.quarter_on_quarter_pat AS qoq_pat,
    lqpat.quarter_on_quarter_growth_rate AS qoq_pat_growth_rate,
    lqpat.quarter_to_quarter_pat AS q2q_pat,
    lqpat.quarter_to_quarter_growth_rate AS q2q_pat_growth_rate,
    an_ratio.ptbv_latest_fy AS latest_fy_ptb,
    an_ratio.ptbv_last_fy AS prev_fy_ptb,
    an_ratio.ptbv_latest_fy - an_ratio.ptbv_last_fy AS latest_fy_ptb_diff_with_prev_fy,
    qr_ratio.ptbv_latest_qr AS ttm_ptb,
    qr_ratio.ptbv_latest_qr - an_ratio.ptbv_last_fy AS ttm_ptb_diff_with_prev_fy,
    an_ratio.pe_latest_fy AS latest_fy_pe,
    an_ratio.pe_last_fy AS prev_fy_pe,
    an_ratio.pe_latest_fy - an_ratio.pe_last_fy AS latest_fy_pe_diff_with_prev_fy,
    ttm_pe.daily_pe AS ttm_pe,
    ttm_pe.daily_pe - an_ratio.pe_last_fy AS ttm_pe_diff_with_prev_fy,
    an_ratio.dy_latest_fy AS latest_fy_dy,
    an_ratio.dy_last_fy AS prev_fy_dy,
    qr_ratio.div_yield AS ttm_dy,
    ptr.d_return AS day_return,
    ptr.w_return AS week_return,
    ptr.m_return AS month_return,
    ptr.q_return AS quarter_return,
    ptr.y_return AS year_return,
    ptr.ytd_return,
    qr_ratio.eps_latest_qr AS ttm_eps,
    qr_ratio.nta_pershare_latest_qr,
    qr_ratio.negative_profit,
    qr_ratio.negative_equity
   FROM dibots_v2.latest_bursa_stock_market_capitalisation mc
     LEFT JOIN dibots_v2.latest_bursa_stock_one_year_net_profit_growth oyg ON oyg.stock_code::text = mc.stock_code::text
     LEFT JOIN dibots_v2.latest_bursa_stock_three_year_net_profit_growth tyg ON tyg.stock_code::text = mc.stock_code::text
     LEFT JOIN dibots_v2.latest_bursa_stock_five_year_net_profit_growth fyg ON fyg.stock_code::text = mc.stock_code::text
     LEFT JOIN dibots_v2.latest_fy_bursa_stock_pat lfpat ON lfpat.stock_code::text = mc.stock_code::text
     LEFT JOIN staging.plc_annual_financial_ratio an_ratio ON an_ratio.stock_code::text = mc.stock_code::text
     LEFT JOIN staging.plc_latestqr_ratio qr_ratio ON qr_ratio.stock_code::text = mc.stock_code::text
     LEFT JOIN dibots_v2.plc_daily_pe ttm_pe ON ttm_pe.stock_code::text = mc.stock_code::text
     LEFT JOIN dibots_v2.latest_bursa_stock_pat lqpat ON lqpat.stock_code::text = mc.stock_code::text
     LEFT JOIN dibots_v2.latest_qr_bursa_stock_net_profit lqnp ON lqnp.stock_code::text = mc.stock_code::text
     LEFT JOIN dibots_v2.plc_total_return ptr ON ptr.stock_code::text = mc.stock_code::text
     LEFT JOIN staging.plc_trailing_pat_12m ptp12m ON ptp12m.stock_code::text = mc.stock_code::text;

--===============================================================================

CREATE MATERIALIZED VIEW dibots_v2.growth_and_value_stock_medians
TABLESPACE pg_default
AS SELECT t1.board,
    t1.sector,
    t1.klci_flag,
    t1.fbm100_flag,
    t1.shariah_flag,
    t1.f4gbm_flag,
    t1.median_ttm_ptb,
    t1.median_ttm_pe,
    t1.median_ttm_dy,
    t1.median_ptb_latest_fy,
    t1.median_pe_latest_fy,
    t1.median_dy_latest_fy,
    t1.median_one_year_growth_latest_fy,
    t1.median_three_year_growth_latest_fy,
    t1.median_five_year_growth_latest_fy,
    t1.median_ptb_prev_fy,
    t1.median_pe_prev_fy,
    t1.median_dy_prev_fy,
    t1.median_one_year_growth_prev_fy,
    t1.median_three_year_growth_prev_fy,
    t1.median_five_year_growth_prev_fy
   FROM ( 
      -- 1. KLCI + ALL sector
      SELECT 'ALL'::character varying as board,
             'ALL'::character varying as sector,
            true as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.klci_flag = true
        UNION
        -- 2. KLCI + ALL sector + shariah
        SELECT 'ALL'::character varying as board,
             'ALL'::character varying as sector,
            true as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.klci_flag = true and gavsmv.shariah_flag = true
        union
        -- 3. KLCI + ALL sector + f4gbm
        SELECT 'ALL'::character varying as board,
             'ALL'::character varying as sector,
            true as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.klci_flag = true and gavsmv.f4gbm_flag = true
        union
        -- 4. KLCI + ALL sector + shariah + f4gbm
        SELECT 'ALL'::character varying as board,
             'ALL'::character varying as sector,
            true as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.klci_flag = true and gavsmv.shariah_flag = true and gavsmv.f4gbm_flag = true
        union
        -- 5. KLCI + 1 sector
        SELECT 'ALL'::character varying as board,
             gavsmv.sector,
            true as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.klci_flag = true
           group by gavsmv.sector
        union
         -- 6. KLCI + 1 sector + shariah
        SELECT 'ALL'::character varying as board,
             gavsmv.sector,
            true as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.klci_flag = true and gavsmv.shariah_flag = true
           group by gavsmv.sector
        union
        -- 7. KLCI + 1 sector + f4gbm
        SELECT 'ALL'::character varying as board,
             gavsmv.sector,
            true as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.klci_flag = true and gavsmv.f4gbm_flag = true
           group by gavsmv.sector
        union
        -- 8. KLCI + 1 sector + shariah + f4gbm
        SELECT 'ALL'::character varying as board,
             gavsmv.sector,
            true as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.klci_flag = true and gavsmv.shariah_flag = true and gavsmv.f4gbm_flag = true
           group by gavsmv.sector
        union
        -- 9. FBM100 + ALL sector
        SELECT 'ALL'::character varying as board,
            'ALL'::character varying as sector,
            false as klci_flag,
            true as fbm100_flag,
            false as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.fbm100_flag = true
        union
        -- 10. FBM100 + ALL sector + shariah
        SELECT 'ALL'::character varying as board,
            'ALL'::character varying as sector,
            false as klci_flag,
            true as fbm100_flag,
            true as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.fbm100_flag = true and gavsmv.shariah_flag = true
        union
        -- 11. FBM100 + ALL sector + f4gbm
        SELECT 'ALL'::character varying as board,
            'ALL'::character varying as sector,
            false as klci_flag,
            true as fbm100_flag,
            false as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.fbm100_flag = true and gavsmv.f4gbm_flag = true
        union
        -- 12. FBM100 + ALL sector + shariah + f4gbm
        SELECT 'ALL'::character varying as board,
            'ALL'::character varying as sector,
            false as klci_flag,
            true as fbm100_flag,
            true as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.fbm100_flag = true and gavsmv.shariah_flag = true and gavsmv.f4gbm_flag = true
        union
        -- 13. FBM100 + 1 sector
        SELECT 'ALL'::character varying as board,
            gavsmv.sector,
            false as klci_flag,
            true as fbm100_flag,
            false as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.fbm100_flag = true
           group by gavsmv.sector
        union
        -- 14. FBM100 + 1 sector + shariah
        SELECT 'ALL'::character varying as board,
            gavsmv.sector,
            false as klci_flag,
            true as fbm100_flag,
            true as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.fbm100_flag = true and gavsmv.shariah_flag = true
           group by gavsmv.sector
        union
        -- 15. FBM100 + 1 sector + f4gbm
        SELECT 'ALL'::character varying as board,
            gavsmv.sector,
            false as klci_flag,
            true as fbm100_flag,
            false as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.fbm100_flag = true and gavsmv.f4gbm_flag = true
           group by gavsmv.sector
        union
        -- 16. FBM100 + 1 sector + shariah + f4gbm
        SELECT 'ALL'::character varying as board,
            gavsmv.sector,
            false as klci_flag,
            true as fbm100_flag,
            true as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.fbm100_flag = true and gavsmv.shariah_flag = true and gavsmv.f4gbm_flag = true
           group by gavsmv.sector
        union
         -- 17. ALL board + ALL sector
        SELECT 'ALL'::character varying as board,
            'ALL'::character varying as sector,
            false as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
        union
        -- 18. ALL board + ALL sector + shariah
        SELECT 'ALL'::character varying as board,
            'ALL'::character varying as sector,
            false as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.shariah_flag = true
        union
        -- 19. ALL board + ALL sector + f4gbm
        SELECT 'ALL'::character varying as board,
            'ALL'::character varying as sector,
            false as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.f4gbm_flag = true
        union
        -- 20. ALL board + ALL sector + shariah + f4gbm
        SELECT 'ALL'::character varying as board,
            'ALL'::character varying as sector,
            false as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.shariah_flag = true and gavsmv.f4gbm_flag = true
        union
        -- 21. 1 board + ALL sector
        SELECT gavsmv.board,
            'ALL'::character varying as sector,
            false as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           group by gavsmv.board
        union
        -- 22. 1 board + ALL sector + shariah
        SELECT gavsmv.board,
            'ALL'::character varying as sector,
            false as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.shariah_flag = true
           group by gavsmv.board
        union
        -- 23. 1 board + ALL sector + f4gbm
        SELECT gavsmv.board,
            'ALL'::character varying as sector,
            false as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.f4gbm_flag = true
           group by gavsmv.board
        union
        -- 24. 1 board + ALL sector + shariah + f4gbm
        SELECT gavsmv.board,
            'ALL'::character varying as sector,
            false as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.shariah_flag = true and gavsmv.f4gbm_flag = true
           group by gavsmv.board
        union
        -- 25. ALL board + 1 sector
        SELECT 'ALL'::character varying as board,
            gavsmv.sector,
            false as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           group by gavsmv.sector
        union
        -- 26. ALL board + 1 sector + shariah
        SELECT 'ALL'::character varying as board,
            gavsmv.sector,
            false as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.shariah_flag = true
           group by gavsmv.sector
        union
        -- 27. ALL board + 1 sector + f4gbm
        SELECT 'ALL'::character varying as board,
            gavsmv.sector,
            false as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.f4gbm_flag = true
           group by gavsmv.sector
        union
        -- 28. ALL board + 1 sector + shariah + f4gbm
        SELECT 'ALL'::character varying as board,
            gavsmv.sector,
            false as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.shariah_flag = true and gavsmv.f4gbm_flag = true
           group by gavsmv.sector
        union
        -- 29. 1 board + 1 sector
        SELECT gavsmv.board,
            gavsmv.sector,
            false as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           group by gavsmv.board, gavsmv.sector
        union
        -- 30. 1 board + 1 sector + shariah
        SELECT gavsmv.board,
            gavsmv.sector,
            false as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            false as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.shariah_flag = true
           group by gavsmv.board, gavsmv.sector
        union
        -- 31. 1 board + 1 sector + f4gbm
        SELECT gavsmv.board,
            gavsmv.sector,
            false as klci_flag,
            false as fbm100_flag,
            false as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.f4gbm_flag = true
           group by gavsmv.board, gavsmv.sector
        union
        -- 32. 1 board + 1 sector + shariah + f4gbm
        SELECT gavsmv.board,
            gavsmv.sector,
            false as klci_flag,
            false as fbm100_flag,
            true as shariah_flag,
            true as f4gbm_flag,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_ptb::double precision)) FILTER (WHERE gavsmv.ttm_ptb > 0::numeric AND gavsmv.negative_equity = false) AS median_ttm_ptb,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_pe::double precision)) FILTER (WHERE gavsmv.ttm_pe > 0::numeric AND gavsmv.negative_profit = false) AS median_ttm_pe,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.ttm_dy::double precision)) FILTER (WHERE gavsmv.ttm_dy > 0::numeric) AS median_ttm_dy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_ptb::double precision)) FILTER (WHERE gavsmv.latest_fy_ptb > 0::numeric) AS median_ptb_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_pe::double precision)) FILTER (WHERE gavsmv.latest_fy_pe > 0::numeric) AS median_pe_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_dy::double precision)) FILTER (WHERE gavsmv.latest_fy_dy > 0::numeric) AS median_dy_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_one_year_growth > 0::numeric) AS median_one_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_three_year_growth > 0::numeric) AS median_three_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.latest_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.latest_fy_net_profit > 0::numeric AND gavsmv.latest_fy_five_year_growth > 0::numeric) AS median_five_year_growth_latest_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_ptb::double precision)) FILTER (WHERE gavsmv.prev_fy_ptb > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_ptb_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_pe::double precision)) FILTER (WHERE gavsmv.prev_fy_pe > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_pe_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_dy::double precision)) FILTER (WHERE gavsmv.prev_fy_dy > 0::numeric AND gavsmv.prev_fy_marketcap IS NOT NULL) AS median_dy_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_one_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_one_year_growth > 0::numeric) AS median_one_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_three_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_three_year_growth > 0::numeric) AS median_three_year_growth_prev_fy,
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (gavsmv.prev_fy_five_year_growth::double precision)) FILTER (WHERE gavsmv.prev_fy_marketcap IS NOT NULL AND gavsmv.prev_fy_net_profit > 0::numeric AND gavsmv.prev_fy_five_year_growth > 0::numeric) AS median_five_year_growth_prev_fy
           FROM dibots_v2.growth_and_value_stock_master_view gavsmv
           where gavsmv.shariah_flag = true and gavsmv.f4gbm_flag = true
           group by gavsmv.board, gavsmv.sector) t1
WITH DATA;

CREATE UNIQUE INDEX growth_and_value_stock_medians_uniq on dibots_v2.growth_and_value_stock_medians (board, sector, klci_flag, fbm100_flag, shariah_flag, f4gbm_flag);