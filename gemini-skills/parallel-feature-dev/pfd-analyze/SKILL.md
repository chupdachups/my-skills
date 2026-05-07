---
name: pfd-analyze
description: 병렬 기능 개발 완료 후 사용자가 지정한 분석 스킬을 실행합니다. 브랜치 목록과 PLAN 파일 정보를 컨텍스트로 전달하여 분석 스킬이 결과를 비교할 수 있도록 합니다.
---

# 병렬 기능 개발 결과 분석 (pfd-analyze)

개발 완료된 브랜치 정보를 컨텍스트로 구성한 뒤, 사용자가 지정한 분석 스킬을 단 1회 실행합니다.

## 지시사항

### 1단계: 설정 읽기

`.pfd-config.json`을 읽어 다음 값을 파악하세요:
- `analyzeSkill`: 실행할 분석 스킬 이름
- `branches`: 개발 완료된 브랜치 목록
- `planFile`: 기준 PLAN 파일
- `baseBranch`: 기준 브랜치
- `devSkill`: 사용된 개발 스킬 이름
- `runs`: 총 실행 횟수

`analyzeSkill`이 비어 있으면 사용자에게 분석 스킬 이름을 질문하세요.

### 2단계: 브랜치 현황 수집

각 브랜치의 최신 커밋을 확인하세요:

```bash
git log --oneline -1 {branchName}
```

### 3단계: 분석 스킬 실행 전 컨텍스트 출력

사용자에게 다음 내용을 출력하세요:

```
=== 분석 스킬 실행 ===
분석 스킬 : {analyzeSkill}
PLAN 파일 : {planFile}
분석 대상 브랜치:
  [1] {branches[0]} — 커밋: {commitHash1}
  [2] {branches[1]} — 커밋: {commitHash2}
  ...
=====================
```

### 4단계: 분석 스킬 실행

분석 스킬 실행 전, 아래 컨텍스트를 현재 대화에 먼저 출력하여 분석 스킬이 참조할 수 있도록 하세요:

```
[pfd 분석 컨텍스트]
- 기준 브랜치: {baseBranch}
- 개발 스킬  : {devSkill}
- PLAN 파일  : {planFile}
- 개발 브랜치 목록:
  {branches[0]}
  {branches[1]}
  ...
```

그 후 `{analyzeSkill}` 스킬을 호출하세요.

### 5단계: 완료 후 안내

분석 스킬 실행이 완료되면 사용자에게 안내하세요:

```
분석이 완료되었습니다.

선택한 브랜치를 병합하려면:
  git checkout {선택한 브랜치}
  gh pr create --base {baseBranch}
```

## Skill Chaining

이 스킬은 파이프라인의 최종 단계입니다.
