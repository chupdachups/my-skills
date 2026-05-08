---
name: pfd-analyze
description: 병렬 기능 개발 완료 후 사용자가 지정한 분석 스킬을 순차적으로 1회 실행합니다. 브랜치 목록과 worktree 경로를 컨텍스트로 전달합니다.
user-invocable: false
allowed-tools: Read, Write, Skill, Bash(git -C *) Bash(git log *)
---

# 병렬 기능 개발 결과 분석 (pfd-analyze)

개발 완료된 브랜치 및 worktree 정보를 컨텍스트로 구성한 뒤, 사용자가 지정한 분석 스킬을 순차적으로 단 1회 실행합니다.

## 지시사항

### 1. 설정 읽기

`{projectRoot}/.pfd-config.json`을 읽어 다음 값을 파악하세요:
- `analyzeSkill`: 실행할 분석 스킬 이름
- `analyzeArgs`: 분석 스킬에 전달할 매개변수 (빈 문자열이면 없음)
- `branches`: 개발 완료된 브랜치 목록
- `worktreePaths`: 각 브랜치의 worktree 절대 경로
- `planFile`, `baseBranch`, `bareRepoPath`, `devSkill`

`analyzeSkill`이 비어 있으면 사용자에게 분석 스킬 이름과 매개변수를 질문하세요.

### 2. 브랜치 현황 수집

각 브랜치의 최신 커밋을 확인하세요:

```bash
git -C {bareRepoPath} log --oneline -1 {branchName}
```

### 3. 분석 스킬 실행 전 컨텍스트 출력

사용자에게 다음 내용을 출력하세요:

```
=== 분석 스킬 실행 ===
분석 스킬 : {analyzeSkill}
매개변수  : {analyzeArgs} (없으면 표시 생략)
PLAN 파일 : {planFile}
분석 대상:
  [1] {branches[0]}  —  {worktreePaths[0]}  —  커밋: {commitHash1}
  [2] {branches[1]}  —  {worktreePaths[1]}  —  커밋: {commitHash2}
  ...
=====================
```

### 4. 분석 스킬 실행

분석 스킬 실행 전 현재 대화에 아래 컨텍스트를 출력하여 분석 스킬이 참조할 수 있도록 하세요:

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

Skill 도구를 사용하여 분석 스킬을 실행하세요:
- skill: `{analyzeSkill}`
- args: `{analyzeArgs}` (비어 있으면 빈 문자열)

### 5. 완료 후 안내

```
분석이 완료되었습니다.

선택한 브랜치로 PR 생성:
  git -C {bareRepoPath} checkout {선택한 브랜치}
  gh pr create --base {baseBranch}

Worktree 정리:
  git -C {bareRepoPath} worktree remove {worktreePath}
  git -C {bareRepoPath} worktree prune
```
