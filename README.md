# Dotfiles

개인 설정 파일 저장소

## Claude Code MCP 설정

새 PC에서 Claude Code MCP를 빠르게 설정하는 스크립트

### 사용법

```bash
# 1. 저장소 클론
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# 2. 환경 변수 설정 (API 키가 필요한 MCP용)
export FIRECRAWL_API_KEY="your-firecrawl-api-key"

# 3. 스크립트 실행
chmod +x ~/dotfiles/claude/setup-mcp.sh
~/dotfiles/claude/setup-mcp.sh
```

### 설치되는 MCP

| MCP | 설명 | API 키 |
|-----|------|--------|
| Firecrawl | 웹 스크래핑 | 필요 |
| Playwright | 브라우저 자동화 | 불필요 |

### 설치되는 플러그인

| 플러그인 | 설명 |
|---------|------|
| feature-dev | 기능 개발 가이드 |
| supabase | Supabase DB 관리 |
| code-review | 코드 리뷰 |
| pr-review-toolkit | PR 리뷰 도구 |
| frontend-design | 프론트엔드 디자인 |
| typescript-lsp | TypeScript LSP |
| claude-mem | 영구 메모리 |

### API 키 발급

- **Firecrawl**: https://www.firecrawl.dev/app/api-keys
