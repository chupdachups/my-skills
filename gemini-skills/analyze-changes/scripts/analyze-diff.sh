#!/bin/bash

# analyze-diff.sh
# 코드 변경사항을 분석하는 스크립트

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 사용법
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --source    Source branch (default: HEAD)"
    echo "  -t, --target    Target branch (default: main)"
    echo "  -f, --files     Specific files to analyze (comma-separated)"
    echo "  -o, --output    Output file path (default: .code-review-analysis.json)"
    echo "  -h, --help      Show this help message"
    exit 1
}

# 기본값
SOURCE_BRANCH="HEAD"
TARGET_BRANCH="main"
FILES=""
OUTPUT_FILE=".code-review-analysis.json"

# 인자 파싱
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--source)
            SOURCE_BRANCH="$2"
            shift 2
            ;;
        -t|--target)
            TARGET_BRANCH="$2"
            shift 2
            ;;
        -f|--files)
            FILES="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

echo -e "${BLUE}=== Code Change Analyzer ===${NC}"
echo ""

# Git 저장소 확인
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not a git repository${NC}"
    exit 1
fi

# 변경 파일 목록 수집
echo -e "${YELLOW}Collecting changed files...${NC}"

if [ -n "$FILES" ]; then
    # 특정 파일 분석
    IFS=',' read -ra FILE_ARRAY <<< "$FILES"
    CHANGED_FILES=("${FILE_ARRAY[@]}")
else
    # 브랜치 비교
    mapfile -t CHANGED_FILES < <(git diff --name-only "$TARGET_BRANCH"..."$SOURCE_BRANCH" 2>/dev/null || git diff --name-only HEAD)
fi

TOTAL_FILES=${#CHANGED_FILES[@]}
echo -e "${GREEN}Found $TOTAL_FILES changed files${NC}"

# 추가/삭제 라인 수 계산
ADDITIONS=0
DELETIONS=0

for file in "${CHANGED_FILES[@]}"; do
    if [ -f "$file" ]; then
        stats=$(git diff --numstat "$TARGET_BRANCH"..."$SOURCE_BRANCH" -- "$file" 2>/dev/null || git diff --numstat HEAD -- "$file")
        if [ -n "$stats" ]; then
            add=$(echo "$stats" | awk '{print $1}')
            del=$(echo "$stats" | awk '{print $2}')
            if [[ "$add" =~ ^[0-9]+$ ]]; then
                ADDITIONS=$((ADDITIONS + add))
            fi
            if [[ "$del" =~ ^[0-9]+$ ]]; then
                DELETIONS=$((DELETIONS + del))
            fi
        fi
    fi
done

TOTAL_CHANGES=$((ADDITIONS + DELETIONS))

echo -e "${GREEN}+$ADDITIONS${NC} / ${RED}-$DELETIONS${NC} lines"

# 파일 타입별 분류
declare -A FILE_TYPES
for file in "${CHANGED_FILES[@]}"; do
    ext="${file##*.}"
    if [ "$ext" != "$file" ]; then
        ext=".$ext"
        ((FILE_TYPES[$ext]++)) || FILE_TYPES[$ext]=1
    fi
done

echo ""
echo -e "${YELLOW}Files by type:${NC}"
for ext in "${!FILE_TYPES[@]}"; do
    echo "  $ext: ${FILE_TYPES[$ext]}"
done

# 영향 영역 분석
declare -A IMPACT_AREAS
for file in "${CHANGED_FILES[@]}"; do
    dir=$(dirname "$file" | cut -d'/' -f1-2)
    ((IMPACT_AREAS[$dir]++)) || IMPACT_AREAS[$dir]=1
done

echo ""
echo -e "${YELLOW}Impact areas:${NC}"
for area in "${!IMPACT_AREAS[@]}"; do
    echo "  $area: ${IMPACT_AREAS[$area]} files"
done

# 위험 수준 계산
RISK_LEVEL="low"
if [ $TOTAL_CHANGES -gt 500 ]; then
    RISK_LEVEL="high"
elif [ $TOTAL_CHANGES -gt 200 ]; then
    RISK_LEVEL="medium"
fi

# 특정 패턴 검사로 위험 수준 상향
for file in "${CHANGED_FILES[@]}"; do
    case "$file" in
        *config*|*auth*|*security*|*password*|*secret*)
            RISK_LEVEL="high"
            break
            ;;
        *migration*|*schema*|*database*)
            if [ "$RISK_LEVEL" != "high" ]; then
                RISK_LEVEL="medium"
            fi
            ;;
    esac
done

echo ""
echo -e "${YELLOW}Risk Level: ${NC}"
case $RISK_LEVEL in
    low)
        echo -e "${GREEN}LOW${NC}"
        ;;
    medium)
        echo -e "${YELLOW}MEDIUM${NC}"
        ;;
    high)
        echo -e "${RED}HIGH${NC}"
        ;;
esac

# JSON 출력 생성
echo ""
echo -e "${BLUE}Generating analysis report...${NC}"

# 파일 타입 JSON
FILE_TYPES_JSON="{"
first=true
for ext in "${!FILE_TYPES[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        FILE_TYPES_JSON+=","
    fi
    FILE_TYPES_JSON+="\"$ext\":${FILE_TYPES[$ext]}"
done
FILE_TYPES_JSON+="}"

# 영향 영역 배열
IMPACT_ARRAY="["
first=true
for area in "${!IMPACT_AREAS[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        IMPACT_ARRAY+=","
    fi
    IMPACT_ARRAY+="\"$area\""
done
IMPACT_ARRAY+="]"

# 변경 파일 배열
CHANGED_FILES_JSON="["
first=true
for file in "${CHANGED_FILES[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        CHANGED_FILES_JSON+=","
    fi

    if [ -f "$file" ]; then
        stats=$(git diff --numstat "$TARGET_BRANCH"..."$SOURCE_BRANCH" -- "$file" 2>/dev/null || git diff --numstat HEAD -- "$file")
        add=$(echo "$stats" | awk '{print $1}')
        del=$(echo "$stats" | awk '{print $2}')
        [[ ! "$add" =~ ^[0-9]+$ ]] && add=0
        [[ ! "$del" =~ ^[0-9]+$ ]] && del=0

        if git ls-files --error-unmatch "$file" > /dev/null 2>&1; then
            change_type="modified"
        else
            change_type="added"
        fi
    else
        add=0
        del=0
        change_type="deleted"
    fi

    CHANGED_FILES_JSON+="{\"path\":\"$file\",\"additions\":$add,\"deletions\":$del,\"changeType\":\"$change_type\"}"
done
CHANGED_FILES_JSON+="]"

# 최종 JSON 생성
cat > "$OUTPUT_FILE" << EOF
{
  "summary": {
    "totalFiles": $TOTAL_FILES,
    "additions": $ADDITIONS,
    "deletions": $DELETIONS,
    "totalChanges": $TOTAL_CHANGES
  },
  "filesByType": $FILE_TYPES_JSON,
  "changedFiles": $CHANGED_FILES_JSON,
  "impactAreas": $IMPACT_ARRAY,
  "riskLevel": "$RISK_LEVEL",
  "analyzedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

echo -e "${GREEN}Analysis complete! Report saved to: $OUTPUT_FILE${NC}"
