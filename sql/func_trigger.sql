--===========================
-- FUNCTIONS AND TRIGGERS
--===========================


--=================================================
-- EXCHANGE_TRADE_DEMOGRAPHY investor_type_custom
--=================================================

CREATE OR REPLACE FUNCTION dibots_v2.update_etd_investor_type_custom() 
RETURNS trigger AS $d$
BEGIN
	IF NEW.investor_type in ('INSTITUTIONAL', 'NOMINEES') THEN NEW.investor_type_custom = 'INSTITUTIONAL';
	ELSIF NEW.investor_type = 'RETAIL' THEN NEW.investor_type_custom = 'RETAIL';
	END IF;
return new;
END;
$d$ LANGUAGE plpgsql;

CREATE TRIGGER set_etd_investor_type_custom
before insert or update of investor_type
on dibots_v2.exchange_demography_y2021q04
for each row execute procedure dibots_v2.update_etd_investor_type_custom();


drop trigger set_etd_investor_type_custom on dibots_v2.exchange_demography_y2021q04

--===========================================
-- EXCHANGE_TRADE_DEMOGRAPHY locality_new
--===========================================

create or replace function dibots_v2.update_etd_locality_new()
returns trigger as $d$
begin 
	if new.intraday_account_type <> 'OTHERS' then new.locality_new = 'PROPRIETARY';
	elseif new.intraday_account_type = 'OTHERS' then new.locality_new = new.locality;
	end if;
return new;
end;
$d$ language plpgsql;

create trigger set_etd_locality_new
before insert or update of intraday_account_type
on dibots_v2.exchange_demography_y2021q04
for each row execute procedure dibots_v2.update_etd_locality_new();

drop trigger set_etd_locality_new on dibots_v2.exchange_demography_y2017q02;

--===========================================
-- EXCHANGE_TRADE_DEMOGRAPHY group_type
--===========================================

create or replace function dibots_v2.update_etd_group_type()
returns trigger as $d$
begin
	if new.intraday_account_type <> 'OTHERS' then new.group_type = new.intraday_account_type;
	elseif new.intraday_account_type = 'OTHERS' then new.group_type = new.investor_type;
	end if;
return new;
end
$d$ language plpgsql;

create trigger set_etd_group_type
before insert or update of intraday_account_type
on dibots_v2.exchange_demography_y2021q04
for each row execute procedure dibots_v2.update_etd_group_type();

--=========================================
-- EXCHANGE_TRADE_DEMOGRAPHY age_band
--=========================================

CREATE OR REPLACE FUNCTION dibots_v2.update_dibots_age_band()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
	IF NEW.age = 0 THEN NEW.dibots_age_band = 'AGE NOT AVAILABLE';
	ELSIF NEW.age is null THEN NEW.dibots_age_band = 'AGE NOT AVAILABLE';
	ELSIF NEW.age < 18 THEN NEW.dibots_age_band = 'LESS AND 18' ;
	ELSIF NEW.age IN (18,19) THEN NEW.dibots_age_band = '18 - 19' ;
	ELSIF NEW.age between 20 and 24 THEN NEW.dibots_age_band = '20 - 24';
	ELSIF NEW.age between 25 and 29 THEN NEW.dibots_age_band = '25 - 29';
	ELSIF NEW.age between 30 and 34 THEN NEW.dibots_age_band = '30 - 34';
	ELSIF NEW.age between 35 and 39 THEN NEW.dibots_age_band = '35 - 39';
	ELSIF NEW.age between 40 and 44 THEN NEW.dibots_age_band = '40 - 44';
	ELSIF NEW.age between 45 and 49 THEN NEW.dibots_age_band = '45 - 49';
	ELSIF NEW.age between 50 and 54 THEN NEW.dibots_age_band = '50 - 54';
	ELSIF NEW.age between 55 and 59 THEN NEW.dibots_age_band = '55 - 59';
	ELSIF NEW.age between 60 and 64 THEN NEW.dibots_age_band = '60 - 64';
	ELSIF NEW.age between 65 and 69 THEN NEW.dibots_age_band = '65 - 69';
	ELSIF NEW.age between 70 and 74 THEN NEW.dibots_age_band = '70 - 74';
	ELSIF NEW.age between 75 and 79 THEN NEW.dibots_age_band = '75 - 79';
	ELSE NEW.dibots_age_band = '80 AND ABOVE';
	END IF;
return new;
END;
$function$
;

create trigger set_dibots_age_band before
insert
    or
update
    of age on
    dibots_v2.exchange_demography_y2021q04 for each row execute function dibots_v2.update_dibots_age_band();


--===========================================
-- EXCHANGE_MARKET_SUMMARY participant_code
--=========================================== 
   
create or replace function dibots_v2.update_ems_participant_code()
returns trigger as $d$
begin
	new.participant_code = (select participant_code 
	from dibots_v2.broker_profile b where b.dbt_entity_id = new.firm_dbt_entity_id  and b.eff_end_date is null and b.is_deleted = false);
return new;
end;
$d$ language plpgsql;

create trigger set_ems_participant_code
before insert or update of firm_dbt_entity_id
on dibots_v2.exchange_market_summary 
for each row execute procedure dibots_v2.update_ems_participant_code();


--==========================================
-- EXCHANGE_DAILY TRANSACTION price_changed
--==========================================

create or replace function dibots_v2.update_daily_trans_price_changed()
returns trigger as $d$
begin
	new.price_changed = new.closing_price_base - new.last_adjusted_closing_price;
return new;
end;
$d$ language plpgsql;

create trigger set_edt_price_changed
before insert or update of closing_price_base
on dibots_v2.exchange_daily_transaction 
for each row execute procedure dibots_v2.update_daily_trans_price_changed();

--==============================
-- PERSON_PROFILE_LKE updated
--==============================

CREATE OR REPLACE FUNCTION dibots_v2.change_updated_flag_person_profile_lke()
RETURNS trigger AS $d$
BEGIN
	NEW.updated := false; 
RETURN NEW;
END;
$d$ language plpgsql;

drop trigger flip_updated_flag on dibots_v2.person_profile_lke;
create trigger flip_updated_flag
before update on dibots_v2.person_profile_lke
for each row
when (old.updated = True)
execute procedure dibots_v2.change_updated_flag_person_profile_lke();

