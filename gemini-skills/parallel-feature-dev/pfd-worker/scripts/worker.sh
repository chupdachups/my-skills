#!/bin/bash
# worker.sh
# 단일 worktree에서 Gemini CLI를 실행하여 개발 스킬을 수행하고 commit/push합니다.
#
# 사용법:
#   bash worker.sh <worktree-path> <branch-name> <dev-skill> <plan-file>
#
# 예시:
#   bash worker.sh ../my-app-pfd-run-1 feature/pfd-run-1 dev-back-execute-code PLAN-FILE.md
#
# 이 스크립트는 orchestrate.sh에 의해 백그라운드로 실행됩니다.

set -e

WORKTREE_PATH="${1}"
BRANCH_NAME="${2}"
DEV_SKILL="${3}"
PLAN_FILE="${4}"

WORKER_NUM="${BRANCH_NAME##*-run-}"
LOG_PREFIX="[워커 ${WORKER_NUM}]"

echo "${LOG_PREFIX} 시작: $(date)"
echo "${LOG_PREFIX} Worktree: $WORKTREE_PATH"
echo "${LOG_PREFIX} 브랜치: $BRANCH_NAME"
echo "${LOG_PREFIX} 개발 스킬: $DEV_SKILL"
echo "${LOG_PREFIX} PLAN 파일: $PLAN_FILE"
echo ""

# worktree 경로로 이동
if [ ! -d "$WORKTREE_PATH" ]; then
  echo "${LOG_PREFIX} ERROR: Worktree 경로가 존재하지 않습니다: $WORKTREE_PATH" >&2
  exit 1
fi

cd "$WORKTREE_PATH" || exit 1

# 브랜치 확인
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]; then
  echo "${LOG_PREFIX} ERROR: 예상 브랜치($BRANCH_NAME)와 현재 브랜치($CURRENT_BRANCH)가 다릅니다." >&2
  exit 1
fi

echo "${LOG_PREFIX} 브랜치 확인 완료: $CURRENT_BRANCH"

# PLAN 파일 존재 확인
if [ ! -f "$PLAN_FILE" ]; then
  echo "${LOG_PREFIX} ERROR: PLAN 파일을 찾을 수 없습니다: $PLAN_FILE" >&2
  exit 1
fi

echo "${LOG_PREFIX} PLAN 파일 확인 완료: $PLAN_FILE"
echo ""

# Gemini CLI로 개발 스킬 실행 (비대화형 모드)
echo "${LOG_PREFIX} 개발 스킬 실행 중: /${DEV_SKILL} ${PLAN_FILE}"
echo "---"

# gemini CLI 비대화형 실행
# --non-interactive: 사용자 입력 없이 실행
# -p: 프롬프트 지정
gemini --non-interactive -p "/${DEV_SKILL} ${PLAN_FILE}

중요: PLAN 파일의 내용을 기반으로 기능을 완전히 구현하세요.
모든 파일 생성/수정이 완료된 후 종료하세요."

GEMINI_EXIT=$?

echo "---"
echo "${LOG_PREFIX} 개발 스킬 완료 (종료코드: $GEMINI_EXIT)"

if [ $GEMINI_EXIT -ne 0 ]; then
  echo "${LOG_PREFIX} WARNING: Gemini CLI가 비정상 종료되었습니다. 변경사항을 확인합니다."
fi

# 변경사항 확인
CHANGED=$(git status --porcelain)
if [ -z "$CHANGED" ]; then
  echo "${LOG_PREFIX} 변경사항 없음. 커밋 스킵."
  exit 0
fi

CHANGED_COUNT=$(echo "$CHANGED" | wc -l | tr -d ' ')
echo "${LOG_PREFIX} 변경된 파일 수: $CHANGED_COUNT"

# Commit
echo "${LOG_PREFIX} 커밋 시작..."
git add -A
git commit -m "feat: implement feature from ${PLAN_FILE} [pfd ${BRANCH_NAME}]

- Dev skill: ${DEV_SKILL}
- Plan file: ${PLAN_FILE}
- Branch: ${BRANCH_NAME}

Co-Authored-By: Gemini CLI <noreply@google.com>"

COMMIT_HASH=$(git rev-parse --short HEAD)
echo "${LOG_PREFIX} 커밋 완료: $COMMIT_HASH"

# Push
echo "${LOG_PREFIX} Push 시작: origin/${BRANCH_NAME}"
git push -u origin "${BRANCH_NAME}"

echo ""
echo "=== ${LOG_PREFIX} 완료 ==="
echo "브랜치  : $BRANCH_NAME"
echo "커밋 해시: $COMMIT_HASH"
echo "상태    : 성공 ✓"
echo "완료 시각: $(date)"
echo "===================="
