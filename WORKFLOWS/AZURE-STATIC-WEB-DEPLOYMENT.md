# TaskMaster Workflow: Azure Static Website Deployment with Validation

**Purpose:** Deploy web application to Azure Storage with destination verification gate

**When to use:** Testing/validating web applications in Azure CERT environment before production

**Duration:** 5-15 minutes (after initial Azure setup)

**Critical Feature:** Destination verification prevents wrong-location deployments

---

## Overview

This workflow ensures safe deployment to Azure Storage with explicit destination verification before uploading files.

**Key Safety Feature:** Validation gate that shows full deployment command and requires user approval of destination path.

**Why This Matters:**
- Prevents accidental deployment to production instead of CERT
- Prevents overwriting wrong project directories
- Provides audit trail of deployment decisions
- Critical for healthcare/production environments

---

## Prerequisites

### One-Time Setup

1. **Azure CLI installed:**
   ```bash
   # macOS
   brew install azure-cli

   # Verify
   az --version
   ```

2. **Azure Login:**
   ```bash
   # Login to correct Azure account
   az login

   # List available accounts/subscriptions
   az account list --output table

   # Verify correct account active
   az account show
   ```

3. **Verify Storage Account Access:**
   ```bash
   # List storage accounts you can access
   az storage account list --query "[].{Name:name, ResourceGroup:resourceGroup}" --output table
   ```

---

## Task List

### Task 1: Verify Azure Authentication

**Action:** Confirm logged into correct Azure account

**Command:**
```bash
az account show
```

**Expected Output:**
```json
{
  "name": "[Subscription Name]",
  "user": {
    "name": "[your-email]@[organization]",
    "type": "user"
  }
}
```

**Dependencies:** None

**Validation:** 🛑 USER VERIFIES - Correct account active

**Approval Prompt:**
```
Azure Account Status:
- Subscription: [name]
- User: [email]
- Tenant: [organization]

Is this the CORRECT Azure account for deployment?
Reply "approved" to continue, or "switch" to change accounts.
```

**TaskMaster Instructions:**
- Show current Azure account details
- PAUSE for user verification
- If "switch", run `az login` and retry
- Block Task 2 until approved

---

### Task 2: Verify Storage Account Exists

**Action:** Confirm target storage account is accessible

**Command:**
```bash
az storage account list --query "[].name" --output table
```

**Dependencies:** Task 1 APPROVED

**Validation:** 🛑 USER VERIFIES - Storage account in list

**Approval Prompt:**
```
Available storage accounts:
[List of account names]

Target account: [storage-account-name]

Is the target storage account accessible?
Reply "approved" if account found, or provide correct account name.
```

**TaskMaster Instructions:**
- List all accessible storage accounts
- Verify target account in list
- PAUSE for user confirmation
- Block Task 3 until approved

---

### Task 3: Show Deployment Configuration

**Action:** Display full deployment details for verification

**Display Format:**
```
📋 Deployment Configuration:

Source Directory:
  Path: [local-source-path]
  Files: [file-count] files

Destination:
  Account:   [storage-account-name]
  Container: $web
  Path:      [destination-path]

Full Command:
az storage blob upload-batch \
  --account-name [storage-account-name] \
  --destination '$web' \
  --destination-path [destination-path] \
  --source [source-path] \
  --overwrite \
  --auth-mode key

Deployment URL:
https://[storage-account-name].z13.web.core.windows.net/[destination-path]/index.html
```

**Dependencies:** Task 2 APPROVED

**Validation:** None (display only)

**Output:** Complete deployment configuration shown

**TaskMaster Instructions:**
- Count files in source directory
- Build complete az command
- Display all parameters clearly
- Show resulting URL
- Block Task 4 until displayed

---

### Task 4: 🛑 CRITICAL: Destination Verification

**Action:** Get explicit user approval of deployment destination

**Prompt:**
```
⚠️ CRITICAL: Verify deployment destination!

Deploying TO:
  Account:     [storage-account-name]
  Destination: $web/[destination-path]

This will upload [N] files and OVERWRITE existing files.

Deployment URL will be:
https://[storage-account-name].z13.web.core.windows.net/[destination-path]/index.html

⚠️ Is this the CORRECT destination?

Common mistakes to avoid:
- Deploying to PROD instead of CERT
- Deploying to wrong project directory
- Overwriting another team's work

Reply "approved" to deploy, or provide correct destination path.
```

**Dependencies:** Task 3

**Validation:** 🛑 DESTINATION APPROVAL REQUIRED

**Output:** User approval to proceed with deployment

**TaskMaster Instructions:**
- Show deployment destination prominently
- Highlight potential risks
- PAUSE for explicit "approved" confirmation
- If user provides different path, update and re-show Task 3
- Block Task 5 until approved
- **This is the most critical validation gate**

---

### Task 5: Execute Azure Deployment

**Action:** Deploy files to Azure Storage

**Command:**
```bash
az storage blob upload-batch \
  --account-name [storage-account-name] \
  --destination '$web' \
  --destination-path [destination-path] \
  --source [source-path] \
  --overwrite \
  --auth-mode key
```

**Dependencies:** Task 4 APPROVED

**Validation:** None (automatic after approval)

**Output:** Files uploaded to Azure

**Expected Duration:** 1-5 minutes depending on file count

**TaskMaster Instructions:**
- Execute deployment command
- Show progress/file count
- Report completion
- Block Task 6 until upload complete

---

### Task 6: Display Deployment URL

**Action:** Show CERT environment URL

**Display:**
```
✅ Deployment Complete!

Files deployed: [N] files
Deployment time: [duration]

🌐 CERT URL:
https://[storage-account-name].z13.web.core.windows.net/[destination-path]/index.html

Next step: Test in CERT environment
```

**Dependencies:** Task 5

**Validation:** None (informational)

**Output:** CERT URL displayed

**TaskMaster Instructions:**
- Calculate and show file count
- Display complete URL
- Block Task 7 until displayed

---

### Task 7: 🛑 CERT Environment Validation

**Action:** User tests deployed application

**Prompt:**
```
Please test the deployed application in CERT:

URL: https://[storage-account-name].z13.web.core.windows.net/[destination-path]/index.html

Validation Checklist:
- [ ] Application loads without errors
- [ ] All assets load (CSS, JS, images)
- [ ] Functionality works as expected
- [ ] No console errors
- [ ] Calculations accurate
- [ ] UI displays correctly
- [ ] Mobile/desktop responsive
- [ ] [Project-specific tests]

Reply "validated" when testing complete, or report issues found.
```

**Dependencies:** Task 6

**Validation:** 🛑 CERT VALIDATION REQUIRED

**Output:** User confirms CERT environment working

**TaskMaster Instructions:**
- PAUSE for user testing
- Wait for "validated" confirmation
- If issues reported, return to development phase
- Block Task 8 until validated
- **Do not proceed to git workflow until CERT validated**

---

### Task 8: Workflow Complete - Ready for Git Workflow

**Action:** Deployment validated, ready to continue with commits/PRs

**Display:**
```
✅ Azure CERT Deployment Validated!

Deployment Summary:
- Account: [storage-account-name]
- Destination: $web/[destination-path]
- Files: [N] files deployed
- URL: [cert-url]
- Status: ✅ Validated

You may now proceed with:
- Git commit
- Pull Request creation
- Merge to main
- Release tagging

Continue with TaskMaster Git Enhancement workflow.
```

**Dependencies:** Task 7 VALIDATED

**Validation:** None (completion summary)

**Output:** Deployment workflow complete

**TaskMaster Instructions:**
- Show complete deployment summary
- Confirm readiness for git workflow
- Mark deployment workflow as complete
- Return control to parent workflow (Git Enhancement)

---

## Workflow Integration

**This workflow integrates with:**
- **TASKMASTER-GIT-ENHANCEMENT.md** - Called as Task N+2 (deployment validation)
- **VALIDATED-WEB-DEVELOPMENT.md** - Web app deployment validation
- **VALIDATED-MPAGE-STANDALONE.md** - MPage CERT testing

**Placement in Git Enhancement Workflow:**
```
Development → Work Complete [GATE] → Azure Deployment [GATE] → Doc Sync → PR → Merge
                                      ↑ This workflow ↑
```

---

## Deployment Script Template

**Create as:** `deploy-azure-cert.sh`

```bash
#!/bin/bash
set -e

# Azure CERT Deployment for [Project Name]
STORAGE_ACCOUNT="[account-name]"
CONTAINER_NAME="\$web"
TARGET_PATH="[destination-path]"
SOURCE_DIR="./src/web"

echo "🚀 Deploying [Project] to Azure CERT"
echo ""

# Verify source
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Source directory not found: $SOURCE_DIR"
    exit 1
fi

# Verify Azure login
if ! az account show &> /dev/null; then
    echo "❌ Not logged in to Azure"
    echo "Please run: az login"
    exit 1
fi

echo "✅ Azure login verified"
echo ""

# Show deployment config
echo "📋 Deployment Configuration:"
echo "   Account:     $STORAGE_ACCOUNT"
echo "   Container:   $CONTAINER_NAME"
echo "   Destination: $TARGET_PATH"
echo "   Source:      $SOURCE_DIR"
echo ""

# Count files
FILE_COUNT=$(find "$SOURCE_DIR" -type f | wc -l | tr -d ' ')
echo "📦 Files to deploy: $FILE_COUNT"
echo ""

# Show sample files
echo "📄 Sample files:"
find "$SOURCE_DIR" -type f | head -5
echo "   ... and $((FILE_COUNT - 5)) more files"
echo ""

# ⚠️ CRITICAL VALIDATION GATE
echo "⚠️  CRITICAL: Verify destination is correct!"
echo ""
echo "Full deployment command:"
echo "az storage blob upload-batch \\"
echo "  --account-name $STORAGE_ACCOUNT \\"
echo "  --destination '$CONTAINER_NAME/$TARGET_PATH' \\"
echo "  --source $SOURCE_DIR \\"
echo "  --overwrite --auth-mode key"
echo ""

# Require explicit confirmation
read -p "🛑 Is this the CORRECT destination? (yes/no): " -r
echo ""

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "❌ Deployment cancelled"
    echo "Please verify the destination path and run again"
    exit 1
fi

echo "✅ Destination approved - deploying..."
echo ""

# Execute deployment
az storage blob upload-batch \
  --account-name "$STORAGE_ACCOUNT" \
  --destination "$CONTAINER_NAME" \
  --destination-path "$TARGET_PATH" \
  --source "$SOURCE_DIR" \
  --overwrite \
  --auth-mode key

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "🌐 CERT URL: https://$STORAGE_ACCOUNT.z13.web.core.windows.net/$TARGET_PATH/index.html"
echo ""
echo "Next steps:"
echo "1. Open the URL above in your browser"
echo "2. Test all functionality in CERT environment"
echo "3. Verify calculations, UI, and interactions"
echo "4. Report validation results"
```

**Usage:**
```bash
# Make executable
chmod +x deploy-azure-cert.sh

# Run deployment
./deploy-azure-cert.sh
```

---

## Common Deployment Targets

### Marshall Health Network (Cabell)
- **CERT Account:** `mhnmpagesstoragedev`
- **Projects:**
  - Emergency Med Calculator: `$web/emergency-med-calc-ojet-mpage`
  - [Other projects as needed]

### Vandalia Health
- **CERT Account:** `ihazurestoragedev`
- **Projects:**
  - Sepsis Dashboard: `$web/camc-sepsis-mpage/src`
  - [Other projects as needed]

---

## Troubleshooting

### Authentication Errors
```bash
# Check current account
az account show

# Login to correct account
az login

# List available subscriptions
az account list --output table

# Switch subscription if needed
az account set --subscription "[subscription-name]"
```

### Storage Account Not Found
```bash
# List accessible storage accounts
az storage account list --query "[].name" --output table

# Verify account name spelling
# Common mistake: mhnmpagesstoragedev vs ihazurestoragedev
```

### Permission Errors
- Verify you have Contributor or Storage Blob Data Contributor role
- Contact Azure administrator for access
- Check account is in correct subscription

---

## Success Criteria

When this workflow completes:
- ✅ Correct Azure account verified
- ✅ Storage account accessible
- ✅ Deployment configuration shown
- ✅ **Destination approved by user** (critical gate)
- ✅ Files deployed successfully
- ✅ CERT URL displayed
- ✅ **CERT environment validated** (critical gate)
- ✅ Ready to proceed with git workflow

---

**Created:** 2025-11-07
**Based on:** sepsis-dashboard/deploy-azure.sh pattern
**Version:** 1.0
**Validation Gates:** 3 (Account, Destination, CERT Testing)
