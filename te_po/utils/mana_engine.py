import os
import json
import hashlib
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Any, Optional
from te_po.utils.env_validator import validate_environment
from te_po.utils.mana_engine import trace_event, mana_trace, mana_heartbeat
from te_po.utils.logger import log_info, log_warn, log_error

# Optional Supabase client
try:
    from supabase import create_client
except Exception:
    create_client = None


@app.on_event("startup")
async def on_startup():
    log_info("Tiwhanawhana starting up…")
    validate_environment()
    mana_heartbeat()

# ---------------------------------------------------------
# 1. RUNTIME TRACER (safe during FastAPI boot)
# ---------------------------------------------------------


def trace_event(event: str, meta: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """Lightweight runtime event tracer (no Supabase, no filesystem pressure)."""
    payload = {
        "event": event,
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "meta": meta or {},
    }
    log_info(f"mana.event :: {event}", payload["meta"])
    return payload


# ---------------------------------------------------------
# 2. GLYPH + SIGNATURE GENERATOR
# ---------------------------------------------------------
def _generate_signature(kaitiaki: str) -> str:
    timestamp = datetime.now(timezone.utc).isoformat()
    raw = f"{kaitiaki}_{timestamp}".encode()
    return hashlib.sha256(raw).hexdigest()[:12], timestamp


def _glyph() -> str:
    return "🌀"   # we can swap this to wolf glyph later if you want


# ---------------------------------------------------------
# 3. LOCAL FILE RECORDER
# ---------------------------------------------------------
def _write_local_trace(kaitiaki: str, trace: Dict[str, Any]) -> None:
    root = Path(f".mauri/{kaitiaki.lower()}")
    root.mkdir(parents=True, exist_ok=True)
    with open(root / "trace.json", "w", encoding="utf-8") as f:
        json.dump(trace, f, indent=2, ensure_ascii=False)
    log_info("mana.local :: trace.json updated", {"kaitiaki": kaitiaki})


# ---------------------------------------------------------
# 4. SUPABASE PUSH (optional)
# ---------------------------------------------------------
def _write_supabase(trace: Dict[str, Any]) -> None:
    url = os.getenv("DEN_URL")
    key = os.getenv("DEN_API_KEY")

    if not (url and key and create_client):
        log_warn("mana.supabase :: disabled or missing keys")
        return

    try:
        client = create_client(url, key)
        client.table("mana_trace").insert(trace).execute()
        log_info("mana.supabase :: uploaded ✓")
    except Exception as e:
        log_warn("mana.supabase :: upload failed", {"error": str(e)})


# ---------------------------------------------------------
# 5. THE MAIN ENGINE
# ---------------------------------------------------------
def mana_trace(event: str, meta: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """
    Full mana engine trace: glyph, signature, timestamp, local storage,
    optional Supabase lineage update.
    """
    kaitiaki = os.getenv("AGENT_NAME", "Tiwhanawhana")
    signature, timestamp = _generate_signature(kaitiaki)

    trace = {
        "event": event,
        "timestamp": timestamp,
        "glyph": _glyph(),
        "kaitiaki": kaitiaki,
        "signature": signature,
        "cwd": str(Path.cwd()),
        "meta": meta or {},
        "supabase_project": (
            os.getenv("DEN_URL").split("//")[1].split(".")[0]
            if os.getenv("DEN_URL")
            else None
        ),
        "status": "active",
    }

    # Local save
    _write_local_trace(kaitiaki, trace)

    # Optional Supabase write
    _write_supabase(trace)

    return trace


# ---------------------------------------------------------
# 6. HEARTBEAT (runs on every startup)
# ---------------------------------------------------------
def mana_heartbeat():
    kaitiaki = os.getenv("AGENT_NAME", "Tiwhanawhana")
    trace_event("heartbeat", {"kaitiaki": kaitiaki})
    mana_trace("heartbeat", {"version": os.getenv("APP_VERSION", "unknown")})
