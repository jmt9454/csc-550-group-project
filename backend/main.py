from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Monorepo API",
    description="FastAPI backend for Vue.js frontend",
    version="1.0.0",
)

origins = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"], 
)

@app.get("/", tags=["System"])
async def root():
    """
    Root endpoint to verify the backend is up and running.
    """
    return {"status": "ok", "message": "CSC 550 Group Project API is running!"}