# TaskMaster Workflow: New Project Initialization

**Purpose:** Initialize a new project with proper structure, documentation, and git setup

**When to use:** Starting any new CCL, Web, or MPage project

**Duration:** 10-20 minutes (depending on TaskMaster initialization)

**Created:** 2025-10-11
**Version:** 1.0

---

## Overview

This workflow creates a complete project structure following global standards with:
- Correct project type structure
- Synchronized documentation (README, CHANGELOG, CLAUDE.md)
- Git repository with initial commit and v1.0.0 tag
- Ready for development

**Workflow Phases:**
1. Project Planning (2 tasks, 2 validation gates)
2. Structure Creation (3 tasks)
3. Documentation Setup (5 tasks, 1 validation gate)
4. Git Initialization (3 tasks, 1 validation gate)

---

## Task List

### Task 1: Determine Project Details

**Action:** Gather project information from user

**Prompt:**
```
Let's initialize a new project! I need the following information:

1. Project Type:
   - CCL Project (Cerner Command Language program)
   - Web Project (HTML/CSS/JavaScript)
   - MPage Project (CCL + Web)

2. Project Name (lowercase-with-hyphens):
   Example: oracle-jet-sepsis-web-app

3. Parent Directory (if applicable):
   Example: vandalia, cabell, kingston

4. Brief Description:
   One-line description of what this project does

Please provide all four pieces of information.
```

**Dependencies:** None

**Validation:** 🛑 USER INPUT REQUIRED

**Output:**
- Project type
- Project name
- Parent directory path
- Description

**TaskMaster Instructions:**
- Pause for user input
- Validate project name follows naming conventions
- Store all values for use in subsequent tasks
- Block all other tasks until complete

---

### Task 2: Confirm Project Structure

**Action:** Show user the planned structure and get approval

**Prompt:**
```
I will create the following project structure:

**Location:** /Users/troyshelton/Projects/[parent-dir]/[project-name]

**Type:** [CCL/Web/MPage] Project

**Structure:**
[Show appropriate structure based on project type from CLAUDE.md]

**Initial Files:**
- README.md (v1.0.0, [current-date])
- CHANGELOG.md (v1.0.0, [current-date])
- CLAUDE.md (v1.0.0, [current-date])
- .gitignore

Is this correct?
Reply "approved" to proceed, or provide corrections.
```

**Dependencies:** Task 1

**Validation:** 🛑 USER APPROVAL REQUIRED

**Output:** User approval of structure

**TaskMaster Instructions:**
- Display complete structure preview
- Show all directories that will be created
- PAUSE for user approval
- Block Task 3 until approved
- If rejected, go back to Task 1

---

### Task 3: Create Directory Structure

**Action:** Create project directories

**Command:**
```bash
# Set absolute project path
BASE_PATH="/Users/troyshelton/Projects"

if [ -n "[parent-dir]" ]; then
    PROJECT_PATH="$BASE_PATH/[parent-dir]/[project-name]"
else
    PROJECT_PATH="$BASE_PATH/[project-name]"
fi

# Create structure based on project type
mkdir -p "$PROJECT_PATH"

# CCL Project
if [ "[type]" = "CCL" ]; then
    mkdir -p "$PROJECT_PATH"/{src/{includes,original},docs/{api,guides,reference},tests,scripts}
fi

# Web Project
if [ "[type]" = "Web" ]; then
    mkdir -p "$PROJECT_PATH"/{src/{css,js,assets,components},docs,tests}
fi

# MPage Project
if [ "[type]" = "MPage" ]; then
    mkdir -p "$PROJECT_PATH"/{src/{ccl,web,shared},docs,tests/{ccl,web},scripts}
fi

ls -la "$PROJECT_PATH"
```

**Dependencies:** Task 2 APPROVED

**Validation:** None (automatic once unblocked)

**Output:** Complete directory structure created

**TaskMaster Instructions:**
- Use project type from Task 1
- Use project name from Task 1
- Use parent directory from Task 1
- Create appropriate structure per CLAUDE.md standards
- Verify directories created successfully

---

### Task 4: Get Current Date

**Action:** Get system date for documentation

**Command:**
```bash
date '+%Y-%m-%d'
```

**Dependencies:** Task 3

**Validation:** None (automatic)

**Output:** Current date in YYYY-MM-DD format

**TaskMaster Instructions:**
- Auto-execute
- Store result for use in documentation tasks
- Pass to Tasks 5, 6, 7

---

### Task 5: Initialize Git Repository

**Action:** Initialize git in project directory

**Command:**
```bash
cd [project-path]
git status 2>&1 || git init
git status
```

**Dependencies:** Task 3

**Validation:** None (automatic)

**Output:** Git repository initialized

**TaskMaster Instructions:**
- Change to project directory
- Check if git already exists
- Initialize if needed
- Verify git status shows clean repository

---

### Task 6: Create README.md

**Action:** Create README.md with project overview

**Tool:** Use Write tool to create file at `[project-path]/README.md`

**Template:**
```markdown
# [Project Name]

**Version**: v1.0.0
**Last Updated**: [YYYY-MM-DD from Task 4]
**Status**: Initial Setup

## Overview

[Description from Task 1]

## Current Status

**Version**: v1.0.0
**Active Branch**: main
**Last Updated**: [YYYY-MM-DD]
**Next Steps**: Initial development setup

## Technology Stack

[Based on project type from Task 1]

## Project Structure

[Show structure diagram based on project type]

## Getting Started

### Prerequisites
[Based on project type]

### Installation
1. Clone the repository
2. [Type-specific setup steps]

## Documentation

See the `docs/` directory for additional documentation.

## Recent Changes

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## Development Guidelines

Follow the global development standards in `/Users/troyshelton/Projects/.standards/`

---
*Last Updated: [YYYY-MM-DD]*
```

**Dependencies:** Tasks 3, 4

**Validation:** None (automatic once unblocked)

**Output:** README.md created with v1.0.0

**TaskMaster Instructions:**
- Use project name from Task 1
- Use description from Task 1
- Use date from Task 4
- Use project type from Task 1 to customize sections
- Create file in project root

---

### Task 7: Create CHANGELOG.md

**Action:** Create CHANGELOG.md with v1.0.0 entry

**Tool:** Use Write tool to create file at `[project-path]/CHANGELOG.md`

**Template:**
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - [YYYY-MM-DD from Task 4]
### Added
- Initial project setup
- Project structure with [list directories based on type]
- README.md with project overview
- CHANGELOG.md for version tracking
- CLAUDE.md for AI assistant guidance
- Git repository initialization
- Basic documentation structure

[Unreleased]: https://github.com/username/[project-name]/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/username/[project-name]/releases/tag/v1.0.0
```

**Dependencies:** Tasks 3, 4

**Validation:** None (automatic once unblocked)

**Output:** CHANGELOG.md created with v1.0.0

**TaskMaster Instructions:**
- Use date from Task 4
- Use project name from Task 1
- List directories based on project type from Task 1
- Create file in project root

---

### Task 8: Create CLAUDE.md

**Action:** Create CLAUDE.md with AI assistant guidance

**Tool:** Use Write tool to create file at `[project-path]/CLAUDE.md`

**Template:**
```markdown
# [Project Name] - AI Assistant Guide

**Version**: v1.0.0
**Last Updated**: [YYYY-MM-DD from Task 4]
**Project Type**: [CCL/Web/MPage] Project

## Project Overview

[Description from Task 1]

## Current Status

**Version**: v1.0.0
**Active Branch**: main
**Last Updated**: [YYYY-MM-DD]
**Current Phase**: Initial Setup
**Next Steps**: [Type-specific next steps]

## Project Structure

Following [Project Type] structure per global CLAUDE.md:

[Show structure diagram]

## Technology Stack

[Type-specific tech stack]

## Development Guidelines

### Global Standards
Follow development standards in `/Users/troyshelton/Projects/.standards/`:
- [GIT-WORKFLOW.md](.standards/GIT-WORKFLOW.md) - Issue → Branch → Tag workflow
- [VERSIONING.md](.standards/VERSIONING.md) - Semantic versioning
- [PRE-COMMIT-CHECKLIST.md](.standards/PRE-COMMIT-CHECKLIST.md) - Pre-commit checks
- [DOCUMENTATION-SYNC-PROTOCOL.md](.standards/DOCUMENTATION-SYNC-PROTOCOL.md) - Doc sync

### [Type]-Specific Guidelines

[Add type-specific guidelines based on project type]

### Version Tracking

[Type-specific version tracking requirements]

## Git Workflow

### Feature Development
```bash
# Create GitHub issue first
gh issue create --title "Feature description"

# Create feature branch
git checkout -b feature/v1.1.0-feature-name

# Develop and test
# ...

# Commit and merge
git add .
git commit -m "feat: feature description"
git checkout main
git merge feature/v1.1.0-feature-name
git tag -a v1.1.0 -m "Release notes"
git push origin main --tags
```

### Documentation Sync
Before every commit with version changes:
1. Update CHANGELOG.md with changes
2. Update README.md version and date
3. Update CLAUDE.md version and date
4. Verify all three files are in sync

## Testing Requirements

[Type-specific testing requirements]

## Key Reminders

1. **Version Sync**: Keep CHANGELOG.md, README.md, and CLAUDE.md in sync
2. **Git Workflow**: Always create issues before branches
3. **Testing**: Test before merging to main
4. **Documentation**: Update docs with code changes

---
*For complete development standards, see `/Users/troyshelton/Projects/CLAUDE.md`*
*Last Updated: [YYYY-MM-DD]*
```

**Dependencies:** Tasks 3, 4

**Validation:** None (automatic once unblocked)

**Output:** CLAUDE.md created with v1.0.0

**TaskMaster Instructions:**
- Use project name from Task 1
- Use description from Task 1
- Use date from Task 4
- Use project type from Task 1 to customize sections
- Include type-specific guidelines (CCL/Web/MPage)
- Create file in project root

---

### Task 9: Create .gitignore

**Action:** Create .gitignore with appropriate rules

**Tool:** Use Write tool to create file at `[project-path]/.gitignore`

**Template (varies by type):**

**For CCL Projects:**
```gitignore
# CCL specific
*.log
*.lst
*.bak
*.old
*~

# OS specific
.DS_Store
Thumbs.db

# Editor specific
.vscode/
.idea/
*.swp
*.swo

# Environment
.env
.env.local

# Temporary
tmp/
temp/
```

**For Web/MPage Projects:**
```gitignore
# OS specific
.DS_Store
Thumbs.db

# Editor specific
.vscode/
.idea/
*.swp
*.swo
*~

# Node modules
node_modules/
package-lock.json

# Build outputs
dist/
build/
*.min.js
*.min.css

# Environment files
.env
.env.local

# Logs
*.log

# Temporary files
tmp/
temp/
```

**Dependencies:** Task 3

**Validation:** None (automatic once unblocked)

**Output:** .gitignore created

**TaskMaster Instructions:**
- Use project type from Task 1
- Select appropriate template
- Create file in project root

---

### Task 10: Review Documentation

**Action:** Show user all created files for review

**Prompt:**
```
Project initialization complete! Here's what was created:

**Project:** [project-name]
**Location:** [full-path]
**Type:** [CCL/Web/MPage] Project

**Files Created:**
- README.md (v1.0.0, [date])
- CHANGELOG.md (v1.0.0, [date])
- CLAUDE.md (v1.0.0, [date])
- .gitignore

**Git Status:**
- Repository initialized
- Files ready to commit

**Documentation Preview:**
[Show first 20 lines of each file]

Are these files correct?
Reply "approved" to create initial commit, or provide feedback for changes.
```

**Dependencies:** Tasks 6, 7, 8, 9

**Validation:** 🛑 USER APPROVAL REQUIRED

**Output:** User approval of documentation

**TaskMaster Instructions:**
- Show preview of all created files
- Display git status
- PAUSE for user approval
- Block Tasks 11 and 12 until approved
- If rejected, allow user to make changes manually

---

### Task 11: Create Initial Commit

**Action:** Commit all files with descriptive message

**Command:**
```bash
cd [project-path]
git add .
git commit -m "$(cat <<'EOF'
Initial project setup

- Created project structure with [list directories]
- Added README.md with project overview
- Added CHANGELOG.md following Keep a Changelog format
- Added CLAUDE.md for AI assistant guidance
- Added .gitignore with [type] project ignore rules
- Initialized git repository

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**Dependencies:** Task 10 APPROVED

**Validation:** None (automatic once unblocked)

**Output:** Initial commit created

**TaskMaster Instructions:**
- Only execute after Task 10 approval
- Use project type from Task 1 in commit message
- Verify commit created successfully
- Show commit hash and summary

---

### Task 12: Create v1.0.0 Tag

**Action:** Tag initial release

**Command:**
```bash
cd [project-path]
git tag -a v1.0.0 -m "$(cat <<'EOF'
Initial release - [Project Name] v1.0.0

- Project structure setup
- Core documentation (README, CHANGELOG, CLAUDE)
- Git repository initialization
- [Type] project foundation ready for development

Type: Initial Release (MAJOR increment)
EOF
)"

git log --oneline --decorate
git tag -l
```

**Dependencies:** Task 11

**Validation:** None (automatic once unblocked)

**Output:** v1.0.0 tag created

**TaskMaster Instructions:**
- Use project name from Task 1
- Use project type from Task 1
- Create annotated tag
- Verify tag created
- Show git log with tag

---

### Task 13: Initialize TaskMaster in Project (Optional)

**Action:** Initialize TaskMaster in the new project for future task management

**Prompt:**
```
The project structure is complete. Would you like to initialize TaskMaster
in this project for future task management?

This will create a .taskmaster directory to track tasks going forward.

Reply "yes" to initialize TaskMaster, or "skip" to complete without it.
```

**Dependencies:** Task 12

**Validation:** 🛑 USER INPUT REQUIRED

**Output:** User decision on TaskMaster initialization

**TaskMaster Instructions:**
- PAUSE for user input
- If user says "yes":
  - Use mcp__taskmaster-ai__initialize_project with:
    - projectRoot: [project-path]
    - initGit: false (already initialized)
    - storeTasksInGit: true
    - addAliases: true
    - skipInstall: false
    - yes: true
    - rules: ["claude"]
- If user says "skip":
  - Mark task as complete and finish workflow
- Show TaskMaster initialization results if initialized

---

## Workflow Phases Summary

```
PHASE 1: PROJECT PLANNING
├─ Task 1: Determine Project Details [VALIDATION GATE - User Input]
├─ Task 2: Confirm Project Structure [VALIDATION GATE - User Approval]

PHASE 2: STRUCTURE CREATION
├─ Task 3: Create Directory Structure
├─ Task 4: Get Current Date
└─ Task 5: Initialize Git Repository

PHASE 3: DOCUMENTATION SETUP
├─ Task 6: Create README.md
├─ Task 7: Create CHANGELOG.md
├─ Task 8: Create CLAUDE.md
├─ Task 9: Create .gitignore
└─ Task 10: Review Documentation [VALIDATION GATE - User Approval]

PHASE 4: GIT INITIALIZATION
├─ Task 11: Create Initial Commit
├─ Task 12: Create v1.0.0 Tag
└─ Task 13: Initialize TaskMaster in Project (Optional) [VALIDATION GATE - User Input]

Total Tasks: 13
Total Validation Gates: 4
```

---

## Success Criteria

When this workflow completes:
- ✅ Project directory structure created per standards
- ✅ All three documentation files synchronized (v1.0.0, same date)
- ✅ Git repository initialized
- ✅ Initial commit created with descriptive message
- ✅ v1.0.0 tag applied
- ✅ User has approved structure and documentation
- ✅ Project ready for development

---

## Error Handling

**If user rejects at Task 2:**
- Revise project details
- Re-run from Task 1

**If user rejects at Task 10:**
- User can manually edit any file
- Re-run from Task 10 to review again
- Re-run Tasks 11-12 to complete

**If git init fails:**
- Check directory permissions
- Verify git is installed
- Manual intervention required

---

## Integration Points

**Integrates with:**
- Global CLAUDE.md standards
- Project type definitions (CCL/Web/MPage)
- Git workflow standards

**Can be called as sub-workflow from:**
- Future project template workflows
- Automated project scaffolding

**Next Steps After Completion:**
- Use TASKMASTER-GIT-ENHANCEMENT.md for first feature
- Use TASKMASTER-DOC-SYNC.md when updating versions

---

## Customization

**For simpler use cases:**
- Skip validation gates for experienced users
- Pre-populate project details

**For more complex scenarios:**
- Add package.json creation for Web/MPage projects
- Add CCL template files for CCL projects
- Add database schema for data-driven projects

---

## Notes

- This workflow follows the project structure standards from `/Users/troyshelton/Projects/CLAUDE.md`
- Supports all three project types: CCL, Web, MPage
- Can be extended with type-specific initialization steps
- Ensures documentation synchronization from day one
- Prevents the recurring issue of docs getting out of sync

---

**Created:** 2025-10-11
**Version:** 1.1
**Last Updated:** 2025-10-11
**Changes in v1.1:**
- Fixed path construction to use absolute paths
- Added explicit tool specifications (Write tool)
- Added optional TaskMaster initialization (Task 13)
- Updated validation gate count (4 total)
