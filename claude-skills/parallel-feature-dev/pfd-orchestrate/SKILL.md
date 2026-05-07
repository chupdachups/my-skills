---
name: pfd-orchestrate
description: 병렬 기능 개발 오케스트레이터. pfd-init 이후 호출되며 N개의 브랜치를 생성하고 병렬 에이전트를 실행합니다.
user-invocable: false
allowed-tools: Read, Write, Agent, Bash(git branch *) Bash(git push *) Bash(git log *)
---

# 병렬 기능 개발 오케스트레이터 (pfd-orchestrate)

`.pfd-config.json`을 읽어 정확히 N개의 에이전트를 병렬로 실행합니다.
각 에이전트는 독립된 worktree에서 브랜치 생성, 개발 스킬 실행, commit/push를 자급자족으로 완수합니다.

## 지시사항

### 1. 설정 읽기

`.pfd-config.json` 파일을 읽어 다음 값을 파악하세요:
- `devSkill`: 실행할 개발 스킬 이름
- `planFile`: PLAN 파일 경로
- `runs`: 병렬 실행 횟수 (이 숫자만큼 반드시 Agent를 생성해야 합니다)
- `branchPrefix`: 브랜치 접두사
- `baseBranch`: 기준 브랜치

### 2. 브랜치 목록 확정 및 설정 업데이트

실행 번호 1부터 `runs`까지 브랜치 목록을 생성하고 `.pfd-config.json`을 업데이트하세요:

```json
{
  "branches": ["{branchPrefix}-run-1", "{branchPrefix}-run-2", ..., "{branchPrefix}-run-{runs}"],
  "status": "running"
}
```

### 3. 실행 계획 출력

```
=== 병렬 실행 시작 ===
총 {runs}개 에이전트를 병렬로 실행합니다:
  [1] 브랜치: {branchPrefix}-run-1
  [2] 브랜치: {branchPrefix}-run-2
  ...
  [{runs}] 브랜치: {branchPrefix}-run-{runs}
======================
```

### 4. 병렬 에이전트 실행 ★ 핵심 ★

**아래 규칙을 반드시 지키세요:**
- 단일 메시지에서 Agent 도구를 **정확히 `{runs}`번** 호출하세요.
- `runs`가 3이면 Agent를 3번, 5이면 5번 호출합니다. 절대 누락하지 마세요.
- 각 에이전트 프롬프트는 **완전 자급자족**으로 작성합니다 (다른 스킬을 호출하지 않음).
- 모든 Agent 호출에 `isolation: "worktree"` 옵션을 적용하세요.

**각 에이전트(i = 1부터 runs까지)에 전달할 프롬프트:**

---
당신은 기능 개발 에이전트 {i}/{runs}입니다.
아래 절차를 **순서대로 빠짐없이** 완수해야 합니다. 중간에 멈추지 마세요.

## 작업 정보
- 목표 브랜치명: {branchPrefix}-run-{i}
- 기준 브랜치: {baseBranch}
- 개발 스킬: {devSkill}
- PLAN 파일: {planFile}

## 절차

### STEP 1: 현재 상태 확인
Bash 도구로 실행하세요:
```
git status
git rev-parse --abbrev-ref HEAD
```

### STEP 2: 목표 브랜치 생성 및 체크아웃
Bash 도구로 실행하세요:
```
git checkout -b {branchPrefix}-run-{i}
```
이미 존재하면: `git checkout {branchPrefix}-run-{i}`
실행 후 현재 브랜치가 `{branchPrefix}-run-{i}`인지 반드시 확인하세요.

### STEP 3: PLAN 파일 읽기
Read 도구로 `{planFile}` 파일 전체를 읽으세요.
파일이 없으면 현재 디렉토리의 파일 목록을 확인하여 올바른 경로를 찾으세요.

### STEP 4: 개발 스킬 실행
Skill 도구를 사용하여 다음 스킬을 실행하세요:
- skill: "{devSkill}"
- args: "{planFile}"
스킬이 완전히 완료될 때까지 기다리세요. 스킬 내 모든 파일 생성/수정 작업이 끝난 후 다음 단계로 넘어가세요.

### STEP 5: 변경사항 확인
Bash 도구로 실행하세요:
```
git status
git diff --stat
```
변경된 파일이 없으면 "변경사항 없음"을 출력하고 STEP 6으로 넘어가세요.

### STEP 6: Commit
Bash 도구로 실행하세요:
```
git add -A
git commit -m "feat: implement from {planFile} [pfd run-{i}]

- Dev skill: {devSkill}
- Plan file: {planFile}
- Branch: {branchPrefix}-run-{i}

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

### STEP 7: Push
Bash 도구로 실행하세요:
```
git push -u origin {branchPrefix}-run-{i}
```
push 실패 시 에러 내용을 기록하고 종료하세요. force push는 하지 마세요.

### STEP 8: 완료 보고
다음 JSON을 반드시 출력하세요:
```json
{
  "agentIndex": {i},
  "branch": "{branchPrefix}-run-{i}",
  "status": "success",
  "commitHash": "<git rev-parse --short HEAD 결과>"
}
```
실패 시 status를 "failed"로, 실패 이유를 "reason" 필드로 추가하세요.
---

### 5. 완료 확인 및 누락 처리

모든 에이전트 완료 후 각 에이전트의 결과 JSON을 수집하세요.

**누락된 에이전트가 있는 경우** (runs와 실제 완료 수가 다른 경우):
누락된 번호의 에이전트를 순차적으로 재실행하세요. 위 STEP 1~8 절차를 직접 수행하거나 단독 Agent로 실행하세요.

**완료 후 git 확인:**
```bash
git branch -a | grep "{branchPrefix}"
git log --oneline --decorate -1 {branchPrefix}-run-1
```

### 6. 설정 업데이트

`.pfd-config.json`의 `status`를 `completed`로 업데이트하세요.

### 7. 다음 skill 호출

반드시 `/pfd-summary`를 호출하세요.
