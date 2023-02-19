select registration_no, regexp_split_to_array(registration_no, '\n') from ssm

alter table ssm add column roc_arr varchar(255)[2], add column old_roc varchar(255), add column new_roc varchar(255), add column old_roc_num int;

update ssm
set roc_arr = regexp_split_to_array(registration_no, '\n')

update ssm
set 
new_roc = roc_arr[1],
old_roc = regexp_replace(regexp_replace(roc_arr[2], '\(', '', 'g'), '\)', '', 'g')

update ssm
set
roc_arr = null,
old_roc = null,
new_roc = null
where old_roc is null

update ssm
set
old_roc_num = cast(regexp_replace(old_roc, '[^0-9]', '', 'g') as int)


select * from ssm where registration_no = '201801037179
(1299209-H)'

delete from ssm where registration_no = '201801037179
(1299209-H)'

insert into ssm (registration_no, company_name, record_created_date)
values ('201801037179
(1299209-H)', 'YENA IMS KOREA SDN. BHD.', '2020-02-27T12:16:10.617Z')


select registration_no, old_roc, new_roc, count(*) from ssm
group by registration_no, old_roc, new_roc having count(*) > 1

alter table ssm add constraint ssm_pkey primary key (registration_no);

select * from ssm