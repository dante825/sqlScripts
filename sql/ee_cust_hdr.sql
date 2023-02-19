-- A custom table for ee_earning_estimates_hdr
-- the primary key for this table is the estimate_id and analyst_id

drop table if exists dibots_v2.ee_cust_hdr;
CREATE TABLE dibots_v2.ee_cust_hdr (
	estimate_id int4 NOT NULL,
	provider_id int4 NULL,
	analyst_id int4 NULL,
	company_perm_id int4 NULL,
	dbt_entity_id uuid NULL,
	external_id int4 NULL,
	wvb_number varchar NULL,
	mic varchar NULL,
	ticker varchar NULL,
	value_unit int4 NULL,
	forecast_begin_date date NULL,
	forecast_end_date date NULL,
	forecast_period_code varchar NULL,
	fiscal_year_start_month int4 NULL,
	handling_code int4 NULL,
	file_id int4 NULL,
	forecast_issue_date date NULL,
	forecast_release_date date NULL,
	iso_currency_code varchar NULL,
	is_deleted bool NULL DEFAULT false,
	created_dtime timestamptz NOT NULL,
	created_by varchar NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar NULL,
	file_source text default 'WVB',
	file_uploader text NULL
);
ALTER TABLE dibots_v2.ee_cust_hdr add constraint ee_cust_hdr_pkey primary key (estimate_id, analyst_id);
CREATE INDEX ee_cust_hdr_dbt_entity_id_idx ON dibots_v2.ee_cust_hdr USING btree (dbt_entity_id);
CREATE INDEX ee_cust_hdr_external_id_idx ON dibots_v2.ee_cust_hdr USING btree (external_id);

select * from dibots_v2.ee_cust_hdr;

-- this table is only for the data uploaded by users, don't insert the WVB data into it
insert into dibots_v2.ee_cust_hdr (estimate_id,provider_id,analyst_id,company_perm_id,dbt_entity_id,external_id,wvb_number,mic,ticker,value_unit,forecast_begin_date,forecast_end_date,
forecast_period_code,fiscal_year_start_month,handling_code,file_id,forecast_issue_date,forecast_release_date,iso_currency_code,is_deleted,created_dtime, created_by)
select a.estimate_id,a.provider_id,b.analyst_id,a.company_perm_id,a.dbt_entity_id,a.external_id,a.wvb_number,a.mic,a.ticker,a.value_unit,a.forecast_begin_date,a.forecast_end_date,
a.forecast_period_code,a.fiscal_year_start_month,a.handling_code,a.file_id,a.forecast_issue_date,a.forecast_release_date,a.iso_currency_code,a.is_deleted,a.created_dtime,a.created_by
from dibots_v2.ee_earning_estimates_hdr a, dibots_v2.ee_analyst_estimate_hdr b
where a.estimate_id = b.estimate_id and a.is_deleted = false and b.is_deleted = false;

select * from dibots_v2.ee_cust_hdr where estimate_id = 395522



--=============================================
-- adding file_source and file_uploaded columns
--=============================================
select * from dibots_v2.ee_spreadsheet_files;

alter table dibots_v2.ee_spreadsheet_files add column file_source text default 'WVB', add column file_uploader text;

select * from dibots_v2.ee_earning_estimates_hdr;

alter table dibots_v2.ee_earning_estimates_hdr add column research_type text default 'stock', add column extracted_code int, add column sector text;
