import streamlit as st
import requests
import pandas as pd


# --------------------------------------------------
# Page Configuration
# --------------------------------------------------

st.set_page_config(
    page_title="AI Powered Financial Analytics",
    page_icon="📊",
    layout="wide"
)


# --------------------------------------------------
# Title
# --------------------------------------------------

st.title("AI Powered Financial Analytics")

st.write(
    "Ask questions about company financials, valuation, "
    "sector performance, stock returns, and cash flow."
)


# --------------------------------------------------
# API Configuration
# --------------------------------------------------

API_URL = "http://127.0.0.1:8000/ask"


# --------------------------------------------------
# Example Questions
# --------------------------------------------------

st.subheader("Example Questions")

col1, col2, col3 = st.columns(3)

with col1:
    if st.button("Analyze TCS"):
        st.session_state.question = (
            "Give me the financial profile of TCS."
        )

with col2:
    if st.button("Compare TCS vs Infosys"):
        st.session_state.question = (
            "Compare TCS and Infosys."
        )

with col3:
    if st.button("Analyze IT sector"):
        st.session_state.question = (
            "Analyze the Information Technology sector."
        )


# --------------------------------------------------
# Question Input
# --------------------------------------------------

question = st.text_area(
    "Ask the AI Analyst",
    value=st.session_state.get("question", ""),
    placeholder=(
        "Example: Compare TCS and Infosys based on "
        "ROE, P/E and stock return."
    ),
    height=100
)


# --------------------------------------------------
# Ask AI
# --------------------------------------------------

if st.button("Ask AI", type="primary"):

    if not question.strip():

        st.warning("Please enter a question.")

    else:

        with st.spinner("Analyzing financial data..."):

            try:

                response = requests.post(
                    API_URL,
                    json={"question": question},
                    timeout=120
                )

                response.raise_for_status()

                result = response.json()


                # ----------------------------------
                # AI Insight
                # ----------------------------------

                st.subheader("AI Insight")

                st.write(
                    result.get(
                        "answer",
                        "No answer returned."
                    )
                )


                # ----------------------------------
                # Tool Used
                # ----------------------------------

                tool = result.get("tool")

                if tool:

                    st.caption(
                        f"Analytical tool used: `{tool}`"
                    )


                # ----------------------------------
                # Retrieved Data
                # ----------------------------------

                data = result.get("data")

                if data:

                    st.subheader("Retrieved Data")

                    df = pd.DataFrame(data)

                    st.dataframe(
                        df,
                        use_container_width=True,
                        hide_index=True
                    )


            except requests.exceptions.ConnectionError:

                st.error(
                    "Could not connect to the FastAPI backend. "
                    "Make sure the backend is running."
                )

            except requests.exceptions.Timeout:

                st.error(
                    "The request took too long. "
                    "Please try again."
                )

            except requests.exceptions.RequestException as e:

                st.error(
                    f"API request failed: {e}"
                )

            except Exception as e:

                st.error(
                    f"Unexpected error: {e}"
                )