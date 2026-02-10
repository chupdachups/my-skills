#!/bin/bash
# MCP 핸들러 코드 생성 보조 스크립트

CONFIG_FILE=".mcp-config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE not found"
    exit 1
fi

if command -v jq &> /dev/null; then
    NAME=$(jq -r '.name' "$CONFIG_FILE")
    LANGUAGE=$(jq -r '.language' "$CONFIG_FILE")

    echo "Generating handlers for: $NAME ($LANGUAGE)"

    TOOLS=$(jq -r '.tools[]?.name // empty' "$CONFIG_FILE" 2>/dev/null)
    RESOURCES=$(jq -r '.resources[]?.uri // empty' "$CONFIG_FILE" 2>/dev/null)

    echo "Tools: $TOOLS"
    echo "Resources: $RESOURCES"
else
    echo "jq not installed - manual parsing required"
fi
