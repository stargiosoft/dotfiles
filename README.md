# Dotfiles

Claude Code 환경 설정 파일 저장소

## Quick Start

### Windows (PowerShell)

```powershell
# 1. Clone repository
git clone https://github.com/stargiosoft/dotfiles.git $env:USERPROFILE\dotfiles

# 2. Set API keys (required MCP servers)
$env:FIRECRAWL_API_KEY = "your-firecrawl-api-key"
$env:SUPABASE_ACCESS_TOKEN = "your-supabase-token"

# Optional: Set if you need TestSprite or Figma
# $env:TESTSPRITE_API_KEY = "your-testsprite-api-key"
# $env:FIGMA_API_KEY = "your-figma-api-key"

# 3. Run setup script
& $env:USERPROFILE\dotfiles\claude\setup-mcp.ps1
```

### macOS / Linux (Bash)

```bash
# 1. Clone repository
git clone https://github.com/stargiosoft/dotfiles.git ~/dotfiles

# 2. Set API keys (required MCP servers)
export FIRECRAWL_API_KEY="your-firecrawl-api-key"
export SUPABASE_ACCESS_TOKEN="your-supabase-token"

# Optional: Set if you need TestSprite or Figma
# export TESTSPRITE_API_KEY="your-testsprite-api-key"
# export FIGMA_API_KEY="your-figma-api-key"

# 3. Run setup script
chmod +x ~/dotfiles/claude/setup-mcp.sh
~/dotfiles/claude/setup-mcp.sh
```

**Note**:
- **Required**: Firecrawl, Supabase (API keys needed)
- **Always installed**: Playwright (no API key needed)
- **Optional**: TestSprite, Figma (skip if API keys not set)

## Installed Components

### MCP Servers

| MCP | Description | API Key | Status |
|-----|-------------|---------|--------|
| **Firecrawl** | Web scraping & crawling | **Required** | ✅ Installed |
| **Playwright** | Browser automation | Not required | ✅ Installed |
| **Supabase** | Database management | **Required** | ✅ Installed |
| **Sentry** | Error monitoring & AI analysis | OAuth | ✅ Installed |
| TestSprite | Auto testing & debugging | Optional | ⚠️ Optional |
| Figma | Design to code | Optional | ⚠️ Optional |
| Google Sheets | Spreadsheet read/write | Service Account | ⚠️ Optional |

**Note**: Serena plugin also provides its own MCP server for LSP operations.

### Plugins

| Plugin | Description | Marketplace | Status |
|--------|-------------|-------------|--------|
| **feature-dev** | Feature development guide | official | ✅ Enabled |
| **supabase** | Supabase DB management | official | ✅ Enabled |
| **code-review** | Code review | official | ✅ Enabled |
| **pr-review-toolkit** | PR review tools | official | ✅ Enabled |
| **frontend-design** | Frontend design | official | ✅ Enabled |
| **typescript-lsp** | TypeScript LSP | official | ✅ Enabled |
| **serena** | LSP-based semantic code analysis (token optimization) | official | ✅ Enabled |
| claude-mem | Persistent memory system | thedotmack | ⚠️ Disabled by default |

## API Key Registration

| Service | URL |
|---------|-----|
| Firecrawl | https://www.firecrawl.dev/app/api-keys |
| Supabase | https://supabase.com/dashboard/account/tokens |
| Sentry | OAuth (auto-prompted on first use) |
| TestSprite | https://www.testsprite.com |
| Figma | Figma App > Settings > Personal access tokens |
| Google Sheets | https://console.cloud.google.com/apis/credentials (Service Account JSON) |

## Currently Installed Setup

Based on the default configuration with required API keys only:

**MCP Servers (4 active):**
- ✅ Firecrawl - Web scraping with API
- ✅ Playwright - Browser automation
- ✅ Supabase - Database operations
- ✅ Sentry - Error monitoring & AI root cause analysis
- ⚠️ Google Sheets - Spreadsheet operations (optional)
- ⚠️ Serena MCP - Provided by serena plugin

**Plugins (8 enabled):**
- ✅ feature-dev - Guided development
- ✅ supabase - DB integration
- ✅ code-review - Code review
- ✅ pr-review-toolkit - PR analysis
- ✅ frontend-design - UI design
- ✅ typescript-lsp - TS language server
- ✅ serena - Token-efficient code operations
- ⚠️ claude-mem - Installed but disabled

## claude-mem Plugin

Persistent memory system that auto-saves/injects context across sessions.

**Note**: claude-mem is installed but **disabled by default**. Enable it per project if needed.

### Features

- **Auto Capture**: Automatically records all tool usage during coding sessions
- **Context Injection**: Auto-injects relevant context at session start
- **Natural Language Search**: Ask questions like "What did I do last session?"
- **Web Viewer**: View saved memories at http://localhost:37777

### Starting claude-mem Worker

The web viewer requires the worker to be running:

**Windows:**
```powershell
$env:USERPROFILE\.bun\bin\bun.exe (Get-ChildItem $env:USERPROFILE\.claude\plugins\cache\thedotmack\claude-mem\*\scripts\worker-cli.js).FullName start
```

**macOS / Linux:**
```bash
bun ~/.claude/plugins/cache/thedotmack/claude-mem/*/scripts/worker-cli.js start
```

### Repository

https://github.com/thedotmack/claude-mem

## Configuration Files

### settings.json

Global plugin enable/disable settings. Located at `~/.claude/settings.json`

### settings.local.json

Local settings including:
- Custom bash permissions
- MCP server configurations with API keys

**Note:** This file contains sensitive API keys. Use `settings.local.json.example` as a template.

## File Structure

```
dotfiles/
├── claude/
│   ├── setup-mcp.sh              # Unix/Mac setup script
│   ├── setup-mcp.ps1             # Windows setup script
│   ├── settings.json             # Plugin settings template
│   └── settings.local.json.example  # Local settings template
└── README.md
```

## Troubleshooting

### Figma MCP Connection Issues

**Problem**: Figma MCP fails to connect with errors like "No token data found" or "400 Bad Request"

**Root Cause**:
- Figma deprecated SSE (Server-Sent Events) transport in favor of HTTP
- Old package `@anthropic/mcp-server-figma` (stdio/SSE) no longer works
- Transport type must be explicitly set to `"http"`

**Solution**: Use HTTP transport instead of stdio/SSE

**Correct Configuration** (`~/.claude.json`):
```json
{
  "mcpServers": {
    "figma": {
      "type": "http",
      "url": "https://mcp.figma.com/mcp",
      "headers": {
        "X-Figma-Token": "figd_xxx..."
      }
    }
  }
}
```

**❌ WRONG - Don't use these**:
```json
// ❌ Wrong: stdio transport with @anthropic/mcp-server-figma
{
  "figma": {
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-figma"]
  }
}

// ❌ Wrong: SSE transport (deprecated)
{
  "figma": {
    "type": "sse",
    "url": "https://mcp.figma.com/mcp"
  }
}
```

**Verification Steps**:
1. Restart Claude Code after changing config
2. Run `/mcp` command in Claude to verify connection
3. You should see "Connected to figma"

**API Key**: Get your Figma Personal Access Token from:
- Figma Desktop App → Settings → Personal access tokens
- Or: https://www.figma.com/developers/api#access-tokens

**Reference**: [GitHub Issue #5125](https://github.com/anthropics/anthropic-quickstarts/issues/5125)

---

## Manual Configuration

If the setup script doesn't work, you can manually configure:

### Add MCP Servers

```bash
# Firecrawl
claude mcp add firecrawl -s user -- npx -y firecrawl-mcp

# Playwright
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest

# Supabase
claude mcp add supabase -s user -- npx -y @supabase/mcp-server-supabase@latest --access-token YOUR_TOKEN

# TestSprite
claude mcp add testsprite -s user -- npx -y @testsprite/testsprite-mcp@latest
```

**Note**: Figma MCP cannot be added via CLI. You must manually edit `~/.claude.json`:

```json
{
  "mcpServers": {
    "figma": {
      "type": "http",
      "url": "https://mcp.figma.com/mcp",
      "headers": {
        "X-Figma-Token": "YOUR_FIGMA_API_KEY_HERE"
      }
    }
  }
}
```

### Install Plugins

```bash
# Add marketplace
claude plugin marketplace add thedotmack/claude-mem

# Install official plugins
claude plugin install feature-dev@claude-plugins-official
claude plugin install supabase@claude-plugins-official
claude plugin install code-review@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install typescript-lsp@claude-plugins-official
claude plugin install serena@claude-plugins-official

# Install community plugins
claude plugin install claude-mem@thedotmack
```

## Serena Plugin Configuration

Serena uses LSP (Language Server Protocol) for symbol-level code operations, saving tokens.

**Note**: Serena is installed as a **plugin** (not MCP) for easier management. No additional runtime required!

### Project Configuration

Create `.serena/config.yaml` in your project:

```yaml
# Serena Configuration
# LSP-based semantic code retrieval and editing

# Project languages (auto-detected, but can be specified)
# languages:
#   - typescript
#   - python

# Exclude patterns
exclude_patterns:
  - node_modules/
  - build/
  - dist/
  - .git/
  - "*.log"
```

### Benefits

- **Token Savings**: Uses symbol-level operations instead of reading entire files
- **Precision**: Finds exact functions/classes using LSP, not string search
- **IDE-like**: Provides "Go to Definition", "Find References" capabilities to LLMs

Example:
- Old: Read entire 500-line file → 500 lines in context
- Serena: `find_symbol("createUser")` → Only 20 lines in context

### More Info

https://github.com/oraios/serena
```
