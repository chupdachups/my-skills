#!/bin/bash
# wait-analysis.sh
# 모든 분석 워커가 완료될 때까지 대기하고 결과를 집계합니다.
#
# 사용법:
#   bash wait-analysis.sh <runs>
#
# 예시:
#   bash wait-analysis.sh 3

RUNS="${1:-3}"
PID_DIR_FILE="/tmp/pfd-analysis-pid-dir.txt"

if [ ! -f "$PID_DIR_FILE" ]; then
  echo "Error: PID 디렉토리 파일 없음. run-analysis.sh를 먼저 실행하세요." >&2
  exit 1
fi

PID_DIR=$(cat "$PID_DIR_FILE")

echo "=== 분석 워커 완료 대기 ==="
TOTAL_SUCCESS=0
TOTAL_FAIL=0

for i in $(seq 1 "$RUNS"); do
  PID_FILE="${PID_DIR}/worker-${i}.pid"

  if [ ! -f "$PID_FILE" ]; then
    echo "[분석 워커 ${i}] PID 파일 없음 - 스킵"
    TOTAL_FAIL=$((TOTAL_FAIL + 1))
    continue
  fi

  PID=$(cat "$PID_FILE")
  echo -n "[분석 워커 ${i}] PID=${PID} 대기 중..."

  if wait "$PID" 2>/dev/null; then
    echo " 완료 ✓"
    TOTAL_SUCCESS=$((TOTAL_SUCCESS + 1))
  else
    echo " 실패 ✗"
    TOTAL_FAIL=$((TOTAL_FAIL + 1))
  fi
done

echo ""
echo "=== 분석 결과 파일 ==="
for i in $(seq 1 "$RUNS"); do
  RESULT_FILE="/tmp/pfd-analysis-${i}.json"
  if [ -f "$RESULT_FILE" ]; then
    echo "  [${i}] $RESULT_FILE ✓"
  else
    echo "  [${i}] $RESULT_FILE ✗ (없음)"
  fi
done

echo ""
echo "성공: ${TOTAL_SUCCESS}/${RUNS}"

rm -rf "$PID_DIR"
rm -f "$PID_DIR_FILE"
