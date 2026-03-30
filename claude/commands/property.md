# 주택 청약 분석 에이전트

## 사용자 프로필

```
이름: 정한결
생년월일: 1991.12.25
거주지: 서울특별시
세대구분: 세대주, 단독세대 (1인가구, 단독세입주)
주택소유: 무주택자
청약통장: 없음
혼인: 미혼 (혼인신고 안 함)
연소득: 62,420,088원 (월 ~5,201,674원)
근무처: 주식회사 스타지오소프트
부동산자산: 생활형 숙박시설 3억 700만원 (주택이 아님 → 무주택 유지)
주식자산: ~1억 3,000만원
차량가액: 500만원
청약 관심지역: 서울, 경기
```

## 자격 요약

| 청약유형 | 자격여부 | 비고 |
|---------|---------|------|
| 일반공급 (1순위) | ❌ | 청약통장 없음 |
| 일반공급 (2순위) | ❌ | 청약통장 없음 |
| 특별공급 (신혼부부) | ❌ | 혼인신고 안 함 |
| 특별공급 (생애최초) | ⚠️ | 불법행위재공급 한정 (청약통장 불필요), 일반 생애최초는 통장 필요. 소득기준 충족 |
| 무순위 (사후) | ✅ | 통장 불필요, 무주택세대구성원이면 OK |
| 불법행위 재공급 | ✅ | 통장 불필요 |
| 임의공급 | ✅ | 사업주체 직접 문의 필요 |

## 소득/자산 기준 참고

- 도시근로자 월평균소득 (1인가구 기준 약 348만원)
  - 130%: ~453만원 → 본인 520만 → 초과
  - 140%: ~487만원 → 본인 520만 → 초과
  - 160%: ~557만원 → 본인 520만 → **충족**
- 부동산가액: 3억 700만원 < 3억 3,100만원 → **충족**
- 자동차가액: 500만원 < 3,708만원 → **충족**

## 실행 지시사항

playwriter MCP 도구를 사용하여 청약홈(applyhome.co.kr)에서 서울/경기 지역 무순위·불법행위재공급·임의공급 목록을 실시간 조회하고, 위 사용자 프로필 기반으로 청약 가능 여부를 분석하라.

### Step 1: 청약홈 잔여세대 조회

playwriter로 `https://www.applyhome.co.kr/ai/aia/selectAPTRemndrLttotPblancListView.do` 접속 후:

1. 서울 지역 조회 → 테이블에서 데이터 추출
2. 경기 지역 조회 → 테이블에서 데이터 추출

테이블 행의 `data-pbno`, `data-hmno` 속성에서 상세조회용 ID를 추출할 수 있다.

```js
// 조회 코드 예시
await state.page.locator('#cate02').selectOption('서울');
await state.page.locator('role=button[name="조회"]').click();
await waitForPageLoad({ page: state.page, timeout: 5000 });
const rows = await state.page.evaluate(() => {
  const rows = document.querySelectorAll('table tr[data-pbno]');
  return Array.from(rows).map(row => {
    const cells = row.querySelectorAll('td');
    return {
      id: row.getAttribute('data-pbno'),
      region: cells[0]?.textContent?.trim(),
      type: cells[1]?.textContent?.trim(),
      name: cells[2]?.textContent?.trim(),
      company: cells[3]?.textContent?.trim(),
      date: cells[4]?.textContent?.trim(),
      period: cells[5]?.textContent?.trim(),
      announce: cells[6]?.textContent?.trim()
    };
  });
});
```

### Step 2: 청약 가능 필터링

오늘 날짜 기준으로:
- 청약접수 마감일이 오늘 이후인 것만 필터
- 유형: 무순위(사후), 불법행위재공급, 임의공급만 해당 (청약통장 불필요)

### Step 3: 상세 정보 조회

각 후보에 대해 POST 요청으로 상세정보 조회:

```js
const detail = await state.page.evaluate(async (id) => {
  const resp = await fetch('/ai/aia/selectAPTRemndrLttotPblancDetailView.do', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `houseManageNo=${id}&pblancNo=${id}&gvPgmId=AIA03M01`,
    credentials: 'same-origin'
  });
  const html = await resp.text();
  const p = new DOMParser();
  const doc = p.parseFromString(html, 'text/html');
  return doc.body.innerText.replace(/\s+/g, ' ');
}, id);
```

### Step 4: 분석 결과 출력

각 후보에 대해 다음 표 형식으로 출력:

```
## 청약 가능 목록 (YYYY-MM-DD 기준)

| # | 단지명 | 지역 | 구분 | 세대수 | 전용면적 | 분양가 | 청약일 | 당첨발표 | 입주예정 | 자격 | 비고 |
```

### Step 5: 중복 체크

이미 넣은 청약이 있는지 사용자에게 확인하고, 당첨자발표일 중복 여부를 체크:
- 같은 당첨자발표일에 APT/불법행위재공급/규제지역무순위는 1인 1건
- 비규제 무순위는 이 제한에서 제외될 수 있음 (공고문 확인 필요)

### 주의사항

- 생활형 숙박시설은 주택이 아니므로 무주택 유지
- 무순위 당첨 후 계약하면 분양권 = 주택 소유 → 무주택 자격 상실
- 서울 거주자가 경기 무순위 넣을 때 "해당 지역 거주" 요건 확인 필요 (수도권 전체 허용하는 곳도 있고, 해당 시/도만 허용하는 곳도 있음)
- 임의공급은 청약홈이 아닌 사업주체 직접 문의/신청일 수 있음
