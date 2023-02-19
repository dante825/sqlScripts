--===================
-- PLC_DAILY_PE
--===================

-- 1. Run the python script to generate the trailing 12 months PE (staging.plc_trailing_profit_12m)
-- 2. Get the stock_price from daily_transaction and the trailing_pe to generate the running PE

--drop table dibots_v2.plc_daily_pe;
create table dibots_v2.plc_daily_pe (
trading_date date,
dbt_entity_id uuid,
external_id bigint not null,
stock_code varchar(10) not null,
stock_name varchar(20),
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
esg_flag bool default false,
esg_rating int,
market_cap numeric(20,5),
trailing_profit_12m numeric(20,5),
daily_pe numeric(20,10)
);

alter table dibots_v2.plc_daily_pe add constraint plc_daily_pe_pkey primary key (trading_date, dbt_entity_id);

create index plc_daily_pe_ext_id_idx on dibots_v2.plc_daily_pe (external_id);
create index plc_daily_pe_stock_code_idx on dibots_v2.plc_daily_pe (stock_code);
create index plc_daily_pe_board_idx on dibots_v2.plc_daily_pe (board);
create index plc_daily_pe_sector_idx on dibots_v2.plc_daily_pe (sector);

-- ONLY CURRENT DATA
truncate table dibots_v2.plc_daily_pe;
insert into dibots_v2.plc_daily_pe(trading_date, dbt_entity_id, external_id, stock_code, stock_name, board, sector, market_cap, trailing_profit_12m, daily_pe)
select a.transaction_date, b.dbt_entity_id, b.external_id, a.stock_code, a.stock_name_short, a.board, a.sector, 
a.market_capitalisation, b.trailing_profit_12m, a.market_capitalisation/ b.trailing_profit_12m/ 1000 as running_pe from
dibots_v2.exchange_daily_transaction a, staging.plc_trailing_profit_12m b
where a.stock_code = b.stock_code and a.transaction_date = (select max(transaction_date) from dibots_v2.exchange_daily_transaction);

select * from dibots_v2.plc_daily_pe;

-- the security types in this table includes STAPLED SECURITY, LOCAL ORDINARY, REAL ESTATE INVESTMENT TRUSTS
