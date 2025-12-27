# Healthcare Project CLAUDE.md Header Template

**Purpose:** Standard header format for healthcare production projects to enable automatic workflow enforcement.

---

## Required Header Format

**Copy this header to the top of your project's CLAUDE.md file:**

```markdown
# Project: [Project Name]

**Current Version:** v[X.Y.Z]
**Date:** [YYYY-MM-DD]
**Project Type:** Healthcare Production ⚠️
**Enforcement:** Mandatory Workflows Required

---

## Project Overview

[Brief description of what this healthcare system does]

**Clinical Purpose:** [e.g., Early sepsis detection, patient safety monitoring, clinical decision support]
**Patient Impact:** [e.g., Reduces sepsis mortality, prevents adverse events, improves care quality]
**Compliance:** [e.g., HIPAA, Patient Safety Standards]

---

## 🛑 MANDATORY WORKFLOW ENFORCEMENT

**This is a healthcare production system. The following workflows are REQUIRED:**

### 1. Deployment Verification
- Show full deployment command before executing
- Wait for explicit approval
- See: `.standards/WORKFLOWS/DEPLOYMENT-VERIFICATION-WORKFLOW.md`

### 2. Code Review
- Show code changes before deploying
- Explain what, why, how
- Wait for user review and approval
- See: `.standards/WORKFLOWS/CODE-REVIEW-WORKFLOW.md`

### 3. Validation Gates
- STOP at every 🛑 VALIDATION subtask
- Show summary of completed work
- WAIT for user approval before proceeding
- See: `.standards/WORKFLOWS/VALIDATION-GATE-PROTOCOL.md`

**Violation History:**
- [List any documented violations with dates]
- Example: "2025-12-08 - Issue #78: Deployed without verification (8 violations)"

---

## Current Status

[Current state of the project - what's working, what's in progress]

## Environment

**Test (CERT):** [URL or access info]
**Production (PROD):** [URL or access info]

**Deployment Location:** [e.g., Azure Storage, Cerner Citrix, etc.]

---

## Recent Changes

[Summary of recent major changes - detailed changelog in CHANGELOG.md]

---
```

---

## Detection Logic

When Claude reads a project CLAUDE.md with this header:

**Primary Trigger:** `**Project Type:** Healthcare Production`

Claude will:
1. Automatically invoke `/enforce-workflows` command
2. Show explicit acknowledgment of mandatory workflows
3. Apply enforcement throughout the session
4. No user action required (automatic protection)

---

## Example: Sepsis Dashboard

```markdown
# Project: Sepsis Dashboard

**Current Version:** v21.0.0
**Date:** 2025-12-09
**Project Type:** Healthcare Production ⚠️
**Enforcement:** Mandatory Workflows Required

---

## Project Overview

Real-time sepsis detection and monitoring dashboard for emergency department clinical staff.

**Clinical Purpose:** Early sepsis detection and intervention tracking
**Patient Impact:** Reduces sepsis mortality through faster identification and treatment
**Compliance:** HIPAA, Patient Safety Standards, Clinical Quality Measures

---

## 🛑 MANDATORY WORKFLOW ENFORCEMENT

[... enforcement section as shown above ...]

---

## Current Status

v21 deployed to production. Frontend and backend working correctly with improved antibiotic detection.

## Environment

**Test (CERT):** https://cert.example.com/sepsis-dashboard
**Production (PROD):** https://prod.example.com/sepsis-dashboard

**Deployment Location:** Azure Storage (static content) + Cerner CCL backend

---
```

---

## Benefits

✅ **Self-documenting** - Anyone reading CLAUDE.md knows it's healthcare
✅ **Automatic enforcement** - No manual `/enforce-workflows` needed
✅ **Version controlled** - Project type travels with the code
✅ **No false positives** - Only triggers for explicitly marked projects
✅ **Audit trail** - Violation history documented in project file
✅ **Compliance ready** - Shows clinical purpose and patient impact

---

## How to Use

### For New Healthcare Projects:
1. Copy the header template above
2. Fill in project details
3. Save as project's CLAUDE.md
4. Enforcement will activate automatically on next session start

### For Existing Healthcare Projects:
1. Add the header to existing CLAUDE.md (at the top)
2. Keep existing content below
3. Add enforcement section if not present
4. Enforcement will activate automatically on next session start

---

**Created:** 2025-12-09
**Purpose:** Automatic healthcare production workflow enforcement via explicit project tagging
**Related:** SESSION-START-PROTOCOL.md Step 4.5
