# Git Worktree Workflow for Parallel Development

Guide for using Git worktrees to enable parallel development with multiple sub-agents.

---

## What Are Git Worktrees?

**Git worktrees** allow multiple working directories from the same Git repository:
- Each worktree is a separate directory
- Each can be on a different branch
- All share the same `.git` repository
- Perfect for parallel development

---

## Why Use Worktrees?

### Benefits for Sub-Agent Development:

1. **Parallel work** - Multiple features simultaneously
2. **Isolated context** - Each sub-agent gets own directory
3. **No branch switching** - Main work continues uninterrupted
4. **Complete context** - Copy standards to each worktree

---

## Basic Worktree Commands

### Create a Worktree:

```bash
# Create new worktree for feature branch
git worktree add ../feature-dashboard feature/v1.3.0-dashboard-view

# Directory structure:
# oracle-jet-mvvm-no-node-web-app/     ← main worktree (main branch)
# feature-dashboard/                   ← new worktree (feature branch)
```

### List Worktrees:

```bash
git worktree list

# Output:
# /path/to/main              abc1234 [main]
# /path/to/feature-dashboard def5678 [feature/v1.3.0-dashboard-view]
```

### Remove Worktree:

```bash
# After merging feature
git worktree remove ../feature-dashboard

# Or if directory deleted manually
git worktree prune
```

---

## Worktree + Sub-Agent Pattern

### Setup for Parallel Sub-Agent Development:

```bash
# 1. Create worktrees for each feature
git worktree add ../feature-theme feature/v1.3.0-theme-customization
git worktree add ../feature-reports feature/v1.4.0-reports-view

# 2. Copy standards to each worktree
cp -r .standards ../feature-theme/.standards
cp -r .standards ../feature-reports/.standards

# 3. Launch sub-agents (in Claude Code)
# Each sub-agent works in its own worktree with complete context
```

### Sub-Agent Context Files:

**Each worktree should have:**
```
feature-theme/
├── .standards/           ← Copied from main
│   ├── PRE-COMMIT-CHECKLIST.md
│   ├── GIT-WORKFLOW.md
│   ├── USER-VALIDATION.md
│   └── VERSIONING.md
├── CLAUDE.md            ← Project-specific instructions
├── README.md            ← Current project state
└── src/                 ← Source code
```

**Pass to sub-agent:**
- `.standards/PRE-COMMIT-CHECKLIST.md`
- `.standards/GIT-WORKFLOW.md`
- `CLAUDE.md` (project context)
- `README.md` (current state)
- Specific issue details

---

## Sub-Agent Instructions Template

When launching sub-agent for worktree:

```markdown
You are working in a Git worktree for parallel development.

**Worktree:** ../feature-dashboard
**Branch:** feature/v1.3.0-dashboard-view
**Issue:** #11 - Add dashboard view

**Context Files** (READ THESE FIRST):
1. /path/to/feature-dashboard/.standards/PRE-COMMIT-CHECKLIST.md
2. /path/to/feature-dashboard/.standards/GIT-WORKFLOW.md
3. /path/to/feature-dashboard/.standards/USER-VALIDATION.md
4. /path/to/feature-dashboard/CLAUDE.md
5. /path/to/feature-dashboard/README.md

**Your Task:**
[Specific task description]

**Requirements:**
- Follow PRE-COMMIT-CHECKLIST.md exactly
- Request user validation before committing
- Update documentation per GIT-WORKFLOW.md
- Work only in this worktree directory
- Do NOT modify main worktree

**When Done:**
- Report back what you completed
- Share screenshot/test URL for validation
- Wait for approval before committing
```

---

## Workflow Example

### Scenario: Add Dashboard and Reports in Parallel

```bash
# 1. Create GitHub issues first
gh issue create --title "Add dashboard view with charts"  # Returns #11
gh issue create --title "Add reports view with export"    # Returns #12

# 2. Create worktrees
git worktree add ../feature-v1.3.0-dashboard feature/v1.3.0-dashboard-view
git worktree add ../feature-v1.4.0-reports feature/v1.4.0-reports-view

# 3. Copy standards to each
cp -r .standards ../feature-v1.3.0-dashboard/.standards
cp -r .standards ../feature-v1.4.0-reports/.standards

# 4. Launch sub-agents in parallel (via Claude Code Task tool)
# Sub-agent 1: Work on dashboard in ../feature-v1.3.0-dashboard/
# Sub-agent 2: Work on reports in ../feature-v1.4.0-reports/

# 5. After sub-agents complete and user validates:
git worktree list  # Verify both completed

cd ../feature-v1.3.0-dashboard
git log --oneline  # Review commits

cd ../main-repo
git merge --no-ff feature/v1.3.0-dashboard-view
git tag -a v1.3.0 -m "Add dashboard\n\nCloses #11"

git merge --no-ff feature/v1.4.0-reports-view
git tag -a v1.4.0 -m "Add reports\n\nCloses #12"

# 6. Cleanup
git worktree remove ../feature-v1.3.0-dashboard
git worktree remove ../feature-v1.4.0-reports
```

---

## Best Practices

### 1. Worktree Naming Convention:
```bash
# Format: ../TYPE-vX.Y.Z-description
../feature-v1.3.0-dashboard
../fix-v1.2.1-header-alignment
../breaking-v2.0.0-api-redesign
```

### 2. Always Copy Standards:
```bash
# Before sub-agent starts
cp -r .standards $WORKTREE_PATH/.standards
```

### 3. Clean Up After Merge:
```bash
# Remove worktree after feature merged
git worktree remove ../feature-name
```

### 4. Check Status:
```bash
# See all active worktrees
git worktree list

# Prune deleted worktrees
git worktree prune
```

---

## Troubleshooting

### Issue: Can't create worktree - branch exists
```bash
# Delete old branch first
git branch -D feature/old-name

# Or use different branch name
git worktree add ../new-feature feature/v1.3.0-new-name
```

### Issue: Worktree shows wrong files
```bash
# Navigate to worktree directory
cd ../feature-name

# Verify branch
git branch --show-current

# Pull latest
git pull origin feature-name
```

### Issue: Can't remove worktree
```bash
# Force remove
git worktree remove --force ../feature-name

# Or manually delete and prune
rm -rf ../feature-name
git worktree prune
```

---

## Integration with Sub-Agents

### Passing Context to Sub-Agents:

**In Claude Code Task tool prompt:**
```
Task: Implement dashboard view in worktree

Before starting, READ these files in order:
1. /path/to/worktree/.standards/PRE-COMMIT-CHECKLIST.md
2. /path/to/worktree/.standards/GIT-WORKFLOW.md
3. /path/to/worktree/.standards/USER-VALIDATION.md
4. /path/to/worktree/CLAUDE.md
5. /path/to/worktree/README.md

Work ONLY in: /path/to/worktree/

[Task details...]

CRITICAL: Follow PRE-COMMIT-CHECKLIST.md exactly.
Request user validation before ANY commit.
```

---

## Worktree Lifecycle

```
1. Create worktree for feature
   ↓
2. Copy .standards/ to worktree
   ↓
3. Launch sub-agent with context
   ↓
4. Sub-agent develops + requests validation
   ↓
5. User validates + approves
   ↓
6. Sub-agent commits
   ↓
7. Merge feature to main
   ↓
8. Tag release
   ↓
9. Remove worktree
```

---

*Last Updated: 2025-10-09*
