# TaskMaster Workflow: Documentation Synchronization

**Purpose:** Keep CHANGELOG.md, CLAUDE.md, and README.md synchronized with current version and date

**When to use:** Before EVERY commit when version number changes

**Duration:** 5-10 minutes

**Prevents:** Documentation files getting out of sync (recurring issue)

---

## Overview

This workflow ensures all three documentation files have matching:
- Version number
- Date
- Status description

**Critical:** This has been a recurring issue. TaskMaster enforcement prevents it from happening again.

---

## Task List

### Task 1: Get Current Date

**Action:**
```bash
date '+%Y-%m-%d'
```

**Dependencies:** None

**Validation:** None (automatic)

**Output:** Current date in YYYY-MM-DD format (e.g., 2025-10-10)

**TaskMaster Instructions:**
- Auto-execute this task
- Store result for use in subsequent tasks

---

### Task 2: Determine Version Number

**Action:** Ask user for version increment type

**Prompt:**
```
What type of change is this?
- patch (bug fix): v1.7.2 → v1.7.3
- minor (new feature): v1.7.2 → v1.8.0
- major (breaking change): v1.7.2 → v2.0.0

Please specify: patch, minor, or major
```

**Dependencies:** None

**Validation:** 🛑 USER INPUT REQUIRED

**Output:** Next version number (e.g., v1.7.3)

**TaskMaster Instructions:**
- Pause for user input
- Calculate next version based on user response
- Block Task 3 until this completes

---

### Task 3: Update CHANGELOG.md

**Action:** Add new version entry at top of CHANGELOG.md

**Template:**
```markdown
## [X.Y.Z] - YYYY-MM-DD

### Fixed / Added / Changed
- **[Brief description]**
  - [Details]
  - [Impact]
  - Ref: Issue #N

### Technical Details
- [Technical explanation]
```

**Dependencies:** Tasks 1 AND 2

**Validation:** 🛑 USER APPROVAL REQUIRED

**Approval Prompt:**
```
I've added the following entry to CHANGELOG.md:

[Show the entry]

Please review the CHANGELOG entry.
Does this accurately describe the changes?
Reply "approved" to continue, or provide feedback for revisions.
```

**Output:** Updated CHANGELOG.md with new version

**TaskMaster Instructions:**
- Use date from Task 1
- Use version from Task 2
- PAUSE after adding entry
- Wait for user approval
- Block Tasks 4 and 5 until approved

---

### Task 4: Update CLAUDE.md Header

**Action:** Update CLAUDE.md lines 1-10

**Find:**
```markdown
# CLAUDE.md - [Project] v[OLD.VERSION]
...
## Current Version: v[OLD.VERSION]
**Date**: [OLD-DATE]
**Status**: [OLD-STATUS]
```

**Replace with:**
```markdown
# CLAUDE.md - [Project] v[NEW.VERSION]
...
## Current Version: v[NEW.VERSION]
**Date**: [NEW-DATE]
**Status**: [NEW-STATUS - describe current state]
```

**Dependencies:** Task 3 APPROVED

**Validation:** None (automatic once unblocked)

**Output:** Updated CLAUDE.md with new version, date, status

**TaskMaster Instructions:**
- Use version from Task 2
- Use date from Task 1
- Update status to reflect current state
- Cannot start until Task 3 is approved

---

### Task 5: Update README.md Header

**Action:** Update README.md Current Status section

**Find:**
```markdown
**Version**: v[OLD.VERSION]
**Status**: [OLD-STATUS]
**Last Updated**: [OLD-DATE]
```

**Replace with:**
```markdown
**Version**: v[NEW.VERSION]
**Status**: [NEW-STATUS]
**Last Updated**: [NEW-DATE]
```

**Dependencies:** Task 3 APPROVED

**Validation:** None (automatic once unblocked)

**Output:** Updated README.md with new version, date, status

**TaskMaster Instructions:**
- Use version from Task 2
- Use date from Task 1
- Update status to match CLAUDE.md
- Can run in parallel with Task 4 (both depend on Task 3)

---

### Task 6: Verify Synchronization

**Action:** Run verification commands

**Commands:**
```bash
# Check version consistency
echo "=== VERSION CHECK ==="
grep -m1 "^\[${NEW_VERSION}\]" CHANGELOG.md && echo "✅ CHANGELOG has v${NEW_VERSION}"
grep -m1 "Current Version: v${NEW_VERSION}" CLAUDE.md && echo "✅ CLAUDE.md has v${NEW_VERSION}"
grep -m1 "^\*\*Version\*\*: v${NEW_VERSION}" README.md && echo "✅ README.md has v${NEW_VERSION}"

echo ""
echo "=== DATE CHECK ==="
grep -m1 "${NEW_DATE}" CHANGELOG.md && echo "✅ CHANGELOG has ${NEW_DATE}"
grep -m1 "${NEW_DATE}" CLAUDE.md && echo "✅ CLAUDE.md has ${NEW_DATE}"
grep -m1 "${NEW_DATE}" README.md && echo "✅ README.md has ${NEW_DATE}"
```

**Dependencies:** Tasks 4 AND 5

**Validation:** None (automatic verification)

**Output:** Verification results showing ✅ or ❌ for each file

**TaskMaster Instructions:**
- Use version from Task 2
- Use date from Task 1
- Run all grep commands
- Display results to user
- Block Task 7 until complete

---

### Task 7: Final Approval to Commit

**Action:** Request final user approval

**Prompt:**
```
Verification Results:
[Show output from Task 6]

All documentation files are synchronized:
- Version: v[NEW_VERSION]
- Date: [NEW_DATE]

Files ready to stage:
- CHANGELOG.md
- CLAUDE.md
- README.md

Are you ready to proceed with staging these files for commit?
Reply "approved" to continue, or "wait" to make additional changes.
```

**Dependencies:** Task 6

**Validation:** 🛑 USER APPROVAL REQUIRED

**Output:** User approval to proceed

**TaskMaster Instructions:**
- Show complete verification summary
- PAUSE for user approval
- Block Task 8 until approved
- If user says "wait", allow them to make changes and re-run workflow

---

### Task 8: Stage Files for Commit

**Action:** Stage documentation files

**Command:**
```bash
git add CHANGELOG.md CLAUDE.md README.md
```

**Dependencies:** Task 7 APPROVED

**Validation:** None (automatic once unblocked)

**Output:** Files staged in git

**TaskMaster Instructions:**
- Only execute after Task 7 approval
- Stage all three documentation files
- Report success
- Workflow complete - ready for actual commit

---

## Success Criteria

When this workflow completes:
- ✅ All three files have matching version numbers
- ✅ All three files have matching dates
- ✅ User has approved CHANGELOG content
- ✅ User has approved final sync verification
- ✅ Files are staged and ready for commit

---

## Error Handling

**If verification fails (Task 6):**
- TaskMaster shows which files have ❌
- User can manually fix issues
- Re-run workflow from Task 6

**If user rejects at Task 3:**
- Revise CHANGELOG entry
- Re-run from Task 3

**If user rejects at Task 7:**
- User can make additional changes
- Re-run from Task 6 to verify again

---

## Integration with Git Workflow

**This workflow is a sub-workflow of:**
- TASKMASTER-GIT-ENHANCEMENT.md (called before merge)
- Any workflow that involves committing code

**Can also be run standalone:**
- When fixing documentation drift
- When updating project status
- Before creating release tags

---

**Created:** 2025-10-10
**Version:** 1.0
**Last Tested:** 2025-10-10 (v1.7.3 dialysis component)
