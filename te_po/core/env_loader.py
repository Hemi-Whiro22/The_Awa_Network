import os
import locale
from dotenv import load_dotenv


def load_env(env_path: str = ".env") -> None:
    """Load environment variables safely."""
    try:
        load_dotenv(env_path)
    except Exception:
        pass


def enforce_utf8_locale() -> None:
    """Force UTF-8 and mi_NZ locale when available."""
    try:
        locale.setlocale(locale.LC_ALL, "mi_NZ.UTF-8")
    except locale.Error:
        locale.setlocale(locale.LC_ALL, "en_US.UTF-8")

    os.environ["LANG"] = "mi_NZ.UTF-8"
    os.environ["LC_ALL"] = "mi_NZ.UTF-8"


def validate_environment(required_keys: list[str]) -> dict:
    """Ensure required environment variables are present."""
    missing = []
    present = {}

    for key in required_keys:
        val = os.getenv(key)
        if val is None or val.strip() == "":
            missing.append(key)
        else:
            present[key] = "***masked***"

    return {"missing": missing, "present": present}
