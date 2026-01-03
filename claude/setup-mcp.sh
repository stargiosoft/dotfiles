#!/bin/bash
# Claude Code MCP & Plugin Setup Script
#
# 사용법:
# 1. 환경 변수 설정: export FIRECRAWL_API_KEY="your-api-key"
# 2. 스크립트 실행: ./setup-mcp.sh

echo "========================================"
echo "  Claude Code MCP & Plugin 설정"
echo "========================================"
echo ""
echo "📦 MCP 서버 설치 중..."

# Firecrawl MCP (API 키 필요)
if [ -z "$FIRECRAWL_API_KEY" ]; then
    echo "⚠️  FIRECRAWL_API_KEY 환경 변수가 설정되지 않았습니다."
    echo "   export FIRECRAWL_API_KEY='your-api-key' 로 설정 후 다시 실행하세요."
else
    claude mcp add firecrawl -s user -- env FIRECRAWL_API_KEY="$FIRECRAWL_API_KEY" npx -y firecrawl-mcp
    echo "✓ Firecrawl MCP 설치됨"
fi

# Playwright MCP (API 키 불필요)
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest
echo "✓ Playwright MCP 설치됨"

# Supabase MCP (Access Token 필요)
if [ -z "$SUPABASE_ACCESS_TOKEN" ]; then
    echo "⚠️  SUPABASE_ACCESS_TOKEN 환경 변수가 설정되지 않았습니다."
    echo "   https://supabase.com/dashboard/account/tokens 에서 토큰 생성 후"
    echo "   export SUPABASE_ACCESS_TOKEN='your-token' 로 설정하세요."
else
    claude mcp add supabase -s user -- npx -y @supabase/mcp-server-supabase@latest --access-token "$SUPABASE_ACCESS_TOKEN"
    echo "✓ Supabase MCP 설치됨"
fi

# Figma MCP (로컬 서버 - Figma 앱에서 실행 필요)
# claude mcp add figma -s local --type http --url http://127.0.0.1:3845/mcp
# echo "✓ Figma MCP 설치됨 (Figma 앱에서 MCP 서버 실행 필요)"

echo ""
echo "🔌 플러그인 설치 중..."

# Official 플러그인
claude plugin install feature-dev@claude-plugins-official
echo "✓ feature-dev 설치됨"

claude plugin install supabase@claude-plugins-official
echo "✓ supabase 설치됨"

claude plugin install code-review@claude-plugins-official
echo "✓ code-review 설치됨"

claude plugin install pr-review-toolkit@claude-plugins-official
echo "✓ pr-review-toolkit 설치됨"

claude plugin install frontend-design@claude-plugins-official
echo "✓ frontend-design 설치됨"

claude plugin install typescript-lsp@claude-plugins-official
echo "✓ typescript-lsp 설치됨"

# Community 플러그인
claude plugin install claude-mem@thedotmack
echo "✓ claude-mem (메모리) 설치됨"

echo ""
echo "========================================"
echo "🎉 설정 완료! Claude Code를 재시작하세요."
echo "========================================"
