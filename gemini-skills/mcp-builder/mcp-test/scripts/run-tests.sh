#!/bin/bash

# MCP 서버 테스트 스크립트
# 사용법: ./run-tests.sh <project-dir> <language>

set -e

PROJECT_DIR=$1
LANGUAGE=$2

if [ -z "$PROJECT_DIR" ] || [ -z "$LANGUAGE" ]; then
    echo "Usage: ./run-tests.sh <project-dir> <language>"
    exit 1
fi

cd "$PROJECT_DIR"

echo "=========================================="
echo "MCP Server Test Suite"
echo "=========================================="
echo ""

# 1. 의존성 설치
echo "[1/4] Installing dependencies..."
if [ "$LANGUAGE" = "typescript" ]; then
    npm install --silent
    echo "✓ npm packages installed"
elif [ "$LANGUAGE" = "python" ]; then
    if command -v uv &> /dev/null; then
        uv pip install -e . --quiet
    else
        pip install -e . --quiet
    fi
    echo "✓ Python packages installed"
fi
echo ""

# 2. 빌드 (TypeScript만)
if [ "$LANGUAGE" = "typescript" ]; then
    echo "[2/4] Building..."
    npm run build --silent
    echo "✓ TypeScript compiled"
    echo ""
else
    echo "[2/4] Build step skipped (Python)"
    echo ""
fi

# 3. 기본 실행 테스트
echo "[3/4] Testing server startup..."

# 서버 시작 테스트 (백그라운드에서 실행 후 종료)
if [ "$LANGUAGE" = "typescript" ]; then
    timeout 5 node dist/index.js <<< '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{"protocolVersion":"0.1.0","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' > /tmp/mcp_test_output.json 2>&1 || true
elif [ "$LANGUAGE" = "python" ]; then
    PACKAGE_NAME=$(basename "$PROJECT_DIR" | tr '-' '_')
    timeout 5 python -m "$PACKAGE_NAME" <<< '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{"protocolVersion":"0.1.0","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' > /tmp/mcp_test_output.json 2>&1 || true
fi

if grep -q '"result"' /tmp/mcp_test_output.json 2>/dev/null; then
    echo "✓ Server starts successfully"
else
    echo "✗ Server startup failed"
    cat /tmp/mcp_test_output.json 2>/dev/null || echo "No output captured"
fi
echo ""

# 4. 도구/리소스 목록 테스트
echo "[4/4] Testing tool/resource listing..."

# tools/list 테스트
echo '{"jsonrpc":"2.0","method":"tools/list","id":2,"params":{}}' > /tmp/mcp_test_input.json

if [ "$LANGUAGE" = "typescript" ]; then
    timeout 5 node dist/index.js < /tmp/mcp_test_input.json > /tmp/mcp_test_tools.json 2>&1 || true
elif [ "$LANGUAGE" = "python" ]; then
    timeout 5 python -m "$PACKAGE_NAME" < /tmp/mcp_test_input.json > /tmp/mcp_test_tools.json 2>&1 || true
fi

if grep -q '"tools"' /tmp/mcp_test_tools.json 2>/dev/null; then
    TOOL_COUNT=$(grep -o '"name"' /tmp/mcp_test_tools.json | wc -l)
    echo "✓ Tools listed: $TOOL_COUNT tool(s)"
else
    echo "○ No tools defined or listing failed"
fi

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo ""
echo "For interactive testing, use MCP Inspector:"
echo ""
if [ "$LANGUAGE" = "typescript" ]; then
    echo "  npx @modelcontextprotocol/inspector node dist/index.js"
elif [ "$LANGUAGE" = "python" ]; then
    echo "  npx @modelcontextprotocol/inspector python -m $PACKAGE_NAME"
fi
echo ""
echo "=========================================="

# 임시 파일 정리
rm -f /tmp/mcp_test_*.json
