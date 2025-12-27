# Session Start Protocol for AI Assistants

**PURPOSE:** Smart project resumption - concise for synced projects, full menu for new/unsynced projects

**WHEN:** User says trigger phrases like "resume [project]", "let's work on [project]", "start [project]"

---

## Trigger Detection

**Trigger Phrases** (case-insensitive, partial match):
- "resume [project name]"
- "let's work on [project]"
- "start working on [project]"
- "continue [project]"
- "back to [project]"
- "what's the status of [project]"
- "where are we with [project]"

**Explicit Menu Request** (always show full menu):
- "show workflows"
- "show available workflows"
- "what workflows exist"
- "list workflows"

**Note:** If user starts with specific task ("fix bug X"), skip protocol and proceed with task

---

## Protocol Steps

### Step 1: Read Project Documentation (REQUIRED)

Read these files in order:
1. Project `CLAUDE.md` (current state, version, status)
2. Project `README.md` (overview, quick status)
3. Project `CHANGELOG.md` (recent changes)
4. Global `/Users/troyshelton/Projects/CLAUDE.md` (standards)

**Extract:**
- Current version number
- Last update date
- Current git branch
- Current status/what's pending
- What's working vs what needs work

---

### Step 2: Determine Project Type

**Check if project is EXISTING or NEW:**

**EXISTING Project Indicators:**
- CLAUDE.md exists
- README.md exists
- CHANGELOG.md exists
- Git repository initialized

**NEW Project Indicators:**
- CLAUDE.md missing
- README.md missing or minimal
- No CHANGELOG.md
- OR user explicitly said "new project"

---

### Step 3: Check Documentation Sync Status (EXISTING Projects Only)

**Extract versions from each file:**
```bash
# Get versions
CHANGELOG_VERSION=$(grep -m1 "^## \[" CHANGELOG.md | sed 's/## \[\(.*\)\].*/\1/')
CLAUDE_VERSION=$(grep -m1 "Current Version: v" CLAUDE.md | sed 's/.*v\([0-9.]*\).*/\1/')
README_VERSION=$(grep -m1 "\*\*Version\*\*: v" README.md | sed 's/.*v\([0-9.]*\).*/\1/')

# Get dates
CHANGELOG_DATE=$(grep -m1 "^## \[.*\] -" CHANGELOG.md | sed 's/.*- \(.*\)/\1/')
CLAUDE_DATE=$(grep -m1 "\*\*Date\*\*:" CLAUDE.md | sed 's/.*: \(.*\)/\1/')
README_DATE=$(grep -m1 "\*\*Last Updated\*\*:" README.md | sed 's/.*: \(.*\)/\1/')
```

**Determine sync status:**
- **IN SYNC:** All versions match AND all dates match (or very close)
- **OUT OF SYNC:** Versions don't match OR dates differ significantly

---

### Step 4: Check Available Tools

**Check MCP Servers:**
- Is TaskMaster MCP enabled? (check for mcp__taskmaster-ai__* commands)
- Is Context7 MCP enabled? (check if available)

**Scan for Workflows:**
- List all .md files in `/Users/troyshelton/Projects/.standards/WORKFLOWS/`
- Exclude: README.md, TASKMASTER-USAGE-GUIDE.md, TEMPLATE-BLANK.md, WORKFLOW-MENU.md
- Each remaining file is a workflow

---

### Step 4.5: Auto-Enforce Healthcare Production Workflows

**Trigger Detection (PRIMARY METHOD):**

**Check project CLAUDE.md header for explicit Project Type flag:**
```markdown
**Project Type:** Healthcare Production
```

**If found, Claude MUST automatically enforce workflows.**

**Fallback Detection (if no explicit flag, check ANY of these):**
1. Project CLAUDE.md contains "HEALTHCARE PRODUCTION ENFORCEMENT" section
2. Project path contains "sepsis", "patient-safety", "clinical-decision"
3. Project CLAUDE.md mentions "production healthcare system", "patient safety", "clinical decision support"
4. User explicitly says "healthcare production" in resume command

**If ANY trigger detected, Claude MUST:**

**A) Automatically invoke `/enforce-workflows` command**
   - Do this BEFORE showing project status
   - This loads the mandatory workflow requirements into session context
   - User will see the acknowledgment happen

**B) Show explicit acknowledgment:**

```
🛑 HEALTHCARE PRODUCTION ENFORCEMENT ACTIVATED

I have automatically loaded and will follow these MANDATORY workflows:

✅ Deployment Verification
   - Show full deployment command (source, destination, account)
   - Wait for "approved" before executing
   - See: .standards/WORKFLOWS/DEPLOYMENT-VERIFICATION-WORKFLOW.md

✅ Code Review
   - Show code changes before deploying
   - Explain what, why, how
   - Wait for user review and approval
   - See: .standards/WORKFLOWS/CODE-REVIEW-WORKFLOW.md

✅ Validation Gates
   - STOP at every 🛑 TaskMaster subtask
   - Show summary of work completed
   - WAIT for user approval before proceeding
   - See: .standards/WORKFLOWS/VALIDATION-GATE-PROTOCOL.md

[If violations documented in project CLAUDE.md:]
⚠️ Violation History:
[List violations from CLAUDE.md]

I acknowledge these workflows are REQUIRED. I will follow them without exception.

---
```

**This creates an explicit contract at the start of every healthcare production session.**

**Why Automatic Invocation:**
- ❌ Manual `/enforce-workflows` requires user to remember
- ✅ Auto-invoke ensures enforcement is ALWAYS active for healthcare projects
- ✅ Visible to user (they see it happen)
- ✅ Creates audit trail (acknowledgment is part of session start)

**If Claude skips this step for a healthcare project:**
- User can point to this protocol
- User can say: "Read SESSION-START-PROTOCOL Step 4.5"
- Claude must then acknowledge before continuing

---

### Step 4.6: Unknown Project Type Check (Gap Prevention)

**Purpose:** Close the gap for projects without explicit Project Type flags or fallback detection.

**When to Apply:**
- No CLAUDE.md exists OR
- CLAUDE.md exists but has no `**Project Type:**` flag AND
- No fallback triggers detected (keywords, path patterns, etc.)

**Claude MUST ask:**

```
⚠️ PROJECT TYPE UNKNOWN

I couldn't detect a Project Type flag in this project.

Is this a healthcare production system that requires mandatory enforcement workflows?

Healthcare production includes:
- Patient data, clinical decision support, EHR/EMR systems
- Hospital/clinic production systems
- Systems subject to HIPAA or patient safety regulations

Reply:
- "yes" to enable mandatory enforcement
- "no" for normal workflows
```

**If user replies "yes":**
1. Immediately invoke `/enforce-workflows` command
2. Show enforcement acknowledgment
3. Suggest creating CLAUDE.md with Project Type flag:
   ```
   📝 RECOMMENDATION: Add Project Type flag to CLAUDE.md

   This enables automatic enforcement in future sessions.

   Template available at: .standards/HEALTHCARE-PROJECT-TEMPLATE.md

   Would you like me to create/update CLAUDE.md with the healthcare header?
   ```
4. Proceed with enforcement active for this session

**If user replies "no":**
1. Continue with normal workflows (no enforcement)
2. Optionally suggest creating CLAUDE.md for documentation purposes
3. Proceed with project work

**Why This Matters:**
- ✅ Catches new healthcare projects before first deployment
- ✅ Prevents Issue #78-style violations on initial setup
- ✅ User maintains control (explicit yes/no)
- ✅ Provides path to permanent solution (adding flag)
- ✅ Creates audit moment (user consciously decides)

**Edge Case - User Unsure:**

If user says "I'm not sure" or asks for guidance:

```
Let me help you determine if this is healthcare production:

Ask yourself:
1. Does this system access patient data or clinical information?
2. Is this deployed in a hospital/clinic production environment?
3. Could errors impact patient safety or care quality?
4. Is this subject to HIPAA or healthcare compliance requirements?

If YES to any of these → This is healthcare production (enable enforcement)
If NO to all of these → This is not healthcare production (normal workflows)

Reply: yes/no/still-unsure
```

If "still-unsure", default to **YES** (enable enforcement) - safer to have enforcement when uncertain.

---

### Step 5: Present Response (Context-Dependent)

## OPTION A: Existing Project + Docs IN SYNC

**Present concise status:**

```markdown
📋 [Project Name] v[X.Y.Z] ([YYYY-MM-DD])
🔧 Branch: [branch-name]
📊 Status: [Current status from CLAUDE.md]

🎯 Next: [What's pending/next action from CLAUDE.md]

MCP: TaskMaster ✅ Context7 ✅

Ready to continue? (Say "show workflows" for full menu)
```

**Keep it brief!** User knows the project, docs tell the story.

---

## OPTION B: New Project OR Docs OUT OF SYNC

**Present full workflow menu:**

```markdown
📋 **Project:** [Project Name] [OR "New Project"]
📌 **Current:** v[X.Y.Z] ([YYYY-MM-DD]) [OR "Not initialized"]

[If out of sync, show warning:]
⚠️ **DOCUMENTATION OUT OF SYNC:**
   CHANGELOG: v1.7.3 (2025-10-10)
   CLAUDE.md: v1.7.0 (2025-01-31)
   README.md: v1.7.0 (2025-02-07)

🤖 **MCP Tools Available:**
  [✅/❌] TaskMaster - Enforced sequential workflows
  [✅/❌] Context7 - Up-to-date documentation

📝 **Available Workflows:**
  1. **Documentation Sync** (8 tasks, 2 validation gates)
     └─ Keep CHANGELOG, CLAUDE.md, README.md synchronized

  2. **Git Enhancement** (10+ tasks, 6 validation gates)
     └─ Full Issue → Branch → Tag workflow

  3. [Any custom workflows found in WORKFLOWS/]

[If out of sync:]
🛑 **REQUIRED:** Run doc-sync workflow first to fix documentation

[If new project:]
🎯 **Recommended:** Start with Git Enhancement workflow

What would you like to work on?
```

---

## Decision Tree

```
User says "resume [project]"
  |
  ├─> Project exists? (CLAUDE.md + README.md found)
  |     |
  |     ├─> YES - Check sync status
  |     |     |
  |     |     ├─> IN SYNC → Use OPTION A (concise)
  |     |     └─> OUT OF SYNC → Use OPTION B (full menu with warning)
  |     |
  |     └─> NO → Use OPTION B (full menu for new project)
  |
  └─> User says "show workflows"
        └─> Use OPTION B (full menu always)
```

---

### Step 4: Context-Aware Suggestions

**Generate based on project state:**

**If on feature branch:**
```
⚡ Continue: [Brief description of current work from CLAUDE.md]
🔄 Status Check: Review progress and next steps
```

**If on main branch:**
```
🆕 New Enhancement: Start git-enhancement workflow
📝 Fix Docs: Run doc-sync if docs drifted
```

**If version in CHANGELOG newer than CLAUDE.md:**
```
⚠️ WARNING: Documentation out of sync!
   CHANGELOG: v1.7.3
   CLAUDE.md: v1.7.0

   Recommend: Run doc-sync workflow immediately
```

**If there are uncommitted changes:**
```
⚠️ Uncommitted changes detected
   Modified: [list files]

   Recommend: Complete current work or stash changes
```

---

## User Response Handling

### If User Selects Workflow

**User says:** "Run workflow 1" OR "Documentation sync" OR "1"

**AI Response:**
```
Starting Documentation Sync workflow...

I'll use TaskMaster MCP to create 8 sequential tasks based on:
.standards/WORKFLOWS/TASKMASTER-DOC-SYNC.md

This workflow has 2 validation gates:
- After updating CHANGELOG (you review entry)
- After syncing all files (you verify ✅)

Ready to begin?
```

**Then:** Load workflow template, use TaskMaster to create tasks, begin execution

---

### If User Wants to Create New Workflow

**User says:** "Create new workflow" OR "3" (if that's custom workflow option)

**AI Response:**
```
I'll help you create a custom workflow template.

What process would you like to automate?
Examples:
- CCL program deployment
- Production hotfix
- Component creation
- Code review
- Security audit

Please describe the process you want to workflow-ize.
```

**Then:** Guide user through creating workflow from TEMPLATE-BLANK.md

---

### If User Wants Specific Action

**User says:** "Let's merge v1.7.3" OR "Start new feature for export to Excel"

**AI Response:**
```
For merging v1.7.3, I recommend using the Git Enhancement workflow
(steps 4-10, since issue/branch already exist).

This ensures:
- Documentation gets synced first
- Changes reviewed before merge
- Proper tagging with issue closure
- Clean branch cleanup

Would you like me to:
A) Run the workflow (guided, validated)
B) Do it manually (I'll help but no TaskMaster enforcement)

Please choose A or B.
```

---

## Implementation in Global CLAUDE.md

**Add this section at TOP of global CLAUDE.md (after the header warning):**

```markdown
## 🚀 SESSION START PROTOCOL

**AI Assistants:** When user says "resume [project]", "let's work on [project]", or similar:

1. **IMMEDIATELY** read project documentation:
   - Project CLAUDE.md
   - Project README.md
   - Project CHANGELOG.md

2. **CHECK** available MCP tools:
   - TaskMaster MCP enabled?
   - Context7 MCP enabled?

3. **SCAN** for workflows:
   - List all .md files in .standards/WORKFLOWS/

4. **PRESENT** workflow menu using format from:
   `.standards/SESSION-START-PROTOCOL.md`

5. **WAIT** for user to choose what to work on

**This provides guided, professional project management from the start!**

See: `.standards/SESSION-START-PROTOCOL.md` for complete protocol
```

### Files to Create

1. `.standards/SESSION-START-PROTOCOL.md` (the guide I'll create)
2. `.standards/WORKFLOWS/WORKFLOW-MENU.md` (workflow catalog)
3. Update global CLAUDE.md (add SESSION START section at top)

### How This Gets Triggered

**AI reads global CLAUDE.md** → Sees SESSION START PROTOCOL at top → Knows to present menu when user says trigger words

**User says "resume"** → AI follows protocol → Presents menu → User chooses → Work begins with proper workflow

**Result:** You never have to remember workflow names or what's available - the menu reminds you every time!

### Benefits

✅ Automatic workflow discovery
✅ Context-aware suggestions
✅ Professional project start
✅ Never forget available workflows
✅ Guided workflow selection
✅ Extensible (new workflows appear automatically)