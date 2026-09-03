from fastapi import FastAPI
from pydantic import BaseModel

from llm import ai_tool_analyst


app = FastAPI(
    title="AI Powered Financial Analytics API",
    description="AI-powered financial analysis using Gemini, MySQL, and analytical tools.",
    version="1.0.0"
)


class AskRequest(BaseModel):
    question: str


@app.get("/")
def root():
    return {
        "message": "AI Powered Financial Analytics API is running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.post("/ask")
def ask(request: AskRequest):
    result = ai_tool_analyst(request.question)

    return result