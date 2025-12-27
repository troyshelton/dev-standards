# Healthcare Production Enforcement Flow

**Created:** 2025-12-09
**Purpose:** Visual guide showing how mandatory workflow enforcement activates

---

## Complete Detection & Enforcement Flow

```
User says: "resume [project-name]"
          |
          v
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Read Project CLAUDE.md                               │
└─────────────────────────────────────────────────────────────┘
          |
          v
┌─────────────────────────────────────────────────────────────┐
│ Step 2: Check for Project Type Flag                          │
│                                                               │
│ Looking for: **Project Type:** Healthcare Production         │
└─────────────────────────────────────────────────────────────┘
          |
          ├──────────────────────────────────────────────┐
          |                                              |
     ✅ FOUND                                      ❌ NOT FOUND
          |                                              |
          v                                              v
┌─────────────────────────┐              ┌──────────────────────────┐
│ PRIMARY PATH (Best)     │              │ Check Fallback Triggers  │
│                         │              │                          │
│ Auto-invoke:            │              │ 1. Path keywords?        │
│ /enforce-workflows      │              │ 2. CLAUDE.md keywords?   │
│                         │              │ 3. User said "healthcare"│
│ Show acknowledgment     │              └──────────────────────────┘
│                         │                          |
│ ✅ Enforcement Active   │              ┌───────────┴──────────┐
└─────────────────────────┘              |                      |
                                    ✅ TRIGGER       ❌ NO TRIGGER
                                    MATCHED          MATCHED
                                         |                |
                                         v                v
                          ┌──────────────────────┐  ┌─────────────────────┐
                          │ FALLBACK PATH        │  │ UNKNOWN PROJECT PATH│
                          │                      │  │                     │
                          │ Auto-invoke:         │  │ Step 4.6 Activates  │
                          │ /enforce-workflows   │  │                     │
                          │                      │  │ Ask user:           │
                          │ Show acknowledgment  │  │ "Is this healthcare │
                          │                      │  │  production?"       │
                          │ ✅ Enforcement Active│  │                     │
                          └──────────────────────┘  └─────────────────────┘
                                                              |
                                                    ┌─────────┴─────────┐
                                                    |                   |
                                              USER: "yes"         USER: "no"
                                                    |                   |
                                                    v                   v
                                      ┌──────────────────────┐  ┌──────────────┐
                                      │ MANUAL ACTIVATION    │  │ NO ENFORCEMENT│
                                      │                      │  │              │
                                      │ Invoke:              │  │ Continue with│
                                      │ /enforce-workflows   │  │ normal       │
                                      │                      │  │ workflows    │
                                      │ Show acknowledgment  │  │              │
                                      │                      │  │ Optionally   │
                                      │ Suggest adding flag  │  │ suggest      │
                                      │                      │  │ CLAUDE.md    │
                                      │ ✅ Enforcement Active│  └──────────────┘
                                      └──────────────────────┘
```

---

## Three Enforcement Paths

### 🥇 PRIMARY PATH: Explicit Project Type Flag

**Trigger:** `**Project Type:** Healthcare Production` in CLAUDE.md

**What Happens:**
```
✅ Automatic detection
✅ Automatic /enforce-workflows invocation
✅ Visible acknowledgment
✅ Zero user action required
✅ Works every session
```

**Example Projects:**
- ✅ sepsis-dashboard (has flag as of 2025-12-09)
- Any project using `.standards/HEALTHCARE-PROJECT-TEMPLATE.md`

**Status:** ⭐ **RECOMMENDED** - Most reliable, zero false positives/negatives

---

### 🥈 FALLBACK PATH: Keyword Detection

**Triggers:**
- Path contains: `sepsis`, `patient-safety`, `clinical-decision`
- CLAUDE.md contains: `production healthcare system`, `patient safety`, `clinical decision support`
- User says: `healthcare production` in resume command

**What Happens:**
```
⚠️ Pattern matching detection
✅ Automatic /enforce-workflows invocation
✅ Visible acknowledgment
⚠️ Risk of false positives/negatives
```

**Status:** 🛡️ **SAFETY NET** - Catches projects missing explicit flag

---

### 🥉 UNKNOWN PATH: User Decision

**Triggers:**
- No Project Type flag found AND
- No fallback triggers matched

**What Happens:**
```
❓ Claude asks: "Is this healthcare production?"
👤 User decides: yes/no
✅ If yes: Enforcement activated + suggest adding flag
❌ If no: Normal workflows
```

**Status:** 🚪 **GAP CLOSER** - Prevents unprotected healthcare projects

---

## Enforcement Acknowledgment (All Paths)

When enforcement activates, user sees:

```
🛑 HEALTHCARE PRODUCTION ENFORCEMENT ACTIVATED

I have automatically loaded and will follow these MANDATORY workflows:

✅ Deployment Verification
   - Show full deployment command (source, destination, account)
   - Wait for "approved" before executing
   - See: .standards/WORKFLOWS/DEPLOYMENT-VERIFICATION-WORKFLOW.md

✅ Code Review
   - Show code changes before deploying
   - Explain what, why, how
   - Wait for user review and approval
   - See: .standards/WORKFLOWS/CODE-REVIEW-WORKFLOW.md

✅ Validation Gates
   - STOP at every 🛑 TaskMaster subtask
   - Show summary of work completed
   - WAIT for user approval before proceeding
   - See: .standards/WORKFLOWS/VALIDATION-GATE-PROTOCOL.md

I acknowledge these workflows are REQUIRED. I will follow them without exception.
```

---

## Manual Override (Always Available)

**Any project, any time:**

User can run: `/enforce-workflows`

This manually activates enforcement even for non-healthcare projects (e.g., critical financial systems).

---

## Example Scenarios

### Scenario 1: First Time Resume of Sepsis Dashboard ✅

```
User: "resume sepsis-dashboard"

Claude:
  1. Reads: vandalia/sepsis-dashboard/CLAUDE.md
  2. Finds: **Project Type:** Healthcare Production
  3. Auto-invokes: /enforce-workflows
  4. Shows: 🛑 HEALTHCARE PRODUCTION ENFORCEMENT ACTIVATED
  5. Proceeds: With enforcement active

Result: ✅ Protected automatically
```

---

### Scenario 2: New Healthcare Project (No CLAUDE.md Yet) ⚠️

```
User: "start patient-portal"

Claude:
  1. Checks: No CLAUDE.md found
  2. Checks: No fallback triggers (generic name)
  3. Triggers: Step 4.6 "Unknown Project Type Check"
  4. Asks: "⚠️ Is this a healthcare production system?"

User: "yes"

Claude:
  5. Invokes: /enforce-workflows
  6. Shows: 🛑 ENFORCEMENT ACTIVATED
  7. Suggests: "Would you like me to create CLAUDE.md with healthcare header?"

User: "yes"

Claude:
  8. Creates: CLAUDE.md with Project Type flag
  9. Proceeds: With enforcement active

Result: ✅ Protected from first session, flag added for future
```

---

### Scenario 3: Old Healthcare Project (No Flag) 🛡️

```
User: "resume old-sepsis-tool"

Claude:
  1. Reads: old-sepsis-tool/CLAUDE.md
  2. No Project Type flag found
  3. Checks fallback: Path contains "sepsis" ✅
  4. Auto-invokes: /enforce-workflows
  5. Shows: 🛑 ENFORCEMENT ACTIVATED (via fallback detection)
  6. Suggests: "Consider adding Project Type flag for explicit detection"

Result: ✅ Protected by fallback (safety net worked)
```

---

### Scenario 4: Non-Healthcare Project ✅

```
User: "resume my-blog"

Claude:
  1. Reads: my-blog/CLAUDE.md
  2. No Project Type: Healthcare Production
  3. No fallback triggers
  4. Triggers: Step 4.6 "Unknown Project Type Check"
  5. Asks: "⚠️ Is this a healthcare production system?"

User: "no"

Claude:
  6. Skips enforcement
  7. Proceeds with normal workflows

Result: ✅ No false positive, normal development flow
```

---

### Scenario 5: User Unsure 🤔

```
User: "resume clinical-trial-manager"

Claude:
  1. Reads: clinical-trial-manager/CLAUDE.md
  2. No Project Type flag
  3. Checks fallback: "clinical" keyword found
  4. Hmm, ambiguous - could be healthcare or research software
  5. Triggers: Step 4.6 anyway (path contains "clinical")
  6. Auto-invokes: /enforce-workflows (safer to have it)

Alternative: If no fallback trigger...

Claude:
  5. Asks: "⚠️ Is this a healthcare production system?"

User: "I'm not sure"

Claude:
  6. Provides guidance:
     "Does it access patient data? (yes/no)
      Is it deployed in hospitals? (yes/no)
      Could errors impact patient safety? (yes/no)"

User: "Yes to patient data"

Claude:
  7. Invokes: /enforce-workflows
  8. Suggests: Adding explicit flag

Result: ✅ Guided decision, protection enabled when in doubt
```

---

## Benefits of This Flow

### ✅ Comprehensive Coverage
- Explicit flags (best case)
- Keyword fallbacks (safety net)
- User decision (gap closer)

### ✅ Zero False Negatives
- All healthcare projects get protected
- Multiple detection layers
- User override available

### ✅ Minimal False Positives
- Explicit flag is primary method (no ambiguity)
- Fallback keywords are narrow
- User decides in unclear cases

### ✅ Audit Trail
- Enforcement activation is visible
- User acknowledgment required
- Violation history tracked in CLAUDE.md

### ✅ Improvement Path
- Unknown projects → Add flag
- Fallback detections → Suggest adding flag
- Creates permanent solution over time

---

## Files Implementing This Flow

1. **SESSION-START-PROTOCOL.md** - Complete flow logic (Steps 4.5, 4.6)
2. **HEALTHCARE-PROJECT-TEMPLATE.md** - Standard header with Project Type flag
3. **sepsis-dashboard/CLAUDE.md** - Reference implementation
4. **.claude/commands/enforce-workflows.md** - Manual enforcement command

---

## Testing Checklist

- [ ] Resume sepsis-dashboard → Should auto-enforce (explicit flag)
- [ ] Resume old project with "sepsis" in path → Should auto-enforce (fallback)
- [ ] Resume project with no flag/triggers → Should ask user (Step 4.6)
- [ ] Start new healthcare project → Should ask user → Add flag
- [ ] Resume non-healthcare project → Should ask user → Skip enforcement
- [ ] Manual `/enforce-workflows` → Should work for any project

---

**Created:** 2025-12-09
**Purpose:** Document complete enforcement detection and activation flow
**Related:** SESSION-START-PROTOCOL.md Steps 4.5 & 4.6
