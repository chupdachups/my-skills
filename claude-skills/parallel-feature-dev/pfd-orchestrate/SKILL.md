---
name: pfd-orchestrate
description: 병렬 기능 개발 오케스트레이터. git worktree를 N개 생성하고 각 worktree에서 개발 에이전트를 병렬 실행합니다.
user-invocable: false
allowed-tools: Read, Write, Agent, Bash(git -C *) Bash(git worktree *) Bash(ls *) Bash(mkdir *)
---

# 병렬 기능 개발 오케스트레이터 (pfd-orchestrate)

`{projectRoot}/.pfd-config.json`을 읽어 git worktree를 생성하고 정확히 N개의 개발 에이전트를 병렬 실행합니다.

## 지시사항

### 1. 설정 읽기

`{projectRoot}/.pfd-config.json`을 읽어 다음 값을 파악하세요.
(projectRoot는 현재 컨텍스트에서 알고 있는 경로를 사용하세요):
- `projectRoot`, `projectBare`, `bareRepoPath`
- `devSkill`, `planFile`, `runs`
- `branchPrefix`, `baseBranch`

### 2. Worktree 생성

`scripts/setup-worktrees.sh`를 참조하여 N개의 worktree를 순차적으로 생성하세요.

각 i=1~runs에 대해:

```bash
git -C {bareRepoPath} worktree add \
  -b {branchPrefix}-run-{i} \
  {projectRoot}/{projectBare}-worktree-run-{i} \
  {baseBranch}
```

생성 확인:
```bash
git -C {bareRepoPath} worktree list
```

이미 worktree가 존재하는 경우 해당 번호를 스킵하세요.

### 3. 설정 파일 업데이트

`.pfd-config.json`의 다음 필드를 업데이트하세요:

```json
{
  "branches": ["{branchPrefix}-run-1", "{branchPrefix}-run-2", ...],
  "worktreePaths": [
    "{projectRoot}/{projectBare}-worktree-run-1",
    "{projectRoot}/{projectBare}-worktree-run-2",
    ...
  ],
  "status": "running"
}
```

### 4. 실행 계획 출력

```
=== 병렬 실행 시작 ===
총 {runs}개 에이전트를 병렬로 실행합니다:
  [1] {projectRoot}/{projectBare}-worktree-run-1  →  {branchPrefix}-run-1
  [2] {projectRoot}/{projectBare}-worktree-run-2  →  {branchPrefix}-run-2
  ...
======================
```

### 5. 병렬 에이전트 실행 ★ 핵심 ★

**아래 규칙을 반드시 지키세요:**
- 단일 메시지에서 Agent 도구를 **정확히 `{runs}`번** 호출하세요.
- `runs`가 3이면 3번, 5이면 5번. 절대 누락하지 마세요.
- 각 에이전트 프롬프트는 **완전 자급자족**으로 작성합니다.
- **`isolation: "worktree"` 옵션을 사용하지 마세요.** Worktree는 이미 수동으로 생성되었습니다.

**각 에이전트(i = 1부터 runs까지)에 전달할 프롬프트:**

---
당신은 기능 개발 에이전트 {i}/{runs}입니다.
아래 절차를 **순서대로 빠짐없이** 완수해야 합니다. 중간에 멈추지 마세요.

## ⛔ 절대 금지 규칙

1. **다른 worktree 참조 금지**: `{worktreePath}` 이외의 worktree 디렉토리를 읽거나 참조하지 마세요.
2. **다른 pfd 브랜치 참조 금지**: `{branchPrefix}-run-{i}` 외의 pfd 브랜치를 checkout/diff/log하지 마세요.
3. **미완성 시 타 브랜치 대체 금지**: 개발 스킬이 완료되지 않으면 다른 worktree 코드로 채우지 말고 실패로 보고하세요.
4. **허용 참조**: `{bareRepoPath}` 기준 브랜치 코드, `{planFile}`, 개발 스킬이 생성한 코드만 사용하세요.

## 작업 정보

- **Worktree 경로**: `{projectRoot}/{projectBare}-worktree-run-{i}`
- **브랜치명**: `{branchPrefix}-run-{i}`
- **개발 스킬**: `{devSkill}`
- **PLAN 파일**: `{planFile}` (worktree 내 상대 경로)
- **실행 번호**: {i} / {runs}

이하 모든 Bash 명령은 반드시 `cd {projectRoot}/{projectBare}-worktree-run-{i} &&` 를 앞에 붙여 실행하세요.

## 절차

### STEP 1: Worktree 진입 및 상태 확인
```bash
cd {projectRoot}/{projectBare}-worktree-run-{i} && git status
cd {projectRoot}/{projectBare}-worktree-run-{i} && git rev-parse --abbrev-ref HEAD
```
현재 브랜치가 `{branchPrefix}-run-{i}`인지 확인하세요.

### STEP 2: PLAN 파일 읽기
Read 도구로 `{projectRoot}/{projectBare}-worktree-run-{i}/{planFile}` 파일을 읽으세요.
없으면 `{projectRoot}/{projectBare}/{planFile}` 에서 읽으세요.

### STEP 3: 개발 스킬 실행
현재 작업 디렉토리가 `{projectRoot}/{projectBare}-worktree-run-{i}`임을 인식하고
Skill 도구를 사용하여 다음 스킬을 실행하세요:
- skill: `{devSkill}`
- args: `{planFile}`

스킬이 완전히 완료될 때까지 기다리세요.

개발 스킬이 완료되지 않거나 실패한 경우:
- 다른 worktree를 참조하지 마세요.
- STEP 6으로 이동하여 status: "failed"로 보고하고 종료하세요.

### STEP 4: 변경사항 확인
```bash
cd {projectRoot}/{projectBare}-worktree-run-{i} && git status
cd {projectRoot}/{projectBare}-worktree-run-{i} && git diff --stat
```
변경된 파일이 없으면 **다른 worktree를 참조하지 말고** STEP 6으로 이동하여 status: "failed", reason: "no changes after skill execution"으로 보고하세요.

### STEP 5: Commit & Push
```bash
cd {projectRoot}/{projectBare}-worktree-run-{i} && git add -A
cd {projectRoot}/{projectBare}-worktree-run-{i} && git commit -m "feat: implement from {planFile} [pfd run-{i}]

- Dev skill: {devSkill}
- Plan file: {planFile}
- Branch: {branchPrefix}-run-{i}
- Worktree: {projectRoot}/{projectBare}-worktree-run-{i}

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

cd {projectRoot}/{projectBare}-worktree-run-{i} && git push -u origin {branchPrefix}-run-{i}
```
push 실패 시 에러를 기록하고 종료하세요. force push는 금지입니다.

### STEP 6: 완료 보고
다음 JSON을 반드시 출력하세요:
```json
{
  "agentIndex": {i},
  "branch": "{branchPrefix}-run-{i}",
  "worktreePath": "{projectRoot}/{projectBare}-worktree-run-{i}",
  "status": "success",
  "commitHash": "<git -C {worktreePath} rev-parse --short HEAD 결과>"
}
```
실패 시 status를 "failed"로, reason 필드에 실패 이유를 추가하세요.
---

### 6. 완료 확인 및 누락 처리

모든 에이전트 완료 후 결과 JSON을 수집하세요.

**누락된 에이전트가 있는 경우**: 위 절차를 직접 수행하거나 단독 Agent로 재실행하세요.

**최종 확인:**
```bash
git -C {bareRepoPath} worktree list
git -C {bareRepoPath} branch -a | grep "{branchPrefix}"
```

### 7. 설정 업데이트

`{projectRoot}/.pfd-config.json`의 `status`를 `completed`로 업데이트하세요.

### 8. 다음 skill 호출

반드시 `/pfd-summary`를 호출하세요.
