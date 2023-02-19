--=====================
-- IPO stock handling
--=====================

select * from dibots_v2.company_profile where dbt_entity_id = (select dbt_entity_id from dibots_v2.entity_identifier where identifier = '201801016797' and deleted = false limit 1)

-- change the status in company_profile

update dibots_v2.company_profile 
--set 
is_listed = true,
ipo_date = '2022-06-23',
comp_status_desc = 'PUBLIC',
modified_dtime = now(),
modified_by = 'kangwei'
where dbt_entity_id = '987daaea-d65d-4481-94bc-c47059a23a46';

-- insert record into exchange_stock_profile

select * from dibots_v2.exchange_stock_profile --where stock_code = '0248'

insert into dibots_v2.exchange_stock_profile (exchange, stock_code, mic, operating_mic, isin, short_name, company_name, board, sector, subsector, issuer_identifier, issuer_identifier_ex, stock_identifier, stock_identifier_ex, 
listing_date, eff_from_date, created_dtime, created_by, is_mother_code)



--values ('BURSA', '0252', 'MESQ', 'XKLS', 'MYQ0252OO005', 'ORGABIO', 'ORGABIO HOLDINGS BERHAD', 'ACE MARKET', 'CONSUMER PRODUCTS & SERVICES', 'FOOD& BEVERAGES', '18de5ad2-5f59-4876-81f2-9ea44ad10111', 23665988,
'18de5ad2-5f59-4876-81f2-9ea44ad10111', 23665988, '2022-07-05', '2022-07-05', now(), 'kangwei', true);

--values ('BURSA', '03053', 'LEAP', 'XKLS', 'MYL030530005', 'CCIB', 'CC INTERNATIONAL BERHAD', 'LEAP MARKET', 'CONSUMER PRODUCTS & SERVICES', 'CONSUMER SERVICES', '27757b57-20f4-4e00-98d8-57aa8ad01445', 4188376,
'27757b57-20f4-4e00-98d8-57aa8ad01445', 4188376, '2022-06-28', '2022-06-28', now(), 'kangwei', true);

--values ('BURSA', '0250', 'MESQ', 'XKLS', 'MYQ0250OO009', 'YXPM', 'YX PRECIOUS METALS BHD', 'ACE MARKET', 'CONSUMER PRODUCTS & SERVICES', 'PERSONAL GOODS', '987daaea-d65d-4481-94bc-c47059a23a46', 26916162,
'987daaea-d65d-4481-94bc-c47059a23a46', 26916162, '2022-06-23', '2022-06-23', now(), 'kangwei', true);

--values ('BURSA', '03054', 'LEAP', 'XKLS', 'MYL03054O003', 'SNOWFIT', 'SNOWFIT GROUP BERHAD', 'LEAP MARKET', 'CONSUMER PRODUCTS & SERVICES', 'HOUSEHOLD GOODS', 'cbc25f67-9151-4edb-8a61-d11633cf32f7', 26730782, 
'cbc25f67-9151-4edb-8a61-d11633cf32f7', 26730782, '2022-06-21', '2022-06-21', now(), 'kangwei', true)

--values('BURSA', '0251', 'MESQ', 'XKLS', 'MYQ0251OO007', 'SFPTECH', 'SFP TECH HOLDINGS BERHAD', 'ACE MARKET', 'TECHNOLOGY', 'SEMICONDUCTORS', 'a119ab83-ec45-4153-ba78-43fc39a2e6d6',26913135, 
'a119ab83-ec45-4153-ba78-43fc39a2e6d6', 26913135, '2022-06-20', '2022-06-20', now(), 'kangwei', true);

--values('BURSA', '0247', 'MESQ', 'XKLS', 'MYQ0247OO005', 'UNITRAD', 'UNITRADE INDUSTRIES BERHAD', 'ACE MARKET', 'INDUSTRIAL PRODUCTS & SERVICES', 'BUILDING MATERIALS', 'd38b5f12-56b4-4880-8cd9-b4e0e34f25f0', 26897539,
'd38b5f12-56b4-4880-8cd9-b4e0e34f25f0', 26897539, '2022-06-14', '2022-06-14', now(), 'kangwei', true);

--values ('BURSA', '0249', 'MESQ', 'XKLS', 'MYQ0249OO001', 'LGMS', 'LGMS BERHAD', 'ACE MARKET', 'TECHNOLOGY', 'DIGITAL SERVICES', 'e18dbac8-bd4d-4598-9adc-fe07804630c3', 26905200, 'e18dbac8-bd4d-4598-9adc-fe07804630c3', 26905200,
'2022-06-08', '2022-06-08', now(), 'kangwei', true);

--values ('BURSA', '0248', 'MESQ', 'XKLS', 'MYQ0248OO003', 'YEWLEE', 'YEW LEE PACIFIC GROUP BERHAD', 'ACE MARKET', 'INDUSTRIAL PRODUCTS & SERVICES', 'INDUSTRIAL MATERIALS, COMPONENTS & EQUIPMENT', '7a58583c-c4bb-4be0-b980-d2cf4c447271', 26904196,
'7a58583c-c4bb-4be0-b980-d2cf4c447271', 26904196, '2022-06-07', '2022-06-07', now(), 'kangwei', true);

--values ('BURSA', '0246', 'MESQ', 'XKLS', 'MYQ0246OO007', 'CNERGEN', 'CNERGENZ BERHAD', 'ACE MARKET', 'TECHNOLOGY', 'TECHNOLOGY EQUIPMENT', 'd1d24a44-741e-44ae-82e7-5cbbf7a6698a', 26765051, 'd1d24a44-741e-44ae-82e7-5cbbf7a6698a', 26765051,
'2022-05-24', '2022-05-24', now(), 'kangwei', true);

--values ('BURSA', '0245', 'MESQ', 'XKLS', 'MYQ0245OO009', 'MNHLDG', 'MN HOLDINGS BERHAD', 'ACE MARKET', 'CONSTRUCTION', 'CONSTRUCTION', 'fc6e7686-30cc-42f7-aaaf-44109e16d5ce', 26706177, 'fc6e7686-30cc-42f7-aaaf-44109e16d5ce', 26706177,
'2022-04-28', '2022-04-28', now(), 'kangwei', true);

--values ('BURSA', '0243', 'MESQ', 'XKLS', 'MYQ0243OO004', 'CENGILD', 'CENGILD MEDICAL BERHAD', 'ACE MARKET', 'HEALTH CARE', 'HEALTH CARE PROVIDERS', '01cdc0e8-77fe-4b40-8709-4079191804d3', 26699481, '01cdc0e8-77fe-4b40-8709-4079191804d3', 26699481,
'2022-04-18', '2022-04-18', now(), 'kangwei', true);

--values ('BURSA', '0242', 'MESQ', 'XKLS', 'MYQ0242OO006', 'PPJACK', 'PAPPAJACK BERHAD', 'ACE MARKET', 'FINANCIAL SERVICES', 'OTHER FINANCIALS', '415c983c-7a77-4b20-af8e-b21cacf6c1ce', 26633621, '415c983c-7a77-4b20-af8e-b21cacf6c1ce', 26633621,
'2022-04-01', '2022-04-01', now(), 'kangwei', true);

select * from dibots_v2.exchange_stock_profile where stock_code = '0252'

-- insert record into company_stock

select * from dibots_v2.company_stock --where stock_code = '0245'

insert into dibots_v2.company_stock (dbt_entity_id, external_id, stock_code, mic, operating_mic, created_dtime, created_by)


values ('18de5ad2-5f59-4876-81f2-9ea44ad10111', 23665988, '0252', 'MESQ', 'XKLS', now(), 'kangwei');

values ('27757b57-20f4-4e00-98d8-57aa8ad01445', 4188376, '03053', 'LEAP', 'XKLS', now(), 'kangwei');

values ('987daaea-d65d-4481-94bc-c47059a23a46', 26916162, '0250', 'MESQ', 'XKLS', now(), 'kangwei');

values ('cbc25f67-9151-4edb-8a61-d11633cf32f7', 26730782, '03054', 'LEAP', 'XKLS', now(), 'kangwei');

values ('a119ab83-ec45-4153-ba78-43fc39a2e6d6', 26913135, '0251', 'MESQ', 'XKLS', now(), 'kangwei');

values ('d38b5f12-56b4-4880-8cd9-b4e0e34f25f0', 26897539, '0247', 'MESQ', 'XKLS', now(), 'kangwei');

values('e18dbac8-bd4d-4598-9adc-fe07804630c3', 26905200, '0249', 'MESQ', 'XKLS', now(), 'kangwei');

values ('7a58583c-c4bb-4be0-b980-d2cf4c447271', 26904196, '0248', 'MESQ', 'XKLS', now(), 'kangwei');

values ('d1d24a44-741e-44ae-82e7-5cbbf7a6698a', 26765051, '0246', 'MESQ', 'XKLS', now(), 'kangwei');

values ('fc6e7686-30cc-42f7-aaaf-44109e16d5ce', 26706177, '0245', 'MESQ', 'XKLS', now(), 'kangwei');

--values ('01cdc0e8-77fe-4b40-8709-4079191804d3', 26699481, '0243', 'MESQ', 'XKLS', now(), 'kangwei');

--values ('415c983c-7a77-4b20-af8e-b21cacf6c1ce', 26633621, '0242', 'MESQ', 'XKLS', now(), 'kangwei');

select * from dibots_v2.company_stock where stock_code = '0252';

-- reindex the stock_prof index so it is searchable
-- reindex the stock_growth index if it has financial information


--================================
-- Company tied to stock changed
--================================

-- for example, on 2021-10-07, the company tied to stock_code 5258 changed from BIMB Holdings Berhad to Bank Islam Malaysia Berhad

-- 1. flag the old record as delisted
-- 2. insert a new record into exchange_stock_profile
-- 3. update the ipo_date, is_listed flag, comp_status_desc in company_profile
-- 4. update company_stock table
-- 5. updated entity_master table so the data importer would pick up the record
-- 6. reindex stock-prof and stock-growth index

insert into dibots_v2.exchange_stock_profile (exchange, stock_code, mic, operating_mic, isin, short_name, company_name, board, sector, subsector, issuer_identifier, issuer_identifier_ex, stock_identifier, stock_identifier_ex, 
listing_date, eff_from_date, created_dtime, created_by, is_mother_code)
values ('BURSA', '5258', 'XKLS', 'XKLS', 'MYL5258OO008', 'BIMB', 'BANK ISLAM MALAYSIA BERHAD', 'MAIN MARKET', 'FINANCIAL SERVICES', 'BANKING', '6b656115-6170-4022-a81e-be08d3cc12ed', 48999, '6b656115-6170-4022-a81e-be08d3cc12ed', 48999,
'2021-10-08', '2021-10-08', now(), 'kangwei', true);

update dibots_v2.exchange_stock_profile 
set
delisted_date = '2021-05-27',
modified_dtime = now(),
modified_by = 'kangwei'
where id = 1298

update dibots_v2.exchange_stock_profile
set
isin = null,
issuer_identifier = '71ce3e6c-c517-427f-9e12-a967ef228e40',
issuer_identifier_ex = 26692712,
stock_identifier = '71ce3e6c-c517-427f-9e12-a967ef228e40',
stock_identifier_ex = 26692712,
modified_dtime = now(),
modified_by = 'kangwei'
where id = 14992

update dibots_v2.company_stock
set
dbt_entity_id = '1c734e67-13ee-47ad-b4d4-e5db3bee6df6',
external_id = 25879611,
modified_dtime = now(),
modified_by = 'kangwei'
where id = 2793

update dibots_v2.entity_master 
set
modified_dtime = now(),
modified_by = 'kangwei'
where dbt_entity_id in ('1c734e67-13ee-47ad-b4d4-e5db3bee6df6', '017165cc-698e-4091-9069-f3dbcceafb0e')
