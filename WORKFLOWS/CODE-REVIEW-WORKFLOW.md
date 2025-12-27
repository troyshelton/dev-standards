# Code Review Workflow

**Purpose:** Ensure user visibility into code changes before deployment to production environments

**Applies to:** Healthcare production systems, critical infrastructure, any code the user didn't write

**Status:** MANDATORY - User must review and approve code before deployment

**Created:** 2025-12-08
**Lesson Learned:** Issue #78 - User validated UI blindly without seeing code changes

---

## 🛑 WHY CODE REVIEW IS MANDATORY

### Healthcare Context

1. **Safety:** User must understand what code does before production
2. **Quality:** User can catch logic errors, inefficiencies, security issues
3. **Knowledge Transfer:** User learns the implementation (not black box)
4. **Compliance:** Audit trail requires documented code review and approval
5. **Trust:** User maintains control and understanding of their systems

### What Happens Without Code Review

**Issue #78 Example:**
- Claude implemented ER patient lists (~500 lines of code)
- Deployed to CERT multiple times
- User could only validate UI (blind testing)
- User didn't see: Service methods, event handlers, CCL queries, data flow
- **User had no visibility into WHAT was built or HOW it worked**

**This is unacceptable for healthcare production.**

---

## 🛑 MANDATORY CODE REVIEW PROCESS

### Step 1: Show Code Changes BEFORE Deployment

**Claude MUST show:**

#### Option A: Git Diff (Preferred for existing files)
```
I've made the following changes to PatientListService.js:

```diff
+ async getERUnitPatients(trackingGroupCd) {
+     // Call ER census CCL
+     const censusParams = ['MINE', trackingGroupCd];
+     censusParams.rawStart = 1;
+     const response = await sendCclRequest('1_cust_mp_gen_get_er_encntrs', censusParams);
+     // ... extract encounter IDs and pass to get_pdata
+ }
```

Lines added: 335-416 (82 lines)
Purpose: Load ER patients by tracking group instead of patient list
```

#### Option B: Full Code Section (For new files or major changes)
```
I've created a new CCL program: 1_cust_mp_gen_get_er_encntrs.prg

Key sections:
1. Tracking tables query (lines 47-73)
2. Filter by tracking group (line 66)
3. Return encounter IDs (lines 88-97)

[Show the actual code or key sections]

This program gets active ER patients for the selected tracking group.
```

#### Option C: Summary with Code Highlights (For minor changes)
```
I've made 3 changes to main.js:

1. Line 2804: Added ER unit event handler
   [show code snippet]

2. Lines 3007-3039: Created loadERUnitData() function
   [show code snippet]

3. Line 2468: Updated auto-refresh to support ER units
   [show code snippet]

Total changes: ~50 lines added
```

### Step 2: Explain Purpose and Impact

**Claude MUST explain:**
- **What** changed (which files, which functions)
- **Why** it changed (what problem does it solve)
- **How** it works (data flow, logic)
- **Impact:** What could break? What was tested?

**Example:**
```
Purpose: Enable ER unit selection without patient lists

How it works:
1. User selects ER unit from dropdown
2. Frontend calls 1_cust_mp_gen_get_er_encntrs with tracking group code
3. CCL returns encounter IDs from tracking board
4. Frontend passes IDs to existing get_pdata program
5. Displays patients (reuses existing rendering logic)

Impact:
- New CCL program (must be compiled in CERT and Production)
- No changes to existing patient list workflow
- Adds ~400 lines to frontend

Tested:
- All six ER units load correct patients
- Refresh and auto-refresh work correctly
```

### Step 3: Wait for User Review and Approval

**User reviews:**
- Code quality
- Logic correctness
- Potential issues
- Understanding of implementation

**User responds:**
- "Approved" → Proceed with deployment
- "Change X to Y" → Make changes, show again, wait for approval
- "Explain Z" → Provide explanation, wait for approval
- "Stop" → Do not deploy

**Claude waits for approval before deploying.**

---

## 📝 CODE REVIEW SCENARIOS

### Scenario 1: Small Change (Single File, <50 lines)

**Show diff + brief explanation:**
```
Changed PatientListService.js (line 367):

- if (response.encntrRec.patients)
+ if (response.erec.patients)

Reason: CCL returns {erec: {...}} not {encntrRec: {...}}
Fixed: Response parsing to match actual JSON structure

May I deploy this fix?
```

### Scenario 2: Medium Change (Multiple Files, 50-200 lines)

**Show key changes + explanation:**
```
I've made changes to 3 files for ER unit dropdown:

1. index.html (lines 154-164): Added ER Units dropdown
   [show dropdown HTML]

2. PatientListService.js (lines 335-416): Added getERUnitPatients()
   [show function signature and key logic]

3. main.js (lines 2976-3030): Added handleERUnitChange()
   [show event handler]

Data flow: User selects ER → Calls CCL → Gets IDs → Loads patients

May I deploy these changes to CERT?
```

### Scenario 3: Large Change (New Feature, 200+ lines)

**Show architecture + key sections:**
```
I've implemented Issue #78 (ER patient lists):

Architecture:
- 1 new CCL program (109 lines)
- 3 frontend files modified (~400 lines total)
- 2-step data flow (census → patient data)

Key components:
1. CCL: 1_cust_mp_gen_get_er_encntrs.prg
   [show query structure and key filters]

2. Service: getERUnitPatients() method
   [show method signature and logic flow]

3. UI: ER Units dropdown + event handlers
   [show dropdown and event logic]

Would you like me to:
A) Show you the complete code for review
B) Deploy to CERT and you'll test the UI
C) Explain a specific section first

(Recommend: A for production healthcare code)
```

---

## 🚫 VIOLATIONS

### If Claude Deploys Code Without Review:

**Claude MUST:**
1. **STOP** when realizing the violation
2. **Acknowledge:** "I deployed code without showing you the changes first. This violated the code review workflow."
3. **Show what was deployed:**
   ```
   Files deployed without review:
   - PatientListService.js (100 lines changed)
   - main.js (400 lines changed)
   - index.html (20 lines changed)
   ```
4. **Offer:** "Would you like me to show you the changes now, or revert the deployment?"
5. **Wait** for user decision

### Violation Tracking

**Document each violation in this file:**

- **2025-12-08:** Issue #78 - Deployed ~500 lines of code without showing user the changes (8 deployments without review)

---

## ✅ WHEN CODE REVIEW CAN BE SKIPPED

**ONLY skip if:**
1. User explicitly says: "Just implement and deploy, I'll test the UI"
2. User is pair-programming and seeing changes in real-time
3. Changes are trivial (<10 lines) AND user already approved the approach

**Default:** ALWAYS show code changes before deploying.

---

## 🎯 BENEFITS OF CODE REVIEW

**For User:**
- ✅ Understands what was built
- ✅ Can catch issues before deployment
- ✅ Learns implementation techniques
- ✅ Maintains control of codebase
- ✅ Can provide feedback before it's "done"

**For Claude:**
- ✅ Gets feedback earlier (before deployment)
- ✅ Catches logic errors sooner
- ✅ Builds user trust through transparency
- ✅ Creates better code (knowing it will be reviewed)

**For Project:**
- ✅ Better code quality
- ✅ Fewer deployment cycles
- ✅ Knowledge transfer (user understands system)
- ✅ Audit trail for compliance

---

## 📚 INTEGRATION WITH TASKMASTER

**At each TaskMaster subtask completion:**

```
Task X.Y complete: [Title]

Code changes:
[Show diff or code sections]

Explanation:
[What and why]

Ready to proceed to Task X.Z?
```

**This creates natural code review checkpoints throughout development.**

---

**Last Updated:** 2025-12-08
**Mandatory For:** Healthcare production, critical infrastructure, team projects
**Enforcement:** Claude reads this at session start, follows WITHOUT EXCEPTION
