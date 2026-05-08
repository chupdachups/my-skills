---
name: pfd-worker
description: 병렬 기능 개발 워커. 지정된 worktree 절대 경로에서 개발 스킬을 실행하고 commit/push합니다. pfd-orchestrate의 worker.sh 스크립트에 의해 호출됩니다.
---

# 병렬 기능 개발 워커 (pfd-worker)

지정된 worktree 절대 경로에서 개발 스킬을 실행하고 결과를 commit/push합니다.

## ⛔ 절대 금지 규칙 (반드시 준수)

1. **다른 worktree 참조 금지**: 현재 worktree 이외의 pfd worktree 디렉토리를 읽거나 참조하지 마세요.
2. **다른 pfd 브랜치 참조 금지**: 현재 브랜치 외의 pfd 브랜치를 checkout/diff/log/read하지 마세요.
3. **미완성 시 타 worktree 대체 금지**: 개발 스킬이 완료되지 않으면 다른 worktree 코드로 채우지 말고 실패로 보고하세요.
4. **허용 참조 소스**: 기준 브랜치 코드, PLAN 파일, 개발 스킬이 생성한 코드만 사용하세요.

## 실행 맥락

이 스킬은 `scripts/worker.sh`에 의해 각 worktree 절대 경로에서 Gemini CLI가 실행될 때 호출됩니다.

- **현재 디렉토리**: worktree 절대 경로 (예: `/workspace/my-app-worktree-run-1`)
- **현재 브랜치**: 해당 실행번호의 브랜치 (예: `feature/pfd-run-1`)

## 지시사항

### 1단계: 환경 확인

```bash
git status
git rev-parse --abbrev-ref HEAD
```

### 2단계: 설정 읽기

`{projectRoot}/.pfd-config.json`을 읽어 `devSkill`, `planFile`, `baseBranch`를 확인하세요.
현재 브랜치가 올바른지 확인하세요.

### 3단계: PLAN 파일 읽기

`{planFile}` 파일을 읽으세요 (현재 worktree 내 상대 경로).

### 4단계: 개발 스킬 실행

지정된 개발 스킬을 PLAN 파일을 인자로 호출하세요:

```
/{devSkill} {planFile}
```

개발 스킬이 완료되지 않거나 실패한 경우:
- 다른 worktree를 절대 참조하지 마세요.
- 실패로 보고하고 종료하세요.

### 5단계: 변경사항 확인

```bash
git status
git diff --stat
```

변경된 파일이 없으면 개발 스킬이 정상 완료되지 않은 것입니다.
**다른 worktree를 참조하지 말고** 실패로 보고하고 종료하세요.

### 6단계: Commit & Push

```bash
git add -A
git commit -m "feat: implement from {planFile} [pfd {branchName}]

Co-Authored-By: Gemini CLI <noreply@google.com>"

git push -u origin {branchName}
```

## Skill Chaining

이 스킬은 체인의 말단입니다.
