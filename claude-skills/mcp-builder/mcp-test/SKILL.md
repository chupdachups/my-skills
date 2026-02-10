---
name: mcp-test
description: MCP 서버를 테스트하고 검증합니다. 빌드, 실행, 기능 테스트를 수행합니다.
user-invocable: false
allowed-tools: Read, Write, Bash
---

# MCP 서버 테스트

생성된 MCP 서버의 빌드, 실행, 기능을 테스트합니다.

## 지시사항

1. **설정 읽기**: `.mcp-config.json` 파일 확인

2. **프로젝트 디렉토리 이동**

3. **의존성 설치**:
   - TypeScript: `npm install`
   - Python: `pip install -e .` 또는 `uv pip install -e .`

4. **빌드** (TypeScript만):
   ```bash
   npm run build
   ```

5. **MCP Inspector 사용 안내**:
   ```bash
   # TypeScript
   npx @modelcontextprotocol/inspector node dist/index.js

   # Python
   npx @modelcontextprotocol/inspector python -m {package_name}
   ```

6. **테스트 체크리스트**:
   - [ ] 서버 정상 시작
   - [ ] 도구 목록 반환
   - [ ] 리소스 목록 반환
   - [ ] 프롬프트 목록 반환
   - [ ] 각 도구 실행 테스트
   - [ ] 에러 처리 동작

7. **테스트 스크립트 실행**: [scripts/run-tests.sh](scripts/run-tests.sh) 참조

8. **테스트 결과 보고**

9. **상태 업데이트**: 성공 시 `status`를 `tested`로 변경

10. **다음 skill 호출**: `/mcp-configure`

## 문제 해결

### 빌드 오류
- TypeScript 5.0 이상 확인
- 의존성 버전 호환성 확인

### 런타임 오류
- Node.js 18 이상 / Python 3.10 이상 확인
- 환경 변수 설정 확인

### 연결 오류
- stdio 전송 방식 확인
- 표준 입출력 처리 확인
