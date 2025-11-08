# 🎯 Your Deployment Stages - Quick Reference

## Stage Overview

```
STAGE 1: Testing (NOW - LOCAL)
├─ docker-compose up
├─ Backend: port 8000 (Docker container)
├─ PostgreSQL: port 5433 (Docker container)
└─ Goal: Verify everything works locally

STAGE 2: Cloud Deploy (NEXT - RENDER)
├─ Git push to GitHub
├─ Render pulls + builds Dockerfile
├─ Backend: Render assigns port (https://tiwhanawhana-backend.render.com)
└─ Goal: Tiwhanawhana running on cloud

STAGE 3: Cloud Agents (NEXT - LOCAL + CLOUD)
├─ Whiro Watcher: Local or Cloud/Worker (reads Supabase)
├─ Mataroa CLI: Local (orchestrates local tasks)
├─ Intake Bridge: Local (scans kaitiaki-intake/active)
└─ Goal: Full coordinated system

STAGE 4: Full Ecosystem (LATER)
├─ Tiwhanawhana: Cloud (main orchestrator)
├─ Meta-memory: Supabase (central knowledge)
├─ All Kaitiaki: Coordinated via Aotahi
└─ Goal: Complete indigenous AI system
```

---

## Right Now (Stage 1 - Testing)

### ✅ You're Already Doing This

```bash
cd backend
docker-compose up

# Result:
# ✅ Tiwhanawhana running at http://localhost:8000
# ✅ PostgreSQL at localhost:5433
# ✅ All routes working (OCR, translate, embed, memory, intake)
# ✅ Test it:
curl http://localhost:8000/intake/status
```

### ✅ Why This Works

```
docker-compose.yaml:
├─ Services:
│  ├─ backend: Runs Dockerfile (Python 3.11 + FastAPI)
│  │  └─ Exposes port 8000
│  └─ db: PostgreSQL 15 with PostGIS
│     └─ Exposes port 5433 (remapped from 5432)
│
├─ Volumes:
│  ├─ .:/app (hot-reload your code changes)
│  └─ pgdata: (persistent database)
│
└─ Env: Uses .env file for credentials
```

### ✅ Testing Intake in Docker

```bash
# Terminal 1: Keep docker-compose running
cd backend
docker-compose up

# Terminal 2: Test intake (while Docker running)
curl http://localhost:8000/intake/status

# Terminal 3: Add document
echo "# Test" > kaitiaki-intake/active/test.md

# Terminal 2: Scan
curl -X POST http://localhost:8000/intake/scan

# Check Supabase for results ✅
```

---

## Stage 2 (Cloud Deploy - Ready When You Are)

### When You're Ready:

```bash
# 1. Commit to Git
git add -A
git commit -m "Add intake pipeline + Whiro template"
git push origin main

# 2. Go to Render.com dashboard
# 3. Create new Web Service
# 4. Connect to your GitHub repo
# 5. Set build command: pip install -r requirements.txt
# 6. Set start command: uvicorn main:app --host 0.0.0.0 --port 8000
# 7. Add Environment Variables (from .env)
# 8. Deploy!

# Result:
# ✅ Your app is at https://tiwhanawhana-backend.render.com
# ✅ Same Docker image, cloud-hosted
# ✅ Automatically redeploys on git push
```

### Render Does This:
```
Your GitHub Push
        ↓
Render Webhook Triggered
        ↓
Render clones repo
        ↓
Render runs: pip install -r requirements.txt
        ↓
Render builds: Dockerfile
        ↓
Render starts: uvicorn main:app --host 0.0.0.0 --port 8000
        ↓
Service available at: https://tiwhanawhana-backend.render.com
```

---

## Stage 3 (Local Agents Connect to Cloud)

### After Render Deploy:

```python
# On your local machine: (Python script or CLI)

# Point to cloud Tiwhanawhana
TIWHANAWHANA_URL = "https://tiwhanawhana-backend.render.com"

# Whiro watcher (read-only from Supabase)
from backend.matua_whiro.kaitiaki.whiro import WhiroWatcher
whiro = WhiroWatcher(remote_url=TIWHANAWHANA_URL)
whiro.start_audit_loop()

# Mataroa CLI (local orchestrator)
from backend.matua_whiro.kaitiaki.mataroa import MataroaOrchestrator
mataroa = MataroaOrchestrator(remote_url=TIWHANAWHANA_URL)
mataroa.start_cli()

# Intake bridge (local document scanner)
from backend.routes.tiwhanawhana.intake_bridge import TiwhanawhanaIntakeBridge
intake = TiwhanawhanaIntakeBridge()
intake.start_continuous_scan()
```

---

## Your Files Are Already Ready

### For Docker (Testing - NOW)
```
✅ backend/Dockerfile         → Defines container
✅ backend/docker-compose.yaml → Orchestrates containers
✅ backend/requirements.txt    → Installs dependencies
✅ backend/.env               → Config (don't commit)
```

### For Render (Deploy - LATER)
```
✅ Same Dockerfile             → Render builds it
✅ Same requirements.txt        → Render installs it
✅ Same code (now with intake) → Render deploys it
✅ Same .env variables         → You configure in Render
```

### For Local Agents (Stage 3)
```
✅ Mataroa CLI                → Already in backend/matua_whiro/
✅ Whiro Watcher             → WHIRO_INTAKE_TEMPLATE.py ready
✅ Intake Bridge             → backend/routes/tiwhanawhana/intake.py
✅ All can connect to RENDER → Via https://tiwhanawhana-backend.render.com
```

---

## Common Confusion Clarified

### "Why docker-compose if I'll use Render?"
**Answer**: Render essentially IS a container running your Dockerfile. Docker-compose lets you test locally **exactly** like Render will run it. No surprises at deployment time.

### "Why port 8000 says in use?"
**Answer**: `docker-compose up` starts a container on port 8000. That container is Tiwhanawhana. Don't try to run Python directly on same port. Either:
- Keep using docker-compose (✅ recommended)
- Stop docker-compose, then run Python
- Run Python on different port (8001)

### "Will my local code changes update in Docker?"
**Answer**: YES! The docker-compose.yaml has `volumes: - .:/app`, so changes auto-reload. Edit intake.py → hit endpoint → changes live.

### "When do I need to rebuild?"
**Answer**: Only when:
- requirements.txt changes (new packages)
- Dockerfile changes (rare)
  
Otherwise just keep docker-compose running.

### "What happens on Render?"
**Answer**: Same Dockerfile, same code, same behavior. Render runs:
```bash
docker build -f Dockerfile .
docker run -p 8000:8000 [image]
```

Except Render manages the network/SSL part.

---

## Your Timeline

```
TODAY:
├─ Intake working in Docker ✅
├─ Test with test_intake.sh ✅
└─ Add Whiro template ✅

THIS WEEK:
├─ Review deployment doc
├─ Test everything locally
└─ Ready for Render

NEXT WEEK:
├─ Git push
├─ Render deploy
└─ Tiwhanawhana on cloud ✅

FOLLOWING WEEK:
├─ Add Whiro watcher
├─ Connect local agents
└─ Full system running ✅
```

---

## Keep It Simple

```
FOR NOW:
✅ Keep docker-compose running
✅ Keep testing locally
✅ Keep adding features (intake working)

WHEN READY:
✅ Push to Git
✅ Deploy to Render
✅ Same code, cloud-hosted

WHEN DEPLOYED:
✅ Local agents connect to cloud URL
✅ Full system coordinated
✅ Done! 🎉
```

---

**You're on the right path!** Docker-compose is exactly what you need for Stage 1 testing before Render deployment. 🌊

