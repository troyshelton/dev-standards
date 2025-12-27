# TaskMaster Data Management Guide (No AI Required)

**Purpose:** Use TaskMaster for workflow management without requiring API keys
**Requirements:** TaskMaster MCP installed, no API keys needed
**Use Case:** Track complex projects with dependencies and clear workflow progression

---

## Quick Start

### 1. Initialize TaskMaster in Your Project

```bash
cd your-project
task-master init
```

**What this creates:**
```
.taskmaster/
├── tasks/
│   └── tasks.json      # Main task database (you'll edit this)
├── config.json         # Model config (ignore for data management)
└── state.json          # Current state
```

### 2. Create Your tasks.json

Edit `.taskmaster/tasks/tasks.json` with your workflow:

```json
{
  "master": {
    "tasks": [
      {
        "id": 1,
        "title": "Setup Development Environment",
        "description": "Install dependencies and configure tooling",
        "status": "pending",
        "priority": "high",
        "dependencies": [],
        "details": "npm install, configure linters, setup git hooks",
        "testStrategy": "Verify all tools run without errors"
      },
      {
        "id": 2,
        "title": "Create Database Schema",
        "description": "Design and implement database tables",
        "status": "pending",
        "priority": "high",
        "dependencies": ["1"],
        "details": "Users, posts, comments tables. Use migrations.",
        "testStrategy": "Run migrations successfully, verify schema"
      },
      {
        "id": 3,
        "title": "Implement API Endpoints",
        "description": "Create REST API for CRUD operations",
        "status": "pending",
        "priority": "medium",
        "dependencies": ["2"],
        "details": "GET/POST/PUT/DELETE for users and posts",
        "testStrategy": "Postman tests pass for all endpoints"
      }
    ],
    "metadata": {
      "created": "2025-10-11T00:00:00.000Z",
      "updated": "2025-10-11T00:00:00.000Z",
      "description": "Project tasks"
    }
  }
}
```

### 3. Use TaskMaster to Guide Your Work

**CLI:**
```bash
# Get next task
task-master next

# Work on the task...

# Mark complete
task-master set-status --id=1 --status=done

# Get next task (Task 2 now available!)
task-master next
```

**MCP (Claude Code):**
```javascript
// Get next task
mcp__taskmaster-ai__next_task({
  projectRoot: "/path/to/project"
})

// Mark complete
mcp__taskmaster-ai__set_task_status({
  id: "1",
  status: "done",
  projectRoot: "/path/to/project"
})

// Next task now unblocked
mcp__taskmaster-ai__next_task({
  projectRoot: "/path/to/project"
})
```

---

## Task Structure Reference

### Required Fields

```json
{
  "id": 1,                    // Unique ID (number or string)
  "title": "Task Title",      // Short name
  "description": "Details",   // What needs to be done
  "status": "pending",        // Current state
  "dependencies": []          // IDs this task depends on
}
```

### Optional But Recommended Fields

```json
{
  "priority": "high",                    // high, medium, low
  "details": "Implementation notes...",  // Extended description
  "testStrategy": "How to verify...",    // Acceptance criteria
  "subtasks": []                         // Nested tasks (see below)
}
```

### Task Status Values

- `pending` - Ready to work on (dependencies met)
- `in-progress` - Currently being worked on
- `done` - Completed and verified
- `review` - Awaiting review
- `deferred` - Postponed for later
- `cancelled` - No longer needed

### Priority Values

- `high` - Critical path, must be done soon
- `medium` - Important but not urgent
- `low` - Nice to have, can wait

---

## Subtasks

### Structure

```json
{
  "id": 1,
  "title": "Implement User Authentication",
  "description": "Complete auth system",
  "status": "in-progress",
  "dependencies": [],
  "subtasks": [
    {
      "id": "1.1",
      "title": "Setup JWT tokens",
      "status": "done",
      "dependencies": []
    },
    {
      "id": "1.2",
      "title": "Create login endpoint",
      "status": "done",
      "dependencies": ["1.1"]
    },
    {
      "id": "1.3",
      "title": "Add password hashing",
      "status": "in-progress",
      "dependencies": ["1.1"]
    }
  ]
}
```

### Managing Subtasks

**CLI:**
```bash
# View task with subtasks
task-master show 1

# Mark subtask complete
task-master set-status --id=1.1 --status=done

# Next subtask
task-master next  # Returns 1.2
```

**MCP:**
```javascript
mcp__taskmaster-ai__get_task({
  id: "1",
  projectRoot: "..."
})

mcp__taskmaster-ai__set_task_status({
  id: "1.1",
  status: "done",
  projectRoot: "..."
})
```

---

## Dependency Management

### Adding Dependencies

**Scenario:** Task 5 must wait for Tasks 2 and 3 to complete

**Method 1: Edit tasks.json directly**
```json
{
  "id": 5,
  "title": "Task 5",
  "dependencies": ["2", "3"]
}
```

**Method 2: Use CLI**
```bash
task-master add-dependency --id=5 --depends-on=2
task-master add-dependency --id=5 --depends-on=3
```

**Method 3: Use MCP**
```javascript
mcp__taskmaster-ai__add_dependency({
  id: "5",
  dependsOn: "2",
  projectRoot: "..."
})
```

### Removing Dependencies

```bash
task-master remove-dependency --id=5 --depends-on=2
```

### Validating Dependencies

```bash
# Check for circular dependencies
task-master validate-dependencies

# Auto-fix issues
task-master fix-dependencies
```

---

## Common Workflows

### Workflow 1: Linear Sequential Tasks

**Use Case:** Must complete tasks in exact order

```json
{
  "tasks": [
    { "id": 1, "title": "Step 1", "dependencies": [] },
    { "id": 2, "title": "Step 2", "dependencies": ["1"] },
    { "id": 3, "title": "Step 3", "dependencies": ["2"] },
    { "id": 4, "title": "Step 4", "dependencies": ["3"] }
  ]
}
```

**Execution:**
```
next_task → 1 → done
next_task → 2 → done
next_task → 3 → done
next_task → 4 → done
```

### Workflow 2: Parallel Tracks with Join

**Use Case:** Independent tasks that merge later

```json
{
  "tasks": [
    { "id": 1, "title": "Frontend Work", "dependencies": [] },
    { "id": 2, "title": "Backend Work", "dependencies": [] },
    { "id": 3, "title": "Integration", "dependencies": ["1", "2"] }
  ]
}
```

**Execution:**
```
next_task → 1 or 2 (both available!)
complete 1
next_task → 2 (still available)
complete 2
next_task → 3 (now available!)
```

### Workflow 3: Diamond Dependency

**Use Case:** Multiple paths converge

```json
{
  "tasks": [
    { "id": 1, "title": "Start", "dependencies": [] },
    { "id": 2, "title": "Path A", "dependencies": ["1"] },
    { "id": 3, "title": "Path B", "dependencies": ["1"] },
    { "id": 4, "title": "Merge", "dependencies": ["2", "3"] }
  ]
}
```

**Execution:**
```
next_task → 1 → done
next_task → 2 or 3 (both available!)
complete 2
next_task → 3
complete 3
next_task → 4 (now available!)
```

---

## Advanced Patterns

### Pattern: Feature Branches with Validation Gates

```json
{
  "tasks": [
    { "id": 1, "title": "Implement Feature", "dependencies": [] },
    { "id": 2, "title": "Write Tests", "dependencies": ["1"] },
    { "id": 3, "title": "Code Review", "dependencies": ["2"], "status": "review" },
    { "id": 4, "title": "Deploy to Staging", "dependencies": ["3"] },
    { "id": 5, "title": "QA Testing", "dependencies": ["4"], "status": "review" },
    { "id": 6, "title": "Deploy to Production", "dependencies": ["5"] }
  ]
}
```

**Usage:**
- Tasks 3 and 5 use `status: "review"` as gates
- Human must manually approve by setting `status: "done"`

### Pattern: Epic with Subtasks

```json
{
  "id": 1,
  "title": "User Authentication Epic",
  "status": "in-progress",
  "subtasks": [
    { "id": "1.1", "title": "JWT Implementation", "status": "done" },
    { "id": "1.2", "title": "Login Endpoint", "status": "done" },
    { "id": "1.3", "title": "Registration Endpoint", "status": "in-progress" },
    { "id": "1.4", "title": "Password Reset", "status": "pending", "dependencies": ["1.2", "1.3"] }
  ]
}
```

### Pattern: Multi-Phase Project

```json
{
  "tasks": [
    // Phase 1: Foundation
    { "id": 1, "title": "Setup", "dependencies": [] },
    { "id": 2, "title": "Database", "dependencies": ["1"] },

    // Phase 2: Core Features
    { "id": 3, "title": "Feature A", "dependencies": ["2"] },
    { "id": 4, "title": "Feature B", "dependencies": ["2"] },

    // Phase 3: Integration
    { "id": 5, "title": "Integration Tests", "dependencies": ["3", "4"] },

    // Phase 4: Deployment
    { "id": 6, "title": "Deploy", "dependencies": ["5"] }
  ]
}
```

---

## Tips & Best Practices

### 1. Start Small

**Bad:**
```json
// 50 tasks all at once
{ "tasks": [ ... 50 items ... ] }
```

**Good:**
```json
// Start with 5-10 high-level tasks
// Expand into subtasks as you work
{
  "tasks": [
    { "id": 1, "title": "Phase 1: Setup" },
    { "id": 2, "title": "Phase 2: Core Features" },
    { "id": 3, "title": "Phase 3: Testing" },
    { "id": 4, "title": "Phase 4: Deployment" }
  ]
}
```

### 2. Use Subtasks for Breakdown

**When a task is complex, expand it:**

```json
{
  "id": 2,
  "title": "Phase 2: Core Features",
  "subtasks": [
    { "id": "2.1", "title": "User Management" },
    { "id": "2.2", "title": "Data Import" },
    { "id": "2.3", "title": "Reports" }
  ]
}
```

### 3. Keep Dependencies Simple

**Bad:** Circular dependency
```json
{ "id": 1, "dependencies": ["2"] },
{ "id": 2, "dependencies": ["1"] }  // ERROR!
```

**Good:** Clear direction
```json
{ "id": 1, "dependencies": [] },
{ "id": 2, "dependencies": ["1"] }
```

### 4. Use Priority Effectively

```json
{
  "tasks": [
    { "id": 1, "title": "Critical Bug Fix", "priority": "high" },
    { "id": 2, "title": "New Feature", "priority": "medium" },
    { "id": 3, "title": "Code Cleanup", "priority": "low" }
  ]
}
```

### 5. Document in details Field

```json
{
  "id": 5,
  "title": "Implement Caching",
  "description": "Add Redis caching layer",
  "details": "Use Redis for session storage. Cache user profiles for 1 hour. Invalidate on user update. Test with 1000+ concurrent users.",
  "testStrategy": "Load test with k6. Verify cache hits > 80%. Test invalidation works."
}
```

### 6. Track Progress with Status Updates

```bash
# Start work
task-master set-status --id=5 --status=in-progress

# Stuck? Mark blocked
task-master set-status --id=5 --status=blocked

# Defer if priorities change
task-master set-status --id=5 --status=deferred

# Complete when done
task-master set-status --id=5 --status=done
```

---

## Integration with Claude Code

### Workflow: Let TaskMaster Guide Claude Code

**1. Start Session:**
```
You: What should I work on next?

Claude: Let me check TaskMaster.
[Calls: mcp__taskmaster-ai__next_task]

Claude: The next task is:
Task 3: Implement API Endpoints
Dependencies satisfied (Task 2 is done)
```

**2. During Work:**
```
You: I'm done with the login endpoint

Claude: Great! Let me mark it complete.
[Calls: mcp__taskmaster-ai__set_task_status(id: "3.1", status: "done")]

Claude: Subtask 3.1 complete. Next subtask is 3.2: Registration endpoint.
```

**3. Check Progress:**
```
You: How much is left?

Claude: [Calls: mcp__taskmaster-ai__get_tasks]

Progress: 5/12 tasks complete (42%)
Currently working on: Task 3 (Implement API Endpoints)
Next up: Task 4 (Write Integration Tests)
```

### Slash Command: /taskmaster-next

Create `.claude/commands/taskmaster-next.md`:

```markdown
Check TaskMaster for the next available task and provide details.

Steps:
1. Call mcp__taskmaster-ai__next_task to get next task
2. If task found:
   - Show task title and description
   - List dependencies (if any)
   - Show implementation details
   - Suggest first step
3. If no tasks:
   - Show completion status
   - Celebrate! 🎉
```

### Slash Command: /taskmaster-done

Create `.claude/commands/taskmaster-done.md`:

```markdown
Mark current task complete and move to next: $ARGUMENTS

Steps:
1. Mark task $ARGUMENTS as done
2. Call next_task to get next available task
3. Show what's next
```

---

## Troubleshooting

### Issue: `next_task` returns null but tasks remain

**Cause:** All pending tasks have unmet dependencies

**Solution:** Check dependencies
```bash
task-master validate-dependencies
task-master list  # Look for circular deps
```

### Issue: Can't edit tasks.json (file locked)

**Cause:** MCP server has file open

**Solution:**
```bash
# Restart Claude Code
# OR
# Edit manually and run:
task-master generate  # Regenerates task files
```

### Issue: Tasks out of sync

**Cause:** Manual edits to tasks.json

**Solution:**
```bash
task-master generate  # Sync everything
```

---

## Real-World Example

### Project: E-Commerce Website

**tasks.json:**
```json
{
  "master": {
    "tasks": [
      {
        "id": 1,
        "title": "Project Setup",
        "description": "Initialize repository and dependencies",
        "status": "done",
        "priority": "high",
        "dependencies": []
      },
      {
        "id": 2,
        "title": "Database Schema",
        "description": "Design and create database tables",
        "status": "done",
        "priority": "high",
        "dependencies": ["1"],
        "subtasks": [
          { "id": "2.1", "title": "Users table", "status": "done" },
          { "id": "2.2", "title": "Products table", "status": "done" },
          { "id": "2.3", "title": "Orders table", "status": "done" }
        ]
      },
      {
        "id": 3,
        "title": "User Authentication",
        "description": "Implement login/registration",
        "status": "in-progress",
        "priority": "high",
        "dependencies": ["2"],
        "subtasks": [
          { "id": "3.1", "title": "JWT setup", "status": "done" },
          { "id": "3.2", "title": "Login endpoint", "status": "in-progress" },
          { "id": "3.3", "title": "Registration endpoint", "status": "pending", "dependencies": ["3.2"] }
        ]
      },
      {
        "id": 4,
        "title": "Product Catalog",
        "description": "Display and search products",
        "status": "pending",
        "priority": "medium",
        "dependencies": ["2"]
      },
      {
        "id": 5,
        "title": "Shopping Cart",
        "description": "Add/remove items, calculate total",
        "status": "pending",
        "priority": "medium",
        "dependencies": ["3", "4"]
      },
      {
        "id": 6,
        "title": "Checkout Process",
        "description": "Payment integration",
        "status": "pending",
        "priority": "high",
        "dependencies": ["5"]
      },
      {
        "id": 7,
        "title": "Order Management",
        "description": "View order history",
        "status": "pending",
        "priority": "low",
        "dependencies": ["6"]
      },
      {
        "id": 8,
        "title": "Admin Dashboard",
        "description": "Manage products and orders",
        "status": "pending",
        "priority": "low",
        "dependencies": ["6"]
      },
      {
        "id": 9,
        "title": "Testing",
        "description": "Write integration tests",
        "status": "pending",
        "priority": "high",
        "dependencies": ["6", "7", "8"]
      },
      {
        "id": 10,
        "title": "Deployment",
        "description": "Deploy to production",
        "status": "pending",
        "priority": "high",
        "dependencies": ["9"]
      }
    ],
    "metadata": {
      "created": "2025-10-11T00:00:00.000Z",
      "updated": "2025-10-11T12:00:00.000Z",
      "description": "E-commerce website development tasks"
    }
  }
}
```

**Current Progress:**
```bash
$ task-master next

Next Task: Task 3 - User Authentication
Status: in-progress
Dependencies: ✅ Task 2 complete

Next Subtask: 3.2 - Login endpoint
```

**Workflow:**
1. Complete subtask 3.2
2. TaskMaster automatically makes 3.3 available
3. Complete all Task 3 subtasks
4. Tasks 4 and 5 become available (parallel work possible!)
5. Continue through dependency chain

---

## Summary

**TaskMaster Data Management Provides:**
- ✅ Clear workflow guidance via `next_task`
- ✅ Automatic dependency tracking
- ✅ Session persistence (survive crashes)
- ✅ Progress visibility
- ✅ No API keys required

**Perfect For:**
- Complex projects with many tasks
- Projects with clear dependencies
- Teams sharing task state
- Long-running projects across multiple sessions

**Not Needed For:**
- Simple linear workflows (< 5 tasks)
- One-off scripts
- Projects without dependencies

**Next Steps:**
1. Initialize TaskMaster in your project
2. Create tasks.json with your workflow
3. Use `next_task` to guide your work
4. Enjoy never losing track again!

---

**Created:** 2025-10-11
**Last Updated:** 2025-10-11
**Version:** 1.0
