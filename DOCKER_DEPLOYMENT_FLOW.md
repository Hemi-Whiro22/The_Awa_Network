# 🌊 Tiwhanawhana Deployment Flow (Explained)

## Your Multi-Stage Architecture

```
STAGE 1: Testing/Development (NOW - LOCAL)
├─ docker-compose up
│  ├─ Backend container (port 8000)
│  ├─ PostgreSQL container (port 5433)
│  └─ Hot-reload for development
│
STAGE 2: Cloud Production (LATER - RENDER)
├─ Tiwhanawhana FastAPI → Render (main app)
├─ Whiro Watcher → Cloud/Worker (auditing)
├─ Mataroa CLI → Local (local orchestrator)
├─ Kaitiaki Intake → Local (document scanner)
└─ Meta-memory → Render (Supabase)
```

---

## Why Docker-Compose?

✅ **Isolation**: Tiwhanawhana runs in her own container
✅ **Reproducibility**: Same setup locally and on Render
✅ **Testing**: Full stack running before cloud deployment
✅ **Scaling**: Easy to move from local Docker → Render container
✅ **PostgreSQL**: Includes local pgvector database for testing

---

## 🚀 Running Tiwhanawhana (Correct Way)

### Option A: Use Docker (RECOMMENDED - What You're Doing)
```bash
# Start Tiwhanawhana in isolated container
cd backend
docker-compose up

# Access at http://localhost:8000
curl http://localhost:8000/

# To stop
docker-compose down
```

**Result**: Port 8000 is IN USE by the container ✅

### Option B: Run Direct (ONLY If Docker Not Running)
```bash
# First, STOP the container
docker-compose down

# Now run directly
cd backend
python3 -m uvicorn main:app --reload

# Access at http://localhost:8000
curl http://localhost:8000/
```

**Result**: Direct access to FastAPI ✅

### Option C: Different Port (If You Want Both)
```bash
# Keep Docker running (8000)
# Run direct on different port
python3 -m uvicorn main:app --reload --port 8001

# Access at http://localhost:8001
```

---

## 🎯 Your Current Setup (Correct!)

```
✅ docker-compose.yaml
   ├─ Runs Tiwhanawhana backend (port 8000)
   ├─ Runs PostgreSQL (port 5433)
   └─ Handles env vars + volumes
   
✅ Dockerfile
   ├─ Python 3.11-slim base
   ├─ Locale support (mi_NZ + en_US)
   ├─ Dependencies installed
   └─ Runs: uvicorn main:app
   
✅ .env file
   ├─ Supabase credentials
   ├─ Database config
   └─ API keys
```

**This is exactly what you need for Stage 1 testing!** 👍

---

## 📊 Tiwhanawhana Deployment Timeline

### Now (Stage 1 - Testing)
```
LOCAL DOCKER
├─ docker-compose up
├─ Backend container (port 8000)
├─ PostgreSQL container (port 5433)
└─ All intake routes working
```

### Next (Stage 2 - Cloud)
```
RENDER.COM (Main)
├─ Tiwhanawhana FastAPI deployed
├─ Port 8000 (Render's ephemeral)
├─ Connected to Supabase (remote DB)
└─ Handles core orchestration

LOCAL (Agents)
├─ Mataroa: CLI + background tasks
├─ Intake Bridge: Document scanner
└─ Whiro: Audit watcher (reads Supabase)
```

### Later (Stage 3+ - Full System)
```
RENDER (Primary)
├─ Tiwhanawhana: Cloud orchestrator
└─ Meta-memory: Central coordination

CLOUD/WORKER
├─ Whiro: Audit processor
└─ Other specialized agents

LOCAL (Optional)
├─ Dashboard: kaitiaki-dashboard
└─ Development tools
```

---

## 🔍 Why "Address Already in Use"?

```
Scenario 1: Docker running
├─ docker-compose up
│  └─ Maps port 8000 inside container → port 8000 host
│
├─ Try: python3 -m uvicorn main:app --reload
│  └─ ERROR: Address already in use (port 8000 taken by container)
│
Solution: Use docker-compose, or run on different port

Scenario 2: Direct Python still running
├─ You killed the terminal but process lingered
│  └─ Process still holding port 8000
│
Solution: Kill process → ps aux | grep uvicorn → kill PID

Scenario 3: Both Docker + Python
├─ Docker container on 8000
├─ Python trying to bind to 8000
│  └─ ERROR: Address already in use
│
Solution: Pick one - Docker OR Direct, not both
```

---

## ✅ Testing Intake with Docker

### While `docker-compose up` is running:

```bash
# Terminal 1: Docker is running (port 8000 in use)
cd backend
docker-compose up
# Tiwhanawhana is now running inside container

# Terminal 2: Test the intake endpoints
curl http://localhost:8000/intake/status

curl -X POST http://localhost:8000/intake/scan

curl http://localhost:8000/intake/documents

# Terminal 3: Add documents to folder
echo "# Test" > kaitiaki-intake/active/test.md

# Everything works! ✅
```

**The intake.py routes are already in the container!** They auto-reload if you change them. 👍

---

## 🚀 When Ready to Deploy to Render

### Step 1: Push to Git
```bash
git add .
git commit -m "Add intake bridge, Whiro template, docs"
git push origin main
```

### Step 2: Create Render Service
```
Render Console:
├─ New → Web Service
├─ Connect GitHub repo
├─ Build: pip install -r requirements.txt
├─ Start: uvicorn main:app --host 0.0.0.0 --port 8000
├─ Environment variables: Copy from .env
└─ Deploy!
```

### Step 3: Render Assigns Port
```
Render will assign:
├─ tiwhanawhana-backend.render.com (https)
├─ Port 443 (https) / 80 (http)
├─ Your app runs inside Render's container
└─ Same Dockerfile, same code, cloud-hosted
```

### Step 4: Local Agents Connect
```python
# On your local machine:
TIWHANAWHANA_URL = "https://tiwhanawhana-backend.render.com"

# Whiro watcher
whiro = WhiroWatcher(remote_url=TIWHANAWHANA_URL)

# Mataroa CLI
mataroa = MataroaOrchestrator(remote_url=TIWHANAWHANA_URL)

# Intake bridge
intake = IntakeBridge(remote_url=TIWHANAWHANA_URL)
```

---

## 📋 Current Status (By Stage)

| Stage | Component | Location | Status | Notes |
|-------|-----------|----------|--------|-------|
| **1** | Tiwhanawhana FastAPI | Docker (Local) | ✅ Ready | `docker-compose up` |
| **1** | PostgreSQL | Docker (Local) | ✅ Ready | Port 5433 |
| **1** | Intake Bridge | Docker (Local) | ✅ Ready | `/intake/*` routes |
| **1** | Test Suite | Local | ✅ Ready | `./test_intake.sh` |
| **2** | Cloud Deploy | Render (Ready) | 🟡 Next | Push to Git → Deploy |
| **3** | Whiro Watcher | Local/Cloud | 🟢 Template | Use WHIRO_INTAKE_TEMPLATE.py |
| **4** | Mataroa CLI | Local | 🟢 Ready | Keep running locally |
| **5** | Dashboard | Optional | 🟢 Ready | kaitiaki-dashboard |

---

## 🎓 Docker vs Direct - When to Use Each

### Use Docker (`docker-compose up`)
✅ Testing full stack locally
✅ Before Render deployment
✅ Ensuring Dockerfile works
✅ Testing with PostgreSQL
✅ Production-like environment
✅ Multiple containers coordination

### Use Direct (`python3 -m uvicorn`)
✅ Quick development iteration
✅ Testing specific routes
✅ Debugging with breakpoints
✅ No Docker installed
✅ Single component testing
❌ NOT for final deployment

---

## 🆘 If You Forget Port is In Use

```bash
# See what's running on 8000
lsof -i :8000
# or
netstat -tlnp | grep 8000

# Kill it if needed
kill -9 <PID>

# Or just use docker-compose (easier)
cd backend
docker-compose down  # Stops all containers
docker-compose up    # Starts fresh
```

---

## 🎉 Summary

✅ **You're doing it right** - docker-compose is the correct way
✅ **Port 8000 is in use** - by your Docker container (expected)
✅ **All intake routes working** - inside the container already
✅ **When ready** - same Dockerfile deploys to Render
✅ **Local agents connect** - via Render's public URL

**Keep using docker-compose for now!** It's the right approach for both testing and eventual Render deployment. 🌊

