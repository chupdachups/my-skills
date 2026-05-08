---
name: pfd-init
description: 설계서(PLAN 파일) 기반 병렬 기능 개발 시작. projectRoot와 projectBare를 기반으로 git worktree를 N개 생성하여 독립 공간에서 병렬 개발합니다.
user-invocable: true
allowed-tools: Read, Write, Bash(git -C *) Bash(git rev-parse *) Bash(ls *)
argument-hint: "[project-root] [project-bare] [dev-skill] [plan-file] [runs]"
---

# 병렬 기능 개발 초기화 (pfd-init)

git worktree 기반으로 독립된 개발 공간을 구성하고 병렬 기능 개발 파이프라인을 시작합니다.

## 개요

자세한 설정 스키마는 [references/config-schema.md](references/config-schema.md)를 참조하세요.

## 지시사항

### 1. 인자 파싱

`$ARGUMENTS`가 제공된 경우 아래 순서로 파싱하세요:
- 첫 번째 토큰 → `projectRoot` (예: `/workspace`)
- 두 번째 토큰 → `projectBare` (예: `my-app`)
- 세 번째 토큰 → 개발 스킬 이름 (예: `dev-back-execute-code`)
- 네 번째 토큰 → PLAN 파일 경로 (예: `PLAN-FILE.md`)
- 다섯 번째 토큰 → 병렬 실행 횟수 (숫자, 예: `3`)

### 2. 누락 정보 수집

파싱되지 않은 항목에 대해 사용자에게 질문하세요:

| 항목 | 질문 | 예시 |
|------|------|------|
| projectRoot | "프로젝트 루트 디렉토리 경로를 입력하세요:" | `/workspace` |
| projectBare | "메인 저장소 디렉토리 이름을 입력하세요:" | `my-app` |
| 개발 스킬 이름 | "실행할 개발 스킬 이름을 입력하세요:" | `dev-back-execute-code` |
| PLAN 파일 경로 | "사용할 PLAN 파일 경로를 입력하세요 (저장소 루트 기준 상대 경로):" | `docs/PLAN-FILE.md` |
| 병렬 실행 횟수 | "병렬로 실행할 횟수를 입력하세요 (1~10):" | `3` |
| 브랜치 접두사 | "생성할 브랜치 접두사를 입력하세요 (기본값: feature/pfd):" | `feature/pfd` |
| 분석 스킬 이름 | "개발 완료 후 실행할 분석 스킬 이름을 입력하세요 (없으면 Enter로 스킵):" | `code-review` |
| 분석 스킬 매개변수 | "분석 스킬에 전달할 매개변수를 입력하세요 (없으면 Enter로 스킵):" | `--strict` |

### 3. 유효성 검사

아래 항목을 순서대로 확인하세요:

**디렉토리 확인:**
```bash
ls {projectRoot}
ls {projectRoot}/{projectBare}
```

**git 저장소 확인:**
```bash
git -C {projectRoot}/{projectBare} rev-parse --git-dir
```

**기준 브랜치 확인:**
```bash
git -C {projectRoot}/{projectBare} rev-parse --abbrev-ref HEAD
```
→ 결과를 `baseBranch`로 저장

**PLAN 파일 확인:**
`{projectRoot}/{projectBare}/{planFile}` 경로로 Read 도구를 사용해 파일 존재를 확인하세요.

**병렬 실행 횟수:** 1 이상 10 이하 확인

오류가 있으면 사용자에게 재입력을 요청하세요.

### 4. Worktree 경로 목록 생성

`projectBare`의 이름 부분에서 worktree 경로를 결정하세요:
- 패턴: `{projectRoot}/{projectBare}-worktree-run-{i}`
- 예시 (`projectRoot=/workspace`, `projectBare=my-app`, `runs=3`):
  - `/workspace/my-app-worktree-run-1`
  - `/workspace/my-app-worktree-run-2`
  - `/workspace/my-app-worktree-run-3`

### 5. 설정 파일 저장

`{projectRoot}/.pfd-config.json`을 생성하세요:

```json
{
  "projectRoot": "/workspace",
  "projectBare": "my-app",
  "bareRepoPath": "/workspace/my-app",
  "devSkill": "dev-back-execute-code",
  "planFile": "docs/PLAN-FILE.md",
  "runs": 3,
  "branchPrefix": "feature/pfd",
  "baseBranch": "main",
  "branches": [],
  "worktreePaths": [],
  "analyzeSkill": "code-review",
  "analyzeArgs": "--strict",
  "analyzeResults": [],
  "status": "initialized",
  "createdAt": "ISO8601 날짜"
}
```

`analyzeSkill`, `analyzeArgs`가 입력되지 않은 경우 빈 문자열(`""`)로 저장하세요.

### 6. 실행 요약 출력

```
=== 병렬 기능 개발 설정 ===
• 프로젝트 루트 : {projectRoot}
• 메인 저장소  : {projectRoot}/{projectBare}  [{baseBranch}]
• 개발 스킬    : {devSkill}
• PLAN 파일    : {planFile}
• 병렬 실행    : {runs}회
• 생성 Worktree:
    {projectRoot}/{projectBare}-worktree-run-1  →  {branchPrefix}-run-1
    {projectRoot}/{projectBare}-worktree-run-2  →  {branchPrefix}-run-2
    ...
• 분석 스킬    : {analyzeSkill} (미입력 시 "분석 스킵")
• 분석 매개변수 : {analyzeArgs}
===========================
```

### 7. 다음 skill 호출

반드시 `/pfd-orchestrate`를 호출하세요.
