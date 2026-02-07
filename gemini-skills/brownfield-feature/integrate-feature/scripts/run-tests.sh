#!/bin/bash

# 테스트 실행 스크립트
# Brownfield Feature Development - Integration Testing

echo "🧪 테스트 실행 중..."
echo "================================"

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 결과 카운터
TOTAL_PASSED=0
TOTAL_FAILED=0

# 1. 프로젝트 타입 감지 및 테스트 실행
run_tests() {
    echo ""
    echo "📦 프로젝트 타입 감지..."

    # Node.js 프로젝트
    if [ -f "package.json" ]; then
        echo "  Node.js 프로젝트 감지"

        # 패키지 매니저 감지
        if [ -f "pnpm-lock.yaml" ]; then
            PKG_MANAGER="pnpm"
        elif [ -f "yarn.lock" ]; then
            PKG_MANAGER="yarn"
        elif [ -f "bun.lockb" ]; then
            PKG_MANAGER="bun"
        else
            PKG_MANAGER="npm"
        fi

        echo "  패키지 매니저: $PKG_MANAGER"
        echo ""

        # 테스트 스크립트 확인
        if grep -q '"test"' package.json; then
            echo "📋 단위/통합 테스트 실행..."
            echo "  명령: $PKG_MANAGER test"
            echo ""
            $PKG_MANAGER test 2>&1
            TEST_EXIT_CODE=$?

            if [ $TEST_EXIT_CODE -eq 0 ]; then
                echo -e "${GREEN}✅ 테스트 통과${NC}"
                ((TOTAL_PASSED++))
            else
                echo -e "${RED}❌ 테스트 실패${NC}"
                ((TOTAL_FAILED++))
            fi
        else
            echo -e "${YELLOW}⚠️ test 스크립트가 package.json에 없습니다${NC}"
        fi

        # E2E 테스트 확인
        if grep -q '"test:e2e"' package.json; then
            echo ""
            echo "📋 E2E 테스트 실행..."
            $PKG_MANAGER run test:e2e 2>&1
        fi

        # 린트 확인
        if grep -q '"lint"' package.json; then
            echo ""
            echo "📋 린트 실행..."
            $PKG_MANAGER run lint 2>&1
            LINT_EXIT_CODE=$?

            if [ $LINT_EXIT_CODE -eq 0 ]; then
                echo -e "${GREEN}✅ 린트 통과${NC}"
            else
                echo -e "${YELLOW}⚠️ 린트 경고/에러 있음${NC}"
            fi
        fi

        # 타입 체크 확인
        if grep -q '"typecheck"' package.json || grep -q '"type-check"' package.json; then
            echo ""
            echo "📋 타입 체크 실행..."
            $PKG_MANAGER run typecheck 2>&1 || $PKG_MANAGER run type-check 2>&1
        fi
    fi

    # Python 프로젝트
    if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        echo "  Python 프로젝트 감지"
        echo ""

        # pytest
        if command -v pytest &> /dev/null || [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
            echo "📋 pytest 실행..."
            python -m pytest -v 2>&1
            TEST_EXIT_CODE=$?

            if [ $TEST_EXIT_CODE -eq 0 ]; then
                echo -e "${GREEN}✅ pytest 통과${NC}"
                ((TOTAL_PASSED++))
            else
                echo -e "${RED}❌ pytest 실패${NC}"
                ((TOTAL_FAILED++))
            fi
        fi

        # unittest
        if [ -d "tests" ] && ! command -v pytest &> /dev/null; then
            echo "📋 unittest 실행..."
            python -m unittest discover -v 2>&1
        fi
    fi

    # Java/Gradle 프로젝트
    if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
        echo "  Gradle 프로젝트 감지"
        echo ""
        echo "📋 Gradle 테스트 실행..."
        ./gradlew test 2>&1
        TEST_EXIT_CODE=$?

        if [ $TEST_EXIT_CODE -eq 0 ]; then
            echo -e "${GREEN}✅ Gradle 테스트 통과${NC}"
            ((TOTAL_PASSED++))
        else
            echo -e "${RED}❌ Gradle 테스트 실패${NC}"
            ((TOTAL_FAILED++))
        fi
    fi

    # Java/Maven 프로젝트
    if [ -f "pom.xml" ]; then
        echo "  Maven 프로젝트 감지"
        echo ""
        echo "📋 Maven 테스트 실행..."
        mvn test 2>&1
        TEST_EXIT_CODE=$?

        if [ $TEST_EXIT_CODE -eq 0 ]; then
            echo -e "${GREEN}✅ Maven 테스트 통과${NC}"
            ((TOTAL_PASSED++))
        else
            echo -e "${RED}❌ Maven 테스트 실패${NC}"
            ((TOTAL_FAILED++))
        fi
    fi

    # Go 프로젝트
    if [ -f "go.mod" ]; then
        echo "  Go 프로젝트 감지"
        echo ""
        echo "📋 Go 테스트 실행..."
        go test ./... -v 2>&1
        TEST_EXIT_CODE=$?

        if [ $TEST_EXIT_CODE -eq 0 ]; then
            echo -e "${GREEN}✅ Go 테스트 통과${NC}"
            ((TOTAL_PASSED++))
        else
            echo -e "${RED}❌ Go 테스트 실패${NC}"
            ((TOTAL_FAILED++))
        fi
    fi

    # Rust 프로젝트
    if [ -f "Cargo.toml" ]; then
        echo "  Rust 프로젝트 감지"
        echo ""
        echo "📋 Cargo 테스트 실행..."
        cargo test 2>&1
        TEST_EXIT_CODE=$?

        if [ $TEST_EXIT_CODE -eq 0 ]; then
            echo -e "${GREEN}✅ Cargo 테스트 통과${NC}"
            ((TOTAL_PASSED++))
        else
            echo -e "${RED}❌ Cargo 테스트 실패${NC}"
            ((TOTAL_FAILED++))
        fi
    fi
}

# 2. 테스트 실행
run_tests

# 3. 결과 요약
echo ""
echo "================================"
echo "📊 테스트 결과 요약"
echo "================================"
echo -e "  ${GREEN}통과: $TOTAL_PASSED${NC}"
echo -e "  ${RED}실패: $TOTAL_FAILED${NC}"
echo ""

if [ $TOTAL_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ 모든 테스트 통과!${NC}"
    exit 0
else
    echo -e "${RED}❌ 일부 테스트 실패${NC}"
    exit 1
fi
