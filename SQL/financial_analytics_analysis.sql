USE financial_analytics;

WITH latest_kpi AS (
    SELECT k.*
    FROM financial_kpis k
    INNER JOIN (
        SELECT company_id, MAX(year) AS latest_year
        FROM financial_kpis
        GROUP BY company_id
    ) x
        ON k.company_id = x.company_id
       AND k.year = x.latest_year
),

latest_valuation AS (
    SELECT v.*
    FROM valuation v
    INNER JOIN (
        SELECT company_id, MAX(year) AS latest_year
        FROM valuation
        GROUP BY company_id
    ) x
        ON v.company_id = x.company_id
       AND v.year = x.latest_year
)

SELECT
    c.id AS company_id,
    c.company_name,
    s.broad_sector,
    s.sub_sector,
    v.market_cap_crore,
    v.pe_ratio,
    v.pb_ratio,
    k.return_on_equity_pct,
    k.net_profit_margin_pct,
    k.debt_to_equity
FROM companies c
LEFT JOIN sectors s
    ON c.id = s.company_id
LEFT JOIN latest_valuation v
    ON c.id = v.company_id
LEFT JOIN latest_kpi k
    ON c.id = k.company_id
ORDER BY v.market_cap_crore DESC;


CREATE VIEW company_latest_summary AS

WITH latest_kpi AS (
    SELECT k.*
    FROM financial_kpis k
    INNER JOIN (
        SELECT company_id, MAX(year) AS latest_year
        FROM financial_kpis
        GROUP BY company_id
    ) x
        ON k.company_id = x.company_id
       AND k.year = x.latest_year
),

latest_valuation AS (
    SELECT v.*
    FROM valuation v
    INNER JOIN (
        SELECT company_id, MAX(year) AS latest_year
        FROM valuation
        GROUP BY company_id
    ) x
        ON v.company_id = x.company_id
       AND v.year = x.latest_year
)

SELECT
    c.id AS company_id,
    c.company_name,
    s.broad_sector,
    s.sub_sector,
    v.market_cap_crore,
    v.pe_ratio,
    v.pb_ratio,
    k.return_on_equity_pct,
    k.net_profit_margin_pct,
    k.debt_to_equity
FROM companies c
LEFT JOIN sectors s
    ON c.id = s.company_id
LEFT JOIN latest_valuation v
    ON c.id = v.company_id
LEFT JOIN latest_kpi k
    ON c.id = k.company_id;
    
    SELECT *
FROM company_latest_summary
LIMIT 20;

CREATE OR REPLACE VIEW company_latest_summary AS

WITH latest_kpi AS (
    SELECT k.*
    FROM financial_kpis k
    INNER JOIN (
        SELECT company_id, MAX(year) AS latest_year
        FROM financial_kpis
        GROUP BY company_id
    ) x
        ON k.company_id = x.company_id
       AND k.year = x.latest_year
),

latest_valuation AS (
    SELECT v.*
    FROM valuation v
    INNER JOIN (
        SELECT company_id, MAX(year) AS latest_year
        FROM valuation
        GROUP BY company_id
    ) x
        ON v.company_id = x.company_id
       AND v.year = x.latest_year
)

SELECT
    c.id AS company_id,
    c.company_name,
    s.broad_sector,
    s.sub_sector,
    v.market_cap_crore,
    v.pe_ratio,
    v.pb_ratio,
    k.return_on_equity_pct,
    k.net_profit_margin_pct,
    k.operating_profit_margin_pct,
    k.debt_to_equity
FROM companies c
LEFT JOIN sectors s
    ON c.id = s.company_id
LEFT JOIN latest_valuation v
    ON c.id = v.company_id
LEFT JOIN latest_kpi k
    ON c.id = k.company_id;
    
    
    CREATE VIEW company_profitability AS
SELECT
    company_id,
    company_name,
    broad_sector,
    sub_sector,
    return_on_equity_pct,
    net_profit_margin_pct,
    operating_profit_margin_pct
FROM company_latest_summary
WHERE return_on_equity_pct IS NOT NULL
   OR net_profit_margin_pct IS NOT NULL
   OR operating_profit_margin_pct IS NOT NULL;
   
   SELECT *
FROM company_profitability
ORDER BY return_on_equity_pct DESC
LIMIT 10;

CREATE VIEW company_valuation AS
SELECT
    company_id,
    company_name,
    broad_sector,
    sub_sector,
    market_cap_crore,
    pe_ratio,
    pb_ratio
FROM company_latest_summary
WHERE market_cap_crore IS NOT NULL
   OR pe_ratio IS NOT NULL
   OR pb_ratio IS NOT NULL;
   
   
   SELECT *
FROM company_valuation
ORDER BY pe_ratio ASC
LIMIT 10;


CREATE VIEW company_stock_performance AS
WITH price_range AS (
    SELECT
        company_id,
        MIN(date) AS start_date,
        MAX(date) AS end_date
    FROM stock_prices
    GROUP BY company_id
),

start_prices AS (
    SELECT
        sp.company_id,
        sp.close_price AS start_price
    FROM stock_prices sp
    INNER JOIN price_range r
        ON sp.company_id = r.company_id
       AND sp.date = r.start_date
),

latest_prices AS (
    SELECT
        sp.company_id,
        sp.close_price AS latest_price
    FROM stock_prices sp
    INNER JOIN price_range r
        ON sp.company_id = r.company_id
       AND sp.date = r.end_date
)

SELECT
    c.id AS company_id,
    c.company_name,
    r.start_date,
    r.end_date,
    s.start_price,
    l.latest_price,
    ROUND(l.latest_price - s.start_price, 2) AS price_change,
    ROUND(
        ((l.latest_price - s.start_price) / NULLIF(s.start_price, 0)) * 100,
        2
    ) AS return_pct
FROM price_range r
JOIN companies c
    ON c.id = r.company_id
JOIN start_prices s
    ON s.company_id = r.company_id
JOIN latest_prices l
    ON l.company_id = r.company_id;
    
    
    SELECT *
FROM company_stock_performance
ORDER BY return_pct DESC
LIMIT 10;


CREATE VIEW company_cashflow AS
WITH latest_cashflow AS (
    SELECT cf.*
    FROM cash_flow cf
    INNER JOIN (
        SELECT company_id, MAX(year) AS latest_year
        FROM cash_flow
        GROUP BY company_id
    ) x
        ON cf.company_id = x.company_id
       AND cf.year = x.latest_year
)
SELECT
    c.id AS company_id,
    c.company_name,
    cf.year,
    cf.operating_activity,
    cf.investing_activity,
    cf.financing_activity,
    cf.net_cash_flow,
    cf.free_cash_flow
FROM latest_cashflow cf
JOIN companies c
    ON c.id = cf.company_id;
    
    
    SELECT *
FROM company_cashflow
ORDER BY free_cash_flow DESC
LIMIT 10;

CREATE VIEW sector_performance AS
SELECT
    broad_sector,
    COUNT(*) AS company_count,
    ROUND(AVG(market_cap_crore), 2) AS avg_market_cap_crore,
    ROUND(AVG(return_on_equity_pct), 2) AS avg_roe_pct,
    ROUND(AVG(net_profit_margin_pct), 2) AS avg_net_profit_margin_pct,
    ROUND(AVG(pe_ratio), 2) AS avg_pe_ratio,
    ROUND(AVG(pb_ratio), 2) AS avg_pb_ratio
FROM company_latest_summary
WHERE broad_sector IS NOT NULL
GROUP BY broad_sector;


SELECT *
FROM sector_performance
ORDER BY avg_market_cap_crore DESC;


CREATE VIEW company_financial_ranking AS
SELECT
    company_id,
    company_name,
    broad_sector,
    return_on_equity_pct,
    net_profit_margin_pct,
    debt_to_equity,
    pe_ratio,

    ROUND(
        COALESCE(return_on_equity_pct, 0) * 0.35
        + COALESCE(net_profit_margin_pct, 0) * 0.30
        - COALESCE(debt_to_equity, 0) * 0.15
        - COALESCE(pe_ratio, 0) * 0.20,
        2
    ) AS financial_score

FROM company_latest_summary;


SELECT *
FROM company_financial_ranking
ORDER BY financial_score DESC
LIMIT 10;


CREATE VIEW company_investment_overview AS
SELECT
    f.company_id,
    f.company_name,
    f.broad_sector,
    f.return_on_equity_pct,
    f.net_profit_margin_pct,
    f.debt_to_equity,
    f.pe_ratio,
    s.start_date,
    s.end_date,
    s.start_price,
    s.latest_price,
    s.return_pct
FROM company_latest_summary f
LEFT JOIN company_stock_performance s
    ON f.company_id = s.company_id;
    
    
    SELECT *
FROM company_investment_overview
ORDER BY return_pct DESC
LIMIT 15;


CREATE VIEW company_growth AS
WITH yearly AS (
    SELECT
        company_id,
        year,
        sales,
        net_profit,
        LAG(sales) OVER (
            PARTITION BY company_id
            ORDER BY year
        ) AS previous_sales,
        LAG(net_profit) OVER (
            PARTITION BY company_id
            ORDER BY year
        ) AS previous_net_profit
    FROM profit_loss
)

SELECT
    company_id,
    year,
    sales,
    net_profit,

    ROUND(
        ((sales - previous_sales) / NULLIF(previous_sales, 0)) * 100,
        2
    ) AS sales_growth_pct,

    ROUND(
        ((net_profit - previous_net_profit) / NULLIF(previous_net_profit, 0)) * 100,
        2
    ) AS net_profit_growth_pct

FROM yearly;


SELECT *
FROM company_growth
WHERE sales_growth_pct IS NOT NULL
ORDER BY sales_growth_pct DESC
LIMIT 10;

SELECT
    company_id,
    company_name,
    broad_sector,
    return_on_equity_pct,
    net_profit_margin_pct,
    pe_ratio,
    debt_to_equity,
    return_pct
FROM company_investment_overview
WHERE return_on_equity_pct > 15
  AND net_profit_margin_pct > 10
  AND pe_ratio < 30
  AND debt_to_equity < 2
  AND return_pct > 50
ORDER BY return_pct DESC;


DESCRIBE company_investment_overview;

CREATE VIEW company_master_profile AS
SELECT
    company_id,
    company_name,
    broad_sector,
    return_on_equity_pct,
    net_profit_margin_pct,
    debt_to_equity,
    pe_ratio,
    start_date,
    end_date,
    start_price,
    latest_price,
    return_pct
FROM company_investment_overview;

SELECT *
FROM company_master_profile
LIMIT 10;