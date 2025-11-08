# Dual Supabase Linking + Iwi Portal Foundation

**Date:** November 9, 2025  
**Status:** ✅ COMPLETE  
**Deployment Target:** Render + Vercel/Netlify

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│         TIWHANAWHANA AWANET PLATFORM                │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Frontend (Vite + React)                            │
│  ├─ IwiPortalPanel.jsx (tabs: OCR|Translate|etc)  │
│  ├─ useIwiPortal.js (API integration)              │
│  └─ Dark theme with koru design                    │
│                                                     │
│  Backend API (FastAPI)                              │
│  ├─ /iwi/ocr          → pytesseract extract        │
│  ├─ /iwi/translate    → OpenAI translate           │
│  ├─ /iwi/archive      → Te Puna read-only          │
│  └─ /iwi/ingest       → Alpha-Den save             │
│                                                     │
│  Dual Supabase Projects                             │
│  ├─ Alpha-Den (WRITE)  → operational data          │
│  │  ├─ ocr_logs                                    │
│  │  ├─ translations                                │
│  │  ├─ memory_logs                                 │
│  │  └─ task_queue                                  │
│  │                                                  │
│  └─ Te Puna (READ-ONLY) → iwi knowledge archive   │
│     ├─ summaries                                   │
│     ├─ taonga_metadata                             │
│     └─ cultural_context                            │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Project IDs & Endpoints

### Alpha-Den (Operational)
- **Project ID:** `ruqejtkudezadrqbdodx`
- **API:** `https://pfyxslvdrcwcdsfldyvl.supabase.co`
- **Access:** Write-enabled (service role key)
- **Purpose:** Data collection, processing, aggregation

### Te Puna (Archive)
- **Project ID:** `fyrzttjlvofmcfxibtpi`
- **API:** `https://fyrzttjlvofmcfxibtpi.supabase.co`
- **Access:** Read-only (RLS enforced)
- **Purpose:** Iwi knowledge reference, summaries, cultural context

---

## Configuration Files

### supabase/config.toml
```toml
[projects.alpha_den]
project_ref = "ruqejtkudezadrqbdodx"
url = "https://pfyxslvdrcwcdsfldyvl.supabase.co"
access_level = "write"

[projects.te_puna]
project_ref = "fyrzttjlvofmcfxibtpi"
url = "https://fyrzttjlvofmcfxibtpi.supabase.co"
access_level = "read"
rls_enforced = true
```

### Environment Variables (Render)

```bash
# Alpha-Den (operational write)
DEN_URL=https://pfyxslvdrcwcdsfldyvl.supabase.co
DEN_API_KEY=<alpha-den-service-role-key>

# Te Puna (archive read-only)
TEPUNA_URL=https://fyrzttjlvofmcfxibtpi.supabase.co
TEPUNA_API_KEY=<te-puna-anon-key>

# Frontend
VITE_API_URL=https://<your-render-backend-url>
```

---

## Backend Implementation

### Routes Added: `/iwi/` prefix

| Endpoint | Method | Input | Output | Project |
|----------|--------|-------|--------|---------|
| `/iwi/ocr` | POST | Image file | OCR text + confidence | Alpha-Den |
| `/iwi/translate` | POST | Text + langs | Translated text | Alpha-Den |
| `/iwi/archive` | GET | limit param | Array of Te Puna records | Te Puna |
| `/iwi/ingest` | POST | Title + content | Inserted record ID | Alpha-Den |
| `/iwi/status` | GET | — | Portal health | Both |

### Key Features

- **OCR:** pytesseract with Māori (`mri`) + English language support
- **Translation:** OpenAI gpt-4o-mini for bidirectional translation
- **Archive:** Read-only access to Te Puna summaries (RLS enforced)
- **Ingest:** Bulk upload with metadata tagging for Alpha-Den
- **Async Support:** All database calls use async wrappers for FastAPI compatibility
- **Retry Logic:** Exponential backoff on transient Supabase errors
- **Logging:** Māori-friendly emoji indicators (🪶✅⚠️❌)

### Files

- `backend/routes/iwi_portal.py` — Main route handlers
- `backend/core/main.py` — Router registration
- `backend/utils/supabase_client.py` — Dual-project client factory

---

## Frontend Implementation

### Iwi Portal Panel

**File:** `frontend/src/panels/IwiPortalPanel.jsx`

**Features:**
- 4 tabs: OCR → Translate → Archive → Ingest
- Dark theme with gradient (blue-900 → green-900)
- File upload zone for OCR
- Real-time translation display
- Archive browser (read-only)
- Ingest workflow with confirmation

### API Integration Hook

**File:** `frontend/src/hooks/useIwiPortal.js`

**Functions:**
- `uploadOCR(file)` → Extract text from image
- `translateText(text, source, target)` → Translate via OpenAI
- `fetchArchive(limit)` → Read from Te Puna
- `ingestRecord(title, content, source, fileType, metadata)` → Save to Alpha-Den
- `checkStatus()` → Portal health check

---

## Security Model

### Alpha-Den (Write-Enabled)
- **Key Type:** Service Role (privileged)
- **Permissions:** Full write + read
- **Storage:** Render Environment (encrypted at rest)
- **Use Case:** Operational data ingestion

### Te Puna (Read-Only)
- **Key Type:** Anonymous or Anon (read-only)
- **Permissions:** SELECT only on specific tables
- **RLS:** Row-level security enforced
- **Use Case:** Public iwi knowledge reference
- **Protection:** Cannot accidentally insert/update/delete

### In-Transit Security
- HTTPS only (Supabase, FastAPI, frontend)
- JWT tokens in Authorization header
- CORS restricted to Render backend

### Logging & Audit
- No secrets logged (masked environment)
- Structured JSON logs with timestamps
- User actions traced to endpoint + project
- Errors logged without sensitive data

---

## Deployment Checklist

### Local Development
```bash
# 1. Link both projects
supabase link --project-ref ruqejtkudezadrqbdodx
supabase link --project-ref fyrzttjlvofmcfxibtpi

# 2. Pull schemas
supabase db pull

# 3. Start local stack
docker-compose up --build

# 4. Test endpoints
curl http://localhost:8000/iwi/status
curl http://localhost:5173  # Frontend
```

### Render Deployment
```bash
# 1. Add to Render Environment tab:
DEN_URL=https://pfyxslvdrcwcdsfldyvl.supabase.co
DEN_API_KEY=<service-role-key>
TEPUNA_URL=https://fyrzttjlvofmcfxibtpi.supabase.co
TEPUNA_API_KEY=<anon-key>

# 2. Push to GitHub (auto-redeploy)
git add .
git commit -m "feat: dual Supabase linking + Iwi Portal foundation"
git push origin main

# 3. Watch Render logs for:
# ✅ Supabase Git link validated for Alpha-Den project
# 🪶 Connected to Alpha-Den (write) and Te Puna (read-only)
# 🔐 Te Puna configured as read-only iwi knowledge archive
```

### Frontend Deployment
```bash
# Deploy to Vercel/Netlify:
VITE_API_URL=https://<render-backend-url> npm run build
# Upload dist/ directory
```

---

## Testing Workflow

### 1. OCR Upload
```bash
curl -F "file=@image.png" http://localhost:8000/iwi/ocr
# Returns: { filename, text, confidence, created_at, saved_to }
```

### 2. Translation
```bash
curl -X POST http://localhost:8000/iwi/translate \
  -H "Content-Type: application/json" \
  -d '{"text":"Kia ora","source_lang":"mi","target_lang":"en"}'
# Returns: { original_text, translated_text, target_lang, saved_to }
```

### 3. Archive Query
```bash
curl "http://localhost:8000/iwi/archive?limit=10"
# Returns: { data: [...], count, ok, error }
```

### 4. Ingest Record
```bash
curl -X POST http://localhost:8000/iwi/ingest \
  -H "Content-Type: application/json" \
  -d '{"title":"Korero","content":"...","source":"portal","file_type":"text"}'
# Returns: { data, ok, error }
```

---

## Next Steps

### Phase 2: ML Enhancement
- [ ] Māori language model fine-tuning (OpenAI GPT-4 with Māori dataset)
- [ ] Confidence scoring for OCR (< 0.6 → fallback to vision model)
- [ ] Vector embeddings for semantic search

### Phase 3: Iwi Governance
- [ ] User authentication (Supabase Auth + iwi-specific roles)
- [ ] Audit logging (who accessed what, when)
- [ ] Data export workflows (CSV, PDF, genealogy formats)
- [ ] Approval workflows for sensitive content

### Phase 4: Community Features
- [ ] Collaborative translation UI
- [ ] Tagging + categorization
- [ ] Full-text search across archive
- [ ] Notifications for new ingestions

---

## Support & Documentation

- **API Docs:** http://localhost:8000/docs (auto-generated by FastAPI)
- **Supabase Docs:** https://supabase.com/docs
- **Render Docs:** https://render.com/docs
- **Taonga Git:** https://github.com/Hemi-Whiro22/fast-api-render

---

**Commits:**
- `2689427` — Supabase config + Alpha-Den linking
- `5cfdb22` — Link documentation
- `[latest]` — Dual Supabase + Iwi Portal foundation

**Status:** 🚀 Ready for Render redeploy + frontend testing
