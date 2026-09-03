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

-- aula dia 01/09/2026------------

-- SELECT * FROM generate_series(1,5); 
-- SELECT * FROM generate_series(0,100,25); 
-- SELECT d 
--     FROM generate_series(
--         DATE '2019-01-01',
--         DATE '2019-01-05',
--         INTERVAL '1 day'
--     ) g(d);

-- DROP TABLE IF EXISTS dw.dim_date CASCADE;
-- CREATE TABLE dw.dim_date (
--     date_sk INTEGER PRIMARY KEY, -- YYYYMMDD
--     full_date DATE NOT NULL UNIQUE,
--     day SMALLINT NOT NULL,
--     month SMALLINT NOT NULL,
--     month_name VARCHAR(15) NOT NULL,
--     quarter SMALLINT NOT NULL,
--     year SMALLINT NOT NULL,
--     day_of_week VARCHAR(15) NOT NULL,
--     is_weekend BOOLEAN NOT NULL
-- );

-- INSERT INTO dw.dim_date
-- SELECT
--     CAST(TO_CHAR(d, 'YYYYMMDD') AS INTEGER),
--     d::DATE,
--     EXTRACT(DAY FROM d)::SMALLINT,
--     EXTRACT(MONTH FROM d)::SMALLINT,
--     TO_CHAR(d, 'TMMonth'),
--     EXTRACT(QUARTER FROM d)::SMALLINT,
--     EXTRACT(YEAR FROM d)::SMALLINT,
--     TO_CHAR(d, 'TMDay'),
--     EXTRACT(DOW FROM d) IN (0, 6)
-- FROM generate_series(DATE '2019-01-01', DATE '2019-12-31', INTERVAL '1 day') g(d);

-- SELECT COUNT(*) FROM dw.dim_date; -- 365

dim_branch -----------------------------------------------
-- DROP TABLE IF EXISTS dw.dim_branch CASCADE;
-- CREATE TABLE dw.dim_branch (
--     branch_sk SERIAL PRIMARY KEY,
--     branch_code CHAR(1) NOT NULL UNIQUE,
--     city VARCHAR(40) NOT NULL
-- );

-- dim_product ----------------------------------------------
-- DROP TABLE IF EXISTS dw.dim_product CASCADE;
-- CREATE TABLE dw.dim_product (
--     product_sk SERIAL PRIMARY KEY,
--     product_line VARCHAR(40) NOT NULL UNIQUE
-- );

-- dim_customer (segmento) ----------------------------------
-- DROP TABLE IF EXISTS dw.dim_customer CASCADE;
-- CREATE TABLE dw.dim_customer (
--     customer_sk SERIAL PRIMARY KEY,
--     customer_type VARCHAR(10) NOT NULL,
--     gender VARCHAR(10) NOT NULL,
--     UNIQUE (customer_type, gender)
-- );

-- dim_payment ----------------------------------------------
-- DROP TABLE IF EXISTS dw.dim_payment CASCADE;
-- CREATE TABLE dw.dim_payment (
--     payment_sk SERIAL PRIMARY KEY,
--     payment_type VARCHAR(20) NOT NULL UNIQUE
-- );



-- SELECT table_name
-- FROM information_schema.tables
-- WHERE table_schema = 'dw';

-- ALTER TABLE staging.sales 
-- ALTER COLUMN branch TYPE VARCHAR (200);
-- ALTER TABLE dw.dim_branch
-- ALTER COLUMN branch_code TYPE VARCHAR(10);

-- INSERT INTO dw.dim_branch (branch_code, city)
-- SELECT DISTINCT branch, city FROM staging.sales;

-- INSERT INTO dw.dim_product (product_line)
-- SELECT DISTINCT product_line FROM staging.sales;

-- INSERT INTO dw.dim_customer (customer_type, gender)
-- SELECT DISTINCT customer_type, gender FROM staging.sales;

-- INSERT INTO dw.dim_payment (payment_type)
-- SELECT DISTINCT payment FROM staging.sales;

-- SELECT 'branch' AS dimensao, COUNT(*) AS linhas FROM dw.dim_branch
-- UNION ALL
-- SELECT 'product', COUNT(*) FROM dw.dim_product
-- UNION ALL
-- SELECT 'customer', COUNT(*) FROM dw.dim_customer
-- UNION ALL
-- SELECT 'payment', COUNT(*) FROM dw.dim_payment;

-- DROP TABLE IF EXISTS dw.fact_sales CASCADE;
-- CREATE TABLE dw.fact_sales (
--     invoice_nk VARCHAR(20) PRIMARY KEY, -- dimensao degenerada
--     date_sk INTEGER NOT NULL REFERENCES dw.dim_date(date_sk),
--     branch_sk INTEGER NOT NULL REFERENCES dw.dim_branch(branch_sk),
--     product_sk INTEGER NOT NULL REFERENCES dw.dim_product(product_sk),
--     customer_sk INTEGER NOT NULL REFERENCES dw.dim_customer(customer_sk),
--     payment_sk INTEGER NOT NULL REFERENCES dw.dim_payment(payment_sk),
--     unit_price NUMERIC(10,2) NOT NULL,
--     quantity INTEGER NOT NULL,
--     total NUMERIC(12,2) NOT NULL,
--     tax NUMERIC(10,4) NOT NULL,
--     cogs NUMERIC(12,2) NOT NULL,
--     gross_income NUMERIC(10,4) NOT NULL,
--     rating NUMERIC(4,1) NOT NULL
-- );

-- CREATE INDEX ix_fs_date ON dw.fact_sales(date_sk);
-- CREATE INDEX ix_fs_branch ON dw.fact_sales(branch_sk);
-- CREATE INDEX ix_fs_product ON dw.fact_sales(product_sk);
-- CREATE INDEX ix_fs_customer ON dw.fact_sales(customer_sk);
-- CREATE INDEX ix_fs_payment ON dw.fact_sales(payment_sk);

-- TRUNCATE TABLE dw.fact_sales;

-- INSERT INTO dw.fact_sales (
--     invoice_nk, date_sk,
--     branch_sk, product_sk, customer_sk, payment_sk,
--     unit_price, quantity, total, tax, cogs, gross_income, rating
-- )
-- SELECT
--     s.invoice_id,
--     CAST(TO_CHAR(s.sale_ts, 'YYYYMMDD') AS INTEGER),
--     db.branch_sk,
--     dp.product_sk,
--     dc.customer_sk,
--     dpa.payment_sk,
--     s.unit_price, s.quantity, s.total,
--     s.tax_5pct, s.cogs, s.gross_income, s.rating
-- FROM staging.sales s
-- JOIN dw.dim_branch db ON db.branch_code = s.branch
-- JOIN dw.dim_product dp ON dp.product_line = s.product_line
-- JOIN dw.dim_customer dc ON dc.customer_type = s.customer_type
--     AND dc.gender = s.gender
-- JOIN dw.dim_payment dpa ON dpa.payment_type = s.payment;

-- SELECT COUNT(*) FROM dw.fact_sales; -- 1000
