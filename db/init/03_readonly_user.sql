-- db/init/03_readonly_user.sql
-- Usuario de solo lectura para que los participantes consulten los datos
-- sin poder modificar nada en la BD demo

CREATE USER demo_reader WITH PASSWORD 'readonlybk2026';
GRANT CONNECT ON DATABASE bankalyst_demo TO demo_reader;
GRANT USAGE ON SCHEMA public TO demo_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO demo_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO demo_reader;