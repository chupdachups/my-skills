---
name: analyze-changes
description: Git 변경사항을 수집하고 파일 통계, 영향 범위, 위험 수준을 분석합니다.
---

# analyze-changes

코드 변경사항을 분석하는 skill입니다.

## 설명

이 skill은 코드 리뷰 파이프라인의 두 번째 단계입니다. Git 변경사항을 수집하고, 변경된 파일들의 통계와 영향 범위를 분석합니다. 분석 스크립트를 활용하여 체계적인 데이터를 수집합니다.

## 지시사항

1. `.code-review-context.json` 파일을 읽어 리뷰 설정을 확인하세요.

2. `scripts/analyze-diff.sh` 스크립트를 실행하여 변경사항을 수집하세요:
   - 브랜치 비교의 경우: 두 브랜치 간 diff 분석
   - 파일 지정의 경우: 해당 파일들의 현재 상태 분석

3. 다음 정보를 수집하여 `.code-review-analysis.json`에 저장하세요:
   ```json
   {
     "summary": {
       "totalFiles": 10,
       "additions": 150,
       "deletions": 30,
       "totalChanges": 180
     },
     "filesByType": {
       ".ts": 5,
       ".tsx": 3,
       ".css": 2
     },
     "changedFiles": [
       {
         "path": "src/components/Button.tsx",
         "additions": 25,
         "deletions": 5,
         "changeType": "modified"
       }
     ],
     "impactAreas": ["components", "styles", "utils"],
     "riskLevel": "low|medium|high",
     "analyzedAt": "ISO날짜"
   }
   ```

4. 변경사항 요약을 사용자에게 표시하세요:
   - 총 변경 파일 수
   - 추가/삭제 라인 수
   - 주요 영향 영역
   - 예상 위험 수준

5. "변경사항 분석이 완료되었습니다. 코딩 표준을 검사합니다." 라고 알리세요.

6. **반드시 다음 skill을 호출하세요: `/check-standards`**

## 예시

```
[/analyze-changes 호출됨]
Gemini: 변경사항을 분석하고 있습니다...

📊 변경사항 요약:
- 총 10개 파일 변경
- +150 / -30 라인
- 영향 영역: components, utils
- 위험 수준: Medium

변경사항 분석이 완료되었습니다. 코딩 표준을 검사합니다.
[/check-standards 호출]
```
