select * from dibots_user.user_detail where lower(username) like 'demo_g3%'

select * from dibots_user.user_detail where id = '3d7934b0-e3e2-4394-89b2-5696a9b3845e'

select uuid_generate_v4()

insert into dibots_user.user_detail (id, username, hashed_password, email, created_dtime, created_by, active, tc_signed, email_verified, expiry_date, is_subscriber, in_watchlist)
values (uuid_generate_v4(), 'demo_g3002', '$2a$11$vJXvxQ.twa46a2AsjRMqVO.6PTyUgQ1ImsBGSzErLduwAJuG.zGx2', 'demo_g3002@dibots-internal.com', now(), 'kangwei', true, false, false, '2022-03-01', false, false);

-- the new user
select * from dibots_user.user_detail where username = 'demo_g3002'

-- copy the role of this user
select * from dibots_user.user_role where user_id = '3d7934b0-e3e2-4394-89b2-5696a9b3845e'

select * from dibots_user.user_role where user_id = 'c1044174-afb7-4ab0-b3f1-c4c76de904c8'


insert into dibots_user.user_role (user_id, role_id, created_dtime, created_by, has_ext)
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'FUNDA', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'VALUE_STOCK', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'B_FOREIGN', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'B_RETAIL', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'B_STOCK', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'B_MARKETSTATS', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'B_DASHBRD', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'B_MARKP', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'PORTFOLIO', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'G_MARKP', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'G_CONN', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'ROD_UPLOAD', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'ROD_VIEW', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'MARKP', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'REP_REPO_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'NEWS_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'REP_REPO_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'AFFIL_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'SUBSI_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'SHAREH_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'PEOP_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'FOREIGN_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'RETAIL_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'DEAL_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'SHAREBB_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'INSIDER_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'FUNDA_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'MOMENTUM_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'FUNDFLOW_LIMITED', now(), 'kangwei', true);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'CONN', now(), 'kangwei', false);
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'IR', now(), 'kangwei', false);

-- copy the role extension of this user
select * from dibots_user.user_role_extension where user_id = 'c1044174-afb7-4ab0-b3f1-c4c76de904c8'

select 'fc27423d-82db-444e-b76d-43c772c92045', role_id, now(), 'kangwei', has_ext from dibots_user.user_role where user_id = 'fbad2e8d-ecf0-4782-8c0f-2fe0eb90fd2e'

select * from dibots_user.user_role_extension where user_id = 'c1044174-afb7-4ab0-b3f1-c4c76de904c8'

select * from dibots_v2.company_profile where dbt_entity_id = '7e1396f0-ed97-493c-98ee-2d7931f84879'

insert into dibots_user.user_role_extension (user_id, role_id, company_id, external_id, created_dtime, created_by)
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'ROD_UPLOAD', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'ROD_VIEW', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'MARKP_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'IR', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'SUBSI_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'SHAREH_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'SHAREBB_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'RETAIL_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'REP_REPO_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'PEOP_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'NEWS_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'INSIDER_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'FOREIGN_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'DEAL_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'AFFIL_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'FUNDA_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'MOMENTUM_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')
--values ('c1044174-afb7-4ab0-b3f1-c4c76de904c8', 'FUNDFLOW_LIMITED', '7e1396f0-ed97-493c-98ee-2d7931f84879', 31816, now(), 'kangwei')



select 'fc27423d-82db-444e-b76d-43c772c92045', role_id, 'db7cdd8b-0ef2-48d0-a010-736f396c039c', '31756', now(), 'kangwei' from dibots_user.user_role_extension 
where user_id = 'fbad2e8d-ecf0-4782-8c0f-2fe0eb90fd2e' and company_id = '153c4417-4d68-4536-9c8f-f4dbda186b50'

select * from dibots_v2.exchange_stock_profile where stock_code = '0022'

insert into dibots_user_pref.user_company_link (user_id, user_role, company_id, company_ext_id, created_dtime, created_by)
values ('fc27423d-82db-444e-b76d-43c772c92045', 'IR', 'db7cdd8b-0ef2-48d0-a010-736f396c039c', '31756', now(), 'kangwei')

--insert into dibots_user_pref.user_company_peer (parent_id, company_id, company_ext_id, created_dtime, created_by)
--values (13, 'a7cea5b9-8b43-4212-8704-637560370b4b', 9688, now(), 'kangwei')

--insert into dibots_user.company_peer_current (parent_id, updated_date, is_deleted)
--values (13, current_date, false)

--insert into dibots_user_pref.company_peer_historical (parent_id, peer_company_id, updated_date, status)
--values (13, 'a7cea5b9-8b43-4212-8704-637560370b4b', current_date, 'A')


-- verify the new user role and extension
select * from dibots_user.user_role where user_id = 'fc27423d-82db-444e-b76d-43c772c92045'

select * from dibots_user.user_role_extension where user_id = 'fc27423d-82db-444e-b76d-43c772c92045'

select * from dibots_user.user_company_link where user_id = 'fc27423d-82db-444e-b76d-43c772c92045'

select * from dibots_user_pref.user_company_link where user_id = 'fc27423d-82db-444e-b76d-43c772c92045'

select * from dibots_user.user_company_peer where parent_id = 13

select * from dibots_user_pref.company_peer_current where parent_id = 13

select * from dibots_user_pref.company_peer_historical where parent_id = 13




