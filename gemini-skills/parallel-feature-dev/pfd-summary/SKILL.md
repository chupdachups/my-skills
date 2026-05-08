---
name: pfd-summary
description: 병렬 기능 개발 결과 요약. 모든 worktree 개발 완료 후 브랜치 및 worktree 목록을 출력하고 분석 스킬로 체이닝합니다.
---

# 병렬 기능 개발 결과 요약 (pfd-summary)

모든 병렬 워커가 완료된 후 결과를 요약하고 분석 스킬로 체이닝합니다.

## 지시사항

### 1단계: 설정 읽기

`{projectRoot}/.pfd-config.json`을 읽어 전체 실행 정보를 파악하세요.

### 2단계: Worktree 및 브랜치 상태 확인

```bash
git -C {bareRepoPath} worktree list
git -C {bareRepoPath} branch -a | grep "{branchPrefix}"
```

각 브랜치 최신 커밋:
```bash
git -C {bareRepoPath} log {branchName} --oneline -1
```

워커 로그 확인:
```bash
ls -la /tmp/pfd-worker-*.log
```

### 3단계: 결과 요약 출력

```
╔══════════════════════════════════════════════════╗
║         병렬 기능 개발 완료 요약                  ║
╠══════════════════════════════════════════════════╣
║ 프로젝트 루트 : {projectRoot}
║ 메인 저장소  : {bareRepoPath}  [{baseBranch}]
║ 개발 스킬   : {devSkill}
║ PLAN 파일   : {planFile}
╠══════════════════════════════════════════════════╣
║ 생성된 Worktree 및 브랜치:
║
║  [1] {projectRoot}/{projectBare}-worktree-run-1
║      브랜치 : {branchPrefix}-run-1
║      커밋  : {commitHash1}  ✓/✗
║
║  [2] {projectRoot}/{projectBare}-worktree-run-2
║      브랜치 : {branchPrefix}-run-2
║      커밋  : {commitHash2}  ✓/✗
║  ...
╠══════════════════════════════════════════════════╣
║ 브랜치 비교:
║   git -C {bareRepoPath} diff {baseBranch}...{branchPrefix}-run-1
║   git -C {bareRepoPath} diff {branchPrefix}-run-1..{branchPrefix}-run-2
╚══════════════════════════════════════════════════╝
```

### 4단계: 분석 스킬 실행 여부 확인

`analyzeSkill` 값을 확인하세요:

- **설정된 경우**: `pfd-analyze` 스킬을 호출하세요.
- **비어 있는 경우**: 아래 마무리 메시지를 출력하고 종료하세요.

### 5단계: 마무리 메시지 (분석 스킵 시)

```
✅ 병렬 기능 개발이 완료되었습니다.

선택 후 정리:
  git -C {bareRepoPath} checkout {선택한 브랜치}
  gh pr create --base {baseBranch}

  git -C {bareRepoPath} worktree remove {worktreePath}
  git -C {bareRepoPath} worktree prune

분석 스킬을 나중에 실행하려면: pfd-analyze 스킬을 실행하세요.
```

## Skill Chaining

- 이전: `pfd-orchestrate`
- 다음: `pfd-analyze` (analyzeSkill이 설정된 경우)
