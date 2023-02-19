--==========================
-- ENTITLEMENTS with details
--==========================

drop table if exists staging.entitlements;
create table staging.entitlements (
id int generated always as identity,
reference_no varchar(25),
company_name varchar(100),
stock_name varchar(10),
stock_code varchar(8),
ent_subject varchar(50),
ex_date date,
ent_indicator varchar(20),
securities_company_name varchar(100),
entitlement varchar(100),
ratio_new numeric(10,2),
ratio_existing numeric(10,2),
ent_currency varchar(100),
ent_amount numeric(25,5),
rights_issue_offer_price varchar(100),
rights_issue_offer_price_amt numeric(25,5)
);

select * from staging.entitlements;




