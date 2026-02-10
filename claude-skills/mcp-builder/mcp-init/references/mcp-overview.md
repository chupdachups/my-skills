# Model Context Protocol (MCP) 개요

## MCP란?

Model Context Protocol(MCP)은 LLM 애플리케이션과 외부 데이터 소스 및 도구 간의 원활한 통합을 가능하게 하는 오픈 프로토콜입니다.

## 핵심 구성요소

### 1. Tools (도구)
- 동적 작업을 수행하는 기능
- POST 엔드포인트와 유사
- 예: `create_issue`, `send_email`, `run_query`

### 2. Resources (리소스)
- LLM 컨텍스트에 로드할 데이터
- GET 엔드포인트와 유사
- 예: `github://repos/{owner}/{repo}`, `config://settings`

### 3. Prompts (프롬프트)
- 재사용 가능한 LLM 상호작용 템플릿
- 예: `code_review`, `summarize_document`

## 전송 방식

| 방식 | 설명 | 사용 사례 |
|------|------|----------|
| `stdio` | 표준 입출력 | 로컬 실행, CLI 도구 |
| `sse` | Server-Sent Events | 웹 기반, 원격 서버 |

## 공식 SDK

- **TypeScript**: `@modelcontextprotocol/sdk`
- **Python**: `mcp`

## 참고

- 공식 사이트: https://modelcontextprotocol.io
- GitHub: https://github.com/modelcontextprotocol
