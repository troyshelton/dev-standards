# Development Standards

**Central repository of development standards, workflows, and checklists for all projects.**

---

## 📁 Standards Files

| File | Purpose |
|------|---------|
| [PRE-COMMIT-CHECKLIST.md](PRE-COMMIT-CHECKLIST.md) | ⚠️ Required checks before every commit |
| [GIT-WORKFLOW.md](GIT-WORKFLOW.md) | Issue → Branch → Tag workflow |
| [VERSIONING.md](VERSIONING.md) | Semantic versioning and changelog standards |
| [USER-VALIDATION.md](USER-VALIDATION.md) | User approval requirements before commits |
| [WORKTREE-WORKFLOW.md](WORKTREE-WORKFLOW.md) | Parallel development with worktrees |

---

## 🎯 Purpose

**Single source of truth** for development standards across all projects.

### Benefits:
- ✅ Update once, applies everywhere
- ✅ Consistent workflows across projects
- ✅ Easy to share with sub-agents
- ✅ No duplication in project files
- ✅ Version controlled (optional Git backup)

---

## 📖 How to Use

### For AI Assistants:

**At project start, read:**
1. Project-specific `CLAUDE.md`
2. Project-specific `README.md`
3. Standards from `.standards/` as needed

**Before committing, check:**
- `.standards/PRE-COMMIT-CHECKLIST.md`
- `.standards/USER-VALIDATION.md`

**When using worktrees:**
- Follow `.standards/WORKTREE-WORKFLOW.md`
- Copy `.standards/` to each worktree

### For New Projects:

```bash
# Reference standards in project CLAUDE.md:
**Standards:** `/Users/troyshelton/Projects/.standards/`

See standards directory for:
- Pre-commit checklist
- Git workflow
- User validation requirements
```

---

## 🔧 Maintenance

### Updating Standards:

```bash
# Edit any .standards/ file
vim /Users/troyshelton/Projects/.standards/GIT-WORKFLOW.md

# Changes apply to ALL projects immediately
# No need to update each project individually
```

### Backup to GitHub (Optional):

```bash
cd /Users/troyshelton/Projects/.standards
git add .
git commit -m "Update: [description]"
git push origin main
```

---

## 📦 Applying to New Projects

### Option 1: Reference in Place
```markdown
# In project CLAUDE.md
**Standards:** `/Users/troyshelton/Projects/.standards/`
```

### Option 2: Copy to Project (for portability)
```bash
cp -r /Users/troyshelton/Projects/.standards ./docs/standards
```

### Option 3: Symlink (for sync)
```bash
ln -s /Users/troyshelton/Projects/.standards ./.standards
```

---

## 🌳 Git Backup Setup

**To version control and share these standards:**

```bash
cd /Users/troyshelton/Projects/.standards

# Initialize Git repo
git init

# Add all files
git add .
git commit -m "Initial development standards"

# Create GitHub repo and push
gh repo create dev-standards --public --source=.
git push -u origin main
```

**For others to use:**
```bash
# Clone to their Projects directory
cd ~/Projects
git clone https://github.com/troyshelton/dev-standards.git .standards
```

---

## 📋 Standards Checklist

**Every standard file should include:**
- Clear purpose statement
- Step-by-step instructions
- Examples
- Troubleshooting section
- Last updated date

---

*Location:* `/Users/troyshelton/Projects/.standards/`
*Repository:* https://github.com/troyshelton/dev-standards (optional backup)
*Last Updated:* 2025-10-09
