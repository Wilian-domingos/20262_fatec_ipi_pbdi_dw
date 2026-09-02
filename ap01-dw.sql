-- CREATE SCHEMA IF NOT EXISTS raw;
-- CREATE SCHEMA IF NOT EXISTS staging;
-- CREATE SCHEMA IF NOT EXISTS dw;

-- -- Conferencia
-- SELECT schema_name
-- FROM information_schema.schemata
-- WHERE schema_name IN ('raw', 'staging', 'dw');

-- DROP TABLE IF EXISTS raw.sales CASCADE;
-- CREATE TABLE raw.sales (
-- invoice_id TEXT,
-- branch TEXT,
-- city TEXT,
-- customer_type TEXT,
-- gender TEXT,
-- product_line TEXT,
-- unit_price TEXT,
-- quantity TEXT,
-- tax_5pct TEXT,
-- total TEXT,
-- sale_date TEXT,
-- sale_time TEXT,
-- payment TEXT,
-- cogs TEXT,
-- gross_margin_percentage TEXT,
-- gross_income TEXT,
-- rating TEXT
-- );
-- importa na tabela sales no schemas raw


-- SELECT * FROM raw.sales;

-- SELECT COUNT(*) FROM raw.sales;
-- SELECT * FROM raw.sales LIMIT 3;

-- DROP TABLE IF EXISTS staging.sales CASCADE;
-- CREATE TABLE staging.sales (
-- invoice_id VARCHAR(20) PRIMARY KEY,
-- branch CHAR(1) NOT NULL,
-- city VARCHAR(40) NOT NULL,
-- customer_type VARCHAR(10) NOT NULL,
-- gender VARCHAR(10) NOT NULL,
-- product_line VARCHAR(40) NOT NULL,
-- unit_price NUMERIC(10,2) NOT NULL,
-- quantity INTEGER NOT NULL,
-- tax_5pct NUMERIC(10,4) NOT NULL,
-- total NUMERIC(12,2) NOT NULL,
-- sale_ts TIMESTAMP NOT NULL,
-- payment VARCHAR(20) NOT NULL,
-- cogs NUMERIC(12,2) NOT NULL,
-- gross_income NUMERIC(10,4) NOT NULL,
-- rating NUMERIC(4,1) NOT NULL
-- );

-- SELECT * FROM staging.sales;
--- crie uma tabela sales no schemas staging





