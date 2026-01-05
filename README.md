# Dotfiles

Claude Code 환경 설정 파일 저장소

## Quick Start

### Windows (PowerShell)

```powershell
# 1. Clone repository
git clone https://github.com/stargiosoft/dotfiles.git $env:USERPROFILE\dotfiles

# 2. Set API keys (get keys from links below)
$env:FIRECRAWL_API_KEY = "your-firecrawl-api-key"
$env:SUPABASE_ACCESS_TOKEN = "your-supabase-token"
$env:TESTSPRITE_API_KEY = "your-testsprite-api-key"
$env:FIGMA_API_KEY = "your-figma-api-key"

# 3. Run setup script
& $env:USERPROFILE\dotfiles\claude\setup-mcp.ps1
```

### macOS / Linux (Bash)

```bash
# 1. Clone repository
git clone https://github.com/stargiosoft/dotfiles.git ~/dotfiles

# 2. Set API keys (get keys from links below)
export FIRECRAWL_API_KEY="your-firecrawl-api-key"
export SUPABASE_ACCESS_TOKEN="your-supabase-token"
export TESTSPRITE_API_KEY="your-testsprite-api-key"
export FIGMA_API_KEY="your-figma-api-key"

# 3. Run setup script
chmod +x ~/dotfiles/claude/setup-mcp.sh
~/dotfiles/claude/setup-mcp.sh
```

## Installed Components

### MCP Servers

| MCP | Description | API Key |
|-----|-------------|---------|
| Firecrawl | Web scraping & crawling | Required |
| Playwright | Browser automation | Not required |
| Supabase | Database management | Required |
| TestSprite | Auto testing & debugging | Required |
| Figma | Design to code | Required |

### Plugins

| Plugin | Description | Marketplace |
|--------|-------------|-------------|
| feature-dev | Feature development guide | official |
| supabase | Supabase DB management | official |
| code-review | Code review | official |
| pr-review-toolkit | PR review tools | official |
| frontend-design | Frontend design | official |
| typescript-lsp | TypeScript LSP | official |
| claude-mem | Persistent memory system | thedotmack |

## API Key Registration

| Service | URL |
|---------|-----|
| Firecrawl | https://www.firecrawl.dev/app/api-keys |
| Supabase | https://supabase.com/dashboard/account/tokens |
| TestSprite | https://www.testsprite.com |
| Figma | Figma App > Settings > Personal access tokens |

## claude-mem Plugin

Persistent memory system that auto-saves/injects context across sessions.

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

# Figma
claude mcp add figma -s user -- npx -y @anthropic/mcp-server-figma
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

# Install community plugins
claude plugin install claude-mem@thedotmack
```
