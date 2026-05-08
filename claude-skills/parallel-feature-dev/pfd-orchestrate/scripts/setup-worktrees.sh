#!/bin/bash
# setup-worktrees.sh
# 메인 저장소에서 N개의 git worktree를 생성합니다.
#
# 사용법:
#   bash setup-worktrees.sh <bare-repo-path> <project-root> <project-bare> <runs> <branch-prefix> <base-branch>
#
# 예시:
#   bash setup-worktrees.sh /workspace/my-app /workspace my-app 3 feature/pfd main

set -e

BARE_REPO_PATH="${1}"
PROJECT_ROOT="${2}"
PROJECT_BARE="${3}"
RUNS="${4:-3}"
BRANCH_PREFIX="${5:-feature/pfd}"
BASE_BRANCH="${6:-main}"

if [ -z "$BARE_REPO_PATH" ] || [ -z "$PROJECT_ROOT" ] || [ -z "$PROJECT_BARE" ]; then
  echo "Error: 필수 인자가 누락되었습니다." >&2
  echo "사용법: bash setup-worktrees.sh <bare-repo-path> <project-root> <project-bare> <runs> <branch-prefix> <base-branch>" >&2
  exit 1
fi

echo "=== Worktree 생성 시작 ==="
echo "메인 저장소: $BARE_REPO_PATH"
echo "브랜치 접두사: $BRANCH_PREFIX"
echo "기준 브랜치: $BASE_BRANCH"
echo "생성 횟수: $RUNS"
echo ""

CREATED=0
SKIPPED=0

for i in $(seq 1 "$RUNS"); do
  BRANCH_NAME="${BRANCH_PREFIX}-run-${i}"
  WORKTREE_PATH="${PROJECT_ROOT}/${PROJECT_BARE}-worktree-run-${i}"

  echo -n "  [${i}/${RUNS}] ${WORKTREE_PATH}  (브랜치: ${BRANCH_NAME}) ... "

  # 이미 존재하는 worktree 확인
  if [ -d "$WORKTREE_PATH" ]; then
    echo "이미 존재, 스킵"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # worktree 생성
  git -C "$BARE_REPO_PATH" worktree add \
    -b "$BRANCH_NAME" \
    "$WORKTREE_PATH" \
    "$BASE_BRANCH" 2>&1

  echo "생성 완료 ✓"
  CREATED=$((CREATED + 1))
done

echo ""
echo "=== Worktree 생성 완료 ==="
echo "생성: ${CREATED}개, 스킵: ${SKIPPED}개"
echo ""

# 최종 목록 확인
echo "현재 Worktree 목록:"
git -C "$BARE_REPO_PATH" worktree list
