---
name: pfd-worker
description: 병렬 기능 개발 워커. 독립된 worktree에서 단일 브랜치를 생성하고 개발 스킬을 실행한 뒤 commit/push합니다. pfd-orchestrate에 의해 호출됩니다.
user-invocable: false
allowed-tools: Read, Write, Bash, Skill
argument-hint: "<branch-name> <plan-file> <dev-skill> <base-branch>"
---

# 병렬 기능 개발 워커 (pfd-worker)

독립된 worktree 환경에서 브랜치를 생성하고 개발 스킬을 실행한 후 결과를 commit/push합니다.

## 인자 파싱

`$ARGUMENTS`에서 순서대로 파싱하세요:
- 첫 번째: `BRANCH_NAME` (예: `feature/pfd-run-1`)
- 두 번째: `PLAN_FILE` (예: `PLAN-FILE.md`)
- 세 번째: `DEV_SKILL` (예: `dev-back-execute-code`)
- 네 번째: `BASE_BRANCH` (예: `main`)

## 지시사항

### 1. 환경 확인

```bash
git status
git rev-parse --abbrev-ref HEAD  # 현재 브랜치 확인
```

### 2. 브랜치 생성 및 체크아웃

`scripts/create-branch.sh`를 참조하여 아래 명령을 실행하세요:

```bash
# 기준 브랜치에서 새 브랜치 생성
git checkout -b {BRANCH_NAME} {BASE_BRANCH}
```

이미 브랜치가 존재하는 경우:
```bash
git checkout {BRANCH_NAME}
```

### 3. 개발 스킬 실행

지정된 개발 스킬을 PLAN 파일을 인자로 호출하세요:

```
/{DEV_SKILL} {PLAN_FILE}
```

**중요**: 개발 스킬이 완료될 때까지 기다리세요. 스킬이 코드를 생성/수정하면 다음 단계로 진행합니다.

### 4. 변경사항 확인

```bash
git status
git diff --stat
```

변경된 파일이 없으면 워커를 종료하고 "변경사항 없음"을 보고합니다.

### 5. Commit

`scripts/commit-push.sh`를 참조하여 commit을 수행하세요:

```bash
# 모든 변경사항 스테이징
git add -A

# 커밋 메시지 (PLAN 파일과 실행 번호 포함)
git commit -m "feat: implement feature from {PLAN_FILE} [pfd {BRANCH_NAME}]

- Dev skill: {DEV_SKILL}
- Plan file: {PLAN_FILE}
- Branch: {BRANCH_NAME}

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

### 6. Push

```bash
git push -u origin {BRANCH_NAME}
```

push 실패 시 에러 메시지를 출력하고 워커를 종료하세요 (force push 금지).

### 7. 완료 보고

다음 형식으로 완료 상태를 출력하세요:

```
=== [워커 완료] ===
브랜치  : {BRANCH_NAME}
PLAN 파일: {PLAN_FILE}
개발 스킬: {DEV_SKILL}
상태    : 성공 ✓ (또는 실패 ✗)
커밋 해시: {COMMIT_HASH}
===================
```
