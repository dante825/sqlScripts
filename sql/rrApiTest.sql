
select * from dibots_v2.research_report_view where file_uploader is null

select stock_identifier, stock_identifier_ex from dibots_v2.exchange_stock_profile where stock_code = '0166'

--=========
-- count
--=========

-- 3
select count(*) from dibots_v2.research_report_view where external_id = 77837 and file_deleted = false and file_uploader in ('kwng_admin', 'jwcheong')

-- 121
select count(*) from dibots_v2.research_report_view where external_id = 77837 and file_deleted = false and file_source = 'WVB'

-- 127 (because the reports could be uploaded by some other uploaders)
select * from dibots_v2.research_report_view where external_id = 77837 and file_deleted = false

select * from dibots_v2.research_report_view where external_id = 77837 and file_deleted = false and (file_source = 'WVB' OR file_uploader in ('kwng_admin', 'jwcheong'))

--==============
-- research avg
--==============

-- 6
select max(estimate_id), file_id from dibots_v2.research_report_view where external_id = 77837 and forecast_release_date between now() - interval '3 months' and now() and file_source = 'WVB'
group by file_id

-- 6
select estimate_id, forecast_release_date, file_id from dibots_v2.research_report_view where external_id = 77837 and forecast_release_date between now() - interval '3 months' and now() and file_source = 'WVB'

-- 1
select * from dibots_v2.research_report_view where estimate_id in (449228,449343,450166,450524,451363,460282)

select * from dibots_v2.ee_earning_estimates_hdr_view where estimate_id in (449228,449343,450166,450524,451363,460282)

select * from dibots_v2.ee_earning_estimates_hdr where estimate_id in (449228,449343,450166,450524,451363,460282)

select * from dibots_v2.research_report_view where file_id in (307383,313261,305761,305722,306383,306801)

select * from dibots_v2.ee_earning_estimates_hdr where file_id = 305761

--==============================
-- Problem FOUND. Due to the creation of the view, the estimate id returned are not consistent. 
-- Same file ID is tied to different estimate ID, thus, a query would gives you different estimate ID at different execution
--===============================
-- The next question is Do all the estimate_id tied to the file_id yield the same TP and recommendation?
-- It seems YES, as proven below.

select * from dibots_v2.ee_data_item_value where estimate_id in (449303,449322,449343,449344) and data_item_perm_id = 29

select * from dibots_v2.ee_data_item_value where estimate_id in (449303,449322,449343,449344) and data_item_perm_id = 28

select * from dibots_v2.ee_earning_estimates_hdr where estimate_id < -1
