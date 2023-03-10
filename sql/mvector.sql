--===============
-- retail_user
--===============

CREATE TABLE retail.retail_user (
	user_id uuid NOT NULL DEFAULT gen_random_uuid(),
	username varchar(200) NOT NULL,
	hashed_password varchar(10000) NOT NULL,
	email varchar(300) NOT NULL,
	email_verified bool NULL DEFAULT false,
	phone_num varchar(50) NOT NULL,
	registered_date date NOT NULL,
	active bool NOT NULL,
	created_dtime timestamptz NOT NULL DEFAULT now(),
	created_by varchar(100) NOT NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	reset_password bool NOT NULL DEFAULT false,
	dob date NULL,
	fullname text NULL,
	gender text NULL,
	tc_signed bool NULL,
	tc_signed_date timestamptz NULL,
	passport text NULL,
	passport_country text NULL,
	income_range int4 NULL,
	ic text NULL,
	broker uuid NULL,
	phone_verified bool NULL DEFAULT false,
	purchase_feature bool NULL DEFAULT true,
	id_uploaded bool NULL DEFAULT false,
	id_verified bool NULL DEFAULT false,
	CONSTRAINT retail_user_phone_num_check CHECK (((phone_num)::text ~ '^[0-9]+$'::text)),
	CONSTRAINT retail_user_pkey PRIMARY KEY (user_id),
	CONSTRAINT retail_user_username_check CHECK (((username)::text !~ '[\s]'::text)),
	CONSTRAINT income_range_fkey FOREIGN KEY (income_range) REFERENCES retail.ref_income_range(id)
);
CREATE UNIQUE INDEX retail_user_email ON retail.retail_user USING btree (lower((email)::text));
CREATE UNIQUE INDEX retail_user_username ON retail.retail_user USING btree (lower((username)::text));



--======================
-- retail_user_address
--======================

CREATE TABLE retail.retail_user_address (
	id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	user_id uuid NOT NULL,
	address_type int4 NOT NULL,
	address_line text NULL,
	city text NULL,
	state text NULL,
	postcode text NULL,
	country text NULL,
	created_dtime timestamptz NOT NULL DEFAULT now(),
	created_by varchar(100) NOT NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	CONSTRAINT retail_user_address_pkey PRIMARY KEY (id),
	CONSTRAINT retail_user_address_uniq UNIQUE (user_id, address_type),
	CONSTRAINT retail_user_address_type_fkey FOREIGN KEY (address_type) REFERENCES retail.ref_address_type(id),
	CONSTRAINT retail_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES retail.retail_user(user_id)
);

--===================
-- ref_address_type
--===================

CREATE TABLE retail.ref_address_type (
	id int4 NOT NULL,
	address_type text NULL,
	address_desc text NULL,
	created_dtime timestamptz NOT NULL DEFAULT now(),
	created_by varchar(100) NOT NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	CONSTRAINT ref_address_type_pkey PRIMARY KEY (id)
);

--=====================
-- ref_broker_profile
--=====================

CREATE OR REPLACE VIEW retail.ref_broker_profile
AS SELECT broker_profile.dbt_entity_id,
    broker_profile.external_id,
    broker_profile.participant_code,
    broker_profile.participant_name
   FROM dibots_v2.broker_profile
  WHERE broker_profile.type = 'BROKER'::text AND broker_profile.eff_end_date IS NULL AND broker_profile.is_deleted = false;


--====================
-- ref_income_range
--====================

CREATE TABLE retail.ref_income_range (
	id int4 NOT NULL,
	income_range text NULL,
	created_dtime timestamptz NOT NULL DEFAULT now(),
	created_by varchar(100) NOT NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	CONSTRAINT ref_income_range_pkey PRIMARY KEY (id)
);

--=================
-- user_watchlist
--=================

CREATE TABLE retail.user_watchlist (
	id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	user_id uuid NOT NULL,
	stock_code text NOT NULL,
	start_date date NULL,
	end_date date NULL,
	watchlist_group int4 NOT NULL,
	created_dtime timestamptz NOT NULL DEFAULT now(),
	created_by varchar(100) NOT NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	CONSTRAINT user_watchlist_pkey PRIMARY KEY (id),
	CONSTRAINT user_watchlist_uniq UNIQUE (user_id, watchlist_group, stock_code),
	CONSTRAINT user_watchlist_fkey FOREIGN KEY (user_id,watchlist_group) REFERENCES retail.user_watchlist_group(user_id,watchlist_group),
	CONSTRAINT user_watchlist_user_fkey FOREIGN KEY (user_id) REFERENCES retail.retail_user(user_id)
);

--=======================
-- user_watchlist_group
--=======================

CREATE TABLE retail.user_watchlist_group (
	id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	user_id uuid NOT NULL,
	watchlist_group int4 NOT NULL,
	watchlist_name text NULL,
	is_deleted bool NULL DEFAULT false,
	created_dtime timestamptz NOT NULL DEFAULT now(),
	created_by varchar(100) NOT NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	CONSTRAINT user_watchlist_group_pkey PRIMARY KEY (id),
	CONSTRAINT user_watchlist_group_uniq UNIQUE (user_id, watchlist_group)
);
