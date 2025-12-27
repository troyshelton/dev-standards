# Validated MPage Development Pattern - Standalone

**Purpose:** Development pattern for standalone MPages with CCL backend + web frontend
**Use For:** Custom MPages deployed as standalone applications
**Validation:** Two-phase (CCL user-validated, Web DevTools-validated)

---

## Overview

Standalone MPages require validation in **two phases** with a critical handoff:

1. **CCL Phase** - Backend data retrieval (user validates in Citrix/domain)
2. **Web Phase** - Frontend display (Chrome DevTools validates)
3. **Deployment Phase** - Deploy to agreed-upon location (client-specific)

---

## Task Pattern Template

```json
{
  "id": N,
  "title": "Feature Name",
  "description": "What this feature adds to the MPage",
  "status": "pending",
  "priority": "high",
  "dependencies": [],
  "subtasks": [
    {
      "id": "N.1",
      "title": "CCL PHASE: Modify Query",
      "description": "Update CCL SELECT to retrieve new data",
      "status": "pending",
      "dependencies": [],
      "details": "Add fields/joins to main CCL query. Test query in development environment first.",
      "testStrategy": "Query runs without errors in dev environment"
    },
    {
      "id": "N.2",
      "title": "CCL PHASE: Update Main CCL Program",
      "description": "Integrate query changes into main program",
      "status": "pending",
      "dependencies": ["N.1"],
      "details": "Update 1_xx_program_name.prg with validated query. Ensure _memory_reply_string JSON structure includes new fields.",
      "testStrategy": "Program compiles successfully in Discern Explorer"
    },
    {
      "id": "N.3",
      "title": "CCL PHASE: Compile CCL Program",
      "description": "Compile updated CCL program",
      "status": "pending",
      "dependencies": ["N.2"],
      "details": "Compile in Discern Explorer. Check for compilation errors. Fix if found.",
      "testStrategy": "Compilation succeeds with no errors"
    },
    {
      "id": "N.4",
      "title": "🛑 USER VALIDATION: Test CCL in Citrix",
      "description": "Run MPage and verify JSON response contains new data",
      "status": "pending",
      "dependencies": ["N.3"],
      "details": "USER MUST: Open MPage in Citrix environment, check browser DevTools Network tab, verify _memory_reply_string includes new fields with correct data.",
      "testStrategy": "JSON response visible, new fields present, data looks correct"
    },
    {
      "id": "N.5",
      "title": "WEB PHASE: Update HTML/JavaScript",
      "description": "Modify web frontend to display new data",
      "status": "pending",
      "dependencies": ["N.4"],
      "details": "Update HTML markup and JavaScript to consume new JSON fields. Add UI elements as needed.",
      "testStrategy": "Code written, no syntax errors in editor"
    },
    {
      "id": "N.6",
      "title": "WEB PHASE: Test with Live Server",
      "description": "Launch live server with updated frontend",
      "status": "pending",
      "dependencies": ["N.5"],
      "details": "Start VS Code Live Server or similar. Use mock JSON response that matches CCL output.",
      "testStrategy": "Page loads without 404 errors"
    },
    {
      "id": "N.7",
      "title": "🛑 VALIDATION: Chrome DevTools Console",
      "description": "Check for JavaScript errors",
      "status": "pending",
      "dependencies": ["N.6"],
      "details": "Use mcp__chrome-devtools__list_console_messages. Must be zero errors.",
      "testStrategy": "Console clean, new feature renders"
    },
    {
      "id": "N.8",
      "title": "🛑 VALIDATION: Visual Verification",
      "description": "Confirm feature displays correctly",
      "status": "pending",
      "dependencies": ["N.7"],
      "details": "Use mcp__chrome-devtools__take_screenshot. Verify new data displays as expected.",
      "testStrategy": "Screenshot shows feature working correctly"
    },
    {
      "id": "N.9",
      "title": "Take Screenshot",
      "description": "Document working feature",
      "status": "pending",
      "dependencies": ["N.8"],
      "details": "Save to docs/screenshots/task-N-feature-name.png"
    },
    {
      "id": "N.10",
      "title": "Commit Both CCL and Web Changes",
      "description": "Create git commit for complete feature",
      "status": "pending",
      "dependencies": ["N.9"],
      "details": "git add src/ccl/*.prg src/web/*.html src/web/*.js; commit 'feat: [description] (task N)'"
    },
    {
      "id": "N.11",
      "title": "Update Documentation",
      "description": "Document CCL and web changes",
      "status": "pending",
      "dependencies": ["N.10"],
      "details": "CHANGELOG: add feature. docs/api/: document new CCL fields. README: update if needed.",
      "testStrategy": "Both CCL and web changes documented"
    },
    {
      "id": "N.12",
      "title": "🛑 USER VALIDATION: Full Integration Test",
      "description": "Deploy to test domain and verify end-to-end",
      "status": "pending",
      "dependencies": ["N.11"],
      "details": "USER MUST: Deploy CCL program to test server. Deploy web assets to test location. Open MPage in Cerner domain. Verify feature works end-to-end.",
      "testStrategy": "Feature works in test domain, CCL + web integrated correctly"
    },
    {
      "id": "N.13",
      "title": "DEPLOYMENT: Deploy to Production",
      "description": "Deploy CCL and web assets to agreed-upon location",
      "status": "pending",
      "dependencies": ["N.12"],
      "details": "Deploy CCL program to production server. Deploy web assets to agreed-upon location (Code Warehouse, Azure, OCI, or client-specific directory). Record deployment location and date.",
      "testStrategy": "Deployed successfully, location documented"
    },
    {
      "id": "N.14",
      "title": "🛑 USER VALIDATION: Production Verification",
      "description": "Verify feature in production domain",
      "status": "pending",
      "dependencies": ["N.13"],
      "details": "USER MUST: Open MPage in production Cerner domain. Test feature with real patient data (if applicable). Verify no errors, feature works as expected.",
      "testStrategy": "Feature works in production, stakeholders can verify"
    }
  ]
}
```

---

## Key Validation Gates

### 🛑 Gate 1: CCL JSON Response (N.4)
**Who validates:** USER (in Citrix environment)
**What to check:** _memory_reply_string contains new fields
**Why it blocks:** Web changes depend on correct CCL output

### 🛑 Gate 2: Web Console (N.7)
**Who validates:** CLAUDE (via Chrome DevTools MCP)
**What to check:** Zero JavaScript errors
**Why it blocks:** Can't commit broken JavaScript

### 🛑 Gate 3: Web Visual (N.8)
**Who validates:** CLAUDE (via screenshot)
**What to check:** UI displays correctly
**Why it blocks:** Must look right before committing

### 🛑 Gate 4: Test Domain (N.12)
**Who validates:** USER (in test Cerner domain)
**What to check:** CCL + Web integration works end-to-end
**Why it blocks:** Must work in Cerner before production

### 🛑 Gate 5: Production (N.14)
**Who validates:** USER (in production domain)
**What to check:** Feature works with real data
**Why it blocks:** Final verification before stakeholder demo

---

## Deployment Locations (Flexible)

### CCL Program Deployment
```
Options:
- Cerner development server
- Cerner test server
- Cerner production server

Standard path: Discern Explorer → Compile → Deploy to domain
```

### Web Assets Deployment

**Option 1: Code Warehouse**
```
Deploy to: [Client-specific Code Warehouse directory]
Example: /cerner/codeware/custom_mpages/sepsis_dashboard/
```

**Option 2: Microsoft Azure**
```
Deploy to: Azure Blob Storage or App Service
Example: https://[account].blob.core.windows.net/mpages/
```

**Option 3: Oracle OCI**
```
Deploy to: OCI Object Storage or compute instance
Example: https://[tenancy].objectstorage.[region].oraclecloud.com/
```

**Option 4: Client-Specific Location**
```
Deploy to: As agreed upon with client
Document location in deployment task
```

**Record in subtask N.13:**
```
"details": "Deployed to [SPECIFIC LOCATION]. Date: [DATE]. Method: [METHOD]."
```

---

## Example Real-World Task

**Stakeholder Request:**
"Add vitals timestamp to Hanson table. Should show last reading time."

**TaskMaster Tasks:**

```json
{
  "id": 5,
  "title": "Add Vitals Timestamp to Hanson Table",
  "description": "Display last vitals reading time in patient table",
  "status": "pending",
  "priority": "high",
  "dependencies": ["4"],
  "subtasks": [
    {
      "id": "5.1",
      "title": "CCL: Add timestamp to query",
      "description": "Modify main query to get last_vitals_timestamp",
      "status": "pending",
      "details": "Add ce.event_end_dt_tm field to SELECT, format as readable timestamp"
    },
    {
      "id": "5.2",
      "title": "CCL: Update 1_co_sepsis_data.prg",
      "description": "Integrate timestamp into JSON response",
      "status": "pending",
      "dependencies": ["5.1"],
      "details": "Add vitalsTimestamp field to _memory_reply_string structure"
    },
    {
      "id": "5.3",
      "title": "CCL: Compile Program",
      "status": "pending",
      "dependencies": ["5.2"]
    },
    {
      "id": "5.4",
      "title": "🛑 USER: Test CCL in Dev Domain",
      "description": "Verify JSON has vitalsTimestamp",
      "status": "pending",
      "dependencies": ["5.3"],
      "details": "USER opens dev MPage, checks Network tab, confirms vitalsTimestamp present in response"
    },
    {
      "id": "5.5",
      "title": "WEB: Add Timestamp Column to Table",
      "description": "Add 'Last Vitals' column to Hanson table",
      "status": "pending",
      "dependencies": ["5.4"],
      "details": "Update table HTML/JS to display vitalsTimestamp. Format as 'MM/DD/YYYY HH:MM'"
    },
    {
      "id": "5.6",
      "title": "WEB: Test with Live Server",
      "status": "pending",
      "dependencies": ["5.5"]
    },
    {
      "id": "5.7",
      "title": "🛑 VALIDATION: Console Check",
      "status": "pending",
      "dependencies": ["5.6"]
    },
    {
      "id": "5.8",
      "title": "🛑 VALIDATION: Table Screenshot",
      "description": "Verify timestamp column displays",
      "status": "pending",
      "dependencies": ["5.7"]
    },
    {
      "id": "5.9",
      "title": "Commit Changes",
      "status": "pending",
      "dependencies": ["5.8"]
    },
    {
      "id": "5.10",
      "title": "Update Documentation",
      "status": "pending",
      "dependencies": ["5.9"]
    },
    {
      "id": "5.11",
      "title": "🛑 USER: Test in Test Domain",
      "description": "Full integration test",
      "status": "pending",
      "dependencies": ["5.10"]
    },
    {
      "id": "5.12",
      "title": "Deploy to Production (Client Location)",
      "description": "Deploy CCL and web to agreed location",
      "status": "pending",
      "dependencies": ["5.11"],
      "details": "CCL: Deploy to production Cerner. Web: Deploy to [LOCATION TBD - Azure/OCI/Code Warehouse]. Document actual location used."
    },
    {
      "id": "5.13",
      "title": "🛑 USER: Production Verification",
      "description": "Verify in production domain",
      "status": "pending",
      "dependencies": ["5.12"]
    }
  ]
}
```

---

## Benefits of Two-Phase Validation

**Prevents:**
- ❌ Deploying CCL that returns wrong data
- ❌ Deploying web code with JavaScript errors
- ❌ Integrating before individual phases work
- ❌ Production deployment before test verification

**Ensures:**
- ✅ CCL output validated before web development
- ✅ Web code validated before integration
- ✅ Integration tested before production
- ✅ Clear handoff points between Claude and user

---

**Created:** 2025-10-11
**Version:** 1.0
**Last Updated:** 2025-10-11
