#!/bin/bash
# commit-push.sh
# 변경사항을 스테이징하고 커밋한 후 원격으로 push합니다.
# 사용법: ./commit-push.sh <plan-file> <dev-skill> <branch-name>
# 예시: ./commit-push.sh PLAN-FILE.md dev-back-execute-code feature/pfd-run-1

set -e

PLAN_FILE="${1:-PLAN-FILE.md}"
DEV_SKILL="${2:-unknown-skill}"
BRANCH_NAME="${3:-$(git rev-parse --abbrev-ref HEAD)}"

# 변경사항 확인
CHANGED=$(git status --porcelain)
if [ -z "$CHANGED" ]; then
  echo "No changes to commit."
  exit 0
fi

# 변경파일 수 출력
CHANGED_COUNT=$(echo "$CHANGED" | wc -l | tr -d ' ')
echo "Staging ${CHANGED_COUNT} changed file(s)..."

# 모든 변경사항 스테이징
git add -A

# 커밋
git commit -m "feat: implement feature from ${PLAN_FILE} [pfd ${BRANCH_NAME}]

- Dev skill: ${DEV_SKILL}
- Plan file: ${PLAN_FILE}
- Branch: ${BRANCH_NAME}

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

COMMIT_HASH=$(git rev-parse --short HEAD)
echo "Committed: ${COMMIT_HASH}"

# Push
echo "Pushing branch '${BRANCH_NAME}' to origin..."
git push -u origin "${BRANCH_NAME}"

echo "Done. Branch '${BRANCH_NAME}' pushed successfully."
echo "COMMIT_HASH=${COMMIT_HASH}"
