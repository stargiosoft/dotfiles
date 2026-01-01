# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment Overview

This is a macOS home directory containing personal automation scripts, service credentials, and several web application projects.

## Key Directories

- `claude-mem/` - Claude Code plugin for persistent memory (has its own CLAUDE.md)
- `tarot-app/` - React TypeScript application
- `stargio-app/` - React application
- `jeju-rentcar/` - Playwright automation scripts
- `figmamacro-supabase/` - Supabase project

## Python Scripts

Various automation scripts for Google Analytics, Gmail, and Google Sheets integration:

```bash
# Run Python scripts
python3 <script_name>.py

# Key scripts:
# - ga_weekly_report.py, ga_csv_report.py - GA4 reporting
# - email_scheduler.py, email_sender.py - Email automation
# - cs_email_monitor.py, cs_auto_reply.py - Customer service monitoring
```

## Credentials

Service account files (keep secure, never commit):
- `ga4-service-account.json` - Google Analytics
- `sheets-service-account.json` - Google Sheets
- `gunghapting-fb21e-*.json` - Firebase

## MCP Servers

Figma MCP server configured at `http://127.0.0.1:3845/mcp` for design-to-code workflows.

## Path Configuration

Custom paths in `.zshrc`:
- `~/.npm-global/bin` - Global npm packages
- `~/.local/bin` - Local binaries
- `~/.antigravity/antigravity/bin` - Antigravity tool
