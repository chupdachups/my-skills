---
name: mcp-test
description: MCP 서버를 테스트하고 검증합니다. 빌드, 실행, 기능 테스트를 수행합니다.
---

# mcp-test

MCP 서버를 테스트하고 검증하는 skill입니다.

## 설명

이 skill은 생성된 MCP 서버의 빌드, 기본 실행, 도구/리소스 동작을 테스트합니다. `scripts/run-tests.sh`를 사용하여 자동화된 테스트를 수행합니다.

## 지시사항

1. 현재 디렉토리의 `.mcp-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. 프로젝트 디렉토리로 이동하세요.

3. `scripts/run-tests.sh`를 참조하여 테스트를 수행하세요.

4. 의존성을 설치하세요:

### TypeScript
```bash
npm install
```

### Python
```bash
pip install -e .
# 또는
uv pip install -e .
```

5. 빌드를 수행하세요 (TypeScript만):
```bash
npm run build
```

6. MCP Inspector를 사용하여 테스트를 안내하세요:
```bash
# TypeScript
npx @modelcontextprotocol/inspector node dist/index.js

# Python
npx @modelcontextprotocol/inspector python -m {package_name}
```

7. 테스트 체크리스트:
   - [ ] 서버가 정상적으로 시작되는가?
   - [ ] 도구 목록이 올바르게 반환되는가?
   - [ ] 리소스 목록이 올바르게 반환되는가?
   - [ ] 프롬프트 목록이 올바르게 반환되는가?
   - [ ] 각 도구가 예상대로 동작하는가?
   - [ ] 에러 처리가 올바르게 동작하는가?

8. 테스트 결과를 사용자에게 보고하세요.

9. 모든 테스트가 통과하면 `.mcp-config.json`의 `status`를 `tested`로 업데이트하세요.

10. **반드시 다음 skill을 호출하세요: `/mcp-configure`**

## 일반적인 문제 해결

### 빌드 오류
- TypeScript 버전 확인 (5.0 이상 권장)
- 의존성 버전 호환성 확인
- tsconfig.json 설정 확인

### 런타임 오류
- Node.js 버전 확인 (18 이상 권장)
- Python 버전 확인 (3.10 이상 권장)
- 환경 변수 설정 확인

### 연결 오류
- stdio 전송 방식 확인
- 표준 입출력 처리 확인

## 예시

```
[/mcp-implement에서 호출됨]
Gemini: 테스트를 시작합니다...

1. 의존성 설치 중...
   ✓ 완료

2. 빌드 중...
   ✓ 완료 (TypeScript)

3. MCP Inspector 실행:
   npx @modelcontextprotocol/inspector python -m github_issues_server

4. 테스트 체크리스트:
   ✓ 서버 시작
   ✓ 도구 목록 반환 (3개)
   ✓ 리소스 목록 반환 (2개)
   ✓ create_issue 도구 테스트
   ✓ github://repos/{owner}/{repo} 리소스 테스트

모든 테스트가 통과했습니다.
[/mcp-configure 호출]
```
