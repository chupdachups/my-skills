# pfd-init 질문 템플릿

## 필수 수집 항목

| 항목 | 설명 | 예시 |
|------|------|------|
| devSkill | 실행할 개발 스킬 이름 | `dev-back-execute-code` |
| planFile | PLAN 파일 경로 | `docs/PLAN-FILE.md` |
| runs | 병렬 실행 횟수 (1~10) | `3` |
| branchPrefix | 브랜치 접두사 | `feature/pfd` |
| analyzeSkill | 실행할 분석 스킬 이름 (선택) | `code-review` |

## 유효성 검사 체크리스트

- [ ] devSkill이 빈 문자열이 아닌가?
- [ ] planFile이 실제로 존재하는가?
- [ ] runs가 1~10 사이 숫자인가?
- [ ] git 저장소 안에 있는가?
- [ ] 현재 브랜치가 clean 상태인가? (uncommitted changes 없는가?)

## 브랜치 명명 규칙

- 패턴: `{branchPrefix}-run-{N}`
- 예시 (branchPrefix=feature/pfd, runs=3):
  - `feature/pfd-run-1`
  - `feature/pfd-run-2`
  - `feature/pfd-run-3`

## Worktree 경로 규칙

- 패턴: `../{repo-name}-pfd-run-{N}`
- 예시 (repo=my-app, runs=3):
  - `../my-app-pfd-run-1`
  - `../my-app-pfd-run-2`
  - `../my-app-pfd-run-3`

## 상태 전이

```
initialized → orchestrating → running → completed → analyzed
(pfd-init)   (pfd-orchestrate)  (pfd-worker)  (pfd-summary)  (pfd-analyze)
```
