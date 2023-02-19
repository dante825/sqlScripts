-- The correlation between the cumulative group type net value and the price of the stocks

REFRESH MATERIALIZED VIEW CONCURRENTLY dibots_v2.exchange_demography_group_period_corr;

CREATE MATERIALIZED VIEW dibots_v2.exchange_demography_group_period_corr
AS SELECT tf.trading_date,
    tf.stock_code,
    tf.stock_num,
    tf.local_cum_val,
    tf.foreign_cum_val,
    tf.local_inst_cum_val,
    tf.local_retail_cum_val,
    tf.local_nom_cum_val,
    tf.foreign_inst_cum_val,
    tf.foreign_retail_cum_val,
    tf.foreign_nom_cum_val,
    tf.prop_cum_val,
    tf.ivt_cum_val,
    tf.pdt_cum_val,
    tf.local_inst_nom_cum_val,
    tf.foreign_inst_nom_cum_val,
    tf.local_retail_nom_cum_val,
    tf.foreign_retail_nom_cum_val,
    tf.ex_price,
    COALESCE((tf.tot_local_sum_all - tf.sum_all_val_local * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_local_sq - power(tf.sum_all_val_local, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_local_all,
    COALESCE((tf.tot_local_sum_20 - tf.sum_20_val_local * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_local_sq - power(tf.sum_20_val_local, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_local_20,
    COALESCE((tf.tot_local_sum_50 - tf.sum_50_val_local * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_local_sq - power(tf.sum_50_val_local, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_local_50,
    COALESCE((tf.tot_local_sum_100 - tf.sum_100_val_local * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_local_sq - power(tf.sum_100_val_local, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_local_100,
    COALESCE((tf.tot_local_sum_200 - tf.sum_200_val_local * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_local_sq - power(tf.sum_200_val_local, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_local_200,
    COALESCE((tf.tot_foreign_sum_all - tf.sum_all_val_foreign * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_foreign_sq - power(tf.sum_all_val_foreign, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_foreign_all,
    COALESCE((tf.tot_foreign_sum_20 - tf.sum_20_val_foreign * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_foreign_sq - power(tf.sum_20_val_foreign, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_foreign_20,
    COALESCE((tf.tot_foreign_sum_50 - tf.sum_50_val_foreign * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_foreign_sq - power(tf.sum_50_val_foreign, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_foreign_50,
    COALESCE((tf.tot_foreign_sum_100 - tf.sum_100_val_foreign * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_foreign_sq - power(tf.sum_100_val_foreign, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_foreign_100,
    COALESCE((tf.tot_foreign_sum_200 - tf.sum_200_val_foreign * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_foreign_sq - power(tf.sum_200_val_foreign, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_foreign_200,
    COALESCE((tf.tot_local_inst_sum_all - tf.sum_all_val_local_inst * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_local_inst_sq - power(tf.sum_all_val_local_inst, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_all,
    COALESCE((tf.tot_local_inst_sum_20 - tf.sum_20_val_local_inst * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_local_inst_sq - power(tf.sum_20_val_local_inst, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_20,
    COALESCE((tf.tot_local_inst_sum_50 - tf.sum_50_val_local_inst * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_local_inst_sq - power(tf.sum_50_val_local_inst, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_50,
    COALESCE((tf.tot_local_inst_sum_100 - tf.sum_100_val_local_inst * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_local_inst_sq - power(tf.sum_100_val_local_inst, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_100,
    COALESCE((tf.tot_local_inst_sum_200 - tf.sum_200_val_local_inst * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_local_inst_sq - power(tf.sum_200_val_local_inst, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_200,
    COALESCE((tf.tot_local_retail_sum_all - tf.sum_all_val_local_retail * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_local_retail_sq - power(tf.sum_all_val_local_retail, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_all,
    COALESCE((tf.tot_local_retail_sum_20 - tf.sum_20_val_local_retail * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_local_retail_sq - power(tf.sum_20_val_local_retail, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_20,
    COALESCE((tf.tot_local_retail_sum_50 - tf.sum_50_val_local_retail * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_local_retail_sq - power(tf.sum_50_val_local_retail, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_50,
    COALESCE((tf.tot_local_retail_sum_100 - tf.sum_100_val_local_retail * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_local_retail_sq - power(tf.sum_100_val_local_retail, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_100,
    COALESCE((tf.tot_local_retail_sum_200 - tf.sum_200_val_local_retail * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_local_retail_sq - power(tf.sum_200_val_local_retail, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_200,
    COALESCE((tf.tot_local_nom_sum_all - tf.sum_all_val_local_nom * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_local_nom_sq - power(tf.sum_all_val_local_nom, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_local_nom_all,
    COALESCE((tf.tot_local_nom_sum_20 - tf.sum_20_val_local_nom * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_local_nom_sq - power(tf.sum_20_val_local_nom, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_local_nom_20,
    COALESCE((tf.tot_local_nom_sum_50 - tf.sum_50_val_local_nom * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_local_nom_sq - power(tf.sum_50_val_local_nom, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_local_nom_50,
    COALESCE((tf.tot_local_nom_sum_100 - tf.sum_100_val_local_nom * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_local_nom_sq - power(tf.sum_100_val_local_nom, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_local_nom_100,
    COALESCE((tf.tot_local_nom_sum_200 - tf.sum_200_val_local_nom * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_local_nom_sq - power(tf.sum_200_val_local_nom, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_local_nom_200,
    COALESCE((tf.tot_foreign_inst_sum_all - tf.sum_all_val_foreign_inst * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_foreign_inst_sq - power(tf.sum_all_val_foreign_inst, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_all,
    COALESCE((tf.tot_foreign_inst_sum_20 - tf.sum_20_val_foreign_inst * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_foreign_inst_sq - power(tf.sum_20_val_foreign_inst, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_20,
    COALESCE((tf.tot_foreign_inst_sum_50 - tf.sum_50_val_foreign_inst * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_foreign_inst_sq - power(tf.sum_50_val_foreign_inst, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_50,
    COALESCE((tf.tot_foreign_inst_sum_100 - tf.sum_100_val_foreign_inst * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_foreign_inst_sq - power(tf.sum_100_val_foreign_inst, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_100,
    COALESCE((tf.tot_foreign_inst_sum_200 - tf.sum_200_val_foreign_inst * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_foreign_inst_sq - power(tf.sum_200_val_foreign_inst, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_200,
    COALESCE((tf.tot_foreign_retail_sum_all - tf.sum_all_val_foreign_retail * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_foreign_retail_sq - power(tf.sum_all_val_foreign_retail, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_all,
    COALESCE((tf.tot_foreign_retail_sum_20 - tf.sum_20_val_foreign_retail * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_foreign_retail_sq - power(tf.sum_20_val_foreign_retail, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_20,
    COALESCE((tf.tot_foreign_retail_sum_50 - tf.sum_50_val_foreign_retail * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_foreign_retail_sq - power(tf.sum_50_val_foreign_retail, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_50,
    COALESCE((tf.tot_foreign_retail_sum_100 - tf.sum_100_val_foreign_retail * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_foreign_retail_sq - power(tf.sum_100_val_foreign_retail, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_100,
    COALESCE((tf.tot_foreign_retail_sum_200 - tf.sum_200_val_foreign_retail * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_foreign_retail_sq - power(tf.sum_200_val_foreign_retail, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_200,
    COALESCE((tf.tot_foreign_nom_sum_all - tf.sum_all_val_foreign_nom * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_foreign_nom_sq - power(tf.sum_all_val_foreign_nom, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_foreign_nom_all,
    COALESCE((tf.tot_foreign_nom_sum_20 - tf.sum_20_val_foreign_nom * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_foreign_nom_sq - power(tf.sum_20_val_foreign_nom, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_foreign_nom_20,
    COALESCE((tf.tot_foreign_nom_sum_50 - tf.sum_50_val_foreign_nom * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_foreign_nom_sq - power(tf.sum_50_val_foreign_nom, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_foreign_nom_50,
    COALESCE((tf.tot_foreign_nom_sum_100 - tf.sum_100_val_foreign_nom * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_foreign_nom_sq - power(tf.sum_100_val_foreign_nom, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_foreign_nom_100,
    COALESCE((tf.tot_foreign_nom_sum_200 - tf.sum_200_val_foreign_nom * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_foreign_nom_sq - power(tf.sum_200_val_foreign_nom, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_foreign_nom_200,
    COALESCE((tf.tot_prop_sum_all - tf.sum_all_val_prop * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_prop_sq - power(tf.sum_all_val_prop, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_prop_all,
    COALESCE((tf.tot_prop_sum_20 - tf.sum_20_val_prop * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_prop_sq - power(tf.sum_20_val_prop, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_prop_20,
    COALESCE((tf.tot_prop_sum_50 - tf.sum_50_val_prop * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_prop_sq - power(tf.sum_50_val_prop, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_prop_50,
    COALESCE((tf.tot_prop_sum_100 - tf.sum_100_val_prop * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_prop_sq - power(tf.sum_100_val_prop, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_prop_100,
    COALESCE((tf.tot_prop_sum_200 - tf.sum_200_val_prop * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_prop_sq - power(tf.sum_200_val_prop, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_prop_200,
    COALESCE((tf.tot_ivt_sum_all - tf.sum_all_val_ivt * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_ivt_sq - power(tf.sum_all_val_ivt, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_ivt_all,
    COALESCE((tf.tot_ivt_sum_20 - tf.sum_20_val_ivt * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_ivt_sq - power(tf.sum_20_val_ivt, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_ivt_20,
    COALESCE((tf.tot_ivt_sum_50 - tf.sum_50_val_ivt * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_ivt_sq - power(tf.sum_50_val_ivt, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_ivt_50,
    COALESCE((tf.tot_ivt_sum_100 - tf.sum_100_val_ivt * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_ivt_sq - power(tf.sum_100_val_ivt, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_ivt_100,
    COALESCE((tf.tot_ivt_sum_200 - tf.sum_200_val_ivt * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_ivt_sq - power(tf.sum_200_val_ivt, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_ivt_200,
    COALESCE((tf.tot_pdt_sum_all - tf.sum_all_val_pdt * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_pdt_sq - power(tf.sum_all_val_pdt, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_pdt_all,
    COALESCE((tf.tot_pdt_sum_20 - tf.sum_20_val_pdt * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_pdt_sq - power(tf.sum_20_val_pdt, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_pdt_20,
    COALESCE((tf.tot_pdt_sum_50 - tf.sum_50_val_pdt * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_pdt_sq - power(tf.sum_50_val_pdt, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_pdt_50,
    COALESCE((tf.tot_pdt_sum_100 - tf.sum_100_val_pdt * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_pdt_sq - power(tf.sum_100_val_pdt, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_pdt_100,
    COALESCE((tf.tot_pdt_sum_200 - tf.sum_200_val_pdt * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_pdt_sq - power(tf.sum_200_val_pdt, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_pdt_200,
    COALESCE((tf.tot_local_inst_nom_sum_all - tf.sum_all_val_local_inst_nom * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_local_inst_nom_sq - power(tf.sum_all_val_local_inst_nom, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_nom_all,
    COALESCE((tf.tot_local_inst_nom_sum_20 - tf.sum_20_val_local_inst_nom * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_local_inst_nom_sq - power(tf.sum_20_val_local_inst_nom, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_nom_20,
    COALESCE((tf.tot_local_inst_nom_sum_50 - tf.sum_50_val_local_inst_nom * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_local_inst_nom_sq - power(tf.sum_50_val_local_inst_nom, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_nom_50,
    COALESCE((tf.tot_local_inst_nom_sum_100 - tf.sum_100_val_local_inst_nom * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_local_inst_nom_sq - power(tf.sum_100_val_local_inst_nom, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_nom_100,
    COALESCE((tf.tot_local_inst_nom_sum_200 - tf.sum_200_val_local_inst_nom * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_local_inst_nom_sq - power(tf.sum_200_val_local_inst_nom, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_local_inst_nom_200,
    COALESCE((tf.tot_foreign_inst_nom_sum_all - tf.sum_all_val_foreign_inst_nom * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_foreign_inst_nom_sq - power(tf.sum_all_val_foreign_inst_nom, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_nom_all,
    COALESCE((tf.tot_foreign_inst_nom_sum_20 - tf.sum_20_val_foreign_inst_nom * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_foreign_inst_nom_sq - power(tf.sum_20_val_foreign_inst_nom, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_nom_20,
    COALESCE((tf.tot_foreign_inst_nom_sum_50 - tf.sum_50_val_foreign_inst_nom * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_foreign_inst_nom_sq - power(tf.sum_50_val_foreign_inst_nom, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_nom_50,
    COALESCE((tf.tot_foreign_inst_nom_sum_100 - tf.sum_100_val_foreign_inst_nom * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_foreign_inst_nom_sq - power(tf.sum_100_val_foreign_inst_nom, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_nom_100,
    COALESCE((tf.tot_foreign_inst_nom_sum_200 - tf.sum_200_val_foreign_inst_nom * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_foreign_inst_nom_sq - power(tf.sum_200_val_foreign_inst_nom, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_foreign_inst_nom_200,
    COALESCE((tf.tot_local_retail_nom_sum_all - tf.sum_all_val_local_retail_nom * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_local_retail_nom_sq - power(tf.sum_all_val_local_retail_nom, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_nom_all,
    COALESCE((tf.tot_local_retail_nom_sum_20 - tf.sum_20_val_local_retail_nom * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_local_retail_nom_sq - power(tf.sum_20_val_local_retail_nom, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_nom_20,
    COALESCE((tf.tot_local_retail_nom_sum_50 - tf.sum_50_val_local_retail_nom * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_local_retail_nom_sq - power(tf.sum_50_val_local_retail_nom, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_nom_50,
    COALESCE((tf.tot_local_retail_nom_sum_100 - tf.sum_100_val_local_retail_nom * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_local_retail_nom_sq - power(tf.sum_100_val_local_retail_nom, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_nom_100,
    COALESCE((tf.tot_local_retail_nom_sum_200 - tf.sum_200_val_local_retail_nom * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_local_retail_nom_sq - power(tf.sum_200_val_local_retail_nom, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_local_retail_nom_200,
    COALESCE((tf.tot_foreign_retail_nom_sum_all - tf.sum_all_val_foreign_retail_nom * tf.sum_all_price / tf.day::numeric) / NULLIF(sqrt(abs((tf.sum_all_val_foreign_retail_nom_sq - power(tf.sum_all_val_foreign_retail_nom, 2.0) / tf.day::numeric) * (tf.sum_all_price_sq - power(tf.sum_all_price, 2.0) / tf.day::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_nom_all,
    COALESCE((tf.tot_foreign_retail_nom_sum_20 - tf.sum_20_val_foreign_retail_nom * tf.sum_20_price / 20::numeric) / NULLIF(sqrt(abs((tf.sum_20_val_foreign_retail_nom_sq - power(tf.sum_20_val_foreign_retail_nom, 2.0) / 20::numeric) * (tf.sum_20_price_sq - power(tf.sum_20_price, 2.0) / 20::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_nom_20,
    COALESCE((tf.tot_foreign_retail_nom_sum_50 - tf.sum_50_val_foreign_retail_nom * tf.sum_50_price / 50::numeric) / NULLIF(sqrt(abs((tf.sum_50_val_foreign_retail_nom_sq - power(tf.sum_50_val_foreign_retail_nom, 2.0) / 50::numeric) * (tf.sum_50_price_sq - power(tf.sum_50_price, 2.0) / 50::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_nom_50,
    COALESCE((tf.tot_foreign_retail_nom_sum_100 - tf.sum_100_val_foreign_retail_nom * tf.sum_100_price / 100::numeric) / NULLIF(sqrt(abs((tf.sum_100_val_foreign_retail_nom_sq - power(tf.sum_100_val_foreign_retail_nom, 2.0) / 100::numeric) * (tf.sum_100_price_sq - power(tf.sum_100_price, 2.0) / 100::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_nom_100,
    COALESCE((tf.tot_foreign_retail_nom_sum_200 - tf.sum_200_val_foreign_retail_nom * tf.sum_200_price / 200::numeric) / NULLIF(sqrt(abs((tf.sum_200_val_foreign_retail_nom_sq - power(tf.sum_200_val_foreign_retail_nom, 2.0) / 200::numeric) * (tf.sum_200_price_sq - power(tf.sum_200_price, 2.0) / 200::numeric))), 0::numeric), 0::numeric) AS corr_foreign_retail_nom_200
   FROM ( SELECT cnv.trading_date,
            cnv.stock_code,
            cnv.stock_num,
            cnv.day,
            cnv.local_cum_val,
            cnv.foreign_cum_val,
            cnv.local_inst_cum_val,
            cnv.local_retail_cum_val,
            cnv.local_nom_cum_val,
            cnv.foreign_inst_cum_val,
            cnv.foreign_retail_cum_val,
            cnv.foreign_nom_cum_val,
            cnv.prop_cum_val,
            cnv.ivt_cum_val,
            cnv.pdt_cum_val,
            cnv.local_inst_nom_cum_val,
            cnv.foreign_inst_nom_cum_val,
            cnv.local_retail_nom_cum_val,
            cnv.foreign_retail_nom_cum_val,
            exp.ex_price,
            sum(COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_price,
            sum(COALESCE(exp.ex_price, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_price_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_price,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_price,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_price,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_price,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(exp.ex_price, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_price_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(exp.ex_price, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_price_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(exp.ex_price, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_price_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(exp.ex_price, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_price_sq,
            sum(COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local,
            sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_sq,
            sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_local_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(cnv.local_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_local_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_local_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_local_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_local_sum_200,
            sum(COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign,
            sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_sq,
            sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_foreign_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(cnv.foreign_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_sum_200,
            sum(COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_inst,
            sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_inst_sq,
            sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_local_inst_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_inst,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_inst,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_inst,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_inst,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_inst_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_inst_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_inst_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(cnv.local_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_inst_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_local_inst_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_local_inst_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_local_inst_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_local_inst_sum_200,
            sum(COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_retail,
            sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_retail_sq,
            sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_local_retail_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_retail,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_retail,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_retail,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_retail,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_retail_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_retail_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_retail_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(cnv.local_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_retail_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_local_retail_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_local_retail_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_local_retail_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_local_retail_sum_200,
            sum(COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_nom,
            sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_nom_sq,
            sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_local_nom_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_nom,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_nom,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_nom,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_nom,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_nom_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_nom_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_nom_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(cnv.local_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_nom_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_local_nom_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_local_nom_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_local_nom_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_local_nom_sum_200,
            sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_inst,
            sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_inst_sq,
            sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_foreign_inst_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_inst,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_inst,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_inst,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_inst,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_inst_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_inst_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_inst_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_inst_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_inst_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_inst_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_inst_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_inst_sum_200,
            sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_retail,
            sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_retail_sq,
            sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_foreign_retail_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_retail,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_retail,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_retail,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_retail,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_retail_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_retail_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_retail_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_retail_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_retail_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_retail_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_retail_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_retail_sum_200,
            sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_nom,
            sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_nom_sq,
            sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_foreign_nom_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_nom,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_nom,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_nom,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_nom,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_nom_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_nom_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_nom_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_nom_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_nom_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_nom_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_nom_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_nom_sum_200,
            sum(COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_prop,
            sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_prop_sq,
            sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_prop_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_prop,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_prop,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_prop,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_prop,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_prop_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_prop_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_prop_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(cnv.prop_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_prop_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_prop_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_prop_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_prop_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.prop_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_prop_sum_200,
            sum(COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_ivt,
            sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_ivt_sq,
            sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_ivt_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_ivt,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_ivt,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_ivt,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_ivt,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_ivt_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_ivt_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_ivt_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(cnv.ivt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_ivt_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_ivt_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_ivt_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_ivt_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.ivt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_ivt_sum_200,
            sum(COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_pdt,
            sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_pdt_sq,
            sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_pdt_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_pdt,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_pdt,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_pdt,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_pdt,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_pdt_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_pdt_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_pdt_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(cnv.pdt_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_pdt_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_pdt_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_pdt_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_pdt_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.pdt_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_pdt_sum_200,
            sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_inst_nom,
            sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_inst_nom_sq,
            sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_local_inst_nom_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_inst_nom,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_inst_nom,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_inst_nom,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_inst_nom,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_inst_nom_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_inst_nom_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_inst_nom_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.local_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_inst_nom_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_local_inst_nom_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_local_inst_nom_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_local_inst_nom_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_local_inst_nom_sum_200,
            sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_inst_nom,
            sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_inst_nom_sq,
            sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_foreign_inst_nom_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_inst_nom,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_inst_nom,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_inst_nom,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_inst_nom,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_inst_nom_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_inst_nom_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_inst_nom_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_inst_nom_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_inst_nom_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_inst_nom_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_inst_nom_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_inst_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_inst_nom_sum_200,
            sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_retail_nom,
            sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_local_retail_nom_sq,
            sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_local_retail_nom_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_retail_nom,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_retail_nom,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_retail_nom,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_retail_nom,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_local_retail_nom_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_local_retail_nom_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_local_retail_nom_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.local_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_local_retail_nom_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_local_retail_nom_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_local_retail_nom_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_local_retail_nom_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.local_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_local_retail_nom_sum_200,
            sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_retail_nom,
            sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_all_val_foreign_retail_nom_sq,
            sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS tot_foreign_retail_nom_sum_all,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_retail_nom,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_retail_nom,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_retail_nom,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_retail_nom,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS sum_20_val_foreign_retail_nom_sq,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS sum_50_val_foreign_retail_nom_sq,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS sum_100_val_foreign_retail_nom_sq,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS sum_200_val_foreign_retail_nom_sq,
                CASE
                    WHEN (cnv.day - 20) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_retail_nom_sum_20,
                CASE
                    WHEN (cnv.day - 50) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_retail_nom_sum_50,
                CASE
                    WHEN (cnv.day - 100) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 99 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_retail_nom_sum_100,
                CASE
                    WHEN (cnv.day - 200) < 0 THEN NULL::numeric
                    ELSE sum(COALESCE(cnv.foreign_retail_nom_cum_val, 0::numeric) * COALESCE(exp.ex_price, 0::numeric)) OVER (PARTITION BY cnv.stock_code ORDER BY cnv.trading_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
                END AS tot_foreign_retail_nom_sum_200
           FROM (SELECT edsw.trading_date, edsw.stock_code, edsw.stock_num,
row_number () over (partition by edsw.stock_code order by edsw.trading_date asc) as day,
sum(coalesce(edsw.net_local_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as local_cum_val,
sum(coalesce(edsw.net_foreign_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as foreign_cum_val,
sum(coalesce(edsw.net_local_inst_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as local_inst_cum_val,
sum(coalesce(edsw.net_local_retail_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as local_retail_cum_val,
sum(coalesce(edsw.net_local_nominees_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as local_nom_cum_val,
sum(coalesce(edsw.net_foreign_inst_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as foreign_inst_cum_val,
sum(coalesce(edsw.net_foreign_retail_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as foreign_retail_cum_val,
sum(coalesce(edsw.net_foreign_nominees_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as foreign_nom_cum_val,
sum(coalesce(edsw.net_ivt_val,0) + coalesce(edsw.net_pdt_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as prop_cum_val,
sum(coalesce(edsw.net_ivt_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as ivt_cum_val,
sum(coalesce(edsw.net_pdt_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as pdt_cum_val,
sum(coalesce(edsw.net_local_inst_val,0) + coalesce(edsw.net_local_nominees_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as local_inst_nom_cum_val,
sum(coalesce(edsw.net_foreign_inst_val,0) + coalesce(edsw.net_foreign_nominees_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as foreign_inst_nom_cum_val,
sum(coalesce(edsw.net_local_retail_val,0) + coalesce(edsw.net_local_nominees_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as local_retail_nom_cum_val,
sum(coalesce(edsw.net_foreign_retail_val,0) + coalesce(edsw.net_foreign_nominees_val,0)) OVER (PARTITION BY edsw.stock_code ORDER BY edsw.trading_date) as foreign_retail_nom_cum_val
FROM dibots_v2.exchange_demography_stock_week edsw
ORDER BY edsw.trading_date, edsw.stock_code, edsw.stock_num) cnv
             JOIN ( SELECT a.transaction_date,
                    a.stock_code,
                    a.stock_num,
                    a.adj_closing / b.factor AS ex_price
                   FROM dibots_v2.exchange_daily_transaction a
                     LEFT JOIN dibots_v2.exchange_stock_latest_factor b ON a.stock_num = b.stock_num) exp ON cnv.trading_date = exp.transaction_date AND cnv.stock_num = exp.stock_num) tf;

CREATE UNIQUE INDEX stock_corr_uniq on dibots_v2.exchange_demography_group_period_corr (trading_date, stock_num);
CREATE UNIQUE INDEX stock_corr_uniq2 on dibots_v2.exchange_demography_group_period_corr (trading_date, stock_code);
