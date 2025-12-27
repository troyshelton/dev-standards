# TaskMaster Workflow Templates

**Purpose:** Reusable, enforced workflows for common development tasks using TaskMaster MCP.

---

## What Are Workflow Templates?

Workflow templates define sequential steps for common development tasks with:
- **Dependencies** - Steps must complete in order
- **Validation Gates** - Pause for user approval at key points
- **Enforcement** - TaskMaster blocks progress until dependencies met

---

## Available Workflows

### Project Management Workflows

| Template | Purpose | Steps | Validation Gates |
|----------|---------|-------|------------------|
| [TASKMASTER-PROJECT-INIT.md](TASKMASTER-PROJECT-INIT.md) | Initialize new project with structure and docs | 13 | 4 |
| [TASKMASTER-DOC-SYNC.md](TASKMASTER-DOC-SYNC.md) | Keep CHANGELOG, CLAUDE.md, README.md synchronized | 7 | 2 |
| [TASKMASTER-GIT-ENHANCEMENT.md](TASKMASTER-GIT-ENHANCEMENT.md) | Full git workflow (Issue → Branch → Tag) | 10+ | 4 |

### Requirement Intake Workflows

| Template | Purpose | Type | Validation Gates |
|----------|---------|------|------------------|
| [STAKEHOLDER-TO-TASKS.md](STAKEHOLDER-TO-TASKS.md) | Convert stakeholder feedback to TaskMaster tasks | All | Varies |

### Validated Development Patterns

| Template | Purpose | Use For | Validation Type |
|----------|---------|---------|-----------------|
| [VALIDATED-WEB-DEVELOPMENT.md](VALIDATED-WEB-DEVELOPMENT.md) | Web projects with automated testing gates | Pure web projects, Oracle JET | Live server + Chrome DevTools |
| [VALIDATED-MPAGE-STANDALONE.md](VALIDATED-MPAGE-STANDALONE.md) | Standalone MPages (CCL + Web) | Custom MPages, independent deployment | CCL (user) + Web (DevTools) + Domain (user) |
| [VALIDATED-MPAGE-COMPONENT.md](VALIDATED-MPAGE-COMPONENT.md) | Custom components in Bedrock | Embedded components, custom-components.js | CCL (user) + Web (DevTools) + Bedrock (user) |
| [VALIDATED-CCL-DEVELOPMENT.md](VALIDATED-CCL-DEVELOPMENT.md) | Standalone CCL programs | Database queries, reports, batch jobs | User validates in Cerner environment |

---

## How to Use a Workflow

### Step 1: Choose Workflow Template

Read the workflow template file (e.g., `TASKMASTER-DOC-SYNC.md`)

### Step 2: Invoke TaskMaster

Tell Claude Code:
```
I need to run the documentation sync workflow from .standards/WORKFLOWS/TASKMASTER-DOC-SYNC.md

Please use TaskMaster MCP to create the tasks with dependencies as defined in that template.
```

### Step 3: TaskMaster Creates Tasks

TaskMaster reads the template and creates tasks with proper dependencies.

### Step 4: Work Through Tasks

Claude works through tasks sequentially:
- Completes automatic tasks
- Pauses at validation gates
- Waits for your approval
- Proceeds once approved

### Step 5: Workflow Completes

All tasks complete, work is done correctly with all validation points covered.

---

## Creating New Workflows

### Quick Start

1. **Copy template:**
   ```bash
   cp TEMPLATE-BLANK.md TASKMASTER-MY-WORKFLOW.md
   ```

2. **Define your steps:**
   - List all steps in order
   - Mark dependencies
   - Add validation gates where user approval needed

3. **Save in WORKFLOWS directory**

4. **Use immediately** - no code changes needed!

### Workflow Template Format

```markdown
# TaskMaster Workflow: [Name]

**Purpose:** [What this workflow does]

**When to use:** [Situations where this applies]

**Duration:** [Estimated time]

---

## Task List

### Task 1: [Name]
- **Action:** [What to do]
- **Dependencies:** None
- **Validation:** None / USER APPROVAL REQUIRED
- **Output:** [What this produces]

### Task 2: [Name]
- **Action:** [What to do]
- **Dependencies:** Task 1
- **Validation:** None / USER APPROVAL REQUIRED
- **Output:** [What this produces]

... etc
```

### When to Add Validation Gates

Add `USER APPROVAL REQUIRED` when:
- User needs to review output before proceeding
- Decision point (which branch of workflow?)
- Before destructive action (delete, push to prod)
- Before committing code
- Before merging branches

---

## Example Workflow Ideas

### For Development:
- `TASKMASTER-CCL-DEPLOYMENT.md` - Deploy CCL program to production
- `TASKMASTER-NEW-COMPONENT.md` - Create new MPages component from scratch
- `TASKMASTER-PRODUCTION-HOTFIX.md` - Emergency production fix workflow
- `TASKMASTER-CODE-REVIEW.md` - Systematic code review process

### For Documentation:
- `TASKMASTER-VERSION-RELEASE.md` - Complete version release process
- `TASKMASTER-API-DOCUMENTATION.md` - Generate API documentation
- `TASKMASTER-MIGRATION-GUIDE.md` - Create migration guide for breaking changes

### For Testing:
- `TASKMASTER-INTEGRATION-TEST.md` - Run full integration test suite
- `TASKMASTER-REGRESSION-TEST.md` - Verify no regressions introduced
- `TASKMASTER-UAT-PREP.md` - Prepare for user acceptance testing

### For Operations:
- `TASKMASTER-SERVER-CYCLE.md` - Cycle WebSphere/Millennium servers
- `TASKMASTER-BACKUP-RESTORE.md` - Backup and restore procedures
- `TASKMASTER-INCIDENT-RESPONSE.md` - Production incident response

---

## Benefits

**vs Manual Checklists:**
- ✅ Enforced dependencies (can't skip ahead)
- ✅ Persistent across sessions (survive restarts)
- ✅ AI can't forget steps
- ✅ Validation gates built in

**vs TodoWrite:**
- ✅ True enforcement (not just visibility)
- ✅ Dependencies block progress
- ✅ Structured and repeatable
- ✅ Survives conversation context resets

**Extensible:**
- ✅ Add new workflows anytime
- ✅ No code changes needed
- ✅ Just create markdown file
- ✅ Works immediately

---

## Workflow Development Tips

1. **Start Simple:** Create basic workflow, test it, then enhance
2. **Add Gates Sparingly:** Too many gates = workflow fatigue
3. **Clear Dependencies:** Make it obvious why task B needs task A
4. **Document Outputs:** What should each task produce?
5. **Version Your Workflows:** Add date/version to template if it changes significantly

---

**Location:** `/Users/troyshelton/Projects/.standards/WORKFLOWS/`
**Last Updated:** 2025-10-10
**System:** TaskMaster MCP + Context7 MCP + Claude Code
