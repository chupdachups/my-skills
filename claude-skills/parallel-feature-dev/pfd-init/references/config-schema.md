# .pfd-config.json 스키마 참조

`{projectRoot}/.pfd-config.json` 위치에 저장됩니다.

## 스키마

```json
{
  "projectRoot": "string",      // 프로젝트 루트 절대 경로 (예: /workspace)
  "projectBare": "string",      // 메인 저장소 디렉토리 이름 (예: my-app)
  "bareRepoPath": "string",     // 메인 저장소 절대 경로 (projectRoot + projectBare)
  "devSkill": "string",         // 실행할 개발 스킬 이름
  "planFile": "string",         // PLAN 파일 경로 (저장소 루트 기준 상대 경로)
  "runs": "number",             // 병렬 실행 횟수 (1~10)
  "branchPrefix": "string",     // 브랜치 접두사 (예: feature/pfd)
  "baseBranch": "string",       // 기준 브랜치 (예: main)
  "branches": "string[]",       // 생성된 브랜치 목록 (pfd-orchestrate에서 채워짐)
  "worktreePaths": "string[]",  // 생성된 worktree 절대 경로 목록
  "analyzeSkill": "string",     // 분석 스킬 이름 (빈 문자열이면 분석 스킵)
  "analyzeArgs": "string",      // 분석 스킬 매개변수 (빈 문자열이면 없음)
  "analyzeResults": "object[]", // 분석 결과 (pfd-analyze에서 채워짐)
  "status": "string",           // initialized | running | completed | analyzed
  "createdAt": "string"         // ISO 8601 날짜
}
```

## 디렉토리 구조 예시

```
{projectRoot}/                          ← 프로젝트 루트
├── .pfd-config.json                    ← 설정 파일 (pfd-init이 생성)
├── {projectBare}/                      ← 메인 저장소 (branch: baseBranch)
│   ├── .git/
│   ├── src/
│   └── {planFile}
├── {projectBare}-worktree-run-1/       ← worktree 1 (branch: {branchPrefix}-run-1)
│   ├── src/
│   └── {planFile}
├── {projectBare}-worktree-run-2/       ← worktree 2 (branch: {branchPrefix}-run-2)
└── {projectBare}-worktree-run-3/       ← worktree 3 (branch: {branchPrefix}-run-3)
```

## 상태 전이

```
initialized → running → completed → analyzed
 (pfd-init)  (pfd-orchestrate+worker)  (pfd-summary)  (pfd-analyze)
```

## Worktree 명명 규칙

- worktree 경로: `{projectRoot}/{projectBare}-worktree-run-{N}`
- 브랜치명: `{branchPrefix}-run-{N}`
