# Tiwhanawhana Platform

## Deployment: Environment & UTF-8 readiness
- Secrets load via `backend/core/env_loader.py`, which masks key previews, enforces UTF-8 locales, and writes audit entries to `logs/env_validation.log`.
- Render services run through `start.sh`, exporting `LANG`/`LC_ALL` as `mi_NZ.UTF-8` before invoking `uvicorn backend.core.main:app`.
- The `/env/health` endpoint (served by `backend/core/main.py`) returns loaded secret keys, UTF-8 status, and a timestamp for operational checks.
- Deployment logs should show `UTF-8 verified: True` alongside masked secret previews before accepting traffic.
- When deploying to Render, ensure `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, and `OPENAI_API_KEY` are provided via the dashboard; local `.env` files remain for developer setups only.
