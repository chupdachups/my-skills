---
name: pfd-analyze
description: 병렬 기능 개발 결과 분석. 각 브랜치에서 지정된 분석 스킬을 병렬로 실행하고 브랜치별 결과를 비교하여 최적 구현을 추천합니다.
user-invocable: false
allowed-tools: Read, Write, Agent, Bash(git log *) Bash(git diff *) Bash(git branch *)
---

# 병렬 기능 개발 결과 분석 (pfd-analyze)

각 브랜치에서 분석 스킬을 병렬로 실행하고 결과를 비교하여 최적 구현 브랜치를 추천합니다.

## 지시사항

### 1. 설정 읽기

`.pfd-config.json`을 읽어 다음 값을 파악하세요:
- `analyzeSkill`: 실행할 분석 스킬 이름
- `branches`: 분석 대상 브랜치 목록 (예: `["feature/pfd-run-1", "feature/pfd-run-2", ...]`)
- `planFile`: 기준 PLAN 파일
- `baseBranch`: 기준 브랜치
- `devSkill`: 사용된 개발 스킬 이름
- `runs`: 브랜치 수

`analyzeSkill`이 비어 있으면 사용자에게 분석 스킬 이름을 질문하고 config를 업데이트하세요.

### 2. 분석 실행 계획 출력

```
=== 브랜치 분석 시작 ===
분석 스킬: {analyzeSkill}
분석 대상: {runs}개 브랜치
  [1] {branches[0]}
  [2] {branches[1]}
  ...
========================
```

### 3. 병렬 분석 에이전트 실행 ★ 핵심 ★

**아래 규칙을 반드시 지키세요:**
- 단일 메시지에서 Agent 도구를 **정확히 `{runs}`번** 호출하세요.
- 각 에이전트 프롬프트는 **완전 자급자족**으로 작성합니다 (다른 스킬을 호출하지 않음).
- 모든 Agent 호출에 `isolation: "worktree"` 옵션을 적용하세요.

**각 에이전트(i = 1부터 runs까지)에 전달할 프롬프트:**

---
당신은 코드 분석 에이전트 {i}/{runs}입니다.
아래 절차를 **순서대로 빠짐없이** 완수해야 합니다.

## 작업 정보
- 분석 대상 브랜치: {branches[i-1]}
- 기준 브랜치: {baseBranch}
- PLAN 파일: {planFile}
- 분석 스킬: {analyzeSkill}

## 절차

### STEP 1: 분석 대상 브랜치 체크아웃
Bash 도구로 실행하세요:
```
git checkout {branches[i-1]}
git rev-parse --abbrev-ref HEAD
```
현재 브랜치가 `{branches[i-1]}`인지 확인하세요.

### STEP 2: 변경 범위 파악
Bash 도구로 실행하세요:
```
git diff {baseBranch}...{branches[i-1]} --stat
git diff {baseBranch}...{branches[i-1]} --name-only
```

### STEP 3: PLAN 파일 읽기
Read 도구로 `{planFile}` 파일 전체를 읽으세요.

### STEP 4: 변경된 파일 읽기
STEP 2에서 확인한 변경 파일들을 Read 도구로 읽으세요.

### STEP 5: 분석 스킬 실행
Skill 도구를 사용하여 다음 스킬을 실행하세요:
- skill: "{analyzeSkill}"
- args: "{planFile}"
분석이 완전히 완료될 때까지 기다리세요.

### STEP 6: 분석 결과 반환
분석 스킬 실행 결과를 바탕으로 아래 JSON을 반드시 출력하세요:
```json
{
  "agentIndex": {i},
  "branch": "{branches[i-1]}",
  "score": 0~100 숫자,
  "summary": "한 줄 요약",
  "strengths": ["강점1", "강점2"],
  "weaknesses": ["약점1", "약점2"],
  "planCoverage": "PLAN 요구사항 충족도 설명 (예: 5개 중 4개 충족)",
  "recommendation": "선택 여부 의견"
}
```
---

### 4. 분석 결과 수집 및 누락 처리

모든 에이전트 완료 후 각 JSON 결과를 수집하세요.

**누락된 에이전트가 있는 경우**: 해당 브랜치를 순차적으로 직접 분석하세요.

수집된 결과를 `.pfd-config.json`의 `analyzeResults`에 저장하고 `status`를 `analyzed`로 업데이트하세요.

### 5. 비교 보고서 생성

`references/report-format.md`를 참조하여 결과를 점수 내림차순으로 정렬하고 출력하세요:

```
╔══════════════════════════════════════════════════╗
║           브랜치 분석 결과 비교 보고서             ║
╠══════════════════════════════════════════════════╣
║ 분석 스킬 : {analyzeSkill}
║ PLAN 파일 : {planFile}
║ 개발 스킬 : {devSkill}
╠══════════════════════════════════════════════════╣
║ 순위별 결과:
║
║  1위. {branch}  점수: {score}/100
║       요약   : {summary}
║       강점   : {strengths}
║       약점   : {weaknesses}
║       PLAN 충족: {planCoverage}
║
║  2위. {branch}  점수: {score}/100
║       ...
║
╠══════════════════════════════════════════════════╣
║ ★ 추천 브랜치: {1위 브랜치명} (점수: {score}/100)
║   추천 이유 : {recommendation}
╚══════════════════════════════════════════════════╝
```

### 6. 다음 행동 안내

```
추천 브랜치로 PR 생성:
  git checkout {추천 브랜치}
  gh pr create --base {baseBranch} --title "feat: {planFile} 구현"
```
