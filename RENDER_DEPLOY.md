# 🚀 Render Deployment Guide - Tiwhanawhana

## Quick Start
1. Push repo to GitHub (private)
2. Connect to Render
3. Paste keys
4. Deploy

---

## Step 1: Push to GitHub

```bash
# Add remote (replace with your GitHub repo URL)
git remote add origin https://github.com/YOUR_USERNAME/tiwhanawhana.git
git branch -M main
git push -u origin main
```

---

## Step 2: Create Render Service

1. Go to [render.com](https://render.com)
2. Click **New +** → **Web Service**
3. Select **Connect a repository** → Choose your `tiwhanawhana` repo
4. Configure:
   - **Name:** `tiwhanawhana-backend`
   - **Environment:** `Python 3`
   - **Build Command:** `pip install -r backend/requirements.txt`
   - **Start Command:** `uvicorn backend.core.main:app --host 0.0.0.0 --port $PORT`

---

## Step 3: Add Environment Variables

In Render dashboard, go to **Environment** and paste these (one at a time from Supabase):

```
DEN_URL=https://ruqejtkudezadrqbdodx.supabase.co
DEN_API_KEY=<paste-your-DEN-service-role-key-here>
TEPUNA_URL=https://fyrzttjlvofmcfxibtpi.supabase.co
TEPUNA_API_KEY=<paste-your-TEPUNA-service-role-key-here>
OPENAI_API_KEY=<paste-your-openai-key-here>
LANG=mi_NZ.UTF-8
LC_ALL=mi_NZ.UTF-8
TZ=Pacific/Auckland
APP_ENV=production
```

---

## Step 4: Deploy

Click **Create Web Service** → Render deploys automatically

---

## Step 5: Test Live Endpoint

```bash
# Your live API will be at something like:
# https://tiwhanawhana-backend-xxxx.onrender.com

curl https://tiwhanawhana-backend-xxxx.onrender.com/health
# Should return: {"status":"ok","timestamp":"2025-11-08T..."}
```

---

## Where to Get the Keys

**DEN Service Role Key:**
- Go to: `https://supabase.com/dashboard/project/ruqejtkudezadrqbdodx/settings/api-keys`
- Find **service_role** (red "secret" label)
- Click **Copy**

**TEPUNA Service Role Key:**
- Go to: `https://supabase.com/dashboard/project/fyrzttjlvofmcfxibtpi/settings/api-keys`
- Find **service_role**
- Click **Copy**

**OpenAI Key:**
- Get from your OpenAI dashboard

---

## Monitoring

In Render dashboard:
- **Logs** → See live application output
- **Metrics** → CPU, memory, requests
- **Events** → Deployment history

---

## Troubleshooting

**Deployment fails:**
- Check **Logs** in Render
- Verify all env vars are set
- Make sure `backend/requirements.txt` exists

**API returns 500 error:**
- Likely missing env var
- Check Render logs

**Keys "invalid":**
- Double-check you copied the **service_role** key (not anon key)
- Make sure there are no spaces at the start/end

---

## Success Indicators

✅ Deployment completes
✅ `/health` endpoint returns 200
✅ `/env/health` shows all vars loaded
✅ Logs show no "Invalid API key" errors

---

You're live! 🌊
