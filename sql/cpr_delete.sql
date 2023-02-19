select * from dibots_v2.company_person_role where wvb_company_person_id < 0

select count(*) from neo4j_list.company_person_role_delete

insert into neo4j_list.company_person_role_delete
select cpr.id, cpr.company_id, cpr.person_id, cpr.wvb_company_person_id, cpr.created_dtime, cpr.created_by
from dibots_v2.company_person_role cpr
left join wvb_clone.company_person_role clone
on cpr.wvb_company_person_id = clone.co_person_role_perm_id
where clone.co_person_role_perm_id is null


select * from dibots_v2.company_person_role cpr
left join wvb_clone.company_person_role clone
on cpr.wvb_company_person_id = clone.co_person_role_perm_id
where clone.co_person_role_perm_id is null and (cpr.modified_by = 'LKE' or cpr.wvb_company_person_id < 0)

select * from dibots_v2.company_person_role where id in (8580419,8580420,8376296,8375797,8375545,8374930,8374929,8374434,8374433,8374436,8374435,8374432,8374431,8374430,8373848,8373199,
8371785,1114961,3232022,7169136,7169138,5232805,4530566,2904759,4340844) and deleted = false


select id from neo4j_list.company_person_role_delete

delete from dibots_v2.company_person_role where id in
(select id from neo4j_list.company_person_role_delete)

select count(*) from dibots_v2.company_person_role

select * from dibots_v2.company_profile where external_id = 3619

select * from dibots_v2.company_person_role where company_id = '3fbb0214-1dc6-4f88-98bc-ac7ab73a17ac' and deleted = false