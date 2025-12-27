# TaskMaster Workflow: Git Enhancement with Pull Requests (Issue → Branch → PR → Tag)

**Purpose:** Complete git workflow from issue creation to release tagging with full audit trail via Pull Requests

**When to use:** For any new feature, bug fix, or enhancement (healthcare/production/team development)

**Duration:** Varies based on work complexity (framework takes 15-30 min, actual work time excluded)

**Audit Trail:** Full GitHub traceability (Issue → PR → Branch → Commits → Tag)

**Follows:** Git Workflow standards from GIT-WORKFLOW.md

---

## Overview

This workflow ensures proper Issue → Branch → PR → Tag linkage with full GitHub audit trail, documentation sync, and user validation at key points.

**Workflow Phases:**
1. Planning (Issue creation)
2. Setup (Branch creation)
3. Development (Your work here)
4. Documentation (Auto-sync)
5. Pull Request (Create, review, merge)
6. Release (Tag with references)
7. Verification (Issue closed via PR)
8. Cleanup (Branch deletion)

**Key Benefit for Healthcare:** Complete audit trail in GitHub showing who approved what and when - essential for regulatory compliance.

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

### Task N+2: Azure Deployment Validation (If Applicable)

**Action:** Deploy to test/staging environment with destination verification

**NOTE:** Only applicable for projects with Azure/cloud deployments. Skip if not needed.

**Prompt to User:**
```
I'm about to deploy to Azure:

Source:      [local-path]
Destination: [azure-destination]
Account:     [storage-account-name]

Command:
az storage blob upload-batch \
  --account-name [account] \
  --destination '[destination]' \
  --source [source] \
  --overwrite --auth-mode key

⚠️ CRITICAL: Is this the correct destination?

Please verify the destination path is correct.
Reply "approved" to deploy, or provide the correct destination.
```

**Dependencies:** Task N+1 APPROVED

**Validation:** 🛑 DEPLOYMENT DESTINATION VERIFICATION REQUIRED

**Output:** Files deployed to verified correct location

**TaskMaster Instructions:**
- ALWAYS show full deployment command before executing
- MUST get user approval of destination path
- PAUSE for explicit user confirmation
- If destination incorrect, update and re-prompt
- Execute deployment only after approval
- Block Task N+3 until deployment validated in environment

**Post-Deployment Validation:**
```
Deployment complete: [file-count] files uploaded

Environment URL: [test-url]

Please test the deployed application and verify:
1. All features working correctly
2. No console errors
3. Visual styling correct
4. Data displaying properly

Reply "validated" to continue, or report issues.
```

---

### Task N+3: Run Documentation Sync Workflow

**Action:** Execute the doc-sync workflow as sub-workflow

**Sub-Workflow:** TASKMASTER-DOC-SYNC.md

**Dependencies:** Task N+2 (deployment validated, if applicable)

**Validation:** Per doc-sync workflow (2 validation gates)

**Output:** All documentation files synchronized

**TaskMaster Instructions:**
- Load TASKMASTER-DOC-SYNC.md workflow
- Execute all 8 tasks from that workflow
- Honor all validation gates in sub-workflow
- Block Task N+4 until sub-workflow complete

---

### Task N+4: Push Feature Branch to Remote

**Action:** Push feature branch to GitHub for PR creation

**Command:**
```bash
git push -u origin [branch-name]
```

**Dependencies:** Task N+3 (doc-sync complete)

**Validation:** None (automatic)

**Output:** Feature branch pushed to remote

**TaskMaster Instructions:**
- Push current feature branch
- Use -u to set upstream tracking
- Block Task N+5 until pushed

---

### Task N+5: Create Pull Request

**Action:** Create GitHub Pull Request from feature branch

**Command:**
```bash
gh pr create \
  --base main \
  --head [branch-name] \
  --title "[Brief title matching issue]" \
  --body "## Summary
[Description of changes]

## Related Issue
Closes #[N]

## Changes Made
- [List key changes]

## Testing
- [x] Local testing complete
- [x] CERT/Azure validated
- [x] Documentation synchronized

🤖 Generated with Claude Code"
```

**Dependencies:** Task N+4

**Validation:** 🛑 USER REVIEW REQUIRED

**Approval Prompt:**
```
Pull Request created: PR #M

Title: [title]
Branch: [branch-name] → main
Closes: #[N]

View PR at: https://github.com/[user]/[repo]/pull/M

Please review the PR description.
Reply "approved" to continue, or provide revisions.
```

**Output:** PR number (e.g., #7)

**TaskMaster Instructions:**
- Create PR with proper formatting
- Include "Closes #N" to link issue
- Capture PR number
- PAUSE for user review
- Block Task N+6 until approved

---

### Task N+6: PR Review and Approval

**Action:** Wait for PR approval (self-approval for solo, or team review)

**For Solo Development:**
```
PR #M is ready for your review.

Review checklist:
- Code changes look correct
- Documentation updated
- CERT validated
- No console errors

Reply "approved" to merge, or "revisions needed" to continue work.
```

**For Team Development:**
```
PR #M created and awaiting team review.

Reviewers needed: [team members]

Request reviews with:
gh pr review [PR#] --approve --body "LGTM"

Or wait for team members to review via GitHub.

Reply "approved" when PR has required approvals.
```

**Dependencies:** Task N+5 APPROVED

**Validation:** 🛑 PR APPROVAL REQUIRED

**Output:** PR approved and ready to merge

**TaskMaster Instructions:**
- For solo: Self-approval gate
- For team: Wait for GitHub approvals
- Check PR status: `gh pr view [M]`
- PAUSE until approved
- Block Task N+7 until PR approved

---

### Task N+7: Merge Pull Request

**Action:** Merge approved PR to main

**Command:**
```bash
gh pr merge [M] --squash --delete-branch
```

**Options:**
- `--squash`: Squash commits (clean history)
- `--merge`: Keep all commits (full history)
- `--rebase`: Rebase commits (linear history)

**Dependencies:** Task N+6 (PR approved)

**Validation:** None (automatic)

**Output:** PR merged, feature branch auto-deleted on GitHub

**TaskMaster Instructions:**
- Use merge strategy appropriate for project
- Default: --squash for clean history
- GitHub auto-deletes remote branch
- Block Task N+8 until merged

---

### Task N+8: Tag Release

**Action:** Create annotated git tag

**Command:**
```bash
git tag -a v[X.Y.Z] -m "[Brief description]

[Details of changes]

Closes #[N]"
```

**Dependencies:** Task N+7

**Validation:** None (automatic)

**Output:** Git tag created

**TaskMaster Instructions:**
- Use version from Task 2
- Use issue number and PR number
- Include "Closes #[N]" AND "PR #[M]" references
- Create annotated tag (not lightweight)
- Tag message format: "[title]\n\n[changes]\n\nCloses #[N]\nPR: #[M]"
- Block Task N+9 until complete

---

### Task N+9: Create GitHub Release

**Action:** Create GitHub Release from tag with release notes

**Command:**
```bash
gh release create v[X.Y.Z] \
  --title "v[X.Y.Z] - [Title]" \
  --notes "[Release notes from CHANGELOG.md]"
```

**Example:**
```bash
gh release create v1.7.0 \
  --title "v1.7.0 - Oracle JET CDN with Fallback" \
  --notes "$(sed -n '/## \[1.7.0\]/,/## \[1.6.1\]/p' CHANGELOG.md | head -n -1)"
```

**Dependencies:** Task N+8

**Validation:** None (automatic)

**Output:** GitHub Release created with formatted notes

**Benefits:**
- User-friendly release page on GitHub
- Stakeholders can view changes without technical knowledge
- Download links for source code at that version
- Professional project presentation

**TaskMaster Instructions:**
- Extract release notes from CHANGELOG.md for the version
- Create GitHub Release using `gh release create`
- Include version number in title
- Use markdown-formatted notes from CHANGELOG
- Block Task N+10 until complete

---

### Task N+10: Push Tags to GitHub

**Action:** Push git tags to remote

**Command:**
```bash
git push origin --tags
```

**Dependencies:** Task N+9

**Validation:** None (automatic - already approved via PR merge)

**Output:** Tags pushed to remote repository

**TaskMaster Instructions:**
- Push tags only (main already pushed via PR merge)
- Verify tag pushed successfully
- Block Task N+11 until complete

---

### Task N+11: Verify Issue Closed

**Action:** Verify GitHub issue auto-closed

**Command:**
```bash
gh issue view [N]
```

**Expected Display:**
```
Issue #[N]: [title]
Status: CLOSED
Linked PR: #[M]
Branch: [branch-name]
Tag: v[X.Y.Z]
```

**Dependencies:** Task N+10

**Validation:** None (verification only)

**Output:** Confirmation that issue is closed with full audit trail

**TaskMaster Instructions:**
- Check issue status (should show "closed" via PR merge)
- Verify issue shows linked PR
- Verify PR shows branch name
- Complete audit trail visible
- Block Task N+12 until verified

---

### Task N+12: Delete Feature Branch (Local)

**Action:** Delete local feature branch (cleanup)

**Command:**
```bash
git branch -d [branch-name]
```

**Dependencies:** Task N+11

**Validation:** None (automatic cleanup)

**Output:** Local branch deleted

**Note:** Remote branch already deleted by `gh pr merge --delete-branch`

**TaskMaster Instructions:**
- Use -d (safe delete - won't delete if not merged)
- Remote branch already deleted via PR merge
- If deletion fails, alert user
- Block Task N+13 until complete

---

### Task N+13: Workflow Complete Summary

**Action:** Display completion summary

**Display:**
```
✅ Git Enhancement Workflow Complete!

Summary:
- Issue: #[N] (closed)
- Pull Request: #[M] (merged)
- Branch: [branch-name] (merged and deleted)
- Version: v[X.Y.Z]
- Tag: v[X.Y.Z] (pushed)
- Documentation: Synchronized

Audit Trail:
- View issue: gh issue view [N]
- View PR: gh pr view [M]
- View code changes: git show v[X.Y.Z]
- View diff from previous: git diff v[X.Y.Z-1]..v[X.Y.Z]

Next steps:
- Monitor issue for stakeholder feedback
- Prepare for deployment if needed
- Update project status if needed
```

**Dependencies:** Task N+11

**Validation:** None (summary only)

**Output:** Workflow completion confirmation with audit trail links

**TaskMaster Instructions:**
- Show complete summary with PR reference
- Provide commands for future traceability
- Mark workflow as complete
- Clear task list

---

## Workflow Phases Summary (WITH PULL REQUEST)

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

DEPLOYMENT (If Applicable)
└─ Task N+2: Azure/Cloud Deployment [VALIDATION GATE - destination verification]

DOCUMENTATION
└─ Task N+3: Run doc-sync workflow [Sub-workflow with 2 VALIDATION GATES]

PULL REQUEST
├─ Task N+4: Push branch to remote
├─ Task N+5: Create Pull Request [VALIDATION GATE]
├─ Task N+6: PR Review and Approval [VALIDATION GATE]
└─ Task N+7: Merge Pull Request

RELEASE
├─ Task N+8: Tag release
└─ Task N+9: Push tags

VERIFICATION
└─ Task N+10: Verify issue closed (with PR link)

CLEANUP
├─ Task N+11: Delete local branch
└─ Task N+12: Summary

Total Validation Gates: 8 (includes deployment destination verification)
```

---

## Success Criteria

When this workflow completes:
- ✅ GitHub issue created and auto-closed (via PR merge)
- ✅ Pull Request created, reviewed, and merged
- ✅ Feature branch created, merged, and deleted (local + remote)
- ✅ Documentation synchronized (CHANGELOG, CLAUDE.md, README.md)
- ✅ Release tagged with proper message (references Issue + PR)
- ✅ Changes pushed to GitHub with full audit trail
- ✅ Clean repository state

## Audit Trail Benefits

**When you ask "What did we do for Issue #6?":**

```bash
# View issue - shows PR link, branch name, commits
gh issue view 6

# View PR - shows code review, approvals, diff
gh pr view 7

# View code at that version
git show v1.29.0-sepsis

# View changes from previous version
git diff v1.28.0-sepsis..v1.29.0-sepsis
```

**GitHub UI shows complete trail:**
- Issue → linked PR → branch → commits → reviewers → tag
- Perfect for healthcare audit requirements

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
**Updated:** 2025-10-15
**Version:** 2.1 (WITH PULL REQUESTS + Azure Deployment Validation Gate)
**Based on:** `.standards/GIT-WORKFLOW.md` standards
