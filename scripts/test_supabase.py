"""Quick Supabase connectivity check for Tiwhanawhana."""
from __future__ import annotations

import os
import sys

from supabase import create_client

SUPABASE_URL_ENV = "DEN_URL"
SUPABASE_KEYS = (
    "DEN_API_KEY",
    "TEPUNA_API_KEY",
)


def _resolve_credentials() -> tuple[str, str]:
    url = os.getenv(SUPABASE_URL_ENV)
    key = next((os.getenv(name)
               for name in SUPABASE_KEYS if os.getenv(name)), None)
    if not url or not key:
        print("⚠️ Missing Supabase credentials. Set DEN_URL and either DEN_API_KEY or TEPUNA_API_KEY.")
        sys.exit(1)
    return url, key


def main() -> None:
    url, key = _resolve_credentials()
    supabase = create_client(url, key)
    print("🌊 Checking Supabase connection...")

    try:
        response = supabase.table("ocr_logs", schema="tiwhanawhana").select(
            "id").limit(1).execute()
        data = getattr(response, "data", None) or []
        print(f"✅ Supabase reachable, sample rows: {len(data)}")
    except Exception as exc:  # noqa: BLE001
        print("⚠️ Supabase check failed:", exc)
        sys.exit(1)


if __name__ == "__main__":
    main()
