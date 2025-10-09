# Pre-Commit Checklist

**Use this checklist before EVERY commit to ensure quality and documentation accuracy.**

---

## 1. User Validation (REQUIRED)

**❌ STOP - Do NOT commit until user validates!**

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

**Before committing, run:**

```bash
# Check current version and date in docs
grep "Last Updated:" CLAUDE.md README.md
grep "Version" CLAUDE.md README.md | head -5

# Check for references to deleted repos
grep -r "oracle-jet-mvvm-no-node-mpage" CLAUDE.md README.md

# Check for closed issues in TODO sections
grep -A10 "Outstanding TODOs" CLAUDE.md README.md

# Verify files staged
git status
```

---

**If ANY checkbox is unchecked, DO NOT COMMIT!**
