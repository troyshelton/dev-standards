# Validated CCL Development Pattern

**Purpose:** Development pattern for standalone CCL programs with testing validation
**Use For:** Database queries, reports, batch processes, data transformations
**Validation:** User-validated in Cerner development environment

---

## Overview

CCL programs require validation in Cerner/Discern environment. Claude assists with:
- Code development
- Syntax checking
- Pattern recommendations
- Documentation

User provides validation:
- Compilation success
- Query execution
- Result verification
- Performance checks

---

## Task Pattern Template

```json
{
  "id": N,
  "title": "CCL Feature/Program Name",
  "description": "What this program does",
  "status": "pending",
  "priority": "high",
  "dependencies": [],
  "subtasks": [
    {
      "id": "N.1",
      "title": "Write CCL Query Logic",
      "description": "Develop SELECT statement and business logic",
      "status": "pending",
      "dependencies": [],
      "details": "Write main SELECT with JOINs, WHERE clauses, calculations. Use CCL syntax (not SQL). Reference CCL_SYNTAX_GUIDE.md.",
      "testStrategy": "Code follows CCL syntax standards, logic appears sound"
    },
    {
      "id": "N.2",
      "title": "Add Report Writer Section",
      "description": "Create HEAD/DETAIL/FOOT sections",
      "status": "pending",
      "dependencies": ["N.1"],
      "details": "Add report writer logic. Define output format. Include counters, totals, grouping as needed.",
      "testStrategy": "Report structure complete"
    },
    {
      "id": "N.3",
      "title": "Add Prompts and Parameters",
      "description": "Define program inputs via prompt section",
      "status": "pending",
      "dependencies": ["N.2"],
      "details": "Add PROMPT section with parameters. Include validation logic for inputs.",
      "testStrategy": "Prompts defined, validation included"
    },
    {
      "id": "N.4",
      "title": "Review CCL Syntax",
      "description": "Check code against CCL standards",
      "status": "pending",
      "dependencies": ["N.3"],
      "details": "Verify: JOIN syntax (outerjoin), no SQL keywords, 30-char limit, number prefix. Reference CCL_SYNTAX_GUIDE.md.",
      "testStrategy": "Code passes syntax review"
    },
    {
      "id": "N.5",
      "title": "🛑 USER VALIDATION: Compilation",
      "description": "Compile program in Discern Explorer",
      "status": "pending",
      "dependencies": ["N.4"],
      "details": "USER MUST: Open program in Discern Explorer. Compile (F7). Check for compilation errors. Report back any errors found.",
      "testStrategy": "Program compiles successfully with no errors"
    },
    {
      "id": "N.6",
      "title": "Fix Compilation Errors (if needed)",
      "description": "Address any errors from compilation",
      "status": "pending",
      "dependencies": ["N.5"],
      "details": "If errors found, fix syntax issues. Re-run N.5. Repeat until clean compilation.",
      "testStrategy": "All compilation errors resolved"
    },
    {
      "id": "N.7",
      "title": "Create Test Execution Parameters",
      "description": "Define test data for program execution",
      "status": "pending",
      "dependencies": ["N.6"],
      "details": "Create .tst file or document test parameters. Include realistic test values that won't affect production data.",
      "testStrategy": "Test parameters documented and safe"
    },
    {
      "id": "N.8",
      "title": "🛑 USER VALIDATION: Execute in Dev Environment",
      "description": "Run program with test parameters",
      "status": "pending",
      "dependencies": ["N.7"],
      "details": "USER MUST: Execute program in development environment. Check results. Verify: correct data returned, calculations accurate, no errors.",
      "testStrategy": "Program runs, results look correct"
    },
    {
      "id": "N.9",
      "title": "🛑 USER VALIDATION: Verify Results Accuracy",
      "description": "Validate output meets requirements",
      "status": "pending",
      "dependencies": ["N.8"],
      "details": "USER MUST: Review output data. Compare to expected results. Verify calculations, totals, counts. Check for missing or incorrect data.",
      "testStrategy": "Results are accurate and complete"
    },
    {
      "id": "N.10",
      "title": "🛑 USER VALIDATION: Performance Check",
      "description": "Verify acceptable execution time and resource usage",
      "status": "pending",
      "dependencies": ["N.9"],
      "details": "USER MUST: Note execution time. Check if acceptable for use case. For large datasets, verify query performance. Note: < 30 seconds ideal, < 2 min acceptable, > 2 min needs optimization.",
      "testStrategy": "Performance acceptable for intended use"
    },
    {
      "id": "N.11",
      "title": "Add Code Comments and Documentation",
      "description": "Document code logic and usage",
      "status": "pending",
      "dependencies": ["N.10"],
      "details": "Add CCL comments explaining: purpose, parameters, business logic, output format. Create docs/api/program-name.md.",
      "testStrategy": "Code well-commented, API documented"
    },
    {
      "id": "N.12",
      "title": "Commit CCL Program",
      "description": "Create git commit for validated program",
      "status": "pending",
      "dependencies": ["N.11"],
      "details": "git add src/*.prg src/*.tst docs/api/; commit 'feat: [program name] (task N)'"
    },
    {
      "id": "N.13",
      "title": "Update Project Documentation",
      "description": "Update CHANGELOG and README",
      "status": "pending",
      "dependencies": ["N.12"],
      "details": "CHANGELOG: add program. README: update status if needed. Document test parameters and expected runtime."
    },
    {
      "id": "N.14",
      "title": "🛑 USER VALIDATION: Test Environment Full Test",
      "description": "Run full test with production-like data",
      "status": "pending",
      "dependencies": ["N.13"],
      "details": "USER MUST: Execute in test environment with larger dataset. Verify performance, accuracy, error handling.",
      "testStrategy": "Works with realistic data volumes"
    },
    {
      "id": "N.15",
      "title": "DEPLOYMENT: Deploy to Production",
      "description": "Deploy CCL program to production server",
      "status": "pending",
      "dependencies": ["N.14"],
      "details": "Deploy compiled program to production Cerner server. Follow client deployment procedures. Record deployment date/time.",
      "testStrategy": "Program deployed successfully"
    },
    {
      "id": "N.16",
      "title": "🛑 USER VALIDATION: Production Verification",
      "description": "Verify in production environment",
      "status": "pending",
      "dependencies": ["N.15"],
      "details": "USER MUST: Execute program in production. Verify works as expected. Monitor for errors. Confirm meets stakeholder requirements.",
      "testStrategy": "Program works in production, ready for stakeholder demo"
    }
  ]
}
```

---

## Critical CCL-Specific Checks

### During Development (Claude assists):

**1. CCL Syntax Validation:**
- ✅ JOIN uses `outerjoin()` pattern
- ✅ No SQL keywords (LEFT JOIN, AS, etc.)
- ✅ FROM clause has no parentheses
- ✅ Program name < 30 characters
- ✅ Program name starts with number
- ✅ NULL checks appropriate (0 for numeric, IS NULL for dates)
- ✅ expand() pattern correct

**2. Code Pattern Review:**
- ✅ Working patterns preserved
- ✅ Record structures valid
- ✅ No record paths in ORDER BY with DUMMYT
- ✅ Counters reset at correct HEAD levels

**3. Documentation:**
- ✅ Comments explain complex logic
- ✅ Parameter usage documented
- ✅ Output format specified

### During Execution (User validates):

**1. Compilation (N.5):**
```
User reports:
✅ "Compiled successfully"
OR
❌ "Error on line 47: [error message]"
```

**2. Execution (N.8):**
```
User reports:
✅ "Ran successfully, returned 150 records"
OR
❌ "Failed with error: [message]"
```

**3. Accuracy (N.9):**
```
User reports:
✅ "Results match expected output"
OR
❌ "Missing data for patient XYZ"
OR
❌ "Calculation incorrect: expected 50, got 75"
```

**4. Performance (N.10):**
```
User reports:
✅ "Ran in 45 seconds with 5000 records - acceptable"
OR
❌ "Taking 5 minutes - too slow for production use"
```

---

## Common CCL Validation Issues

### Issue: Compilation Error - JOIN syntax

**User reports:**
```
Error: Syntax error on line 25
LEFT JOIN table_alias
```

**Claude fixes:**
```ccl
; Change from SQL style
LEFT JOIN encounter e ON e.person_id = p.person_id

; To CCL style
join encounter e
  where e.person_id = outerjoin(p.person_id)
```

**Re-run:** N.5 (compilation)

### Issue: Query Returns No Data

**User reports:**
```
Program runs but returns 0 records
```

**Claude investigates:**
```
Check:
- WHERE clause too restrictive?
- Date range correct?
- JOIN conditions right?
- expand() pattern correct if used?
```

**Fix and re-run:** N.8 (execution)

### Issue: Performance Too Slow

**User reports:**
```
Query took 3 minutes with 10,000 patients
```

**Claude optimizes:**
```ccl
; Add indexes
; Reduce unnecessary JOINs
; Filter earlier in query
; Use MAXREC if appropriate
```

**Re-run:** N.10 (performance check)

---

## Integration with MPages

**When CCL is part of MPage:**
1. Complete CCL validation (N.1 through N.10)
2. Switch to WEB PHASE (use VALIDATED-MPAGE templates)
3. Web phase depends on N.10 (CCL validated)

**Example:**
```json
{
  "id": 1,
  "title": "Add New Metric to Sepsis Dashboard",
  "subtasks": [
    // CCL PHASE (N.1 - N.10)
    { "id": "1.1", "title": "Modify sepsis query" },
    { "id": "1.10", "title": "🛑 USER: Verify CCL results" },

    // WEB PHASE (N.11 - N.18)
    { "id": "1.11", "title": "Update dashboard HTML" },
    { "id": "1.15", "title": "🛑 DEVTOOLS: Console check" }
  ]
}
```

---

## Benefits

**For Claude:**
- ✅ Clear stopping points (user validation required)
- ✅ Can't proceed with broken CCL
- ✅ Knows when to wait for user input

**For User:**
- ✅ Controls when Claude proceeds
- ✅ Validates in actual Cerner environment
- ✅ Catches errors before they propagate
- ✅ Clear checkpoints for testing

**For Stakeholders:**
- ✅ Code validated at each step
- ✅ Lower risk of production errors
- ✅ Clear development progress
- ✅ Documented validation trail

---

**Created:** 2025-10-11
**Version:** 1.0
**Last Updated:** 2025-10-11
