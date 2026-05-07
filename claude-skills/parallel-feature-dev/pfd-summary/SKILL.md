---
name: pfd-summary
description: 병렬 기능 개발 결과 요약. 모든 워커 완료 후 생성된 브랜치 목록과 비교 방법을 안내합니다.
user-invocable: false
allowed-tools: Read, Bash(git branch *) Bash(git log *)
---

# 병렬 기능 개발 결과 요약 (pfd-summary)

모든 병렬 에이전트가 완료된 후 결과를 요약하고 브랜치 비교 방법을 안내합니다.

## 지시사항

### 1. 설정 읽기

`.pfd-config.json`을 읽어 전체 실행 정보를 파악하세요.

### 2. 브랜치 상태 확인

각 브랜치의 최신 커밋을 확인하세요:

```bash
git branch -a | grep "{branchPrefix}"
```

각 브랜치별로:
```bash
git log {branchName} --oneline -3
```

### 3. 결과 요약 출력

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
║      └─ 최신 커밋: {commitHash1} {commitMsg1}
║
║  [2] {branchPrefix}-run-2
║      └─ 최신 커밋: {commitHash2} {commitMsg2}
║
║  [N] {branchPrefix}-run-N
║      └─ 최신 커밋: {commitHashN} {commitMsgN}
╠══════════════════════════════════════════╣
║ 브랜치 비교 방법:
╚══════════════════════════════════════════╝
```

### 4. 브랜치 비교 방법 안내

사용자에게 다음 방법을 안내하세요:

#### GitHub / GitLab에서 PR 비교
```
각 브랜치를 {baseBranch}와 비교하는 Pull Request를 열어 diff를 확인하세요.
```

#### CLI로 브랜치 간 차이 확인
```bash
# 특정 브랜치와 기준 브랜치 비교
git diff {baseBranch}...{branchPrefix}-run-1

# 두 실행 결과 브랜치 간 비교
git diff {branchPrefix}-run-1..{branchPrefix}-run-2

# 변경된 파일 목록만 확인
git diff --name-only {baseBranch}...{branchPrefix}-run-1
```

#### 각 브랜치 체크아웃하여 직접 확인
```bash
git checkout {branchPrefix}-run-1
# 코드 확인 후...
git checkout {branchPrefix}-run-2
```

### 5. 마무리 메시지

```
총 {N}개의 브랜치가 생성되었습니다.
각 브랜치를 직접 비교하여 가장 잘 구현된 결과를 선택하세요.
선택한 브랜치를 {baseBranch}에 병합하려면 해당 브랜치의 PR을 생성하세요.
```
