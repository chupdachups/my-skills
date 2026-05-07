# .pfd-config.json 스키마 참조

병렬 기능 개발 파이프라인 전반에서 사용하는 설정 파일 구조입니다.

## 스키마

```json
{
  "devSkill": "string",       // 실행할 개발 스킬 이름 (예: dev-back-execute-code)
  "planFile": "string",       // PLAN 파일 경로 (예: docs/PLAN-FILE.md)
  "runs": "number",           // 병렬 실행 횟수 (1~10)
  "branchPrefix": "string",   // 브랜치 접두사 (예: feature/pfd)
  "baseBranch": "string",     // 기준 브랜치 (예: main, develop)
  "branches": "string[]",     // 생성된 브랜치 목록 (pfd-orchestrate에서 채워짐)
  "status": "string",         // initialized | branched | running | completed
  "createdAt": "string"       // ISO 8601 날짜
}
```

## 상태 전이

```
initialized  →  branched  →  running  →  completed
   (pfd-init)  (pfd-orchestrate)  (pfd-worker)  (pfd-summary)
```

## 브랜치 명명 규칙

- 패턴: `{branchPrefix}-run-{N}`
- 예시: `feature/pfd-run-1`, `feature/pfd-run-2`, `feature/pfd-run-3`
