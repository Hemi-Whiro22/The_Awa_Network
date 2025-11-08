# ✅ Tiwhanawhana + Whiro Integration Checklist

## Pre-Flight (Now)

- [ ] Backend code is clean (no threading issues with agents)
- [ ] kaitiaki-intake folder at root (no duplicates)
- [ ] kaitiaki-dashboard at root (separate)
- [ ] New intake routes added to backend/routes/tiwhanawhana/
- [ ] New intake endpoints added to main.py
- [ ] Whiro template provided at WHIRO_INTAKE_TEMPLATE.py
- [ ] All documentation written (5 guides)

## Phase 1: Test Intake (This Week)

### Setup
- [ ] Copy test document to kaitiaki-intake/active/
- [ ] Start backend: `cd backend && python3 -m uvicorn main:app --reload`
- [ ] Run test script: `chmod +x test_intake.sh && ./test_intake.sh`

### Verify
- [ ] `GET /intake/status` returns 200
- [ ] `POST /intake/scan` queues documents
- [ ] Check Supabase task_queue table
- [ ] Verify entries have `task_type: "intake_document_process"`
- [ ] Verify entries have `task_type: "whiro_audit_document"`

### Document It
- [ ] Screenshot Supabase showing queued tasks
- [ ] Note any errors for troubleshooting
- [ ] Verify document ID was generated

## Phase 2: Add Whiro Auditor (Next Week)

### Prepare
- [ ] Copy WHIRO_INTAKE_TEMPLATE.py to whiro_intake_processor.py
- [ ] Update imports in whiro processor
- [ ] Add task_queue listener (reads audit tasks)

### Integrate
- [ ] Create task processor worker
- [ ] Listen for `task_type: "whiro_audit_document"`
- [ ] Process each task through auditor
- [ ] Save results to audit_logs table
- [ ] Update task_queue status to "completed"

### Verify
- [ ] Whiro processes audit tasks
- [ ] Audit results appear in audit_logs
- [ ] Audit results are visible in UI

### Test Whiro
- [ ] Add cultural document → audited for compliance
- [ ] Add english-only document → flagged
- [ ] Check audit timestamps and IDs

## Phase 3: Full Integration (Optional)

### Dashboard
- [ ] Connect kaitiaki-dashboard to intake data
- [ ] Show intake status
- [ ] Show audit results
- [ ] Show document pipeline status

### Additional Agents
- [ ] Add Rongohia for knowledge indexing
- [ ] Add Kitenga for data analysis
- [ ] Coordinate via Aotahi

### Performance
- [ ] Test with 10+ documents
- [ ] Monitor Supabase usage
- [ ] Verify no bottlenecks

## Deployment (When Ready)

- [ ] All tests passing
- [ ] Documentation complete
- [ ] Error handling working
- [ ] Logging configured
- [ ] Backup of database

---

## Success Metrics

### Phase 1 Complete When:
✅ Documents appear in Supabase task_queue
✅ Audit requests are queued
✅ No errors in logs
✅ Test script passes

### Phase 2 Complete When:
✅ Whiro processes all audit tasks
✅ Audit results appear in audit_logs
✅ All documents have audit trail
✅ UI shows audit status

### Phase 3 Complete When:
✅ Multiple agents coordinate without conflicts
✅ Dashboard shows full pipeline
✅ Performance is acceptable
✅ Error recovery works

---

## Rollback Plan

If anything breaks:

1. **Intake Routes Failed**
   ```bash
   # Remove intake from main.py
   # Comment out: from routes.tiwhanawhana import intake
   # Restart backend
   ```

2. **Supabase Connection Failed**
   ```bash
   # Check .env SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY
   # Verify MCP config json/mcp.json
   # Test connection manually
   ```

3. **Documents Not Found**
   ```bash
   # Verify kaitiaki-intake/active/ exists
   # Check file permissions
   # Add test file manually
   ```

4. **Queue Table Missing**
   ```bash
   # Run migration: backend/supabase/migrations/20251104_tiwhanawhana_schema.sql
   # Or create table manually via Supabase UI
   ```

---

## Timeline

```
NOW:
├─ Review this setup ✓
├─ Start backend
├─ Run test_intake.sh
└─ Verify in Supabase

TOMORROW:
├─ Add Whiro processor
├─ Test audit pipeline
├─ Document results

THIS WEEK:
├─ Polish integration
├─ Update dashboard
└─ Ready for production

NEXT WEEK:
├─ Add more agents (optional)
├─ Full load testing
└─ Deploy to production
```

---

## Support

**If something goes wrong:**

1. Check logs: `backend/logs/` and Supabase logs
2. Run test script: `./test_intake.sh`
3. Check Supabase tables directly
4. Verify env vars: `cat backend/.env | grep SUPABASE`
5. Test endpoints with curl

**Key Endpoints for Debugging:**
```bash
# Status
curl http://localhost:8000/intake/status | python3 -m json.tool

# List documents
curl http://localhost:8000/intake/documents | python3 -m json.tool

# Health
curl http://localhost:8000/ | python3 -m json.tool

# Mauri logs
curl http://localhost:8000/mauri/logs | python3 -m json.tool
```

---

## Notes

- Keep it simple - Phase 1 focus on intake/queue
- One agent at a time - Whiro next, others later
- Test frequently - Don't wait to end
- Document as you go - Makes troubleshooting easier
- Backup before big changes

You've got this! 🌊

