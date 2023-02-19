--==========================================
-- EXCHANGE_INVESTOR_STATS partitioning
--==========================================

create table dibots_v2.exchange_investor_stats (
trading_date date,
participant_code int,
participant_name varchar(255),
external_id int,
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int
) PARTITION BY RANGE(trading_date);

alter table dibots_v2.exchange_investor_stats add constraint exchg_invt_stats_pkey 
PRIMARY KEY (trading_date, participant_code, locality, intraday_account_type, investor_type, age, gender, race);

create index eis_trading_date_idx on dibots_v2.exchange_investor_stats (trading_date);
create index eis_ext_id_idx on dibots_v2.exchange_investor_stats (external_id);
create index eis_locality_idx on dibots_v2.exchange_investor_stats (locality_new);
create index eis_group_type_idx on dibots_v2.exchange_investor_stats (group_type);
create index eis_ptcpt_code_idx on dibots_v2.exchange_investor_stats (participant_code);

create table dibots_v2.exchange_investor_stats_y2018 partition of dibots_v2.exchange_investor_stats
for values from ('2018-01-01') to ('2019-01-01');
create table dibots_v2.exchange_investor_stats_y2019 partition of dibots_v2.exchange_investor_stats
for values from ('2019-01-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stats_y2020 partition of dibots_v2.exchange_investor_stats
for values from ('2020-01-01') to ('2021-01-01');
create table dibots_v2.exchange_investor_stats_y2021 partition of dibots_v2.exchange_investor_stats
for values from ('2021-01-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stats_y2022 partition of dibots_v2.exchange_investor_stats
for values from ('2022-01-01') to ('2023-01-01');
create table dibots_v2.exchange_investor_stats_y2023 partition of dibots_v2.exchange_investor_stats
for values from ('2023-01-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stats_y2024 partition of dibots_v2.exchange_investor_stats
for values from ('2024-01-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stats_y2025 partition of dibots_v2.exchange_investor_stats
for values from ('2025-01-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stats_default partition of dibots_v2.exchange_investor_stats default;

--=================================================
-- EXCHANGE_INVESTOR_STOCK_STATS partitioning
--=================================================
create table dibots_v2.exchange_investor_stock_stats (
trading_date date,
stock_code varchar(20),
stock_name varchar(20),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
f4gbm_flag bool default false,
participant_code int,
external_id int,
participant_name varchar(255),
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int
) PARTITION BY RANGE(trading_date);

alter table dibots_v2.exchange_investor_stock_stats add constraint exchg_invt_stock_stats_pkey primary key 
(trading_date, stock_code, participant_code, locality_new, group_type, age, gender, race);

create index eiss_date_stock_idx on dibots_v2.exchange_investor_stock_stats (trading_date, stock_code);
create index eiss_trading_date_idx on dibots_v2.exchange_investor_stock_stats (trading_date);
create index eiss_stock_code_idx on dibots_v2.exchange_investor_stock_stats (stock_code);
create index eiss_stock_num_idx on dibots_v2.exchange_investor_stock_stats (stock_num);
create index eiss_ext_id_idx on dibots_v2.exchange_investor_stock_stats (external_id);
create index eiss_board_idx on dibots_v2.exchange_investor_stock_stats (board);
create index eiss_sector_idx on dibots_v2.exchange_investor_stock_stats (sector);
create index eiss_locality_idx on dibots_v2.exchange_investor_stock_stats (locality_new);
create index eiss_group_type_idx on dibots_v2.exchange_investor_stock_stats (group_type);


create table dibots_v2.exchange_investor_stock_stats_y2018h01 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2018-01-01') to ('2018-07-01');
create table dibots_v2.exchange_investor_stock_stats_y2018h02 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2018-07-01') to ('2019-01-01');
create table dibots_v2.exchange_investor_stock_stats_y2019h01 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2019-01-01') to ('2019-07-01');
create table dibots_v2.exchange_investor_stock_stats_y2019h02 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2019-07-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stock_stats_y2020h01 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2020-01-01') to ('2020-07-01');
create table dibots_v2.exchange_investor_stock_stats_y2020h02 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2020-07-01') to ('2021-01-01');
create table dibots_v2.exchange_investor_stock_stats_y2021h01 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2021-01-01') to ('2021-07-01');
create table dibots_v2.exchange_investor_stock_stats_y2021h02 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2021-07-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stock_stats_y2022h01 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2022-01-01') to ('2022-07-01');
create table dibots_v2.exchange_investor_stock_stats_y2022h02 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2022-07-01') to ('2023-01-01');
create table dibots_v2.exchange_investor_stock_stats_y2023h01 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2023-01-01') to ('2023-07-01');
create table dibots_v2.exchange_investor_stock_stats_y2023h02 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2023-07-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stock_stats_y2024h01 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2024-01-01') to ('2024-07-01');
create table dibots_v2.exchange_investor_stock_stats_y2024h02 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2024-07-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stock_stats_y2025h01 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2025-01-01') to ('2025-07-01');
create table dibots_v2.exchange_investor_stock_stats_y2025h02 partition of dibots_v2.exchange_investor_stock_stats
for values from ('2025-07-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stock_stats_default partition of dibots_v2.exchange_investor_stock_stats default;


--==========================================
-- EXCHANGE_INVESTOR_STATS_WEEK partitioning
--==========================================

create table dibots_v2.exchange_investor_stats_week (
last_date date,
week_count varchar(10),
participant_code int,
participant_name varchar(255),
external_id int,
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
) PARTITION BY RANGE(last_date);

alter table dibots_v2.exchange_investor_stats_week add constraint exchg_invt_stats_week_pkey 
PRIMARY KEY (last_date, participant_code, locality, intraday_account_type, investor_type, age, gender, race);

create index eisw_last_date_idx on dibots_v2.exchange_investor_stats_week (last_date);
create index eisw_ext_id_idx on dibots_v2.exchange_investor_stats_week (external_id);
create index eisw_locality_idx on dibots_v2.exchange_investor_stats_week (locality_new);
create index eisw_group_type_idx on dibots_v2.exchange_investor_stats_week (group_type);

create table dibots_v2.exchange_investor_stats_week_y2018 partition of dibots_v2.exchange_investor_stats_week
for values from ('2018-01-01') to ('2019-01-01');
create table dibots_v2.exchange_investor_stats_week_y2019 partition of dibots_v2.exchange_investor_stats_week
for values from ('2019-01-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stats_week_y2020 partition of dibots_v2.exchange_investor_stats_week
for values from ('2020-01-01') to ('2021-01-01');
create table dibots_v2.exchange_investor_stats_week_y2021 partition of dibots_v2.exchange_investor_stats_week
for values from ('2021-01-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stats_week_y2022 partition of dibots_v2.exchange_investor_stats_week
for values from ('2022-01-01') to ('2023-01-01');
create table dibots_v2.exchange_investor_stats_week_y2023 partition of dibots_v2.exchange_investor_stats_week
for values from ('2023-01-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stats_week_y2024 partition of dibots_v2.exchange_investor_stats_week
for values from ('2024-01-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stats_week_y2025 partition of dibots_v2.exchange_investor_stats_week
for values from ('2025-01-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stats_week_default partition of dibots_v2.exchange_investor_stats_week default;


--=============================================
-- EXCHANGE_INVESTOR_STATS_MONTH partitioning
--=============================================

create table dibots_v2.exchange_investor_stats_month (
last_date date,
year int,
month int,
participant_code int,
participant_name varchar(255),
external_id int,
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
) PARTITION BY RANGE(last_date);

alter table dibots_v2.exchange_investor_stats_month add constraint exchg_invt_stats_month_pkey 
PRIMARY KEY (last_date, participant_code, locality, intraday_account_type, investor_type, age, gender, race);

create index eism_last_date_idx on dibots_v2.exchange_investor_stats_month (last_date);
create index eism_ext_id_idx on dibots_v2.exchange_investor_stats_month (external_id);
create index eism_locality_idx on dibots_v2.exchange_investor_stats_month (locality_new);
create index eism_group_type_idx on dibots_v2.exchange_investor_stats_month (group_type);

create table dibots_v2.exchange_investor_stats_month_y2018_2019 partition of dibots_v2.exchange_investor_stats_month
for values from ('2018-01-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stats_month_y2020_2021 partition of dibots_v2.exchange_investor_stats_month
for values from ('2020-01-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stats_month_y2022_2023 partition of dibots_v2.exchange_investor_stats_month
for values from ('2022-01-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stats_month_y2024_2026 partition of dibots_v2.exchange_investor_stats_month
for values from ('2024-01-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stats_month_default partition of dibots_v2.exchange_investor_stats_month default;


--==========================================
-- EXCHANGE_INVESTOR_STATS_QTR partitioning
--==========================================

create table dibots_v2.exchange_investor_stats_qtr (
last_date date,
year int,
qtr int,
participant_code int,
participant_name varchar(255),
external_id int,
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
) PARTITION BY RANGE(last_date);

alter table dibots_v2.exchange_investor_stats_qtr add constraint exchg_invt_stats_qtr_pkey 
PRIMARY KEY (last_date, participant_code, locality, intraday_account_type, investor_type, age, gender, race);

create index eisq_last_date_idx on dibots_v2.exchange_investor_stats_qtr (last_date);
create index eisq_ext_id_idx on dibots_v2.exchange_investor_stats_qtr (external_id);
create index eisq_locality_idx on dibots_v2.exchange_investor_stats_qtr (locality_new);
create index eisq_group_type_idx on dibots_v2.exchange_investor_stats_qtr (group_type);

create table dibots_v2.exchange_investor_stats_qtr_y2018_2021 partition of dibots_v2.exchange_investor_stats_qtr
for values from ('2018-01-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stats_qtr_y2021_2024 partition of dibots_v2.exchange_investor_stats_qtr
for values from ('2022-01-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stats_qtr_default partition of dibots_v2.exchange_investor_stats_qtr default;

--==================================================
-- EXCHANGE_INVESTOR_STATS_SEMI_ANNUAL
--==================================================

create table dibots_v2.exchange_investor_stats_semi_annual (
last_date date,
year int,
semi int,
participant_code int,
participant_name varchar(255),
external_id int,
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
);

alter table dibots_v2.exchange_investor_stats_semi_annual add constraint exchg_invt_stats_semi_annual_pkey 
PRIMARY KEY (last_date, participant_code, locality, intraday_account_type, investor_type, age, gender, race);

create index eissa_last_date_idx on dibots_v2.exchange_investor_stats_semi_annual (last_date);
create index eissa_ext_id_idx on dibots_v2.exchange_investor_stats_semi_annual (external_id);
create index eissa_locality_idx on dibots_v2.exchange_investor_stats_semi_annual (locality_new);
create index eissa_group_type_idx on dibots_v2.exchange_investor_stats_semi_annual (group_type);


--==================================================
-- EXCHANGE_INVESTOR_STATS_YEAR
--==================================================

create table dibots_v2.exchange_investor_stats_year (
last_date date,
year int,
participant_code int,
participant_name varchar(255),
external_id int,
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
);

alter table dibots_v2.exchange_investor_stats_year add constraint exchg_invt_stats_year_pkey 
PRIMARY KEY (last_date, participant_code, locality, intraday_account_type, investor_type, age, gender, race);

create index eisy_last_date_idx on dibots_v2.exchange_investor_stats_year (last_date);
create index eisy_ext_id_idx on dibots_v2.exchange_investor_stats_year (external_id);
create index eisy_locality_idx on dibots_v2.exchange_investor_stats_year (locality_new);
create index eisy_group_type_idx on dibots_v2.exchange_investor_stats_year (group_type);


--=================================================
-- EXCHANGE_INVESTOR_STOCK_STATS_WEEK partitioning
--=================================================
create table dibots_v2.exchange_investor_stock_stats_week (
last_date date,
week_count varchar(10),
stock_code varchar(20),
stock_name varchar(20),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
f4gbm_flag bool default false,
participant_code int,
external_id int,
participant_name varchar(255),
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
) PARTITION BY RANGE(last_date);

alter table dibots_v2.exchange_investor_stock_stats_week add constraint exchg_invt_stock_stats_week_pkey primary key 
(last_date, stock_code, participant_code, locality_new, group_type, age, gender, race);

create index eissw_last_date_idx on dibots_v2.exchange_investor_stock_stats_week (last_date);
create index eissw_stock_code_idx on dibots_v2.exchange_investor_stock_stats_week (stock_code);
create index eissw_stock_num_idx on dibots_v2.exchange_investor_stock_stats_week (stock_num);
create index eissw_ext_id_idx on dibots_v2.exchange_investor_stock_stats_week (external_id);
create index eissw_board_idx on dibots_v2.exchange_investor_stock_stats_week (board);
create index eissw_sector_idx on dibots_v2.exchange_investor_stock_stats_week (sector);
create index eissw_locality_idx on dibots_v2.exchange_investor_stock_stats_week (locality_new);
create index eissw_group_type_idx on dibots_v2.exchange_investor_stock_stats_week (group_type);
create index eissw_date_stock_idx on dibots_v2.exchange_investor_stock_stats_week (last_date, stock_code);


create table dibots_v2.exchange_investor_stock_stats_week_y2018h01 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2018-01-01') to ('2018-07-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2018h02 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2018-07-01') to ('2019-01-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2019h01 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2019-01-01') to ('2019-07-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2019h02 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2019-07-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2020h01 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2020-01-01') to ('2020-07-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2020h02 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2020-07-01') to ('2021-01-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2021h01 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2021-01-01') to ('2021-07-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2021h02 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2021-07-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2022h01 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2022-01-01') to ('2022-07-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2022h02 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2022-07-01') to ('2023-01-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2023h01 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2023-01-01') to ('2023-07-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2023h02 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2023-07-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2024h01 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2024-01-01') to ('2024-07-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2024h02 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2024-07-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2025h01 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2025-01-01') to ('2025-07-01');
create table dibots_v2.exchange_investor_stock_stats_week_y2025h02 partition of dibots_v2.exchange_investor_stock_stats_week
for values from ('2025-07-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stock_stats_week_default partition of dibots_v2.exchange_investor_stock_stats_week default;

--=================================================
-- EXCHANGE_INVESTOR_STOCK_STATS_MONTH partitioning
--=================================================
create table dibots_v2.exchange_investor_stock_stats_month (
last_date date,
year int,
month int,
stock_code varchar(20),
stock_name varchar(20),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
f4gbm_flag bool default false,
participant_code int,
external_id int,
participant_name varchar(255),
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
) PARTITION BY RANGE(last_date);

alter table dibots_v2.exchange_investor_stock_stats_month add constraint exchg_invt_stock_stats_month_pkey primary key 
(last_date, stock_code, participant_code, locality_new, group_type, age, gender, race);

create index eissm_ext_id_idx on dibots_v2.exchange_investor_stock_stats_month (external_id);
create index eissm_stock_code_idx on dibots_v2.exchange_investor_stock_stats_month (stock_code);
create index eissm_stock_num_idx on dibots_v2.exchange_investor_stock_stats_month (stock_num);
create index eissm_board_idx on dibots_v2.exchange_investor_stock_stats_month (board);
create index eissm_sector_idx on dibots_v2.exchange_investor_stock_stats_month (sector);
create index eissm_last_date_idx on dibots_v2.exchange_investor_stock_stats_month (last_date);
create index eissm_locality_idx on dibots_v2.exchange_investor_stock_stats_month (locality_new);
create index eissm_group_type_idx on dibots_v2.exchange_investor_stock_stats_month (group_type);
create index eissm_date_stock_idx on dibots_v2.exchange_investor_stock_stats_month(last_date, stock_code);


create table dibots_v2.exchange_investor_stock_stats_month_y2018h01 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2018-01-01') to ('2018-07-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2018h02 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2018-07-01') to ('2019-01-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2019h01 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2019-01-01') to ('2019-07-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2019h02 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2019-07-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2020h01 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2020-01-01') to ('2020-07-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2020h02 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2020-07-01') to ('2021-01-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2021h01 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2021-01-01') to ('2021-07-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2021h02 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2021-07-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2022h01 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2022-01-01') to ('2022-07-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2022h02 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2022-07-01') to ('2023-01-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2023h01 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2023-01-01') to ('2023-07-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2023h02 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2023-07-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2024h01 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2024-01-01') to ('2024-07-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2024h02 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2024-07-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2025h01 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2025-01-01') to ('2025-07-01');
create table dibots_v2.exchange_investor_stock_stats_month_y2025h02 partition of dibots_v2.exchange_investor_stock_stats_month
for values from ('2025-07-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stock_stats_month_default partition of dibots_v2.exchange_investor_stock_stats_month default;


--=================================================
-- EXCHANGE_INVESTOR_STOCK_STATS_QTR partitioning
--=================================================
create table dibots_v2.exchange_investor_stock_stats_qtr (
last_date date,
year int,
qtr int,
stock_code varchar(20),
stock_name varchar(20),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
f4gbm_flag bool default false,
participant_code int,
external_id int,
participant_name varchar(255),
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
) PARTITION BY RANGE(last_date);

alter table dibots_v2.exchange_investor_stock_stats_qtr add constraint exchg_invt_stock_stats_qtr_pkey primary key 
(last_date, stock_code, participant_code, locality_new, group_type, age, gender, race);

create index eissq_ext_id_idx on dibots_v2.exchange_investor_stock_stats_qtr (external_id);
create index eissq_stock_code_idx on dibots_v2.exchange_investor_stock_stats_qtr (stock_code);
create index eissq_stock_num_idx on dibots_v2.exchange_investor_stock_stats_qtr (stock_num);
create index eissq_board_idx on dibots_v2.exchange_investor_stock_stats_qtr (board);
create index eissq_sector_idx on dibots_v2.exchange_investor_stock_stats_qtr (sector);
create index eissq_last_date_idx on dibots_v2.exchange_investor_stock_stats_qtr (last_date);
create index eissq_locality_idx on dibots_v2.exchange_investor_stock_stats_qtr (locality_new);
create index eissq_group_type_idx on dibots_v2.exchange_investor_stock_stats_qtr (group_type);
create index eissq_date_stock_idx on dibots_v2.exchange_investor_stock_stats_qtr (last_date, stock_code);


create table dibots_v2.exchange_investor_stock_stats_qtr_y2018h01 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2018-01-01') to ('2018-07-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2018h02 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2018-07-01') to ('2019-01-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2019h01 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2019-01-01') to ('2019-07-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2019h02 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2019-07-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2020h01 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2020-01-01') to ('2020-07-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2020h02 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2020-07-01') to ('2021-01-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2021h01 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2021-01-01') to ('2021-07-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2021h02 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2021-07-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2022h01 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2022-01-01') to ('2022-07-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2022h02 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2022-07-01') to ('2023-01-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2023h01 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2023-01-01') to ('2023-07-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2023h02 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2023-07-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2024h01 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2024-01-01') to ('2024-07-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2024h02 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2024-07-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2025h01 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2025-01-01') to ('2025-07-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_y2025h02 partition of dibots_v2.exchange_investor_stock_stats_qtr
for values from ('2025-07-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stock_stats_qtr_default partition of dibots_v2.exchange_investor_stock_stats_qtr default;


--========================================================
-- EXCHANGE_INVESTOR_STOCK_STATS_SEMI_ANNUAL partitioning
--========================================================
create table dibots_v2.exchange_investor_stock_stats_semi_annual (
last_date date,
year int,
semi int,
stock_code varchar(20),
stock_name varchar(20),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
f4gbm_flag bool default false,
participant_code int,
external_id int,
participant_name varchar(255),
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
) PARTITION BY RANGE(last_date);

alter table dibots_v2.exchange_investor_stock_stats_semi_annual add constraint exchg_invt_stock_stats_semi_annual_pkey primary key 
(last_date, stock_code, participant_code, locality_new, group_type, age, gender, race);

create index eisssa_ext_id_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (external_id);
create index eisssa_stock_code_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (stock_code);
create index eisssa_stock_num_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (stock_num);
create index eisssa_board_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (board);
create index eisssa_sector_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (sector);
create index eisssa_last_date_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (last_date);
create index eisssa_locality_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (locality_new);
create index eisssa_group_type_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (group_type);
create index eisssa_date_stock_idx on dibots_v2.exchange_investor_stock_stats_semi_annual (last_date, stock_code);


create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2018h01 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2018-01-01') to ('2018-07-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2018h02 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2018-07-01') to ('2019-01-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2019h01 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2019-01-01') to ('2019-07-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2019h02 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2019-07-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2020h01 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2020-01-01') to ('2020-07-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2020h02 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2020-07-01') to ('2021-01-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2021h01 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2021-01-01') to ('2021-07-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2021h02 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2021-07-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2022h01 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2022-01-01') to ('2022-07-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2022h02 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2022-07-01') to ('2023-01-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2023h01 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2023-01-01') to ('2023-07-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2023h02 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2023-07-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2024h01 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2024-01-01') to ('2024-07-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2024h02 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2024-07-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2025h01 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2025-01-01') to ('2025-07-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_y2025h02 partition of dibots_v2.exchange_investor_stock_stats_semi_annual
for values from ('2025-07-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stock_stats_semi_annual_default partition of dibots_v2.exchange_investor_stock_stats_semi_annual default;


--========================================================
-- EXCHANGE_INVESTOR_STOCK_STATS_YEAR partitioning
--========================================================
create table dibots_v2.exchange_investor_stock_stats_year (
last_date date,
year int,
stock_code varchar(20),
stock_name varchar(20),
stock_num int,
board varchar(100),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
f4gbm_flag bool default false,
participant_code int,
external_id int,
participant_name varchar(255),
locality varchar(100),
intraday_account_type varchar(100),
investor_type varchar(100),
locality_new varchar(100) not null,
group_type varchar(100) not null,
age int,
gender varchar(100),
race varchar(100),
total_trades int,
total_investors int,
total_traded_value numeric(25,2),
total_traded_volume bigint,
total_intraday_trades int,
min_traded_value numeric(25,2),
max_traded_value numeric(25,2),
avg_traded_value numeric(25,2),
min_traded_volume bigint,
max_traded_volume bigint,
avg_traded_volume bigint
) PARTITION BY RANGE(last_date);

alter table dibots_v2.exchange_investor_stock_stats_year add constraint exchg_invt_stock_stats_year_pkey primary key 
(last_date, stock_code, participant_code, locality_new, group_type, age, gender, race);

create index eissy_ext_id_idx on dibots_v2.exchange_investor_stock_stats_year (external_id);
create index eissy_stock_code_idx on dibots_v2.exchange_investor_stock_stats_year (stock_code);
create index eissy_stock_num_idx on dibots_v2.exchange_investor_stock_stats_year (stock_num);
create index eissy_board_idx on dibots_v2.exchange_investor_stock_stats_year (board);
create index eissy_sector_idx on dibots_v2.exchange_investor_stock_stats_year (sector);
create index eissy_last_date_idx on dibots_v2.exchange_investor_stock_stats_year (last_date);
create index eissy_locality_idx on dibots_v2.exchange_investor_stock_stats_year (locality_new);
create index eissy_group_type_idx on dibots_v2.exchange_investor_stock_stats_year (group_type);
create index eissy_date_stock_idx on dibots_v2.exchange_investor_stock_stats_year (last_date, stock_code);

create table dibots_v2.exchange_investor_stock_stats_year_y2018h01 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2018-01-01') to ('2018-07-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2018h02 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2018-07-01') to ('2019-01-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2019h01 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2019-01-01') to ('2019-07-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2019h02 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2019-07-01') to ('2020-01-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2020h01 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2020-01-01') to ('2020-07-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2020h02 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2020-07-01') to ('2021-01-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2021h01 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2021-01-01') to ('2021-07-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2021h02 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2021-07-01') to ('2022-01-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2022h01 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2022-01-01') to ('2022-07-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2022h02 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2022-07-01') to ('2023-01-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2023h01 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2023-01-01') to ('2023-07-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2023h02 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2023-07-01') to ('2024-01-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2024h01 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2024-01-01') to ('2024-07-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2024h02 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2024-07-01') to ('2025-01-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2025h01 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2025-01-01') to ('2025-07-01');
create table dibots_v2.exchange_investor_stock_stats_year_y2025h02 partition of dibots_v2.exchange_investor_stock_stats_year
for values from ('2025-07-01') to ('2026-01-01');
create table dibots_v2.exchange_investor_stock_stats_year_default partition of dibots_v2.exchange_investor_stock_stats_year default;