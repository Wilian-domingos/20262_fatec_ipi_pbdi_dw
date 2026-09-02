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
-- ALTER TABLE staging.sales 
-- ALTER COLUMN branch TYPE VARCHAR (200);

-- TRUNCATE TABLE staging.sales;

-- INSERT INTO staging.sales (
--     invoice_id, branch, city, customer_type,
--     gender, product_line, payment,
--     unit_price, quantity, tax_5pct,
--     total, cogs, gross_income, rating,
--     sale_ts
-- )
-- SELECT
--     TRIM(invoice_id),
--     UPPER(TRIM(branch)),
--     INITCAP(TRIM(city)),
--     INITCAP(TRIM(customer_type)),
--     INITCAP(TRIM(gender)),
--     INITCAP(TRIM(product_line)),
--     INITCAP(TRIM(payment)),
--     CAST(TRIM(unit_price) AS NUMERIC(10,2)),
--     CAST(TRIM(quantity) AS INTEGER),
--     CAST(TRIM(tax_5pct) AS NUMERIC(10,4)),
--     CAST(TRIM(total) AS NUMERIC(12,2)),
--     CAST(TRIM(cogs) AS NUMERIC(12,2)),
--     CAST(TRIM(gross_income) AS NUMERIC(10,4)),
--     CAST(TRIM(rating) AS NUMERIC(4,1)),
--     TO_TIMESTAMP(
--         TRIM(sale_date) || ' ' || TRIM(sale_time),
--         'MM/DD/YYYY HH12:MI:SS AM'
--     )
-- FROM raw.sales
-- WHERE TRIM(invoice_id) <> '';

-- -- Conferência
-- SELECT COUNT(*) FROM staging.sales;
-- SELECT * FROM staging.sales LIMIT 3;


