# TaskMaster MCP Workflows - Usage Guide

**Purpose:** Learn how to use TaskMaster MCP with workflow templates for enforced, validated development workflows

---

## Quick Start

### Invoking a Workflow

**Tell Claude Code:**
```
I need to run the [workflow name] workflow.

Please use TaskMaster MCP to create tasks based on:
/Users/troyshelton/Projects/.standards/WORKFLOWS/TASKMASTER-DOC-SYNC.md

Follow the template exactly, including all dependencies and validation gates.
```

**Claude will:**
1. Read the workflow template
2. Use TaskMaster to create tasks
3. Set up dependencies
4. Begin executing sequentially

---

## Understanding Task Dependencies

**Dependencies block progress:**

Example:
```
Task 3: Update CLAUDE.md
  Dependencies: Task 2 APPROVED

You CANNOT do Task 3 until:
- Task 2 is complete
- AND user has approved Task 2
```

**This prevents skipping steps!**

---

## Validation Gates Explained

**What is a Validation Gate?**
- A task that requires user approval to proceed
- Marked with: 🛑 USER APPROVAL REQUIRED
- TaskMaster PAUSES workflow
- Waits for your explicit approval
- Blocks all dependent tasks

**How to Approve:**
```
Claude: I've completed Task 3. Here's what I updated:
[shows changes]

Please review and approve to continue.

You: approved
OR
You: looks good
OR
You: proceed

Claude: Task 3 approved. Proceeding to Task 4...
```

**How to Reject/Revise:**
```
You: wait, change XYZ first
OR
You: not quite, update ABC

Claude: Understood. I'll revise Task 3.
[makes changes]
Please review again.

You: approved
Claude: Task 3 approved. Proceeding...
```

---

## TaskMaster MCP Commands

**Create tasks from template:**
```
Use mcp__taskmaster-ai__generate to create tasks based on the workflow template
```

**Check task status:**
```
Use mcp__taskmaster-ai__get_tasks to show current tasks and dependencies
```

**Update task status:**
```
Use mcp__taskmaster-ai__set_task_status to mark task complete or pending approval
```

**Add task:**
```
Use mcp__taskmaster-ai__add_task to add task to workflow
```

---

## Common Workflows

### Documentation Sync (Before Every Commit)

**When:** Before committing when version changed

**Command:**
```
Run doc-sync workflow from .standards/WORKFLOWS/TASKMASTER-DOC-SYNC.md
```

**Steps:** 8 tasks, 2 validation gates, ~5-10 minutes

**Prevents:** Documentation files getting out of sync

---

### Git Enhancement (Full Feature/Fix Workflow)

**When:** Starting any new feature or bug fix

**Command:**
```
Run git-enhancement workflow from .standards/WORKFLOWS/TASKMASTER-GIT-ENHANCEMENT.md
```

**Steps:** 10+ tasks, 6 validation gates, duration varies

**Ensures:** Proper Issue → Branch → Tag workflow with documentation sync

---

## Troubleshooting

### "TaskMaster not responding"

**Check:**
1. Is TaskMaster MCP enabled? Check `.claude/settings.local.json`
2. Try restarting Claude Code
3. Verify MCP connection: `claude mcp list`

### "Tasks not blocking correctly"

**Verify:**
- Dependencies are set correctly in template
- Task status is being updated (use get_tasks to check)
- Prior task marked complete before proceeding

### "Validation gate not pausing"

**Ensure:**
- Template clearly marks: `Validation: USER APPROVAL REQUIRED`
- Claude understands to pause and wait
- If Claude proceeds anyway, remind: "Wait for my approval!"

---

## Best Practices

### 1. One Workflow at a Time
Don't run multiple workflows simultaneously - they may conflict

### 2. Complete Workflows
Don't abandon workflows mid-stream - complete or explicitly cancel

### 3. Clear Approvals
Use clear language: "approved", "looks good", "proceed"
Avoid ambiguous: "ok", "thanks" (Claude might misinterpret)

### 4. Review Before Approving
Actually review the work before approving validation gates
Purpose is quality control, not speed

### 5. Document Custom Workflows
If you create new workflow templates, document them in WORKFLOWS/README.md

---

## Advanced: Creating Custom Workflows

### Step 1: Identify Repetitive Process

Look for processes you do repeatedly that have:
- Multiple sequential steps
- Need for validation at key points
- Risk of forgetting steps
- Benefit from enforcement

### Step 2: Map the Steps

List all steps in order:
1. What happens first?
2. What depends on that?
3. Where do you need to review/approve?
4. What happens last?

### Step 3: Define Dependencies

For each step, ask:
- Can this run in parallel with previous step? (no dependency)
- Must previous step complete first? (dependency)
- Must user approve previous step? (approval dependency)

### Step 4: Add Validation Gates

Add USER APPROVAL REQUIRED where:
- Important decision point
- Need to review output
- Before destructive action
- Before committing/deploying

### Step 5: Use Template

Copy TEMPLATE-BLANK.md and fill in your steps

### Step 6: Test

Run the workflow once to verify:
- Steps execute in correct order
- Dependencies work as expected
- Validation gates pause correctly
- Workflow achieves desired outcome

### Step 7: Refine

After testing, refine:
- Add missing steps
- Adjust dependencies
- Add/remove validation gates
- Improve prompts and instructions

---

## Integration with Context7

**What Context7 Does:**
- Fetches up-to-date documentation for libraries/frameworks
- Prevents outdated code suggestions
- Works automatically when Claude needs docs

**How to Use with Workflows:**
- Context7 works in background
- When Claude needs docs for code in workflow, Context7 provides them
- No explicit invocation needed
- Just installed and available

**Example:**
```
Task: Update component to use MPages Fusion 8.8

Claude (automatically):
- Checks Context7 for Fusion 8.8 docs
- Uses current API patterns
- Generates code with up-to-date methods
```

---

## Workflow Template Library

**Current Templates:**
- TASKMASTER-DOC-SYNC.md
- TASKMASTER-GIT-ENHANCEMENT.md
- TEMPLATE-BLANK.md

**Future Templates (Ideas):**
- TASKMASTER-CCL-DEPLOYMENT.md
- TASKMASTER-PRODUCTION-HOTFIX.md
- TASKMASTER-CODE-REVIEW.md
- TASKMASTER-NEW-COMPONENT.md
- TASKMASTER-SECURITY-AUDIT.md

**Contribute:**
When you create useful workflows, save them in WORKFLOWS/ directory for reuse!

---

**Created:** 2025-10-10
**Version:** 1.0
**MCP Requirements:** TaskMaster MCP (required), Context7 MCP (optional but recommended)
