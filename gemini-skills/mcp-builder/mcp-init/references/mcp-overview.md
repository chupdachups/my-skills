# Model Context Protocol (MCP) 개요

## MCP란?

Model Context Protocol(MCP)은 LLM 애플리케이션과 외부 데이터 소스 및 도구 간의 원활한 통합을 가능하게 하는 오픈 프로토콜입니다.

Language Server Protocol(LSP)이 프로그래밍 언어 지원을 표준화한 것처럼, MCP는 AI 애플리케이션 생태계에서 추가 컨텍스트와 도구 통합을 표준화합니다.

## 핵심 구성요소

### 1. Tools (도구)

동적 작업을 수행하는 기능입니다. POST 엔드포인트와 유사합니다.

**특징**:
- LLM이 호출하여 실행
- 외부 시스템과 상호작용
- 상태 변경 가능
- 입력 파라미터와 반환값 정의

**예시**:
- `create_issue` - GitHub 이슈 생성
- `send_email` - 이메일 발송
- `run_query` - 데이터베이스 쿼리 실행

### 2. Resources (리소스)

LLM 컨텍스트에 로드할 데이터를 제공합니다. GET 엔드포인트와 유사합니다.

**특징**:
- 읽기 전용 데이터 제공
- URI로 식별
- 정적 또는 동적(템플릿) URI 지원

**예시**:
- `github://repos/{owner}/{repo}` - 저장소 정보
- `config://settings` - 설정 데이터
- `docs://api-reference` - API 문서

### 3. Prompts (프롬프트)

재사용 가능한 LLM 상호작용 템플릿입니다.

**특징**:
- 일관된 작업 수행
- 파라미터화 가능
- 여러 메시지로 구성 가능

**예시**:
- `code_review` - 코드 리뷰 요청 템플릿
- `summarize_document` - 문서 요약 템플릿

## 아키텍처

```
┌─────────────┐     MCP Protocol     ┌─────────────┐
│  MCP Client │ ◄─────────────────► │  MCP Server │
│  (Claude,   │      (JSON-RPC)      │  (Your App) │
│   etc.)     │                      │             │
└─────────────┘                      └─────────────┘
                                            │
                                            ▼
                                     ┌─────────────┐
                                     │  External   │
                                     │  Services   │
                                     │  (APIs,DBs) │
                                     └─────────────┘
```

## 전송 방식

### stdio (표준 입출력)
- 로컬 프로세스 간 통신
- 가장 간단한 설정
- Claude Desktop, Claude Code에서 주로 사용

### SSE (Server-Sent Events)
- HTTP 기반 원격 통신
- 웹 환경에 적합
- 상태 유지 연결

## 공식 SDK

- **TypeScript**: `@modelcontextprotocol/sdk`
- **Python**: `mcp`

## 참고 자료

- 공식 사이트: https://modelcontextprotocol.io
- GitHub: https://github.com/modelcontextprotocol
- Anthropic 블로그: https://www.anthropic.com/news/model-context-protocol
