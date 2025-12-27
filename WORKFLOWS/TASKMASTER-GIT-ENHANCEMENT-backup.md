# TaskMaster Workflow: Git Enhancement (Issue → Branch → Tag)

**Purpose:** Complete git workflow from issue creation to release tagging

**When to use:** For any new feature, bug fix, or enhancement

**Duration:** Varies based on work complexity (framework takes 15-30 min, actual work time excluded)

**Follows:** Git Workflow standards from GIT-WORKFLOW.md

---

## Overview

This workflow ensures proper Issue → Branch → Tag linkage with documentation sync and user validation at key points.

**Workflow Phases:**
1. Planning (Issue creation)
2. Setup (Branch creation)
3. Development (Your work here)
4. Documentation (Auto-sync)
5. Integration (Merge and tag)
6. Cleanup (Branch deletion)

---

## Task List

### Task 1: Create GitHub Issue

**Action:** Create issue describing the enhancement

**Command:**
```bash
gh issue create \
  --title "[Brief description]" \
  --body "[Detailed description of what and why]"
```

**Prompt to User:**
```
What is the title of this enhancement?
What is the detailed description?
```

**Dependencies:** None

**Validation:** 🛑 USER REVIEW REQUIRED

**Approval Prompt:**
```
GitHub issue created: #N

Title: [title]
Body: [body]

Please review the issue at: https://github.com/[user]/[repo]/issues/N

Is this issue description accurate?
Reply "approved" to continue, or provide revisions.
```

**Output:** GitHub issue number (e.g., #12)

**TaskMaster Instructions:**
- Execute gh issue create with user input
- Capture issue number
- Pause for user review
- Block all subsequent tasks until approved

---

### Task 2: Determine Version Number

**Action:** Determine next version based on change type

**Prompt to User:**
```
What type of change is this enhancement?

- patch (bug fix, corrections): v1.7.2 → v1.7.3
- minor (new feature, enhancement): v1.7.2 → v1.8.0
- major (breaking change): v1.7.2 → v2.0.0

Please specify: patch, minor, or major
```

**Dependencies:** Task 1 APPROVED

**Validation:** 🛑 USER INPUT REQUIRED

**Output:** Next version number (e.g., v1.7.3)

**TaskMaster Instructions:**
- Get latest tag with: `git tag --sort=-version:refname | head -1`
- Present current version to user
- Wait for user to specify increment type
- Calculate next version
- Block Task 3 until complete

---

### Task 3: Create Feature Branch

**Action:** Create and checkout feature branch

**Branch naming:** `type/vX.Y.Z-description`

**Command:**
```bash
# Ensure we're on updated main
git checkout main
git pull origin main

# Create feature branch
git checkout -b [type]/v[X.Y.Z]-[description]
```

**Examples:**
- `fix/v1.7.3-viewpoint-compatibility`
- `feature/v1.8.0-export-to-excel`
- `breaking/v2.0.0-api-restructure`

**Dependencies:** Task 2

**Validation:** None (automatic)

**Output:** Feature branch created and checked out

**TaskMaster Instructions:**
- Use version from Task 2
- Derive type from version increment (patch=fix, minor=feature, major=breaking)
- Extract description from issue title
- Create branch
- Cannot start until Task 2 complete

---

### Task 4-N: Development Work

**Action:** This is where actual development happens

**Note:** This is NOT a single task - user does their work:
- Make code changes
- Test changes
- Can make multiple commits on the feature branch
- May take hours/days

**Dependencies:** Task 3

**Validation:** 🛑 USER SIGNALS COMPLETE

**Completion Signal:**
```
When your development work is complete and tested, tell TaskMaster:
"Development work is complete and ready for review"
```

**Output:** Working code on feature branch

**TaskMaster Instructions:**
- This is a placeholder task
- Don't time-box it - user works at their own pace
- User explicitly signals when ready to proceed
- Block Task N+1 until user signals complete

---

### Task N+1: Work Completion Validation

**Action:** Review what was accomplished

**Prompt to User:**
```
Development work summary:
- Files modified: [list]
- Commits made: [count]
- Current branch: [branch-name]

Please confirm:
1. All changes are complete
2. Code has been tested
3. No console errors
4. Ready to proceed with documentation sync

Reply "approved" to continue, or "wait" if more work needed.
```

**Dependencies:** Task 4-N (development complete signal)

**Validation:** 🛑 USER APPROVAL REQUIRED

**Output:** User approval that work is complete

**TaskMaster Instructions:**
- Show git log since branching
- Show git diff summary
- PAUSE for user approval
- Block Task N+2 until approved
- If "wait", allow user to continue work and re-trigger this task

---

### Task N+2: Run Documentation Sync Workflow

**Action:** Execute the doc-sync workflow as sub-workflow

**Sub-Workflow:** TASKMASTER-DOC-SYNC.md

**Dependencies:** Task N+1 APPROVED

**Validation:** Per doc-sync workflow (2 validation gates)

**Output:** All documentation files synchronized

**TaskMaster Instructions:**
- Load TASKMASTER-DOC-SYNC.md workflow
- Execute all 8 tasks from that workflow
- Honor all validation gates in sub-workflow
- Block Task N+3 until sub-workflow complete

---

### Task N+3: Review Changes Before Merge

**Action:** Show complete change summary

**Display:**
```
Ready to merge feature branch to main:

Branch: [branch-name]
Commits: [count]
Files changed: [list]
Documentation: ✅ Synchronized

Changes summary:
[git log --oneline since main]
[git diff --stat main...HEAD]

Ready to merge?
```

**Dependencies:** Task N+2 (doc-sync complete)

**Validation:** 🛑 USER APPROVAL REQUIRED

**Output:** User approval to merge

**TaskMaster Instructions:**
- Show complete git summary
- PAUSE for user approval
- Block Task N+4 until approved

---

### Task N+4: Merge to Main

**Action:** Merge feature branch to main

**Command:**
```bash
git checkout main
git pull origin main  # Ensure main is current
git merge --no-ff [branch-name]
```

**Dependencies:** Task N+3 APPROVED

**Validation:** None (automatic)

**Output:** Feature branch merged to main

**TaskMaster Instructions:**
- Use --no-ff to preserve branch history
- Check for merge conflicts
- If conflicts, pause and alert user
- Block Task N+5 until merge complete

---

### Task N+5: Tag Release

**Action:** Create annotated git tag

**Command:**
```bash
git tag -a v[X.Y.Z] -m "[Brief description]

[Details of changes]

Closes #[N]"
```

**Dependencies:** Task N+4

**Validation:** None (automatic)

**Output:** Git tag created

**TaskMaster Instructions:**
- Use version from Task 2
- Use issue number from Task 1
- Include "Closes #N" to auto-close issue
- Create annotated tag (not lightweight)
- Block Task N+6 until complete

---

### Task N+6: Push to GitHub

**Action:** Push main branch and tags

**Command:**
```bash
git push origin main --tags
```

**Dependencies:** Task N+5

**Validation:** 🛑 USER APPROVAL REQUIRED

**Approval Prompt:**
```
Ready to push to GitHub:
- Branch: main
- Tag: v[X.Y.Z]
- Issue: Will close #[N]

This will make changes public.
Reply "approved" to push.
```

**Output:** Changes pushed to remote repository

**TaskMaster Instructions:**
- Show what will be pushed
- PAUSE for user approval
- Block Task N+7 until approved
- After push, verify success

---

### Task N+7: Verify Issue Closed

**Action:** Verify GitHub issue auto-closed

**Command:**
```bash
gh issue view [N]
```

**Dependencies:** Task N+6

**Validation:** None (verification only)

**Output:** Confirmation that issue is closed

**TaskMaster Instructions:**
- Check issue status
- Should show "closed" due to "Closes #N" in tag
- If not closed, alert user
- Block Task N+8 until verified

---

### Task N+8: Delete Feature Branch (Local)

**Action:** Delete local feature branch

**Command:**
```bash
git branch -d [branch-name]
```

**Dependencies:** Task N+7

**Validation:** None (automatic cleanup)

**Output:** Local branch deleted

**TaskMaster Instructions:**
- Use -d (safe delete - won't delete if not merged)
- If deletion fails, alert user
- Block Task N+9 until complete

---

### Task N+9: Delete Feature Branch (Remote)

**Action:** Delete remote feature branch

**Command:**
```bash
git push origin --delete [branch-name]
```

**Dependencies:** Task N+8

**Validation:** 🛑 USER APPROVAL REQUIRED

**Approval Prompt:**
```
Local branch deleted successfully.

Delete remote branch: origin/[branch-name]?

This is cleanup - remote branch is no longer needed since changes are merged.
Reply "approved" to delete, or "skip" to keep remote branch.
```

**Output:** Remote branch deleted (or skipped)

**TaskMaster Instructions:**
- PAUSE for user approval
- If "skip", mark complete without deleting
- If "approved", delete remote branch
- Block Task N+10 until complete or skipped

---

### Task N+10: Workflow Complete Summary

**Action:** Display completion summary

**Display:**
```
✅ Git Enhancement Workflow Complete!

Summary:
- Issue: #[N] (closed)
- Version: v[X.Y.Z]
- Branch: [branch-name] (merged and deleted)
- Tag: v[X.Y.Z] (pushed)
- Documentation: Synchronized

Next steps:
- Monitor issue for stakeholder feedback
- Prepare for deployment if needed
- Update project status if needed
```

**Dependencies:** Task N+9

**Validation:** None (summary only)

**Output:** Workflow completion confirmation

**TaskMaster Instructions:**
- Show complete summary
- Mark workflow as complete
- Clear task list

---

## Workflow Phases Summary

```
PLANNING
├─ Task 1: Create GitHub Issue [VALIDATION GATE]
└─ Task 2: Determine Version [USER INPUT]

SETUP
└─ Task 3: Create Feature Branch

DEVELOPMENT
└─ Task 4-N: Your work here [VALIDATION GATE when complete]

VALIDATION
└─ Task N+1: Confirm work complete [VALIDATION GATE]

DOCUMENTATION
└─ Task N+2: Run doc-sync workflow [Sub-workflow with 2 VALIDATION GATES]

PRE-MERGE
└─ Task N+3: Review changes [VALIDATION GATE]

INTEGRATION
├─ Task N+4: Merge to main
└─ Task N+5: Tag release

PUBLICATION
└─ Task N+6: Push to GitHub [VALIDATION GATE]

VERIFICATION
└─ Task N+7: Verify issue closed

CLEANUP
├─ Task N+8: Delete local branch
├─ Task N+9: Delete remote branch [VALIDATION GATE]
└─ Task N+10: Summary

Total Validation Gates: 6
```

---

## Success Criteria

When this workflow completes:
- ✅ GitHub issue created and auto-closed
- ✅ Feature branch created, merged, and deleted
- ✅ Documentation synchronized (CHANGELOG, CLAUDE.md, README.md)
- ✅ Release tagged with proper message
- ✅ Changes pushed to GitHub
- ✅ Clean repository state

---

## Customization

**For simpler workflows:**
- Skip some validation gates (make them automatic)
- Combine steps (e.g., merge + tag in one task)

**For more complex workflows:**
- Add testing tasks (unit tests, integration tests)
- Add code review task
- Add deployment tasks
- Add notification tasks (email team, update Slack)

---

## Integration Points

**Integrates with:**
- TASKMASTER-DOC-SYNC.md (called as sub-workflow)
- GIT-WORKFLOW.md (follows those standards)
- PRE-COMMIT-CHECKLIST.md (ensures quality)
- VERSIONING.md (semantic versioning rules)

**Can be customized for:**
- Hotfix workflow (emergency production fixes)
- Release workflow (major version releases)
- Documentation-only workflow (skip development phase)

---

**Created:** 2025-10-10
**Version:** 1.0
**Based on:** `.standards/GIT-WORKFLOW.md` standards
