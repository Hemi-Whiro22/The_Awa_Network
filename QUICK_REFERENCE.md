# 🌊 Your Tiwhanawhana Setup - Quick Reference

## Current Status ✅

### What You Have
```
✅ Tiwhanawhana Watchdog
   - FastAPI core (port 8000)
   - OCR, Translate, Embed, Memory routes
   - Supabase + pgvector backend
   
✅ kaitiaki-intake Folder (at root)
   - Active documents ready for processing
   - Organized structure (active/raw/raw_archive)
   
✅ kaitiaki-dashboard (at root)
   - UI for monitoring
   - Ready to connect to Tiwhanawhana
   
✅ 11 Kaitiaki Agents (in backend/matua_whiro/kaitiaki/)
   - Mataroa (Navigator)
   - Whiro (Auditor)
   - Rongohia, Kitenga, Hinewai, etc.
   - NOT threaded into main flow yet ✓ (clean)
```

### Recommended Setup

```
PHASE 1 (NOW - Simple):
├─ Tiwhanawhana = Watchdog (OCR/Translate/Embed/Memory)
├─ kaitiaki-intake/active/ = Document source
├─ Intake Bridge (NEW) = Scans & queues documents
├─ Supabase = Document storage + audit trail
└─ Result = Documents land in Supabase with IDs

PHASE 2 (Next - Add Auditing):
├─ Whiro = Audits documents from task_queue
├─ Whiro Auditor = Validates cultural compliance
├─ Whiro saves audit to audit_logs table
└─ Result = Documents + audit trail

PHASE 3 (Optional - Full Multi-Agent):
├─ Rongohia = Knowledge indexing
├─ Kitenga = Data analysis
├─ Other agents as needed
└─ Aotahi = Coordinates all
```

## New Files Added

### 1. `intake_bridge.py` 
- Monitors kaitiaki-intake/active/ folder
- Reads .md, .json, .txt files
- Queues to Supabase task_queue
- Requests Whiro audit

### 2. `intake.py`
- FastAPI endpoints:
  - `/intake/status` - Current status
  - `/intake/scan` - Scan once
  - `/intake/documents` - List all
  - `/intake/process/{name}` - Process specific
  - `/intake/start-continuous-scan` - Background loop

### 3. Updated `main.py`
- Imports intake routes
- Logs "Intake Bridge" at startup

## Folder Decision: LEAVE AS IS ✅

**Don't move anything!** Your current structure is clean:

```
✅ GOOD - Current Structure
project-root/
├── kaitiaki-intake/        (ROOT - no duplicates)
├── kaitiaki-dashboard/     (ROOT - separate)
└── backend/
    └── routes/tiwhanawhana/
        ├── intake.py       (NEW - handles routes)
        ├── intake_bridge.py (NEW - does work)
        └── ...
```

No need to move anything. Intake folder at root is perfect for document dropping.

## What Happens When You Drop a Document

```
1. Copy document to kaitiaki-intake/active/
   my_document.md → stored at /kaitiaki-intake/active/my_document.md

2. Hit /intake/scan endpoint
   → Tiwhanawhana.intake_bridge finds it
   → Reads content
   → Generates intake_abc123 ID

3. Queues to Supabase
   → Saves to task_queue table
   → Status = "pending"
   → Priority = 2

4. Whiro gets notified
   → Reads from task_queue
   → Audits for cultural compliance
   → Saves audit_result

5. Result in Supabase
   ✅ Document stored with ID
   ✅ Audit trail created
   ✅ Ready for next step
```

## One-Line Test

```bash
# After backend is running:

# 1. Add test document
echo "# Test" > kaitiaki-intake/active/test.md

# 2. Scan
curl http://localhost:8000/intake/scan

# 3. Check
curl http://localhost:8000/intake/status
```

## Next: Add Whiro

Once this works, create:
```python
# backend/matua_whiro/kaitiaki/whiro/whiro_intake_processor.py
def process_intake_audit_task(task_from_queue):
    # Read task_queue entry
    # Audit document for cultural compliance
    # Save to audit_logs
    # Update task_queue status = "completed"
```

Then Whiro runs on a loop reading `task_type == "whiro_audit_document"` tasks.

---

## Summary

✅ **Tiwhanawhana = Watchdog** (runs core services)
✅ **Intake Bridge = Scanner** (monitors kaitiaki-intake/active)
✅ **Supabase = Storage** (documents + audit trail)
🛡️ **Whiro = Auditor** (next step)

No folder moving needed. Clean setup. Ready to go.

