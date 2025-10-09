# User Validation Requirements

**CRITICAL:** AI assistants must ALWAYS pause for user validation before committing changes.

---

## Core Principle

**Never commit without explicit user approval.**

This ensures:
- User maintains control over all changes
- No surprises in commit history
- User can test changes in their own environment
- Trust is built through transparency

---

## When to Request Validation

### ALWAYS Pause For:

1. **UI/Visual Changes**
   - Layout modifications
   - Styling updates
   - Component additions/removals
   - Color/theme changes

2. **Functional Changes**
   - New features
   - Bug fixes
   - Logic modifications
   - Data structure changes

3. **Before ANY Commit**
   - Even documentation updates
   - Even "obvious" fixes
   - Even small tweaks

### Exceptions (Extremely Rare):

- User explicitly says "auto-commit all changes"
- User says "I trust you, just commit it"

**Default assumption: ALWAYS ask first**

---

## How to Request Validation

### For UI Changes:

**Template:**
```
I've made the following UI changes:
- [List specific changes]

Here's a screenshot showing the result:
[Take screenshot with Chrome DevTools MCP]

Test URL: http://localhost:XXXX/path/to/page

Please review and let me know if this looks correct.
Should I proceed with committing?
```

### For Functionality Changes:

**Template:**
```
I've implemented the following functionality:
- [List specific changes]

Changes made to:
- file1.js: [what changed]
- file2.html: [what changed]

How to test:
1. [Step-by-step testing instructions]
2. [Expected results]

Please test and let me know if this works as expected.
Should I proceed with committing?
```

### For Documentation Changes:

**Template:**
```
I've updated the following documentation:
- [List files and changes]

Summary of updates:
- [Key changes]

Please review the changes summary above.
Should I proceed with committing?
```

---

## Validation Language to Watch For

### ✅ User Approval Signals:
- "Looks good"
- "Approved"
- "Commit it"
- "Push it"
- "That's correct"
- "Perfect"
- "Go ahead"

### ❌ User Rejection Signals:
- "Wait"
- "Not quite"
- "Let me check"
- "Can you change..."
- "I need to test first"

### ⚠️ Unclear - Ask for Clarification:
- "Okay" (could mean "I understand" not "approved")
- "Thanks" (acknowledgment, not approval)
- Silence (user might be reviewing)

---

## Chrome DevTools MCP for Validation

**For visual changes, always:**

1. **Take screenshot:**
   ```javascript
   mcp__chrome-devtools__take_screenshot
   ```

2. **Provide test URL:**
   ```
   http://localhost:PORT/path/to/page
   ```

3. **Describe what to look for:**
   ```
   "Notice the table rows are now more compact (28px vs 48px).
   You should see about 14 rows visible instead of 7."
   ```

4. **Wait for approval**

---

## Examples

### Good Example ✅

```
Assistant: I've enhanced the table compact density to match Cerner Millennium:
- Row height: 48px → 28px
- Font: 16px → 12px Arial
- Removed checkbox column

Here's a screenshot of the updated table:
[screenshot shown]

Test it yourself: http://localhost:8002/src/index.html

Does this match the Cerner styling you showed me?
Should I proceed with committing?

User: Wow! Looks much better! Yes, commit it.