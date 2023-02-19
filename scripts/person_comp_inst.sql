select * from dibots_v2.person_profile where lower(fullname) like 'flybrunei%'

select * from dibots_v2.company_profile where lower(company_name) like 'flybrunei%'

select * from dibots_v2.institution_profile where external_id = 21318898

select * from dibots_v2.entity_master where external_id = 21382421


select * from dibots_v2.person_profile a, dibots_v2.company_profile b where lower(a.fullname) like '%sdn%' and
regexp_replace(lower(a.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(company_name), '[^A-Za-z0-9]','','g') and 
regexp_replace(lower(b.company_name), '[^A-Za-z0-9]', '', 'g') <> '' and 
regexp_replace(lower(a.fullname), '[^A-Za-z0-9]', '', 'g') <> ''

select * from dibots_v2.institution_profile a, dibots_v2.company_profile b where lower(a.institution_name) like '%sdn%' and
regexp_replace(lower(a.institution_name), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(company_name), '[^A-Za-z0-9]','','g') and 
regexp_replace(lower(b.company_name), '[^A-Za-z0-9]', '', 'g') <> '' and 
regexp_replace(lower(a.institution_name), '[^A-Za-z0-9]', '', 'g') <> ''