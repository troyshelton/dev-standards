#!/bin/bash
# Git Pre-Commit Hook for Documentation Synchronization
#
# Installation:
#   cp /Users/troyshelton/Projects/.standards/pre-commit-hook-template.sh .git/hooks/pre-commit
#   chmod +x .git/hooks/pre-commit
#
# Purpose: Verify CHANGELOG, CLAUDE.md, and README.md are synchronized before allowing commit
#
# Note: This hook can be bypassed with --no-verify if absolutely necessary
#       But you should RARELY need to do that!

echo ""
echo "======================================================================"
echo "  PRE-COMMIT HOOK: Documentation Synchronization Check"
echo "======================================================================"
echo ""

# Check if documentation files exist
if [ ! -f "CHANGELOG.md" ] || [ ! -f "CLAUDE.md" ] || [ ! -f "README.md" ]; then
    echo "⚠️ Not all documentation files present - skipping sync check"
    exit 0
fi

# Get today's date
TODAY=$(date '+%Y-%m-%d')
echo "Today's date: $TODAY"
echo ""

# Extract versions from each file
CHANGELOG_VERSION=$(grep -m1 "^## \[" CHANGELOG.md | sed 's/## \[\(.*\)\].*/\1/' || echo "")
CLAUDE_VERSION=$(grep -m1 "Current Version:" CLAUDE.md | sed 's/.*v\([0-9.]*\).*/\1/' || echo "")
README_VERSION=$(grep -m1 "^\*\*Version\*\*:" README.md | sed 's/.*v\([0-9.]*\).*/\1/' || echo "")

# Extract dates from each file
CHANGELOG_DATE=$(grep -m1 "^## \[.*\] -" CHANGELOG.md | sed 's/.*- \(.*\)/\1/' || echo "")
CLAUDE_DATE=$(grep -m1 "^\*\*Date\*\*:" CLAUDE.md | sed 's/.*: \(.*\)/\1/' || echo "")
README_DATE=$(grep -m1 "^\*\*Last Updated\*\*:" README.md | sed 's/.*: \(.*\)/\1/' || echo "")

echo "=== VERSION CHECK ==="
echo "CHANGELOG.md: v$CHANGELOG_VERSION"
echo "CLAUDE.md:    v$CLAUDE_VERSION"
echo "README.md:    v$README_VERSION"
echo ""

echo "=== DATE CHECK ==="
echo "CHANGELOG.md: $CHANGELOG_DATE"
echo "CLAUDE.md:    $CLAUDE_DATE"
echo "README.md:    $README_DATE"
echo ""

# Check for version mismatch
VERSIONS_MATCH=true
if [ "$CHANGELOG_VERSION" != "$CLAUDE_VERSION" ] || [ "$CHANGELOG_VERSION" != "$README_VERSION" ]; then
    VERSIONS_MATCH=false
fi

# Check for date mismatch (all should match CHANGELOG date, which should be today for new versions)
DATES_MATCH=true
if [ "$CHANGELOG_DATE" != "$CLAUDE_DATE" ] || [ "$CHANGELOG_DATE" != "$README_DATE" ]; then
    DATES_MATCH=false
fi

# Report results
if [ "$VERSIONS_MATCH" = false ]; then
    echo "❌ VERSION MISMATCH DETECTED!"
    echo ""
    echo "All three files must have the same version number."
    echo ""
    echo "To fix:"
    echo "1. Update CLAUDE.md header to v$CHANGELOG_VERSION"
    echo "2. Update README.md header to v$CHANGELOG_VERSION"
    echo "3. Run 'git add CLAUDE.md README.md'"
    echo "4. Try commit again"
    echo ""
    echo "See: /Users/troyshelton/Projects/.standards/DOCUMENTATION-SYNC-PROTOCOL.md"
    echo ""
    echo "To bypass this check (NOT RECOMMENDED):"
    echo "  git commit --no-verify"
    echo ""
    exit 1
fi

if [ "$DATES_MATCH" = false ]; then
    echo "⚠️ DATE MISMATCH DETECTED!"
    echo ""
    echo "All three files should have matching dates."
    echo "CHANGELOG date should match commit date."
    echo ""
    echo "Expected date: $CHANGELOG_DATE (from CHANGELOG.md)"
    echo ""
    echo "To fix:"
    echo "1. Update CLAUDE.md date to $CHANGELOG_DATE"
    echo "2. Update README.md date to $CHANGELOG_DATE"
    echo "3. Run 'git add CLAUDE.md README.md'"
    echo "4. Try commit again"
    echo ""
    echo "See: /Users/troyshelton/Projects/.standards/DOCUMENTATION-SYNC-PROTOCOL.md"
    echo ""
    echo "To bypass this check (NOT RECOMMENDED):"
    echo "  git commit --no-verify"
    echo ""
    exit 1
fi

# All checks passed
echo "✅ All version numbers match: v$CHANGELOG_VERSION"
echo "✅ All dates match: $CHANGELOG_DATE"
echo ""
echo "Documentation is synchronized. Proceeding with commit..."
echo ""

exit 0
