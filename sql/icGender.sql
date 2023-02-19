-- Generate the birthdate based on IC. Defaulted year to 19XX.
update dibots_v2.person_profile 
set year_of_birth = ('19' || substring(dibots_v2.entity_identifier.identifier, 1, 2))::integer, 
	month_of_birth = substring(dibots_v2.entity_identifier.identifier, 3, 2)::integer,
	day_of_birth = substring(dibots_v2.entity_identifier.identifier, 5, 2)::integer
from dibots_v2.entity_identifier  
where dibots_v2.person_profile.dbt_entity_id = dibots_v2.entity_identifier.dbt_entity_id 
	and dibots_v2.entity_identifier.deleted = false 
	and dibots_v2.entity_identifier.identifier_type = 'MK' 
	and length(regexp_replace(dibots_v2.entity_identifier.identifier, '[^0-9]+', '', 'g')) = 12
	and dibots_v2.person_profile.active = true 
	and dibots_v2.entity_identifier.identifier not like all(array['%0000','0%'])

-- Generate the birthdate based on IC. Defaulted year to 20XX for IC started with 0.
update dibots_v2.person_profile 
set year_of_birth = ('20' || substring(dibots_v2.entity_identifier.identifier, 1, 2))::integer, 
	month_of_birth = substring(dibots_v2.entity_identifier.identifier, 3, 2)::integer,
	day_of_birth = substring(dibots_v2.entity_identifier.identifier, 5, 2)::integer
from dibots_v2.entity_identifier  
where dibots_v2.person_profile.dbt_entity_id = dibots_v2.entity_identifier.dbt_entity_id 
	and dibots_v2.entity_identifier.deleted = false 
	and dibots_v2.entity_identifier.identifier_type = 'MK' 
	and length(regexp_replace(dibots_v2.entity_identifier.identifier, '[^0-9]+', '', 'g')) = 12
	and dibots_v2.person_profile.active = true 
	and dibots_v2.entity_identifier.identifier like '%0'
	
