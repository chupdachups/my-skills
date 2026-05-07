#!/bin/bash
# analyze-worker.sh
# 단일 worktree에서 Gemini CLI로 분석 스킬을 실행하고 결과를 JSON으로 저장합니다.
#
# 사용법:
#   bash analyze-worker.sh <worktree-path> <branch-name> <analyze-skill> <plan-file> <run-index>
#
# 예시:
#   bash analyze-worker.sh ../my-app-pfd-run-1 feature/pfd-run-1 code-review PLAN-FILE.md 1

set -e

WORKTREE_PATH="${1}"
BRANCH_NAME="${2}"
ANALYZE_SKILL="${3}"
PLAN_FILE="${4}"
RUN_INDEX="${5}"

RESULT_FILE="/tmp/pfd-analysis-${RUN_INDEX}.json"
LOG_PREFIX="[분석 워커 ${RUN_INDEX}]"

echo "${LOG_PREFIX} 시작: $(date)"
echo "${LOG_PREFIX} Worktree: $WORKTREE_PATH"
echo "${LOG_PREFIX} 브랜치  : $BRANCH_NAME"
echo "${LOG_PREFIX} 분석 스킬: $ANALYZE_SKILL"
echo ""

# worktree 경로로 이동
if [ ! -d "$WORKTREE_PATH" ]; then
  echo "${LOG_PREFIX} ERROR: Worktree 경로 없음: $WORKTREE_PATH" >&2
  echo "{\"branch\":\"${BRANCH_NAME}\",\"runIndex\":${RUN_INDEX},\"score\":0,\"summary\":\"worktree 경로 없음\",\"strengths\":[],\"weaknesses\":[\"worktree 경로 없음\"],\"planCoverage\":\"분석 불가\",\"recommendation\":\"제외\"}" > "$RESULT_FILE"
  exit 1
fi

cd "$WORKTREE_PATH" || exit 1

# 브랜치 확인
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "${LOG_PREFIX} 현재 브랜치: $CURRENT_BRANCH"

# PLAN 파일 확인
if [ ! -f "$PLAN_FILE" ]; then
  echo "${LOG_PREFIX} WARNING: PLAN 파일 없음: $PLAN_FILE" >&2
fi

# Gemini CLI로 분석 스킬 실행
# 분석 결과를 JSON 형식으로 반환하도록 프롬프트 구성
ANALYSIS_PROMPT="/${ANALYZE_SKILL} ${PLAN_FILE}

분석 완료 후 반드시 다음 JSON 형식으로만 결과를 출력하세요 (다른 텍스트 없이):
{
  \"branch\": \"${BRANCH_NAME}\",
  \"runIndex\": ${RUN_INDEX},
  \"score\": 0~100 숫자,
  \"summary\": \"한 줄 요약\",
  \"strengths\": [\"강점1\", \"강점2\"],
  \"weaknesses\": [\"약점1\", \"약점2\"],
  \"planCoverage\": \"PLAN 요구사항 충족도 설명\",
  \"recommendation\": \"선택 여부 의견\"
}"

echo "${LOG_PREFIX} 분석 실행 중..."
echo "---"

ANALYSIS_OUTPUT=$(gemini --non-interactive -p "$ANALYSIS_PROMPT" 2>&1)
GEMINI_EXIT=$?

echo "---"
echo "${LOG_PREFIX} 분석 완료 (종료코드: $GEMINI_EXIT)"

# JSON 추출 시도
JSON_OUTPUT=$(echo "$ANALYSIS_OUTPUT" | grep -o '{.*}' | tail -1)

if [ -n "$JSON_OUTPUT" ]; then
  echo "$JSON_OUTPUT" > "$RESULT_FILE"
  echo "${LOG_PREFIX} 결과 저장: $RESULT_FILE"
else
  # JSON 추출 실패 시 기본 결과 저장
  echo "${LOG_PREFIX} WARNING: JSON 추출 실패. 원본 출력을 summary로 저장합니다."
  ESCAPED_OUTPUT=$(echo "$ANALYSIS_OUTPUT" | head -5 | tr '"' "'" | tr '\n' ' ')
  echo "{\"branch\":\"${BRANCH_NAME}\",\"runIndex\":${RUN_INDEX},\"score\":50,\"summary\":\"${ESCAPED_OUTPUT}\",\"strengths\":[],\"weaknesses\":[\"JSON 파싱 실패\"],\"planCoverage\":\"수동 확인 필요\",\"recommendation\":\"수동 검토\"}" > "$RESULT_FILE"
fi

echo ""
echo "=== ${LOG_PREFIX} 완료 ==="
echo "결과 파일: $RESULT_FILE"
echo "완료 시각: $(date)"
