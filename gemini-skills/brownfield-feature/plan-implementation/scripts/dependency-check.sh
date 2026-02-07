#!/bin/bash

# 의존성 확인 스크립트
# Brownfield Feature Development - Implementation Planning

echo "🔗 프로젝트 의존성 분석 중..."
echo "================================"

# 1. 패키지 매니저 감지 및 의존성 확인
echo ""
echo "📦 패키지 의존성:"

if [ -f "package.json" ]; then
    echo "  Node.js 프로젝트 감지"
    echo ""
    echo "  프로덕션 의존성:"
    if command -v jq &> /dev/null; then
        cat package.json | jq -r '.dependencies // {} | keys[]' 2>/dev/null | while read dep; do
            echo "    - $dep"
        done
    else
        grep -A 100 '"dependencies"' package.json | grep -E '^\s+"[^"]+":' | head -20
    fi
    echo ""
    echo "  개발 의존성:"
    if command -v jq &> /dev/null; then
        cat package.json | jq -r '.devDependencies // {} | keys[]' 2>/dev/null | while read dep; do
            echo "    - $dep"
        done
    else
        grep -A 100 '"devDependencies"' package.json | grep -E '^\s+"[^"]+":' | head -20
    fi
fi

if [ -f "requirements.txt" ]; then
    echo "  Python 프로젝트 감지 (requirements.txt)"
    echo ""
    cat requirements.txt | grep -v "^#" | grep -v "^$" | head -20
fi

if [ -f "pyproject.toml" ]; then
    echo "  Python 프로젝트 감지 (pyproject.toml)"
fi

if [ -f "pom.xml" ]; then
    echo "  Maven 프로젝트 감지"
    echo ""
    grep -E "<artifactId>|<groupId>" pom.xml | head -30
fi

if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    echo "  Gradle 프로젝트 감지"
    echo ""
    grep -E "implementation|api|compile" build.gradle* 2>/dev/null | head -20
fi

if [ -f "go.mod" ]; then
    echo "  Go 프로젝트 감지"
    echo ""
    grep -E "require" go.mod | head -20
fi

if [ -f "Cargo.toml" ]; then
    echo "  Rust 프로젝트 감지"
    echo ""
    grep -A 50 "\[dependencies\]" Cargo.toml | grep -v "^\[" | head -20
fi

# 2. 내부 모듈 의존성 분석
echo ""
echo "================================"
echo "📁 내부 모듈 구조:"

for dir in src app lib; do
    if [ -d "$dir" ]; then
        echo ""
        echo "  $dir/ 디렉토리:"
        find "$dir" -type d -maxdepth 2 | head -15
    fi
done

# 3. 임포트 패턴 분석
echo ""
echo "================================"
echo "🔍 주요 임포트 패턴:"

echo ""
echo "  상대 경로 임포트 사용:"
grep -r "from '\.\." --include="*.ts" --include="*.js" --include="*.tsx" --include="*.jsx" . 2>/dev/null | wc -l | xargs echo "    JavaScript/TypeScript:"
grep -r "from \.\." --include="*.py" . 2>/dev/null | wc -l | xargs echo "    Python:"

echo ""
echo "  절대 경로 임포트 사용:"
grep -r "from '@" --include="*.ts" --include="*.js" --include="*.tsx" --include="*.jsx" . 2>/dev/null | wc -l | xargs echo "    JavaScript/TypeScript (@alias):"

# 4. 순환 의존성 경고
echo ""
echo "================================"
echo "⚠️ 순환 의존성 확인:"
echo "  (이 분석은 정적 분석 도구로 더 정확하게 수행할 수 있습니다)"

if command -v npx &> /dev/null && [ -f "package.json" ]; then
    echo "  madge 도구 사용 가능: npx madge --circular src/"
fi

echo ""
echo "================================"
echo "✅ 의존성 분석 완료"
