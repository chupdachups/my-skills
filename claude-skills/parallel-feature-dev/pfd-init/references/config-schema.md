# .pfd-config.json 스키마 참조

병렬 기능 개발 파이프라인 전반에서 사용하는 설정 파일 구조입니다.

## 스키마

```json
{
  "devSkill": "string",         // 실행할 개발 스킬 이름 (예: dev-back-execute-code)
  "planFile": "string",         // PLAN 파일 경로 (예: docs/PLAN-FILE.md)
  "runs": "number",             // 병렬 실행 횟수 (1~10)
  "branchPrefix": "string",     // 브랜치 접두사 (예: feature/pfd)
  "baseBranch": "string",       // 기준 브랜치 (예: main, develop)
  "branches": "string[]",       // 생성된 브랜치 목록 (pfd-orchestrate에서 채워짐)
  "analyzeSkill": "string",     // 실행할 분석 스킬 이름 (빈 문자열이면 분석 스킵)
  "analyzeResults": "object[]", // 브랜치별 분석 결과 (pfd-analyze에서 채워짐)
  "status": "string",           // initialized | branched | running | completed | analyzed
  "createdAt": "string"         // ISO 8601 날짜
}
```

## analyzeResults 항목 스키마

```json
{
  "branch": "string",         // 브랜치명
  "runIndex": "number",       // 실행 번호
  "score": "number",          // 0~100 점수
  "summary": "string",        // 한 줄 요약
  "strengths": "string[]",    // 강점 목록
  "weaknesses": "string[]",   // 약점 목록
  "planCoverage": "string",   // PLAN 충족도 설명
  "recommendation": "string"  // 선택 여부 의견
}
```

## 상태 전이

```
initialized  →  branched  →  running  →  completed  →  analyzed
   (pfd-init)  (pfd-orchestrate)  (pfd-worker)  (pfd-summary)  (pfd-analyze)
```

## 브랜치 명명 규칙

- 패턴: `{branchPrefix}-run-{N}`
- 예시: `feature/pfd-run-1`, `feature/pfd-run-2`, `feature/pfd-run-3`
