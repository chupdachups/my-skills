#!/bin/bash

# 프로젝트 구조 분석 스크립트
# Brownfield Feature Development - Codebase Analysis

echo "📁 프로젝트 구조 분석 중..."
echo "================================"

# 1. 디렉토리 구조 출력 (최대 3레벨)
echo ""
echo "📂 디렉토리 구조:"
if command -v tree &> /dev/null; then
    tree -L 3 -d --noreport -I 'node_modules|.git|__pycache__|.venv|venv|dist|build|.next|.nuxt|target|.gradle' 2>/dev/null || find . -type d -maxdepth 3 | head -50
else
    find . -type d -maxdepth 3 -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/__pycache__/*' | head -50
fi

# 2. 주요 파일 감지
echo ""
echo "📄 주요 설정 파일:"
for file in package.json pom.xml build.gradle settings.gradle Cargo.toml go.mod requirements.txt Pipfile pyproject.toml composer.json Gemfile; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    fi
done

# 3. 소스 디렉토리 감지
echo ""
echo "📁 소스 디렉토리:"
for dir in src app lib source main pkg internal cmd; do
    if [ -d "$dir" ]; then
        echo "  ✓ $dir/"
        ls -la "$dir" 2>/dev/null | head -10
    fi
done

# 4. 테스트 디렉토리 감지
echo ""
echo "🧪 테스트 디렉토리:"
for dir in test tests spec __tests__ test-integration e2e; do
    if [ -d "$dir" ]; then
        echo "  ✓ $dir/"
    fi
done

# 5. 설정 파일 감지
echo ""
echo "⚙️ 설정 파일:"
for file in .env.example .eslintrc* .prettierrc* tsconfig.json jsconfig.json webpack.config.* vite.config.* rollup.config.* jest.config.* vitest.config.* .babelrc* Makefile Dockerfile docker-compose.yml; do
    if ls $file 1> /dev/null 2>&1; then
        echo "  ✓ $file"
    fi
done

# 6. 파일 통계
echo ""
echo "📊 파일 통계:"
echo "  총 파일 수: $(find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' | wc -l | tr -d ' ')"

for ext in js ts jsx tsx py java kt go rs rb php cs; do
    count=$(find . -name "*.$ext" -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -gt 0 ]; then
        echo "  .$ext 파일: $count개"
    fi
done

echo ""
echo "================================"
echo "✅ 구조 분석 완료"
