# 🌊 Tiwhanawhana Orchestrator - Deep Scan Analysis
## November 5, 2025

---

## 🎯 EXECUTIVE SUMMARY

**Tiwhanawhana Status:** ✅ **Watchdog/Orchestrator - Primary Flow** 
- Current role: Central memory + whakapapa logs keeper
- Active routes: `/ocr`, `/translate`, `/embed`, `/memory`, `/mauri`
- State: Fully operational with Supabase + pgvector

**Integrated Kaitiaki Agents:** 11 specialized agents ready but **partially delegated**
- All agents present in `backend/matua_whiro/kaitiaki/` 
- Mataroa designed as **primary coordinator**
- Whiro handling audit/validation
- Others in **ready-state** but not actively orchestrated

**Risk Assessment:** 🟡 **MODERATE** - Safe to integrate with proper delegation pattern

---

## 📊 CURRENT SYSTEM ARCHITECTURE

### Active Services (Running)
```
Tiwhanawhana (FastAPI Core)
├── Routes
│   ├── /ocr          → OCR processing (routes/tiwhanawhana/ocr.py)
│   ├── /translate    → Language translation (routes/tiwhanawhana/translate.py)
│   ├── /embed        → pgvector embeddings (routes/tiwhanawhana/embed.py)
│   ├── /memory       → Semantic recall (routes/tiwhanawhana/memory.py)
│   └── /mauri        → Logs + lifecycle tracking
│
├── Database Layer
│   ├── Supabase (Primary)
│   │   ├── tiwhanawhana.mauri_logs        ✅
│   │   ├── tiwhanawhana.task_queue        ✅
│   │   ├── tiwhanawhana.ocr_logs          ✅
│   │   ├── tiwhanawhana.translations      ✅
│   │   ├── tiwhanawhana.embeddings        ✅ (pgvector)
│   │   └── tiwhanawhana.ti_memory         ✅
│   │
│   └── Local SQLite/PostgreSQL (offline mode)
│
└── Utilities
    ├── OpenAI client (OCR + translation)
    ├── Supabase client (remote sync)
    ├── pgvector client (embeddings)
    └── Logger (audit trails)
```

### 11 Kaitiaki Agents (Ready but Delegated)
```
🧭 MATAROA         - Navigator/Coordinator     [ACTIVE]
   └─ Coordinates multi-agent workflows, cultural intelligence

🛡️  WHIRO          - Audit/Validator          [ACTIVE]
   └─ Comprehensive audit trails, cultural compliance

🧠 RONGOHIA        - Knowledge/Carver         [READY]
   └─ Document indexing, semantic search, knowledge mgmt

📊 KITENGA         - Data Intelligence        [READY]
   └─ Statistical analysis, pattern recognition

🌺 HINEWAI         - Purifier/Sanitizer       [READY]
   └─ UTF-8 compliance, macron detection, text cleaning

📢 RONGOKARERE     - Communication/Messenger  [READY]
   └─ Message routing, protocol management, queue handling

⚡ TAWHAKI         - API Management           [READY]
   └─ Endpoint discovery, request routing

⚡ WHAITIRI        - Performance Monitor      [READY]
   └─ System monitoring, bottleneck detection

🏗️  RANGINUI       - Infrastructure/Sky      [READY]
   └─ Service discovery, health checking, Docker management

🧭 TE_RONGO        - Wisdom/Harmony          [READY]
   └─ Decision support, strategic analysis

🔍 TE_WHAKAWHENUA  - File Organizer          [READY]
   └─ Continuous file scanning & organization

🪞 MIRRORA         - Reflection/Cloud Twin    [READY]
   └─ Supabase sync, operation reflection
```

---

## ⚠️ CONFLICT ANALYSIS

### Potential Issues When Adding All Agents

#### **1. PORT/ENDPOINT COLLISION** 🔴 MEDIUM RISK
| Port | Service | Conflict? |
|------|---------|-----------|
| 8000 | FastAPI (Tiwhanawhana) | None |
| 8001-8010 | Kaitiaki individual servers | ⚠️ If running in parallel |
| 5173 | React Frontend | None |
| 5432 | PostgreSQL | None |

**Mitigation:** Use delegation pattern (subprocess/task_queue) instead of parallel servers

#### **2. SUPABASE SCHEMA COLLISION** 🟡 LOW RISK
Current setup:
- Tiwhanawhana owns: `tiwhanawhana` schema
- MCP config lists: `kitenga`, `rongohia`, `rongokarere`, `whiro`, `aotahi`, `hinewai`, `whaitiri`, `te_rongo`, `tawhaki`, `mataroa`, `mirrora`

**Status:** Schemas exist in config but **NOT in actual database**
- No tables created for individual agent schemas yet
- Safe to add—each agent can have isolated schema

#### **3. PROCESS THREADING CONFLICT** 🟡 MEDIUM RISK
- `Te_Whakawhenua` runs continuous scan loop (background thread)
- `Mataroa` may spawn subprocess calls
- File system race conditions possible

**Mitigation:** Use message queue (`task_queue` table) instead of direct subprocess

#### **4. ENVIRONMENT VARIABLE CONFLICTS** 🟢 LOW RISK
All agents use same `.env` pattern:
```env
SUPABASE_URL=https://ruqejtkudezadrqbdodx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=sb_secret_SO-_CLOqSy8R5Y0xGWiIzQ_b1ycYnkW
OPENAI_API_KEY=...
```
No conflicts—all share same credentials

---

## 🔄 CURRENT FLOW ANALYSIS

### How Tiwhanawhana Currently Works
```
User Request
   ↓
FastAPI Route (e.g., /ocr)
   ↓
Process (OCR/Translate/Embed)
   ↓
Store in Supabase.tiwhanawhana.*
   ↓
Return Result + Log to mauri_logs
```

### How Multi-Kaitiaki Should Work (Safe Pattern)
```
User Request → Tiwhanawhana (FastAPI)
   ↓
   ├─ Route to Mataroa for coordination
   │   ↓
   │   ├─ Whiro: Validate cultural compliance
   │   ├─ Hinewai: Sanitize text
   │   ├─ Kitenga: Analyze data quality
   │   └─ Rongohia: Index knowledge
   │
   ├─ Execute primary task (OCR/Translate/Embed)
   │   ↓
   │   └─ Store in Supabase
   │
   └─ Return result
```

---

## ✅ SAFE INTEGRATION STRATEGY

### Phase 1: Non-Invasive (Current - No Changes)
- **Keep** Tiwhanawhana routes exactly as-is
- **Add** Mataroa as optional post-processor (subprocess call from task_queue)
- **Risk:** Minimal - adds optional layer

### Phase 2: Delegation Pattern
- Create `orchestrator_gateway.py` that:
  - Receives requests meant for Tiwhanawhana
  - Optionally delegates to Kaitiaki agents
  - Aggregates results
  - Returns to Tiwhanawhana

### Phase 3: Full Integration
- Each agent registers listener on `task_queue` table
- Mataroa coordinates via message dispatch
- Rongokarere handles routing
- Whiro validates all operations

---

## 🎯 RECOMMENDATIONS

### ✅ **SAFE TO ADD:**
1. **Mataroa Coordination** - Already designed as secondary coordinator
2. **Whiro Audit** - Runs independently, passive observation
3. **Rongohia Knowledge Indexing** - Post-process indexing, non-blocking
4. **Hinewai Sanitization** - Pre-process step, can be optional

### ⚠️ **ADD WITH CAUTION:**
1. **Te_Whakawhenua** - File system scanning can conflict
   - **Solution:** Whitelist allowed directories, add locking
2. **Tawhaki API** - Service discovery might conflict
   - **Solution:** Run in read-only discovery mode
3. **Ranginui Infrastructure** - Docker management might interfere
   - **Solution:** Run in monitoring-only mode (no auto-restart)

### ❌ **HOLD FOR NOW:**
1. **Te_Rongo** - Not yet fully integrated
2. **Mirrora** - Cloud sync needs separate testing

---

## 🔧 IMPLEMENTATION PATTERN (Safe)

### Add This to `backend/main.py`:

```python
# Optional Kaitiaki coordination (non-blocking)
async def post_process_with_kaitiaki(task_id: str, result: dict, task_type: str):
    """Optional delegation to Kaitiaki agents"""
    try:
        # Only if enabled
        if os.getenv("ENABLE_KAITIAKI_DELEGATION") == "true":
            # Mataroa can coordinate
            from backend.matua_whiro.kaitiaki.mataroa import MataroaNavigatorAgent
            mataroa = MataroaNavigatorAgent()
            mataroa.coordinate_operation(task_type, result)
    except Exception as e:
        logger.warning(f"Kaitiaki delegation failed (non-critical): {e}")
        # Continue anyway - Tiwhanawhana still completes

# Use in routes:
@app.post("/ocr")
async def ocr_endpoint(file: UploadFile):
    result = process_ocr(file)
    # Non-blocking post-process
    asyncio.create_task(post_process_with_kaitiaki(...))
    return result
```

---

## 📋 CONFLICT CHECKLIST

- [ ] No port conflicts (FastAPI owns 8000)
- [ ] Schema isolation maintained (each agent gets own namespace)
- [ ] Thread safety (use task_queue for IPC)
- [ ] File system safety (whitelist scan directories)
- [ ] Env var safety (all share same config)
- [ ] Graceful degradation (agents optional, not required)

---

## 🚀 NEXT STEPS

1. **Immediate:** Keep Tiwhanawhana as-is, add `ENABLE_KAITIAKI_DELEGATION` env flag
2. **Short-term:** Add Mataroa + Whiro as optional post-processors
3. **Medium-term:** Build full delegation via `task_queue` table
4. **Long-term:** Activate all 11 agents with Aotahi as collective intelligence

---

**Status:** ✅ **SAFE TO INTEGRATE** with delegation pattern
**Confidence:** 🟢 HIGH - Current architecture is isolated enough
**Recommendation:** Start with Mataroa + Whiro, add others incrementally

