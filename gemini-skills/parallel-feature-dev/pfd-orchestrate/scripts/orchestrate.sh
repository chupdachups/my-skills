#!/bin/bash
# orchestrate.sh
# N개의 pfd-worker를 백그라운드로 병렬 실행합니다.
#
# 사용법:
#   bash orchestrate.sh <dev-skill> <plan-file> <runs> <branch-prefix> <repo-name>
#
# 예시:
#   bash orchestrate.sh dev-back-execute-code PLAN-FILE.md 3 feature/pfd my-app

set -e

DEV_SKILL="${1}"
PLAN_FILE="${2}"
RUNS="${3}"
BRANCH_PREFIX="${4:-feature/pfd}"
REPO_NAME="${5}"

if [ -z "$DEV_SKILL" ] || [ -z "$PLAN_FILE" ] || [ -z "$RUNS" ] || [ -z "$REPO_NAME" ]; then
  echo "Error: 필수 인자가 누락되었습니다." >&2
  echo "사용법: bash orchestrate.sh <dev-skill> <plan-file> <runs> <branch-prefix> <repo-name>" >&2
  exit 1
fi

# PID 파일 저장 디렉토리
PID_DIR="/tmp/pfd-pids-$$"
mkdir -p "$PID_DIR"
echo "$PID_DIR" > /tmp/pfd-pid-dir.txt

# 로그 파일 기록
LOG_FILE="/tmp/pfd-orchestrate-$(date +%Y%m%d-%H%M%S).log"
echo "=== pfd-orchestrate 시작: $(date) ===" | tee "$LOG_FILE"
echo "Dev Skill  : $DEV_SKILL" | tee -a "$LOG_FILE"
echo "Plan File  : $PLAN_FILE" | tee -a "$LOG_FILE"
echo "Runs       : $RUNS" | tee -a "$LOG_FILE"
echo "Branch Prefix: $BRANCH_PREFIX" | tee -a "$LOG_FILE"
echo "Repo Name  : $REPO_NAME" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKER_SCRIPT="$(dirname "$SCRIPT_DIR")/pfd-worker/scripts/worker.sh"

# 각 워커를 백그라운드로 실행
for i in $(seq 1 "$RUNS"); do
  BRANCH_NAME="${BRANCH_PREFIX}-run-${i}"
  WORKTREE_PATH="../${REPO_NAME}-pfd-run-${i}"
  WORKER_LOG="/tmp/pfd-worker-${i}-$(date +%Y%m%d-%H%M%S).log"

  echo "▶ 워커 ${i}/${RUNS} 시작: 브랜치=${BRANCH_NAME}" | tee -a "$LOG_FILE"

  bash "$WORKER_SCRIPT" \
    "$WORKTREE_PATH" \
    "$BRANCH_NAME" \
    "$DEV_SKILL" \
    "$PLAN_FILE" \
    > "$WORKER_LOG" 2>&1 &

  WORKER_PID=$!
  echo "$WORKER_PID" > "${PID_DIR}/worker-${i}.pid"
  echo "  PID: $WORKER_PID, 로그: $WORKER_LOG" | tee -a "$LOG_FILE"
done

echo "" | tee -a "$LOG_FILE"
echo "모든 워커가 백그라운드에서 실행 중입니다." | tee -a "$LOG_FILE"
echo "PID 파일 위치: $PID_DIR" | tee -a "$LOG_FILE"
echo "로그 모니터링: tail -f /tmp/pfd-worker-*.log" | tee -a "$LOG_FILE"
