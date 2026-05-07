#!/bin/bash
# wait-workers.sh
# 모든 pfd 워커 프로세스가 완료될 때까지 대기하고 결과를 보고합니다.
#
# 사용법:
#   bash wait-workers.sh <runs>
#
# 예시:
#   bash wait-workers.sh 3

RUNS="${1:-3}"
PID_DIR_FILE="/tmp/pfd-pid-dir.txt"

if [ ! -f "$PID_DIR_FILE" ]; then
  echo "Error: PID 디렉토리 파일을 찾을 수 없습니다. orchestrate.sh를 먼저 실행하세요." >&2
  exit 1
fi

PID_DIR=$(cat "$PID_DIR_FILE")

echo "=== 워커 완료 대기 중 ==="
echo "PID 디렉토리: $PID_DIR"
echo ""

declare -A WORKER_STATUS
TOTAL_SUCCESS=0
TOTAL_FAIL=0

for i in $(seq 1 "$RUNS"); do
  PID_FILE="${PID_DIR}/worker-${i}.pid"

  if [ ! -f "$PID_FILE" ]; then
    echo "[워커 ${i}] PID 파일 없음 - 스킵"
    WORKER_STATUS[$i]="MISSING"
    continue
  fi

  PID=$(cat "$PID_FILE")
  echo -n "[워커 ${i}] PID=${PID} 대기 중..."

  if wait "$PID" 2>/dev/null; then
    echo " 완료 ✓"
    WORKER_STATUS[$i]="SUCCESS"
    TOTAL_SUCCESS=$((TOTAL_SUCCESS + 1))
  else
    EXIT_CODE=$?
    echo " 실패 ✗ (종료코드: ${EXIT_CODE})"
    WORKER_STATUS[$i]="FAILED:${EXIT_CODE}"
    TOTAL_FAIL=$((TOTAL_FAIL + 1))
  fi
done

echo ""
echo "=== 최종 결과 ==="
echo "성공: ${TOTAL_SUCCESS}/${RUNS}"
echo "실패: ${TOTAL_FAIL}/${RUNS}"
echo ""

for i in $(seq 1 "$RUNS"); do
  STATUS="${WORKER_STATUS[$i]}"
  if [[ "$STATUS" == "SUCCESS" ]]; then
    echo "  [${i}] ✓ 성공"
  elif [[ "$STATUS" == FAILED* ]]; then
    echo "  [${i}] ✗ 실패 - 로그 확인: /tmp/pfd-worker-${i}-*.log"
  else
    echo "  [${i}] ? 알 수 없음"
  fi
done

# 정리
rm -rf "$PID_DIR"
rm -f "$PID_DIR_FILE"

if [ "$TOTAL_FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
