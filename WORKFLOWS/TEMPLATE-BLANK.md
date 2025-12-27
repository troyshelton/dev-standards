# TaskMaster Workflow: [Workflow Name]

**Purpose:** [What this workflow accomplishes]

**When to use:** [Situations where this workflow applies]

**Duration:** [Estimated time to complete]

**Created:** [Date]
**Version:** 1.0

---

## Overview

[Brief description of the workflow and its benefits]

**Workflow Phases:**
1. [Phase 1 name] ([tasks])
2. [Phase 2 name] ([tasks])
3. [Phase 3 name] ([tasks])

---

## Task List

### Task 1: [Task Name]

**Action:** [What needs to be done]

**Command/Steps:**
```bash
# Command to run (if applicable)
```

**Dependencies:** None / Task N

**Validation:** None / 🛑 USER APPROVAL REQUIRED / 🛑 USER INPUT REQUIRED

**Approval Prompt:** (if validation required)
```
[What to show user for approval]

Reply "approved" to continue, or provide feedback.
```

**Output:** [What this task produces]

**TaskMaster Instructions:**
- [Specific instructions for how TaskMaster should handle this task]
- [Any blocking/unblocking logic]
- [What to do on success/failure]

---

### Task 2: [Task Name]

**Action:** [What needs to be done]

**Command/Steps:**
```bash
# Command to run (if applicable)
```

**Dependencies:** Task 1 / Task 1 APPROVED

**Validation:** None / 🛑 USER APPROVAL REQUIRED / 🛑 USER INPUT REQUIRED

**Approval Prompt:** (if validation required)
```
[What to show user for approval]
```

**Output:** [What this task produces]

**TaskMaster Instructions:**
- [Specific instructions]
- [Dependencies must be satisfied before starting]

---

### Task 3: [Task Name]

[Continue pattern for all tasks...]

---

## Workflow Phases Summary

```
PHASE 1: [NAME]
├─ Task 1: [Name] [VALIDATION GATE if applicable]
├─ Task 2: [Name]
└─ Task 3: [Name]

PHASE 2: [NAME]
├─ Task 4: [Name] [VALIDATION GATE if applicable]
└─ Task 5: [Name]

PHASE 3: [NAME]
└─ Task 6: [Name]

Total Validation Gates: [count]
```

---

## Success Criteria

When this workflow completes:
- ✅ [Criterion 1]
- ✅ [Criterion 2]
- ✅ [Criterion 3]

---

## Error Handling

**If [error scenario]:**
- [How to recover]
- [Which task to re-run]

**If user rejects at [Task N]:**
- [How to revise]
- [Which tasks to re-execute]

---

## Integration Points

**Integrates with:**
- [Other workflow names that call this]
- [Standards documents this follows]

**Can be called as sub-workflow from:**
- [Workflow names that might include this]

---

## Customization

**For simpler use cases:**
- [Variations to simplify]

**For more complex scenarios:**
- [Extensions to add]

---

## Notes

[Any additional context, gotchas, or important information]

---

**Created:** YYYY-MM-DD
**Version:** 1.0
**Last Updated:** YYYY-MM-DD
**Tested:** [Date of last successful test run]
