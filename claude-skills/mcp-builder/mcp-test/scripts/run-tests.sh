#!/bin/bash
# MCP 서버 테스트 스크립트

set -e

PROJECT_DIR=$1
LANGUAGE=$2

if [ -z "$PROJECT_DIR" ] || [ -z "$LANGUAGE" ]; then
    echo "Usage: ./run-tests.sh <project-dir> <language>"
    exit 1
fi

cd "$PROJECT_DIR"

echo "=== MCP Server Test ==="

# 의존성 설치
echo "[1/3] Installing dependencies..."
if [ "$LANGUAGE" = "typescript" ]; then
    npm install --silent
elif [ "$LANGUAGE" = "python" ]; then
    pip install -e . --quiet 2>/dev/null || uv pip install -e . --quiet
fi

# 빌드 (TypeScript)
if [ "$LANGUAGE" = "typescript" ]; then
    echo "[2/3] Building..."
    npm run build --silent
else
    echo "[2/3] Build skipped (Python)"
fi

# 기본 테스트
echo "[3/3] Testing server..."
if [ "$LANGUAGE" = "typescript" ]; then
    echo '{"jsonrpc":"2.0","method":"tools/list","id":1}' | timeout 5 node dist/index.js 2>/dev/null && echo "✓ Server responds"
elif [ "$LANGUAGE" = "python" ]; then
    PACKAGE_NAME=$(basename "$PROJECT_DIR" | tr '-' '_')
    echo '{"jsonrpc":"2.0","method":"tools/list","id":1}' | timeout 5 python -m "$PACKAGE_NAME" 2>/dev/null && echo "✓ Server responds"
fi

echo ""
echo "For interactive testing:"
echo "  npx @modelcontextprotocol/inspector <command>"
