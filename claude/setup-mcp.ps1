# Claude Code MCP & Plugin Setup Script for Windows
#
# Usage:
# 1. Set environment variables:
#    $env:FIRECRAWL_API_KEY = "your-api-key"
#    $env:SUPABASE_ACCESS_TOKEN = "your-token"
#    $env:TESTSPRITE_API_KEY = "your-api-key"
#    $env:FIGMA_API_KEY = "your-figma-api-key"
# 2. Run script: .\setup-mcp.ps1

Write-Host "========================================"
Write-Host "  Claude Code MCP & Plugin Setup"
Write-Host "========================================"
Write-Host ""

# Check if claude command exists
if (-not (Get-Command "claude" -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Claude Code CLI not found. Please install it first:" -ForegroundColor Red
    Write-Host "  npm install -g @anthropic-ai/claude-code"
    exit 1
}

Write-Host "Installing MCP servers..." -ForegroundColor Cyan

# Firecrawl MCP
if ([string]::IsNullOrEmpty($env:FIRECRAWL_API_KEY)) {
    Write-Host "WARNING: FIRECRAWL_API_KEY not set. Skipping Firecrawl MCP." -ForegroundColor Yellow
    Write-Host "  Set with: `$env:FIRECRAWL_API_KEY = 'your-api-key'"
} else {
    claude mcp add firecrawl -s user -- cmd /c "set FIRECRAWL_API_KEY=$env:FIRECRAWL_API_KEY && npx -y firecrawl-mcp"
    Write-Host "OK Firecrawl MCP installed" -ForegroundColor Green
}

# Playwright MCP (no API key required)
claude mcp add playwright -s user -- cmd /c "npx -y @playwright/mcp@latest"
Write-Host "OK Playwright MCP installed" -ForegroundColor Green

# Supabase MCP
if ([string]::IsNullOrEmpty($env:SUPABASE_ACCESS_TOKEN)) {
    Write-Host "WARNING: SUPABASE_ACCESS_TOKEN not set. Skipping Supabase MCP." -ForegroundColor Yellow
    Write-Host "  Get token: https://supabase.com/dashboard/account/tokens"
    Write-Host "  Set with: `$env:SUPABASE_ACCESS_TOKEN = 'your-token'"
} else {
    claude mcp add supabase -s user -- npx -y "@supabase/mcp-server-supabase@latest" --access-token $env:SUPABASE_ACCESS_TOKEN
    Write-Host "OK Supabase MCP installed" -ForegroundColor Green
}

# TestSprite MCP
if ([string]::IsNullOrEmpty($env:TESTSPRITE_API_KEY)) {
    Write-Host "WARNING: TESTSPRITE_API_KEY not set. Skipping TestSprite MCP." -ForegroundColor Yellow
    Write-Host "  Get key: https://www.testsprite.com"
    Write-Host "  Set with: `$env:TESTSPRITE_API_KEY = 'your-api-key'"
} else {
    claude mcp add testsprite -s user -- cmd /c "set API_KEY=$env:TESTSPRITE_API_KEY && npx -y @testsprite/testsprite-mcp@latest"
    Write-Host "OK TestSprite MCP installed" -ForegroundColor Green
}

# Figma MCP
if ([string]::IsNullOrEmpty($env:FIGMA_API_KEY)) {
    Write-Host "WARNING: FIGMA_API_KEY not set. Skipping Figma MCP." -ForegroundColor Yellow
    Write-Host "  Get key: Figma > Settings > Personal access tokens"
    Write-Host "  Set with: `$env:FIGMA_API_KEY = 'your-api-key'"
} else {
    claude mcp add figma -s user -- cmd /c "set FIGMA_API_KEY=$env:FIGMA_API_KEY && npx -y @anthropic/mcp-server-figma"
    Write-Host "OK Figma MCP installed" -ForegroundColor Green
}

# Sentry MCP (HTTP-based, OAuth authentication)
claude mcp add sentry -s user --transport http https://mcp.sentry.dev/mcp
Write-Host "OK Sentry MCP installed (OAuth auth required on first use)" -ForegroundColor Green

# Google Sheets MCP
if ([string]::IsNullOrEmpty($env:GOOGLE_APPLICATION_CREDENTIALS)) {
    Write-Host "WARNING: GOOGLE_APPLICATION_CREDENTIALS not set. Skipping Google Sheets MCP." -ForegroundColor Yellow
    Write-Host "  Get credentials: https://console.cloud.google.com/apis/credentials"
    Write-Host "  Set with: `$env:GOOGLE_APPLICATION_CREDENTIALS = 'path/to/credentials.json'"
} else {
    claude mcp add mcp-google-sheets -s user -- uvx mcp-google-sheets@latest
    Write-Host "OK Google Sheets MCP installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installing plugins..." -ForegroundColor Cyan

# Add community marketplace
Write-Host "Adding thedotmack/claude-mem marketplace..."
claude plugin marketplace add thedotmack/claude-mem
Write-Host "OK thedotmack marketplace added" -ForegroundColor Green

# Official plugins
$officialPlugins = @(
    "feature-dev",
    "supabase",
    "code-review",
    "pr-review-toolkit",
    "frontend-design",
    "typescript-lsp"
)

foreach ($plugin in $officialPlugins) {
    Write-Host "Installing $plugin..."
    claude plugin install "$plugin@claude-plugins-official"
    Write-Host "OK $plugin installed" -ForegroundColor Green
}

# Community plugins
Write-Host "Installing claude-mem..."
claude plugin install claude-mem@thedotmack
Write-Host "OK claude-mem installed" -ForegroundColor Green

Write-Host ""
Write-Host "========================================"
Write-Host "  Setup complete! Restart Claude Code."
Write-Host "========================================"
Write-Host ""

# Install Bun for claude-mem worker
Write-Host "Installing Bun runtime for claude-mem..." -ForegroundColor Cyan
try {
    irm bun.sh/install.ps1 | iex
    Write-Host "OK Bun installed" -ForegroundColor Green
    Write-Host ""
    Write-Host "To start claude-mem worker:" -ForegroundColor Yellow
    Write-Host "  `$env:USERPROFILE\.bun\bin\bun.exe `$env:USERPROFILE\.claude\plugins\cache\thedotmack\claude-mem\*\scripts\worker-cli.js start"
} catch {
    Write-Host "WARNING: Could not install Bun automatically." -ForegroundColor Yellow
    Write-Host "  Install manually: irm bun.sh/install.ps1 | iex"
}
