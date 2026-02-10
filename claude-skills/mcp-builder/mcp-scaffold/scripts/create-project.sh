#!/bin/bash
# MCP 프로젝트 구조 생성 스크립트
# 사용법: ./create-project.sh <project-name> <language> <features>

set -e

PROJECT_NAME=$1
LANGUAGE=$2
FEATURES=$3

PACKAGE_NAME=$(echo "$PROJECT_NAME" | tr '-' '_')

mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

if [ "$LANGUAGE" = "typescript" ]; then
    mkdir -p src
    [[ "$FEATURES" == *"tools"* ]] && mkdir -p src/tools
    [[ "$FEATURES" == *"resources"* ]] && mkdir -p src/resources
    [[ "$FEATURES" == *"prompts"* ]] && mkdir -p src/prompts
elif [ "$LANGUAGE" = "python" ]; then
    mkdir -p "src/$PACKAGE_NAME"
    [[ "$FEATURES" == *"tools"* ]] && mkdir -p "src/$PACKAGE_NAME/tools"
    [[ "$FEATURES" == *"resources"* ]] && mkdir -p "src/$PACKAGE_NAME/resources"
    [[ "$FEATURES" == *"prompts"* ]] && mkdir -p "src/$PACKAGE_NAME/prompts"
fi

echo "Created project structure for $PROJECT_NAME"
