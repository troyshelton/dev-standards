# Git and Feature Branch Workflow

Complete guide for Git-based development workflow including feature branches, semantic versioning, and GitHub integration.

## Table of Contents
- [Overview](#overview)
- [Initial Setup](#initial-setup)
- [Feature Branch Workflow](#feature-branch-workflow)
- [Branch Management](#branch-management)
- [Testing Requirements](#testing-requirements)
- [Commit Guidelines](#commit-guidelines)
- [GitHub Integration](#github-integration)

## Overview

Use feature branches for all development work. This ensures:
- Main branch always remains stable
- Easy to revert entire features
- Clear history of what was added when
- Work can be resumed after interruptions

## Initial Setup

### GitHub Repository Setup

**Best Practice**: Set up GitHub repository immediately after `git init` to enable:
- Backup of your work
- Collaboration features
- Pull request workflow
- Issue tracking

#### For New Projects:
```bash
# 1. After git init and initial commit, create repository on GitHub:
#    - Go to https://github.com/new
#    - Name: match your local project name
#    - DON'T initialize with README/license (if you already have files)
#    - Click "Create repository"

# 2. Connect local to remote
git remote add origin https://github.com/username/repository-name.git

# 3. Push initial commit and tags
git push -u origin main
git push origin --tags
```

#### For Existing Local Projects:
```bash
# Check if remote exists
git remote -v

# If no remote, add it
git remote add origin https://github.com/username/repository-name.git

# Set upstream and push
git push -u origin main
```

#### Clone Existing Repository:
```bash
git clone https://github.com/username/repository-name.git
cd repository-name
```

## Feature Branch Workflow

### The Issue-Branch-Tag Connection

**IMPORTANT**: All three work together for proper tracking:

1. **GitHub Issue (#N)** - Describes WHAT and WHY
2. **Feature Branch** (feature/vX.Y.Z-description) - WHERE the work happens
3. **Version Tag** (vX.Y.Z) - WHEN it was completed

**Visual Workflow:**
```
Issue #N created
    ↓
Feature branch: feature/vX.Y.Z-issue-description
    ↓
Development & testing
    ↓
Merge to main
    ↓
Tag vX.Y.Z with "Closes #N"
    ↓
Issue #N auto-closed
```

### Workflow Steps

#### 1. Create GitHub Issue FIRST (REQUIRED for tracking)
```bash
# Using GitHub CLI (gh)
gh issue create --title "Add PDF type checker for CCL references" \
  --body "Description of the problem and proposed solution"

# Or create via GitHub web interface
# Returns issue number (e.g., #1)
```

#### 2. Determine Next Version Number
```bash
# Get the latest tag
LATEST_TAG=$(git tag --sort=-version:refname | head -1)
echo "Latest version: $LATEST_TAG"

# Determine next version based on change type:
# - PATCH (fix): v2.0.0 → v2.0.1 (bug fixes, corrections)
# - MINOR (feature): v2.0.0 → v2.1.0 (new features, enhancements)
# - MAJOR (breaking): v2.0.0 → v3.0.0 (breaking changes)

# Example for a bug fix:
NEXT_VERSION="v2.0.1"  # Increment patch number
```

#### 3. Create Versioned Feature Branch
```bash
# Always start from updated main
git checkout main
git pull origin main

# Create branch with version and description
git checkout -b fix/v2.0.1-nocturnal-pulse-oximetry-study-missing
# Format: TYPE/VERSION-description
# Types: fix, feature, breaking
```

#### 4. Develop Changes
```bash
# Make changes
# Review changes with git diff
git diff
```

#### 5. Test Changes (REQUIRED before committing)
See [Testing Requirements](#testing-requirements) section below.

#### 6. Commit After Successful Testing
```bash
# Only commit after testing passes
git add .
git commit -m "type: brief description

Detailed explanation of changes

Testing:
- Describe what was tested
- Environment/data used
- Results confirmed

Fixes #N"
```

#### 7. Push Feature Branch (optional - for backup/collaboration)
```bash
git push -u origin feature/N-description
```

#### 8. Show Changes for Review
```bash
git diff main...HEAD
git log --oneline main..HEAD
```

#### 9. After Testing and User Approval - Merge
```bash
git checkout main
git pull origin main  # Ensure main is up to date
git merge --no-ff feature/N-description
```

#### 10. Tag the Version with Predetermined Number
```bash
# Use the version number determined in step 2
git tag -a $NEXT_VERSION -m "Brief description

- List key changes
- Include any important notes
- Type: fix/feature/breaking change
- Closes #N"

# Example for our current fix:
git tag -a v2.0.1 -m "Fix: Make frequency field optional for scheduled RT tasks

- Resolved Nocturnal Pulse Oximetry Study missing from worklist
- Added OUTERJOIN for optional frequency fields in Query 3
- Enhanced CCL troubleshooting documentation
- Type: Bug fix (PATCH increment)
- Closes #1"
```

#### 11. Push Everything and Clean Up
```bash
git push origin main --tags
git push origin --delete fix/vX.Y.Z-description  # Clean up remote
git branch -d fix/vX.Y.Z-description             # Clean up local
```

### Branch Naming Conventions (With Semantic Versioning)

**Format**: `type/vX.Y.Z-description`

#### Branch Types with Version Increments:
- `fix/v2.0.1-description` - **Bug fixes** (PATCH increment)
- `feature/v2.1.0-description` - **New features** (MINOR increment)
- `breaking/v3.0.0-description` - **Breaking changes** (MAJOR increment)
- `hotfix/v2.0.1-description` - **Urgent production fixes** (PATCH increment)
- `docs/description` - **Documentation only** (no version change)

#### Examples:
- `fix/v2.0.1-nocturnal-pulse-oximetry-study-missing`
- `feature/v2.1.0-patient-filtering-enhancements`
- `breaking/v3.0.0-ccl-program-restructure`
- `hotfix/v2.0.1-critical-memory-leak`

#### Semantic Versioning Rules:
- **PATCH** (v2.0.0 → v2.0.1): Bug fixes, corrections, patches
- **MINOR** (v2.0.0 → v2.1.0): New features, enhancements, backwards-compatible
- **MAJOR** (v2.0.0 → v3.0.0): Breaking changes, incompatible API changes

### For Parameter-by-Parameter Development:
```bash
# Base implementation
git checkout main
git checkout -b feature/parameter-1-locations
# ... implement and test parameter 1 ...
git commit -m "Add Facility Locations parameter with Behavioral B exclusion"
git checkout main
git merge feature/parameter-1-locations
git tag v1.0.0

# Next parameter
git checkout -b feature/parameter-2-um-status
# ... implement and test parameter 2 ...
git commit -m "Add UM Status parameter"
git checkout main
git merge feature/parameter-2-um-status
git tag v1.1.0
```

#### Branch Naming for Multi-Parameter Projects:
- `feature/parameter-N-description` - Individual parameter implementation
- `feature/enhancement-description` - General enhancements
- `hotfix/issue-description` - Urgent fixes
- `docs/description` - Documentation updates

## Branch Management

### Resuming Work After Interruption

#### Check Current State:
```bash
# What branch am I on?
git branch --show-current

# Any uncommitted changes?
git status

# Recent commits?
git log --oneline -5

# What's different from main?
git diff main...HEAD
```

#### Resume Scenarios:
1. **Mid-development**: Continue editing, commit WIP if needed
2. **Awaiting review**: Show diff to user for approval
3. **Ready to merge**: Proceed with merge and tag

### Reverting Changes

**If a feature needs to be reverted:**
```bash
# Option 1: Revert the merge (preferred)
git revert -m 1 <merge-commit-hash>
git tag -a v0.3.2 -m "Revert PDF checker feature"

# Option 2: Reset to previous version (destructive)
git reset --hard v0.3.0
git push --force-with-lease origin main
```

### Branch Lifecycle Management

**Problem**: Over time, repositories accumulate many stale branches that make navigation difficult and clutter the branch list.

**Solution**: Regular branch cleanup following these guidelines:

#### Branch Retention Policy
- ✅ **Always Keep**: `main`, active development branches
- ✅ **Keep Temporarily**: Recent feature branches (< 3 months)
- ❌ **Delete**: Merged branches, old experimental work, abandoned features

#### Safe Branch Cleanup Process

##### Step 1: Analyze Current Branches
```bash
# Get total branch count
git branch -r | grep -v HEAD | wc -l

# List branches with commit dates
git for-each-ref --format='%(refname:short) %(committerdate) %(authorname)' refs/remotes/origin | sort -k2 -r

# Find branches already merged into main
git branch -r --merged main | grep -v main
```

##### Step 2: Identify Safe Deletions
```bash
# Count merged branches (safe to delete)
git branch -r --merged main | grep -v main | wc -l

# Review specific branch before deletion
git show origin/BRANCH_NAME --stat
git log main..origin/BRANCH_NAME --oneline
```

##### Step 3: Delete Merged Branches (CAREFULLY)
```bash
# Delete individual branches (RECOMMENDED - one by one)
git push origin --delete old-feature-branch
git push origin --delete completed-fix-branch

# Bulk delete merged branches (DANGEROUS - use with caution)
git branch -r --merged main | grep -v main | sed 's/origin\///' | xargs -n 1 git push origin --delete
```

##### Step 4: Clean Up Local References
```bash
# Remove stale remote tracking branches
git remote prune origin

# Delete local branches that no longer exist on remote
git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d
```

#### Branch Categories for Deletion Priority

##### 🟢 High Priority (Safe to Delete)
- ✅ Branches merged into main > 3 months ago
- ✅ Old `stable-vX.X.X` branches (keep latest few only)
- ✅ Completed feature branches
- ✅ Old fix branches that are merged
- ✅ Merge conflict resolution branches

##### 🟡 Medium Priority (Review First)
- ⚠️ Recent branches (< 3 months) that are merged
- ⚠️ Branches with unclear purpose
- ⚠️ Experimental branches

##### 🔴 Low Priority (Keep)
- ❌ Active development branches
- ❌ Long-running branches (`development`, `staging`)
- ❌ Recent unmerged work
- ❌ `main` branch (never delete)

#### Automation Script Template
```bash
#!/bin/bash
# Safe branch cleanup script

echo "🔍 Analyzing branches..."
git fetch --all --prune

MERGED_COUNT=$(git branch -r --merged main | grep -v main | wc -l)
echo "📊 Found $MERGED_COUNT branches merged into main"

echo "🗑️ Safe to delete:"
git branch -r --merged main | grep -v main | sed 's/origin\///' | head -10

read -p "❓ Delete these branches? (y/n): " confirm
if [[ $confirm == "y" ]]; then
    git branch -r --merged main | grep -v main | sed 's/origin\///' | head -10 | xargs -n 1 git push origin --delete
    echo "✅ Cleanup complete!"
fi
```

#### Best Practices for Branch Cleanup
1. **Regular Schedule** - Clean up branches monthly/quarterly
2. **Team Communication** - Coordinate with team before bulk deletions
3. **Backup Important Work** - Create tags for important experimental branches
4. **Document Decisions** - Note why branches were kept/deleted
5. **Incremental Cleanup** - Delete a few branches at a time, not all at once

#### Example Cleanup Results
- **Before**: 42 branches (35 merged, 7 active)
- **After Cleanup**: 12 branches (5 active, 7 recent/important)
- **Result**: 📉 71% reduction in branch clutter

## Testing Requirements

**Always test changes before merging to main:**

### CCL Projects
- Test with sample record IDs
- Verify output matches expectations
- Check error handling with invalid inputs
- Run in debug mode to check logic flow

### Web Projects
- Run unit tests if available
- Test in browser (multiple if needed)
- Check console for errors
- Verify responsive design

### SQL Scripts
- Test on non-production data
- Verify performance with EXPLAIN PLAN
- Check for proper indexes
- Test edge cases

### Document Testing
- Include test results in PR description
- Note any limitations found
- List test scenarios covered

### Test Documentation Format
```bash
git commit -m "type: brief description

Detailed explanation of changes

Testing:
- What was tested
- Test environment used
- Any issues found and fixed
- Confirmation that changes work as expected

Fixes #N"
```

## Commit Guidelines

### Commit Message Format
```
type(scope): subject

Body explaining why this change was made
Can be multiple paragraphs if needed

Refs #issue-number
```

Types: feat, fix, docs, style, refactor, test, chore

### Example Commit Messages
```bash
# Bug fix
git commit -m "fix: Make frequency field optional for scheduled RT tasks

Added OUTERJOIN for optional frequency fields to prevent missing tasks
from appearing in worklist when frequency field is not populated.

Testing:
- Tested with Nocturnal Pulse Oximetry Study
- Verified task appears in worklist
- Confirmed frequency displays as 'Once' when not specified

Fixes #1"

# New feature
git commit -m "feat: Add patient filtering by UM status

Implemented new parameter for filtering patients by UM status with
support for multiple selections and default to 'All'.

Testing:
- Tested with multiple UM status selections
- Verified default behavior
- Confirmed integration with existing filters

Refs #5"
```

## GitHub Integration

### GitHub Issue Integration

**Benefits of Using Issues:**
- Track work items and progress
- Document problem and solution
- Auto-close issues on merge (with "Fixes #N")
- Create roadmap of planned features
- Enable discussions and collaboration

**Issue References in Commits:**
- `Fixes #N` or `Closes #N` - Auto-closes issue when merged
- `Refs #N` or `See #N` - Links to issue without closing
- Multiple issues: `Fixes #1, Fixes #2`

### README Status Section
Always maintain in README.md:
```markdown
## Current Status

**Version**: v0.3.0
**Active Branch**: feature/1-pdf-checker
**Current Task**: Testing PDF type detection
**Next Steps**: Test with actual CCL PDF file

### Recent Changes
- v0.3.0: Added image compression tools
- v0.2.0: Created markdown splitters
```

## Git Best Practices

1. **One feature per branch** - Keep changes focused
2. **Test before merging** - Ensure quality and stability
3. **Commit frequently** - Even work-in-progress
4. **Write descriptive messages** - Future you will thank you
5. **Tag completed features** - Following semantic versioning
6. **Keep main stable** - Only merge tested, approved code
7. **Update README** - Maintain current status section
8. **Clean up branches regularly** - Remove merged branches to keep repository tidy

---
*Last Updated: 2025-10-09*