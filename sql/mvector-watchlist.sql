-- steps to get subscribed stocks in mvector

-- 1. get user_id
select * from retail.retail_user where username = 'chyee'

select * from retail.retail_user where username = 'kwng'

-- 2. get user_feature id
select * from retail.user_feature_access where user_id = '59e8dc40-8354-4e45-9ce6-6a307105a875' --and feature_id = 5

select * from retail.user_feature_access where user_id = 'a810fd73-b2fb-4ca8-8660-c5842adf0493' --and feature_id = 5

select * from retail.feature

-- 3. get the list of subscribed stocks based on the id from step 2
select * from retail.user_feature_company_access where linked_user_feature_access = 21 and expiry_date >= current_date

select * from retail.user_feature_company_access where linked_user_feature_access = 14 and expiry_date >= current_date

select * from retail.feature_cost where id = 2

select * from retail.feature

select * from retail.feature_unsubscribe_history

-- steps to get stocks in watchlist

select * from retail.user_watchlist where user_id = '59e8dc40-8354-4e45-9ce6-6a307105a875' and end_date is null

-- purchase history

select * from retail.user_token_transaction_history where user_id = 'a810fd73-b2fb-4ca8-8660-c5842adf0493'

select transaction_type, token_change, stock_code, target_user, created_dtime from retail.user_token_transaction_history where user_id = 'a810fd73-b2fb-4ca8-8660-c5842adf0493' and token_type = 2

-- record form
select a.transaction_type, a.token_change, a.stock_code, b.short_name, c.username, a.created_dtime from retail.user_token_transaction_history a
left join retail.stock_profile b on a.stock_code = b.stock_code
left join retail.retail_user c on a.target_user = c.user_id
where
a.user_id = 'a810fd73-b2fb-4ca8-8660-c5842adf0493' and a.token_type = 1 and a.created_dtime between '2022-01-06 00:00' and '2022-02-22 23:59'

-- graph form
select transaction_type, sum(token_change), extract(year from created_dtime) as year, extract(month from created_dtime) as month
from retail.user_token_transaction_history where user_id = 'a810fd73-b2fb-4ca8-8660-c5842adf0493' and token_type = 2
group by transaction_type, extract(year from created_dtime), extract(month from created_dtime)
order by extract(year from created_dtime), extract(month from created_dtime)




-- delete user and all the dependency

select * from retail.retail_user

select * from retail.retail_user_identification_image

delete from retail.retail_user_identification_image where user_id = 'debd9940-4b07-4f5e-8c77-b02b7a4b384f';
delete from retail.retail_user_address where user_id = 'debd9940-4b07-4f5e-8c77-b02b7a4b384f';
delete from retail.email_verification_token where user_id = 'debd9940-4b07-4f5e-8c77-b02b7a4b384f';
delete from retail.retail_user where user_id  ='debd9940-4b07-4f5e-8c77-b02b7a4b384f';

