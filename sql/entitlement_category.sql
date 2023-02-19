--========================
-- entitlement category
--=======================

-- 1. bonus: bonus, share split
-- 2. dividend: dividend, income distribution
-- 3. rights: right
-- 4. others

-- bonus
select * from dibots_v2.exchange_entitlement where (lower(entitlements) like '%bonus%' or lower(entitlements) like '%share split%') and category is null

update dibots_v2.exchange_entitlement
set
category = 'BONUS',
category_int = 1
where (lower(entitlements) like '%bonus%' or lower(entitlements) like '%share split%') and category is null;

-- dividend
select * from dibots_v2.exchange_entitlement where (lower(entitlements) like '%dividend%' or lower(entitlements) like '%distribution%') and category is null

update dibots_v2.exchange_entitlement
set
category = 'DIVIDEND',
category_int = 2
where (lower(entitlements) like '%dividend%' or lower(entitlements) like '%distribution%') and category is null;

-- rights
select * from dibots_v2.exchange_entitlement where lower(entitlements) like '%rights%'

update dibots_v2.exchange_entitlement
set
category = 'RIGHTS',
category_int = 3
where lower(entitlements) like '%rights%' and category is null;

-- others
update dibots_v2.exchange_entitlement
set
category = 'OTHERS',
category_int = 4
where category is null;

select * from dibots_v2.exchange_entitlement where category is null and lower(entitlements) like '%free warrant%'

select * from dibots_v2.exchange_entitlement where category is null