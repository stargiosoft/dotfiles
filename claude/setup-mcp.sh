#!/bin/bash
# Claude Code MCP Setup Script
#
# 사용법:
# 1. 환경 변수 설정: export FIRECRAWL_API_KEY="your-api-key"
# 2. 스크립트 실행: ./setup-mcp.sh

echo "Claude Code MCP 설정 중..."

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

# Figma MCP (로컬 서버 - Figma 앱에서 실행 필요)
# claude mcp add figma -s local --type http --url http://127.0.0.1:3845/mcp
# echo "✓ Figma MCP 설치됨 (Figma 앱에서 MCP 서버 실행 필요)"

echo ""
echo "🎉 MCP 설정 완료! Claude Code를 재시작하세요."
