---
name: pfd-orchestrate
description: 병렬 기능 개발 오케스트레이터. pfd-init 이후 호출되며 N개의 브랜치를 생성하고 병렬 에이전트를 실행합니다.
user-invocable: false
allowed-tools: Read, Write, Agent, Bash(git checkout *) Bash(git branch *) Bash(git push *)
---

# 병렬 기능 개발 오케스트레이터 (pfd-orchestrate)

`.pfd-config.json`을 읽어 N개의 브랜치를 생성하고, 각 브랜치에서 개발 스킬을 병렬로 실행합니다.

## 지시사항

### 1. 설정 읽기

`.pfd-config.json` 파일을 읽어 다음 값을 파악하세요:
- `devSkill`: 실행할 개발 스킬 이름
- `planFile`: PLAN 파일 경로
- `runs`: 병렬 실행 횟수
- `branchPrefix`: 브랜치 접두사
- `baseBranch`: 기준 브랜치

### 2. 브랜치 목록 생성 및 설정 업데이트

`setup-branches.sh` 스크립트를 참조하여 각 실행번호(1~N)에 대한 브랜치 이름 목록을 생성하세요:

```
branches = ["{branchPrefix}-run-1", "{branchPrefix}-run-2", ..., "{branchPrefix}-run-{N}"]
```

`.pfd-config.json`의 `branches` 필드를 생성된 목록으로 업데이트하고 `status`를 `branched`로 변경하세요.

### 3. 사용자에게 실행 계획 출력

```
=== 병렬 실행 시작 ===
총 {N}개 에이전트를 병렬로 실행합니다:
  [1] 브랜치: {branchPrefix}-run-1
  [2] 브랜치: {branchPrefix}-run-2
  ...
  [N] 브랜치: {branchPrefix}-run-N

각 에이전트는 독립된 worktree에서 실행됩니다.
======================
```

### 4. 병렬 에이전트 실행 (핵심)

**반드시 단일 메시지에서 N개의 Agent 도구 호출을 동시에 실행하세요 (병렬 실행).**

각 에이전트에 전달할 프롬프트 템플릿:

```
당신은 독립된 worktree에서 실행되는 기능 개발 에이전트입니다.

## 작업 정보
- 브랜치명: {branchPrefix}-run-{i}
- 기준 브랜치: {baseBranch}
- 개발 스킬: /{devSkill}
- PLAN 파일: {planFile}
- 실행 번호: {i} / {N}

## 수행 절차
1. `/pfd-worker` 스킬을 호출하세요.
   - 인자: "{branchPrefix}-run-{i} {planFile} {devSkill} {baseBranch}"
```

각 Agent 호출에 `isolation: "worktree"` 옵션을 적용하여 독립된 환경에서 실행하세요.

예시 (3회 병렬 실행):
- Agent 1: 브랜치 `{branchPrefix}-run-1`, PLAN 파일 실행
- Agent 2: 브랜치 `{branchPrefix}-run-2`, PLAN 파일 실행  
- Agent 3: 브랜치 `{branchPrefix}-run-3`, PLAN 파일 실행

### 5. 에이전트 완료 대기

모든 병렬 에이전트가 완료될 때까지 기다리세요.
각 에이전트의 성공/실패 결과를 수집하세요.

### 6. 설정 상태 업데이트

`.pfd-config.json`의 `status`를 `completed`로 업데이트하세요.

### 7. 다음 skill 호출

반드시 `/pfd-summary`를 호출하세요.
