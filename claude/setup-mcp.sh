#!/bin/bash
# Claude Code MCP & Plugin Setup Script
#
# Usage:
# 1. Set environment variables:
#    export FIRECRAWL_API_KEY="your-api-key"
#    export SUPABASE_ACCESS_TOKEN="your-token"
#    export TESTSPRITE_API_KEY="your-api-key"
#    export FIGMA_API_KEY="your-figma-api-key"
# 2. Run script: ./setup-mcp.sh

echo "========================================"
echo "  Claude Code MCP & Plugin Setup"
echo "========================================"
echo ""

# Check if claude command exists
if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code CLI not found. Please install it first:"
    echo "  npm install -g @anthropic-ai/claude-code"
    exit 1
fi

echo "Installing MCP servers..."

# Firecrawl MCP (API key required)
if [ -z "$FIRECRAWL_API_KEY" ]; then
    echo "WARNING: FIRECRAWL_API_KEY not set. Skipping Firecrawl MCP."
    echo "  Set with: export FIRECRAWL_API_KEY='your-api-key'"
else
    claude mcp add firecrawl -s user -- env FIRECRAWL_API_KEY="$FIRECRAWL_API_KEY" npx -y firecrawl-mcp
    echo "OK Firecrawl MCP installed"
fi

# Playwright MCP (no API key required)
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest
echo "OK Playwright MCP installed"

# Supabase MCP (Access Token required)
if [ -z "$SUPABASE_ACCESS_TOKEN" ]; then
    echo "WARNING: SUPABASE_ACCESS_TOKEN not set. Skipping Supabase MCP."
    echo "  Get token: https://supabase.com/dashboard/account/tokens"
    echo "  Set with: export SUPABASE_ACCESS_TOKEN='your-token'"
else
    claude mcp add supabase -s user -- npx -y @supabase/mcp-server-supabase@latest --access-token "$SUPABASE_ACCESS_TOKEN"
    echo "OK Supabase MCP installed"
fi

# TestSprite MCP (API key required)
if [ -z "$TESTSPRITE_API_KEY" ]; then
    echo "WARNING: TESTSPRITE_API_KEY not set. Skipping TestSprite MCP."
    echo "  Get key: https://www.testsprite.com"
    echo "  Set with: export TESTSPRITE_API_KEY='your-api-key'"
else
    claude mcp add testsprite -s user -- env API_KEY="$TESTSPRITE_API_KEY" npx -y @testsprite/testsprite-mcp@latest
    echo "OK TestSprite MCP installed"
fi

# Figma MCP (API key required)
if [ -z "$FIGMA_API_KEY" ]; then
    echo "WARNING: FIGMA_API_KEY not set. Skipping Figma MCP."
    echo "  Get key: Figma > Settings > Personal access tokens"
    echo "  Set with: export FIGMA_API_KEY='your-api-key'"
else
    claude mcp add figma -s user -- env FIGMA_API_KEY="$FIGMA_API_KEY" npx -y @anthropic/mcp-server-figma
    echo "OK Figma MCP installed"
fi

# Serena - LSP-based token optimization (installed as plugin, not MCP)
# Note: Serena is installed as a plugin in the plugins section below
# The plugin version is easier to manage and doesn't require uv installation

echo ""
echo "Installing plugins..."

# Add community marketplace
echo "Adding thedotmack/claude-mem marketplace..."
claude plugin marketplace add thedotmack/claude-mem
echo "OK thedotmack marketplace added"

# Official plugins
for plugin in feature-dev supabase code-review pr-review-toolkit frontend-design typescript-lsp serena; do
    echo "Installing $plugin..."
    claude plugin install "$plugin@claude-plugins-official"
    echo "OK $plugin installed"
done

# Community plugins (thedotmack marketplace)
echo "Installing claude-mem..."
claude plugin install claude-mem@thedotmack
echo "OK claude-mem installed"

echo ""
echo "========================================"
echo "  Setup complete! Restart Claude Code."
echo "========================================"
echo ""

# Install Bun for claude-mem worker
echo "Installing Bun runtime for claude-mem..."
if command -v bun &> /dev/null; then
    echo "OK Bun already installed"
else
    curl -fsSL https://bun.sh/install | bash
    echo "OK Bun installed"
fi

echo ""
echo "To start claude-mem worker:"
echo "  bun ~/.claude/plugins/cache/thedotmack/claude-mem/*/scripts/worker-cli.js start"
