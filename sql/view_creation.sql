--========================
-- NET SHORT POSITION
--========================

-- DEPRECATED
-- exchange_net_short_position_latest_view (an intermediate view for exchange_shortselling_pos_view to get the latest net_short_position)
create or replace view dibots_v2.exchange_netshort_pos_latest_view as 
SELECT a.trading_date, a.stock_code, a.stock_name, a.board, a.sector, a.klci_flag, a.fbm100_flag, a.shariah_flag, a.net_short_position_vol, a.net_short_position_pct,
rank () OVER (PARTITION BY a.stock_code ORDER BY a.trading_date DESC) AS dt_latest 
FROM dibots_v2.exchange_net_short_position a;

-- DEPRECATED
-- exchange_shortselling_pos_view (the stock short selling vol val with its latest net short position)
create or replace view dibots_v2.exchange_shortselling_pos_view
as SELECT ss.trading_date, ss.week_count, ss.year, ss.month, ss.stock_code, ss.stock_name, ss.stock_num, ss.board, ss.sector, ss.klci_flag, ss.fbm100_flag, ss.shariah_flag, 
ss.rss_volume, ss.rss_value, ss.idss_volume, ss.idss_value, ss.pss_volume, ss.pss_value, ss.pdt_volume, ss.pdt_value, ss.total_volume, ss.total_value,
np.trading_date as net_short_date, np.net_short_position_vol, np.net_short_position_pct
FROM dibots_v2.exchange_short_selling ss
LEFT JOIN dibots_v2.exchange_netshort_pos_latest_view np ON
ss.stock_code = np.stock_code AND np.dt_latest = 1;

-- exchange_shortselling_sync_view (the short selling and net short are changing according to date)
create or replace view dibots_v2.exchange_shortselling_sync_view AS
select coalesce(a.trading_date, b.trading_date) as trading_date, to_char(coalesce(a.trading_date, b.trading_date), 'IYYY-IW') as week_count, 
coalesce(a.stock_code, b.stock_code) as stock_code, coalesce(a.stock_name, b.stock_name) as stock_name, a.stock_num,
coalesce(a.board, b.board) as board, coalesce(a.sector, b.sector) as sector, coalesce(a.klci_flag, b.klci_flag) as klci_flag, coalesce(a.fbm100_flag, b.fbm100_flag) as fbm100_flag,
coalesce(a.shariah_flag, b.shariah_flag) as shariah_flag, a.rss_volume, a.rss_value, a.idss_volume, a.idss_value, a.pss_volume, a.pss_value, a.pdt_volume, a.pdt_value, 
a.total_volume, a.total_value, b.net_short_position_vol, b.net_short_position_pct
from dibots_v2.exchange_short_selling a
full join dibots_v2.exchange_net_short_position b on a.trading_date = b.trading_date and a.stock_code = b.stock_code;


-- left join with agg
select a.stock_code, a.stock_name, sum(b.total_volume), sum(b.total_value), a.trading_date, a.net_short_position_vol, a.net_short_position_pct
from dibots_v2.exchange_netshort_pos_latest_view a
left join dibots_v2.exchange_short_selling b
on a.stock_code = b.stock_code and b.trading_date between '2021-02-01' and '2021-02-04' 
where a.dt_latest = 1 AND a.board = 'MAIN MARKET' and a.sector = 'HEALTH CARE'
group by a.trading_date, a.stock_code, a.stock_name, a.net_short_position_vol, a.net_short_position_pct

update dibots_v2.exchange_net_short_position a
set
board = b.board,
sector = b.sector,
klci_flag = b.klci_flag,
fbm100_flag = b.fbm100_flag,
shariah_flag = b.shariah_flag
from dibots_v2.exchange_daily_transaction b
where a.stock_code = b.stock_code and a.trading_date = b.transaction_date
and a.board is null;

--========================
-- AFFILIATED_COMP_VIEW
--========================

CREATE OR REPLACE VIEW dibots_v2.affiliated_comp_view
AS SELECT tmp.id, tmp.wvb_owner_id, tmp.owner_id, tmp.wvb_equity_id, tmp.security_owner_type, tmp.wvb_company_id, tmp.company_id, tmp.closely_held_flag, tmp.eff_from_date, 
tmp.eff_thru_date, tmp.nbr_of_shares, tmp.nbr_of_votes, tmp.pct_of_shares, tmp.pct_of_votes, tmp.indirect_nbr_of_shares, tmp.indirect_nbr_of_votes, tmp.indirect_pct_of_shares, 
tmp.indirect_pct_of_votes, tmp.handling_code, tmp.scaling_factor_exponent, tmp.original_eff_from_date, tmp.is_deleted, tmp.is_approved, tmp.wvb_last_updated_dtime, 
tmp.created_dtime, tmp.created_by, tmp.modified_dtime, tmp.modified_by, tmp.calc_pct_of_shares, tmp.calc_pct_of_votes, tmp.has_owner_profile, tmp.previous_owner_id, 
tmp.previous_company_id, tmp.owner_name, tmp.company_name, tmp.owner_nationality, tmp.company_nationality, tmp.comp_status_desc, tmp.total_nbr_of_shares, tmp.total_pct_of_shares 
FROM ( SELECT a.id, a.wvb_owner_id, a.owner_id, a.wvb_equity_id, a.security_owner_type, a.wvb_company_id, a.company_id, a.closely_held_flag, a.eff_from_date, a.eff_thru_date, 
	a.nbr_of_shares, a.nbr_of_votes, a.pct_of_shares, a.pct_of_votes, a.indirect_nbr_of_shares, a.indirect_nbr_of_votes, a.indirect_pct_of_shares, a.indirect_pct_of_votes, 
	a.handling_code, a.scaling_factor_exponent, a.original_eff_from_date, a.is_deleted, a.is_approved, a.wvb_last_updated_dtime, a.created_dtime, a.created_by, a.modified_dtime, 
	a.modified_by, a.calc_pct_of_shares, a.calc_pct_of_votes, a.has_owner_profile, a.previous_owner_id, a.previous_company_id, a.owner_name, a.company_name, a.owner_nationality, 
	a.company_nationality, a.comp_status_desc, a.total_nbr_of_shares, a.total_pct_of_shares 
	FROM dibots_v2.equity_security_owner a LEFT JOIN dibots_v2.wvb_company_subsidiary b ON a.company_id = b.subsidiary_id 
	WHERE b.subsidiary_id IS NULL) tmp;



--===============================
-- EE_EARNING_ESTIMATES_HDR_VIEW
--===============================

-- only get the latest research report based on the forecast_period_code when provider_id, forecast_release_date, and company_perm_id are the same

CREATE OR REPLACE VIEW dibots_v2.ee_earning_estimates_hdr_view
AS SELECT tmp.row_number, tmp.estimate_id, tmp.provider_id, tmp.analyst_id, tmp.company_perm_id, tmp.dbt_entity_id, tmp.external_id, tmp.wvb_number, tmp.mic, 
tmp.ticker, tmp.value_unit, tmp.forecast_begin_date, tmp.forecast_end_date, tmp.forecast_period_code, tmp.fiscal_year_start_month, tmp.handling_code, tmp.file_id,
tmp.forecast_issue_date, tmp.forecast_release_date, tmp.iso_currency_code, tmp.is_deleted, tmp.research_type, tmp.extracted_code, tmp.research_sector, 
tmp.research_content, tmp.file_dir, tmp.origin_file_name, tmp.doc_code, tmp.file_source, tmp.file_uploader, 
tmp.created_dtime, tmp.created_by, tmp.modified_dtime,tmp.modified_by
FROM ( SELECT row_number() OVER (PARTITION BY a.file_id, a.forecast_release_date, a.dbt_entity_id ORDER BY a.forecast_period_code DESC) AS row_number,
            a.estimate_id, a.provider_id, a.analyst_id, a.company_perm_id, a.dbt_entity_id, a.external_id, a.wvb_number, a.mic, a.ticker, a.value_unit,
            a.forecast_begin_date, a.forecast_end_date, a.forecast_period_code, a.fiscal_year_start_month, a.handling_code, a.file_id, a.forecast_issue_date, 
            a.forecast_release_date, a.iso_currency_code, a.is_deleted, b.research_type, b.extracted_code, b.research_sector, b.file_dir, b.origin_file_name, 
            b.doc_code, b.file_source, b.file_uploader, b.research_content,
            a.created_dtime, a.created_by, a.modified_dtime, a.modified_by
           FROM dibots_v2.ee_earning_estimates_hdr a
             JOIN dibots_v2.ee_spreadsheet_files b ON a.file_id = b.file_id
          WHERE b.is_deleted = false) tmp
  WHERE tmp.row_number = 1 AND tmp.is_deleted = false;


-- research report view, similar with the view above, but use ee_spreadsheet_files as the starting point
-- condition COALESCE(b.is_deleted, false) = false, is added because files uploaded by user, before full extraction would only be in ee_spreadsheet_files,
-- these files need to be in the view as well for displaying user uploaded files
-- Extracted code mapping
-- 0 = File Uploaded
-- 100 = Extraction Completed
-- 110 = Extraction Completed Without Signal
-- 200 = Extraction Incomplete
-- 300 = Modified

CREATE OR REPLACE VIEW dibots_v2.research_report_view
AS SELECT tmp.row_number, tmp.estimate_id, tmp.provider_id, tmp.analyst_id, tmp.company_perm_id, tmp.dbt_entity_id, tmp.external_id, tmp.wvb_number, tmp.mic, 
tmp.ticker, tmp.value_unit, tmp.forecast_begin_date, tmp.forecast_end_date, tmp.forecast_period_code, tmp.fiscal_year_start_month, tmp.handling_code, tmp.file_id,
tmp.forecast_issue_date, tmp.forecast_release_date, tmp.iso_currency_code, tmp.hdr_deleted, tmp.file_deleted, tmp.research_type, tmp.extracted_code, tmp.research_sector, 
tmp.research_content, tmp.research_entities, tmp.file_dir, tmp.origin_file_name, tmp.doc_code, tmp.file_source, 
COALESCE(tmp.file_uploader, 'WVB') as file_uploader, tmp.file_upload_date,
tmp.created_dtime, tmp.created_by, tmp.modified_dtime,tmp.modified_by
FROM (SELECT row_number() OVER (PARTITION BY btrim(a.file_dir), btrim(a.doc_code) ORDER BY a.file_id DESC) AS row_number, 
      b.estimate_id, b.provider_id, b.analyst_id, b.company_perm_id, b.dbt_entity_id, b.external_id, b.wvb_number, b.mic, b.ticker, b.value_unit, 
      b.forecast_begin_date, b.forecast_end_date, b.forecast_period_code, b.fiscal_year_start_month, b.handling_code, a.file_id, b.forecast_issue_date,
      b.forecast_release_date, b.iso_currency_code, coalesce(a.is_deleted, false) as file_deleted, coalesce(b.is_deleted, false) as hdr_deleted, 
      a.research_type, a.extracted_code, 
      a.research_sector, btrim(a.file_dir) as file_dir, 
      btrim(a.origin_file_name) as origin_file_name, btrim(a.doc_code) as doc_code, a.file_upload_date,
      a.file_source, a.file_uploader, a.research_content, a.research_entities,
      a.created_dtime, a.created_by, a.modified_dtime, a.modified_by 
      FROM dibots_v2.ee_spreadsheet_files a 
      LEFT JOIN dibots_v2.ee_earning_estimates_hdr b ON a.file_id = b.file_id
      where COALESCE(b.is_deleted,false) = false and a.file_dir is not null) tmp
WHERE tmp.row_number = 1;


--====================================
-- GROWTH_AND_VALUE_STOCK_MASTER_VIEW
--====================================
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

--===========================
-- PLC_TOTAL_RETURN_VIEW
--===========================

REFRESH MATERIALIZED VIEW CONCURRENTLY dibots_v2.plc_total_return;

CREATE MATERIALIZED VIEW dibots_v2.plc_total_return
AS SELECT tday.dbt_entity_id,
    tday.stock_code,
    tday.display_name,
    tday.d_return,
    tweek.w_return,
    tmonth.m_return,
    tquarter.q_return,
    tyear.y_return,
    tytd.ytd_return
   FROM ( SELECT t1.dbt_entity_id,
            t1.stock_code,
            t1.display_name,
            t1.start_date,
            t1.end_date,
            (tmax.adj_closing / tmax.factor - t1.div_cost / tmax.factor - tmin.adj_lacp / tmax.factor) / (tmin.adj_lacp / tmax.factor) * 100::numeric AS d_return
           FROM ( SELECT a.dbt_entity_id,
                    a.display_name,
                    b.stock_code,
                    min(b.transaction_date) AS start_date,
                    max(b.transaction_date) AS end_date,
                    COALESCE(sum(c.div_cost), 0::numeric) AS div_cost
                   FROM dibots_v2.company_stock_named a
                     LEFT JOIN dibots_v2.exchange_daily_transaction b ON a.stock_code::text = b.stock_code::text
                     LEFT JOIN staging.exchange_factor_details c ON a.stock_code::text = c.stock_code::text AND b.transaction_date = c.transaction_date AND c.div IS NOT NULL AND c.price_adj <> 0::numeric AND c.remarks = 'ok'::text
                  WHERE b.transaction_date = (( SELECT max(exchange_daily_transaction.transaction_date) AS max_date
                           FROM dibots_v2.exchange_daily_transaction))
                  GROUP BY b.stock_code, a.display_name, a.dbt_entity_id) t1
             JOIN dibots_v2.exchange_daily_transaction tmin ON t1.stock_code::text = tmin.stock_code::text AND t1.start_date = tmin.transaction_date
             JOIN dibots_v2.exchange_daily_transaction tmax ON t1.stock_code::text = tmax.stock_code::text AND t1.end_date = tmax.transaction_date) tday
     JOIN ( SELECT t1.dbt_entity_id,
            t1.stock_code,
            t1.start_date,
            t1.end_date,
            (tmax.adj_closing / tmax.factor - t1.div_cost / tmax.factor - tmin.adj_lacp / tmax.factor) / (tmin.adj_lacp / tmax.factor) * 100::numeric AS w_return
           FROM ( SELECT a.dbt_entity_id,
                    a.display_name,
                    b.stock_code,
                    min(b.transaction_date) AS start_date,
                    max(b.transaction_date) AS end_date,
                    COALESCE(sum(c.div_cost), 0::numeric) AS div_cost
                   FROM dibots_v2.company_stock_named a
                     LEFT JOIN dibots_v2.exchange_daily_transaction b ON a.stock_code::text = b.stock_code::text
                     LEFT JOIN staging.exchange_factor_details c ON a.stock_code::text = c.stock_code::text AND b.transaction_date = c.transaction_date AND c.div IS NOT NULL AND c.price_adj <> 0::numeric AND c.remarks = 'ok'::text
                  WHERE b.transaction_date > ((( SELECT max(exchange_daily_transaction.transaction_date) AS max_date
                           FROM dibots_v2.exchange_daily_transaction)) - '7 days'::interval)
                  GROUP BY b.stock_code, a.display_name, a.dbt_entity_id) t1
             JOIN dibots_v2.exchange_daily_transaction tmin ON t1.stock_code::text = tmin.stock_code::text AND t1.start_date = tmin.transaction_date
             JOIN dibots_v2.exchange_daily_transaction tmax ON t1.stock_code::text = tmax.stock_code::text AND t1.end_date = tmax.transaction_date) tweek ON tday.stock_code::text = tweek.stock_code::text
     JOIN ( SELECT t1.dbt_entity_id,
            t1.stock_code,
            t1.start_date,
            t1.end_date,
            (tmax.adj_closing / tmax.factor - t1.div_cost / tmax.factor - tmin.adj_lacp / tmax.factor) / (tmin.adj_lacp / tmax.factor) * 100::numeric AS m_return
           FROM ( SELECT a.dbt_entity_id,
                    a.display_name,
                    b.stock_code,
                    min(b.transaction_date) AS start_date,
                    max(b.transaction_date) AS end_date,
                    COALESCE(sum(c.div_cost), 0::numeric) AS div_cost
                   FROM dibots_v2.company_stock_named a
                     LEFT JOIN dibots_v2.exchange_daily_transaction b ON a.stock_code::text = b.stock_code::text
                     LEFT JOIN staging.exchange_factor_details c ON a.stock_code::text = c.stock_code::text AND b.transaction_date = c.transaction_date AND c.div IS NOT NULL AND c.price_adj <> 0::numeric AND c.remarks = 'ok'::text
                  WHERE b.transaction_date > ((( SELECT max(exchange_daily_transaction.transaction_date) AS max_date
                           FROM dibots_v2.exchange_daily_transaction)) - '1 mon'::interval)
                  GROUP BY b.stock_code, a.display_name, a.dbt_entity_id) t1
             JOIN dibots_v2.exchange_daily_transaction tmin ON t1.stock_code::text = tmin.stock_code::text AND t1.start_date = tmin.transaction_date
             JOIN dibots_v2.exchange_daily_transaction tmax ON t1.stock_code::text = tmax.stock_code::text AND t1.end_date = tmax.transaction_date) tmonth ON tday.stock_code::text = tmonth.stock_code::text
     JOIN ( SELECT t1.dbt_entity_id,
            t1.stock_code,
            t1.start_date,
            t1.end_date,
            (tmax.adj_closing / tmax.factor - t1.div_cost / tmax.factor - tmin.adj_lacp / tmax.factor) / (tmin.adj_lacp / tmax.factor) * 100::numeric AS q_return
           FROM ( SELECT a.dbt_entity_id,
                    a.display_name,
                    b.stock_code,
                    min(b.transaction_date) AS start_date,
                    max(b.transaction_date) AS end_date,
                    COALESCE(sum(c.div_cost), 0::numeric) AS div_cost
                   FROM dibots_v2.company_stock_named a
                     LEFT JOIN dibots_v2.exchange_daily_transaction b ON a.stock_code::text = b.stock_code::text
                     LEFT JOIN staging.exchange_factor_details c ON a.stock_code::text = c.stock_code::text AND b.transaction_date = c.transaction_date AND c.div IS NOT NULL AND c.price_adj <> 0::numeric AND c.remarks = 'ok'::text
                  WHERE b.transaction_date > ((( SELECT max(exchange_daily_transaction.transaction_date) AS max_date
                           FROM dibots_v2.exchange_daily_transaction)) - '3 mons'::interval)
                  GROUP BY b.stock_code, a.display_name, a.dbt_entity_id) t1
             JOIN dibots_v2.exchange_daily_transaction tmin ON t1.stock_code::text = tmin.stock_code::text AND t1.start_date = tmin.transaction_date
             JOIN dibots_v2.exchange_daily_transaction tmax ON t1.stock_code::text = tmax.stock_code::text AND t1.end_date = tmax.transaction_date) tquarter ON tday.stock_code::text = tquarter.stock_code::text
     JOIN ( SELECT t1.dbt_entity_id,
            t1.stock_code,
            t1.start_date,
            t1.end_date,
            (tmax.adj_closing / tmax.factor - t1.div_cost / tmax.factor - tmin.adj_lacp / tmax.factor) / (tmin.adj_lacp / tmax.factor) * 100::numeric AS y_return
           FROM ( SELECT a.dbt_entity_id,
                    a.display_name,
                    b.stock_code,
                    min(b.transaction_date) AS start_date,
                    max(b.transaction_date) AS end_date,
                    COALESCE(sum(c.div_cost), 0::numeric) AS div_cost
                   FROM dibots_v2.company_stock_named a
                     LEFT JOIN dibots_v2.exchange_daily_transaction b ON a.stock_code::text = b.stock_code::text
                     LEFT JOIN staging.exchange_factor_details c ON a.stock_code::text = c.stock_code::text AND b.transaction_date = c.transaction_date AND c.div IS NOT NULL AND c.price_adj <> 0::numeric AND c.remarks = 'ok'::text
                  WHERE b.transaction_date > ((( SELECT max(exchange_daily_transaction.transaction_date) AS max_date
                           FROM dibots_v2.exchange_daily_transaction)) - '1 year'::interval)
                  GROUP BY b.stock_code, a.display_name, a.dbt_entity_id) t1
             JOIN dibots_v2.exchange_daily_transaction tmin ON t1.stock_code::text = tmin.stock_code::text AND t1.start_date = tmin.transaction_date
             JOIN dibots_v2.exchange_daily_transaction tmax ON t1.stock_code::text = tmax.stock_code::text AND t1.end_date = tmax.transaction_date) tyear ON tday.stock_code::text = tyear.stock_code::text
     JOIN ( SELECT t1.dbt_entity_id,
            t1.stock_code,
            t1.start_date,
            t1.end_date,
            (tmax.adj_closing / tmax.factor - t1.div_cost / tmax.factor - tmin.adj_lacp / tmax.factor) / (tmin.adj_lacp / tmax.factor) * 100::numeric AS ytd_return
           FROM ( SELECT a.dbt_entity_id,
                    a.display_name,
                    b.stock_code,
                    min(b.transaction_date) AS start_date,
                    max(b.transaction_date) AS end_date,
                    COALESCE(sum(c.div_cost), 0::numeric) AS div_cost
                   FROM dibots_v2.company_stock_named a
                     LEFT JOIN dibots_v2.exchange_daily_transaction b ON a.stock_code::text = b.stock_code::text
                     LEFT JOIN staging.exchange_factor_details c ON a.stock_code::text = c.stock_code::text AND b.transaction_date = c.transaction_date AND c.div IS NOT NULL AND c.price_adj <> 0::numeric AND c.remarks = 'ok'::text
                  WHERE date_part('year'::text, b.transaction_date) = (( SELECT date_part('year'::text, max(exchange_daily_transaction.transaction_date)) AS max_date
                           FROM dibots_v2.exchange_daily_transaction))
                  GROUP BY b.stock_code, a.display_name, a.dbt_entity_id) t1
             JOIN dibots_v2.exchange_daily_transaction tmin ON t1.stock_code::text = tmin.stock_code::text AND t1.start_date = tmin.transaction_date
             JOIN dibots_v2.exchange_daily_transaction tmax ON t1.stock_code::text = tmax.stock_code::text AND t1.end_date = tmax.transaction_date) tytd ON tday.stock_code::text = tytd.stock_code::text;


CREATE UNIQUE INDEX plc_tret_uniq on dibots_v2.plc_total_return (dbt_entity_id);
CREATE INDEX plc_tret_stock_idx on dibots_v2.plc_total_return (stock_code);

--===========================
-- PLC_ANNUAL_FINANCIAL_ITEM
--===========================

-- the following views are dependent on plc_annual_financial_item
-- staging.plc_annual_financial_ratio (view)
-- dibots_v2.growth_and_value_stock_master_view (view)
-- dibots_v2.growth_and_value_stock_medians (materialized view)
-- check views_cascade.sql


REFRESH MATERIALIZED VIEW CONCURRENTLY staging.plc_annual_financial_item;

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

--===========================
-- BURSA_ANNOUNCEMENT_VIEW
--===========================
CREATE OR REPLACE VIEW dibots_v2.bursa_announcement_view
AS SELECT COALESCE(b.ann_id, a.ann_id) AS ann_id,
    b.item_perm_id,
    COALESCE(a.title::character varying, b.item_heading) AS title,
    b.item_language,
    COALESCE(a.date_announced::timestamp with time zone, b.item_publish_time) AS date_announced,
    COALESCE(a.company_name, b.company_name) AS company_name,
    COALESCE(a.stock_code, b.ticker) AS stock_code, -- prioritize our own stock_code because sometime they trimmed leading zeroes
    a.stock_name, -- they don't have stock_name so use company_name
    COALESCE('XKLS'::character varying, b.mic) AS mic,
    COALESCE(a.ann_url::character varying, b.item_url) AS item_url,
    a.content,
    COALESCE(a.crawled_date::timestamp with time zone, b.created_dtime) AS created_dtime,
    COALESCE('kangwei'::character varying(100), b.created_by) AS created_by,
    b.modified_dtime,
    b.modified_by
   FROM dibots_v2.exchange_announcement_master a
     FULL JOIN ( SELECT wvb_news_item.item_perm_id,
            wvb_news_item.wvb_number,
            wvb_news_item.item_heading,
            wvb_news_item.distributor_perm_id,
            wvb_news_item.format_perm_id,
            wvb_news_item.item_language,
            wvb_news_item.type_perm_id,
            wvb_news_item.topic_perm_id,
            wvb_news_item.item_publish_time,
            wvb_news_item.item_gmt_time,
            wvb_news_item.item_received_time,
            wvb_news_item.company_name,
            wvb_news_item.ticker,
            wvb_news_item.mic,
            wvb_news_item.isin,
            wvb_news_item.item_url,
            wvb_news_item.item_signature,
            wvb_news_item.item_status,
            wvb_news_item.item_attached,
            wvb_news_item.item_news_id,
            wvb_news_item.dtime_approved,
            wvb_news_item.dtime_created,
            wvb_news_item.dtime_last_changed,
            wvb_news_item.created_dtime,
            wvb_news_item.created_by,
            wvb_news_item.modified_dtime,
            wvb_news_item.modified_by,
            wvb_news_item.ann_id
           FROM dibots_v2.wvb_news_item
          WHERE wvb_news_item.mic::text = 'XKLS'::text AND wvb_news_item.ann_id IS NOT NULL) b ON a.ann_id = b.ann_id;


--===============================
-- EXCHANGE_STOCK_LATEST_FACTOR
--===============================
-- A view for ease of accessing the stocks latest factor for ex_price calculation

CREATE OR REPLACE VIEW dibots_v2.exchange_stock_latest_factor
AS SELECT a.max_date,
    a.stock_code,
    a.stock_num,
    b.factor,
    b.shares_outstanding,
    b.market_capitalisation
   FROM ( SELECT max(dt.transaction_date) AS max_date,
            dt.stock_code, dt.stock_num
           FROM dibots_v2.exchange_daily_transaction dt
          GROUP BY dt.stock_code, dt.stock_num) a,
    dibots_v2.exchange_daily_transaction b
  WHERE a.stock_num = b.stock_num AND a.max_date = b.transaction_date;



--=============
-- STOCK_VIEW
--=============

CREATE OR REPLACE VIEW dibots_user_pref.stock_view
AS SELECT a.stock_code,
    a.stock_identifier AS dbt_entity_id,
    a.stock_identifier_ex AS external_id,
    a.mic,
    a.short_name AS stock_name,
    a.company_name,
    a.eff_end_date,
    a.delisted_date
   FROM dibots_v2.exchange_stock_profile a;


--=========================
-- STOCK_LIVE_LATEST_VIEW
--=========================

create or replace view dibots_v2.stock_live_latest_view as 
select a.code as stock_code, a.last_done, a.lacp, a.chg, a.pct_chg, a.vol_00, a.buy_vol_00, a.buy, a.sell, a.sell_vol_00, a.high, a.low, a.date from
(
select b.code, max(b.date) as max_date from dibots_v2.bursa_equities_history b
where b.date::date = (select max(date)::date from dibots_v2.bursa_equities_history) group by code
) latest
left join dibots_v2.bursa_equities_history a
on latest.code = a.code and latest.max_date = a.date;


--=================================
-- DEMOGRAPHY_PERIOD_NET_VAL_VIEW
--=================================

--REFRESH MATERIALIZED VIEW CONCURRENTLY dibots_v2.demography_period_net_val_mview; 

--CREATE MATERIALIZED VIEW dibots_v2.demography_period_net_val_mview as
CREATE OR REPLACE VIEW dibots_v2.demography_period_net_val_view as
select b.trading_date, b.stock_code, b.stock_num,
case when b.day < 5 then null else sum(COALESCE(b.net_local_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as local_5,
case when b.day < 10 then null else sum(COALESCE(b.net_local_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as local_10,
case when b.day < 20 then null else sum(COALESCE(b.net_local_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as local_20,
case when b.day < 50 then null else sum(COALESCE(b.net_local_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as local_50,
case when b.day < 100 then null else sum(COALESCE(b.net_local_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as local_100,
case when b.day < 200 then null else sum(COALESCE(b.net_local_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as local_200,
case when b.day < 5 then null else sum(COALESCE(b.net_foreign_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as foreign_5,
case when b.day < 10 then null else sum(COALESCE(b.net_foreign_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as foreign_10,
case when b.day < 20 then null else sum(COALESCE(b.net_foreign_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as foreign_20,
case when b.day < 50 then null else sum(COALESCE(b.net_foreign_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as foreign_50,
case when b.day < 100 then null else sum(COALESCE(b.net_foreign_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as foreign_100,
case when b.day < 200 then null else sum(COALESCE(b.net_foreign_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as foreign_200,
case when b.day < 5 then null else sum(COALESCE(b.net_local_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as local_inst_5,
case when b.day < 10 then null else sum(COALESCE(b.net_local_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as local_inst_10,
case when b.day < 20 then null else sum(COALESCE(b.net_local_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as local_inst_20,
case when b.day < 50 then null else sum(COALESCE(b.net_local_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as local_inst_50,
case when b.day < 100 then null else sum(COALESCE(b.net_local_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as local_inst_100,
case when b.day < 200 then null else sum(COALESCE(b.net_local_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as local_inst_200,
case when b.day < 5 then null else sum(COALESCE(b.net_local_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as local_retail_5,
case when b.day < 10 then null else sum(COALESCE(b.net_local_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as local_retail_10,
case when b.day < 20 then null else sum(COALESCE(b.net_local_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as local_retail_20,
case when b.day < 50 then null else sum(COALESCE(b.net_local_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as local_retail_50,
case when b.day < 100 then null else sum(COALESCE(b.net_local_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as local_retail_100,
case when b.day < 200 then null else sum(COALESCE(b.net_local_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as local_retail_200,
case when b.day < 5 then null else sum(COALESCE(b.net_local_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as local_nom_5,
case when b.day < 10 then null else sum(COALESCE(b.net_local_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as local_nom_10,
case when b.day < 20 then null else sum(COALESCE(b.net_local_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as local_nom_20,
case when b.day < 50 then null else sum(COALESCE(b.net_local_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as local_nom_50,
case when b.day < 100 then null else sum(COALESCE(b.net_local_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as local_nom_100,
case when b.day < 200 then null else sum(COALESCE(b.net_local_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as local_nom_200,
case when b.day < 5 then null else sum(COALESCE(b.net_foreign_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as foreign_inst_5,
case when b.day < 10 then null else sum(COALESCE(b.net_foreign_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as foreign_inst_10,
case when b.day < 20 then null else sum(COALESCE(b.net_foreign_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as foreign_inst_20,
case when b.day < 50 then null else sum(COALESCE(b.net_foreign_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as foreign_inst_50,
case when b.day < 100 then null else sum(COALESCE(b.net_foreign_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as foreign_inst_100,
case when b.day < 200 then null else sum(COALESCE(b.net_foreign_inst_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as foreign_inst_200,
case when b.day < 5 then null else sum(COALESCE(b.net_foreign_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as foreign_retail_5,
case when b.day < 10 then null else sum(COALESCE(b.net_foreign_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as foreign_retail_10,
case when b.day < 20 then null else sum(COALESCE(b.net_foreign_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as foreign_retail_20,
case when b.day < 50 then null else sum(COALESCE(b.net_foreign_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as foreign_retail_50,
case when b.day < 100 then null else sum(COALESCE(b.net_foreign_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as foreign_retail_100,
case when b.day < 200 then null else sum(COALESCE(b.net_foreign_retail_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as foreign_retail_200,
case when b.day < 5 then null else sum(COALESCE(b.net_foreign_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as foreign_nom_5,
case when b.day < 10 then null else sum(COALESCE(b.net_foreign_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as foreign_nom_10,
case when b.day < 20 then null else sum(COALESCE(b.net_foreign_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as foreign_nom_20,
case when b.day < 50 then null else sum(COALESCE(b.net_foreign_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as foreign_nom_50,
case when b.day < 100 then null else sum(COALESCE(b.net_foreign_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as foreign_nom_100,
case when b.day < 200 then null else sum(COALESCE(b.net_foreign_nominees_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as foreign_nom_200,
case when b.day < 5 then null else sum(COALESCE(b.net_ivt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as ivt_5,
case when b.day < 10 then null else sum(COALESCE(b.net_ivt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as ivt_10,
case when b.day < 20 then null else sum(COALESCE(b.net_ivt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as ivt_20,
case when b.day < 50 then null else sum(COALESCE(b.net_ivt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as ivt_50,
case when b.day < 100 then null else sum(COALESCE(b.net_ivt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as ivt_100,
case when b.day < 200 then null else sum(COALESCE(b.net_ivt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as ivt_200,
case when b.day < 5 then null else sum(COALESCE(b.net_pdt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as pdt_5,
case when b.day < 10 then null else sum(COALESCE(b.net_pdt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as pdt_10,
case when b.day < 20 then null else sum(COALESCE(b.net_pdt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as pdt_20,
case when b.day < 50 then null else sum(COALESCE(b.net_pdt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as pdt_50,
case when b.day < 100 then null else sum(COALESCE(b.net_pdt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as pdt_100,
case when b.day < 200 then null else sum(COALESCE(b.net_pdt_val, 0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as pdt_200,
case when b.day < 5 then null else sum(COALESCE(b.net_ivt_val, 0) + COALESCE(b.net_pdt_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as prop_5,
case when b.day < 10 then null else sum(COALESCE(b.net_ivt_val, 0) + COALESCE(b.net_pdt_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as prop_10,
case when b.day < 20 then null else sum(COALESCE(b.net_ivt_val, 0) + COALESCE(b.net_pdt_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as prop_20,
case when b.day < 50 then null else sum(COALESCE(b.net_ivt_val, 0) + COALESCE(b.net_pdt_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as prop_50,
case when b.day < 100 then null else sum(COALESCE(b.net_ivt_val, 0) + COALESCE(b.net_pdt_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as prop_100,
case when b.day < 200 then null else sum(COALESCE(b.net_ivt_val, 0) + COALESCE(b.net_pdt_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as prop_200,
case when b.day < 5 then null else sum(COALESCE(b.net_local_inst_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as local_inst_nom_5,
case when b.day < 10 then null else sum(COALESCE(b.net_local_inst_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as local_inst_nom_10,
case when b.day < 20 then null else sum(COALESCE(b.net_local_inst_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as local_inst_nom_20,
case when b.day < 50 then null else sum(COALESCE(b.net_local_inst_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as local_inst_nom_50,
case when b.day < 100 then null else sum(COALESCE(b.net_local_inst_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as local_inst_nom_100,
case when b.day < 200 then null else sum(COALESCE(b.net_local_inst_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as local_inst_nom_200,
case when b.day < 5 then null else sum(COALESCE(b.net_foreign_inst_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as foreign_inst_nom_5,
case when b.day < 10 then null else sum(COALESCE(b.net_foreign_inst_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as foreign_inst_nom_10,
case when b.day < 20 then null else sum(COALESCE(b.net_foreign_inst_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as foreign_inst_nom_20,
case when b.day < 50 then null else sum(COALESCE(b.net_foreign_inst_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as foreign_inst_nom_50,
case when b.day < 100 then null else sum(COALESCE(b.net_foreign_inst_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as foreign_inst_nom_100,
case when b.day < 200 then null else sum(COALESCE(b.net_foreign_inst_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as foreign_inst_nom_200,
case when b.day < 5 then null else sum(COALESCE(b.net_local_retail_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as local_retail_nom_5,
case when b.day < 10 then null else sum(COALESCE(b.net_local_retail_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as local_retail_nom_10,
case when b.day < 20 then null else sum(COALESCE(b.net_local_retail_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as local_retail_nom_20,
case when b.day < 50 then null else sum(COALESCE(b.net_local_retail_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as local_retail_nom_50,
case when b.day < 100 then null else sum(COALESCE(b.net_local_retail_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as local_retail_nom_100,
case when b.day < 200 then null else sum(COALESCE(b.net_local_retail_val, 0) + COALESCE(b.net_local_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as local_retail_nom_200,
case when b.day < 5 then null else sum(COALESCE(b.net_foreign_retail_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) END as foreign_retail_nom_5,
case when b.day < 10 then null else sum(COALESCE(b.net_foreign_retail_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) END as foreign_retail_nom_10,
case when b.day < 20 then null else sum(COALESCE(b.net_foreign_retail_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) END as foreign_retail_nom_20,
case when b.day < 50 then null else sum(COALESCE(b.net_foreign_retail_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) END as foreign_retail_nom_50,
case when b.day < 100 then null else sum(COALESCE(b.net_foreign_retail_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) END as foreign_retail_nom_100,
case when b.day < 200 then null else sum(COALESCE(b.net_foreign_retail_val, 0) + COALESCE(b.net_foreign_nominees_val,0)) OVER (PARTITION BY b.stock_code ORDER BY b.trading_date asc ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) END as foreign_retail_nom_200
from
(select row_number() over (partition by a.stock_code order by a.trading_date asc) as day, *
from dibots_v2.exchange_demography_stock_week a) b;

--create unique index on dibots_v2.demography_period_net_val_mview (trading_date, stock_code);




--=============================
-- COMPANY_PERSON_ROLE_PLC
--=============================

REFRESH MATERIALIZED VIEW CONCURRENTLY dibots_v2.company_person_role_plc_mview;

CREATE MATERIALIZED VIEW dibots_v2.company_person_role_plc_mview
AS SELECT DISTINCT date_part('year'::text, a.transaction_date)::integer AS year,
    a.stock_code,
    c.stock_identifier,
    a.stock_name_short,
    a.stock_name_long,
    a.board,
    a.sector,
    a.klci_flag,
    a.fbm100_flag,
    a.shariah_flag,
    a.f4gbm_flag,
    a.insolvency_flag,
    d.company_name,
    d.company_external_id,
    d.company_status,
    d.person_name,
    d.person_external_id,
    d.id,
    d.company_id,
    d.person_id,
    d.wvb_company_person_id,
    d.role_type,
    d.eff_from_date,
    d.eff_end_date,
    d.role_desc,
    d.is_board_member,
    d.is_officer,
    d.year_joint_company,
    d.year_appointed_to_board,
        CASE
            WHEN d.year_appointed_to_board::double precision < date_part('year'::text, d.eff_from_date) THEN date_part('year'::text, a.transaction_date) - d.year_appointed_to_board::double precision
            ELSE date_part('year'::text, a.transaction_date) - date_part('year'::text, d.eff_from_date)
        END AS tenure,
    d.member_of_committee_1,
    d.member_of_committee_2,
    d.member_of_committee_3,
    d.note,
    d.wvb_handling_code,
    d.wvb_last_update_dtime,
    d.created_dtime,
    d.created_by,
    d.modified_dtime,
    d.modified_by,
    d.deleted,
    d.description,
    d.role_position,
        CASE
            WHEN d.role_desc ~~ '%ALTERNATE%'::text THEN true
            ELSE false
        END AS alternate_director,
    d.role_ranking,
    e.gender,
    e.year_of_birth,
    (date_part('year'::text, a.transaction_date) - e.year_of_birth::double precision)::integer AS age,
        CASE
            WHEN n.is_pep IS TRUE THEN 'YES'::text
            WHEN l.is_pep IS TRUE THEN 'PROBABLE'::text
            ELSE 'NO'::text
        END AS is_pep,
        CASE
            WHEN o.is_sanctioned IS TRUE THEN 'YES'::text
            WHEN m.is_sanctioned IS TRUE THEN 'PROBABLE'::text
            ELSE 'NO'::text
        END AS is_sanctioned,
    f.identifier_type,
    f.identifier,
    e.biography,
    k.total_salary,
    k.fye_year,
    g.nationality,
        CASE
            WHEN
            CASE
                WHEN d.year_appointed_to_board::double precision < date_part('year'::text, d.eff_from_date) THEN date_part('year'::text, a.transaction_date) - d.year_appointed_to_board::double precision
                ELSE date_part('year'::text, a.transaction_date) - date_part('year'::text, d.eff_from_date)
            END < 4::double precision THEN '< 4'::text
            WHEN
            CASE
                WHEN d.year_appointed_to_board::double precision < date_part('year'::text, d.eff_from_date) THEN date_part('year'::text, a.transaction_date) - d.year_appointed_to_board::double precision
                ELSE date_part('year'::text, a.transaction_date) - date_part('year'::text, d.eff_from_date)
            END >= 4::double precision AND
            CASE
                WHEN d.year_appointed_to_board::double precision < date_part('year'::text, d.eff_from_date) THEN date_part('year'::text, a.transaction_date) - d.year_appointed_to_board::double precision
                ELSE date_part('year'::text, a.transaction_date) - date_part('year'::text, d.eff_from_date)
            END <= 6::double precision THEN '4-6'::text
            WHEN
            CASE
                WHEN d.year_appointed_to_board::double precision < date_part('year'::text, d.eff_from_date) THEN date_part('year'::text, a.transaction_date) - d.year_appointed_to_board::double precision
                ELSE date_part('year'::text, a.transaction_date) - date_part('year'::text, d.eff_from_date)
            END >= 7::double precision AND
            CASE
                WHEN d.year_appointed_to_board::double precision < date_part('year'::text, d.eff_from_date) THEN date_part('year'::text, a.transaction_date) - d.year_appointed_to_board::double precision
                ELSE date_part('year'::text, a.transaction_date) - date_part('year'::text, d.eff_from_date)
            END <= 9::double precision THEN '7-9'::text
            ELSE '>=10'::text
        END AS tenure_group
   FROM dibots_v2.exchange_daily_transaction a
     JOIN ( SELECT max(exchange_daily_transaction.transaction_date) AS transaction_date
           FROM dibots_v2.exchange_daily_transaction where date_part('year'::text, exchange_daily_transaction.transaction_date) > 2016
          GROUP BY (date_part('year'::text, exchange_daily_transaction.transaction_date))) b ON a.transaction_date = b.transaction_date 
     JOIN dibots_v2.exchange_stock_profile c ON a.stock_code::text = c.stock_code::text AND c.is_mother_code IS TRUE
     JOIN dibots_v2.company_person_role_extended d ON c.stock_identifier = d.company_id AND d.role_position::text = 'Board'::text AND (d.eff_end_date > a.transaction_date OR d.eff_end_date IS NULL) AND d.deleted IS FALSE AND a.transaction_date >= d.eff_from_date AND (d.eff_end_date >= a.transaction_date OR d.eff_end_date IS NULL)
     JOIN dibots_v2.person_profile e ON d.person_id = e.dbt_entity_id AND e.active IS TRUE
     LEFT JOIN dibots_v2.entity_identifier f ON d.person_id = f.dbt_entity_id AND (f.identifier_type = 'MK'::text OR f.identifier_type = 'PASSPORT'::text) AND f.deleted IS FALSE
     LEFT JOIN dibots_v2.person_nationality g ON d.person_id = g.dbt_entity_id AND g.is_deleted IS FALSE
     LEFT JOIN ( SELECT person_profile.display_name,
            person_profile.wvb_entity_type,
            person_profile.is_pep
           FROM dibots_v2.person_profile
          WHERE person_profile.is_pep IS TRUE) l ON d.person_name = l.display_name
     LEFT JOIN ( SELECT person_profile.display_name,
            person_profile.wvb_entity_type,
            person_profile.is_sanctioned
           FROM dibots_v2.person_profile
          WHERE person_profile.is_sanctioned IS TRUE) m ON d.person_name = m.display_name
     LEFT JOIN ( SELECT h.person_id,
            h.company_id,
            i.numeric_value AS total_salary,
            date_part('year'::text, j.fiscal_period_end_date) AS fye_year
           FROM dibots_v2.company_person_role_sal_hdr h
             JOIN dibots_v2.company_person_role_sal_val i ON h.person_role_sal_hdr_perm_id = i.person_role_sal_hdr_perm_id AND i.data_item_perm_id = 10140
             JOIN dibots_v2.analyst_hdr j ON h.wvb_co_fin_data_hdr_perm_id = j.wvb_hdr_id AND i.data_item_perm_id = 10140) k ON d.person_id = k.person_id AND d.company_id = k.company_id AND date_part('year'::text, a.transaction_date) = k.fye_year
     LEFT JOIN ( SELECT DISTINCT a_1.source_entity,
            b_1.is_pep
           FROM dibots_v2.entity_link a_1
             JOIN dibots_v2.person_profile b_1 ON a_1.target_entity = b_1.dbt_entity_id AND b_1.is_pep IS TRUE AND a_1.deleted IS FALSE) n ON d.person_id = n.source_entity
     LEFT JOIN ( SELECT DISTINCT a_1.source_entity,
            b_1.is_sanctioned
           FROM dibots_v2.entity_link a_1
             JOIN dibots_v2.person_profile b_1 ON a_1.target_entity = b_1.dbt_entity_id AND b_1.is_sanctioned IS TRUE AND a_1.deleted IS FALSE) o ON d.person_id = o.source_entity


create unique index on dibots_v2.company_person_role_plc_mview (year, wvb_company_person_id, identifier_type, identifier, nationality, total_salary);

--====================
-- mscore_view
--===================

CREATE OR REPLACE VIEW dibots_v2.mscore_view
AS SELECT t1.stock_code,
    t1.company_name,
    t1.fiscal_period_end_date,
    t1.data_item_id,
    t1.board,
    t1.sector,
    t1.dsri,
    t1.gmi,
    t1.aqi,
    t1.sgi,
    t1.depi,
    t1.sgai,
    t1.lvgi,
    t1.tata,
    t1.mscore,
    t1.rank
   FROM ( SELECT a.stock_code,
            a.company_name,
            a.board,
            a.sector,
            b.fiscal_period_end_date,
            c.data_item_id,
            c.numeric_value AS dsri,
            d.numeric_value AS gmi,
            e.numeric_value AS aqi,
            f.numeric_value AS sgi,
            g.numeric_value AS depi,
            h.numeric_value AS sgai,
            i.numeric_value AS lvgi,
            j.numeric_value AS tata,
            k.numeric_value AS mscore,
            rank() OVER (PARTITION BY a.stock_code ORDER BY b.fiscal_period_end_date DESC) AS rank
           FROM dibots_v2.exchange_stock_profile a
             JOIN dibots_v2.analyst_hdr b ON a.stock_identifier = b.dbt_entity_id
             JOIN dibots_v2.wvb_custom_item_value c ON b.wvb_hdr_id = c.wvb_hdr_id AND c.data_item_id = 955001 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text
             JOIN dibots_v2.wvb_custom_item_value d ON b.wvb_hdr_id = d.wvb_hdr_id AND d.data_item_id = 955002 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text
             JOIN dibots_v2.wvb_custom_item_value e ON b.wvb_hdr_id = e.wvb_hdr_id AND e.data_item_id = 955003 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text
             JOIN dibots_v2.wvb_custom_item_value f ON b.wvb_hdr_id = f.wvb_hdr_id AND f.data_item_id = 955004 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text
             JOIN dibots_v2.wvb_custom_item_value g ON b.wvb_hdr_id = g.wvb_hdr_id AND g.data_item_id = 955005 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text
             JOIN dibots_v2.wvb_custom_item_value h ON b.wvb_hdr_id = h.wvb_hdr_id AND h.data_item_id = 955006 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text
             JOIN dibots_v2.wvb_custom_item_value i ON b.wvb_hdr_id = i.wvb_hdr_id AND i.data_item_id = 955007 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text
             JOIN dibots_v2.wvb_custom_item_value j ON b.wvb_hdr_id = j.wvb_hdr_id AND j.data_item_id = 955008 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text
             JOIN dibots_v2.wvb_custom_item_value k ON b.wvb_hdr_id = k.wvb_hdr_id AND k.data_item_id = 955009 AND a.is_mother_code IS TRUE AND a.eff_end_date IS NULL AND a.sector <> 'FINANCIAL SERVICES'::text) t1
WHERE t1.fiscal_period_end_date > '2014-12-31';


--==========================
-- QTRLY_ANALYST_HDR_VIEW
--==========================
-- add a rank by partition into the view to remove the duplicate but since it is a partition query, performance would take a hit
-- hold it off for now, ETL need to clear daily

SELECT b.wvb_hdr_id, b.dbt_entity_id, b.fiscal_period_end_date, b.original_fiscal_period_end_date, b.fiscal_year_end_month, b.report_type, b.year_report_published,
b.periodicity, b.months_in_period, b.weeks_in_period, b.iso_currency_code, b.scaling_factor_exponent, b.data_year, b.asset_model, b.mapped_asset_model, b.liability_model,
b.mapped_liability_model, b.income_model, b.mapped_income_model, b.cashflow_model, b.mapped_cashflow_model, b.quickview_model, b.wvb_handling_code, b.wvb_last_update_dtime,
b.created_dtime, b.created_by, b.modified_dtime, b.modified_by, b.wvb_dtime_approved_for_prod, 990081 AS free_version_quickview, b.report_model, 
rank() over (partition by b.dbt_entity_id, b.fiscal_period_end_date order by b.wvb_hdr_id desc)
FROM dibots_v2.qtrly_analyst_hdr a
JOIN dibots_v2.data_hdr b ON a.wvb_hdr_id = b.wvb_hdr_id
where b.dbt_entity_id = '354d74a9-1568-44bb-9dc6-ffe504f7d481' order by b.fiscal_period_end_date desc