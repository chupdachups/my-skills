---
name: pfd-analyze
description: 병렬 기능 개발 결과 분석. 각 브랜치에서 지정된 분석 스킬을 병렬로 실행하고 브랜치별 결과를 비교하여 최적 구현을 추천합니다.
user-invocable: false
allowed-tools: Read, Write, Agent, Bash(git log *) Bash(git diff *) Bash(git worktree *)
---

# 병렬 기능 개발 결과 분석 (pfd-analyze)

각 브랜치에서 분석 스킬을 병렬로 실행하고 결과를 비교하여 최적 구현 브랜치를 추천합니다.

## 지시사항

### 1. 설정 읽기

`.pfd-config.json`을 읽어 다음 값을 파악하세요:
- `analyzeSkill`: 실행할 분석 스킬 이름
- `branches`: 분석 대상 브랜치 목록
- `worktreePaths`: 각 브랜치의 worktree 경로
- `planFile`: 기준이 되는 PLAN 파일
- `baseBranch`: 기준 브랜치
- `devSkill`: 사용된 개발 스킬 이름

analyzeSkill이 비어 있으면 사용자에게 분석 스킬 이름을 질문하세요.

### 2. 분석 실행 안내 출력

```
=== 브랜치 분석 시작 ===
분석 스킬: {analyzeSkill}
분석 대상: {runs}개 브랜치
  [1] {branchPrefix}-run-1
  [2] {branchPrefix}-run-2
  ...
========================
```

### 3. 병렬 분석 실행 (핵심)

**반드시 단일 메시지에서 N개의 Agent 도구 호출을 동시에 실행하세요 (병렬).**

각 에이전트에 전달할 프롬프트 템플릿:

```
당신은 코드 분석 에이전트입니다. 특정 브랜치의 구현 결과를 분석합니다.

## 분석 정보
- 브랜치명: {branchName}
- 기준 브랜치: {baseBranch}
- PLAN 파일: {planFile}
- 분석 스킬: /{analyzeSkill}
- 실행 번호: {i} / {N}

## 수행 절차
1. 이 브랜치와 기준 브랜치의 diff를 확인하세요:
   git diff {baseBranch}...{branchName} --stat
   git diff {baseBranch}...{branchName}

2. PLAN 파일을 읽어 요구사항을 파악하세요.

3. `/{analyzeSkill}` 스킬을 호출하세요.

4. 분석 완료 후 반드시 다음 형식으로 결과를 JSON으로 반환하세요:
   {
     "branch": "{branchName}",
     "runIndex": {i},
     "score": 0~100,
     "summary": "한 줄 요약",
     "strengths": ["강점1", "강점2"],
     "weaknesses": ["약점1", "약점2"],
     "planCoverage": "PLAN 요구사항 충족도 설명",
     "recommendation": "선택 여부 의견"
   }
```

각 Agent 호출에 `isolation: "worktree"` 옵션을 적용하세요.

### 4. 분석 결과 수집

모든 에이전트 완료 후 각 결과 JSON을 수집하세요.
`.pfd-config.json`의 `analyzeResults` 필드에 결과 배열을 저장하세요.

### 5. 비교 보고서 생성

`references/report-format.md`를 참조하여 최종 비교 보고서를 출력하세요:

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
║      요약  : {summary2}
║      강점  : {strengths2}
║      약점  : {weaknesses2}
║      PLAN 충족도: {planCoverage2}
║
╠══════════════════════════════════════════════════╣
║ ★ 추천 브랜치: {최고점수 브랜치명} (점수: {최고점수}/100)
║   추천 이유 : {recommendation}
╚══════════════════════════════════════════════════╝
```

### 6. 다음 행동 안내

```
분석이 완료되었습니다.

추천 브랜치: {branchName}
  git checkout {branchName}
  gh pr create --base {baseBranch} --title "feat: {planFile} 구현"

또는 다른 브랜치를 선택하려면:
  git checkout {다른 브랜치명}
```
