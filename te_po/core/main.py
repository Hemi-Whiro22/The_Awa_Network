import os
import locale
import uvicorn
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware

# --- Environment / UTF-8 Setup ---
from .env_loader import load_env, enforce_utf8_locale
from .config import get_settings

# --- Logging / Validation / Trace ---
from te_po.utils.logger import log_info, log_warn, log_error
from te_po.utils.env_validator import validate_environment
from te_po.utils.mana_trace import trace_event, write_mana_trace


# --- Optional: Packwatch Handler ---
try:
    from te_po.services.carver.main import handle_packwatch
    PACKWATCH_AVAILABLE = True
except Exception:
    PACKWATCH_AVAILABLE = False

# --- Routers ---
from te_po.routes import ocr, translate, embed, memory, iwi_portal
from te_po.routes.tiwhanawhana import intake, mauri

# ============================================================
# 1. LOCALE + ENVIRONMENT BOOTSTRAP (EARLIEST POSSIBLE STEP)
# ============================================================

try:
    locale.setlocale(locale.LC_ALL, "mi_NZ.UTF-8")
except locale.Error:
    locale.setlocale(locale.LC_ALL, "en_US.UTF-8")

os.environ["LANG"] = "mi_NZ.UTF-8"
os.environ["LC_ALL"] = "mi_NZ.UTF-8"

enforce_utf8_locale()
load_env()

settings = get_settings()

# ============================================================
# 2. FASTAPI APP DEFINITION
# ============================================================

app = FastAPI(
    title="Tiwhanawhana",
    description="Awakened backend of Kitenga / AwaNet",
    version="0.4.0",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================================
# 3. ROUTERS
# ============================================================

app.include_router(ocr.router, prefix="/ocr")
app.include_router(translate.router, prefix="/translate")
app.include_router(embed.router, prefix="/embed")
app.include_router(memory.router, prefix="/memory")
app.include_router(mauri.router, prefix="/mauri")
app.include_router(intake.router, prefix="/intake")
app.include_router(iwi_portal.router, prefix="/iwi")

# ============================================================
# 4. KITENGA / PACKWATCH HOOK
# ============================================================


@app.post("/kitenga/hook")
async def kitenga_hook(request: Request):
    """Sandboxed endpoint for Packwatch + MCP signals from Kitenga."""
    if not PACKWATCH_AVAILABLE:
        log_warn("Packwatch not available – hook ignored.")
        return {"status": "disabled"}

    try:
        payload = await request.json()
        trace_event("kitenga_hook_received", payload)
        response = await handle_packwatch(payload)
        return {"status": "ok", "response": response}
    except Exception as e:
        log_error(f"Kitenga hook error: {e}")
        return {"status": "error", "detail": str(e)}

# ============================================================
# 5. HEALTH ENDPOINTS
# ============================================================


@app.get("/")
async def root():
    return {"tiwhanawhana": "awake", "version": "0.4.0"}


@app.get("/health")
async def health():
    return {"alive": True}


@app.get("/env/health")
async def env_health():
    try:
        validate_environment()
        return {"status": "ok"}
    except Exception as e:
        return {"status": "error", "detail": str(e)}

# ============================================================
# 6. STARTUP EVENTS
# ============================================================


@app.on_event("startup")
async def on_startup():
    log_info("Tiwhanawhana starting up…")

    try:
        validate_environment()
        log_info("Environment validated ✓")
    except Exception as e:
        log_warn(f"Environment issue: {e}")

    trace_event("startup", {"message": "Tiwhanawhana online"})

    # Optional: Full whakapapa stamp
    # write_mana_trace(agent_name="Tiwhanawhana")


# ============================================================
# 7. LOCAL DEV ENTRYPOINT
# ============================================================

if __name__ == "__main__":
    uvicorn.run(
        "te_po.core.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
    )
