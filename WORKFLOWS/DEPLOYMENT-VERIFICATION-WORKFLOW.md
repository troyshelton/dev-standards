# Deployment Verification Workflow

**Purpose:** Prevent unauthorized or incorrect deployments to Azure, GitHub, or production environments

**Applies to:** ALL deployment commands (az storage, gh, git push to production, etc.)

**Status:** MANDATORY - No exceptions for healthcare production systems

**Created:** 2025-12-08
**Lesson Learned:** Issue #78 - Multiple deployments without verification

---

## 🛑 MANDATORY CHECKLIST (MUST COMPLETE BEFORE DEPLOYMENT)

**Claude MUST complete ALL steps before executing ANY deployment command.**

### Step 1: Show Full Deployment Command

**Claude must display:**

```
I'm about to deploy to [ENVIRONMENT]:

Command: [full command with all parameters]
Source:  [full source path]
Destination: [full destination path]
Account: [account name]
Files to deploy: [specific files OR "all files in source"]

⚠️ CRITICAL: Is this the correct destination?

Reply "approved" to deploy, or provide the correct destination.
```

**Example (Azure CERT):**
```
I'm about to deploy to Azure CERT:

Command: az storage blob upload-batch --account-name ihazurestoragedev --destination '$web/camc-sepsis-mpage/src' --source /Users/troyshelton/Projects/vandalia/sepsis-dashboard/src/web --overwrite --auth-mode key

Source:      /Users/troyshelton/Projects/vandalia/sepsis-dashboard/src/web
Destination: $web/camc-sepsis-mpage/src
Account:     ihazurestoragedev (CERT)
Files:       All files in src/web directory

⚠️ CRITICAL: Is this the correct destination?

Reply "approved" to deploy.
```

### Step 2: Wait for Explicit Approval

**Valid responses:**
- "approved"
- "yes"
- "proceed"
- "correct"

**Invalid responses (STOP):**
- Silence (no response)
- "wait"
- "no"
- Any question or concern

**If user provides a DIFFERENT destination:**
- Update the command with user's destination
- Show the corrected command
- Wait for "approved" again

### Step 3: Execute ONLY After Approval

**After user says "approved":**
- Execute the deployment command
- Show results
- Confirm deployment successful

### Step 4: Document Deployment

**In commit message or TaskMaster update:**
- What was deployed
- Where it was deployed
- When it was deployed
- User approval received

---

## 🚫 VIOLATIONS AND CONSEQUENCES

### If Claude Deploys Without Showing Command:

**Claude MUST:**
1. **STOP immediately** after realizing the violation
2. **Acknowledge:** "I violated the deployment verification workflow. I deployed to [destination] without showing you the command first. This was wrong."
3. **Show what was deployed:**
   ```
   Unauthorized deployment executed:
   - Destination: [where it went]
   - Files: [what was deployed]
   - Time: [when it happened]
   ```
4. **Ask:** "Would you like me to revert this deployment, or shall we validate it's correct?"
5. **WAIT** for user guidance

### Violation History (Track ALL Violations)

**Add date and details each time Claude violates this workflow:**

- **2025-10-15:** Deployed to wrong Azure location twice before verification rule added
- **2025-12-08:** Multiple deployments for Issue #78 without verification (deployed ~8 times without approval)

**If violations continue:** User may decide to end session or require additional safeguards.

---

## 📋 DEPLOYMENT ENVIRONMENTS

**Know the correct destinations for each environment:**

### CAMC Sepsis Dashboard

**CERT (Development/Testing):**
- Account: `ihazurestoragedev`
- Destination: `$web/camc-sepsis-mpage/src`
- Purpose: Testing and validation
- Approval: Required before each deployment

**Production:**
- Method: Cerner Citrix I: Drive (NOT Azure)
- See: CITRIX-DEPLOYMENT-GUIDE.md
- Approval: Required + Casey validation required

### Other Projects

**Document each project's deployment destinations in project CLAUDE.md**

---

## 🔧 EXCEPTIONS (VERY RARE)

**The ONLY time Claude may skip verification:**

1. User explicitly says: "Deploy to CERT without asking"
2. User has pre-approved a series of deployments: "Deploy after each change"
3. User is actively watching and participating in rapid iteration

**Even then:** Show a summary of what was deployed after the fact.

**Default:** ALWAYS verify. When in doubt, verify.

---

## ✅ ENFORCEMENT

**This workflow is:**
- ✅ Mandatory for healthcare projects
- ✅ Required for production deployments
- ✅ Non-negotiable for Azure storage deployments
- ✅ Applies across ALL sessions and projects

**Claude's responsibility:**
- Read this workflow at start of relevant sessions
- Follow it WITHOUT EXCEPTION
- Acknowledge violations immediately
- Improve compliance over time

---

**Last Updated:** 2025-12-08
**Next Review:** After any deployment violation (update violation history)
