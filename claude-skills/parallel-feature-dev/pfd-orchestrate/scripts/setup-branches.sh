#!/bin/bash
# setup-branches.sh
# 브랜치 목록을 JSON 배열 형태로 출력합니다.
# 사용법: ./setup-branches.sh <branch-prefix> <runs>
# 예시: ./setup-branches.sh feature/pfd 3
# 출력: ["feature/pfd-run-1","feature/pfd-run-2","feature/pfd-run-3"]

set -e

BRANCH_PREFIX="${1:-feature/pfd}"
RUNS="${2:-3}"

if ! [[ "$RUNS" =~ ^[0-9]+$ ]] || [ "$RUNS" -lt 1 ] || [ "$RUNS" -gt 10 ]; then
  echo "Error: runs must be a number between 1 and 10" >&2
  exit 1
fi

branches="["
for i in $(seq 1 "$RUNS"); do
  if [ "$i" -gt 1 ]; then
    branches+=","
  fi
  branches+="\"${BRANCH_PREFIX}-run-${i}\""
done
branches+="]"

echo "$branches"
