-- create the inv_fund_flows table and load the data from CSV

--=====================
-- CONTRA FUND FLOW
--=====================

--drop table if exists dibots_v2.exchange_contra_fund_flow;
create table dibots_v2.exchange_contra_fund_flow (
t0_date date,
tminus1_date date,
tminus2_date date,
tminus3_date date,
tminus4_date date,
stock_code varchar(10),
stock_name varchar(20),
stock_num int,
board varchar(20),
sector varchar(100),
klci_flag bool default false,
fbm100_flag bool default false,
shariah_flag bool default false,
f4gbm_flag bool default false,
participant_code int,
external_id bigint,
participant_name varchar(100),
locality varchar(20),
intraday_acc_type varchar(20),
inv_type varchar(20),
locality_new varchar(20),
group_type varchar(20),
age int,
gender varchar(25),
race varchar(20),
account_identifier bigint,
t0_buy_volume int,
t0_sell_volume int,
t0_net_volume int,
tminus1_buy_volume int,
tminus1_sell_volume int,
tminus1_net_volume int,
tminus2_buy_volume int,
tminus2_sell_volume int,
tminus2_net_volume int,
tminus3_buy_volume int,
tminus3_sell_volume int,
tminus3_net_volume int,
tminus4_buy_volume int,
tminus4_sell_volume int,
tminus4_net_volume int,
t0_buy_value numeric(25,3),
t0_sell_value numeric(25,3),
t0_net_value numeric(25,3),
tminus1_buy_value numeric(25,3),
tminus1_sell_value numeric(25,3),
tminus1_net_value numeric(25,3),
tminus2_buy_value numeric(25,3),
tminus2_sell_value numeric(25,3),
tminus2_net_value numeric(25,3),
tminus3_buy_value numeric(25,3),
tminus3_sell_value numeric(25,3),
tminus3_net_value numeric(25,3),
tminus4_buy_value numeric(25,3),
tminus4_sell_value numeric(25,3),
tminus4_net_value numeric(25,3),
t1_open_volume int,
t2_open_volume int, 
t3_open_volume_raw int,
t3_open_volume int,
t1_open_value numeric(25,3),
t2_open_value numeric(25,3),
t3_open_value_raw numeric(25,3),
t3_open_value numeric(25,3),
t1_open_volume_nexttradingday int,
t2_open_volume_nexttradingday int,
t3_open_volume_nexttradingday int, 
t1_open_value_nexttradingday numeric(25,3),
t2_open_value_nexttradingday numeric(25,3), 
t3_open_value_nexttradingday numeric(25,3)
) partition by range (t0_date);

create index cff_date_idx on dibots_v2.exchange_contra_fund_flow (t0_date);
create index cff_stock_code_idx on dibots_v2.exchange_contra_fund_flow (stock_code);
create index cff_stock_num_idx on dibots_v2.exchange_contra_fund_flow (stock_num);
create index cff_ext_id_idx on dibots_v2.exchange_contra_fund_flow (external_id);
create index cff_pcode_idx on dibots_v2.exchange_contra_fund_flow (participant_code);

alter table dibots_v2.exchange_contra_fund_flow add constraint cff_pkey primary key (t0_date, stock_code, participant_code, locality_new, group_type, age, gender, race, account_identifier);

create table dibots_v2.exchange_contra_fund_flow_y2019q01 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2019-01-01') to ('2019-04-01');
create table dibots_v2.exchange_contra_fund_flow_y2019q02 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2019-04-01') to ('2019-07-01');
create table dibots_v2.exchange_contra_fund_flow_y2019q03 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2019-07-01') to ('2019-10-01');
create table dibots_v2.exchange_contra_fund_flow_y2019q04 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2019-10-01') to ('2020-01-01');
create table dibots_v2.exchange_contra_fund_flow_y2020q01 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2020-01-01') to ('2020-04-01');
create table dibots_v2.exchange_contra_fund_flow_y2020q02 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2020-04-01') to ('2020-07-01');
create table dibots_v2.exchange_contra_fund_flow_y2020q03 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2020-07-01') to ('2020-10-01');
create table dibots_v2.exchange_contra_fund_flow_y2020q04 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2020-10-01') to ('2021-01-01');
create table dibots_v2.exchange_contra_fund_flow_y2021q01 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2021-01-01') to ('2021-04-01');
create table dibots_v2.exchange_contra_fund_flow_y2021q02 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2021-04-01') to ('2021-07-01');
create table dibots_v2.exchange_contra_fund_flow_y2021q03 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2021-07-01') to ('2021-10-01');
create table dibots_v2.exchange_contra_fund_flow_y2021q04 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2021-10-01') to ('2022-01-01');
create table dibots_v2.exchange_contra_fund_flow_y2022q01 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2022-01-01') to ('2022-04-01');
create table dibots_v2.exchange_contra_fund_flow_y2022q02 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2022-04-01') to ('2022-07-01');
create table dibots_v2.exchange_contra_fund_flow_y2022q03 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2022-07-01') to ('2022-10-01');
create table dibots_v2.exchange_contra_fund_flow_y2022q04 partition of dibots_v2.exchange_contra_fund_flow
for values from ('2022-10-01') to ('2023-01-01');
create table dibots_v2.exchange_contra_fund_flow_default partition of dibots_v2.exchange_contra_fund_flow default;


-- reloading the table from a tmp table
insert into dibots_v2.exchange_contra_fund_flow (t0_date,tminus1_date,tminus2_date,tminus3_date,tminus4_date,stock_code,stock_name,
board,sector,klci_flag,fbm100_flag,shariah_flag,participant_code,external_id,participant_name,locality,intraday_acc_type,inv_type,locality_new,group_type,
age,gender,race,account_identifier,t0_buy_volume,t0_sell_volume,t0_net_volume,tminus1_buy_volume,tminus1_sell_volume,tminus1_net_volume,
tminus2_buy_volume,tminus2_sell_volume,tminus2_net_volume,tminus3_buy_volume,tminus3_sell_volume,tminus3_net_volume,tminus4_buy_volume,
tminus4_sell_volume,tminus4_net_volume,t0_buy_value,t0_sell_value,t0_net_value,tminus1_buy_value,tminus1_sell_value,tminus1_net_value,
tminus2_buy_value,tminus2_sell_value,tminus2_net_value,tminus3_buy_value,tminus3_sell_value,tminus3_net_value,tminus4_buy_value,
tminus4_sell_value,tminus4_net_value,t1_open_volume,t2_open_volume,t3_open_volume_raw,t3_open_volume,t1_open_value,t2_open_value,
t3_open_value_raw,t3_open_value,t1_open_volume_nexttradingday,t2_open_volume_nexttradingday,t3_open_volume_nexttradingday,t1_open_value_nexttradingday,
t2_open_value_nexttradingday,t3_open_value_nexttradingday)
select t0_date,tminus1_date,tminus2_date,tminus3_date,tminus4_date,stock_code,stock_name,
board,sector,klci_flag,fbm100_flag,shariah_flag,participant_code,external_id,participant_name,locality,intraday_acc_type,inv_type,locality_new,group_type,
age,gender,race,account_identifier,t0_buy_volume,t0_sell_volume,t0_net_volume,tminus1_buy_volume,tminus1_sell_volume,tminus1_net_volume,
tminus2_buy_volume,tminus2_sell_volume,tminus2_net_volume,tminus3_buy_volume,tminus3_sell_volume,tminus3_net_volume,tminus4_buy_volume,
tminus4_sell_volume,tminus4_net_volume,t0_buy_value,t0_sell_value,t0_net_value,tminus1_buy_value,tminus1_sell_value,tminus1_net_value,
tminus2_buy_value,tminus2_sell_value,tminus2_net_value,tminus3_buy_value,tminus3_sell_value,tminus3_net_value,tminus4_buy_value,
tminus4_sell_value,tminus4_net_value,t1_open_volume,t2_open_volume,t3_open_volume_raw,t3_open_volume,t1_open_value,t2_open_value,
t3_open_value_raw,t3_open_value,t1_open_volume_nexttradingday,t2_open_volume_nexttradingday,t3_open_volume_nexttradingday,t1_open_value_nexttradingday,
t2_open_value_nexttradingday,t3_open_value_nexttradingday
from staging.exchange_contra_fund_flow_verify;

select * from dibots_v2.exchange_contra_fund_flow;

select distinct t0_date, stock_code from dibots_v2.exchange_contra_fund_flow order by t0_date, stock_code

update dibots_v2.exchange_contra_fund_flow a 
set
external_id = b.external_id,
participant_name = b.participant_name
from dibots_v2.broker_profile b
where a.participant_code = b.participant_code and a.external_id is null;

update dibots_v2.exchange_contra_fund_flow a 
set
locality_new = 'PROPRIETARY'
where btrim(intraday_acc_type) in ('IVT', 'PDT') and locality_new is null;

update dibots_v2.exchange_contra_fund_flow a 
set
locality_new = 'LOCAL'
where btrim(locality) = 'LOCAL' and locality_new is null;

update dibots_v2.exchange_contra_fund_flow a 
set
locality_new = 'FOREIGN'
where btrim(locality) = 'FOREIGN' and locality_new is null;

update dibots_v2.exchange_contra_fund_flow 
set
group_type = btrim(inv_type)
where btrim(intraday_acc_type) = 'OTHERS' and group_type is null;

update dibots_v2.exchange_contra_fund_flow 
set
group_type = btrim(intraday_acc_type)
where group_type is null;

update dibots_v2.exchange_contra_fund_flow 
set
stock_code = btrim(stock_code);

update dibots_v2.exchange_contra_fund_flow a
set
stock_name = b.stock_name_short,
board = b.board,
sector = b.sector,
klci_flag = b.klci_flag,
fbm100_flag = b.fbm100_flag,
shariah_flag = b.shariah_flag
from dibots_v2.exchange_daily_transaction b
where a.stock_code = b.stock_code and a.t0_date = b.transaction_date and a.stock_name is null;


-- update t2_open_value, t3_open_value_raw
update dibots_v2.exchange_contra_fund_flow a
set
t2_open_volume = CASE
                    WHEN tminus2_net_volume < 0 THEN 0
                    WHEN tminus2_net_volume > 0 AND
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END > tminus2_net_volume AND
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END > 0 THEN tminus2_net_volume
                    WHEN tminus2_net_volume > 0 AND
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END > tminus2_net_volume AND
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END <= 0 THEN 0
                    WHEN tminus2_net_volume > 0 AND
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END <= tminus2_net_volume AND
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END > 0 THEN
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END
                    WHEN tminus2_net_volume > 0 AND
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END <= tminus2_net_volume AND
                    CASE
                        WHEN tminus3_net_volume > 0 THEN tminus1_net_volume + tminus2_net_volume + tminus3_net_volume
                        ELSE tminus1_net_volume + tminus2_net_volume
                    END <= 0 THEN 0
                    ELSE 0
                END,
t3_open_volume_raw = CASE
                    WHEN tminus3_net_volume > 0 AND (tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END) > tminus3_net_volume AND (tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END) > 0 THEN tminus3_net_volume +
                    CASE
                        WHEN tminus1_net_volume < 0 THEN tminus1_net_volume
                        ELSE 0
                    END
                    WHEN tminus3_net_volume > 0 AND (tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END) > tminus3_net_volume AND (tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END) <= 0 THEN 0 +
                    CASE
                        WHEN tminus1_net_volume < 0 THEN tminus1_net_volume
                        ELSE 0
                    END
                    WHEN tminus3_net_volume > 0 AND (tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END) <= tminus3_net_volume AND (tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END) > 0 THEN tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END +
                    CASE
                        WHEN tminus1_net_volume < 0 THEN tminus1_net_volume
                        ELSE 0
                    END
                    WHEN tminus3_net_volume > 0 AND (tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END) <= tminus3_net_volume AND (tminus2_net_volume + tminus3_net_volume +
                    CASE
                        WHEN tminus4_net_volume > 0 THEN tminus4_net_volume
                        ELSE 0
                    END) <= 0 THEN 0 +
                    CASE
                        WHEN tminus1_net_volume < 0 THEN tminus1_net_volume
                        ELSE 0
                    END
                    WHEN tminus3_net_volume <= 0 THEN 0 +
                    CASE
                        WHEN tminus1_net_volume < 0 THEN tminus1_net_volume
                        ELSE 0
                    END
                    ELSE 0 +
                    CASE
                        WHEN tminus1_net_volume < 0 THEN tminus1_net_volume
                        ELSE 0
                    END
                END,
t2_open_value = CASE
                    WHEN tminus2_net_value < 0::numeric THEN 0::numeric
                    WHEN tminus2_net_value > 0::numeric AND
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END > tminus2_net_value AND
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END > 0::numeric THEN tminus2_net_value
                    WHEN tminus2_net_value > 0::numeric AND
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END > tminus2_net_value AND
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END <= 0::numeric THEN 0::numeric
                    WHEN tminus2_net_value > 0::numeric AND
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END <= tminus2_net_value AND
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END > 0::numeric THEN
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END
                    WHEN tminus2_net_value > 0::numeric AND
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END <= tminus2_net_value AND
                    CASE
                        WHEN tminus3_net_value > 0::numeric THEN tminus1_net_value + tminus2_net_value + tminus3_net_value
                        ELSE tminus1_net_value + tminus2_net_value
                    END <= 0::numeric THEN 0::numeric
                    ELSE 0::numeric
                END,
t3_open_value_raw = CASE
                    WHEN tminus3_net_value > 0::numeric AND (tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END) > tminus3_net_value AND (tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END) > 0::numeric THEN tminus3_net_value +
                    CASE
                        WHEN tminus1_net_value < 0::numeric THEN tminus1_net_value
                        ELSE 0::numeric
                    END
                    WHEN tminus3_net_value > 0::numeric AND (tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END) > tminus3_net_value AND (tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END) <= 0::numeric THEN 0::numeric +
                    CASE
                        WHEN tminus1_net_value < 0::numeric THEN tminus1_net_value
                        ELSE 0::numeric
                    END
                    WHEN tminus3_net_value > 0::numeric AND (tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END) <= tminus3_net_value AND (tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END) > 0::numeric THEN tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END +
                    CASE
                        WHEN tminus1_net_value < 0::numeric THEN tminus1_net_value
                        ELSE 0::numeric
                    END
                    WHEN tminus3_net_value > 0::numeric AND (tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END) <= tminus3_net_value AND (tminus2_net_value + tminus3_net_value +
                    CASE
                        WHEN tminus4_net_value > 0::numeric THEN tminus4_net_value
                        ELSE 0::numeric
                    END) <= 0::numeric THEN 0::numeric +
                    CASE
                        WHEN tminus1_net_value < 0::numeric THEN tminus1_net_value
                        ELSE 0::numeric
                    END
                    WHEN tminus3_net_value <= 0::numeric THEN 0::numeric +
                    CASE
                        WHEN tminus1_net_value < 0::numeric THEN tminus1_net_value
                        ELSE 0::numeric
                    END
                    ELSE 0::numeric +
                    CASE
                        WHEN tminus1_net_value < 0::numeric THEN tminus1_net_value
                        ELSE 0::numeric
                    END
                END
where a.t2_open_volume is null;

-- update t1_open_value_nextradingday, t3_open_value

update dibots_v2.exchange_contra_fund_flow a
set
t1_open_volume_nexttradingday = CASE WHEN a.t0_net_volume > 0 THEN a.t0_net_volume ELSE 0 END,
t2_open_volume_nexttradingday = CASE
            WHEN (a.t2_open_volume + a.t0_net_volume) < 0 AND (
            CASE
                WHEN a.t2_open_volume >= 0 AND a.tminus1_net_volume > 0 THEN a.tminus1_net_volume
                ELSE 0
            END + a.t2_open_volume + a.t0_net_volume) >= 0 THEN
            CASE
                WHEN a.t2_open_volume >= 0 AND a.tminus1_net_volume > 0 THEN a.tminus1_net_volume
                ELSE 0
            END + a.t2_open_volume + a.t0_net_volume
            WHEN (a.t2_open_volume + a.t0_net_volume) < 0 AND (
            CASE
                WHEN a.t2_open_volume >= 0 AND a.tminus1_net_volume > 0 THEN a.tminus1_net_volume
                ELSE 0
            END + a.t2_open_volume + a.t0_net_volume) < 0 THEN 0
            WHEN (a.t2_open_volume + a.t0_net_volume) >= 0 AND
            CASE
                WHEN a.t2_open_volume >= 0 AND a.tminus1_net_volume > 0 THEN a.tminus1_net_volume
                ELSE 0
            END >= 0 THEN
            CASE
                WHEN a.t2_open_volume >= 0 AND a.tminus1_net_volume > 0 THEN a.tminus1_net_volume
                ELSE 0
            END
            WHEN (a.t2_open_volume + a.t0_net_volume) >= 0 AND
            CASE
                WHEN a.t2_open_volume >= 0 AND a.tminus1_net_volume > 0 THEN a.tminus1_net_volume
                ELSE 0
            END < 0 THEN 0
            ELSE NULL::integer
        END,
t3_open_volume_nexttradingday = CASE
            WHEN a.t2_open_volume > 0 AND a.t0_net_volume < 0 AND (a.t2_open_volume + a.t0_net_volume) < 0 THEN 0
            WHEN a.t2_open_volume > 0 AND a.t0_net_volume < 0 AND (a.t2_open_volume + a.t0_net_volume) >= 0 THEN a.t2_open_volume + a.t0_net_volume
            WHEN a.t2_open_volume < 0 THEN 0
            ELSE a.t2_open_volume
        END,
t1_open_volume = CASE
            WHEN a.t2_open_volume >= 0 AND a.tminus1_net_volume > 0 THEN a.tminus1_net_volume
            ELSE 0
        END,
t3_open_volume = CASE
            WHEN a.t3_open_volume_raw < 0 THEN 0
            ELSE a.t3_open_volume_raw
        END,
t1_open_value_nexttradingday = CASE
            WHEN a.t0_net_value > 0::numeric THEN a.t0_net_value
            ELSE 0::numeric
        END,
t2_open_value_nexttradingday = CASE
            WHEN (a.t2_open_value + a.t0_net_value) < 0::numeric AND (
            CASE
                WHEN a.t2_open_value >= 0::numeric AND a.tminus1_net_value > 0::numeric THEN a.tminus1_net_value
                ELSE 0::numeric
            END + a.t2_open_value + a.t0_net_value) >= 0::numeric THEN
            CASE
                WHEN a.t2_open_value >= 0::numeric AND a.tminus1_net_value > 0::numeric THEN a.tminus1_net_value
                ELSE 0::numeric
            END + a.t2_open_value + a.t0_net_value
            WHEN (a.t2_open_value + a.t0_net_value) < 0::numeric AND (
            CASE
                WHEN a.t2_open_value >= 0::numeric AND a.tminus1_net_value > 0::numeric THEN a.tminus1_net_value
                ELSE 0::numeric
            END + a.t2_open_value + a.t0_net_value) < 0::numeric THEN 0::numeric
            WHEN (a.t2_open_value + a.t0_net_value) >= 0::numeric AND
            CASE
                WHEN a.t2_open_value >= 0::numeric AND a.tminus1_net_value > 0::numeric THEN a.tminus1_net_value
                ELSE 0::numeric
            END >= 0::numeric THEN
            CASE
                WHEN a.t2_open_value >= 0::numeric AND a.tminus1_net_value > 0::numeric THEN a.tminus1_net_value
                ELSE 0::numeric
            END
            WHEN (a.t2_open_value + a.t0_net_value) >= 0::numeric AND
            CASE
                WHEN a.t2_open_value >= 0::numeric AND a.tminus1_net_value > 0::numeric THEN a.tminus1_net_value
                ELSE 0::numeric
            END < 0::numeric THEN 0::numeric
            ELSE NULL::numeric
        END,
t3_open_value_nexttradingday = CASE
            WHEN a.t2_open_value > 0::numeric AND a.t0_net_value < 0::numeric AND (a.t2_open_value + a.t0_net_value) < 0::numeric THEN 0::numeric
            WHEN a.t2_open_value > 0::numeric AND a.t0_net_value < 0::numeric AND (a.t2_open_value + a.t0_net_value) >= 0::numeric THEN a.t2_open_value + a.t0_net_value
            WHEN a.t2_open_value < 0::numeric THEN 0::numeric
            ELSE a.t2_open_value
        END,
t1_open_value = CASE
            WHEN a.t2_open_value >= 0::numeric AND a.tminus1_net_value > 0::numeric THEN a.tminus1_net_value
            ELSE 0::numeric
        END,
t3_open_value = CASE
            WHEN a.t3_open_value_raw < 0::numeric THEN 0::numeric
            ELSE a.t3_open_value_raw
        END
where a.t1_open_volume_nexttradingday is null;

vacuum (analyze) dibots_v2.exchange_contra_fund_flow;


