import os
import json

from google import genai

from tools import (
    get_company_profile,
    compare_companies,
    get_sector_analysis,
    get_valuation,
    get_stock_performance,
    run_readonly_sql,
    execute_tool
)


# ==================================================
# Gemini Client
# ==================================================

api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    raise ValueError("GEMINI_API_KEY environment variable is not set.")

client = genai.Client(api_key=api_key)


# ==================================================
# System Prompt
# ==================================================

SYSTEM_PROMPT = """
You are an AI-powered financial data analyst.

You have access to a MySQL database named financial_analytics through
the available analytical tools.

Your job is to answer financial-data questions accurately using the
database.

CORE RULES:

1. Understand the user's question before selecting a tool.

2. Use the most appropriate available tool to retrieve the required
   information from the database.

3. Base factual claims and numerical values ONLY on the retrieved
   database results.

4. Never invent, assume, or fabricate financial data.

5. You may calculate simple derived values from retrieved data when
   necessary, but clearly explain what was calculated.

6. Clearly distinguish between:
   - Facts directly retrieved from the database
   - Calculations based on retrieved data
   - Reasonable interpretation of the retrieved data

7. Do not make unsupported claims about:
   - Market leadership
   - Future performance
   - Future stock prices
   - Investment attractiveness
   - Risk level
   - Company reputation
   - Competitive position

   unless the retrieved database data directly supports the claim.

8. Do not provide investment advice or recommendations unless the user
   explicitly asks for an opinion. Even then, clearly state that the
   analysis is based only on the available data.

9. If the data contains unusual, extreme, or potentially misleading
   values, report them accurately and mention that they are unusual.
   Do not silently modify or remove them.

10. If the requested information is not available in the database,
    clearly say that the available data does not contain enough
    information to answer the question.

11. Do not claim to have used a tool or database if you did not actually
    use it.

12. Keep answers concise but useful. Include the most relevant numbers
    and comparisons.

13. For company comparisons, explicitly identify which company performs
    better for each relevant metric rather than giving vague conclusions.

14. For financial ratios:
    - ROE and margins are percentages.
    - P/E and P/B are valuation multiples.
    - Debt-to-equity is a ratio.
    - Stock return is a percentage.

15. Do not confuse correlation with causation.

16. Do not infer causation or explain why a financial metric is higher
    or lower unless the retrieved data directly supports that explanation.
    Describe observed differences without attributing causes that are not
    present in the database.


AVAILABLE TOOLS:

- get_company_profile
  Get financial profile and stock performance for a specific company.

- compare_companies
  Compare two companies using financial and stock-performance metrics.

- get_sector_analysis
  Get financial performance metrics by sector.

- get_valuation
  Get company valuation metrics including P/E and P/B ratios.

- get_stock_performance
  Get historical stock performance and returns for companies.

- run_readonly_sql
  Run a read-only SELECT or WITH SQL query when the predefined tools
  cannot answer the question.

When a suitable predefined tool exists, prefer that tool over
run_readonly_sql.
"""


# ==================================================
# Gemini Tool Definitions
# ==================================================

gemini_tools = [

    # ------------------------------------------------
    # Company Profile
    # ------------------------------------------------

    {
        "type": "function",
        "name": "get_company_profile",
        "description": (
            "Get financial profile and stock performance "
            "for a specific company."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "company_name": {
                    "type": "string",
                    "description": (
                        "Company name or company ID, "
                        "such as TCS or INFY."
                    )
                }
            },
            "required": ["company_name"],
            "additionalProperties": False
        }
    },


    # ------------------------------------------------
    # Compare Companies
    # ------------------------------------------------

    {
        "type": "function",
        "name": "compare_companies",
        "description": (
            "Compare two companies using financial "
            "and stock performance metrics."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "company1": {
                    "type": "string",
                    "description": (
                        "First company ID, such as TCS."
                    )
                },
                "company2": {
                    "type": "string",
                    "description": (
                        "Second company ID, such as INFY."
                    )
                }
            },
            "required": ["company1", "company2"],
            "additionalProperties": False
        }
    },


    # ------------------------------------------------
    # Sector Analysis
    # ------------------------------------------------

    {
        "type": "function",
        "name": "get_sector_analysis",
        "description": (
            "Get financial performance metrics by sector. "
            "This tool requires no arguments."
        ),
        "parameters": {
            "type": "object",
            "properties": {},
            "additionalProperties": False
        }
    },


    # ------------------------------------------------
    # Valuation
    # ------------------------------------------------

    {
        "type": "function",
        "name": "get_valuation",
        "description": (
            "Get company valuation metrics including "
            "P/E and P/B ratios. This tool requires no arguments."
        ),
        "parameters": {
            "type": "object",
            "properties": {},
            "additionalProperties": False
        }
    },


    # ------------------------------------------------
    # Stock Performance
    # ------------------------------------------------

    {
        "type": "function",
        "name": "get_stock_performance",
        "description": (
            "Get historical stock performance and returns "
            "for companies. This tool requires no arguments."
        ),
        "parameters": {
            "type": "object",
            "properties": {},
            "additionalProperties": False
        }
    },


    # ------------------------------------------------
    # Read-Only SQL
    # ------------------------------------------------

    {
        "type": "function",
        "name": "run_readonly_sql",
        "description": (
            "Run a read-only SELECT or WITH SQL query when "
            "the other tools cannot answer the question."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "sql": {
                    "type": "string",
                    "description": (
                        "A read-only MySQL SELECT or WITH query."
                    )
                }
            },
            "required": ["sql"],
            "additionalProperties": False
        }
    }
]


# ==================================================
# Response Text Extraction
# ==================================================

def extract_response_text(response):
    """
    Extract final text from a Gemini Interaction response.

    Uses output_text when available and falls back
    to message steps.
    """

    if getattr(response, "output_text", None):
        return response.output_text

    texts = []

    for step in getattr(response, "steps", []):

        if getattr(step, "type", None) == "message":

            content = getattr(step, "content", None)

            if isinstance(content, str):
                texts.append(content)

            elif isinstance(content, list):

                for item in content:

                    text = getattr(item, "text", None)

                    if text:
                        texts.append(text)

                    elif (
                        isinstance(item, dict)
                        and item.get("text")
                    ):
                        texts.append(item["text"])

    return "\n".join(texts).strip()


# ==================================================
# AI Analyst
# ==================================================

def ai_tool_analyst(question):

    # ----------------------------------------------
    # First Gemini Call
    # ----------------------------------------------

    response = client.interactions.create(
        model="gemini-3.6-flash",
        system_instruction=SYSTEM_PROMPT,
        input=question,
        tools=gemini_tools
    )


    # ----------------------------------------------
    # Find Function Call
    # ----------------------------------------------

    function_call = next(
        (
            step
            for step in response.steps
            if step.type == "function_call"
        ),
        None
    )


    # ----------------------------------------------
    # Gemini Answered Without Using a Tool
    # ----------------------------------------------

    if function_call is None:

        return {
            "answer": extract_response_text(response),
            "tool": None,
            "data": None
        }


    # ----------------------------------------------
    # Execute Selected Tool
    # ----------------------------------------------

    tool_result = execute_tool(
        function_call.name,
        function_call.arguments
    )


    # ----------------------------------------------
    # Convert DataFrame to JSON-Compatible Records
    # ----------------------------------------------

    if hasattr(tool_result, "to_dict"):

        result_data = tool_result.to_dict(
            orient="records"
        )

    else:

        result_data = tool_result


    # ----------------------------------------------
    # Send Tool Result Back to Gemini
    # ----------------------------------------------

    final_response = client.interactions.create(
        model="gemini-3.6-flash",
        previous_interaction_id=response.id,
        input=[
            {
                "type": "function_result",
                "name": function_call.name,
                "call_id": function_call.id,
                "result": [
                    {
                        "type": "text",
                        "text": json.dumps(
                            result_data,
                            default=str
                        )
                    }
                ]
            }
        ]
    )


    # ----------------------------------------------
    # Return Final Response
    # ----------------------------------------------

    return {
        "answer": extract_response_text(final_response),
        "tool": function_call.name,
        "data": result_data
    }