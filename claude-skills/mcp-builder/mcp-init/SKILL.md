---
name: mcp-init
description: MCP 서버 프로젝트 초기화. 서버 정보를 수집하고 설정 파일을 생성합니다. MCP 서버를 만들고 싶을 때 사용하세요.
user-invocable: true
allowed-tools: Read, Write, Bash
argument-hint: "[server-name]"
---

# MCP Server 프로젝트 초기화

MCP(Model Context Protocol) 서버 프로젝트를 초기화하는 skill입니다.

## 개요

이 skill은 MCP 서버 제작 파이프라인의 진입점입니다. 사용자로부터 정보를 수집하고 다음 skill을 자동으로 호출합니다.

## MCP란?

MCP(Model Context Protocol)는 LLM 애플리케이션과 외부 데이터 소스 및 도구를 통합하는 오픈 프로토콜입니다.

자세한 내용은 [references/mcp-overview.md](references/mcp-overview.md)를 참조하세요.

## 지시사항

1. **인자 확인**: `$ARGUMENTS`가 제공되었다면 서버 이름으로 사용

2. **정보 수집**: 사용자에게 다음 정보를 질문하세요:
   - **서버 이름**: 영문 소문자, 하이픈 허용 (예: `weather-server`)
   - **설명**: MCP 서버가 제공할 기능
   - **언어**: `typescript` 또는 `python`
   - **전송 방식**: `stdio` (기본) 또는 `sse`
   - **기능 선택**: `tools`, `resources`, `prompts` 중 복수 선택

3. **설정 파일 생성**: `.mcp-config.json` 파일 생성
   ```json
   {
     "name": "server-name",
     "description": "서버 설명",
     "language": "typescript|python",
     "transport": "stdio|sse",
     "features": {
       "tools": true,
       "resources": false,
       "prompts": false
     },
     "tools": [],
     "resources": [],
     "prompts": [],
     "createdAt": "ISO날짜",
     "status": "initialized"
   }
   ```

4. **설정 요약 출력**: 수집된 정보를 사용자에게 표시

5. **다음 skill 호출**: 반드시 `/mcp-scaffold`를 호출하여 프로젝트 구조 생성

## 예시

```
사용자: /mcp-init weather-api

Claude: MCP 서버 'weather-api'를 초기화합니다.

1. 서버 설명을 입력해주세요:
> 날씨 정보를 조회하는 MCP 서버

2. 프로그래밍 언어를 선택해주세요 (typescript/python):
> typescript

3. 제공할 기능을 선택해주세요 (tools, resources, prompts):
> tools, resources

설정이 완료되었습니다. 프로젝트 구조를 생성합니다.
[/mcp-scaffold 호출]
```
