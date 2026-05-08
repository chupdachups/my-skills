# pfd-init 질문 템플릿

## 수집 항목

| 항목 | 설명 | 예시 |
|------|------|------|
| projectRoot | 프로젝트 루트 절대 경로 | `/workspace` |
| projectBare | 메인 저장소 디렉토리 이름 | `my-app` |
| devSkill | 실행할 개발 스킬 이름 | `dev-back-execute-code` |
| planFile | PLAN 파일 경로 (저장소 루트 기준) | `docs/PLAN-FILE.md` |
| runs | 병렬 실행 횟수 (1~10) | `3` |
| branchPrefix | 브랜치 접두사 | `feature/pfd` |
| analyzeSkill | 실행할 분석 스킬 이름 (선택) | `code-review` |
| analyzeArgs  | 분석 스킬 매개변수 (선택) | `--strict` |

## 유효성 검사 체크리스트

- [ ] projectRoot 디렉토리가 존재하는가?
- [ ] projectRoot/projectBare 디렉토리가 존재하는가?
- [ ] projectRoot/projectBare 가 git 저장소인가?
- [ ] planFile이 저장소 내에 존재하는가?
- [ ] runs가 1~10 사이 숫자인가?

## 디렉토리 구조

```
{projectRoot}/
├── .pfd-config.json                       ← pfd-init이 생성
├── {projectBare}/                         ← 메인 저장소 (branch: baseBranch)
├── {projectBare}-worktree-run-1/          ← worktree 1
├── {projectBare}-worktree-run-2/          ← worktree 2
└── {projectBare}-worktree-run-3/          ← worktree 3
```

## 상태 전이

```
initialized → running → completed → analyzed
 (pfd-init)  (pfd-orchestrate+worker)  (pfd-summary)  (pfd-analyze)
```
