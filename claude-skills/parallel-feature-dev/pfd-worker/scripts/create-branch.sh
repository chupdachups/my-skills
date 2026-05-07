#!/bin/bash
# create-branch.sh
# 기준 브랜치에서 새 브랜치를 생성하거나 기존 브랜치로 체크아웃합니다.
# 사용법: ./create-branch.sh <branch-name> <base-branch>
# 예시: ./create-branch.sh feature/pfd-run-1 main

set -e

BRANCH_NAME="${1}"
BASE_BRANCH="${2:-main}"

if [ -z "$BRANCH_NAME" ]; then
  echo "Error: branch-name is required" >&2
  exit 1
fi

# 브랜치가 이미 존재하는지 확인
if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
  echo "Branch '${BRANCH_NAME}' already exists. Checking out..."
  git checkout "${BRANCH_NAME}"
else
  echo "Creating new branch '${BRANCH_NAME}' from '${BASE_BRANCH}'..."
  git checkout -b "${BRANCH_NAME}" "${BASE_BRANCH}"
fi

echo "Now on branch: $(git rev-parse --abbrev-ref HEAD)"
