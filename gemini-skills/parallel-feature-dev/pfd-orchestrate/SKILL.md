---
name: pfd-orchestrate
description: 병렬 기능 개발 오케스트레이터. git worktree를 N개 생성하고 각 worktree에서 개발 워커를 병렬 백그라운드로 실행합니다.
---

# 병렬 기능 개발 오케스트레이터 (pfd-orchestrate)

`{projectRoot}/.pfd-config.json`을 읽어 git worktree를 생성하고 N개의 워커를 병렬로 실행합니다.

## 지시사항

### 1단계: 설정 읽기

`{projectRoot}/.pfd-config.json`을 읽어 다음 값을 파악하세요:
- `projectRoot`, `projectBare`, `bareRepoPath`
- `devSkill`, `planFile`, `runs`
- `branchPrefix`, `baseBranch`

`references/worktree-guide.md`의 git worktree 가이드를 참고하세요.

### 2단계: Worktree 생성

`scripts/setup-worktrees.sh`를 실행하여 N개의 worktree를 생성하세요:

```bash
bash scripts/setup-worktrees.sh \
  "{bareRepoPath}" \
  "{projectRoot}" \
  "{projectBare}" \
  {runs} \
  "{branchPrefix}" \
  "{baseBranch}"
```

생성 확인:
```bash
git -C {bareRepoPath} worktree list
```

### 3단계: 설정 파일 업데이트

`{projectRoot}/.pfd-config.json`의 다음 필드를 업데이트하세요:

```json
{
  "branches": ["{branchPrefix}-run-1", ...],
  "worktreePaths": [
    "{projectRoot}/{projectBare}-worktree-run-1",
    "{projectRoot}/{projectBare}-worktree-run-2",
    ...
  ],
  "status": "running"
}
```

### 4단계: 실행 계획 출력

```
=== 병렬 실행 시작 ===
총 {runs}개 워커를 백그라운드로 실행합니다:

  [1] {projectRoot}/{projectBare}-worktree-run-1  →  {branchPrefix}-run-1
  [2] {projectRoot}/{projectBare}-worktree-run-2  →  {branchPrefix}-run-2
  ...
======================
```

### 5단계: 워커 병렬 실행

`scripts/orchestrate.sh`를 실행하세요:

```bash
bash scripts/orchestrate.sh \
  "{projectRoot}" \
  "{projectBare}" \
  "{devSkill}" \
  "{planFile}" \
  {runs} \
  "{branchPrefix}"
```

### 6단계: 완료 대기

```
🔄 {runs}개의 워커가 백그라운드에서 실행 중입니다.
로그 확인: tail -f /tmp/pfd-worker-*.log
```

`scripts/wait-workers.sh`를 실행하세요:
```bash
bash scripts/wait-workers.sh {runs}
```

### 7단계: 설정 업데이트 및 다음 스킬 호출

`{projectRoot}/.pfd-config.json`의 `status`를 `completed`로 업데이트하세요.

`pfd-summary` 스킬을 호출하세요.

## Skill Chaining

- 이전: `pfd-init`
- 다음: `pfd-summary`
