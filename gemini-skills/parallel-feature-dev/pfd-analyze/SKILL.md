---
name: pfd-analyze
description: 병렬 기능 개발 결과 분석. 각 worktree에서 지정된 분석 스킬을 병렬로 실행하고 브랜치별 결과를 비교하여 최적 구현을 추천합니다. pfd-summary 이후 자동 호출됩니다.
---

# 병렬 기능 개발 결과 분석 (pfd-analyze)

각 브랜치(worktree)에서 분석 스킬을 병렬로 실행하고 결과를 비교하여 최적 구현 브랜치를 추천합니다.

## 지시사항

### 1단계: 설정 읽기

`.pfd-config.json`을 읽어 다음 값을 파악하세요:
- `analyzeSkill`: 실행할 분석 스킬 이름
- `branches`: 분석 대상 브랜치 목록
- `worktreePaths`: 각 브랜치의 worktree 경로
- `planFile`: 기준 PLAN 파일
- `baseBranch`: 기준 브랜치
- `devSkill`: 사용된 개발 스킬

`analyzeSkill`이 비어 있으면 사용자에게 분석 스킬 이름을 질문하세요.

`references/report-format.md`의 보고서 형식을 참고하세요.

### 2단계: 분석 실행 안내 출력

```
=== 브랜치 분석 시작 ===
분석 스킬: {analyzeSkill}
분석 대상: {runs}개 브랜치
  [1] {branchPrefix}-run-1  →  {worktreePath-1}
  [2] {branchPrefix}-run-2  →  {worktreePath-2}
  ...

scripts/run-analysis.sh 스크립트로 분석을 실행합니다.
========================
```

### 3단계: 병렬 분석 실행

`scripts/run-analysis.sh`를 실행하세요:

```bash
bash scripts/run-analysis.sh "{analyzeSkill}" "{planFile}" {runs} "{branchPrefix}" "{repoName}"
```

이 스크립트가 각 worktree에서 `scripts/analyze-worker.sh`를 백그라운드로 실행합니다.

### 4단계: 분석 완료 대기

```bash
bash scripts/wait-analysis.sh {runs}
```

각 워커의 분석 결과 JSON이 `/tmp/pfd-analysis-{i}.json`에 저장됩니다.

### 5단계: 결과 집계

완료된 분석 결과 파일들을 읽으세요:
```bash
cat /tmp/pfd-analysis-*.json
```

결과를 `.pfd-config.json`의 `analyzeResults` 배열에 저장하고 `status`를 `analyzed`로 업데이트하세요.

### 6단계: 비교 보고서 출력

수집된 결과를 `references/report-format.md` 형식으로 출력하세요:

```
╔══════════════════════════════════════════════════╗
║           브랜치 분석 결과 비교 보고서             ║
╠══════════════════════════════════════════════════╣
║ 분석 스킬 : {analyzeSkill}
║ PLAN 파일 : {planFile}
║ 개발 스킬 : {devSkill}
╠══════════════════════════════════════════════════╣
║ 브랜치별 분석 결과:
║
║  [1] {branchName-1}  점수: {score1}/100
║      요약  : {summary1}
║      강점  : {strengths1}
║      약점  : {weaknesses1}
║      PLAN 충족도: {planCoverage1}
║
║  [2] {branchName-2}  점수: {score2}/100
║      ...
║
╠══════════════════════════════════════════════════╣
║ ★ 추천 브랜치: {최고점수 브랜치명} (점수: {최고점수}/100)
║   추천 이유 : {recommendation}
╚══════════════════════════════════════════════════╝
```

### 7단계: 다음 행동 안내

```
✅ 분석이 완료되었습니다.

추천 브랜치: {branchName}

선택한 브랜치를 사용하려면:
  git checkout {branchName}
  gh pr create --base {baseBranch} --title "feat: {planFile} 구현"

나머지 정리:
  git worktree remove ../{repoName}-pfd-run-N
  git worktree prune
```

## Skill Chaining

이 스킬은 파이프라인의 최종 단계입니다.
