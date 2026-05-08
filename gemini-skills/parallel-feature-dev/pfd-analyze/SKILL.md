---
name: pfd-analyze
description: 병렬 기능 개발 완료 후 사용자가 지정한 분석 스킬을 순차적으로 1회 실행합니다. 브랜치 목록과 worktree 경로를 컨텍스트로 전달합니다.
---

# 병렬 기능 개발 결과 분석 (pfd-analyze)

개발 완료된 브랜치 및 worktree 정보를 컨텍스트로 구성한 뒤, 사용자가 지정한 분석 스킬을 순차적으로 단 1회 실행합니다.

## 지시사항

### 1단계: 설정 읽기

`{projectRoot}/.pfd-config.json`을 읽어 다음 값을 파악하세요:
- `analyzeSkill`, `analyzeArgs`
- `branches`, `worktreePaths`
- `planFile`, `baseBranch`, `bareRepoPath`, `devSkill`

`analyzeSkill`이 비어 있으면 사용자에게 분석 스킬 이름과 매개변수를 질문하세요.

### 2단계: 브랜치 현황 수집

```bash
git -C {bareRepoPath} log --oneline -1 {branchName}
```

### 3단계: 분석 스킬 실행 전 컨텍스트 출력

```
=== 분석 스킬 실행 ===
분석 스킬 : {analyzeSkill}
매개변수  : {analyzeArgs} (없으면 표시 생략)
PLAN 파일 : {planFile}
분석 대상:
  [1] {branches[0]}  →  {worktreePaths[0]}  —  커밋: {commitHash1}
  [2] {branches[1]}  →  {worktreePaths[1]}  —  커밋: {commitHash2}
  ...
=====================
```

### 4단계: 분석 스킬 실행

현재 대화에 아래 컨텍스트를 출력한 후 분석 스킬을 호출하세요:

```
[pfd 분석 컨텍스트]
- 메인 저장소  : {bareRepoPath}  [{baseBranch}]
- 개발 스킬   : {devSkill}
- PLAN 파일   : {planFile}
- 개발 완료 브랜치 및 Worktree:
  {branches[0]}  →  {worktreePaths[0]}
  {branches[1]}  →  {worktreePaths[1]}
  ...
```

`{analyzeSkill}` 스킬을 호출하세요. `analyzeArgs`가 있으면 인자로 함께 전달하세요.

### 5단계: 완료 후 안내

```
✅ 분석이 완료되었습니다.

선택한 브랜치로 PR 생성:
  git -C {bareRepoPath} checkout {선택한 브랜치}
  gh pr create --base {baseBranch}

Worktree 정리:
  git -C {bareRepoPath} worktree remove {worktreePath}
  git -C {bareRepoPath} worktree prune
```

## Skill Chaining

이 스킬은 파이프라인의 최종 단계입니다.
