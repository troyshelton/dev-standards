# Pre-Commit Checklist

**Use this checklist before EVERY commit to ensure quality and documentation accuracy.**

---

## 1. User Validation (REQUIRED)

**❌ STOP - Do NOT commit until user validates!**

- [ ] **For CCL changes (CRITICAL - See CCL-MODIFICATION-WORKFLOW.md):**
  - Find working example from another project (sepsis dashboard, etc.)
  - Show side-by-side comparison: current vs proposed vs working example
  - Reference CCL_SYNTAX_GUIDE.md section
  - Explain why this pattern works
  - Wait for explicit "approved" confirmation
  - Make ONLY the approved change
  - Show git diff for final verification
  - **NO ASSUMPTIONS** - CCL syntax is complex and differs from SQL

- [ ] **For UI changes:**
  - Share screenshot from Chrome DevTools MCP
  - OR provide test URL for user to verify in their browser
  - Wait for explicit approval: "Looks good!" or "Approved"

- [ ] **For functionality changes:**
  - Describe what changed in plain language
  - Explain how to test it
  - Wait for explicit approval

**Only proceed after user says:** "approved", "looks good", "commit it", or similar

---

## 2. Documentation Update (REQUIRED)

### Update CLAUDE.md Header

```bash
# Lines 7, 13, 891
- [ ] Last Updated: 2025-10-09 (today's date)
- [ ] Current Version: 1.X.X (new version)
- [ ] What's Working section reflects current features
- [ ] Outstanding TODOs reflect actual open issues (no closed issues listed)
```

### Update README.md Header

```bash
# Lines 14, 18
- [ ] Version in status table: 1.X.X (new version)
- [ ] Last Updated in status table: 2025-10-09 (today's date)
- [ ] What's Working section reflects current features
- [ ] Outstanding TODOs reflect actual open issues (no closed issues listed)
```

### Verify References

- [ ] Both files link to CHANGELOG.md
- [ ] Both files link to GitHub Issues
- [ ] No references to deleted/archived projects

---

## 3. Code Quality

- [ ] Test changes locally
- [ ] No console errors in browser
- [ ] Search/filter works
- [ ] Table renders correctly
- [ ] All features work as expected

---

## 4. Git Workflow

- [ ] Changes made on feature branch (not main)
- [ ] Commit message follows format:
  ```
  type: brief description

  Detailed explanation

  Testing: ...

  Refs #N or Closes #N
  ```

---

## Quick Validation

**⚠️ MANDATORY VERIFICATION BEFORE EVERY COMMIT ⚠️**

Run these commands to verify documentation is synchronized:

```bash
# Get current date (use THIS date, don't hardcode!)
TODAY=$(date '+%Y-%m-%d')
echo "Today's date: $TODAY"

# Verify CHANGELOG has today's date
if grep -q "$TODAY" CHANGELOG.md; then
    echo "✅ CHANGELOG.md has today's date"
else
    echo "❌ CHANGELOG.md missing today's date - UPDATE IT!"
fi

# Verify CLAUDE.md has today's date
if grep -q "Date.*: $TODAY\|Last Updated: $TODAY" CLAUDE.md; then
    echo "✅ CLAUDE.md has today's date"
else
    echo "❌ CLAUDE.md date is out of sync - UPDATE IT!"
fi

# Verify README.md has today's date
if grep -q "Last Updated.*: $TODAY" README.md; then
    echo "✅ README.md has today's date"
else
    echo "❌ README.md date is out of sync - UPDATE IT!"
fi

# Show version summary
echo ""
echo "=== VERSION SUMMARY ==="
echo "CHANGELOG: $(grep -m1 "^## \[" CHANGELOG.md || echo 'NOT FOUND')"
echo "CLAUDE.md: $(grep -m1 "Current Version:" CLAUDE.md || echo 'NOT FOUND')"
echo "README.md: $(grep -m1 "^\*\*Version\*\*:" README.md || echo 'NOT FOUND')"

echo ""
echo "⚠️ ALL three should show the SAME version!"
echo "⚠️ If ANY show ❌ or versions don't match: STOP and update files!"
echo ""
echo "See: /Users/troyshelton/Projects/.standards/DOCUMENTATION-SYNC-PROTOCOL.md"
```

---

**🛑 STOP! If ANY check fails, DO NOT COMMIT! 🛑**

**Update the files, then run the validation again.**

---

**If ALL checks pass ✅, proceed with commit.**
