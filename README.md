# Dotfiles

개인 설정 파일 저장소

## Claude Code MCP 설정

새 PC에서 Claude Code MCP를 빠르게 설정하는 스크립트

### 사용법

```bash
# 1. 저장소 클론
git clone https://github.com/stargiosoft/dotfiles.git ~/dotfiles

# 2. 환경 변수 설정 (API 키가 필요한 MCP용)
export FIRECRAWL_API_KEY="your-firecrawl-api-key"
export SUPABASE_ACCESS_TOKEN="your-supabase-token"
export TESTSPRITE_API_KEY="your-testsprite-api-key"

# 3. 스크립트 실행
chmod +x ~/dotfiles/claude/setup-mcp.sh
~/dotfiles/claude/setup-mcp.sh
```

### 설치되는 MCP

| MCP | 설명 | API 키 |
|-----|------|--------|
| Firecrawl | 웹 스크래핑 | 필요 |
| Playwright | 브라우저 자동화 | 불필요 |
| Supabase | DB 관리 | 필요 |
| TestSprite | 자동 테스트/디버깅 | 필요 |

### 설치되는 플러그인

| 플러그인 | 설명 | 마켓플레이스 |
|---------|------|-------------|
| feature-dev | 기능 개발 가이드 | official |
| supabase | Supabase DB 관리 | official |
| code-review | 코드 리뷰 | official |
| pr-review-toolkit | PR 리뷰 도구 | official |
| frontend-design | 프론트엔드 디자인 | official |
| typescript-lsp | TypeScript LSP | official |
| claude-mem | 영속 메모리 시스템 | thedotmack |

### claude-mem 플러그인

세션 간 컨텍스트를 자동 저장/주입하는 영속 메모리 시스템

- **자동 캡처**: 코딩 세션 중 모든 도구 사용을 자동 기록
- **컨텍스트 주입**: 다음 세션 시작 시 관련 컨텍스트 자동 주입
- **자연어 검색**: "지난 세션에서 뭐 했지?", "이 버그 전에 고친 적 있어?" 질문 가능
- **웹 뷰어**: http://localhost:37777 에서 저장된 메모리 확인
- **저장소**: https://github.com/thedotmack/claude-mem

### API 키 발급

- **Firecrawl**: https://www.firecrawl.dev/app/api-keys
- **Supabase**: https://supabase.com/dashboard/account/tokens
- **TestSprite**: https://www.testsprite.com
