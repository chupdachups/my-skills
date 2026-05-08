---
name: pfd-init
description: 설계서(PLAN 파일) 기반 병렬 기능 개발 시작. projectRoot와 projectBare를 기반으로 git worktree를 N개 생성하여 독립 공간에서 병렬 개발합니다.
---

# 병렬 기능 개발 초기화 (pfd-init)

git worktree 기반으로 독립된 개발 공간을 구성하고 병렬 기능 개발 파이프라인을 시작합니다.

## 목적

같은 PLAN 파일과 개발 스킬을 사용하여 N개의 독립된 worktree/브랜치에서 기능을 개발하고,
사용자가 결과를 비교하여 가장 잘 구현된 브랜치를 선택할 수 있도록 합니다.

## 지시사항

### 1단계: 정보 수집

사용자에게 다음을 확인하세요. `assets/init-questions.md`의 질문 템플릿을 참고하세요.

```
🚀 병렬 기능 개발을 시작합니다.

다음 정보가 필요합니다:

1. **프로젝트 루트 디렉토리 경로를 알려주세요.**
   (예: /workspace)

2. **메인 저장소 디렉토리 이름을 알려주세요.**
   (예: my-app → /workspace/my-app 에 위치)

3. **사용할 개발 스킬 이름을 알려주세요.**
   (예: dev-back-execute-code)

4. **PLAN 파일 경로를 알려주세요. (저장소 루트 기준 상대 경로)**
   (예: docs/PLAN-FILE.md)

5. **병렬로 실행할 횟수를 입력하세요. (1~10)**
   (예: 3)

6. **브랜치 접두사를 입력하세요. (기본값: feature/pfd)**
   (예: feature/pfd → feature/pfd-run-1, feature/pfd-run-2, ...)

7. **개발 완료 후 실행할 분석 스킬 이름을 입력하세요. (없으면 Enter로 스킵)**
   (예: code-review)

8. **분석 스킬에 전달할 매개변수를 입력하세요. (없으면 Enter로 스킵)**
   (예: --strict)
```

### 2단계: 유효성 검사

수집한 정보를 검증하세요:

```bash
# 디렉토리 확인
ls {projectRoot}
ls {projectRoot}/{projectBare}

# git 저장소 확인
git -C {projectRoot}/{projectBare} rev-parse --git-dir

# 기준 브랜치 확인 (결과를 baseBranch로 저장)
git -C {projectRoot}/{projectBare} rev-parse --abbrev-ref HEAD

# PLAN 파일 확인
ls {projectRoot}/{projectBare}/{planFile}
```

오류가 있으면 사용자에게 재입력을 요청하세요.

### 3단계: 설정 파일 저장

`{projectRoot}/.pfd-config.json`을 생성하세요:

```json
{
  "projectRoot": "/workspace",
  "projectBare": "my-app",
  "bareRepoPath": "/workspace/my-app",
  "devSkill": "dev-back-execute-code",
  "planFile": "docs/PLAN-FILE.md",
  "runs": 3,
  "branchPrefix": "feature/pfd",
  "baseBranch": "main",
  "branches": [],
  "worktreePaths": [],
  "analyzeSkill": "code-review",
  "analyzeArgs": "--strict",
  "analyzeResults": [],
  "status": "initialized",
  "createdAt": "ISO8601 날짜"
}
```

`analyzeSkill`, `analyzeArgs`가 입력되지 않은 경우 빈 문자열(`""`)로 저장하세요.

### 4단계: 실행 계획 출력

```
=== 병렬 기능 개발 설정 완료 ===
• 프로젝트 루트 : {projectRoot}
• 메인 저장소  : {projectRoot}/{projectBare}  [{baseBranch}]
• 개발 스킬    : {devSkill}
• PLAN 파일    : {planFile}
• 병렬 실행    : {runs}회
• 생성 Worktree:
    {projectRoot}/{projectBare}-worktree-run-1  →  {branchPrefix}-run-1
    {projectRoot}/{projectBare}-worktree-run-2  →  {branchPrefix}-run-2
    ...
• 분석 스킬    : {analyzeSkill} (미입력 시 "분석 스킵")
• 분석 매개변수 : {analyzeArgs}
================================

계속 진행하시겠습니까? (Y/N)
```

사용자 확인 후 다음 단계로 진행합니다.

### 5단계: 다음 스킬 호출

`pfd-orchestrate` 스킬을 호출하세요.

## Skill Chaining

- 다음: `pfd-orchestrate` — git worktree 생성 및 병렬 실행
