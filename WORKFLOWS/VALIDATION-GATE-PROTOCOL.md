# TaskMaster Validation Gate Protocol

**Purpose:** Enforce mandatory approval checkpoints during development workflows

**Applies to:** ALL TaskMaster workflows with 🛑 VALIDATION gates

**Status:** MANDATORY - No exceptions for healthcare production

**Created:** 2025-12-08
**Lesson Learned:** Issue #78 - Rushed through implementation without stopping at validation gates

---

## 🛑 WHAT IS A VALIDATION GATE?

**A validation gate is a TaskMaster subtask marked with 🛑 that requires user approval before proceeding.**

**Example subtasks with validation gates:**
- `30.8: 🛑 VALIDATION: CERT validation with Casey`
- `29.7: 🛑 VALIDATION: CERT deployment and testing`
- `31.9: 🛑 SUB-WORKFLOW: Documentation sync`

**Purpose:**
- ✅ Pause development for user review
- ✅ Ensure quality before proceeding
- ✅ Get stakeholder approval (Casey, Dr. Crawford)
- ✅ Prevent rushing through critical steps

---

## 🛑 MANDATORY PROTOCOL AT VALIDATION GATES

### When Claude Reaches a Validation Gate Subtask:

**Claude MUST:**

#### Step 1: STOP Immediately

**Do NOT proceed to next subtask automatically.**
**Do NOT continue implementation.**
**PAUSE and wait for user approval.**

#### Step 2: Show Summary of Work Completed

```
🛑 VALIDATION GATE: Task X.Y - [Title]

Summary of work completed:
✅ [What was accomplished in previous subtasks]
✅ [What was built/tested/deployed]
✅ [Current state]

What needs validation:
- [What user should review/test]
- [What stakeholder should approve]
- [What criteria must be met]

Next steps after approval:
- Task X.Z: [Next subtask title]
- [What will be done next]

Ready to proceed? Reply "approved" when validation complete.
```

**Example:**
```
🛑 VALIDATION GATE: Task 30.8 - CERT Validation with Casey

Summary of work completed:
✅ Date parsing utilities implemented
✅ Temporal order validation (cultures BEFORE antibiotics)
✅ Bundle compliance tooltip created
✅ Deployed to CERT (2025-12-08T02:41 UTC)
✅ Tested with HAYNES (valid) and MILLER (violation)

What needs Casey validation:
- Tooltip accuracy and clinical relevance
- Temporal order logic correctness
- UI/UX appropriateness
- No regressions in existing functionality

Current CERT deployment:
- URL: https://ihazurestoragedev.z13.web.core.windows.net/camc-sepsis-mpage/src/index.html
- Features: Bundle compliance tooltip with temporal validation
- Version: Integration testing

Next steps after Casey approval:
- Task 30.9: Documentation sync
- Update CHANGELOG, README, CLAUDE.md
- Prepare for production deployment

Ready to proceed? Reply "approved" when Casey validates.
```

#### Step 3: WAIT for User Approval

**Claude MUST wait for:**
- User to complete validation
- User to reply "approved" or "proceed"
- User to provide stakeholder feedback

**DO NOT:**
- ❌ Assume approval
- ❌ Continue to next subtask
- ❌ Skip the gate
- ❌ Proceed because "it's working"

#### Step 4: Document Approval

**When user approves:**
```bash
task-master update-subtask --id=X.Y --prompt="User validated [date]. [Feedback if any]. Approved to proceed."
task-master set-status --id=X.Y --status=done
task-master set-status --id=X.Z --status=in-progress  # Next subtask
```

---

## 🚫 VIOLATIONS

### If Claude Skips a Validation Gate:

**Claude MUST:**
1. **STOP** when realizing the violation (or when user points it out)
2. **Acknowledge:** "I skipped validation gate X.Y without waiting for your approval. This violated the TaskMaster workflow."
3. **Show what was done without approval:**
   ```
   Work completed without validation:
   - Task X.Z: [what was done]
   - Task X.A: [what was done]
   - Deployments: [if any]
   ```
4. **Retroactive validation:** "Would you like to review this work now, or shall we revert and do it properly?"
5. **WAIT** for user decision

### Violation Consequences

**User decides:**
- Continue (accept work as-is)
- Review now (show code, validate retroactively)
- Revert (undo changes, start over at validation gate)
- End session (violation too severe)

**Violation History:**
- **2025-12-08:** Issue #78 - Skipped validation gates, rushed through Tasks 31.2-31.6 without pausing

---

## 📋 TYPES OF VALIDATION GATES

### Technical Validation Gates

**Purpose:** Ensure code works before proceeding

**Example:**
```
31.6: 🛑 VALIDATION: Test each ER unit

What to validate:
- Each of six ER units loads correct patients
- No JavaScript errors
- Performance acceptable
- Stats update correctly

Pause here: Let user test and approve before proceeding to Casey validation.
```

### Stakeholder Validation Gates

**Purpose:** Get clinical/business approval

**Example:**
```
29.7: 🛑 VALIDATION: CERT validation with Casey

What to validate:
- Clinical accuracy (are fluids detected correctly?)
- User experience (is tooltip helpful?)
- No regressions (existing features still work?)

Pause here: Wait for Casey feedback and approval.
```

### Documentation Validation Gates

**Purpose:** Ensure docs are synced and accurate

**Example:**
```
30.9: 🛑 SUB-WORKFLOW: Documentation sync

What to validate:
- CHANGELOG entry accurate and complete?
- Version numbers all match?
- Dates all match?
- README status section updated?

Pause here: User reviews docs before committing.
```

### Deployment Validation Gates

**Purpose:** Verify deployment destination and success

**Example:**
```
31.10: 🛑 VALIDATION: Deploy to CERT and verify

What to validate:
- Deployed to correct Azure account?
- Files uploaded successfully?
- User tested and confirmed working?
- Ready for Casey validation?

Pause here: User confirms deployment successful.
```

---

## ✅ HOW TO USE VALIDATION GATES EFFECTIVELY

### For Claude:

1. **Read the gate requirement** - Understand what needs validation
2. **Complete prior work** - Finish all setup before the gate
3. **STOP at the gate** - Do not proceed automatically
4. **Show summary** - Give user clear picture of current state
5. **Wait patiently** - User may take hours/days (e.g., waiting for Casey)
6. **Resume when approved** - User says "approved" → proceed to next subtask

### For User:

1. **Use gates strategically** - Place gates where approval is critical
2. **Review thoroughly** - Gates are checkpoints for your oversight
3. **Approve explicitly** - Say "approved" when ready
4. **Provide feedback** - Use gates to course-correct before too much work done

---

## 🔄 INTEGRATION WITH OTHER WORKFLOWS

**Validation gates work with:**

### Deployment Verification Workflow
```
At deployment validation gate:
→ Claude shows deployment command (Deployment Verification Workflow)
→ User approves destination
→ Claude deploys
→ User tests
→ User approves validation gate
→ Claude proceeds
```

### Code Review Workflow
```
At technical validation gate:
→ Claude shows code changes (Code Review Workflow)
→ User reviews code
→ User approves code quality
→ Claude deploys
→ User tests
→ User approves validation gate
→ Claude proceeds
```

---

## 📊 VALIDATION GATE CHECKLIST

**At each 🛑 gate, Claude completes:**

- [ ] Stopped at gate (did not proceed automatically)
- [ ] Showed summary of completed work
- [ ] Showed code changes if applicable
- [ ] Showed deployment command if applicable
- [ ] Explained what needs validation
- [ ] Waited for user approval
- [ ] Documented approval when received
- [ ] Proceeded to next subtask only after approval

**If ANY checkbox is unchecked → VIOLATION**

---

## 🎯 SUCCESS METRICS

**Validation gates are working when:**
- ✅ Claude stops at every 🛑 gate
- ✅ User has visibility into what was done
- ✅ User approves before Claude continues
- ✅ No surprises (user knows what's happening at each step)
- ✅ Issues caught early (at gates, not after deployment)

**Validation gates are failing when:**
- ❌ Claude rushes through gates without pausing
- ❌ User discovers work was done without their knowledge
- ❌ Multiple subtasks completed without user approval
- ❌ Deployments happen without user seeing code

---

**Last Updated:** 2025-12-08
**Mandatory For:** All TaskMaster workflows with 🛑 gates
**Enforcement:** Claude must follow this protocol WITHOUT EXCEPTION
