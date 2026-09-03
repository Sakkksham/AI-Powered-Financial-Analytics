from database import run_query
from sql_validator import validate_sql


def get_company_profile(company_name):
    sql = f"""
        SELECT *
        FROM company_master_profile
        WHERE company_name = '{company_name}'
           OR company_id = '{company_name.upper()}'
    """
    return run_query(sql)


def compare_companies(company1, company2):
    sql = f"""
        SELECT
            company_id,
            company_name,
            broad_sector,
            return_on_equity_pct,
            net_profit_margin_pct,
            debt_to_equity,
            pe_ratio,
            start_price,
            latest_price,
            return_pct
        FROM company_master_profile
        WHERE company_id IN ('{company1.upper()}', '{company2.upper()}')
    """
    return run_query(sql)


def get_sector_analysis():
    sql = """
        SELECT *
        FROM sector_performance
        ORDER BY avg_market_cap_crore DESC
    """
    return run_query(sql)


def get_valuation():
    sql = """
        SELECT *
        FROM company_valuation
        ORDER BY pe_ratio ASC
    """
    return run_query(sql)


def get_stock_performance():
    sql = """
        SELECT *
        FROM company_stock_performance
        ORDER BY return_pct DESC
    """
    return run_query(sql)


def run_readonly_sql(sql):
    is_safe, message = validate_sql(sql)

    if not is_safe:
        raise ValueError(message)

    return run_query(sql)


TOOLS = {
    "get_company_profile": get_company_profile,
    "compare_companies": compare_companies,
    "get_sector_analysis": get_sector_analysis,
    "get_valuation": get_valuation,
    "get_stock_performance": get_stock_performance,
    "run_readonly_sql": run_readonly_sql
}


def execute_tool(tool_name, arguments=None):
    if tool_name not in TOOLS:
        raise ValueError(f"Unknown tool: {tool_name}")

    if arguments is None:
        arguments = {}

    return TOOLS[tool_name](**arguments)