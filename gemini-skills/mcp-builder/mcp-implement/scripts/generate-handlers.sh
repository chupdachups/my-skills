#!/bin/bash

# MCP 핸들러 코드 생성 보조 스크립트
# 이 스크립트는 .mcp-config.json을 읽어 핸들러 스텁을 생성합니다

set -e

CONFIG_FILE=".mcp-config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE not found"
    exit 1
fi

# jq가 설치되어 있는지 확인
if ! command -v jq &> /dev/null; then
    echo "Warning: jq is not installed. Manual parsing required."
    exit 0
fi

# 설정 읽기
NAME=$(jq -r '.name' "$CONFIG_FILE")
LANGUAGE=$(jq -r '.language' "$CONFIG_FILE")
PACKAGE_NAME=$(echo "$NAME" | tr '-' '_')

echo "Generating handlers for: $NAME"
echo "Language: $LANGUAGE"

# 도구 목록 추출
TOOLS=$(jq -r '.tools[]?.name // empty' "$CONFIG_FILE" 2>/dev/null)
RESOURCES=$(jq -r '.resources[]?.uri // empty' "$CONFIG_FILE" 2>/dev/null)
PROMPTS=$(jq -r '.prompts[]?.name // empty' "$CONFIG_FILE" 2>/dev/null)

echo ""
echo "Tools to implement:"
for tool in $TOOLS; do
    echo "  - $tool"
done

echo ""
echo "Resources to implement:"
for resource in $RESOURCES; do
    echo "  - $resource"
done

echo ""
echo "Prompts to implement:"
for prompt in $PROMPTS; do
    echo "  - $prompt"
done

echo ""
echo "Handler stubs will be generated in the appropriate directories."
echo "Please implement the actual logic in each handler file."

# TypeScript 핸들러 스텁 생성
generate_ts_tool_stub() {
    local tool_name=$1
    cat << EOF
import { CallToolRequest } from "@modelcontextprotocol/sdk/types.js";

export async function ${tool_name}Handler(request: CallToolRequest) {
  const { arguments: args } = request.params;

  // TODO: Implement ${tool_name} logic
  // 1. Validate input arguments
  // 2. Execute tool logic
  // 3. Return result

  return {
    content: [
      {
        type: "text",
        text: JSON.stringify({ status: "not_implemented" }),
      },
    ],
  };
}
EOF
}

# Python 핸들러 스텁 생성
generate_py_tool_stub() {
    local tool_name=$1
    cat << EOF
import json
from mcp.types import TextContent

async def ${tool_name}_handler(arguments: dict) -> list[TextContent]:
    """
    ${tool_name} 도구 핸들러

    TODO: Implement ${tool_name} logic
    1. Validate input arguments
    2. Execute tool logic
    3. Return result
    """
    # 입력 파라미터 추출
    # param = arguments.get("param")

    # 로직 구현
    result = {"status": "not_implemented"}

    return [TextContent(type="text", text=json.dumps(result))]
EOF
}

echo ""
echo "Done!"
