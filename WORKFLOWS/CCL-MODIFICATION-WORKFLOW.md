# CCL Modification Workflow

**Purpose:** Mandatory validation steps for ANY CCL code modification
**Created:** 2025-12-21 after BayCare wound care CCL violation
**Applies To:** ALL CCL (.prg, .inc) file modifications

---

## 🛑 MANDATORY - No Exceptions

**This workflow is REQUIRED before modifying ANY CCL code.**

**Context:** CCL (Cerner Command Language) has complex syntax rules that differ from SQL and other languages. Assumptions about CCL syntax often lead to compilation errors and broken code.

**Violation Impact:** Broken code deployed to clients, damaged professional reputation, loss of trust.

---

## Workflow Steps

### Step 1: 🛑 STOP - Do Not Edit Files

**Before making ANY CCL changes:**
- Do NOT use Edit tool yet
- Do NOT assume you know the correct syntax
- Do NOT modify files without validation

**Ask yourself:**
- Do I have a working example of this pattern?
- Have I validated this syntax against CCL references?
- Has the user approved this specific change?

**If NO to any question → STOP and follow remaining steps**

---

### Step 2: FIND Working Examples

**Locate working CCL code with similar patterns:**

**Check these projects:**
1. `/Users/troyshelton/Projects/vandalia/sepsis-dashboard/src/ccl/` - Proven production code
2. `/Users/troyshelton/Projects/cabell/` - Other CCL examples
3. Current project's `original/` directory (if exists)
4. User-provided working code

**Use Explore agent:**
```
Launch Explore agent to find similar CCL patterns in working projects
Prompt: "Find examples of [specific pattern] in CCL files across projects"
```

**Reference guides:**
- `/Users/troyshelton/Projects/CCL_REFERENCE/CCL_SYNTAX_GUIDE.md`
- `/Users/troyshelton/Projects/CCL_REFERENCE/CCL_COMMON_PATTERNS.md`
- Oracle Cerner Data Model Reports (for table schemas)

---

### Step 3: COMPARE - Show Side-by-Side

**Create comparison for user review:**

**Format:**
```markdown
## Proposed CCL Change

### Current Code:
```ccl
[current code snippet]
```

### Proposed Change:
```ccl
[proposed code snippet]
```

### Working Example (from [project name]):
```ccl
[working example that proves this pattern works]
```

### Reference:
- Pattern from: [file path]
- CCL Guide Section: [reference]
- Why this works: [explanation]
```

**Show user this comparison BEFORE editing any files**

---

### Step 4: EXPLAIN - Justify the Change

**Explain to user:**
1. **What** you're changing (specific lines/syntax)
2. **Why** it needs to change (problem being solved)
3. **How** it works (reference to working example)
4. **Evidence** it will work (working example from another project)

**Do NOT:**
- Assume syntax without evidence
- Make changes based on "it looks right"
- Skip validation because "it's a small change"
- Proceed without working example reference

---

### Step 5: 🛑 WAIT - Get Explicit Approval

**Wait for user response:**
- ✅ "approved" → Proceed to Step 6
- ❌ "not approved" → Stop, revise proposal
- ❓ Questions → Answer, provide more examples, revise

**Do NOT:**
- Proceed without approval
- Assume silence means approval
- Make "just one more small change" without re-approval

---

### Step 6: EDIT - Make Approved Change ONLY

**Make the change:**
- Use Edit tool with exact approved syntax
- Change ONLY what was approved
- No additional "improvements" or "cleanup" without approval

**Stay within scope:**
- If you see other issues, NOTE them but don't fix without approval
- One change at a time
- Get approval for each distinct modification

---

### Step 7: VERIFY - Show Diff

**After making change:**
```bash
git diff [file]
```

**Show user:**
- What actually changed (diff output)
- Confirm it matches approved change
- Ask: "Does this match what you approved?"

**Wait for confirmation before:**
- Committing
- Making additional changes
- Moving to next task

---

## CCL-Specific Validation Checklist

**Before ANY CCL modification:**

- [ ] Found working example of this pattern?
- [ ] Referenced CCL_SYNTAX_GUIDE.md for syntax rules?
- [ ] Checked Oracle Cerner Data Model Reports for table schemas?
- [ ] Showed proposed change to user?
- [ ] Explained why this pattern works?
- [ ] Provided working example reference?
- [ ] Got explicit "approved" confirmation?
- [ ] Made ONLY the approved change?
- [ ] Showed git diff for verification?
- [ ] Got final confirmation before commit?

**If ANY checkbox is unchecked → STOP, you're violating the workflow**

---

## Common CCL Mistakes to AVOID

**Based on documented violations:**

1. **Using SET inside report writer sections**
   - ❌ WRONG: `SET variable = value` inside SELECT/report writer
   - ✅ CORRECT: `variable = value` (simple assignment)
   - **Rule:** DECLARE and SET only outside SELECT/report writer sections

2. **Adding foot report without validation**
   - ❌ WRONG: Assuming `foot report` is always needed
   - ✅ CORRECT: Check if working examples use it
   - **Rule:** Different patterns for different report structures

3. **SQL-style JOIN syntax**
   - ❌ WRONG: `LEFT JOIN table ON condition`
   - ✅ CORRECT: `join table where condition = outerjoin(...)`
   - **Rule:** CCL JOIN syntax differs from SQL

4. **Making cleanup changes without approval**
   - ❌ WRONG: "Improving" code formatting without asking
   - ✅ CORRECT: Show proposed cleanup, get approval
   - **Rule:** All changes require validation, even formatting

---

## Validation Agent Pattern

**For complex CCL changes, use this pattern:**

```markdown
1. Launch Explore agent to find working examples
2. Launch Plan agent to design change with references
3. Show user: current code, proposed code, working example
4. Wait for approval
5. Make change
6. Verify with diff
7. Get final confirmation
```

**Agent Prompt Template:**
```
Find working examples of [CCL pattern] in:
- /Users/troyshelton/Projects/vandalia/sepsis-dashboard/src/ccl/
- /Users/troyshelton/Projects/cabell/
- Other CCL projects

Return:
- File path and line numbers
- Code snippet showing the pattern
- Explanation of why it works
```

---

## Enforcement

**This workflow is MANDATORY for:**
- ✅ All CCL file modifications (.prg, .inc, .dpb)
- ✅ Healthcare production projects
- ✅ Client-facing work
- ✅ Any specialized domain code (CCL, proprietary languages)

**Violations will be:**
- ✅ Documented in project CLAUDE.md Violation History
- ✅ Tracked with date, impact, root cause
- ✅ Used to improve workflows and prevent recurrence

---

## Success Criteria

**CCL modification is successful when:**
- ✅ Working example referenced and validated
- ✅ User approved proposed change before edit
- ✅ Change matches approved syntax exactly
- ✅ Compiles without errors
- ✅ Works in target environment (M30/Production)
- ✅ User confirms change is correct
- ✅ No negative impact on professional reputation

---

## References

**CCL Resources:**
- `/Users/troyshelton/Projects/CCL_REFERENCE/CCL_SYNTAX_GUIDE.md`
- `/Users/troyshelton/Projects/CCL_REFERENCE/CCL_COMMON_PATTERNS.md`
- `/Users/troyshelton/Projects/CCL_REFERENCE/CCL_BEGINNER.md`
- `/Users/troyshelton/Projects/CCL_REFERENCE/CCL_INTERMEDIATE.md`
- `/Users/troyshelton/Projects/CCL_REFERENCE/CCL_ADVANCED.md`

**Working Examples:**
- `/Users/troyshelton/Projects/vandalia/sepsis-dashboard/src/ccl/` - Production CCL
- `/Users/troyshelton/Projects/cabell/` - Additional examples

**Data Models:**
- `/Users/troyshelton/Projects/CCL_REFERENCE/Oracle Cerner - Millennium Data Model Reports/`

---

**Created:** 2025-12-21
**Reason:** Prevent CCL syntax violations and broken code deployment
**Mandatory:** YES - No exceptions for CCL modifications

---

*This workflow exists because assumptions about CCL syntax lead to broken code and damaged professional reputation. Follow it without exception.*
