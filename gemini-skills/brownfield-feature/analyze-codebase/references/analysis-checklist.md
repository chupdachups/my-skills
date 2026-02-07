# 코드베이스 분석 체크리스트

## 1. 프로젝트 구조 분석

### 디렉토리 구조
- [ ] 루트 디렉토리 구성 파악
- [ ] 소스 코드 위치 확인 (src, app, lib 등)
- [ ] 테스트 코드 위치 확인
- [ ] 설정 파일 위치 확인
- [ ] 정적 자원 위치 확인 (assets, public, static)
- [ ] 문서 위치 확인 (docs, README)

### 모듈 구조
- [ ] 모듈/패키지 분리 방식 (기능별, 레이어별, 도메인별)
- [ ] 공유 모듈 위치 (common, shared, utils)
- [ ] 진입점 파일 (main, index, app)

## 2. 기술 스택 확인

### 언어 및 런타임
- [ ] 프로그래밍 언어
- [ ] 언어 버전
- [ ] 런타임 환경 (Node.js, JVM, Python 등)

### 프레임워크
- [ ] 웹 프레임워크 (React, Vue, Spring, Django 등)
- [ ] API 프레임워크 (Express, FastAPI, Gin 등)
- [ ] 테스트 프레임워크 (Jest, PyTest, JUnit 등)

### 빌드 및 도구
- [ ] 패키지 매니저 (npm, yarn, pip, maven 등)
- [ ] 빌드 도구 (webpack, vite, gradle 등)
- [ ] 린터/포매터 (ESLint, Prettier, Black 등)

## 3. 아키텍처 패턴

### 전체 아키텍처
- [ ] 모놀리식 / 마이크로서비스
- [ ] 레이어드 아키텍처 여부
- [ ] 헥사고날 / 클린 아키텍처 여부
- [ ] MVC / MVVM 패턴 여부

### 데이터 흐름
- [ ] 상태 관리 방식 (Redux, Vuex, Context 등)
- [ ] API 통신 패턴 (REST, GraphQL, gRPC)
- [ ] 데이터베이스 접근 패턴 (ORM, Query Builder, Raw SQL)

### 의존성 관리
- [ ] 의존성 주입 방식
- [ ] 모듈 간 의존성 방향
- [ ] 순환 의존성 여부

## 4. 코딩 컨벤션

### 네이밍 규칙
- [ ] 변수명 (camelCase, snake_case)
- [ ] 함수명 (동사 시작, 명사 등)
- [ ] 클래스명 (PascalCase)
- [ ] 파일명 (kebab-case, camelCase, PascalCase)
- [ ] 상수명 (UPPER_SNAKE_CASE)

### 코드 스타일
- [ ] 들여쓰기 (탭, 스페이스 2칸, 4칸)
- [ ] 따옴표 (작은따옴표, 큰따옴표)
- [ ] 세미콜론 사용 여부
- [ ] 줄바꿈 스타일

### 구조 패턴
- [ ] 컴포넌트/클래스 구조
- [ ] 임포트 순서 및 그룹화
- [ ] 주석 스타일 (JSDoc, Docstring 등)
- [ ] 에러 처리 패턴

## 5. 품질 관리

### 테스트
- [ ] 테스트 커버리지 확인
- [ ] 테스트 실행 방법
- [ ] 테스트 네이밍 규칙

### CI/CD
- [ ] CI 설정 파일 확인 (.github/workflows, .gitlab-ci.yml 등)
- [ ] 배포 프로세스 파악
- [ ] 환경별 설정 확인

## 6. 분석 결과 정리

### 핵심 발견 사항
- 강점:
- 주의점:
- 개선 가능 영역:

### 새 기능 추가 시 참고 사항
- 유사한 기존 기능:
- 따라야 할 패턴:
- 피해야 할 안티패턴:
