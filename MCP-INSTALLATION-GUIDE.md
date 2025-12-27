# MCP Server Installation Guide

**Purpose:** Prevent recurring MCP configuration issues

**Created:** 2025-10-11
**Last Updated:** 2025-10-11

---

## ⚠️ CRITICAL: Always Use User Scope

**TL;DR:** Always install MCP servers with `-s user` scope, NEVER project scope.

```bash
# ✅ CORRECT
claude mcp add -s user <name> -- <command>

# ❌ WRONG - Will cause tools to not load
claude mcp add -s project <name> -- <command>
```

---

## The Recurring Issue

### Problem Description

MCP servers installed at **project scope** show as "Connected" in `claude mcp list` but their tools **don't actually load** in Claude Code sessions.

**Symptoms:**
- `claude mcp list` shows: `✓ Connected`
- `claude mcp get <name>` shows: `Scope: Project config`
- But tools are NOT available in function list
- `ListMcpResourcesTool` shows server not found

### Root Cause

Project-scoped MCPs (`.mcp.json`) require per-project approval and don't reliably expose tools to active Claude Code sessions. This is a known limitation/bug.

User-scoped MCPs (`~/.claude.json`) load globally and work consistently.

---

## Installation Best Practices

### Standard Installation Pattern

**For all MCP servers, use user scope:**

```bash
# Context7 (documentation fetcher)
claude mcp add -s user context7 -- npx -y @upstash/context7-mcp

# TaskMaster (workflow automation)
claude mcp add -s user taskmaster-ai -- npx -y --package=task-master-ai task-master-ai

# Any other MCP server
claude mcp add -s user <server-name> -- <command> [args...]
```

### Verification Steps

After installation:

```bash
# 1. Verify server is connected
claude mcp list

# 2. Check scope is "User config"
claude mcp get <server-name>

# Expected output:
# Scope: User config (available in all your projects) ✅
# Status: ✓ Connected
```

### Restart Requirement

**IMPORTANT:** After adding/moving an MCP server, restart Claude Code for tools to become available.

---

## Fixing Existing Project-Scoped MCPs

If an MCP is installed at project scope and not working:

```bash
# 1. Remove from project scope
claude mcp remove <server-name> -s project

# 2. Add to user scope
claude mcp add -s user <server-name> -- <command>

# 3. Verify
claude mcp get <server-name>

# 4. Restart Claude Code
```

### Example: Fixing TaskMaster

```bash
# Remove from project
claude mcp remove taskmaster-ai -s project

# Add to user scope
claude mcp add -s user taskmaster-ai -- npx -y --package=task-master-ai task-master-ai

# Verify
claude mcp get taskmaster-ai
# Should show: Scope: User config (available in all your projects)

# Restart Claude Code
```

---

## Understanding MCP Scopes

### Available Scopes

| Scope | Config File | Use Case | Reliability |
|-------|-------------|----------|-------------|
| **user** | `~/.claude.json` | Global, all projects | ✅ **Reliable** |
| **local** | `~/.claude.json` (project-specific section) | Single project, private | ⚠️ Mixed |
| **project** | `.mcp.json` in project | Shared via git | ❌ **Unreliable** |

### Recommended Strategy

**Always use `user` scope** unless you have a specific reason not to.

**Reasons to use other scopes:**
- **local**: Testing an MCP before making it global
- **project**: Never use (broken functionality)

---

## Installed MCP Servers (Reference)

### Current Installation

```bash
# Check what's installed
claude mcp list
```

**Expected MCPs:**

1. **context7** (User scope)
   - Purpose: Up-to-date library documentation
   - Command: `npx -y @upstash/context7-mcp`
   - Status: ✅ Working

2. **taskmaster-ai** (User scope)
   - Purpose: Workflow automation with validation gates
   - Command: `npx -y --package=task-master-ai task-master-ai`
   - Status: ✅ Fixed (moved from project to user scope)

3. **MCP_DOCKER** (User scope)
   - Purpose: Gateway for multiple MCP servers
   - Command: `docker mcp gateway run`
   - Status: ✅ Working

---

## Troubleshooting

### MCP Shows Connected But Tools Not Available

**Diagnosis:**
```bash
claude mcp get <server-name>
```

**If it shows:**
```
Scope: Project config (shared via .mcp.json)
```

**Fix:**
```bash
# Move to user scope
claude mcp remove <server-name> -s project
claude mcp add -s user <server-name> -- <original-command>

# Restart Claude Code
```

### MCP Not Showing at All

**Check if it's installed:**
```bash
claude mcp list
```

**If not listed, install with user scope:**
```bash
claude mcp add -s user <server-name> -- <command>
```

### MCP Connection Failures

**Check MCP server status:**
```bash
claude mcp list
# Look for ✓ Connected or ❌ errors
```

**Common fixes:**
1. Check npm/npx is installed and working
2. Check Docker is running (for MCP_DOCKER)
3. Check internet connection (some MCPs need network access)
4. Restart Claude Code
5. Try removing and re-adding the server

---

## Quick Reference

### Common Commands

```bash
# List all MCPs
claude mcp list

# Get details about specific MCP
claude mcp get <server-name>

# Add MCP (ALWAYS use -s user)
claude mcp add -s user <name> -- <command>

# Remove MCP
claude mcp remove <server-name> -s user

# View help
claude mcp --help
```

### Installation Checklist

When installing any new MCP:

- [ ] Use `-s user` scope
- [ ] Verify with `claude mcp get <name>`
- [ ] Check scope shows "User config"
- [ ] Restart Claude Code
- [ ] Test tools are available
- [ ] Document in this file

---

## Historical Issues

### Issue 1: Context7 Not Loading (Resolved)

**Date:** Previous session
**Problem:** Context7 configured but tools not available
**Cause:** Unknown (likely similar to project scope issue)
**Resolution:** Reinstalled with user scope

### Issue 2: TaskMaster Not Loading (Resolved)

**Date:** 2025-10-11
**Problem:** TaskMaster configured at project scope, tools not available
**Cause:** Project-scoped MCPs don't expose tools reliably
**Resolution:** Moved from project scope to user scope

---

## Related Documentation

- [WORKFLOWS/TASKMASTER-USAGE-GUIDE.md](WORKFLOWS/TASKMASTER-USAGE-GUIDE.md) - How to use TaskMaster MCP
- [SESSION-START-PROTOCOL.md](SESSION-START-PROTOCOL.md) - Session initialization
- Global CLAUDE.md references MCP servers in workflow descriptions

---

**Remember:** This issue has happened multiple times. Always check this guide before installing new MCP servers!

---

**Created:** 2025-10-11
**Version:** 1.0
**Last Incident:** 2025-10-11 (TaskMaster project scope issue)
