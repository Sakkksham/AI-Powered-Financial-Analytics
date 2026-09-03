SELECT 'balance_sheet' AS table_name, COUNT(*) AS unmatched
FROM balance_sheet b
LEFT JOIN companies c ON b.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'cash_flow', COUNT(*)
FROM cash_flow cf
LEFT JOIN companies c ON cf.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'documents', COUNT(*)
FROM documents d
LEFT JOIN companies c ON d.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'financial_kpis', COUNT(*)
FROM financial_kpis f
LEFT JOIN companies c ON f.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'nifty100_analysis', COUNT(*)
FROM nifty100_analysis n
LEFT JOIN companies c ON n.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'peer_groups', COUNT(*)
FROM peer_groups p
LEFT JOIN companies c ON p.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'profit_loss', COUNT(*)
FROM profit_loss p
LEFT JOIN companies c ON p.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'pros_cons', COUNT(*)
FROM pros_cons p
LEFT JOIN companies c ON p.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'sectors', COUNT(*)
FROM sectors s
LEFT JOIN companies c ON s.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'stock_prices', COUNT(*)
FROM stock_prices sp
LEFT JOIN companies c ON sp.company_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 'valuation', COUNT(*)
FROM valuation v
LEFT JOIN companies c ON v.company_id = c.id
WHERE c.id IS NULL;


SELECT
    company_id,
    year,
    COUNT(*) AS row_count
FROM cash_flow
GROUP BY company_id, year
HAVING COUNT(*) > 1
ORDER BY company_id, year;

SELECT
    id,
    company_id,
    year,
    operating_activity,
    investing_activity,
    financing_activity,
    net_cash_flow,
    free_cash_flow
FROM cash_flow
WHERE company_id = 'ABB'
ORDER BY year, id;



SELECT 'companies' AS table_name,
       COUNT(*) AS rows_count,
       COUNT(DISTINCT id) AS unique_ids,
       COUNT(DISTINCT id) AS unique_companies
FROM companies

UNION ALL

SELECT 'balance_sheet',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM balance_sheet

UNION ALL

SELECT 'cash_flow',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM cash_flow

UNION ALL

SELECT 'documents',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM documents

UNION ALL

SELECT 'financial_kpis',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM financial_kpis

UNION ALL

SELECT 'nifty100_analysis',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM nifty100_analysis

UNION ALL

SELECT 'peer_groups',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM peer_groups

UNION ALL

SELECT 'profit_loss',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM profit_loss

UNION ALL

SELECT 'pros_cons',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM pros_cons

UNION ALL

SELECT 'sector_mapping',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company)
FROM sector_mapping

UNION ALL

SELECT 'sectors',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM sectors

UNION ALL

SELECT 'stock_prices',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM stock_prices

UNION ALL

SELECT 'valuation',
       COUNT(*),
       COUNT(DISTINCT id),
       COUNT(DISTINCT company_id)
FROM valuation;