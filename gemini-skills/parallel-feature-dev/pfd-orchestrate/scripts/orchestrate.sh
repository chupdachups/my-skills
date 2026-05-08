#!/bin/bash
# orchestrate.sh
# 각 worktree에서 worker.sh를 백그라운드로 병렬 실행합니다.
#
# 사용법:
#   bash orchestrate.sh <project-root> <project-bare> <dev-skill> <plan-file> <runs> <branch-prefix>
#
# 예시:
#   bash orchestrate.sh /workspace my-app dev-back-execute-code docs/PLAN.md 3 feature/pfd

set -e

PROJECT_ROOT="${1}"
PROJECT_BARE="${2}"
DEV_SKILL="${3}"
PLAN_FILE="${4}"
RUNS="${5:-3}"
BRANCH_PREFIX="${6:-feature/pfd}"

if [ -z "$PROJECT_ROOT" ] || [ -z "$PROJECT_BARE" ] || [ -z "$DEV_SKILL" ] || [ -z "$PLAN_FILE" ]; then
  echo "Error: 필수 인자가 누락되었습니다." >&2
  exit 1
fi

PID_DIR="/tmp/pfd-pids-$$"
mkdir -p "$PID_DIR"
echo "$PID_DIR" > /tmp/pfd-pid-dir.txt

LOG_FILE="/tmp/pfd-orchestrate-$(date +%Y%m%d-%H%M%S).log"
echo "=== pfd-orchestrate 시작: $(date) ===" | tee "$LOG_FILE"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKER_SCRIPT="$(dirname "$SCRIPT_DIR")/pfd-worker/scripts/worker.sh"

for i in $(seq 1 "$RUNS"); do
  BRANCH_NAME="${BRANCH_PREFIX}-run-${i}"
  WORKTREE_PATH="${PROJECT_ROOT}/${PROJECT_BARE}-worktree-run-${i}"
  WORKER_LOG="/tmp/pfd-worker-${i}-$(date +%Y%m%d-%H%M%S).log"

  echo "▶ 워커 ${i}/${RUNS}: ${WORKTREE_PATH}" | tee -a "$LOG_FILE"

  bash "$WORKER_SCRIPT" \
    "$WORKTREE_PATH" \
    "$BRANCH_NAME" \
    "$DEV_SKILL" \
    "$PLAN_FILE" \
    > "$WORKER_LOG" 2>&1 &

  WORKER_PID=$!
  echo "$WORKER_PID" > "${PID_DIR}/worker-${i}.pid"
  echo "  PID: $WORKER_PID  로그: $WORKER_LOG" | tee -a "$LOG_FILE"
done

echo "" | tee -a "$LOG_FILE"
echo "모든 워커 실행 중. PID 디렉토리: $PID_DIR" | tee -a "$LOG_FILE"
echo "로그 확인: tail -f /tmp/pfd-worker-*.log"
