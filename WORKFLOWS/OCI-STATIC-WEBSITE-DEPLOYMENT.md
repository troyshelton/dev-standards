# TaskMaster Workflow: OCI Static Website Deployment

**Purpose:** Deploy web application to Oracle Cloud Infrastructure Object Storage for static website hosting

**When to use:** Migrating from Azure/AWS or deploying new static web apps to OCI

**Duration:** 1-2 days (account setup through validation)

**Use Case:** Sepsis Dashboard migration from Azure to OCI (Phase 1)

---

## Task List

### Task 1: Create OCI Account (Organizational)

**Action:** Create Oracle Cloud Infrastructure account for Vandalia Health

**Steps:**
1. Go to https://cloud.oracle.com
2. Click "Start for Free" or "Sign Up"
3. Use organizational email: troy.shelton@vandaliahealth.org
4. Select account type: Individual/Company (use Company for organization)
5. Complete registration (verify email, set password)
6. Add payment method (Vandalia billing)
7. Verify account active

**Dependencies:** None

**Validation:** 🛑 USER COMPLETES - Confirm account created

**Output:** Active OCI account with Vandalia email

---

### Task 2: Navigate OCI Console and Familiarize

**Action:** Learn basic OCI Console navigation

**Key areas to locate:**
1. **Compartments** - Organizational units (like Azure resource groups)
2. **Object Storage** - Where we'll host the website
3. **Identity (IAM)** - User/team access management
4. **Tenancy** - Your organization's OCI environment

**Steps:**
1. Log in to cloud.oracle.com
2. Navigate to "Object Storage & Archive Storage"
3. Note your Home Region (e.g., us-ashburn-1)
4. Locate Compartment selector (may default to root)

**Dependencies:** Task 1

**Validation:** None (familiarization)

**Output:** Understanding of OCI Console layout

---

### Task 3: Create Object Storage Bucket

**Action:** Create bucket for sepsis dashboard hosting

**Steps:**
1. In OCI Console, go to: Storage → Object Storage & Archive Storage → Buckets
2. Click "Create Bucket"
3. Bucket Name: `camc-sepsis-dashboard` (or preferred name)
4. Default Storage Tier: Standard
5. Encryption: Use Oracle-managed keys
6. Click "Create Bucket"

**Dependencies:** Task 2

**Validation:** None (automatic)

**Output:** Bucket created and visible in console

---

### Task 4: Configure Bucket for Static Website Hosting

**Action:** Enable static website hosting on bucket

**Steps:**
1. Click on bucket name to open details
2. Under "Bucket Information", note the Namespace
3. No special "static website" toggle in OCI - just upload files
4. Files are accessible via: https://objectstorage.{region}.oraclecloud.com/n/{namespace}/b/{bucket}/o/{object}

**Alternative - Pre-Authenticated Requests (PAR):**
1. Can create PAR for simpler URLs
2. Or use custom domain (advanced)

**Dependencies:** Task 3

**Validation:** None (configuration)

**Output:** Bucket ready for file upload

---

### Task 5: Set Bucket Public Access Policy

**Action:** Allow public read access to web assets

**Steps:**
1. In bucket details, go to "Edit Visibility"
2. Select "Public" (allows public read access)
3. Confirm change

**Security Note:**
- Public visibility allows anyone to read objects
- Appropriate for static website assets
- Do NOT upload sensitive data

**Dependencies:** Task 4

**Validation:** None (automatic)

**Output:** Bucket publicly accessible

---

### Task 6: Install OCI CLI

**Action:** Install OCI Command Line Interface for deployment

**Steps (macOS):**
```bash
# Install using Homebrew (easiest)
brew install oci-cli

# Or use installer script
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

# Verify installation
oci --version
```

**Dependencies:** Task 1 (need account credentials)

**Validation:** None (automatic)

**Output:** OCI CLI installed and ready

---

### Task 7: Configure OCI CLI with Account Credentials

**Action:** Set up CLI authentication

**Steps:**
```bash
# Run setup wizard
oci setup config

# Follow prompts:
# - Location for config: ~/.oci/config (default)
# - User OCID: Get from OCI Console → Profile → User Settings
# - Tenancy OCID: Get from OCI Console → Profile → Tenancy
# - Region: Your home region (e.g., us-ashburn-1)
# - Generate API key: Yes
```

**Upload API Key to OCI:**
1. CLI will generate public/private key pair
2. Copy public key content
3. In OCI Console → Profile → API Keys → Add API Key
4. Paste public key, save

**Test configuration:**
```bash
oci os ns get
# Should return your namespace
```

**Dependencies:** Task 6

**Validation:** 🛑 USER VALIDATES - CLI test command succeeds

**Output:** OCI CLI configured and authenticated

---

### Task 8: Upload Dashboard to OCI Bucket

**Action:** Deploy all web assets to OCI Object Storage

**Command:**
```bash
# Bulk upload from src/web directory
oci os object bulk-upload \
  --bucket-name camc-sepsis-dashboard \
  --src-dir /Users/troyshelton/Projects/vandalia/sepsis-dashboard/src/web \
  --overwrite

# OR upload directory structure preserving paths
cd /Users/troyshelton/Projects/vandalia/sepsis-dashboard/src/web
oci os object bulk-upload \
  --bucket-name camc-sepsis-dashboard \
  --src-dir . \
  --overwrite
```

**Dependencies:** Task 5, Task 7

**Validation:** None (automatic)

**Output:** All files uploaded to OCI bucket

**Expected:** ~20 files uploaded (HTML, CSS, JS, libraries)

---

### Task 9: Get OCI Dashboard URL

**Action:** Construct URL to access dashboard

**URL Format:**
```
https://objectstorage.{region}.oraclecloud.com/n/{namespace}/b/{bucket-name}/o/index.html
```

**Example:**
```
https://objectstorage.us-ashburn-1.oraclecloud.com/n/your-namespace/b/camc-sepsis-dashboard/o/index.html
```

**Get values:**
- Region: From OCI Console (e.g., us-ashburn-1)
- Namespace: Run `oci os ns get`
- Bucket name: camc-sepsis-dashboard

**Dependencies:** Task 8

**Validation:** None (construction)

**Output:** OCI dashboard URL

---

### Task 10: Test Dashboard on OCI URL

**Action:** Open OCI URL and verify basic functionality

**Tests:**
1. Navigate to OCI URL in browser
2. Verify page loads (no 404 errors)
3. Check console for JavaScript errors
4. Verify CSS/styling loads correctly
5. Test simulator mode (select Demo Patient List A)

**Dependencies:** Task 9

**Validation:** 🛑 USER VALIDATES - Dashboard loads and displays

**Output:** Basic functionality confirmed

---

### Task 11: Test CCL Integration in CERT

**Action:** Disable simulator and test with real Cerner data

**Steps:**
1. Edit Config.js: Set `enabled: false` (disable simulator)
2. Re-upload Config.js to OCI
3. Open OCI URL in CERT environment
4. Select real patient list (Troy's)
5. Verify data loads from CCL programs
6. Check all features work

**Dependencies:** Task 10

**Validation:** 🛑 USER VALIDATES - Real CERT data loads correctly

**Output:** CCL integration working on OCI

---

### Task 12: Test All Dashboard Features

**Action:** Comprehensive feature testing on OCI

**Test checklist:**
- [ ] Patient list dropdown works
- [ ] Patient data loads and displays
- [ ] All bundle columns show correct icons
- [ ] Tooltips appear and position correctly
- [ ] 3-hour timer displays
- [ ] Bundle completion icons show (green ✓ / red ✗)
- [ ] Fluids conditional logic works (N/A when lactate <4.0)
- [ ] Patient name links are blue with hover underline
- [ ] Refresh button works
- [ ] No console errors

**Dependencies:** Task 11

**Validation:** 🛑 USER VALIDATES - All features working

**Output:** Fully functional dashboard on OCI

---

### Task 13: Configure Team Access (IAM)

**Action:** Add team members to OCI account

**Steps:**
1. In OCI Console → Identity → Users
2. Click "Create User"
3. Add team members:
   - Name, email
   - Add to appropriate groups
   - Set permissions (admin, read-only, etc.)
4. Send invite email
5. Members complete signup

**Alternative - Federation:**
- If Vandalia has SSO/federation, use that
- Integrated with Vandalia AD/identity provider

**Dependencies:** Task 12 (after dashboard validated)

**Validation:** None (administrative)

**Output:** Team members can access OCI console

---

### Task 14: Create Deployment Script (deploy-oci.sh)

**Action:** Create reusable deployment script for OCI

**Script content:**
```bash
#!/bin/bash
# Deploy Sepsis Dashboard to OCI Object Storage

BUCKET_NAME="camc-sepsis-dashboard"
SOURCE_DIR="/Users/troyshelton/Projects/vandalia/sepsis-dashboard/src/web"

echo "Deploying to OCI..."
echo "Bucket: $BUCKET_NAME"
echo "Source: $SOURCE_DIR"

# Upload files
oci os object bulk-upload \
  --bucket-name "$BUCKET_NAME" \
  --src-dir "$SOURCE_DIR" \
  --overwrite

echo "Deployment complete!"
echo "URL: https://objectstorage.{region}.oraclecloud.com/n/{namespace}/b/$BUCKET_NAME/o/index.html"
```

**Save as:** `deploy-oci.sh`
**Make executable:** `chmod +x deploy-oci.sh`

**Dependencies:** Task 13

**Validation:** None (script creation)

**Output:** Deployment script for future use

---

### Task 15: Update Documentation

**Action:** Document OCI deployment in project files

**Files to update:**

**1. README.md:**
- Add OCI URL
- Update deployment section
- Note: Hosted on Oracle Cloud Infrastructure

**2. CLAUDE.md:**
- Update deployment paths
- Add OCI account info
- Document team access

**3. Create OCI-DEPLOYMENT.md:**
- Complete OCI setup guide
- Team access procedures
- Deployment runbook
- Troubleshooting

**Dependencies:** Task 14

**Validation:** None (documentation)

**Output:** Complete OCI documentation

---

### Task 16: 🛑 VALIDATION: Stakeholder Review

**Action:** Show OCI-hosted dashboard to stakeholders

**Prompt to User:**
```
OCI deployment complete!

OCI URL: [url]
Features tested: All working
CERT validated: ✅

Please review OCI-hosted dashboard and confirm:
1. Acceptable for production use
2. URL is appropriate
3. Ready to share with clinical team

Reply "approved" to proceed with production launch.
```

**Dependencies:** Task 15

**Validation:** 🛑 USER APPROVAL REQUIRED

**Output:** Stakeholder approval for OCI deployment

---

### Task 17: Create Custom Domain (Optional)

**Action:** Set up friendly URL (if desired)

**Options:**

**Option A: OCI DNS + Custom Domain**
- Register domain or use Vandalia subdomain
- Configure DNS in OCI
- Point to Object Storage bucket
- Example: sepsis.vandaliahealth.org

**Option B: Use Default OCI URL**
- Keep objectstorage.region.oraclecloud.com URL
- Simpler, no DNS setup needed
- Still fully functional

**Dependencies:** Task 16 (if pursuing)

**Validation:** 🛑 USER DECISION - Custom domain needed?

**Output:** Custom domain configured (if chosen)

---

### Task 18: Production Cutover

**Action:** Switch from Azure to OCI for production

**Steps:**
1. Confirm OCI deployment stable
2. Share OCI URL with clinical users
3. Update bookmarks/favorites
4. Update any documentation with old Azure URL
5. Monitor for issues

**Dependencies:** Task 16 (or Task 17 if custom domain)

**Validation:** None (administrative)

**Output:** OCI is production deployment

---

### Task 19: Archive Azure Deployment

**Action:** Document Azure deployment as backup/archive

**Steps:**
1. Keep Azure deployment active initially (backup)
2. Document Azure account info for records
3. After 30 days of stable OCI: Consider Azure decommission
4. Update cost tracking (remove Azure, add OCI)

**Dependencies:** Task 18

**Validation:** None (cleanup)

**Output:** Clean migration to OCI, Azure archived

---

### Task 20: Workflow Complete Summary

**Action:** Document completion and provide access info

**Display:**
```
✅ OCI Migration Complete!

Summary:
- OCI Account: troy.shelton@vandaliahealth.org
- Bucket: camc-sepsis-dashboard
- Region: [region]
- URL: [oci-url]
- Team Access: Configured
- Deployment: Automated (deploy-oci.sh)

Next Steps:
- Share URL with clinical team
- Monitor usage and performance
- Begin Phase 2 enhancements

Strategic Alignment:
- Hosted on Oracle Cloud Infrastructure ✅
- Aligns with Vandalia's Oracle Health migration ✅
- Future-proof for Oracle Health EHR integration ✅
```

**Dependencies:** Task 19

**Validation:** None (summary)

**Output:** Complete migration documentation

---

## Workflow Summary

```
SETUP (Tasks 1-7)
├─ Task 1: Create OCI account [VALIDATION GATE]
├─ Task 2: Navigate console
├─ Task 3: Create bucket
├─ Task 4: Configure for web hosting
├─ Task 5: Set public access
├─ Task 6: Install OCI CLI
└─ Task 7: Configure CLI authentication [VALIDATION GATE]

DEPLOYMENT (Tasks 8-12)
├─ Task 8: Upload dashboard files
├─ Task 9: Get OCI URL
├─ Task 10: Test basic functionality [VALIDATION GATE]
├─ Task 11: Test CERT integration [VALIDATION GATE]
└─ Task 12: Test all features [VALIDATION GATE]

ACCESS & AUTOMATION (Tasks 13-15)
├─ Task 13: Configure team access
├─ Task 14: Create deployment script
└─ Task 15: Update documentation

PRODUCTION (Tasks 16-20)
├─ Task 16: Stakeholder approval [VALIDATION GATE]
├─ Task 17: Custom domain (optional) [DECISION GATE]
├─ Task 18: Production cutover
├─ Task 19: Archive Azure
└─ Task 20: Summary

Total Validation Gates: 6
Total Decision Gates: 1
```

---

## Success Criteria

When this workflow completes:
- ✅ OCI account created (Vandalia organizational)
- ✅ Dashboard deployed to OCI Object Storage
- ✅ All features tested and working
- ✅ Team access configured
- ✅ Deployment automated (script)
- ✅ Documentation complete
- ✅ Stakeholder approved
- ✅ Production URL shared

---

## Notes

**Strategic Positioning:**
- Demonstrates Oracle/OCI alignment
- Future-proof for Oracle Health EHR
- Aligns with organizational infrastructure direction

**Technical:**
- Same functionality as Azure (just different host)
- OCI CLI similar to Azure CLI
- Deployment process nearly identical

**Cost:**
- OCI Object Storage: ~$0.03/GB/month (first 10GB free)
- Minimal cost for static website
- Similar to Azure pricing

---

**Created:** 2025-10-16
**For:** Sepsis Dashboard OCI migration (Phase 1)
**Version:** 1.0
