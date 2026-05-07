---
name: pfd-init
description: 설계서(PLAN 파일) 기반 병렬 기능 개발 시작. 동일한 PLAN 파일로 특정 개발 스킬을 N번 병렬로 실행하여 각각 별도 브랜치에 commit/push하고, 분석 스킬로 결과를 비교합니다.
---

# 병렬 기능 개발 초기화 (pfd-init)

설계서를 기반으로 동일한 기능 개발을 N번 병렬로 실행하는 파이프라인을 시작합니다.

## 목적

같은 PLAN 파일과 개발 스킬을 사용하여 N개의 독립된 브랜치에서 기능을 개발하고, 사용자가 결과를 비교하여 가장 잘 구현된 브랜치를 선택할 수 있도록 합니다.

## 지시사항

### 1단계: 정보 수집

사용자에게 다음을 확인하세요:

```
🚀 병렬 기능 개발을 시작합니다.

다음 정보가 필요합니다:

1. **사용할 개발 스킬 이름을 알려주세요.**
   (예: dev-back-execute-code, implement-feature)

2. **PLAN 파일 경로를 알려주세요.**
   (예: docs/PLAN-FILE.md, FEATURE-PLAN.md)

3. **병렬로 실행할 횟수를 입력하세요. (1~10)**
   (예: 3 → 3개의 독립 브랜치에서 동시 개발)

4. **브랜치 접두사를 입력하세요. (기본값: feature/pfd)**
   (예: feature/pfd → feature/pfd-run-1, feature/pfd-run-2, ...)

5. **개발 완료 후 실행할 분석 스킬 이름을 입력하세요. (없으면 Enter로 스킵)**
   (예: code-review, analyze-implementation)
```

`assets/init-questions.md`의 질문 템플릿을 참고하세요.

### 2단계: 유효성 검사

수집한 정보를 검증하세요:

- **PLAN 파일 존재 확인**: 파일이 실제로 존재하는지 확인
- **git 저장소 확인**: `git rev-parse --git-dir` 실행
- **현재 브랜치 확인**: `git rev-parse --abbrev-ref HEAD` 로 baseBranch 저장
- **병렬 실행 횟수**: 1~10 범위 내인지 확인

오류가 있으면 사용자에게 재입력을 요청하세요.

### 3단계: 설정 파일 저장

`.pfd-config.json`을 프로젝트 루트에 생성하세요:

```json
{
  "devSkill": "입력된 개발 스킬 이름",
  "planFile": "PLAN 파일 경로",
  "runs": 3,
  "branchPrefix": "feature/pfd",
  "baseBranch": "현재 브랜치명",
  "branches": [],
  "worktreePaths": [],
  "analyzeSkill": "입력된 분석 스킬 이름 (없으면 빈 문자열)",
  "analyzeResults": [],
  "status": "initialized",
  "createdAt": "ISO8601 날짜"
}
```

### 4단계: 실행 계획 출력

```
=== 병렬 기능 개발 설정 완료 ===
• 개발 스킬  : {devSkill}
• PLAN 파일  : {planFile}
• 병렬 실행  : {runs}회
• 생성 브랜치 : {branchPrefix}-run-1 ~ {branchPrefix}-run-{runs}
• 기준 브랜치 : {baseBranch}
• 분석 스킬  : {analyzeSkill} (미입력 시 "분석 스킵")
================================

계속 진행하시겠습니까? (Y/N)
```

사용자 확인 후 다음 단계로 진행합니다.

### 5단계: 다음 스킬 호출

`pfd-orchestrate` 스킬을 호출하세요.

## Skill Chaining

- 다음: `pfd-orchestrate` — git worktree 생성 및 병렬 실행 오케스트레이션
