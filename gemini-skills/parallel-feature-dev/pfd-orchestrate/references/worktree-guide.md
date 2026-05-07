# Git Worktree 가이드

## 개요

git worktree는 하나의 저장소에서 여러 브랜치를 동시에 체크아웃할 수 있게 해주는 기능입니다.
pfd-orchestrate에서 병렬 실행을 위해 N개의 worktree를 생성합니다.

## 주요 명령어

### Worktree 생성

```bash
# 새 브랜치를 만들면서 worktree 생성
git worktree add -b <new-branch> <path> <base-branch>

# 예시
git worktree add -b feature/pfd-run-1 ../my-app-pfd-run-1 main
```

### Worktree 목록 확인

```bash
git worktree list
```

출력 예시:
```
/Users/user/my-app          abc1234 [main]
/Users/user/my-app-pfd-run-1  def5678 [feature/pfd-run-1]
/Users/user/my-app-pfd-run-2  ghi9012 [feature/pfd-run-2]
```

### Worktree 제거

```bash
# 작업 완료 후 worktree 정리
git worktree remove ../my-app-pfd-run-1

# 강제 제거 (변경사항 있어도)
git worktree remove --force ../my-app-pfd-run-1

# 불필요한 worktree 참조 정리
git worktree prune
```

## 주의사항

- 같은 브랜치를 두 개의 worktree에서 동시에 체크아웃할 수 없습니다.
- Worktree 경로는 주 저장소와 다른 디렉토리여야 합니다.
- 주 저장소의 `.git` 디렉토리를 공유하므로 git 히스토리는 동일합니다.
- 각 worktree는 독립된 작업 디렉토리를 가집니다.

## 병렬 실행 패턴

```
my-app/                    (main 브랜치 - 원본)
├── .git/
├── src/
└── .pfd-config.json

my-app-pfd-run-1/          (feature/pfd-run-1 브랜치 - worktree 1)
├── src/
└── .pfd-config.json

my-app-pfd-run-2/          (feature/pfd-run-2 브랜치 - worktree 2)
├── src/
└── .pfd-config.json

my-app-pfd-run-3/          (feature/pfd-run-3 브랜치 - worktree 3)
├── src/
└── .pfd-config.json
```
