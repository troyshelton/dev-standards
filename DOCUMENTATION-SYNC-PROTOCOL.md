# Documentation Synchronization Protocol

**PURPOSE:** Keep CHANGELOG.md, CLAUDE.md, and README.md synchronized with current version, date, and status.

**WHEN:** Before EVERY commit, no exceptions.

---

## The Problem

Documentation files get out of sync when:
- Version updated in CHANGELOG but not in CLAUDE.md/README.md
- Dates don't match across files
- Status descriptions become outdated
- Emergency commits bypass documentation updates

## The Rule

**BEFORE COMMITTING:**
1. ✅ Update CHANGELOG.md with new version entry
2. ✅ Update CLAUDE.md header (version, date, status)
3. ✅ Update README.md header (version, date, status)
4. ✅ Verify all three match

**ALL THREE FILES MUST HAVE MATCHING:**
- Version number (e.g., v1.7.3)
- Date (e.g., 2025-10-10)
- Consistent status description

---

## Step-by-Step Protocol

### Step 1: Get Current Date

```bash
# ALWAYS get current date from system
date '+%Y-%m-%d'
# Example output: 2025-10-10
```

**NEVER hardcode dates!**

### Step 2: Determine Next Version

Based on change type:
- **PATCH** (bug fix): v1.7.2 → v1.7.3
- **MINOR** (new feature): v1.7.2 → v1.8.0
- **MAJOR** (breaking change): v1.7.2 → v2.0.0

### Step 3: Update CHANGELOG.md

Add new version entry at top:

```markdown
## [1.7.3] - 2025-10-10

### Fixed
- [Description of what was fixed]

### Technical Details
- [Technical explanation]
```

### Step 4: Update CLAUDE.md Header

**Location:** Top of file (lines 1-10)

**Find and replace:**
```markdown
# CLAUDE.md - Dialysis Component v1.7.2

## Current Version: v1.7.2

**Date**: 2025-08-07
**Status**: [Old status]
```

**Replace with:**
```markdown
# CLAUDE.md - Dialysis Component v1.7.3

## Current Version: v1.7.3

**Date**: 2025-10-10
**Status**: [New status - describe current state]
```

**Also update:** Add "What's New in v1.7.3" section below header

### Step 5: Update README.md Header

**Location:** Current Status section (lines 5-10)

**Find and replace:**
```markdown
**Version**: v1.7.2
**Status**: [Old status]
**Last Updated**: 2025-08-07
```

**Replace with:**
```markdown
**Version**: v1.7.3
**Status**: [New status - describe current state]
**Last Updated**: 2025-10-10
```

### Step 6: Verify Synchronization

Run these commands:

```bash
# Check version numbers match
grep "Version.*1\.7\.3" CHANGELOG.md CLAUDE.md README.md

# Check dates match
grep "2025-10-10" CHANGELOG.md CLAUDE.md README.md

# Visual confirmation
echo "=== CHANGELOG.md ===" && head -10 CHANGELOG.md
echo "=== CLAUDE.md ===" && head -10 CLAUDE.md
echo "=== README.md ===" && head -15 README.md
```

**If ANY file doesn't show the new version/date:** STOP and update it!

### Step 7: Commit

Only after all three files are synchronized:

```bash
git add CHANGELOG.md CLAUDE.md README.md [other files]
git commit -m "..."
```

---

## Quick Reference Templates

### CLAUDE.md Header Template

```markdown
# CLAUDE.md - Dialysis Component v[X.Y.Z]

This file documents the current state of the dialysis component for Claude Code (AI assistant) reference.

## Current Version: v[X.Y.Z]

**Date**: YYYY-MM-DD
**Status**: [Brief current state description]
**Previous Version**: v[X.Y.Z-1]

## What's New in v[X.Y.Z]

### [Category]
[Description of changes]
```

### README.md Status Template

```markdown
## Current Status

**Version**: v[X.Y.Z]
**Status**: [Brief current state - Production/Testing/Development]
**Last Updated**: YYYY-MM-DD
**Environment**: Production/Cert/Development
```

### CHANGELOG.md Entry Template

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Fixed / Added / Changed
- **[Category]** - Description
  - Details
  - Impact
  - Ref: Issue #N

### Technical Details
- Technical explanation
- Files affected
- Testing performed
```

---

## Validation Commands

**Run these BEFORE committing:**

```bash
# 1. Check all files have new version
echo "Checking version consistency..."
NEW_VERSION="1.7.3"
grep -l "Version.*$NEW_VERSION\|\\[$NEW_VERSION\\]" CHANGELOG.md CLAUDE.md README.md

# Should return all 3 files. If not, files are out of sync!

# 2. Check all files have today's date
echo "Checking date consistency..."
TODAY=$(date '+%Y-%m-%d')
grep -l "$TODAY" CHANGELOG.md CLAUDE.md README.md

# Should return all 3 files. If not, dates are out of sync!

# 3. Show versions side-by-side
echo "=== Version Summary ==="
echo "CHANGELOG: $(grep -m1 "^## \[" CHANGELOG.md)"
echo "CLAUDE.md: $(grep -m1 "Current Version:" CLAUDE.md)"
echo "README.md: $(grep -m1 "Version.*:" README.md | head -1)"

# 4. Show dates side-by-side
echo "=== Date Summary ==="
echo "CHANGELOG: $(grep -m1 "^## \[.*\] -" CHANGELOG.md | sed 's/.*- //')"
echo "CLAUDE.md: $(grep -m1 "Date.*:" CLAUDE.md | sed 's/.*: //')"
echo "README.md: $(grep -m1 "Last Updated.*:" README.md | sed 's/.*: //')"
```

**If ANYTHING doesn't match:** STOP, update files, verify again.

---

## Why This Matters

**For AI Assistants:**
- CLAUDE.md is primary context file
- Out-of-date CLAUDE.md = incorrect understanding of project state
- Leads to wrong assumptions and advice

**For Resuming Work:**
- "Resume [project]" relies on documentation being accurate
- Out-of-sync docs = confusion about what's complete vs pending
- Wastes time re-analyzing project state

**For Collaboration:**
- Other developers trust documentation
- Out-of-date docs = poor handoff
- Breaks team workflow

---

## Emergency Commit Exception

If you MUST commit urgently (production emergency):

1. **Commit the fix immediately**
2. **Create follow-up issue:** "Update documentation for v[X.Y.Z]"
3. **Update docs ASAP** (same day)
4. **Mark in commit:** "Emergency commit - docs update pending"

**But this should be RARE!**

---

## Enforcement

### For AI Assistants

Before EVERY commit command, AI must:
1. Check if version changed
2. If yes, verify CLAUDE.md and README.md updated
3. If not updated, PAUSE and update them
4. Only then proceed with commit

### For Human Developers

Use git hooks or manual checklist review before pushing.

---

## Quick Sync Script

Save this as `sync-docs.sh` in project root:

```bash
#!/bin/bash
# Quick documentation synchronization helper

if [ $# -ne 2 ]; then
    echo "Usage: ./sync-docs.sh VERSION DATE"
    echo "Example: ./sync-docs.sh 1.7.3 2025-10-10"
    exit 1
fi

VERSION=$1
DATE=$2

echo "Checking documentation sync for v$VERSION on $DATE..."
echo ""

# Check CHANGELOG
if grep -q "\[$VERSION\] - $DATE" CHANGELOG.md; then
    echo "✅ CHANGELOG.md has v$VERSION dated $DATE"
else
    echo "❌ CHANGELOG.md missing v$VERSION or wrong date"
fi

# Check CLAUDE.md version
if grep -q "Current Version: v$VERSION" CLAUDE.md; then
    echo "✅ CLAUDE.md version is v$VERSION"
else
    echo "❌ CLAUDE.md version needs update"
fi

# Check CLAUDE.md date
if grep -q "Date.*: $DATE" CLAUDE.md; then
    echo "✅ CLAUDE.md date is $DATE"
else
    echo "❌ CLAUDE.md date needs update"
fi

# Check README version
if grep -q "Version.*: v$VERSION" README.md; then
    echo "✅ README.md version is v$VERSION"
else
    echo "❌ README.md version needs update"
fi

# Check README date
if grep -q "Last Updated.*: $DATE" README.md; then
    echo "✅ README.md date is $DATE"
else
    echo "❌ README.md date needs update"
fi

echo ""
echo "If any ❌ above, run: grep -n 'Version\|Date\|Last Updated' CLAUDE.md README.md"
echo "Then update the files before committing."
```

---

**Last Updated:** 2025-10-10
**Version:** 1.0
