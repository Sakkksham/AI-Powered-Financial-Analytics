from tools import (
    get_company_profile,
    compare_companies,
    get_sector_analysis,
    get_valuation,
    get_stock_performance
)


print("Testing company profile...")
print(get_company_profile("TCS"))


print("\nTesting company comparison...")
print(compare_companies("TCS", "INFY"))


print("\nTesting sector analysis...")
print(get_sector_analysis().head())


print("\nTesting valuation...")
print(get_valuation().head())


print("\nTesting stock performance...")
print(get_stock_performance().head())