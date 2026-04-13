import json
import base64
import os
import uvicorn
from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from google import genai 
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

client = genai.Client()

SYSTEM_PROMPT = """You are an expert resume reviewer and ATS (Applicant Tracking System) specialist.

When given a resume, analyze it and return ONLY a valid JSON object with no additional text, markdown, or code blocks.

Structure:
{
  "score": <integer 0-100>,
  "suggestions": ["<specific fix 1>", "<specific fix 2>", "<specific fix 3>"],
  "keywords_found": ["<keyword1>", "<keyword2>", "..."],
  "keywords_missing": ["<keyword1>", "<keyword2>", "..."]
}
"""

@app.post('/resume-review')
async def resume_review(file: UploadFile = File(...)):
    try: 
        pdf_bytes = await file.read()
        pdf_b64 = base64.b64encode(pdf_bytes).decode("utf-8")

        response = client.models.generate_content(
            model='gemini-2.5-flash',
            contents = [
                {
                    "parts": [
                        {"inline_data": {"mime_type": "application/pdf", "data": pdf_b64}},
                        {"text": "Please review this resume and provide ATS and resume improvements."}
                    ]
                }
            ],
            config={"system_instruction": SYSTEM_PROMPT}
        )
        
        raw = response.text.strip()
        
        if raw.startswith("```"):
            raw = raw.split("```")[1]
            if raw.startswith("json"):
                raw = raw[4:]
            raw = raw.strip()

        result = json.loads(raw)

        required = {"score", "suggestions", "keywords_found", "keywords_missing"}
        if not required.issubset(result.keys()):
            raise ValueError(f"Missing keys in AI response: {result.keys()}")
        
        return result

    except Exception as e:
        print(f"Error occurred: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)