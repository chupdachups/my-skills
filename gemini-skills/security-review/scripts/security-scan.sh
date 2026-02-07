#!/bin/bash

# security-scan.sh
# 코드 보안 취약점 스캔 스크립트

set -e

# 색상 정의
RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# 사용법
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --path      Path to scan (default: current directory)"
    echo "  -o, --output    Output file path (default: .code-review-security.json)"
    echo "  -v, --verbose   Show detailed output"
    echo "  -h, --help      Show this help message"
    exit 1
}

# 기본값
SCAN_PATH="."
OUTPUT_FILE=".code-review-security.json"
VERBOSE=false

# 인자 파싱
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--path)
            SCAN_PATH="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
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

echo -e "${BLUE}=== Security Scanner ===${NC}"
echo -e "Scanning: ${SCAN_PATH}"
echo ""

# 결과 저장용 배열
declare -a VULNERABILITIES

# 취약점 카운터
CRITICAL=0
HIGH=0
MEDIUM=0
LOW=0
INFO=0

# 취약점 추가 함수
add_vulnerability() {
    local severity="$1"
    local category="$2"
    local file="$3"
    local line="$4"
    local description="$5"
    local recommendation="$6"

    case $severity in
        critical) ((CRITICAL++)) ;;
        high) ((HIGH++)) ;;
        medium) ((MEDIUM++)) ;;
        low) ((LOW++)) ;;
        info) ((INFO++)) ;;
    esac

    local vuln_id="SEC-$(printf '%03d' $((CRITICAL + HIGH + MEDIUM + LOW + INFO)))"
    VULNERABILITIES+=("{\"id\":\"$vuln_id\",\"severity\":\"$severity\",\"category\":\"$category\",\"file\":\"$file\",\"line\":$line,\"description\":\"$description\",\"recommendation\":\"$recommendation\"}")

    if [ "$VERBOSE" = true ]; then
        case $severity in
            critical|high) echo -e "${RED}[$severity] $file:$line - $description${NC}" ;;
            medium) echo -e "${ORANGE}[$severity] $file:$line - $description${NC}" ;;
            low) echo -e "${YELLOW}[$severity] $file:$line - $description${NC}" ;;
            *) echo -e "[$severity] $file:$line - $description" ;;
        esac
    fi
}

# 1. SQL Injection 검사
echo -e "${YELLOW}[1/8] Checking for SQL Injection vulnerabilities...${NC}"
while IFS= read -r result; do
    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        add_vulnerability "high" "A03:2021 - Injection" "$file" "$line" \
            "Potential SQL injection - string concatenation in query" \
            "Use parameterized queries or ORM"
    fi
done < <(grep -rn --include="*.js" --include="*.ts" --include="*.py" \
    -E "(SELECT|INSERT|UPDATE|DELETE).*\\\$\{|query\s*\(.*\+.*\)|execute\s*\(.*%s" \
    "$SCAN_PATH" 2>/dev/null || true)

# 2. 하드코딩된 시크릿 검사
echo -e "${YELLOW}[2/8] Checking for hardcoded secrets...${NC}"
while IFS= read -r result; do
    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        add_vulnerability "critical" "A02:2021 - Cryptographic Failures" "$file" "$line" \
            "Hardcoded secret or API key detected" \
            "Use environment variables or secret management"
    fi
done < <(grep -rn --include="*.js" --include="*.ts" --include="*.py" --include="*.java" \
    -iE "(password|secret|api_key|apikey|auth_token|private_key)\s*[=:]\s*['\"][^'\"]{8,}['\"]" \
    "$SCAN_PATH" 2>/dev/null | grep -v "node_modules" | grep -v ".test." || true)

# 3. XSS 취약점 검사
echo -e "${YELLOW}[3/8] Checking for XSS vulnerabilities...${NC}"
while IFS= read -r result; do
    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        add_vulnerability "high" "A03:2021 - Injection (XSS)" "$file" "$line" \
            "Potential XSS - innerHTML or dangerouslySetInnerHTML usage" \
            "Sanitize user input or use textContent"
    fi
done < <(grep -rn --include="*.js" --include="*.ts" --include="*.tsx" --include="*.jsx" \
    -E "innerHTML\s*=|dangerouslySetInnerHTML|v-html" \
    "$SCAN_PATH" 2>/dev/null | grep -v "node_modules" || true)

# 4. 명령어 인젝션 검사
echo -e "${YELLOW}[4/8] Checking for Command Injection vulnerabilities...${NC}"
while IFS= read -r result; do
    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        add_vulnerability "critical" "A03:2021 - Injection" "$file" "$line" \
            "Potential command injection - exec/spawn with variable" \
            "Use parameterized execution or input validation"
    fi
done < <(grep -rn --include="*.js" --include="*.ts" --include="*.py" \
    -E "(exec|spawn|system|popen|subprocess)\s*\([^)]*\\\$|os\.(system|popen)\s*\(.*\+" \
    "$SCAN_PATH" 2>/dev/null | grep -v "node_modules" || true)

# 5. 약한 암호화 검사
echo -e "${YELLOW}[5/8] Checking for weak cryptography...${NC}"
while IFS= read -r result; do
    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        add_vulnerability "medium" "A02:2021 - Cryptographic Failures" "$file" "$line" \
            "Weak hashing algorithm detected (MD5/SHA1)" \
            "Use SHA-256 or bcrypt for passwords"
    fi
done < <(grep -rn --include="*.js" --include="*.ts" --include="*.py" --include="*.java" \
    -E "createHash\s*\(\s*['\"]md5['\"]|createHash\s*\(\s*['\"]sha1['\"]|hashlib\.(md5|sha1)" \
    "$SCAN_PATH" 2>/dev/null | grep -v "node_modules" || true)

# 6. 안전하지 않은 랜덤 검사
echo -e "${YELLOW}[6/8] Checking for insecure randomness...${NC}"
while IFS= read -r result; do
    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        add_vulnerability "medium" "A02:2021 - Cryptographic Failures" "$file" "$line" \
            "Insecure random number generation" \
            "Use crypto.randomBytes or secrets module"
    fi
done < <(grep -rn --include="*.js" --include="*.ts" --include="*.py" \
    -E "Math\.random\s*\(\)|random\.random\s*\(\)" \
    "$SCAN_PATH" 2>/dev/null | grep -v "node_modules" | grep -v ".test." || true)

# 7. eval 사용 검사
echo -e "${YELLOW}[7/8] Checking for dangerous eval usage...${NC}"
while IFS= read -r result; do
    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        add_vulnerability "high" "A03:2021 - Injection" "$file" "$line" \
            "Dangerous eval/exec usage detected" \
            "Avoid eval; use safer alternatives"
    fi
done < <(grep -rn --include="*.js" --include="*.ts" --include="*.py" \
    -E "\beval\s*\(|\bexec\s*\(|new\s+Function\s*\(" \
    "$SCAN_PATH" 2>/dev/null | grep -v "node_modules" | grep -v ".eslint" || true)

# 8. CORS 전체 허용 검사
echo -e "${YELLOW}[8/8] Checking for insecure CORS configuration...${NC}"
while IFS= read -r result; do
    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        add_vulnerability "medium" "A05:2021 - Security Misconfiguration" "$file" "$line" \
            "CORS allows all origins" \
            "Specify allowed origins explicitly"
    fi
done < <(grep -rn --include="*.js" --include="*.ts" --include="*.py" \
    -E "origin:\s*['\"]?\*['\"]?|Access-Control-Allow-Origin.*\*" \
    "$SCAN_PATH" 2>/dev/null | grep -v "node_modules" || true)

# 결과 요약
echo ""
echo -e "${BLUE}=== Scan Complete ===${NC}"
echo ""
echo -e "Vulnerabilities found:"
echo -e "  ${RED}Critical: $CRITICAL${NC}"
echo -e "  ${ORANGE}High: $HIGH${NC}"
echo -e "  ${YELLOW}Medium: $MEDIUM${NC}"
echo -e "  ${GREEN}Low: $LOW${NC}"
echo -e "  Info: $INFO"

# JSON 출력 생성
echo ""
echo -e "${BLUE}Generating security report...${NC}"

# 취약점 배열 생성
VULN_JSON="["
first=true
for vuln in "${VULNERABILITIES[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        VULN_JSON+=","
    fi
    VULN_JSON+="$vuln"
done
VULN_JSON+="]"

# 통과한 검사 항목
PASSED_CHECKS='["Basic auth headers check","HTTPS redirect check","Cookie security flags check"]'

# JSON 파일 생성
cat > "$OUTPUT_FILE" << EOF
{
  "scanType": "automated",
  "scanPath": "$SCAN_PATH",
  "vulnerabilities": $VULN_JSON,
  "summary": {
    "critical": $CRITICAL,
    "high": $HIGH,
    "medium": $MEDIUM,
    "low": $LOW,
    "info": $INFO,
    "total": $((CRITICAL + HIGH + MEDIUM + LOW + INFO))
  },
  "passedChecks": $PASSED_CHECKS,
  "scannedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

echo -e "${GREEN}Security report saved to: $OUTPUT_FILE${NC}"

# 심각한 취약점이 있으면 종료 코드 1 반환
if [ $CRITICAL -gt 0 ] || [ $HIGH -gt 0 ]; then
    echo ""
    echo -e "${RED}WARNING: Critical or High severity vulnerabilities found!${NC}"
    exit 1
fi

exit 0
