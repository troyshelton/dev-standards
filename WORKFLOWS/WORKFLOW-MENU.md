# TaskMaster Workflow Catalog

**Purpose:** Quick reference guide for all available workflows

**Last Updated:** 2025-10-11

---

## Core Workflows (Always Available)

### 1. Project Initialization
**File:** `TASKMASTER-PROJECT-INIT.md`
**Tasks:** 12 sequential steps
**Validation Gates:** 3
**Duration:** 10-15 minutes

**When to use:**
- Starting any new CCL, Web, or MPage project
- Need proper structure and documentation from day one
- Want to ensure git setup from the beginning

**Ensures:**
- Correct project type structure (CCL/Web/MPage)
- Synchronized documentation (v1.0.0)
- Git repository with initial commit and tag
- Ready for development

**Prevents:**
- Inconsistent project structures
- Missing documentation from the start
- Git setup errors

---

### 2. Documentation Sync
**File:** `TASKMASTER-DOC-SYNC.md`
**Tasks:** 8 sequential steps
**Validation Gates:** 2
**Duration:** 5-10 minutes

**When to use:**
- Before committing when version number changed
- When CHANGELOG/CLAUDE.md/README.md are out of sync
- As part of git-enhancement workflow

**Prevents:**
- Documentation drift (recurring issue)
- Version mismatches across files
- Date mismatches

---

### 3. Git Enhancement (Issue → Branch → Tag)
**File:** `TASKMASTER-GIT-ENHANCEMENT.md`
**Tasks:** 10+ sequential steps
**Validation Gates:** 6
**Duration:** Variable (depends on development work)

**When to use:**
- Starting any new feature
- Starting bug fix work
- Any enhancement requiring Issue → Branch → Tag workflow

**Ensures:**
- Proper git workflow standards
- Documentation stays synchronized
- Issues linked to branches and tags
- Clean git history

**Includes:**
- Calls doc-sync as sub-workflow
- Cleanup of branches
- Proper tagging with issue closure

---

## Custom Workflows (Add Your Own!)

**To add new workflow:**
1. Copy `TEMPLATE-BLANK.md`
2. Define your steps
3. Add dependencies
4. Add validation gates where needed
5. Save in WORKFLOWS/ directory
6. It appears in menu automatically!

**Workflow ideas:**
- CCL program deployment
- MPages component creation
- Production hotfix
- Code review process
- Security audit
- Server maintenance
- Database migration
- Integration testing

---

## Workflow Comparison

| Workflow | Use Case | Tasks | Gates | Duration |
|----------|----------|-------|-------|----------|
| **Project Init** | New project setup | 12 | 3 | 10-15 min |
| **Doc Sync** | Keep docs current | 8 | 2 | 5-10 min |
| **Git Enhancement** | Full development cycle | 10+ | 6 | Varies |
| **[Custom]** | Your process | TBD | TBD | TBD |

---

## How to Use

**From any project:**
```
Run [workflow name] workflow from .standards/WORKFLOWS/[filename]
```

**AI will:**
1. Read the workflow template
2. Use TaskMaster to create tasks
3. Set up dependencies
4. Execute sequentially
5. Pause at validation gates for your approval

**See:** `TASKMASTER-USAGE-GUIDE.md` for detailed usage instructions

---

## Validation Gates Explained

**Validation gates pause workflow for your approval:**

| Gate Type | Example | What It Does |
|-----------|---------|--------------|
| **Review Content** | Review CHANGELOG entry | You approve content before proceeding |
| **Decision Point** | Choose version type (patch/minor/major) | You decide direction |
| **Pre-Destructive** | About to push to GitHub | You confirm before public action |
| **Final Check** | All docs synced? | You verify before commit |

**Gates BLOCK subsequent tasks** until you approve!

---

## Integration Between Workflows

**Project Init:**
- Run standalone (new project setup)
- First workflow to run when starting any project
- Creates foundation for other workflows

**Doc Sync can be:**
- Run standalone (fixing documentation drift)
- Called as sub-workflow (from git-enhancement or project-init)

**Git Enhancement:**
- Self-contained complete workflow
- Calls doc-sync automatically
- Used after project init for development

**Custom workflows can:**
- Call other workflows as sub-workflows
- Build on existing patterns
- Create specialized processes

---

## Best Practices

1. **One workflow at a time** - Don't run multiple simultaneously
2. **Complete workflows** - Don't abandon mid-stream
3. **Honor validation gates** - Review before approving
4. **Create reusable workflows** - If you do something twice, make it a workflow
5. **Update this catalog** - When you add new workflows

---

**Location:** `/Users/troyshelton/Projects/.standards/WORKFLOWS/`
**MCP Requirements:** TaskMaster MCP (required), Context7 MCP (optional enhancement)
