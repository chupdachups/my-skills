#!/bin/bash
# worker.sh
# 지정된 worktree 절대 경로에서 Gemini CLI로 개발 스킬을 실행하고 commit/push합니다.
#
# 사용법:
#   bash worker.sh <worktree-path> <branch-name> <dev-skill> <plan-file>
#
# 예시:
#   bash worker.sh /workspace/my-app-worktree-run-1 feature/pfd-run-1 dev-back-execute-code docs/PLAN.md

set -e

WORKTREE_PATH="${1}"
BRANCH_NAME="${2}"
DEV_SKILL="${3}"
PLAN_FILE="${4}"

WORKER_NUM="${BRANCH_NAME##*-run-}"
LOG_PREFIX="[워커 ${WORKER_NUM}]"

echo "${LOG_PREFIX} 시작: $(date)"
echo "${LOG_PREFIX} Worktree: $WORKTREE_PATH"
echo "${LOG_PREFIX} 브랜치  : $BRANCH_NAME"
echo "${LOG_PREFIX} 개발 스킬: $DEV_SKILL"
echo "${LOG_PREFIX} PLAN 파일: $PLAN_FILE"
echo ""

# worktree 경로 확인
if [ ! -d "$WORKTREE_PATH" ]; then
  echo "${LOG_PREFIX} ERROR: Worktree 경로 없음: $WORKTREE_PATH" >&2
  exit 1
fi

# worktree 진입
cd "$WORKTREE_PATH" || exit 1

# 브랜치 확인
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]; then
  echo "${LOG_PREFIX} ERROR: 예상 브랜치($BRANCH_NAME)와 현재 브랜치($CURRENT_BRANCH)가 다릅니다." >&2
  exit 1
fi
echo "${LOG_PREFIX} 브랜치 확인: $CURRENT_BRANCH ✓"

# PLAN 파일 확인
if [ ! -f "$PLAN_FILE" ]; then
  echo "${LOG_PREFIX} ERROR: PLAN 파일 없음: $PLAN_FILE" >&2
  exit 1
fi
echo "${LOG_PREFIX} PLAN 파일 확인: $PLAN_FILE ✓"
echo ""

# Gemini CLI로 개발 스킬 실행
echo "${LOG_PREFIX} 개발 스킬 실행 중..."
echo "---"

gemini --non-interactive -p "/${DEV_SKILL} ${PLAN_FILE}

[브랜치 독립성 규칙 - 반드시 준수]
- 현재 worktree(${WORKTREE_PATH}) 외의 다른 pfd worktree를 참조하지 마세요.
- 현재 브랜치(${BRANCH_NAME}) 외의 다른 pfd 브랜치를 checkout/diff/read하지 마세요.
- 개발이 완료되지 않으면 다른 worktree 코드로 채우지 말고 그대로 종료하세요.
- 허용 참조: 기준 브랜치 코드, PLAN 파일, 직접 생성한 코드만 사용하세요.

PLAN 파일의 내용을 기반으로 기능을 완전히 구현하세요.
모든 파일 생성/수정이 완료된 후 종료하세요."

GEMINI_EXIT=$?
echo "---"
echo "${LOG_PREFIX} 개발 스킬 완료 (종료코드: $GEMINI_EXIT)"

# 변경사항 확인
CHANGED=$(git status --porcelain)
if [ -z "$CHANGED" ]; then
  echo "${LOG_PREFIX} 변경사항 없음. 개발 스킬이 완료되지 않은 것으로 판단합니다."
  echo "${LOG_PREFIX} 다른 worktree를 참조하지 않고 종료합니다."
  exit 1
fi

CHANGED_COUNT=$(echo "$CHANGED" | wc -l | tr -d ' ')
echo "${LOG_PREFIX} 변경된 파일 수: $CHANGED_COUNT"

# Commit
echo "${LOG_PREFIX} 커밋 시작..."
git add -A
git commit -m "feat: implement from ${PLAN_FILE} [pfd run-${WORKER_NUM}]

- Dev skill: ${DEV_SKILL}
- Plan file: ${PLAN_FILE}
- Branch: ${BRANCH_NAME}
- Worktree: ${WORKTREE_PATH}

Co-Authored-By: Gemini CLI <noreply@google.com>"

COMMIT_HASH=$(git rev-parse --short HEAD)
echo "${LOG_PREFIX} 커밋 완료: $COMMIT_HASH"

# Push
echo "${LOG_PREFIX} Push: origin/${BRANCH_NAME}"
git push -u origin "${BRANCH_NAME}"

echo ""
echo "=== ${LOG_PREFIX} 완료 ==="
echo "Worktree : $WORKTREE_PATH"
echo "브랜치   : $BRANCH_NAME"
echo "커밋 해시 : $COMMIT_HASH"
echo "상태     : 성공 ✓"
echo "완료 시각 : $(date)"
