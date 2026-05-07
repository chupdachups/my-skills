---
name: pfd-orchestrate
description: 병렬 기능 개발 오케스트레이터. pfd-init 이후 호출되며 git worktree를 N개 생성하고 각각 백그라운드 프로세스로 개발 스킬을 병렬 실행합니다.
---

# 병렬 기능 개발 오케스트레이터 (pfd-orchestrate)

`.pfd-config.json`을 읽어 N개의 git worktree를 생성하고, 각 worktree에서 개발 워커를 병렬로 실행합니다.

## 지시사항

### 1단계: 설정 읽기

`.pfd-config.json`을 읽어 전체 설정을 파악하세요:
- `devSkill`, `planFile`, `runs`, `branchPrefix`, `baseBranch`

`references/worktree-guide.md`의 git worktree 가이드를 참고하세요.

### 2단계: Worktree 생성

각 실행번호(1~N)에 대해 git worktree를 생성하세요.

**현재 저장소 이름 확인:**
```bash
git rev-parse --show-toplevel
```

**N개의 worktree 생성 (순차적으로):**

각 i=1~N에 대해:
```bash
git worktree add -b {branchPrefix}-run-{i} ../{repo-name}-pfd-run-{i} {baseBranch}
```

예시 (repo=my-app, branchPrefix=feature/pfd, i=1):
```bash
git worktree add -b feature/pfd-run-1 ../my-app-pfd-run-1 main
```

worktree 목록 확인:
```bash
git worktree list
```

### 3단계: 설정 파일 업데이트

`.pfd-config.json`의 다음 필드를 업데이트하세요:

```json
{
  "branches": ["feature/pfd-run-1", "feature/pfd-run-2", ...],
  "worktreePaths": ["../my-app-pfd-run-1", "../my-app-pfd-run-2", ...],
  "status": "orchestrating"
}
```

각 worktree 경로에도 설정 파일을 복사하세요:
```bash
cp .pfd-config.json ../{repo-name}-pfd-run-{i}/.pfd-config.json
```

### 4단계: 병렬 실행 안내 출력

```
=== 병렬 실행 시작 ===
총 {N}개 워커를 백그라운드로 실행합니다:

  [1] 브랜치: {branchPrefix}-run-1
      경로  : ../{repo}-pfd-run-1
  [2] 브랜치: {branchPrefix}-run-2
      경로  : ../{repo}-pfd-run-2
  ...

scripts/orchestrate.sh 스크립트로 워커를 실행합니다.
======================
```

### 5단계: 워커 병렬 실행 (핵심)

`scripts/orchestrate.sh`를 실행하세요. 이 스크립트가 N개의 워커를 백그라운드로 실행합니다:

```bash
bash scripts/orchestrate.sh "{devSkill}" "{planFile}" {runs} "{branchPrefix}" "{repoName}"
```

`is_background: false`로 실행하세요 (스크립트 내부에서 각 워커를 백그라운드로 실행합니다).

### 6단계: 완료 대기 및 모니터링

워커 실행 후 진행 상태를 사용자에게 안내하세요:

```
🔄 {N}개의 워커가 백그라운드에서 실행 중입니다.

모니터링하려면:
  /shells  → 백그라운드 프로세스 목록 확인
  tail -f /tmp/pfd-worker-*.log → 각 워커 로그 확인

완료를 기다리는 중...
```

`scripts/wait-workers.sh`를 실행하여 모든 워커가 완료될 때까지 대기하세요:
```bash
bash scripts/wait-workers.sh {runs}
```

### 7단계: 완료 후 처리

모든 워커 완료 후:

1. `.pfd-config.json`의 `status`를 `completed`로 업데이트
2. worktree 정리 (선택):
   ```bash
   # worktree는 결과 확인 후 사용자가 직접 정리하도록 안내
   ```

3. `pfd-summary` 스킬을 호출하세요.

## Skill Chaining

- 이전: `pfd-init`
- 다음: `pfd-summary` — 결과 요약 및 브랜치 비교 안내
