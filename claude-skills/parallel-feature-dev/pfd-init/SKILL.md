---
name: pfd-init
description: 설계서(PLAN 파일) 기반 병렬 기능 개발 시작. 동일한 PLAN 파일로 특정 개발 스킬을 N번 병렬 실행하여 각각 별도 브랜치에 commit/push하고, 분석 스킬로 결과를 비교합니다.
user-invocable: true
allowed-tools: Read, Write, Bash(git branch *) Bash(git rev-parse *) Bash(git status *)
argument-hint: "[dev-skill] [plan-file] [runs] [analyze-skill]"
---

# 병렬 기능 개발 초기화 (pfd-init)

설계서를 기반으로 동일한 기능 개발을 N번 병렬로 실행하는 파이프라인을 시작합니다.

## 개요

이 skill은 병렬 기능 개발 파이프라인의 진입점입니다.
자세한 설정 스키마는 [references/config-schema.md](references/config-schema.md)를 참조하세요.

## 지시사항

### 1. 인자 파싱

`$ARGUMENTS`가 제공된 경우 아래 순서로 파싱하세요:
- 첫 번째 토큰 → 개발 스킬 이름 (예: `dev-back-execute-code`)
- 두 번째 토큰 → PLAN 파일 경로 (예: `PLAN-FILE.md`)
- 세 번째 토큰 → 병렬 실행 횟수 (숫자, 예: `3`)
- 네 번째 토큰 → 분석 스킬 이름 (선택, 예: `code-review`)

### 2. 누락 정보 수집

파싱되지 않은 항목에 대해 사용자에게 질문하세요:

| 항목 | 질문 | 예시 |
|------|------|------|
| 개발 스킬 이름 | "실행할 개발 스킬 이름을 입력하세요 (예: dev-back-execute-code):" | `dev-back-execute-code` |
| PLAN 파일 경로 | "사용할 PLAN 파일 경로를 입력하세요:" | `docs/PLAN-FILE.md` |
| 병렬 실행 횟수 | "병렬로 실행할 횟수를 입력하세요 (1~10):" | `3` |
| 브랜치 접두사 | "생성할 브랜치 접두사를 입력하세요 (기본값: feature/pfd):" | `feature/pfd` |
| 분석 스킬 이름 | "개발 완료 후 실행할 분석 스킬 이름을 입력하세요 (없으면 Enter로 스킵):" | `code-review` |

### 3. 유효성 검사

- 병렬 실행 횟수는 1 이상 10 이하여야 합니다.
- PLAN 파일이 현재 디렉토리에 존재하는지 Read 도구로 확인하세요.
- git 저장소인지 `git rev-parse --git-dir` 명령으로 확인하세요.
- 현재 브랜치 이름을 `git rev-parse --abbrev-ref HEAD`로 확인하고 baseBranch로 저장하세요.

### 4. 설정 파일 저장

`.pfd-config.json`을 프로젝트 루트에 생성하세요:

```json
{
  "devSkill": "dev-back-execute-code",
  "planFile": "docs/PLAN-FILE.md",
  "runs": 3,
  "branchPrefix": "feature/pfd",
  "baseBranch": "main",
  "branches": [],
  "analyzeSkill": "code-review",
  "analyzeResults": [],
  "status": "initialized",
  "createdAt": "ISO날짜"
}
```

`analyzeSkill`이 입력되지 않은 경우 빈 문자열(`""`)로 저장하세요.

### 5. 실행 요약 출력

수집된 정보를 사용자에게 다음 형식으로 표시하세요:

```
=== 병렬 기능 개발 설정 ===
• 개발 스킬  : {devSkill}
• PLAN 파일  : {planFile}
• 병렬 실행  : {runs}회
• 브랜치 접두사: {branchPrefix}-run-1 ~ {branchPrefix}-run-{runs}
• 기준 브랜치: {baseBranch}
• 분석 스킬  : {analyzeSkill} (미입력 시 "분석 스킵")
===========================
```

### 6. 다음 skill 호출

반드시 `/pfd-orchestrate`를 호출하세요.

## 예시

```
사용자: /pfd-init dev-back-execute-code PLAN-FILE.md 3

Claude: === 병렬 기능 개발 설정 ===
• 개발 스킬  : dev-back-execute-code
• PLAN 파일  : PLAN-FILE.md
• 병렬 실행  : 3회
• 브랜치 접두사: feature/pfd-run-1 ~ feature/pfd-run-3
• 기준 브랜치: main
===========================
설정이 완료되었습니다. 병렬 실행을 시작합니다.
[/pfd-orchestrate 호출]
```
