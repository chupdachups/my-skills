---
name: mcp-implement
description: MCP 서버의 구현 코드를 생성합니다. 정의된 도구, 리소스, 프롬프트를 실제 코드로 변환합니다.
user-invocable: false
allowed-tools: Read, Write, Bash
---

# MCP 서버 구현

정의된 Tools, Resources, Prompts를 바탕으로 구현 코드를 생성합니다.

## 지시사항

1. **설정 읽기**: `.mcp-config.json`에서 전체 설정 확인

2. **구현 패턴 참조**: [references/implementation-patterns.md](references/implementation-patterns.md)

3. **언어별 코드 생성**:

### TypeScript
```typescript
// src/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { createServer } from "./server.js";

async function main() {
  const server = createServer();
  const transport = new StdioServerTransport();
  await server.connect(transport);
}
main().catch(console.error);
```

### Python
```python
# src/{package}/__main__.py
import asyncio
from .server import create_server

def main():
    server = create_server()
    asyncio.run(server.run())

if __name__ == "__main__":
    main()
```

4. **각 기능별 핸들러 구현**:
   - 도구: 입력 유효성 검사, 로직 실행, 결과 반환
   - 리소스: URI 파싱, 데이터 조회, 응답 형식화
   - 프롬프트: 인자 치환, 메시지 구성

5. **외부 API 확인**: 사용자에게 외부 API 사용 여부 확인
   - 필요한 환경 변수 목록 작성
   - API 클라이언트 코드 생성

6. **에러 처리 추가**: 적절한 예외 처리 구현

7. **상태 업데이트**: `.mcp-config.json`의 `status`를 `implemented`로 변경

8. **생성된 파일 목록 표시**

9. **다음 skill 호출**: `/mcp-test`
