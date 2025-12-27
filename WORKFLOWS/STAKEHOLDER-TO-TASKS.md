# Stakeholder Requirements to TaskMaster Tasks Workflow

**Purpose:** Convert stakeholder feedback into structured, validated TaskMaster tasks
**Use For:** Emails, meeting transcripts, issue lists, change requests
**Output:** TaskMaster tasks.json with validation gates

---

## Quick Start

**User says:**
```
"Let's use TaskMaster for this request"
OR
"I have stakeholder feedback to convert to tasks"
```

**Claude responds with this workflow.**

---

## Workflow Steps

### Step 1: Gather Context

**Claude asks:**
```
I'll help convert stakeholder feedback into TaskMaster tasks!

Please provide:

1. **Project Information:**
   - Project name
   - Is this a NEW project or EXISTING project?

2. **Project Type:**
   - Web Project (HTML/CSS/JS only)
   - MPage Standalone (CCL + Web, separate deployment)
   - MPage Component (embedded in Bedrock)
   - CCL Program (backend only)
   - Other

3. **Requirements Source:**
   Please paste one of:
   - Stakeholder email
   - Meeting transcript
   - Issue list
   - Your description of changes needed
```

**User provides information.**

---

### Step 2: Analyze Requirements

**Claude does:**
1. Read stakeholder input
2. Identify distinct features/changes
3. Determine dependencies between items
4. Estimate complexity
5. Note any unclear requirements

**Claude asks clarifying questions:**
```
I see the following requests:
1. Add timestamp to Hanson table
2. Add color coding for risk levels
3. Add 24-hour filter
4. Add CSV export

Questions:
- Is the Hanson table in the CCL query or just display?
- What defines "high risk" for color coding?
- Should the filter be client-side or server-side?
- CSV export should include all fields or subset?
```

**User clarifies ambiguous requirements.**

---

### Step 3: Select Appropriate Template

**Based on project type, Claude chooses:**

| Project Type | Template | Validation Pattern |
|--------------|----------|-------------------|
| Web Project | VALIDATED-WEB-DEVELOPMENT.md | Live server + Chrome DevTools |
| MPage Standalone | VALIDATED-MPAGE-STANDALONE.md | CCL (user) + Web (DevTools) |
| MPage Component | VALIDATED-MPAGE-COMPONENT.md | CCL (user) + Bedrock (user) + Web (DevTools) |
| CCL Program | VALIDATED-CCL-DEVELOPMENT.md | User validates in Cerner environment |

**Claude announces:**
```
Based on "MPage Component" project type, I'll use the
VALIDATED-MPAGE-COMPONENT.md pattern.

This includes:
- CCL validation gates (you verify in Citrix)
- Web validation gates (I verify with Chrome DevTools)
- Bedrock integration testing (you verify in PowerChart)
- Production deployment to static content location
```

---

### Step 4: Create TaskMaster Tasks

**Claude creates tasks:**

```
Converting stakeholder requests to TaskMaster tasks...

Stakeholder Request: "Add timestamp to Hanson table"
→ Task 1: Add Vitals Timestamp to Hanson Table (13 subtasks)
  - CCL Phase: 4 subtasks (N.1-N.4)
  - Web Phase: 5 subtasks (N.5-N.9)
  - Integration Phase: 2 subtasks (N.10-N.11)
  - Deployment Phase: 2 subtasks (N.12-N.13)

Stakeholder Request: "Add color coding for risk levels"
→ Task 2: Add Color Coding (depends on Task 1)
  - [subtasks following same pattern]

Dependencies identified:
- Task 2 depends on Task 1 (shares same table)
- Task 3 depends on Task 1 (filter needs timestamp)
- Task 4 can be parallel (CSV export independent)
```

**Claude generates actual tasks.json:**
```json
{
  "master": {
    "tasks": [
      {
        "id": 1,
        "title": "Add Vitals Timestamp to Hanson Table",
        "description": "Display last vitals reading time",
        "status": "pending",
        "priority": "high",
        "dependencies": [],
        "subtasks": [ ... ]
      },
      {
        "id": 2,
        "title": "Add Color Coding for Risk Levels",
        "description": "Red/yellow/green indicators",
        "status": "pending",
        "priority": "high",
        "dependencies": ["1"],
        "subtasks": [ ... ]
      }
    ]
  }
}
```

---

### Step 5: Review and Approve

**Claude shows:**
```
Created 4 tasks with 52 total subtasks:

Task 1: Add Vitals Timestamp (13 subtasks, 4 validation gates)
Task 2: Add Color Coding (12 subtasks, 4 validation gates)
Task 3: Add 24-hour Filter (11 subtasks, 3 validation gates)
Task 4: Add CSV Export (10 subtasks, 3 validation gates)

Dependencies:
- Tasks 2 & 3 depend on Task 1
- Task 4 is independent (can work in parallel)

Estimated duration: 2-3 days with testing

Does this look correct? Reply "approved" to load into TaskMaster,
or provide feedback for adjustments.
```

**User reviews and approves or requests changes.**

---

### Step 6: Load into TaskMaster

**Claude writes tasks to project:**

```bash
# Write to tasks.json
[Writes generated tasks to .taskmaster/tasks/tasks.json]

# Verify TaskMaster can read it
mcp__taskmaster-ai__get_tasks()

Success! TaskMaster loaded with:
- 4 main tasks
- 52 subtasks
- 14 validation gates
```

---

### Step 7: Begin Execution

**Claude starts workflow:**
```
TaskMaster says: Begin with Task 1, Subtask 1.1

Subtask 1.1: Modify CCL query to include vitals timestamp

I'll update the query now...
[Makes changes]

Subtask 1.1 complete. Next: 1.2 - Update main CCL program
```

**Workflow continues using `next_task` guidance.**

---

## Example Scenarios

### Scenario 1: Email with Feature Requests

**User provides:**
```
From: Dr. Smith
Subject: Respiratory Dashboard Updates

We need these changes for the quarterly review:

1. Add SpO2 trend chart (last 24 hours)
2. Show medication administration times
3. Filter for ICU patients only
4. Add "print report" button

Thanks!
```

**Claude converts:**
```
Task 1: Add SpO2 Trend Chart
  Dependencies: []
  Pattern: VALIDATED-MPAGE-STANDALONE
  Subtasks: 14 (CCL phase + Web phase + Deployment)

Task 2: Show Medication Times
  Dependencies: [1] (uses same CCL query structure)
  Pattern: VALIDATED-MPAGE-STANDALONE
  Subtasks: 12

Task 3: Add ICU Filter
  Dependencies: [1, 2] (filters both features)
  Pattern: Web-only enhancement
  Subtasks: 8

Task 4: Add Print Button
  Dependencies: [1, 2, 3] (prints filtered data)
  Pattern: Web-only enhancement
  Subtasks: 7

Total: 4 tasks, 41 subtasks, ~2 days development + testing
```

---

### Scenario 2: Meeting Transcript

**User provides:**
```
[Transcript from stakeholder meeting]

Clinical Team: "The sepsis component needs to be updated.
We want to see the qSOFA score alongside the SIRS score.
Also, can we make the alert sound configurable?"

Development Team: "We can do that. Any color changes needed?"

Clinical Team: "Yes, qSOFA should be yellow if >= 2"
```

**Claude converts:**
```
Task 1: Add qSOFA Score to Sepsis Component
  Type: MPage Component
  Pattern: VALIDATED-MPAGE-COMPONENT

  Subtasks:
  - CCL Phase: Calculate qSOFA from vitals
  - Component Phase: Update component code
  - Web Phase: Display qSOFA with color coding
  - Integration Phase: Add to custom-components.js
  - Bedrock Testing: Verify in workflow
  - Deployment: Static content location

Task 2: Make Alert Sound Configurable
  Type: Component Enhancement
  Dependencies: [1] (same component)

  Subtasks:
  - Add settings panel to component
  - Store preference in local storage
  - Test different alert sounds
  - Integrate and deploy
```

---

### Scenario 3: Bug Fix List

**User provides:**
```
Issues to fix:
1. Hanson table doesn't sort by name
2. Export button downloads empty file
3. Risk score showing NaN for new patients
```

**Claude converts:**
```
Task 1: Fix Hanson Table Sorting (Priority: HIGH)
  Type: Bug fix
  Pattern: Web-only (if just frontend)
  Subtasks: 7 (diagnose, fix, test, commit, docs)

Task 2: Fix Export Button (Priority: HIGH)
  Type: Bug fix
  Dependencies: [] (independent of Task 1)
  Pattern: Web-only
  Subtasks: 8

Task 3: Fix NaN Risk Score (Priority: CRITICAL)
  Type: Bug fix
  Pattern: May need CCL + Web (depends on root cause)
  Subtasks: 9-14 (depends on whether CCL or web issue)
```

---

## Task Prioritization

**Claude applies:**

### Priority Levels

**Critical:**
- System down / Data corruption / Security issues
- Must fix immediately

**High:**
- Stakeholder requirements / User-facing features
- Requested functionality / Important bugs

**Medium:**
- Enhancements / Nice-to-have features
- Non-blocking issues

**Low:**
- Optimizations / Code cleanup / Documentation only
- Future considerations

### Dependency Analysis

**Claude identifies:**
- Which tasks must be sequential (data dependencies)
- Which tasks can be parallel (independent features)
- Which tasks converge (multiple features join)

**Example:**
```
Stakeholder wants: "New field + export that field"

Task 1: Add new field (HIGH priority)
Task 2: Update export (MEDIUM priority, depends on Task 1)

Cannot do Task 2 until Task 1 complete!
```

---

## Validation Gate Placement

**Claude adds gates at:**

### User Validation Gates (🛑 USER)

**When:**
- CCL compilation needed
- CCL execution needed
- Results accuracy check
- Performance verification
- Citrix/domain testing
- Bedrock integration check
- Production deployment verification

**Why:**
- Claude can't access these environments
- User has domain expertise
- User can see actual data
- User can verify against requirements

### Automated Validation Gates (🛑 VALIDATION)

**When:**
- Chrome DevTools console check
- Screenshot verification
- Live server testing
- Automated tests

**Why:**
- Claude can execute these via MCP
- Automated and repeatable
- Fast feedback loop
- Catches common errors

---

## Documentation Requirements

**Every task includes:**

```json
{
  "details": "Detailed implementation notes",
  "testStrategy": "How to verify completion",
  "subtasks": [
    {
      "id": "N.last",
      "title": "Update Documentation",
      "details": "CHANGELOG: [what changed]. docs/: [relevant docs]. README: [if user-facing]."
    }
  ]
}
```

**Documentation tasks always:**
- Come after code validation
- Come after commits
- Update CHANGELOG, docs/, and README
- Include screenshots where relevant

---

## Real-World Usage

### Complete Example Flow

**1. User starts:**
```
User: "I have feedback from stakeholders on the sepsis dashboard.
       Let's use TaskMaster to track this work."

Claude: [Invokes STAKEHOLDER-TO-TASKS workflow]
        "Great! What type of project is this?"

User: "MPage component embedded in Bedrock"

Claude: "Perfect, I'll use VALIDATED-MPAGE-COMPONENT pattern.
         Please paste the stakeholder feedback."

User: [Pastes email with 5 requests]

Claude: "I see 5 requests. Let me ask some clarifying questions..."
        [Asks 3 questions about ambiguous items]

User: [Provides answers]

Claude: "Creating TaskMaster tasks now...

         Task 1: Update Hanson Table (15 subtasks, 5 gates)
         Task 2: Add Color Coding (13 subtasks, 4 gates)
         Task 3: Implement Filter (11 subtasks, 3 gates)
         Task 4: Add Export Button (10 subtasks, 3 gates)
         Task 5: Update Documentation (8 subtasks, 1 gate)

         Dependencies:
         - Tasks 2-4 all depend on Task 1
         - Task 5 depends on all others

         Total: 57 subtasks, 16 validation gates

         Approve?"

User: "Approved"

Claude: [Writes tasks.json]
        "Tasks loaded! TaskMaster says: Start with Task 1.1 -
         Modify CCL query to add timestamp column..."
```

**2. Development begins:**
```
Claude: "I've updated the query. Here's the change..."
        [Shows CCL code]
        "Ready for subtask 1.2"

Claude: "Subtask 1.2 complete. Subtask 1.3: 🛑 USER VALIDATION

         Please compile the program in Discern Explorer and
         let me know if it compiles successfully."

User: "Compiled successfully"

Claude: "Great! Subtask 1.3 validated. Moving to 1.4..."
```

**3. Validation gate encountered:**
```
Claude: "Subtask 1.7: 🛑 USER VALIDATION - Test CCL in Dev

         Please run the MPage in your development environment
         and verify the JSON response includes 'vitalsTimestamp'.

         I'm waiting for your confirmation..."

User: [Tests in Citrix] "Yes, I see vitalsTimestamp in the JSON"

Claude: "Excellent! CCL phase validated. Moving to Web phase...
         Subtask 1.8: Update HTML to display timestamp column..."
```

**4. Progress tracking:**
```
User: "Where are we at?"

Claude: [Calls mcp__taskmaster-ai__get_tasks]

        "Progress: 23/57 subtasks complete (40%)
         Currently: Task 1, Subtask 1.11 (Integration phase)
         Next gate: 1.12 - Test in Bedrock MPage

         Completed: Tasks 1-2 fully done
         In progress: Task 3, Subtask 3.5
         Blocked: Tasks 4-5 (waiting for Task 3)"
```

---

## Input Types

### Type 1: Formal Email

**Format:**
```
From: [Stakeholder]
Subject: [Topic]
Date: [Date]

Request:
- Item 1
- Item 2
- Item 3

Timeline: [Date]
```

**Claude extracts:**
- Feature list → Tasks
- Timeline → Priority levels
- Context → Implementation details

---

### Type 2: Meeting Transcript

**Format:**
```
[Meeting Date]
Attendees: [Names]

Discussion points:
- [Topic 1]
- [Topic 2]

Action items:
- [Who] will [what] by [when]
```

**Claude extracts:**
- Action items → Tasks
- Discussion context → Task details
- Who owns what → Dependencies
- Timeline → Priorities

---

### Type 3: Issue/Bug List

**Format:**
```
Issues reported:
1. [Bug description]
2. [Bug description]
3. [Feature request]
```

**Claude extracts:**
- Bugs → High priority tasks
- Features → Medium priority
- Dependencies between fixes

---

### Type 4: User Description

**Format:**
```
User: "We need to update the respiratory dashboard.
       Add pulse ox trending and alerts when SpO2 < 90%.
       Also fix the refresh button - it's not working."
```

**Claude extracts:**
- Feature requests → Separate tasks
- Bug fixes → Separate task with high priority
- Implied requirements → Asks for clarification

---

## Task Structure Decision Tree

```
Is this a NEW project?
├─ YES → Use TASKMASTER-PROJECT-INIT.md first
└─ NO → Continue below

Does it involve CCL changes?
├─ YES → Is it standalone or component?
│   ├─ Standalone → VALIDATED-MPAGE-STANDALONE.md
│   └─ Component → VALIDATED-MPAGE-COMPONENT.md
└─ NO → Pure web changes → VALIDATED-WEB-DEVELOPMENT.md

Is it ONLY CCL (no web component)?
└─ YES → VALIDATED-CCL-DEVELOPMENT.md
```

---

## Dependencies Between Tasks

**Claude determines dependencies by asking:**

1. **Does Task B need data from Task A?**
   - YES → B depends on A

2. **Does Task B modify same code as Task A?**
   - YES → B depends on A (avoid conflicts)

3. **Does Task B build on UI from Task A?**
   - YES → B depends on A

4. **Can tasks work in parallel?**
   - YES → No dependency needed

**Examples:**

```
"Add field to table" + "Export that field"
→ Export depends on field (sequential)

"Add chart component" + "Add filter component"
→ No dependency (parallel)

"Update CCL" + "Update matching web display"
→ Web depends on CCL (sequential, phased)
```

---

## Estimating Subtask Count

**Claude estimates based on complexity:**

### Simple Task (< 10 subtasks)
- Pure web UI change
- No CCL changes
- No integration testing
- Example: Change button color

### Medium Task (10-15 subtasks)
- CCL changes OR web changes (not both)
- Standard validation gates
- Example: Add one new field

### Complex Task (15-20 subtasks)
- CCL + Web changes
- Multiple validation phases
- Integration testing required
- Example: New component feature

### Very Complex (20+ subtasks)
- CCL + Web + Integration
- Multiple components affected
- Deployment coordination needed
- Example: Complete workflow redesign

---

## Validation Gate Types

### 🛑 USER VALIDATION: [Description]
**Requires user action:**
- Test in Citrix environment
- Compile in Discern Explorer
- Verify in production domain
- Check with actual stakeholder

**Claude waits for:**
- Explicit confirmation ("Looks good", "Approved", "Verified")
- Error reports (Claude fixes and re-submits for validation)

### 🛑 VALIDATION: [Description]
**Automated by Claude:**
- Chrome DevTools console check
- Screenshot verification
- Live server testing
- Syntax validation

**Claude proceeds automatically** if validation passes.

---

## Handling Unclear Requirements

**If stakeholder request is vague:**

**User provides:**
```
"Make the dashboard better"
```

**Claude asks:**
```
I need more specifics to create tasks. Can you clarify:

1. What specifically should be improved?
   - Performance?
   - UI/UX?
   - New features?
   - Bug fixes?

2. Are there any specific pain points users reported?

3. Is there a priority order?

4. Any deadline or constraints?
```

**User clarifies, Claude creates targeted tasks.**

---

## Updating Tasks from New Feedback

**Scenario: Stakeholder adds requirement mid-project**

**User says:**
```
"Stakeholders just added one more request: Add patient age to the table"
```

**Claude does:**
```
I'll add a new task:

Task 5: Add Patient Age Column
  Dependencies: [1] (same table as timestamp)
  Pattern: VALIDATED-MPAGE-COMPONENT
  Priority: MEDIUM (new request, not critical path)
  Subtasks: 13 (following component pattern)

Adding to TaskMaster...

Current progress: 3/4 tasks complete (Task 4 in progress)
New task 5 added, will work on after Task 4 completes.
```

**Uses:**
```javascript
mcp__taskmaster-ai__add_task({
  // Task details
  // Follows chosen validation pattern
})
```

---

## Tips for Best Results

### 1. Provide Complete Context

**Good:**
```
Project: Sepsis Dashboard (MPage Component)
Stakeholder: Clinical team
Request: [full email pasted]
Deadline: Friday for UAT
```

**Bad:**
```
"Make some changes to sepsis thing"
```

### 2. Clarify Technical Details

**If stakeholder says:**
```
"Add the score"
```

**You clarify:**
```
"They mean the qSOFA score, calculated from:
 - Respiratory rate >= 22
 - Altered mentation (GCS < 15)
 - Systolic BP <= 100"
```

### 3. Specify Deployment Locations

**Good:**
```
"This MPage deploys to Azure:
 https://cabellhealthcare.blob.core.windows.net/mpages/"
```

**Bad:**
```
"Deploy somewhere in the cloud"
```

### 4. Note Testing Constraints

**Helpful:**
```
"I can only test in dev environment 2-4pm weekdays.
 Production testing must be after hours."
```

**Claude adjusts:**
```
Adds note to validation gates:
"USER VALIDATION: Test in dev (weekday 2-4pm window)"
```

---

## Success Criteria

**After this workflow:**
- ✅ All stakeholder requests converted to tasks
- ✅ Appropriate validation pattern selected
- ✅ Dependencies properly identified
- ✅ TaskMaster tasks.json created
- ✅ Ready to begin development with `next_task`
- ✅ Clear validation gates throughout
- ✅ User knows when input is needed
- ✅ Claude knows when to wait
- ✅ Documentation updates built into workflow

---

## Integration with Existing Workflows

**This workflow is the STARTING POINT for:**
- VALIDATED-WEB-DEVELOPMENT.md
- VALIDATED-MPAGE-STANDALONE.md
- VALIDATED-MPAGE-COMPONENT.md
- VALIDATED-CCL-DEVELOPMENT.md

**Process:**
```
STAKEHOLDER-TO-TASKS
  ↓
[Chooses appropriate pattern]
  ↓
Executes chosen pattern for each task
  ↓
All tasks complete
  ↓
Stakeholder demo
```

---

## Troubleshooting

### Issue: "I don't know which pattern to use"

**Ask:**
- Does it involve CCL? (If yes: CCL or MPage pattern)
- Is it embedded in Bedrock? (If yes: Component pattern)
- Is it standalone? (If yes: Standalone pattern)
- Is it web only? (If yes: Web pattern)

### Issue: "Tasks seem too big"

**Solution:**
- Break main tasks into smaller chunks
- Each task = one testable feature
- Use subtasks for implementation steps

### Issue: "Dependencies are unclear"

**Solution:**
- Ask user: "Can these be worked on at the same time?"
- If NO → Add dependency
- If YES → No dependency, parallel work

### Issue: "Validation gates slow us down"

**Response:**
- Gates prevent broken code from progressing
- Faster to catch early than debug later
- User gates can be batched if preferred

---

**Created:** 2025-10-11
**Version:** 1.0
**Last Updated:** 2025-10-11
