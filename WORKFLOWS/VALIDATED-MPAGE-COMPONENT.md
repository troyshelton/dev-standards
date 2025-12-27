# Validated MPage Development Pattern - Custom Component

**Purpose:** Development pattern for custom components embedded in Bedrock MPages
**Use For:** Reusable components in consolidated custom-components.js
**Validation:** Two-phase + Bedrock integration testing

---

## Overview

Custom components require:

1. **CCL Phase** - Backend data retrieval (if needed)
2. **Component Phase** - Build/update component code
3. **Web Phase** - Test component standalone
4. **Integration Phase** - Add to consolidated file and test in Bedrock
5. **Deployment Phase** - Deploy to static content location

---

## Task Pattern Template

```json
{
  "id": N,
  "title": "Component Feature Name",
  "description": "What this component does",
  "status": "pending",
  "priority": "high",
  "dependencies": [],
  "subtasks": [
    {
      "id": "N.1",
      "title": "CCL PHASE: Update Data Query (if needed)",
      "description": "Modify CCL to provide data for component",
      "status": "pending",
      "dependencies": [],
      "details": "If component needs new data, update CCL query. Otherwise skip this phase.",
      "testStrategy": "Query returns needed data or phase skipped"
    },
    {
      "id": "N.2",
      "title": "🛑 USER VALIDATION: CCL Response (if CCL changed)",
      "description": "Verify CCL provides correct data",
      "status": "pending",
      "dependencies": ["N.1"],
      "details": "USER checks JSON response includes fields needed by component. Skip if no CCL changes.",
      "testStrategy": "JSON has required fields or phase skipped"
    },
    {
      "id": "N.3",
      "title": "COMPONENT: Write/Update Component Code",
      "description": "Develop the custom component",
      "status": "pending",
      "dependencies": ["N.2"],
      "details": "Create or modify component in standalone file. Follow MPage.namespace pattern. Include registration, methods, event handlers.",
      "testStrategy": "Component code complete, no syntax errors"
    },
    {
      "id": "N.4",
      "title": "COMPONENT: Create Test HTML Page",
      "description": "Build test harness for component",
      "status": "pending",
      "dependencies": ["N.3"],
      "details": "Create test page that loads component with mock data. Allows testing component in isolation.",
      "testStrategy": "Test page loads component successfully"
    },
    {
      "id": "N.5",
      "title": "WEB PHASE: Test Component with Live Server",
      "description": "Run component in browser",
      "status": "pending",
      "dependencies": ["N.4"],
      "details": "Start live server with test page. Component should render and function."
    },
    {
      "id": "N.6",
      "title": "🛑 VALIDATION: Console Check",
      "description": "Verify no JavaScript errors",
      "status": "pending",
      "dependencies": ["N.5"],
      "details": "Use mcp__chrome-devtools__list_console_messages. Zero errors required.",
      "testStrategy": "Console clean, component renders"
    },
    {
      "id": "N.7",
      "title": "🛑 VALIDATION: Component Functionality",
      "description": "Verify component works correctly",
      "status": "pending",
      "dependencies": ["N.6"],
      "details": "Test all component features: clicks, data display, interactions. Take screenshot.",
      "testStrategy": "Component behaves as expected"
    },
    {
      "id": "N.8",
      "title": "Screenshot Component",
      "description": "Document working component",
      "status": "pending",
      "dependencies": ["N.7"],
      "details": "Save to docs/screenshots/task-N-component-name.png"
    },
    {
      "id": "N.9",
      "title": "INTEGRATION: Backup Production File",
      "description": "Backup current custom-components.js",
      "status": "pending",
      "dependencies": ["N.8"],
      "details": "Copy I:\\WININTEL\\static_content\\custom_mpage_content\\custom-components.js to custom-components-[DATE].js.bak",
      "testStrategy": "Backup file created with date stamp"
    },
    {
      "id": "N.10",
      "title": "INTEGRATION: Add to Consolidated File",
      "description": "Integrate component into custom-components.js",
      "status": "pending",
      "dependencies": ["N.9"],
      "details": "Add or update component code in custom-components.js. Maintain existing components. Test syntax.",
      "testStrategy": "Component integrated, file has no syntax errors"
    },
    {
      "id": "N.11",
      "title": "INTEGRATION: Deploy to Test Environment",
      "description": "Deploy consolidated file to test location",
      "status": "pending",
      "dependencies": ["N.10"],
      "details": "Copy custom-components.js to test static content location. Clear cache if needed.",
      "testStrategy": "File deployed to test environment"
    },
    {
      "id": "N.12",
      "title": "🛑 USER VALIDATION: Test in Bedrock MPage",
      "description": "Verify component in embedded context",
      "status": "pending",
      "dependencies": ["N.11"],
      "details": "USER MUST: Open PowerChart, navigate to Bedrock MPage that embeds this component. Verify component loads and functions correctly within Bedrock. Check for console errors in Citrix browser.",
      "testStrategy": "Component visible in Bedrock, works correctly, no errors"
    },
    {
      "id": "N.13",
      "title": "Commit Component Changes",
      "description": "Git commit for validated component",
      "status": "pending",
      "dependencies": ["N.12"],
      "details": "git add component file and custom-components.js, commit 'feat: [component] (task N)'"
    },
    {
      "id": "N.14",
      "title": "Update Documentation",
      "description": "Document component changes",
      "status": "pending",
      "dependencies": ["N.13"],
      "details": "CHANGELOG: add component update. docs/: document component API. README: note which Bedrock MPages use this component."
    },
    {
      "id": "N.15",
      "title": "DEPLOYMENT: Deploy to Production",
      "description": "Deploy consolidated file to production",
      "status": "pending",
      "dependencies": ["N.14"],
      "details": "Deploy custom-components.js to I:\\WININTEL\\static_content\\custom_mpage_content\\. Record deployment date and time.",
      "testStrategy": "Production file updated"
    },
    {
      "id": "N.16",
      "title": "🛑 USER VALIDATION: Production Verification",
      "description": "Verify component in production Bedrock",
      "status": "pending",
      "dependencies": ["N.15"],
      "details": "USER MUST: Open production PowerChart, verify component works in production Bedrock MPage. Test with real workflow.",
      "testStrategy": "Component works in production, stakeholders can see changes"
    }
  ]
}
```

---

## Key Differences from Standalone

### Standalone MPage:
- Separate HTML/JS/CSS files
- Flexible deployment location
- Direct URL access for testing

### Component MPage:
- ✅ **Backup production file first** (critical!)
- ✅ **Integrate into consolidated custom-components.js**
- ✅ **Fixed deployment location** (static content)
- ✅ **Test in Bedrock context** (not standalone)
- ✅ **Visual verification in PowerChart**

---

## Bedrock Integration Testing

### What User Must Verify (N.12):

**1. Open PowerChart:**
```
Navigate to production or test Cerner environment
```

**2. Find Bedrock MPage:**
```
Locate workflow or viewpoint that embeds the component
Example: "Respiratory Assessment" workflow
```

**3. Verify Component Loads:**
```
Component is visible in the MPage
No blank spaces or loading errors
Component displays expected UI
```

**4. Test Component Functionality:**
```
Click buttons, enter data, verify interactions
Component responds correctly
Data saves/loads as expected
```

**5. Check for Errors:**
```
Open browser DevTools in Citrix (F12)
Check Console tab for errors
Note: May have warnings from Bedrock, focus on component-specific errors
```

### What to Report Back to Claude:

```
✅ "Component loads, no errors, functionality works"
OR
❌ "Component doesn't load - getting error: [message]"
OR
❌ "Component loads but button X doesn't work"
```

---

## Component Registration Pattern

Components must follow:
```javascript
// In custom-components.js
MPage.namespace('MPage.CustomComponents.ComponentName', function() {
    // Component code
});
```

**Validation checks:**
- Namespace is unique
- Existing components not broken
- Component registers on page load
- Component accessible from Bedrock

---

## Deployment Checklist

**Pre-Deployment:**
- [ ] Component tested standalone (live server)
- [ ] Console errors = 0
- [ ] Integrated into custom-components.js
- [ ] Production file backed up with date
- [ ] Tested in test Bedrock MPage

**Deployment:**
- [ ] File deployed to: `I:\WININTEL\static_content\custom_mpage_content\`
- [ ] Deployment time recorded
- [ ] Cache cleared (if applicable)

**Post-Deployment:**
- [ ] Verified in production Bedrock MPage
- [ ] Stakeholder notified
- [ ] Documentation updated

---

**Created:** 2025-10-11
**Version:** 1.0
**Last Updated:** 2025-10-11
