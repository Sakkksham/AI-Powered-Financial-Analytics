CREATE DATABASE financial_analytics;
USE financial_analytics;

SELECT DATABASE();

USE financial_analytics;

CREATE TABLE companies (
    id INT PRIMARY KEY,
    company_name VARCHAR(150) NOT NULL,
    company_logo TEXT,
    website TEXT,
    nse_profile TEXT,
    bse_profile TEXT,
    chart_link TEXT,
    about_company TEXT,
    face_value DECIMAL(12,2),
    book_value DECIMAL(15,2),
    roce_percentage DECIMAL(10,2),
    roe_percentage DECIMAL(10,2)
);

SHOW TABLES;

DESCRIBE companies;

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';


USE financial_analytics;

DELETE FROM companies;

ALTER TABLE companies
MODIFY COLUMN id VARCHAR(30) NOT NULL;

DESCRIBE companies;

LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/companies_clean.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_logo,
    company_name,
    chart_link,
    about_company,
    website,
    nse_profile,
    bse_profile,
    face_value,
    book_value,
    roce_percentage,
    roe_percentage
);

SELECT COUNT(*) AS company_count
FROM companies;

SELECT id, company_name
FROM companies
ORDER BY id
LIMIT 10;

SELECT *
FROM companies
WHERE id IN ('ABB', 'ADANIENSOL', 'ADANIENT');


DESCRIBE companies;

SELECT
    id,
    company_name,
    company_logo,
    website,
    nse_profile,
    bse_profile,
    chart_link,
    about_company,
    face_value,
    book_value,
    roce_percentage,
    roe_percentage
FROM companies
WHERE id = 'ABB';

SELECT COUNT(*) AS total_companies,
       COUNT(DISTINCT id) AS unique_companies
FROM companies;


SHOW TABLES;


USE financial_analytics;

CREATE TABLE nifty100_analysis (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    sales_growth_period VARCHAR(50),
    sales_growth DECIMAL(10,2),
    profit_growth_period VARCHAR(50),
    profit_growth DECIMAL(10,2),
    stock_price_cagr_period VARCHAR(50),
    stock_price_cagr DECIMAL(10,2),
    roe_period VARCHAR(50),
    roe DECIMAL(10,2),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/nifty100_analysis_clean.csv'
INTO TABLE nifty100_analysis
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    sales_growth_period,
    sales_growth,
    profit_growth_period,
    profit_growth,
    stock_price_cagr_period,
    stock_price_cagr,
    roe_period,
    roe
);

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT id) AS unique_ids
FROM nifty100_analysis;

SELECT DISTINCT company_id
FROM nifty100_analysis
WHERE company_id NOT IN (
    SELECT id FROM companies
);

SELECT COUNT(*) AS total_rows
FROM nifty100_analysis;

SELECT COUNT(DISTINCT company_id) AS companies
FROM nifty100_analysis;


SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT id) AS unique_ids,
       COUNT(DISTINCT company_id) AS unique_companies
FROM nifty100_analysis;


SELECT COUNT(*) AS unmatched_companies
FROM nifty100_analysis a
LEFT JOIN companies c
    ON a.company_id = c.id
WHERE c.id IS NULL;



SELECT COUNT(*) AS company_count
FROM companies;

SELECT id
FROM companies
ORDER BY id;

USE financial_analytics;

INSERT INTO companies (id, company_name)
VALUES
('AGTL', 'AGTL'),
('ULTRACEMCO', 'UltraTech Cement Ltd'),
('UNIONBANK', 'Union Bank of India'),
('UNITDSPR', 'United Spirits Ltd'),
('VBL', 'Varun Beverages Ltd'),
('VEDL', 'Vedanta Ltd'),
('WIPRO', 'Wipro Ltd'),
('ZOMATO', 'Zomato Ltd'),
('ZYDUSLIFE', 'Zydus Lifesciences Ltd');

SELECT COUNT(*) AS company_count
FROM companies;


SELECT id, company_name
FROM companies
WHERE id IN (
    'AGTL',
    'ULTRACEMCO',
    'UNIONBANK',
    'UNITDSPR',
    'VBL',
    'VEDL',
    'WIPRO',
    'ZOMATO',
    'ZYDUSLIFE'
)
ORDER BY id;


TRUNCATE TABLE nifty100_analysis;

LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/nifty100_analysis_clean.csv'
INTO TABLE nifty100_analysis
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    sales_growth_period,
    sales_growth,
    profit_growth_period,
    profit_growth,
    stock_price_cagr_period,
    stock_price_cagr,
    roe_period,
    roe
);

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT id) AS unique_ids,
       COUNT(DISTINCT company_id) AS unique_companies
FROM nifty100_analysis;

SELECT COUNT(*) AS unmatched
FROM nifty100_analysis a
LEFT JOIN companies c
    ON a.company_id = c.id
WHERE c.id IS NULL;

USE financial_analytics;

CREATE TABLE balance_sheet (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    year VARCHAR(20) NOT NULL,
    equity_capital DECIMAL(18,2),
    reserves DECIMAL(18,2),
    borrowings DECIMAL(18,2),
    other_liabilities DECIMAL(18,2),
    total_liabilities DECIMAL(18,2),
    fixed_assets DECIMAL(18,2),
    cwip DECIMAL(18,2),
    investments DECIMAL(18,2),
    other_asset DECIMAL(18,2),
    total_assets DECIMAL(18,2),
    debt_to_assets DECIMAL(10,4),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/balance_sheet_clean.csv'
INTO TABLE balance_sheet
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    year,
    equity_capital,
    reserves,
    borrowings,
    other_liabilities,
    total_liabilities,
    fixed_assets,
    cwip,
    investments,
    other_asset,
    total_assets,
    debt_to_assets
);
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT id) AS unique_ids,
       COUNT(DISTINCT company_id) AS unique_companies
FROM balance_sheet;


SELECT COUNT(*) AS unmatched
FROM balance_sheet b
LEFT JOIN companies c
    ON b.company_id = c.id
WHERE c.id IS NULL;


SELECT
    COUNT(*) AS total_rows,
    COUNT(debt_to_assets) AS non_null_debt_to_assets,
    COUNT(*) - COUNT(debt_to_assets) AS null_debt_to_assets,
    MIN(debt_to_assets) AS min_value,
    MAX(debt_to_assets) AS max_value
FROM balance_sheet;

SELECT
    company_id,
    year,
    debt_to_assets
FROM balance_sheet
WHERE debt_to_assets IS NULL
   OR debt_to_assets = 0
LIMIT 20;

SELECT
    company_id,
    year,
    debt_to_assets
FROM balance_sheet
ORDER BY debt_to_assets DESC
LIMIT 20;




USE financial_analytics;

CREATE TABLE cash_flow (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    year VARCHAR(20) NOT NULL,
    operating_activity DECIMAL(18,2),
    investing_activity DECIMAL(18,2),
    financing_activity DECIMAL(18,2),
    net_cash_flow DECIMAL(18,2),
    company_year_count INT,
    company_year_conflict BOOLEAN,
    free_cash_flow DECIMAL(18,2),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);



SHOW TABLES;



LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/cash_flow_clean.csv'
INTO TABLE cash_flow
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    year,
    operating_activity,
    investing_activity,
    financing_activity,
    net_cash_flow,
    company_year_count,
    company_year_conflict,
    free_cash_flow
);


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM cash_flow;


SELECT COUNT(*) AS unmatched
FROM cash_flow cf
LEFT JOIN companies c
    ON cf.company_id = c.id
WHERE c.id IS NULL;


TRUNCATE TABLE cash_flow;

LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/cash_flow_mysql.csv'
INTO TABLE cash_flow
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    year,
    @operating_activity,
    @investing_activity,
    @financing_activity,
    @net_cash_flow,
    company_year_count,
    company_year_conflict,
    @free_cash_flow
)
SET
    operating_activity = NULLIF(TRIM(@operating_activity), ''),
    investing_activity = NULLIF(TRIM(@investing_activity), ''),
    financing_activity = NULLIF(TRIM(@financing_activity), ''),
    net_cash_flow = NULLIF(TRIM(@net_cash_flow), ''),
    free_cash_flow = NULLIF(TRIM(@free_cash_flow), '');
    
    SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT id) AS unique_ids,
       COUNT(DISTINCT company_id) AS unique_companies
FROM cash_flow;



USE financial_analytics;

CREATE TABLE financial_kpis (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    year VARCHAR(20) NOT NULL,
    net_profit_margin_pct DECIMAL(12,4),
    operating_profit_margin_pct DECIMAL(12,4),
    return_on_equity_pct DECIMAL(12,4),
    debt_to_equity DECIMAL(12,4),
    interest_coverage DECIMAL(12,4),
    asset_turnover DECIMAL(12,4),
    free_cash_flow_cr DECIMAL(18,2),
    capex_cr DECIMAL(18,2),
    earnings_per_share DECIMAL(18,4),
    book_value_per_share DECIMAL(18,4),
    dividend_payout_ratio_pct DECIMAL(12,4),
    total_debt_cr DECIMAL(18,2),
    cash_from_operations_cr DECIMAL(18,2),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);


SHOW TABLES;


LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/financial_kpis_clean.csv'
INTO TABLE financial_kpis
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    year,
    @net_profit_margin_pct,
    @operating_profit_margin_pct,
    @return_on_equity_pct,
    @debt_to_equity,
    @interest_coverage,
    @asset_turnover,
    @free_cash_flow_cr,
    @capex_cr,
    @earnings_per_share,
    @book_value_per_share,
    @dividend_payout_ratio_pct,
    @total_debt_cr,
    @cash_from_operations_cr
)
SET
    net_profit_margin_pct = NULLIF(TRIM(@net_profit_margin_pct), ''),
    operating_profit_margin_pct = NULLIF(TRIM(@operating_profit_margin_pct), ''),
    return_on_equity_pct = NULLIF(TRIM(@return_on_equity_pct), ''),
    debt_to_equity = NULLIF(TRIM(@debt_to_equity), ''),
    interest_coverage = NULLIF(TRIM(@interest_coverage), ''),
    asset_turnover = NULLIF(TRIM(@asset_turnover), ''),
    free_cash_flow_cr = NULLIF(TRIM(@free_cash_flow_cr), ''),
    capex_cr = NULLIF(TRIM(@capex_cr), ''),
    earnings_per_share = NULLIF(TRIM(@earnings_per_share), ''),
    book_value_per_share = NULLIF(TRIM(@book_value_per_share), ''),
    dividend_payout_ratio_pct = NULLIF(TRIM(@dividend_payout_ratio_pct), ''),
    total_debt_cr = NULLIF(TRIM(@total_debt_cr), ''),
    cash_from_operations_cr = NULLIF(TRIM(@cash_from_operations_cr), '');
    
    
    SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM financial_kpis;

SELECT COUNT(*) AS unmatched
FROM financial_kpis f
LEFT JOIN companies c
    ON f.company_id = c.id
WHERE c.id IS NULL;



CREATE TABLE valuation (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    year VARCHAR(20) NOT NULL,
    market_cap_crore DECIMAL(20,2),
    enterprise_value_crore DECIMAL(20,2),
    pe_ratio DECIMAL(12,4),
    pb_ratio DECIMAL(12,4),
    ev_ebitda DECIMAL(12,4),
    dividend_yield_pct DECIMAL(12,4),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);


SHOW TABLES;


LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/valuation/valuation_clean.csv'
INTO TABLE valuation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    year,
    market_cap_crore,
    enterprise_value_crore,
    pe_ratio,
    pb_ratio,
    ev_ebitda,
    dividend_yield_pct
);

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM valuation;

SELECT COUNT(*) AS unmatched
FROM valuation v
LEFT JOIN companies c
    ON v.company_id = c.id
WHERE c.id IS NULL;


USE financial_analytics;

CREATE TABLE documents (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    year VARCHAR(20) NOT NULL,
    annual_report TEXT,
    FOREIGN KEY (company_id) REFERENCES companies(id)
);


LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/documents_clean.csv'
INTO TABLE documents
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    year,
    @annual_report
)
SET
    annual_report = NULLIF(TRIM(@annual_report), '');
    
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM documents;


SELECT COUNT(*) AS unmatched
FROM documents d
LEFT JOIN companies c
    ON d.company_id = c.id
WHERE c.id IS NULL;


USE financial_analytics;

CREATE TABLE sector_mapping (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company VARCHAR(30) NOT NULL,
    sector VARCHAR(100) NOT NULL,
    sub_sector VARCHAR(100) NOT NULL
);

LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/sector_mapping/sector_mapping_clean.csv'
INTO TABLE sector_mapping
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    company,
    sector,
    sub_sector
);

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT company) AS unique_companies
FROM sector_mapping;

SELECT *
FROM sector_mapping
WHERE company = 'company';

DELETE FROM sector_mapping
WHERE company = 'company';


USE financial_analytics;

CREATE TABLE profit_loss (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    year VARCHAR(20) NOT NULL,
    sales DECIMAL(20,2),
    expenses DECIMAL(20,2),
    operating_profit DECIMAL(20,2),
    opm_percentage DECIMAL(12,4),
    other_income DECIMAL(20,2),
    interest DECIMAL(20,2),
    depreciation DECIMAL(20,2),
    profit_before_tax DECIMAL(20,2),
    tax_percentage DECIMAL(12,4),
    net_profit DECIMAL(20,2),
    eps DECIMAL(18,4),
    dividend_payout DECIMAL(12,4),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);


LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/profit_loss/profit_loss_clean.csv'
INTO TABLE profit_loss
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    year,
    @sales,
    @expenses,
    @operating_profit,
    @opm_percentage,
    @other_income,
    @interest,
    @depreciation,
    @profit_before_tax,
    @tax_percentage,
    @net_profit,
    @eps,
    @dividend_payout
)
SET
    sales = NULLIF(TRIM(@sales), ''),
    expenses = NULLIF(TRIM(@expenses), ''),
    operating_profit = NULLIF(TRIM(@operating_profit), ''),
    opm_percentage = NULLIF(TRIM(@opm_percentage), ''),
    other_income = NULLIF(TRIM(@other_income), ''),
    interest = NULLIF(TRIM(@interest), ''),
    depreciation = NULLIF(TRIM(@depreciation), ''),
    profit_before_tax = NULLIF(TRIM(@profit_before_tax), ''),
    tax_percentage = NULLIF(TRIM(@tax_percentage), ''),
    net_profit = NULLIF(TRIM(@net_profit), ''),
    eps = NULLIF(TRIM(@eps), ''),
    dividend_payout = NULLIF(TRIM(@dividend_payout), '');
    
    
    SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM profit_loss;

SELECT COUNT(*) AS unmatched
FROM profit_loss p
LEFT JOIN companies c
    ON p.company_id = c.id
WHERE c.id IS NULL;


USE financial_analytics;

CREATE TABLE pros_cons (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    pros TEXT,
    cons TEXT,
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

TRUNCATE TABLE pros_cons;

LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/pros_cons/pros_cons_clean.csv'
INTO TABLE pros_cons
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    @pros,
    @cons
)
SET
    pros = NULLIF(TRIM(@pros), ''),
    cons = NULLIF(TRIM(@cons), '');
    
    
    SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM pros_cons;

SELECT * FROM pros_cons;


USE financial_analytics;

CREATE TABLE peer_groups (
    id INT NOT NULL PRIMARY KEY,
    peer_group_name VARCHAR(100) NOT NULL,
    company_id VARCHAR(30) NOT NULL,
    is_benchmark TINYINT(1) NOT NULL,
    FOREIGN KEY (company_id) REFERENCES companies(id)
);


LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/peer_groups/peer_groups_clean.csv'
INTO TABLE peer_groups
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    peer_group_name,
    company_id,
    @is_benchmark
)
SET
    is_benchmark = CASE
        WHEN LOWER(TRIM(@is_benchmark)) = 'true' THEN 1
        WHEN LOWER(TRIM(@is_benchmark)) = 'false' THEN 0
        ELSE NULL
    END;
    
    
    SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM peer_groups;

SELECT COUNT(*) AS unmatched
FROM peer_groups p
LEFT JOIN companies c
    ON p.company_id = c.id
WHERE c.id IS NULL;

USE financial_analytics;

CREATE TABLE stock_prices (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    date DATE NOT NULL,
    open_price DECIMAL(18,2),
    high_price DECIMAL(18,2),
    low_price DECIMAL(18,2),
    close_price DECIMAL(18,2),
    volume BIGINT,
    adjusted_close DECIMAL(18,2),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/stock_prices/stock_prices_clean.csv'
INTO TABLE stock_prices
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    @date,
    open_price,
    high_price,
    low_price,
    close_price,
    volume,
    adjusted_close
)
SET
    date = STR_TO_DATE(@date, '%Y-%m-%d');
    
    SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM stock_prices;

SELECT COUNT(*) AS unmatched
FROM stock_prices s
LEFT JOIN companies c
    ON s.company_id = c.id
WHERE c.id IS NULL;

USE financial_analytics;

CREATE TABLE sectors (
    id INT NOT NULL PRIMARY KEY,
    company_id VARCHAR(30) NOT NULL,
    broad_sector VARCHAR(100) NOT NULL,
    sub_sector VARCHAR(100) NOT NULL,
    index_weight_pct DECIMAL(10,4) NOT NULL,
    market_cap_category VARCHAR(30) NOT NULL,
    FOREIGN KEY (company_id) REFERENCES companies(id)
);


LOAD DATA LOCAL INFILE
'C:/Users/KIIT/OneDrive/Desktop/Financial Analytics Project/Cleaned Data/sectors/sectors_clean.csv'
INTO TABLE sectors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    company_id,
    broad_sector,
    sub_sector,
    index_weight_pct,
    market_cap_category
);


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(DISTINCT company_id) AS unique_companies
FROM sectors;

SELECT COUNT(*) AS unmatched
FROM sectors s
LEFT JOIN companies c
    ON s.company_id = c.id
WHERE c.id IS NULL;

SELECT
    COUNT(*) AS duplicate_ids
FROM (
    SELECT id
    FROM stock_prices
    GROUP BY id
    HAVING COUNT(*) > 1
) x;
