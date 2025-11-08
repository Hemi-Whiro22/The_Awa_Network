# 🌊 Tiwhanawhana + Whiro Integration Setup
## Document Intake → Audit Pipeline

---

## 🎯 Architecture

```
kaitiaki-intake/active/
    ├── (documents drop here)
    │
    └─→ [Tiwhanawhana Watchdog]
         ├─ Detects new documents
         ├─ Reads content
         ├─ Generates ID
         └─ Queues to task_queue
              │
              ├─→ [Whiro Auditor]
              │    ├─ Validates cultural compliance
              │    ├─ Checks for sensitive content
              │    ├─ Generates audit report
              │    └─ Marks status
              │
              └─→ [Supabase Storage]
                   ├─ tiwhanawhana.task_queue
                   ├─ tiwhanawhana.mauri_logs
                   └─ [audit_logs] (from Whiro)
```

---

## 📂 Folder Structure

```
project-root/
├── kaitiaki-intake/          ← Your document source
│   ├── active/               ← Documents to process
│   ├── raw/
│   └── raw_archive/
│
├── kaitiaki-dashboard/       ← Monitoring UI
│
└── backend/
    └── routes/tiwhanawhana/
        ├── intake_bridge.py  ← NEW: Scans and processes
        ├── intake.py         ← NEW: FastAPI endpoints
        ├── ocr.py
        ├── translate.py
        ├── embed.py
        ├── memory.py
        └── mauri.py
```

**No duplicates needed** - clean setup! ✅

---

## 🚀 Getting Started

### Step 1: Add Documents to Intake Folder
```bash
# Copy documents to the active folder
cp my_document.md kaitiaki-intake/active/
cp my_data.json kaitiaki-intake/active/
```

### Step 2: Start Tiwhanawhana with Intake
```bash
# Start the backend - intake routes will be available
cd backend
python3 -m uvicorn main:app --reload
```

### Step 3: Trigger Scanning
```bash
# Option A: Scan once
curl http://localhost:8000/intake/scan

# Option B: Start continuous scanning (checks every 30s)
curl -X POST http://localhost:8000/intake/start-continuous-scan

# Option C: Check status
curl http://localhost:8000/intake/status

# Option D: List documents
curl http://localhost:8000/intake/documents

# Option E: Process specific document
curl -X POST http://localhost:8000/intake/process/my_document.md
```

---

## 🔄 Data Flow Example

### Input
```markdown
# Te Reo Māori Document
This is a kaitiaki document with cultural content...
```

### Step 1: Tiwhanawhana Detects
```json
{
  "file_name": "document.md",
  "file_type": ".md",
  "size_bytes": 1024,
  "status": "received"
}
```

### Step 2: Queue to Supabase
```json
{
  "task_type": "intake_document_process",
  "status": "pending",
  "priority": 2,
  "payload": {
    "id": "intake_abc123def456",
    "file_name": "document.md",
    "full_content": "...",
    "whiro_audit_pending": true
  }
}
```

### Step 3: Whiro Audit Request
```json
{
  "task_type": "whiro_audit_document",
  "status": "pending",
  "priority": 3,
  "payload": {
    "document_id": "intake_abc123def456",
    "audit_type": "cultural_compliance",
    "request_source": "tiwhanawhana_intake_bridge"
  }
}
```

### Step 4: Results in Supabase
```json
{
  "mauri_logs": {
    "message": "Document intake_abc123def456 processed",
    "meta": {
      "file_name": "document.md",
      "whiro_audit_status": "pending"
    }
  }
}
```

---

## 🛡️ Whiro Integration (Next Step)

After this setup works, add Whiro audit processor:

```python
# backend/matua_whiro/kaitiaki/whiro/whiro_intake_auditor.py
class WhiroIntakeAuditor:
    def audit_intake_document(self, doc_id: str, content: str):
        """Audit document from intake pipeline"""
        # Check cultural sensitivity
        # Validate content
        # Generate audit report
        # Save to audit_logs
        pass
```

---

## ✅ Validation Checklist

- [ ] `kaitiaki-intake/active/` folder exists
- [ ] Documents are readable (`.md`, `.json`, `.txt`)
- [ ] Backend running with new intake routes
- [ ] `/intake/status` endpoint responds
- [ ] Supabase connection working
- [ ] Task queue table created
- [ ] Documents appearing in `task_queue` after scan
- [ ] Whiro auditor ready (next phase)

---

## 🐛 Troubleshooting

### "No documents found"
```bash
# Check folder exists
ls -la kaitiaki-intake/active/

# Add a test file
echo "# Test" > kaitiaki-intake/active/test.md
```

### "Supabase connection failed"
```bash
# Check .env variables
cat backend/.env | grep SUPABASE

# Verify MCP config
cat json/mcp.json | grep endpoint
```

### "Task not in Supabase"
```bash
# Check if table exists
curl http://localhost:8000/mauri/logs

# Manually check task_queue table
```

---

## 📊 Next: Adding Whiro Auditor

Once intake is working:

1. Enable Whiro in `backend/matua_whiro/kaitiaki/whiro/whiro_comprehensive_auditor.py`
2. Create `whiro_intake_auditor.py` to process intake audit tasks
3. Update `intake_bridge.py` to handle audit results
4. Add audit results to response

This keeps Tiwhanawhana as watchdog and Whiro as validator. ✅

