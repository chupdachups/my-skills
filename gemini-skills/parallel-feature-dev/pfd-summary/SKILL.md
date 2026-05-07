---
name: pfd-summary
description: 병렬 기능 개발 결과 요약. 모든 워커 완료 후 생성된 브랜치 목록과 비교 방법을 안내합니다. pfd-orchestrate 이후 자동 호출됩니다.
---

# 병렬 기능 개발 결과 요약 (pfd-summary)

모든 병렬 워커가 완료된 후 결과를 요약하고 브랜치 비교 방법을 안내합니다.

## 지시사항

### 1단계: 설정 및 결과 읽기

`.pfd-config.json`을 읽어 전체 실행 정보를 파악하세요:
- `devSkill`, `planFile`, `runs`, `branchPrefix`, `baseBranch`, `branches`

### 2단계: 각 브랜치 상태 확인

```bash
# 생성된 브랜치 목록 확인
git branch -a | grep "{branchPrefix}"
```

각 브랜치별 최신 커밋 확인:
```bash
git log {branchName} --oneline -3
```

### 3단계: 워커 로그 확인

각 워커의 실행 결과 로그를 확인하세요:
```bash
ls -la /tmp/pfd-worker-*.log
```

성공/실패 여부를 각 로그에서 확인하세요.

### 4단계: 결과 요약 출력

다음 형식으로 최종 결과를 출력하세요:

```
╔══════════════════════════════════════════╗
║     병렬 기능 개발 완료 요약              ║
╠══════════════════════════════════════════╣
║ 개발 스킬 : {devSkill}
║ PLAN 파일 : {planFile}
║ 기준 브랜치: {baseBranch}
╠══════════════════════════════════════════╣
║ 생성된 브랜치 목록:
║
║  [1] {branchPrefix}-run-1
║      └─ 커밋: {commitHash1} {commitMsg1}
║      └─ 상태: ✓ 성공 / ✗ 실패
║
║  [2] {branchPrefix}-run-2
║      └─ 커밋: {commitHash2} {commitMsg2}
║      └─ 상태: ✓ 성공 / ✗ 실패
║
╠══════════════════════════════════════════╣
║ 전체: {성공수}/{runs} 성공
╚══════════════════════════════════════════╝
```

### 5단계: 브랜치 비교 방법 안내

```
=== 브랜치 비교 방법 ===

1. GitHub/GitLab에서 PR 비교:
   각 브랜치를 {baseBranch}로 향하는 PR을 열어 diff를 확인하세요.

2. CLI로 브랜치 diff 확인:

   # 특정 브랜치와 기준 브랜치 비교
   git diff {baseBranch}...{branchPrefix}-run-1

   # 두 실행 결과 브랜치 간 비교
   git diff {branchPrefix}-run-1..{branchPrefix}-run-2

   # 변경 파일 목록만 확인
   git diff --name-only {baseBranch}...{branchPrefix}-run-1

3. 직접 체크아웃하여 확인:
   git checkout {branchPrefix}-run-1
   # 확인 후...
   git checkout {branchPrefix}-run-2

4. Worktree 경로에서 직접 확인:
   코드 에디터로 각 worktree 경로를 열어 비교하세요.
   - ../{repoName}-pfd-run-1/
   - ../{repoName}-pfd-run-2/
```

### 6단계: 정리 안내

```
=== 작업 완료 후 정리 방법 ===

마음에 드는 브랜치를 선택한 후:

1. 선택한 브랜치의 PR 생성:
   git checkout {선택한 브랜치}
   gh pr create --base {baseBranch}

2. 나머지 worktree 정리:
   git worktree remove ../{repoName}-pfd-run-N
   git worktree prune

3. 불필요한 브랜치 삭제:
   git branch -d {branchPrefix}-run-N
   git push origin --delete {branchPrefix}-run-N
```

### 7단계: 분석 스킬 실행 여부 확인

`.pfd-config.json`의 `analyzeSkill` 값을 확인하세요:

- **analyzeSkill이 설정된 경우**: 사용자에게 안내 후 `pfd-analyze` 스킬을 호출하세요.
  ```
  분석 스킬 ({analyzeSkill})을 각 브랜치에 실행합니다.
  → pfd-analyze 스킬 호출
  ```

- **analyzeSkill이 비어 있는 경우**: 아래 마무리 메시지를 출력하고 종료하세요.

### 8단계: 마무리 메시지 (분석 스킵 시)

```
✅ 병렬 기능 개발이 완료되었습니다.

총 {N}개의 브랜치를 비교하여 가장 잘 구현된 결과를 선택하세요.
선택한 브랜치를 {baseBranch}에 병합하려면 해당 브랜치의 PR을 생성하세요.

분석 스킬을 나중에 실행하려면:
  pfd-analyze 스킬을 실행하세요.
```

## Skill Chaining

- 이전: `pfd-orchestrate`
- 다음: `pfd-analyze` (analyzeSkill이 설정된 경우)
