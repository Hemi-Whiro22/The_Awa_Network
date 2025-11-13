from typing import Optional, Dict, Any
from pydantic_settings import BaseSettings
from pydantic import Field
from functools import lru_cache

_env_state: Dict[str, Any] = {}


class Settings(BaseSettings):
    """Application settings sourced from validated environment variables."""

    # Supabase keys
    supabase_url: Optional[str] = Field(default=None, alias="DEN_URL")
    supabase_service_role_key: Optional[str] = Field(
        default=None, alias="DEN_API_KEY")
    supabase_anon_key: Optional[str] = Field(
        default=None, alias="TEPUNA_API_KEY")
    supabase_publishable_key: Optional[str] = Field(
        default=None, alias="TEPUNA_URL")
    # OpenAI
    openai_api_key: Optional[str] = Field(default=None, alias="OPENAI_API_KEY")

    # Locale
    lang: str = "mi_NZ.UTF-8"
    lc_all: str = "mi_NZ.UTF-8"

    # Flags + Tools
    offline_mode: bool = False
    database_url: Optional[str] = None
    memory_table: Optional[str] = None

    # Models
    translation_model: str = "gpt-4o-mini"
    embedding_model: str = "text-embedding-3-small"

    # OCR
    tesseract_path: Optional[str] = None

    # Supabase tables
    supabase_table_ocr_logs: str = "ocr_logs"
    supabase_table_translations: str = "translations"
    supabase_table_embeddings: str = "embeddings"
    supabase_table_memory: str = "ti_memory"

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        extra = "ignore"        # <-- Important
        populate_by_name = True

    def summary(self) -> Dict[str, Any]:
        """Return a masked snapshot of environment status."""
        return {
            "context": _env_state.get("context", "local"),
            "loaded_keys": _env_state.get("loaded_keys", []),
            "masked_secrets": _env_state.get("masked_preview", {}),
            "utf8_status": _env_state.get("utf8_status", {}),
            "source": _env_state.get("source", "system"),
        }


@lru_cache()
def get_settings() -> Settings:
    return Settings()


# global shared instance
settings = get_settings()
