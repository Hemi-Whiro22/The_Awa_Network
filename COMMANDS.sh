#!/bin/bash
# 🌊 TIWHANAWHANA - Quick Command Reference
# Commands for testing, deploying, and managing your system

# ============================================
# STAGE 1: LOCAL TESTING (NOW)
# ============================================

# Start Tiwhanawhana in Docker
docker-compose -f backend/docker-compose.yaml up

# Stop Tiwhanawhana (and clean up)
docker-compose -f backend/docker-compose.yaml down

# View logs
docker-compose -f backend/docker-compose.yaml logs -f

# Run test suite
./test_intake.sh

# Test intake endpoints (while docker-compose running)
curl http://localhost:8000/intake/status
curl http://localhost:8000/intake/documents
curl -X POST http://localhost:8000/intake/scan
curl -X POST http://localhost:8000/intake/start-continuous-scan

# Add test document
echo "# Test Document" > kaitiaki-intake/active/test.md

# Check what's running on port 8000
lsof -i :8000
# or
netstat -tlnp | grep 8000

# Kill process on port 8000 (if stuck)
kill -9 <PID>

# ============================================
# STAGE 2: PREPARE FOR CLOUD (WHEN READY)
# ============================================

# Review changes
git status
git diff

# Stage changes
git add -A

# Commit
git commit -m "Add intake bridge, Whiro template, deployment docs"

# Push to GitHub (triggers Render webhook)
git push origin main

# Check git log
git log --oneline -5

# ============================================
# STAGE 3: LOCAL AGENTS (AFTER RENDER DEPLOY)
# ============================================

# Start Whiro watcher (reads Supabase)
# (Create script once WHIRO_INTAKE_TEMPLATE.py is deployed)

# Start Mataroa CLI (local orchestrator)
# python3 backend/matua_whiro/kaitiaki/mataroa/mataroa_cli.py

# Start intake bridge (continuous monitoring)
python3 backend/routes/tiwhanawhana/intake_bridge.py loop

# ============================================
# DEBUGGING & TROUBLESHOOTING
# ============================================

# Check Supabase connection
curl https://ruqejtkudezadrqbdodx.supabase.co/rest/v1/

# View backend logs
docker-compose -f backend/docker-compose.yaml logs backend

# View database logs
docker-compose -f backend/docker-compose.yaml logs db

# Connect to PostgreSQL
psql -h localhost -p 5433 -U postgres -d tiwhanawhana

# Check if dependencies are installed
pip list | grep -E "fastapi|uvicorn|supabase|pgvector"

# Rebuild Docker image (if changes to Dockerfile)
docker-compose -f backend/docker-compose.yaml build --no-cache

# Remove all Docker containers
docker-compose -f backend/docker-compose.yaml down -v

# ============================================
# DOCUMENTATION QUICK ACCESS
# ============================================

# Read this (you are here!)
cat STAGES_EXPLAINED.md

# Then read these
cat README_INTAKE.md
cat QUICK_REFERENCE.md
cat INTAKE_SETUP_GUIDE.md
cat ARCHITECTURE_DIAGRAM.md
cat DOCKER_DEPLOYMENT_FLOW.md

# ============================================
# MONITORING & STATUS
# ============================================

# Check all container status
docker ps
docker ps -a

# Check container resource usage
docker stats

# View container details
docker inspect tiwhanawhana_backend
docker inspect tiwhanawhana_db

# Test API health
curl http://localhost:8000/

# ============================================
# USEFUL PORTS
# ============================================

# FastAPI: http://localhost:8000
# PostgreSQL: localhost:5433 (inside: 5432)
# Supabase: https://supabase.com (web)
# Render: (your deployed URL when ready)

# ============================================
# NEXT STEPS
# ============================================

# 1. Test locally
docker-compose -f backend/docker-compose.yaml up
./test_intake.sh

# 2. Read docs
cat README_INTAKE.md
cat DOCKER_DEPLOYMENT_FLOW.md

# 3. When ready to deploy
git add -A
git commit -m "Ready for Render deployment"
git push origin main

# Then go to Render.com and connect your repo!

# ============================================
# QUICK DIAGNOSIS
# ============================================

# If "address already in use":
docker-compose -f backend/docker-compose.yaml down
docker-compose -f backend/docker-compose.yaml up

# If intake endpoints not found:
# Make sure docker-compose is running
curl http://localhost:8000/intake/status

# If no documents found:
ls kaitiaki-intake/active/
# If empty, add one:
echo "test" > kaitiaki-intake/active/test.md

# If Supabase not connecting:
# Check .env file has DEN_URL and DEN_API_KEY
cat backend/.env | grep DEN_

# ============================================
# RENDER DEPLOYMENT CHECKLIST
# ============================================

# Before deployment, verify:
# [ ] docker-compose up works locally
# [ ] All tests pass (./test_intake.sh)
# [ ] Git is clean (git status shows nothing)
# [ ] Changes committed (git log shows your commit)
# [ ] .env not in git (check .gitignore)
# [ ] Code pushed to GitHub (git push done)

# Then:
# [ ] Go to render.com
# [ ] New → Web Service
# [ ] Connect to your GitHub repo
# [ ] Build: pip install -r requirements.txt
# [ ] Start: uvicorn main:app --host 0.0.0.0 --port 8000
# [ ] Add environment variables (from .env)
# [ ] Deploy!
# [ ] Get https://tiwhanawhana-backend.render.com URL
# [ ] Update local configs to use that URL

# ============================================
# USEFUL SHORTCUTS
# ============================================

# Alias for docker-compose (add to ~/.bashrc)
alias ti-up='docker-compose -f backend/docker-compose.yaml up'
alias ti-down='docker-compose -f backend/docker-compose.yaml down'
alias ti-logs='docker-compose -f backend/docker-compose.yaml logs -f'
alias ti-test='./test_intake.sh'

# Then you can just:
# ti-up
# ti-test
# ti-down
