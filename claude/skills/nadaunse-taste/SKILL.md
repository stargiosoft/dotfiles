---
name: nadaunse-taste
description: "나다운세 프론트엔드 디자인 품질 스킬. 모바일 운세 서비스에 최적화된 UI/UX 가드레일. Tailwind v4 + Pretendard + 440px 모바일 레이아웃 + iOS Safari 대응 + 안티-AI-슬롭 규칙. React 18 + Vite + shadcn/ui 기반. Actions: design, build, create, implement, review, fix, improve UI/UX code for nadaunse project."
---

# 나다운세 디자인 품질 스킬 (Nadaunse Taste Skill)

> 나다운세 프론트엔드 코드 생성 시 **고품질 모바일 UI**를 보장하는 가드레일.
> AI가 만드는 뻔하고 밋밋한 디자인을 방지하고, 프로젝트 디자인 시스템을 강제합니다.

---

## 1. 프로젝트 컨텍스트

- **서비스**: 타로/사주 운세 모바일 웹 (nadaunse.com)
- **스택**: React 18 + TypeScript + Tailwind CSS v4 + Vite + Supabase
- **UI 라이브러리**: shadcn/ui (48개 컴포넌트)
- **폰트**: Pretendard Variable (한글 최적화 가변 폰트)
- **타겟**: 모바일 퍼스트 (360px~440px), iOS Safari 필수 대응
- **톤**: 밝고 따뜻한 + 친근한 + 신뢰감 (운세 서비스 특성)
- **절대 아님**: 다크/테크/SaaS/에이전시 감성

---

## 1.5. 디자인 톤 규칙 [CRITICAL — 최우선]

새 페이지나 컴포넌트를 만들 때 **반드시 기존 페이지의 톤을 먼저 참고**해야 합니다.

### 필수 참고 페이지
| 페이지 | 파일 | 참고 포인트 |
|--------|------|-----------|
| 홈 | `pages/HomeScreenNew.tsx` | 전체 톤, 카드 스타일, 섹션 구조 |
| 나다움 분석 | `components/NadaumAnalysisPage.tsx` | 카테고리 카드, 색상 토큰, 데이터 시각화 |
| 사주 상담 | `pages/SajuConsultPage.tsx` | 입력 플로우, 버튼 인터랙션 |

### 나다운세 디자인 톤
- **배경**: 흰색(`#ffffff`) 또는 연한 회색(`#f7f8f9`). 다크 배경 금지
- **카드**: 흰색 배경 + 연한 테두리(`#f8f8f8`) + 부드러운 그림자(`4px 4px 14px rgba(0,0,0,0.04)`)
- **라운딩**: 카드 `20px`, 버튼 `16px`, 뱃지 `20px`, 아이콘 박스 `14~16px`
- **분위기**: 밝고 가볍고 따뜻함. 캐릭터 일러스트 활용. 과도한 장식 애니메이션 금지
- **텍스트 톤**: 친근하고 부드러운 한국어. 영어 라벨/태그 금지

### 절대 금지 (AI 슬롭)
- 다크 히어로 섹션 (다크 그라디언트 배경 + 흰 텍스트)
- 별 반짝임, 글로우 오브, 네온 효과
- 영어 배지/라벨 ("AI Future Simulation", "Premium" 등)
- 과도한 motion 애니메이션 (별 12개 반짝이는 등)
- 테크/SaaS/에이전시 감성의 레이아웃

### 새 페이지 시작 전 체크
1. HomeScreenNew.tsx의 Design Tokens(`C` 객체) 확인
2. 기존 유사 페이지의 카드/섹션 스타일 확인
3. 새 페이지가 홈과 나란히 놓여도 이질감 없는지 확인

---

## 2. 레이아웃 아키텍처 [MANDATORY]

### 표준 페이지 구조
모든 페이지는 440px 중앙 정렬 모바일 컨테이너를 사용합니다.

```
[외부: bg-white min-h-screen w-full flex justify-center]
  [내부: w-full max-w-[440px] relative pb-[140px]]
    [상단 네비게이션: h-[52px] shrink-0 z-20]
    [60px 여백]
    [메인 콘텐츠: padding 12px 20px 40px 20px]
    [하단 고정 CTA: fixed bottom-0 max-w-[440px]]
```

### iOS 스크롤 바운스 방지 레이아웃 (권장)
스크롤이 있는 페이지에서는 `fixed inset-0` 패턴을 사용합니다:

```
[fixed inset-0 flex justify-center]
  [w-full max-w-[440px] h-full flex flex-col]
    [네비게이션: shrink-0]
    [콘텐츠: flex-1 overflow-auto]
    [하단 버튼: shrink-0]
```

### 하단 고정 CTA
```tsx
<div
  className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[440px] bg-white pointer-events-auto"
  style={{ boxShadow: '0px -8px 16px 0px rgba(255, 255, 255, 0.76)' }}
>
  <div style={{ padding: '12px 20px' }}>
    {/* 버튼 */}
  </div>
</div>
```

---

## 3. Tailwind CSS v4 스타일링 규칙 [CRITICAL]

### 절대 금지 — 폰트 관련 Tailwind 클래스
globals.css base typography가 충돌하므로 아래 클래스는 **사용 금지**:

```
금지: text-sm, text-lg, text-xl, text-[15px], text-[any size]
금지: font-bold, font-semibold, font-[500], font-[any weight]
금지: leading-5, leading-tight, leading-[20px], leading-[any value]
금지: tracking-tight, tracking-[any value]
```

### 반드시 inline style 사용
```tsx
// 타이포그래피 → 무조건 inline style
style={{ fontSize: '15px', fontWeight: 400, lineHeight: '20px', letterSpacing: '-0.45px' }}

// 색상 (HEX) → inline style (Tailwind v4 arbitrary HEX 불안정)
style={{ backgroundColor: '#41a09e', color: '#151515', borderColor: '#e7e7e7' }}
```

### Tailwind 사용 가능한 속성
```
OK: flex, flex-col, items-center, justify-center, justify-between
OK: w-full, max-w-[440px], min-h-screen, h-full, size-full
OK: relative, absolute, fixed, z-20
OK: gap-4, p-4, px-5, py-3, m-4 (토큰 기반 spacing)
OK: rounded-2xl, overflow-hidden
OK: cursor-pointer, transition-colors, transition-transform
OK: outline-none, bg-transparent, shrink-0
OK: active:bg-gray-100, group, group-active:scale-90
```

### Arbitrary Value 주의
```tsx
// ⚠️ 작동 불안정 → inline style 사용
className="bg-[#f0f8f8]"   → style={{ backgroundColor: '#f0f8f8' }}
className="px-[7px]"        → style={{ padding: '0 7px' }}
className="active:scale-[0.99]" → onMouseDown 핸들러로 대체
```

---

## 4. 디자인 토큰

### 색상 팔레트

| 용도 | 색상 | HEX |
|------|------|-----|
| 브랜드 Primary | 민트/틸 | `#41a09e` |
| 브랜드 강조 | 진한 틸 | `#368683` |
| 브랜드 밝은 | 연한 틸 | `#48b2af` |
| 텍스트 기본 | 진한 검정 | `#151515` |
| 텍스트 서브 | 중간 회색 | `#6d6d6d` |
| 텍스트 라벨 | 연한 회색 | `#848484` |
| 텍스트 비활성 | 밝은 회색 | `#b7b7b7` |
| 배경 기본 | 흰색 | `#ffffff` |
| 배경 비활성 | 연한 회색 | `#f8f8f8` |
| 배경 민트 | 연한 민트 | `#f0f8f8` |
| 배경 카드 | 구분 배경 | `#f9f9f9` |
| 보더 기본 | 입력 필드 | `#e7e7e7` |
| 보더 연한 | 구분선 | `#d4d4d4` |
| 카카오 | 노란색 | `#fee500` |

### 타이포그래피 스케일

모든 텍스트는 `Pretendard Variable, sans-serif` 기반 inline style:

| 용도 | size | weight | lineHeight | letterSpacing |
|------|------|--------|------------|---------------|
| 대제목 | 22px | 600 | 32.5px | -0.22px |
| 소제목 | 18px | 600 | - | -0.36px |
| 버튼 | 16px | 500 | 25px | -0.32px |
| 본문 | 15px | 400 | 20px | -0.45px |
| 라벨 | 12px | 400 | 16px | -0.24px |

---

## 5. 인터랙션 & 모션

### 버튼 Press 피드백 (Tailwind v4 대응)
Tailwind v4에서 `active:scale-[0.99]` 같은 arbitrary value가 불안정하므로, JS 이벤트로 구현:

```tsx
// CTA 버튼
style={{ transition: 'all 0.15s ease' }}
onMouseDown={(e) => {
  e.currentTarget.style.transform = 'scale(0.99)';
  e.currentTarget.style.backgroundColor = '#41A09E';
}}
onMouseUp={(e) => {
  e.currentTarget.style.transform = 'scale(1)';
  e.currentTarget.style.backgroundColor = '#48b2af';
}}
onTouchStart/onTouchEnd // 모바일 터치 동일 처리
onMouseLeave // 마우스 이탈 시 복원
```

### 아이콘 버튼 (Tailwind group 활용)
```tsx
<div className="group flex items-center justify-center cursor-pointer transition-colors duration-200 active:bg-gray-100"
     style={{ width: '44px', height: '44px', borderRadius: '12px' }}>
  <X className="transition-transform duration-200 group-active:scale-90"
     style={{ width: '24px', height: '24px', color: '#848484' }}
     strokeWidth={1.8} />
</div>
```

### 모션 성능 가드레일
- **GPU 안전**: `transform`, `opacity`만 애니메이션. `top`/`left`/`width`/`height` 애니메이션 금지
- **will-change**: 실제 애니메이션 대상에만 사용, 남발 금지
- **iOS Safari**: `overflow: hidden` + `border-radius` 조합 시 반드시 `transform-gpu` 추가
- **모멘텀 스크롤**: `overflow-y-auto` 영역에 `WebkitOverflowScrolling: 'touch'`

---

## 6. iOS Safari 필수 대응 [CRITICAL]

| 이슈 | 해결 |
|------|------|
| 스크롤 바운스 | `fixed inset-0` + `flex-1 overflow-auto` 패턴 |
| 둥근 모서리 깨짐 | `overflow-hidden` + `rounded-*` → `transform-gpu` 추가 |
| 100vh 오차 | `h-screen` 금지 → `min-h-[100dvh]` 사용 |
| 하단 CTA 첫 클릭 무반응 | `pointer-events-auto` 추가 |
| bfcache 결제 버튼 비활성화 | `pageshow` 이벤트 + `event.persisted` 리셋 |
| 하단 고정 요소 | `fixed bottom-0 left-1/2 -translate-x-1/2` + safe area 고려 |

---

## 7. 안티-AI-슬롭 규칙 (Anti-Generic Patterns) [CRITICAL]

AI 코드 생성 시 흔히 나오는 **뻔하고 밋밋한 패턴**을 방지합니다.
**핵심 원칙**: 새로 만든 페이지가 기존 홈 화면 옆에 놓였을 때 이질감이 없어야 합니다.

### 레이아웃
- **3-Column 카드 금지**: 모바일 서비스에서 3열 카드 그리드는 사용하지 않음. 세로 스택 또는 캐러셀 사용
- **과도한 카드 래핑 금지**: 모든 콘텐츠를 카드로 감싸지 말 것. `border-b`, spacing으로 구분
- **중앙 정렬 남발 금지**: 모든 텍스트를 center 정렬하지 말 것. 콘텐츠는 좌측 정렬 기본
- **다크 히어로 섹션 금지**: 다크 배경 + 흰 텍스트 히어로 영역은 나다운세 톤과 맞지 않음

### 색상 & 시각
- **순수 검정 금지**: `#000000` 대신 `#151515` (프로젝트 기본 텍스트 색상) 사용
- **다크 배경 금지**: 페이지/섹션 배경에 `#151515`, `#1a2332` 등 다크 색상 사용 금지. 흰색 또는 `#f7f8f9` 사용
- **네온/글로우 금지**: `box-shadow` 글로우 효과, radial-gradient 글로우 오브 금지
- **과도한 그라디언트 금지**: 그라디언트 텍스트, 무지개 그라디언트 금지. 단색 또는 미묘한 그라디언트만
- **보라/네온 계열 금지**: "AI 느낌" 보라색/파란색 글로우는 프로젝트 톤과 맞지 않음. 브랜드 민트(#41a09e) 사용

### 타이포그래피
- **Tailwind 폰트 클래스 금지** (섹션 3 참고)
- **과도한 대문자 금지**: 한글 서비스에서 불필요
- **기본 폰트 금지**: Inter, Roboto, Arial 등 생성 금지. 프로젝트는 Pretendard Variable 전용

### 콘텐츠
- **이모지 아이콘 금지**: UI에 이모지 사용 금지. SVG 아이콘 또는 Lucide 사용
- **영어 Lorem Ipsum 금지**: 한글 더미 텍스트 사용
- **외부 이미지 URL 금지**: CSP 제한으로 차단됨. `/public` 폴더에 저장 후 절대 경로 사용
- **Unsplash/Picsum 금지**: CSP에 허용되지 않음

### 인터랙션
- **커스텀 마우스 커서 금지**: 모바일 서비스에서 불필요
- **과도한 패럴랙스 금지**: 모바일 성능 저하. 간단한 fade-in 정도만
- **linear easing 금지**: `ease`, `cubic-bezier(0.32, 0.72, 0, 1)` 등 자연스러운 이징 사용
- **window scroll listener 금지**: IntersectionObserver 사용

---

## 8. 컴포넌트 품질 기준

### 필수 상태 구현
모든 인터랙티브 컴포넌트는 다음 상태를 구현해야 합니다:
- **로딩**: 스켈레톤 로더 (제네릭 스피너 지양)
- **빈 상태**: 안내 메시지 + 액션 유도
- **에러 상태**: 인라인 에러 메시지 (input 하단)
- **비활성화**: 색상 변경 + `cursor-not-allowed`
- **Press 피드백**: `scale(0.99)` 또는 `active:bg-gray-100`

### 터치 타겟
- **최소 44x44px**: 모든 터치 가능 요소
- **ArrowLeft**: 44x44px 터치 영역 (기존 컴포넌트 사용)
- **아이콘 버튼**: 44x44px wrapper + 24x24px 아이콘

### 입력 필드 표준
```
높이: 56px | 테두리: 1px solid #e7e7e7 | 반경: 16px | 패딩: 0 12px
텍스트: 15px / 400 / #151515 | 플레이스홀더: #b7b7b7
라벨: 12px / 400 / #848484 (input 상단)
에러: 12px / 400 / destructive color (input 하단)
```

### CTA 버튼 표준
```
높이: 56px | 반경: 16px | 너비: 100%
활성: bg #41a09e, 텍스트 #ffffff
비활성: bg #f8f8f8, 텍스트 #b7b7b7
Press: scale(0.99), bg #41A09E → #48b2af
```

---

## 9. shadcn/ui 커스터마이징

shadcn/ui 컴포넌트는 **기본 스타일 그대로 사용 금지**. 프로젝트 디자인 토큰에 맞게 커스터마이징:

- **radius**: 프로젝트 기본 `--radius: 0.625rem` (globals.css)
- **색상**: `--primary`, `--secondary`, `--muted` 등 CSS 변수 활용
- **크기**: 모바일 터치 타겟 44px 이상 보장
- **폰트**: Tailwind 폰트 클래스 대신 inline style 또는 CSS 변수

---

## 10. 이미지 처리 [CRITICAL]

### CSP 허용 도메인
```
'self' | data: | blob: | https://*.supabase.co | https://*.kakaocdn.net
```

### 규칙
- **외부 이미지 URL 사용 금지** (Unsplash, Picsum, postimg 등 전부 차단)
- 이미지는 `/public` 폴더에 저장 → 절대 경로 사용 (`/image.jpg`)
- 또는 `import` 구문 사용 (`import img from '../assets/image.png'`)
- Supabase Storage, 카카오 CDN은 허용

---

## 11. 프리플라이트 체크리스트

코드 출력 전 반드시 확인:

### 스타일링
- [ ] `text-*`, `font-*`, `leading-*`, `tracking-*` Tailwind 클래스 없음
- [ ] 모든 타이포그래피가 inline style로 작성됨
- [ ] HEX 색상이 inline style로 작성됨 (arbitrary value 미사용)
- [ ] `#000000` 대신 `#151515` 사용

### 레이아웃
- [ ] 외부 컨테이너: `bg-white min-h-screen w-full flex justify-center`
- [ ] 내부 컨테이너: `w-full max-w-[440px]`
- [ ] 하단 CTA: `fixed bottom-0 left-1/2 -translate-x-1/2 max-w-[440px]`
- [ ] 하단 CTA에 `pointer-events-auto` 추가

### iOS Safari
- [ ] `overflow-hidden` + `rounded-*` 조합에 `transform-gpu` 추가
- [ ] `h-screen` 대신 `min-h-[100dvh]` 사용
- [ ] 스크롤 영역: `fixed inset-0` 패턴 또는 `flex-1 overflow-auto`

### 인터랙션
- [ ] 터치 타겟 최소 44x44px
- [ ] 버튼 Press 피드백 (scale 또는 bg 변경)
- [ ] 로딩/빈 상태/에러 상태 구현
- [ ] `cursor-pointer` on 모든 클릭 가능 요소

### 보안
- [ ] 외부 이미지 URL 미사용 (CSP)
- [ ] 하드코딩된 API 키, 시크릿 없음
- [ ] `DEV` 플래그로 개발 전용 UI 분리

### 품질
- [ ] 이모지 아이콘 미사용
- [ ] 과도한 그라디언트/글로우/패럴랙스 없음
- [ ] 자연스러운 이징 사용 (linear 금지)
- [ ] 애니메이션은 `transform`/`opacity`만 사용
