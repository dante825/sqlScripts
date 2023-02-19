-- MUST run at the start of a new month when getting data of the last month

SELECT 
    stock_code, company_name, sector, fiscal_year, fiscal_period_end_date,
    CASE WHEN data_item_id=3037 THEN 'net_profit'
        WHEN data_item_id=3077 THEN 'total_asset'
        WHEN data_item_id=3072 THEN 'goodwill_intangible'
        WHEN data_item_id=5514 THEN 'operating_cash_flow'
        WHEN data_item_id=5523 THEN 'dividend_paid'
        WHEN data_item_id=3000 THEN 'revenue'
        WHEN data_item_id=5024 THEN 'roe'
        WHEN data_item_id=4041 THEN 'shareholder_equity'
    END AS fiscal_item,
    numeric_value AS fiscal_value,
    created_dtime as last_upd_date
FROM 
    bursa_xtrn.fundamental_view_current
UNION
SELECT 
    stock_code, company_name, sector, fiscal_year, fiscal_period_end_date,
    CASE WHEN data_item_id=3037 THEN 'net_profit'
        WHEN data_item_id=3077 THEN 'total_asset'
        WHEN data_item_id=3072 THEN 'goodwill_intangible'
        WHEN data_item_id=5514 THEN 'operating_cash_flow'
        WHEN data_item_id=5523 THEN 'dividend_paid'
        WHEN data_item_id=3000 THEN 'revenue'
        WHEN data_item_id=5024 THEN 'roe'
        WHEN data_item_id=4041 THEN 'shareholder_equity'
    END AS fiscal_item,
    numeric_value AS fiscal_value,
    created_dtime as last_upd_date
FROM 
    bursa_xtrn.fundamental_view_custom_current
ORDER BY stock_code, fiscal_year desc 