-- basic builtin datatypes
SELECT * FROM pglogical_regress_variables()
\gset

\c :provider_dsn
CREATE TABLE public.basic_dml (
	id serial primary key,
	other integer,
	data text,
	something interval
);

-- insert rows with basic without the to be added default

INSERT INTO basic_dml(other, data, something)
VALUES (5, 'foo', '1 minute'::interval),
       (4, 'bar', '12 weeks'::interval),
       (3, 'baz', '2 years 1 hour'::interval),
       (2, 'qux', '8 months 2 days'::interval),
       (1, NULL, NULL);

ALTER TABLE public.basic_dml ADD COLUMN not_null_default integer DEFAULT 0 NOT NULL;

SELECT id, other, data, something, not_null_default FROM basic_dml ORDER BY id;

\c :subscriber_dsn

CREATE TABLE public.basic_dml (
	id serial primary key,
	other integer,
	data text,
	something interval,
	not_null_default integer DEFAULT 0 NOT NULL
);

\c :provider_dsn

SELECT * FROM pglogical.replication_set_add_table('default', 'basic_dml', synchronize_data := true);

SELECT pglogical.wait_slot_confirm_lsn(NULL, NULL);

\c :subscriber_dsn

BEGIN;
SET LOCAL statement_timeout = '10s';
SELECT pglogical.wait_for_table_sync_complete('test_subscription', 'basic_dml');
COMMIT;

SELECT id, other, data, something, not_null_default FROM basic_dml ORDER BY id;

\c :provider_dsn
\set VERBOSITY terse
SELECT pglogical.replicate_ddl_command($$
	DROP TABLE public.basic_dml CASCADE;
$$);
