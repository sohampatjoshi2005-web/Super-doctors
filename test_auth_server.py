"""
Minimal standalone server for testing login/auth ONLY.

This bypasses app/main.py's full router set (which pulls in langchain,
boto3, faster-whisper, etc.) and loads just the auth router, which only
needs fastapi, sqlmodel, bcrypt, and python-jose. Use this when you want
to verify login works without installing the full requirements.txt.

Run:
    pip install -r requirements-auth-test.txt
    python test_auth_server.py

Then test:
    curl -X POST http://localhost:8000/v1/auth/login \\
      -H "Content-Type: application/json" \\
      -d '{"username":"admin","email":"admin@superhumanly.ai","password":"admin123"}'

Uses the same SQLite file (doctor_support.db) and the same seed_initial_admin()
logic as the real app, so the default admin account (see app/core/config.py
INITIAL_ADMIN_* settings) will be created automatically on first run.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.auth import router as auth_router, seed_initial_admin
from app.db import init_db

app = FastAPI(title="Auth-only test server")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router, prefix="/v1")


@app.on_event("startup")
async def startup():
    init_db()
    await seed_initial_admin()


@app.get("/health")
def health():
    return {"status": "ok", "mode": "auth-only"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
