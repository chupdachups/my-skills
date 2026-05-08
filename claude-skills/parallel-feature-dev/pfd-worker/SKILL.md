---
name: pfd-worker
description: 병렬 기능 개발 워커. 지정된 worktree 절대 경로에서 개발 스킬을 실행하고 commit/push합니다. pfd-orchestrate의 agent 프롬프트 또는 단독으로 실행됩니다.
user-invocable: false
allowed-tools: Read, Write, Bash, Skill
argument-hint: "<worktree-path> <branch-name> <dev-skill> <plan-file>"
---

# 병렬 기능 개발 워커 (pfd-worker)

지정된 worktree 절대 경로에서 개발 스킬을 실행하고 결과를 commit/push합니다.

## ⛔ 절대 금지 규칙 (반드시 준수)

1. **다른 worktree 참조 금지**: `{WORKTREE_PATH}` 이외의 worktree 디렉토리를 읽거나 참조하지 마세요.
2. **다른 pfd 브랜치 참조 금지**: `{BRANCH_NAME}` 외의 pfd 브랜치를 checkout/diff/log하지 마세요.
3. **미완성 시 타 브랜치 대체 금지**: 개발 스킬이 완료되지 않으면 다른 worktree 코드로 채우지 말고 실패로 보고하세요.
4. **허용 참조 소스**: 기준 브랜치 코드, PLAN 파일, 개발 스킬이 생성한 코드만 사용하세요.

## 인자 파싱

`$ARGUMENTS`에서 순서대로 파싱하세요:
- 첫 번째: `WORKTREE_PATH` (절대 경로, 예: `/workspace/my-app-worktree-run-1`)
- 두 번째: `BRANCH_NAME` (예: `feature/pfd-run-1`)
- 세 번째: `DEV_SKILL` (예: `dev-back-execute-code`)
- 네 번째: `PLAN_FILE` (저장소 루트 기준 상대 경로, 예: `docs/PLAN-FILE.md`)

## 지시사항

이하 모든 Bash 명령은 반드시 `cd {WORKTREE_PATH} &&` 를 앞에 붙여 실행하세요.

### 1. Worktree 진입 및 상태 확인

```bash
cd {WORKTREE_PATH} && git status
cd {WORKTREE_PATH} && git rev-parse --abbrev-ref HEAD
```

현재 브랜치가 `{BRANCH_NAME}`인지 확인하세요.

### 2. PLAN 파일 읽기

Read 도구로 `{WORKTREE_PATH}/{PLAN_FILE}` 파일을 읽으세요.

### 3. 개발 스킬 실행

Skill 도구를 사용하여 다음 스킬을 실행하세요:
- skill: `{DEV_SKILL}`
- args: `{PLAN_FILE}`

스킬이 완전히 완료될 때까지 기다리세요.

개발 스킬이 완료되지 않거나 실패한 경우:
- 다른 worktree를 절대 참조하지 마세요.
- 실패로 보고하고 종료하세요.

### 4. 변경사항 확인

```bash
cd {WORKTREE_PATH} && git status
cd {WORKTREE_PATH} && git diff --stat
```

변경된 파일이 없으면 개발 스킬이 정상 완료되지 않은 것입니다.
**다른 worktree를 참조하지 말고** 실패로 보고하고 종료하세요.

### 5. Commit

```bash
cd {WORKTREE_PATH} && git add -A
cd {WORKTREE_PATH} && git commit -m "feat: implement from {PLAN_FILE} [pfd {BRANCH_NAME}]

- Dev skill: {DEV_SKILL}
- Plan file: {PLAN_FILE}
- Branch: {BRANCH_NAME}
- Worktree: {WORKTREE_PATH}

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

### 6. Push

```bash
cd {WORKTREE_PATH} && git push -u origin {BRANCH_NAME}
```

push 실패 시 에러 내용을 출력하고 종료하세요. force push는 금지입니다.

### 7. 완료 보고

```
=== [워커 완료] ===
Worktree : {WORKTREE_PATH}
브랜치   : {BRANCH_NAME}
개발 스킬 : {DEV_SKILL}
상태     : 성공 ✓ (또는 실패 ✗)
커밋 해시 : {COMMIT_HASH}
===================
```
