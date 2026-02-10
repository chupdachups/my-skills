#!/bin/bash

# MCP 프로젝트 구조 생성 스크립트
# 사용법: ./create-project.sh <project-name> <language> <features>

set -e

PROJECT_NAME=$1
LANGUAGE=$2
FEATURES=$3  # comma-separated: tools,resources,prompts

if [ -z "$PROJECT_NAME" ] || [ -z "$LANGUAGE" ]; then
    echo "Usage: ./create-project.sh <project-name> <language> [features]"
    exit 1
fi

# 패키지 이름 생성 (하이픈을 언더스코어로)
PACKAGE_NAME=$(echo "$PROJECT_NAME" | tr '-' '_')

echo "Creating MCP project: $PROJECT_NAME"
echo "Language: $LANGUAGE"
echo "Features: $FEATURES"

# 프로젝트 디렉토리 생성
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

if [ "$LANGUAGE" = "typescript" ]; then
    # TypeScript 프로젝트 구조
    mkdir -p src

    # 기능별 디렉토리 생성
    if [[ "$FEATURES" == *"tools"* ]]; then
        mkdir -p src/tools
        touch src/tools/index.ts
    fi

    if [[ "$FEATURES" == *"resources"* ]]; then
        mkdir -p src/resources
        touch src/resources/index.ts
    fi

    if [[ "$FEATURES" == *"prompts"* ]]; then
        mkdir -p src/prompts
        touch src/prompts/index.ts
    fi

    # 기본 파일 생성
    touch src/index.ts
    touch src/server.ts
    touch package.json
    touch tsconfig.json
    touch README.md

elif [ "$LANGUAGE" = "python" ]; then
    # Python 프로젝트 구조
    mkdir -p "src/$PACKAGE_NAME"

    # 기능별 디렉토리 생성
    if [[ "$FEATURES" == *"tools"* ]]; then
        mkdir -p "src/$PACKAGE_NAME/tools"
        touch "src/$PACKAGE_NAME/tools/__init__.py"
    fi

    if [[ "$FEATURES" == *"resources"* ]]; then
        mkdir -p "src/$PACKAGE_NAME/resources"
        touch "src/$PACKAGE_NAME/resources/__init__.py"
    fi

    if [[ "$FEATURES" == *"prompts"* ]]; then
        mkdir -p "src/$PACKAGE_NAME/prompts"
        touch "src/$PACKAGE_NAME/prompts/__init__.py"
    fi

    # 기본 파일 생성
    touch "src/$PACKAGE_NAME/__init__.py"
    touch "src/$PACKAGE_NAME/__main__.py"
    touch "src/$PACKAGE_NAME/server.py"
    touch pyproject.toml
    touch README.md
fi

echo "Project structure created successfully!"
echo ""
echo "Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. Fill in the generated template files"
echo "3. Install dependencies"
