#!/bin/bash
# run-analysis.sh
# N개의 analyze-worker.sh를 백그라운드로 병렬 실행합니다.
#
# 사용법:
#   bash run-analysis.sh <analyze-skill> <plan-file> <runs> <branch-prefix> <repo-name>
#
# 예시:
#   bash run-analysis.sh code-review PLAN-FILE.md 3 feature/pfd my-app

set -e

ANALYZE_SKILL="${1}"
PLAN_FILE="${2}"
RUNS="${3}"
BRANCH_PREFIX="${4:-feature/pfd}"
REPO_NAME="${5}"

if [ -z "$ANALYZE_SKILL" ] || [ -z "$PLAN_FILE" ] || [ -z "$RUNS" ] || [ -z "$REPO_NAME" ]; then
  echo "Error: 필수 인자가 누락되었습니다." >&2
  echo "사용법: bash run-analysis.sh <analyze-skill> <plan-file> <runs> <branch-prefix> <repo-name>" >&2
  exit 1
fi

# PID 파일 저장
ANALYSIS_PID_DIR="/tmp/pfd-analysis-pids-$$"
mkdir -p "$ANALYSIS_PID_DIR"
echo "$ANALYSIS_PID_DIR" > /tmp/pfd-analysis-pid-dir.txt

LOG_FILE="/tmp/pfd-analyze-$(date +%Y%m%d-%H%M%S).log"
echo "=== pfd-analyze 시작: $(date) ===" | tee "$LOG_FILE"
echo "분석 스킬 : $ANALYZE_SKILL" | tee -a "$LOG_FILE"
echo "PLAN 파일 : $PLAN_FILE" | tee -a "$LOG_FILE"
echo "실행 횟수 : $RUNS" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKER_SCRIPT="${SCRIPT_DIR}/analyze-worker.sh"

for i in $(seq 1 "$RUNS"); do
  BRANCH_NAME="${BRANCH_PREFIX}-run-${i}"
  WORKTREE_PATH="../${REPO_NAME}-pfd-run-${i}"
  WORKER_LOG="/tmp/pfd-analysis-worker-${i}-$(date +%Y%m%d-%H%M%S).log"

  echo "▶ 분석 워커 ${i}/${RUNS} 시작: 브랜치=${BRANCH_NAME}" | tee -a "$LOG_FILE"

  bash "$WORKER_SCRIPT" \
    "$WORKTREE_PATH" \
    "$BRANCH_NAME" \
    "$ANALYZE_SKILL" \
    "$PLAN_FILE" \
    "$i" \
    > "$WORKER_LOG" 2>&1 &

  WORKER_PID=$!
  echo "$WORKER_PID" > "${ANALYSIS_PID_DIR}/worker-${i}.pid"
  echo "  PID: $WORKER_PID, 로그: $WORKER_LOG" | tee -a "$LOG_FILE"
done

echo "" | tee -a "$LOG_FILE"
echo "모든 분석 워커가 백그라운드에서 실행 중입니다." | tee -a "$LOG_FILE"
echo "결과 파일: /tmp/pfd-analysis-{N}.json" | tee -a "$LOG_FILE"
