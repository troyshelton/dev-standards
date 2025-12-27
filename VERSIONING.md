# Version Tracking and Changelog Standards

Complete guide for version management, tracking, and changelog maintenance across projects.

## Table of Contents
- [Overview](#overview)
- [Version Management Strategy](#version-management-strategy)
- [Version Tracking Standards](#version-tracking-standards)
- [Changelog Requirements](#changelog-requirements)
- [Benefits of Version Tracking](#benefits-of-version-tracking)

## Overview

Proper version tracking enables:
- Quick identification of deployed versions
- Feature tracking and capability awareness
- Debugging support and issue correlation
- Change management and rollback capability

## Version Management Strategy

**CRITICAL DECISION**: Choose ONE versioning approach based on Git availability:

### Option A: Git-Based Versioning (RECOMMENDED)
**Use when Git repository is initialized and configured**

**Benefits:**
- Clean single working directory
- Git history preserves all changes
- Proper branch-based development
- Git tags for version releases
- Standard industry practice

**Structure:**
```
project-name/
├── README.md
├── CHANGELOG.md
├── src/
│   ├── ccl/           # Current version only
│   └── original/      # Template reference
└── docs/
```

**Workflow:**
```bash
# Feature development on branches
git checkout -b feature/add-parameter-2
# ... make changes ...
git commit -m "Add UM Status parameter"
git checkout main
git merge feature/add-parameter-2
git tag v1.1.0
```

### Option B: Version Directory Structure (LEGACY)
**Use ONLY when Git is not available or cannot be used**

**Structure:**
```
project-name/
├── README.md
├── CHANGELOG.md
├── src/
│   ├── ccl/
│   │   ├── v1.0.0/    # Frozen - Do not modify
│   │   ├── v1.1.0/    # Current work
│   │   └── v1.2.0/    # Next version
│   └── original/      # Template reference
└── docs/
```

**Rules for Version Directories:**
- **NEVER modify existing version directories**
- **ALWAYS create new version directory first**
- Copy previous version before making changes

## Version Tracking Standards

### For Web Projects (HTML/CSS/JavaScript)

#### HTML Meta Tags (Required)
```html
<head>
    <!-- Version Information -->
    <meta name="version" content="v1.3.0">
    <meta name="build-date" content="2025-08-30">
    <meta name="git-branch" content="feature/enhancement-name">
    <meta name="git-commit" content="abc1234">
</head>
```

#### JavaScript Global Objects (Required)
```javascript
window.PROJECT_VERSION = {
    version: "v1.3.0",
    buildDate: "2025-08-30",
    branch: "feature/enhancement-name",
    commit: "abc1234",
    features: ["feature1", "feature2", "feature3"]
};
```

#### Debug Console Integration (Recommended)
```javascript
// Show version info when debug console activated
logDebug('📋 Version: ' + window.PROJECT_VERSION.version + ' | Branch: ' + window.PROJECT_VERSION.branch);
logDebug('🚀 Features: ' + window.PROJECT_VERSION.features.join(', '));
```

#### Programmatic Access (Required)
```javascript
// Version information must be accessible programmatically
window.PROJECT_VERSION.version      // Get version string
window.PROJECT_VERSION.features     // List implemented features
window.PROJECT_VERSION.buildDate    // Get build timestamp
```

### For CCL Projects (CCL Programs)

#### CCL Header Comments (Required)
```ccl
;===============================================================================
; Program: my_program.prg
; Version: v1.3.0
; Build Date: 2025-08-30
; Git Branch: feature/enhancement-name
; Git Commit: abc1234
;
; Features: feature1, feature2, feature3
;
; Last Modified: 2025-08-30 by [Developer]
; Description: Brief description of program purpose
;===============================================================================
```

#### CCL Version Constants (Recommended)
```ccl
; Version tracking constants
DECLARE PROGRAM_VERSION = vc WITH CONSTANT("v1.3.0"), PROTECT
DECLARE BUILD_DATE = vc WITH CONSTANT("2025-08-30"), PROTECT
DECLARE GIT_BRANCH = vc WITH CONSTANT("feature/enhancement-name"), PROTECT
DECLARE PROGRAM_FEATURES = vc WITH CONSTANT("feature1,feature2,feature3"), PROTECT

; Log version information
CALL echo(build("Program Version: ", PROGRAM_VERSION))
CALL echo(build("Build Date: ", BUILD_DATE))
CALL echo(build("Features: ", PROGRAM_FEATURES))
```

#### CCL Record Structure (Advanced)
```ccl
; For programs that return version information
FREE RECORD version_info
RECORD version_info(
    1 program_version = vc
    1 build_date = vc
    1 git_branch = vc
    1 git_commit = vc
    1 features[*]
        2 feature_name = vc
)
```

### For MPage Projects (CCL + Web)

#### Coordinated Versioning (Required)
- **Same version number** in both CCL and web components
- **Consistent build date** across all files
- **Shared feature list** in both environments
- **Cross-reference capability** between web and CCL versions

#### Example Implementation
```javascript
// Web component
window.PROJECT_VERSION.cclVersion = "v1.3.0";  // Match CCL version

// CCL component
DECLARE WEB_VERSION = vc WITH CONSTANT("v1.3.0"), PROTECT  // Match web version
```

### Version Information Integration

#### Build Process Integration (Recommended)
```bash
# Auto-inject version info during build
BUILD_VERSION=$(git describe --tags --abbrev=0)
BUILD_DATE=$(date '+%Y-%m-%d')
BUILD_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BUILD_COMMIT=$(git rev-parse --short HEAD)

# Update HTML files with current git information
sed -i "s/PLACEHOLDER_VERSION/$BUILD_VERSION/g" *.html
sed -i "s/PLACEHOLDER_DATE/$BUILD_DATE/g" *.html
```

#### Deployment Verification (Required)
- **Check version after deployment**: Ensure correct version is deployed
- **Programmatic verification**: Use debug console or API to verify version
- **Documentation updates**: Update README.md with deployed version info
- **Change tracking**: CHANGELOG.md entries for each version

### README Template
```markdown
# Project Name

Brief description of the project.

## Current Status
**Version**: v1.2.0
**Active Branch**: feature/new-feature
**Last Updated**: 2025-01-10

## Quick Start
Installation and basic usage instructions.

## Documentation
- [API Reference](docs/api/)
- [Installation Guide](docs/guides/installation.md)
- [Troubleshooting](docs/guides/troubleshooting.md)

## Project Structure
Brief description of directory layout.

## Recent Changes
See [CHANGELOG.md](CHANGELOG.md)
```

## Changelog Requirements

### CHANGELOG.md Format
When creating or updating a CHANGELOG.md file:
1. **Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)** format
2. **Use [Semantic Versioning](https://semver.org/spec/v2.0.0.html)** (MAJOR.MINOR.PATCH)
3. **Include all notable changes** organized by version
4. **Categorize changes** using standard headings:
   - `Added` for new features
   - `Changed` for changes in existing functionality
   - `Deprecated` for soon-to-be removed features
   - `Removed` for now removed features
   - `Fixed` for any bug fixes
   - `Security` for vulnerability fixes

### Version Numbering
- **MAJOR** version: Incompatible API/behavior changes
- **MINOR** version: Backwards-compatible functionality additions
- **PATCH** version: Backwards-compatible bug fixes

### Example Changelog Entry
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2025-01-10
### Added
- New feature X for improved performance
- Support for additional data formats

### Changed
- Updated algorithm Y for better accuracy
- Improved error messaging

### Fixed
- Resolved issue with Z component
- Fixed memory leak in long-running processes

## [1.1.0] - 2025-01-05
### Added
- Initial parameter support

### Fixed
- Bug in date handling

## [1.0.0] - 2025-01-01
### Added
- Initial release
- Basic functionality
- Core features implemented
```

### Changelog Best Practices
1. **Keep it updated** - Add entries as changes are made
2. **Be specific** - Describe what changed and why
3. **Group changes** - Use standard categories consistently
4. **Link versions** - Include version tag links if using Git
5. **Date format** - Use ISO 8601 format (YYYY-MM-DD)
6. **User perspective** - Write for users, not developers
7. **Security first** - Always highlight security fixes

## Benefits of Version Tracking

### Development Benefits
- **Quick identification** of deployed versions
- **Feature tracking** - know what capabilities are available
- **Debugging support** - correlate issues with specific versions
- **Change management** - track what changed between versions

### Production Benefits
- **Support efficiency** - quickly identify version for troubleshooting
- **Deployment verification** - confirm correct version deployed
- **Change correlation** - link user reports to specific code changes
- **Rollback capability** - easy identification of previous working versions

### Maintenance Benefits
- **Historical tracking** - understand evolution of codebase
- **Feature documentation** - automatic listing of implemented features
- **Cross-reference capability** - link web and CCL component versions
- **Impact analysis** - understand scope of changes between versions

### Version Tracking Checklist

#### Before Deployment
- [ ] Version number updated in all files
- [ ] Build date reflects current date
- [ ] Git branch/commit information included
- [ ] Feature list matches implemented features
- [ ] CHANGELOG.md updated with changes
- [ ] README.md reflects current version

#### After Deployment
- [ ] Version verified in production
- [ ] Debug console shows correct version
- [ ] Documentation updated
- [ ] Git tag created for version
- [ ] Team notified of deployment

#### For MPage Projects (CCL + Web)
- [ ] CCL and web versions match
- [ ] Cross-references verified
- [ ] Both components tested together
- [ ] Coordinated deployment completed

---
*Last Updated: 2025-09-26*