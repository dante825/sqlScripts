--===========
-- providers
--===========

select * from dibots_v2.ee_providers where lower(provider_name) like '%cgs%'

select * from dibots_v2.ee_providers where provider_id = 581

select * from dibots_v2.company_profile where lower(company_name) like 'clsa%' and wvb_entity_type = 'COMP'

insert into dibots_v2.ee_providers (provider_id, company_perm_id, dbt_entity_id, external_id, provider_name, website, email, telephone, telephone2, fax, address, iso_country_code, 
provider_status, profile_in_public, is_deleted, created_dtime, created_by) values

(-2004, 2586394, '76ebf0b1-721d-4530-8102-d2603d918249', 72869, 'CLSA SECURITIES MALAYSIA SDN BHD', null, null, null, null, null, null, 'MYS', 1, 1, false, now(), 'kangwei');
(-2003, 10208625, 'a0fbdbd1-1e3a-4914-a24a-80291522f859', 2605456, 'KAF EQUITIES SDN. BHD.', null, null, null, null, null, null, 'MYS', 1, 1, false, now(), 'kangwei')
(-2002, 12045210, '831905cf-bda0-4a80-8425-d28ed834a446', 4211630, 'NOMURA SECURITIES CO LTD', null, null, null, null, null, null, 'JPN', 1, 1, false, now(), 'kangwei')
(-2001, 2579891, 'ac2dd6fe-52ac-4aa1-a9cf-74ae0f456833', 66534, 'JPMorgan Securities (Malaysia) Sdn. Bhd.', 'www.jpmorganmarkets.com', null, null, null, null, null, 'MYS', 1,1,false, now(), 'kangwei')
(-2000, 10422261, '89df8806-74f6-47d3-90aa-d9b382a84e37', 2724491, 'MACQUARIE CAPITAL SECURITIES (MALAYSIA) SDN. BHD.', 'www.macquarieinsights.com', 'macresearch@macquarie.com', 
null, null, null, null, 'MYS', 1, 1, false, now(), 'kangwei')

--===========
-- analysts
--===========

select * from dibots_v2.ee_analysts --where provider_id = 3500

select * from dibots_v2.ee_analysts where analyst_id < -2000 order by analyst_id asc

insert into dibots_v2.ee_analysts (analyst_id, provider_id, analyst_status, profile_in_public, last_name, first_name, middle_initial_or_name, display_name, iso_country_of_citizenship, 
job_title, department, phone_number1, email, address, created_dtime, created_by) values 
(-2093, 3500, 0,0, 'Khoo', 'Zhen Ye', null, 'Khoo Zhen Ye', 'MYS', 'Analyst', 'research', '(60) 3 2635 9278', 'zhenye.khoo@cgs-cimb.com', null, now(), 'kangwei')

(-2086,3500, 0, 0, 'Nagulan', 'Ravi', null, 'MYS', 'Analyst', null, '603 2635 9264', 'nagulan.ravi@cgs-cimb.com', null, now(), 'kangwei') 

(-169,3400, 0, 0, 'Analyst', 'Unknown', null, 'MYS', 'Analyst', null, null, 'www.amequities.com.my', null, now(), 'kangwei') 
(-2031, 1260, 0, 0, 'Ang', 'Jae', null, 'MYS', 'Analyst', null, '6 03 2723 2095', 'jae.ang@credit-suisse.com', null, now(), 'kangwei')
(-2030, 640, 0, 0, 'Chong', 'Desmond', null, 'MYS', 'Analyst', null, '+603 2147 1980', 'desmondchong@uobkayhian.com', null, now(), 'kangwei')
(-2029, 680, 0, 0, 'Lee', 'Meng Horng', null, 'MYS', 'Analyst', null, '+603 9280 8866', 'lee.meng.horng@rhbgroup.com', null, now(), 'kangwei')

(-2025, -2004, 0, 0, 'Kong', 'Peter', null, 'MYS', 'Analyst', null, '+60 3 2056 7877', 'peter.kong@clsa.com', null, now(), 'kangwei');
(-2024, -2004, 0, 0, 'Lim', 'Sue Lin', null, 'MYS', 'Analyst', null, '60 3 2056 7875', 'suelin.lim@clsa.com', null, now(), 'kangwei');
(-2023, -2002, 0, 0, 'Dohare', 'Rahul', null, null, 'Analyst', null, '+91 22 672 34560', 'rahul.dohare@nomura.com', null, now(), 'kangwei');
(-2022, -2002, 0, 0, 'Kong', 'Heng Siong', null, 'MYS', 'Analyst', null, '+603 2027 6894', 'hengsiong.kong@nomura.com', null, now(), 'kangwei');
(-2021, 620, 0, 0, 'Fais', 'Megat', null, 'MYS', 'CFA', null, '+60-3-2383-2940', 'megat.fais@citi.com', null, now(), 'kangwei')
(-2020, 1260, 0, 0, 'Cheah', 'Joanna', null, 'MYS', 'Analyst', null, '6 03 2723 2081', 'joanna.cheah@credit-suisse.com', null, now(), 'kangwei');
(-2019, -2001, 0, 0, 'Singhi', 'Anshool', null, null, 'Analyst', null, '(91-22) 6157-5094', 'anshool.singhi@jpmchase.com', null, now(), 'kangwei');
(-2018, -2001, 0, 0, 'Mirchandani', 'Ajay', null, null, 'Analyst', null, '(65) 6882-2419', 'ajay.mirchandani@jpmorgan.com', null, now(), 'kangwei');
(-2017, -2000, 0, 0, 'Jearajasingam', 'Prem', null, 'MYS', 'Analyst', null, '+60 3 2059 8989', 'prem.jearajasingam@macquarie.com', null, now(), 'kangwei')
(-2016, -2002, 0, 0, 'Alpa', 'Aggarwal', null, null, 'CFA', null, '+91 22 305 32250', 'alpa.aggarwal@nomura.com', null, now(), 'kangwei');
(-2015, -2002, 0, 0, 'Mohata', 'Tushar', null, 'MYS', 'CFA', null, '+60(3)20276895', 'tushar.mohata@nomura.com', null, now(), 'kangwei');
(-2014, 640, 0, 0, 'Zulkaplly', 'Afif', null, 'MYS', 'Analyst', null, '+603 2147 1924', 'muhammadafif@uobkayhian.com', null, now(), 'kangwei');
(-2013, -2003, 0, 0, 'Mak', 'Hoy Ken', null, 'MYS', 'Analyst', null, '(603) 2171 0508', 'mak.hoyken@kaf.com.my', null, now(), 'kangwei');
(-2012, -2002, 0, 0, 'Banka', 'Bineet', null, null, 'CFA', null, '+91(22)4053 3784', 'bineet.banka@nomura.com', null, now(), 'kangwei');
(-2011, -2002, 0, 0, 'Usman', 'Ahmad', 'Maghfur', 'MYS', 'Analyst', null, '+603 2027 6892', 'ahmad.maghfurusman@nomura.com', null, now(), 'kangwei');
(-2010, 3460, 0, 0, 'Tan', 'Kai Shuen', null, 'MYS', 'CFA', null, '(603) 2083 1714', 'kstan@hlib.hongleong.com.my', null, now(), 'kangwei');
(-2009, 3500, 0, 0, 'Ng', 'Wilson', null, 'MYS', 'Analyst', null, '(60) 3 2261 9071', 'winson.ng@cgs-cimb.com', null, now(), 'kangwei');
(-2008, 640, 0, 0, 'Yow', 'Jacquelyn', null, 'MYS', 'Analyst', null, '+603 2147 1995', 'jacquelyn@uobkayhian.com', null, now(), 'kangwei')
(-2007, 640, 0, 0, 'Leow', 'Huey Chuen', null, 'MYS', 'Analyst', null, '+603 2147 1990', 'hueychuen@uobkayhian.com', null, now(), 'kangwei')
(-2006, 640, 0, 0, 'Wee', 'Keith', 'Teck Keong', 'MYS', 'Analyst', null, '+603 2147 1981', 'keithwee@uobkayhian.com', null, now(), 'kangwei')
(-2005, -2002, 0, 0, 'Matsumoto', 'Shigeki', null, 'JPN', 'Analyst', null, '+81 3 6703 1137', null, null, now(), 'kangwei')
(-2004, -2001, 0, 0, 'Cheah', 'YY', null, 'MYS', 'CFA', null, '(60-3) 2718-0609', 'yoke.y.cheah@jpmorgan.com', null, now(), 'kangwei')
(-2003, -2001, 0, 0, 'Ng', 'Jeffrey', null, 'MYS', 'Analyst', null, '(60-3) 2718 0713', 'Jeff.Ng@jpmorgan.com', null, now(), 'kangwei')
(-2002, 680, 0, 0, 'Lim', 'Alan', null, 'MYS', 'CFA', null, '+603 9280 8890', 'alan.lim@rhbgroup.com', null, now(), 'kangwei')
(-2001, 680, 0, 0, 'Chew', 'Sean', null, 'MYS', 'Analyst', null, '+603 92808801', 'sean.chew@rhbgroup.com', null, now(), 'kangwei')
(-2000, -2000, 0, 0, 'Soon', 'Denise', null, 'MYS', 'Analyst', null, '+603 2059 8845', 'denise.soon@macquarie.com', null, now(), 'kangwei')

select * from dibots_v2.ee_analysts where analyst_id = -2004

update dibots_v2.ee_analysts 
set
last_name = 'Cheah',
first_name = 'YY'
where analyst_id = -2004


--==============================
-- TO RESET THE UPLOADED FILES
--==============================

-- check the number of files uploaded
select * from dibots_v2.research_report_view where file_upload_date::date = '2022-05-19'

select * from dibots_v2.ee_spreadsheet_files where file_upload_date::date = '2022-05-19'

select * from dibots_v2.ee_earning_estimates_hdr where created_dtime::date = '2022-05-19' and created_by = 'rsrpt_extractor'

select * from dibots_v2.ee_earning_estimates_hdr where estimate_id in (-1882, -1883)

select * from dibots_v2.ee_analyst_estimate_hdr where created_dtime::date = '2022-05-19' and created_by = 'rsrpt_extractor'

select * from dibots_v2.ee_analyst_estimate_hdr where estimate_id in (-1882, -1883)

select * from dibots_v2.ee_data_item_value where created_dtime::date = '2022-05-19' and created_by = 'rsrpt_extractor'

select * from dibots_v2.ee_data_item_value where estimate_id in (-1882, -1883)

select * from dibots_v2.ee_data_item_value_forecast where created_dtime::date = '2022-05-19' and created_by = 'rsrpt_extractor'

select * from dibots_v2.ee_data_item_value_forecast where estimate_id in (-1882, -1883)

select * from dibots_v2.ee_spreadsheet_file_delete_archive where created_dtime::date = '2022-05-19' and created_by = 'kwng_admin'

-- DELETE THE FILES IN THE SERVER

-- delete the records in the table

delete from dibots_v2.ee_spreadsheet_files where file_id in (-1859,-1860,-1861,-1862,-1863,-1864)

delete from dibots_v2.ee_earning_estimates_hdr where created_dtime::date = '2022-05-19' and created_by = 'rsrpt_extractor'
--estimate_id in (-1882, -1883)

delete from dibots_v2.ee_analyst_estimate_hdr where created_dtime::date = '2022-05-19' and created_by = 'rsrpt_extractor'
--estimate_id in (-1882, -1883)

delete from dibots_v2.ee_data_item_value where created_dtime::date = '2022-05-19' and created_by = 'rsrpt_extractor'
--estimate_id in (-1882, -1883)

delete from dibots_v2.ee_data_item_value_forecast where created_dtime::date = '2022-05-19' and created_by = 'rsrpt_extractor'
--estimate_id in (-1882, -1883)

delete from dibots_v2.ee_spreadsheet_file_delete_archive where created_dtime::date = '2022-05-19' and created_by = 'kwng_admin'


