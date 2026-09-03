# 📊 AI Powered Financial Analytics

An end-to-end financial analytics project that combines **MySQL, Python, Power BI, Generative AI, FastAPI, and Streamlit** to analyze company financial performance, valuation, growth, stock performance, sectors, and cash flow.

The project also includes an **AI Financial Analyst** that can understand natural-language financial questions, retrieve relevant data from MySQL through analytical tools, and generate data-driven responses using Gemini.

---

## 🚀 Project Overview

The goal of this project is to build a complete financial analytics workflow starting from raw financial datasets and ending with:

- Clean and structured financial data
- MySQL-based analytical data storage
- SQL analytical views
- Python-based analysis
- Interactive Power BI dashboards
- AI-powered financial analysis
- Tool/function calling
- FastAPI backend
- Streamlit user interface

The project demonstrates how traditional data analytics and Business Intelligence can be enhanced with Generative AI.

---

# 🏗️ Project Architecture

```text
Raw Financial Data
        │
        ▼
Data Cleaning & Preparation
        │
        ▼
Cleaned CSV Datasets
        │
        ▼
MySQL Database
        │
        ├──────────────► SQL Analytical Views
        │
        ▼
Python Analytics Layer
        │
        ├──────────────► Power BI Dashboard
        │
        └──────────────► AI Financial Analyst
                                  │
                                  ▼
                            Gemini LLM
                                  │
                                  ▼
                         Tool / Function Calling
                                  │
                                  ▼
                              MySQL
                                  │
                                  ▼
                         Analytical Response
                                  │
                                  ▼
                           Streamlit UI
                                  │
                                  ▼
                            FastAPI Backend

📂 Project Structure
AI-Powered-Financial-Analytics/
│
├── AI Analyst/
│   └── app.py
│
├── Cleaned Data/
│   ├── balance_sheet_clean.csv
│   ├── cash_flow_clean.csv
│   ├── companies_clean.csv
│   ├── documents_clean.csv
│   ├── financial_kpis_clean.csv
│   ├── market_cap_clean.csv
│   ├── peer_groups_clean.csv
│   ├── profit_loss_clean.csv
│   ├── pros_cons_clean.csv
│   ├── sector_mapping_clean.csv
│   ├── sectors_clean.csv
│   ├── stock_prices_clean.csv
│   └── valuation_clean.csv
│
├── DOCUMENTATION/
│
├── IMAGES/
│   ├── ai_tool_calling.png
│   ├── company_analysis_dashboard.png
│   ├── company_comparison_dashboard.png
│   ├── executive_dashboard.png
│   ├── fastapi_backend.png
│   ├── frontend_ui.png
│   ├── growth_stock_performance_cash_flow_dashboard.png
│   └── sector_market_analysis_dashboard.png
│
├── PowerBI/
│   └── Financial Analytics Dashboard.pbix
│
├── Python/
│   ├── notebooks/
│   │   └── 11_Python_MySQL_LLM.ipynb
│   │
│   └── backend/
│       ├── database.py
│       ├── llm.py
│       ├── main.py
│       ├── sql_validator.py
│       ├── tools.py
│       ├── test_tools.py
│       └── requirements.txt
│
├── Raw Data/
│
├── SQL/
│
├── .gitignore
└── Readme.md
🗄️ Data & Database

The project uses multiple financial datasets covering company fundamentals, valuation, stock prices, sectors, peer groups, and cash flows.

Main datasets
Company information
Balance sheet
Profit & loss
Cash flow
Financial KPIs
Valuation metrics
Stock prices
Market capitalization
Sector classification
Sector mapping
Peer groups
Annual reports
Pros and cons

The data was cleaned and structured before being loaded into MySQL.

🧹 Data Preparation

The data preparation process includes:

Removing unnecessary title/header rows
Standardizing column names
Handling missing values
Checking duplicate records
Validating company identifiers
Standardizing financial metrics
Preparing datasets for MySQL
Creating analytical views for reporting

The cleaned datasets are stored inside the Cleaned Data directory.

🐬 MySQL Analytics

MySQL is used as the central analytical database.

The project includes analytical views such as:

company_latest_summary

Provides the latest company-level financial and valuation metrics.

company_profitability

Used to analyze:

ROE
Net Profit Margin
Operating Profit Margin
company_valuation

Used for valuation analysis including:

P/E Ratio
P/B Ratio
EV/EBITDA
Dividend Yield
company_stock_performance

Used to analyze historical stock price performance and returns.

sector_performance

Provides sector-level:

Company count
Market capitalization
Average ROE
Average Net Profit Margin
Average P/E
Average P/B
company_financial_ranking

Provides a project-defined financial ranking based on selected profitability, leverage, and valuation metrics.

company_investment_overview

Combines company fundamentals with stock performance.

company_growth

Provides historical revenue and net-profit growth analysis.

company_cashflow

Provides company-level cash-flow information.

company_master_profile

Combines important company-level financial and market metrics into a single analytical profile.

📊 Power BI Dashboard

The Power BI dashboard contains 5 analytical pages designed to provide different levels of financial analysis.

1. Executive Overview

Provides a high-level snapshot of the financial dataset and overall market.

Key elements include:

Total Companies
Total Sectors
Average ROE
Median P/E
Company Distribution by Sector
Sector Valuation vs Profitability
Top Companies by ROE
Top Stock Price Performers
Company Financial Snapshot

2. Company Analysis

Provides a detailed view of an individual company.

Key elements include:

Company selector
Stock Price Trend
Revenue Trend
Net Profit Growth Trend
Company Financial Details

Metrics include:

ROE
Net Profit Margin
Debt-to-Equity
P/E
Starting Price
Latest Price
Stock Return

3. Company Comparison

Allows users to compare two companies across financial and market metrics.

The page includes:

Company selectors
Revenue comparison
Stock return comparison
Valuation vs profitability
Debt-to-equity comparison
Detailed company comparison

This page uses disconnected selector tables and DAX measures to dynamically compare the selected companies.

4. Sector & Market Analysis

Provides sector-level analysis of the financial dataset.

Key elements include:

Sector selector
Company distribution by sector
Average Net Profit Margin by sector
Market capitalization across sectors
Sector valuation vs profitability
Price-to-book analysis
Sector performance details

5. Growth, Stock Performance & Cash Flow

Focuses on business growth, stock performance, and cash-flow activity.

Key elements include:

Top 10 Stock Returns
Net Profit Growth Trend
Revenue Trend
Cash Flow Activity
Stock Price Trend
Company selector

🤖 AI Financial Analyst

The project includes an AI-powered financial analyst that allows users to ask financial questions using natural language.

Examples:

What is the financial profile of TCS?

Compare TCS and Infosys.

Which companies have the highest stock returns?

Show sector performance.

Which companies have lower P/E ratios?

What is the ROE and net profit margin of Infosys?

Show the stock performance of SBI.

The AI retrieves relevant information from the MySQL database through analytical tools instead of relying only on the language model's internal knowledge.

🧠 AI Tool Calling

The AI analyst uses Gemini with a custom tool/function-calling layer.

Available analytical tools include:

get_company_profile
compare_companies
get_sector_analysis
get_valuation
get_stock_performance
run_readonly_sql

The workflow is:

User Question
      │
      ▼
Gemini LLM
      │
      ▼
Select Analytical Tool
      │
      ▼
Execute Tool
      │
      ▼
MySQL Query
      │
      ▼
Retrieve Data
      │
      ▼
Return Tool Result
      │
      ▼
Gemini Generates Response

🖥️ Streamlit Frontend

The Streamlit interface provides a simple user-facing interface for interacting with the AI Financial Analyst.

Users can enter natural-language financial questions and receive analytical responses.

⚡ FastAPI Backend

FastAPI provides the backend API layer connecting the frontend with the AI analyst.

Available endpoints
GET /
GET /health
POST /ask
Example request
{
  "question": "Compare TCS and Infosys"
}

The backend processes the request through the AI analyst and returns the generated financial analysis.

🔐 SQL Safety

The AI analyst includes a SQL validation layer to ensure that generated SQL is read-only.

Only:

SELECT
WITH

queries are allowed.

The validator blocks operations such as:

INSERT
UPDATE
DELETE
DROP
ALTER
TRUNCATE
CREATE
RENAME
GRANT
REVOKE

This helps prevent the AI layer from modifying the underlying financial database.

🐍 Python Analytics Layer

Python is used for:

Data exploration
Data validation
MySQL connectivity
Analytical queries
Tool execution
LLM integration
Financial analysis

The main analytical notebook is:

Python/notebooks/11_Python_MySQL_LLM.ipynb
📈 Key Financial Metrics

The project analyzes several financial and market metrics.

Profitability
Return on Equity (ROE)
Net Profit Margin
Operating Profit Margin
Leverage
Debt-to-Equity
Interest Coverage
Valuation
P/E Ratio
P/B Ratio
EV/EBITDA
Dividend Yield
Growth
Revenue Growth
Net Profit Growth
Market Performance
Stock Price
Historical Return
Market Capitalization
Cash Flow
Cash from Operations
Investing Activity
Financing Activity
Free Cash Flow
Capital Expenditure
🛠️ Technology Stack
Technology	Purpose
Python	Data analysis and backend logic
Pandas	Data processing
MySQL	Financial data storage and analytics
SQL	Data querying and analytical views
Power BI	Interactive dashboards
Gemini	Generative AI
Google GenAI SDK	Gemini integration
FastAPI	Backend API
Streamlit	AI analyst frontend
Git & GitHub	Version control and project hosting
🔄 End-to-End Workflow
Raw Data
   ↓
Data Cleaning
   ↓
Cleaned CSV Files
   ↓
MySQL Database
   ↓
SQL Analytical Views
   ↓
Python Analytics
   ↓
Power BI Dashboard
   │
   └──────────────► AI Financial Analyst
                           ↓
                      Gemini LLM
                           ↓
                     Tool Calling
                           ↓
                         MySQL
                           ↓
                    Financial Answer
▶️ Running the Project
1. Clone the repository
git clone https://github.com/Sakkksham/AI-Powered-Financial-Analytics.git
cd AI-Powered-Financial-Analytics
2. Install Python dependencies
pip install -r Python/backend/requirements.txt
3. Configure environment variables

Create a .env file containing the required database and Gemini API configuration.

Example:

MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=your_password
MYSQL_DATABASE=financial_analytics
GEMINI_API_KEY=your_api_key

Do not commit API keys, passwords, or other credentials to GitHub.

4. Start FastAPI

Navigate to the backend directory:

cd Python/backend

Run:

python -m uvicorn main:app --reload

The API will be available at:

http://127.0.0.1:8000

FastAPI documentation:

http://127.0.0.1:8000/docs
5. Run Streamlit

From the project environment:

streamlit run "AI Analyst/app.py"

The Streamlit interface can then be used to interact with the AI Financial Analyst.

🎯 Project Objectives

The main objectives of this project are to:

Build an end-to-end financial analytics solution
Practice financial data cleaning and preparation
Develop SQL-based analytical workflows
Build interactive Power BI dashboards
Integrate Generative AI with structured financial data
Implement tool/function calling
Build a read-only AI-to-SQL workflow
Develop a FastAPI backend
Build a Streamlit AI application
Demonstrate how AI can enhance traditional analytics
💡 What This Project Demonstrates

This project demonstrates practical skills in:

Data Analytics
Business Intelligence
SQL
MySQL
Python
Pandas
Power BI
Financial Analytics
Generative AI
LLM Tool Calling
API Development
Streamlit
FastAPI
Data Visualization
Git & GitHub
⚠️ Disclaimer

This project is intended for educational, analytical, and portfolio purposes.

The financial analysis is based on the datasets available within the project and should not be considered investment advice.

Historical stock performance does not guarantee future results.

👨‍💻 Author
Saksham Deo

B.Tech Computer Science Engineering — 2026

Interested in:

Data Analytics
Business Intelligence
SQL
Python
Generative AI
AI-powered Analytics
Data Applications