# Validated Web Development Pattern

**Purpose:** Development pattern for web projects with automated testing gates
**Use For:** Pure HTML/CSS/JavaScript projects, Oracle JET applications
**Validation:** Live server + Chrome DevTools MCP

---

## Task Pattern Template

Use this pattern for each feature/enhancement in web projects:

```json
{
  "id": N,
  "title": "Feature Name",
  "description": "What this feature does",
  "status": "pending",
  "priority": "high",
  "dependencies": [],
  "subtasks": [
    {
      "id": "N.1",
      "title": "Write Code",
      "description": "Implement the feature code",
      "status": "pending",
      "dependencies": []
    },
    {
      "id": "N.2",
      "title": "Start/Refresh Live Server",
      "description": "Launch or reload development server",
      "status": "pending",
      "dependencies": ["N.1"]
    },
    {
      "id": "N.3",
      "title": "🛑 VALIDATION: Check Chrome DevTools Console",
      "description": "Verify no errors in browser console",
      "status": "pending",
      "dependencies": ["N.2"],
      "details": "Use mcp__chrome-devtools__list_console_messages. Must have zero errors. Warnings acceptable if documented.",
      "testStrategy": "Console clean, no red errors, feature loads"
    },
    {
      "id": "N.4",
      "title": "🛑 VALIDATION: Visual Verification",
      "description": "Confirm feature works as expected",
      "status": "pending",
      "dependencies": ["N.3"],
      "details": "Use mcp__chrome-devtools__take_screenshot. Verify feature displays correctly.",
      "testStrategy": "Screenshot shows feature working, UI looks correct"
    },
    {
      "id": "N.5",
      "title": "Take Screenshot for Documentation",
      "description": "Capture working feature",
      "status": "pending",
      "dependencies": ["N.4"],
      "details": "Save to docs/screenshots/task-N-feature-name.png",
      "testStrategy": "Screenshot saved and clearly shows feature"
    },
    {
      "id": "N.6",
      "title": "Commit Validated Feature",
      "description": "Create git commit for validated code",
      "status": "pending",
      "dependencies": ["N.5"],
      "details": "git add affected files, commit with 'feat: [description] (task N)'",
      "testStrategy": "Commit created successfully, files tracked"
    },
    {
      "id": "N.7",
      "title": "Update Documentation",
      "description": "Document the new feature",
      "status": "pending",
      "dependencies": ["N.6"],
      "details": "Update CHANGELOG.md under [Unreleased]. Add screenshot to docs. Update README if user-facing feature.",
      "testStrategy": "Documentation complete and accurate"
    }
  ]
}
```

---

## Example: Add Data Grid Feature

```json
{
  "id": 1,
  "title": "Add Patient Data Grid",
  "description": "Display patient list in sortable table",
  "status": "pending",
  "priority": "high",
  "dependencies": [],
  "subtasks": [
    {
      "id": "1.1",
      "title": "Create Mock Patient Data",
      "description": "Generate test data for grid",
      "status": "pending",
      "dependencies": [],
      "details": "Create js/data/mockPatients.js with 10 sample patients"
    },
    {
      "id": "1.2",
      "title": "Add oj-table Component",
      "description": "Insert Oracle JET table into HTML",
      "status": "pending",
      "dependencies": ["1.1"],
      "details": "Add oj-table with columns: ID, Name, Age, Risk Score"
    },
    {
      "id": "1.3",
      "title": "Wire Data to Table",
      "description": "Connect mock data via Knockout",
      "status": "pending",
      "dependencies": ["1.2"],
      "details": "Load data in main.js, bind to table with ko.observableArray"
    },
    {
      "id": "1.4",
      "title": "Start Live Server",
      "description": "Launch development server",
      "status": "pending",
      "dependencies": ["1.3"],
      "details": "VS Code Live Server or similar, navigate to page"
    },
    {
      "id": "1.5",
      "title": "🛑 VALIDATION: Console Check",
      "description": "Verify no JavaScript errors",
      "status": "pending",
      "dependencies": ["1.4"],
      "details": "Use Chrome DevTools MCP: list_console_messages. Zero errors required.",
      "testStrategy": "No red errors in console, table renders"
    },
    {
      "id": "1.6",
      "title": "🛑 VALIDATION: Table Functionality",
      "description": "Verify table sorting and display",
      "status": "pending",
      "dependencies": ["1.5"],
      "details": "Take screenshot. Verify: 10 rows visible, data correct, sorting works",
      "testStrategy": "All 10 patients display, columns sortable"
    },
    {
      "id": "1.7",
      "title": "Screenshot Documentation",
      "description": "Capture working table",
      "status": "pending",
      "dependencies": ["1.6"],
      "details": "Save to docs/screenshots/task-1-patient-grid.png"
    },
    {
      "id": "1.8",
      "title": "Commit Feature",
      "description": "Commit validated data grid",
      "status": "pending",
      "dependencies": ["1.7"],
      "details": "git add mockPatients.js, index.html, main.js; commit 'feat: add patient data grid (task 1)'"
    },
    {
      "id": "1.9",
      "title": "Update Documentation",
      "description": "Document data grid feature",
      "status": "pending",
      "dependencies": ["1.8"],
      "details": "CHANGELOG: add to [Unreleased]. README: update features if needed. Add screenshot reference."
    }
  ]
}
```

---

## Chrome DevTools MCP Tools for Validation

### Available Validation Tools

**Console Checking:**
```javascript
mcp__chrome-devtools__list_console_messages()
// Returns all console logs, errors, warnings
```

**Screenshots:**
```javascript
mcp__chrome-devtools__take_screenshot({
  filePath: "docs/screenshots/feature.png"
})
```

**Page Navigation:**
```javascript
mcp__chrome-devtools__navigate_page({
  url: "http://localhost:5500/src/index.html"
})
```

**Element Interaction (for testing):**
```javascript
mcp__chrome-devtools__click({ uid: "button-id" })
mcp__chrome-devtools__fill({ uid: "input-id", value: "test" })
```

### Typical Validation Sequence

```bash
# Subtask N.2: Start live server
[User starts VS Code Live Server]

# Subtask N.3: Navigate to page
mcp__chrome-devtools__navigate_page(url)

# Subtask N.4: Check console
messages = mcp__chrome-devtools__list_console_messages()
if (errors found):
  STOP - fix errors first
else:
  proceed to next subtask

# Subtask N.5: Visual check
mcp__chrome-devtools__take_screenshot()
# Review screenshot
if (looks wrong):
  STOP - fix UI first
else:
  proceed to commit
```

---

## When to Use This Pattern

**✅ Use for:**
- Pure web projects (no backend)
- Frontend-only enhancements
- UI/UX changes
- Static websites
- Oracle JET applications
- Client-side logic

**❌ Don't use for:**
- MPage projects (use VALIDATED-MPAGE templates instead)
- CCL programs (use VALIDATED-CCL template)
- Projects requiring backend validation

---

## Benefits

1. **Automated Testing Gates**
   - Chrome DevTools MCP catches errors automatically
   - No "it worked on my machine" problems

2. **Incremental Validation**
   - Each feature validated before commit
   - Prevents accumulating broken code

3. **Documentation Trail**
   - Screenshots prove features work
   - Clear visual history of development

4. **Fast Feedback Loop**
   - Know immediately if something broke
   - Fix issues while context is fresh

---

**Created:** 2025-10-11
**Version:** 1.0
**Last Updated:** 2025-10-11
