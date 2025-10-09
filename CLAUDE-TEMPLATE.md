# Project Instructions for Claude (AI Assistant)

**Project:** [PROJECT NAME]
**Location:** [PROJECT PATH]

---

## 🚨 READ FIRST - REQUIRED READING ORDER

**⚠️ DO NOT SKIP - Read these files IN ORDER before doing ANY work:**

1. **Global Standards** - `/Users/troyshelton/Projects/CLAUDE.md`
   - CCL syntax rules (if applicable)
   - Project structure standards
   - Global patterns

2. **Workflow Standards** - `/Users/troyshelton/Projects/.standards/`
   - `PRE-COMMIT-CHECKLIST.md` ⚠️ Required before EVERY commit
   - `USER-VALIDATION.md` ⚠️ Get user approval before commits
   - `GIT-WORKFLOW.md` - Issue → Branch → Tag workflow
   - `VERSIONING.md` - Semantic versioning
   - `WORKTREE-WORKFLOW.md` - Parallel development (if using sub-agents)

3. **This File** - Project-specific context and architecture

4. **Current Status** - `README.md` in this directory
   - Current version and last updated date
   - What's working (features)
   - Quick start guide

5. **Version History** - `CHANGELOG.md` in this directory
   - Detailed change history
   - Git workflow compliance notes

6. **Current Work** - [GitHub Issues](GITHUB_ISSUES_URL)
   - All outstanding work tracked here
   - No TODOs in markdown files

**✅ After reading all 6, you'll have complete context to work effectively.**

---

## Current Status → See README.md

**For current version, date, and features:** See `README.md` status table
**For outstanding work:** See [GitHub Issues](GITHUB_ISSUES_URL)
**For version history:** See `CHANGELOG.md`

---

## Project Context

### Business Problem
[Describe the problem this project solves]

### Proposed Solution
[Explain the solution approach]

### Key Constraints
1. [Constraint 1]
2. [Constraint 2]
3. [Constraint 3]

### Success Criteria
- ✅ [Criterion 1]
- ⏳ [Criterion 2 - pending]

---

## Architecture Overview

### Current Architecture: [ARCHITECTURE NAME]

**[Component 1]:** [Description]
**[Component 2]:** [Description]

**Benefits:**
- [Benefit 1]
- [Benefit 2]

**Why This Architecture?**
[Explain decision reasoning]

---

## Project Structure

```
project-name/
├── README.md          # Current status, features, quick start
├── CHANGELOG.md       # Version history
├── CLAUDE.md          # This file - AI instructions
├── .gitignore
├── src/               # Source code
├── docs/              # Documentation
└── tests/             # Tests
```

**Key Points:**
- [Structure explanation]
- [File organization rationale]

---

## File Roles and Responsibilities

### Core Files

| File | Purpose | Modify? |
|------|---------|---------|
| `[file1]` | [purpose] | ✅ Yes / ❌ No |
| `[file2]` | [purpose] | ✅ Yes / ❌ No |

### Critical Rules

**DO NOT Modify:**
1. `[protected file/directory]` - [reason]
2. `[protected file/directory]` - [reason]

**Always Do:**
1. Update CHANGELOG.md
2. Test after changes
3. Follow [applicable] conventions

---

## Development Workflow

### Git Workflow - See .standards/

**📋 BEFORE COMMITTING:**
- [.standards/PRE-COMMIT-CHECKLIST.md](../../.standards/PRE-COMMIT-CHECKLIST.md)
- [.standards/USER-VALIDATION.md](../../.standards/USER-VALIDATION.md)

**Complete Workflows:**
- [.standards/GIT-WORKFLOW.md](../../.standards/GIT-WORKFLOW.md) - Issue → Branch → Tag
- [.standards/VERSIONING.md](../../.standards/VERSIONING.md) - Semantic versioning

### Common Development Tasks

**Task: [Common Task 1]**

1. [Step 1]
2. [Step 2]
3. Update CHANGELOG.md
4. Test
5. Request user validation
6. Commit

**Task: [Common Task 2]**

[Instructions...]

---

## Architecture Decisions

### Why [Decision 1]?

**Decision:** [What was decided]

**Rationale:**
1. ✅ [Reason 1]
2. ✅ [Reason 2]

**Future Consideration:**
- [Migration path or alternative]

---

## Testing Guidelines

### Manual Testing Checklist

Before committing:
- [ ] [Test 1]
- [ ] [Test 2]
- [ ] No console errors
- [ ] Works in target browsers

### Testing Commands

```bash
# Start server
[command]

# Run tests
[command]
```

---

## Known Issues and Workarounds

### Issue: [Issue Name]

**Status:** ✅ Resolved / 📋 TODO / ⚠️ Known Issue
**Description:** [What's wrong]
**Workaround:** [Temporary solution]
**Location:** `file.ext:line`
**Priority:** High / Medium / Low

---

## References

### External Documentation
- [Link 1]
- [Link 2]

### Project Documentation
- [README.md](README.md) - Current status
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [docs/](docs/) - Additional documentation

### Global Standards
- [Global CLAUDE.md](/Users/troyshelton/Projects/CLAUDE.md)
- [.standards/](/Users/troyshelton/Projects/.standards/)

---

**For current version and last updated date, see `README.md` status table.**
