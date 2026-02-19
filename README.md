# Dotfiles

Claude Code 환경 설정 파일 저장소

## Quick Start

### Windows (PowerShell)

```powershell
# 1. Clone repository
git clone https://github.com/stargiosoft/dotfiles.git $env:USERPROFILE\dotfiles

# 2. Claude 설정 파일 복사
Copy-Item $env:USERPROFILE\dotfiles\claude\settings.json $env:USERPROFILE\.claude\settings.json
Copy-Item -Recurse $env:USERPROFILE\dotfiles\claude\commands $env:USERPROFILE\.claude\commands
Copy-Item -Recurse $env:USERPROFILE\dotfiles\claude\knowledge $env:USERPROFILE\.claude\knowledge

# 3. Set API keys (required MCP servers)
$env:FIRECRAWL_API_KEY = "your-firecrawl-api-key"
$env:SUPABASE_ACCESS_TOKEN = "your-supabase-token"

# Optional
# $env:FIGMA_API_KEY = "your-figma-api-key"

# 4. Run setup script
& $env:USERPROFILE\dotfiles\claude\setup-mcp.ps1
```

### macOS / Linux (Bash)

```bash
# 1. Clone repository
git clone https://github.com/stargiosoft/dotfiles.git ~/dotfiles

# 2. Claude 설정 파일 복사
cp ~/dotfiles/claude/settings.json ~/.claude/settings.json
cp -r ~/dotfiles/claude/commands ~/.claude/commands
cp -r ~/dotfiles/claude/knowledge ~/.claude/knowledge

# 3. Set API keys (required MCP servers)
export FIRECRAWL_API_KEY="your-firecrawl-api-key"
export SUPABASE_ACCESS_TOKEN="your-supabase-token"

# Optional
# export FIGMA_API_KEY="your-figma-api-key"

# 4. Run setup script
chmod +x ~/dotfiles/claude/setup-mcp.sh
~/dotfiles/claude/setup-mcp.sh
```

**Note**:
- **Required**: Firecrawl, Supabase (API keys needed)
- **Always installed**: Playwright (no API key needed)
- **Optional**: Figma (skip if API key not set)

---

## File Structure

```
dotfiles/
├── claude/
│   ├── commands/                     # 커스텀 슬래시 커맨드
│   │   └── thread.md                 # /thread — 스레드 바이럴 글 작성기
│   ├── knowledge/                    # AI 지식 베이스
│   │   ├── 마케팅_용어.txt
│   │   ├── 서비스_기획.txt
│   │   └── 행동경제학.txt
│   ├── setup-mcp.sh                  # Unix/Mac setup script
│   ├── setup-mcp.ps1                 # Windows setup script
│   ├── settings.json                 # 글로벌 설정 (plugins, permissions)
│   └── settings.local.json.example  # 로컬 설정 템플릿 (API keys 포함)
└── README.md
```

---

## Custom Commands (Slash Commands)

`~/.claude/commands/` 에 `.md` 파일을 두면 Claude Code에서 `/파일명` 으로 실행할 수 있어.

### /thread — 스레드 바이럴 글 작성기

```
/thread
/thread 비즈니스 모델 주제로 써줘
/thread 오늘 온보딩 이탈률 보고 충격받음
```

IT 기획자 페르소나로 스레드(Threads) 바이럴 글을 자동 생성.
- knowledge 파일에서 반직관적 인사이트 자동 추출
- 본글(5줄) + 댓글(2~5개) 구조로 출력
- 후킹 전략, 리듬, 줄바꿈까지 설계

---

## Knowledge Base

`~/.claude/knowledge/` 에 `.txt` 파일을 두면 커스텀 커맨드에서 참조할 수 있어.

| 파일 | 내용 |
|------|------|
| `마케팅_용어.txt` | AARRR, GTM, PMF, 브랜딩 vs 마케팅, 플랫폼 BM 등 |
| `서비스_기획.txt` | 기획 순서, OMTM, KPI, 화면 설계, 애자일 등 |
| `행동경제학.txt` | 피크엔드 법칙, 앵커링, 선택의 역설, 손실회피 등 |

---

## Installed Components

### MCP Servers

| MCP | Description | API Key | Status |
|-----|-------------|---------|--------|
| **Firecrawl** | Web scraping & crawling | **Required** | ✅ |
| **Playwright** | Browser automation | Not required | ✅ |
| **Supabase** | Database management | **Required** | ✅ |
| **Sentry** | Error monitoring & AI analysis | OAuth | ✅ |
| Figma | Design to code | Optional | ⚠️ |
| Google Sheets | Spreadsheet read/write | Service Account | ⚠️ |

### Plugins

| Plugin | Description | Status |
|--------|-------------|--------|
| **feature-dev** | Feature development guide | ✅ |
| **supabase** | Supabase DB management | ✅ |
| **code-review** | Code review | ✅ |
| **pr-review-toolkit** | PR review tools | ✅ |
| **frontend-design** | Frontend design | ✅ |
| **typescript-lsp** | TypeScript LSP | ✅ |
| **serena** | LSP-based semantic code analysis | ✅ |
| claude-mem | Persistent memory system | ⚠️ Optional |

---

## API Key Registration

| Service | URL |
|---------|-----|
| Firecrawl | https://www.firecrawl.dev/app/api-keys |
| Supabase | https://supabase.com/dashboard/account/tokens |
| Sentry | OAuth (auto-prompted on first use) |
| Figma | Figma App > Settings > Personal access tokens |
| Google Sheets | https://console.cloud.google.com/apis/credentials |

---

## Configuration Files

### settings.json

글로벌 설정 파일. `~/.claude/settings.json` 에 위치.
- 허용/차단 bash 명령어 권한
- 활성화된 플러그인 목록
- 기본 모드, 모델 설정

### settings.local.json

기기별 로컬 설정. `settings.local.json.example` 을 복사해서 사용.
- MCP 서버 설정 (API 키 포함)
- 기기별 추가 bash 권한

**주의:** API 키가 포함되므로 절대 git에 커밋하지 말 것.

---

## Figma MCP 설정 주의사항

Figma MCP는 CLI 설치 불가. `~/.claude.json` 을 직접 수정해야 해.

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

> ❌ `@anthropic/mcp-server-figma` (stdio/SSE) 는 deprecated. HTTP transport 사용할 것.

---

## Troubleshooting

### MCP 연결 확인

```bash
claude mcp list
```

Claude Code 내에서 `/mcp` 명령으로도 확인 가능.

### claude-mem Worker 실행

**Windows:**
```powershell
$env:USERPROFILE\.bun\bin\bun.exe (Get-ChildItem $env:USERPROFILE\.claude\plugins\cache\thedotmack\claude-mem\*\scripts\worker-cli.js).FullName start
```

**macOS / Linux:**
```bash
bun ~/.claude/plugins/cache/thedotmack/claude-mem/*/scripts/worker-cli.js start
```

Web viewer: http://localhost:37777
