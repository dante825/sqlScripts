--drop table dibots_v2.bursa_strcwarr_profile;
create table dibots_v2.bursa_strcwarr_profile (
ann_id int not null primary key,
instrument_category text,
instrument_type text,
description text,
mother_stock_code varchar(10),
mother_stock_name text,
mother_stock_identifier uuid,
issuer text,
stock_code varchar(10),
stock_name text,
stock_num int,
isin_code text,
board text,
sector text,
listing_date date,
term_sheet_date date,
issue_date date,
issue_price_currency varchar(10),
issue_price numeric(19,3),
issue_size_indicator text,
issue_size_in_unit bigint,
maturity_date date,
name_of_guarantor text,
name_of_trustee text,
payment_rate numeric(19,3),
payment_frequency int,
redemption int,
exercise_period_month numeric(19,2),
revised_exercise_period_month numeric(19,2),
exercise_price_currency varchar(10),
exercise_price numeric(19,5),
exercise_level numeric(19,5),
revised_exercise_price numeric(19,5),
revised_exercise_level numeric(19,5),
exercise_ratio text,
revised_exercise_ratio text,
settlement_type text,
market_maker_contact_details text,
circumstances_no_quote text,
created_by varchar(20),
created_dtime timestamptz,
modified_by varchar(20),
modified_dtime timestamptz
);
create index strcwarr_stock_code_idx on dibots_v2.bursa_strcwarr_profile (stock_code);
create index strcwarr_stock_num_idx on dibots_v2.bursa_strcwarr_profile (stock_num);

select * from dibots_v2.bursa_strcwarr_profile

truncate table dibots_v2.bursa_strcwarr_profile restart identity;

select * from pg_stat_activity where datname = 'dibots';