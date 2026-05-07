---
name: pfd-worker
description: 병렬 기능 개발 워커. 독립된 git worktree 디렉토리에서 개발 스킬을 실행하고 결과를 commit/push합니다. pfd-orchestrate의 worker.sh 스크립트에 의해 호출됩니다.
---

# 병렬 기능 개발 워커 (pfd-worker)

독립된 git worktree 환경에서 지정된 개발 스킬을 실행하고 결과를 commit/push합니다.

## 실행 맥락

이 스킬은 `scripts/worker.sh`에 의해 각 worktree 디렉토리 내에서 Gemini CLI가 실행될 때 호출됩니다.

실행 환경:
- **현재 디렉토리**: worktree 경로 (예: `../my-app-pfd-run-1`)
- **현재 브랜치**: 해당 실행번호의 브랜치 (예: `feature/pfd-run-1`)

## 지시사항

### 1단계: 환경 확인

```bash
# 현재 위치와 브랜치 확인
pwd
git status
git rev-parse --abbrev-ref HEAD
```

### 2단계: 설정 읽기

`.pfd-config.json`을 읽어 다음 값을 확인하세요:
- `devSkill`: 실행할 개발 스킬 이름
- `planFile`: PLAN 파일 경로
- 현재 브랜치가 올바른지 확인

### 3단계: 개발 스킬 실행

지정된 개발 스킬을 PLAN 파일을 인자로 호출하세요:

```
/{devSkill} {planFile}
```

**중요**: 개발 스킬의 모든 작업이 완전히 완료될 때까지 기다리세요.
코드 생성, 파일 수정, 테스트 등 스킬이 정의한 모든 단계를 수행하세요.

### 4단계: 변경사항 확인

```bash
git status
git diff --stat
```

변경된 파일이 없는 경우:
- 로그에 "변경사항 없음" 기록
- 스킬 종료

### 5단계: Commit

`scripts/commit-worker.sh`를 참조하여 commit을 수행하세요:

```bash
git add -A

git commit -m "feat: implement feature from {planFile} [pfd {branchName}]

- Dev skill: {devSkill}
- Plan file: {planFile}
- Branch: {branchName}

Co-Authored-By: Gemini CLI <noreply@google.com>"
```

### 6단계: Push

```bash
git push -u origin {branchName}
```

push 실패 시:
- 에러 메시지를 로그에 기록
- force push는 절대 하지 않음
- 에러 상태로 종료

### 7단계: 완료 보고

다음 형식으로 완료 상태를 출력하세요:

```
=== [워커 완료] ===
브랜치  : {branchName}
PLAN 파일: {planFile}
개발 스킬: {devSkill}
상태    : 성공 ✓
커밋 해시: {commitHash}
===================
```

## Skill Chaining

이 스킬은 체인의 말단입니다. 완료 후 pfd-orchestrate의 wait-workers.sh로 결과가 수집됩니다.
