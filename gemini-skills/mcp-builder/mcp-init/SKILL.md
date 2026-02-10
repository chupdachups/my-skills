---
name: mcp-init
description: MCP 서버 프로젝트 초기화를 시작하는 진입점. 서버 정보를 수집하고 컨텍스트를 설정합니다.
---

# mcp-init

MCP(Model Context Protocol) 서버 프로젝트 초기화를 시작하는 진입점 skill입니다.

## 설명

이 skill은 MCP 서버 제작 파이프라인의 첫 번째 단계입니다. 사용자로부터 MCP 서버 프로젝트 정보를 수집하고 다음 skill을 호출합니다. `references/mcp-overview.md`를 참조하여 MCP 개념을 이해합니다.

## 지시사항

1. `references/mcp-overview.md` 파일을 읽어 MCP 개념을 숙지하세요.

2. `assets/init-questions.md` 파일을 참조하여 사용자에게 다음 정보를 질문하세요:
   - **서버 이름**: MCP 서버의 이름 (영문, 소문자, 하이픈 허용)
   - **설명**: MCP 서버가 제공할 기능에 대한 간단한 설명
   - **프로그래밍 언어**: `typescript` 또는 `python` 중 선택
   - **전송 방식**: `stdio` 또는 `sse` 중 선택
   - **제공할 기능**: `tools`, `resources`, `prompts` 중 복수 선택

3. 수집한 정보를 현재 디렉토리에 `.mcp-config.json` 파일로 저장하세요:
   ```json
   {
     "name": "서버이름",
     "description": "서버 설명",
     "language": "typescript|python",
     "transport": "stdio|sse",
     "features": {
       "tools": true|false,
       "resources": true|false,
       "prompts": true|false
     },
     "tools": [],
     "resources": [],
     "prompts": [],
     "createdAt": "ISO날짜",
     "status": "initialized"
   }
   ```

4. 저장이 완료되면 사용자에게 "MCP 서버 프로젝트 정보가 수집되었습니다."라고 알리고 선택한 설정 요약을 표시하세요.

5. **반드시 다음 skill을 호출하세요: `/mcp-scaffold`**

## 예시

```
사용자: /mcp-init
Gemini: MCP 서버 프로젝트를 초기화하겠습니다. 몇 가지 정보가 필요합니다...

1. 서버 이름을 입력해주세요:
사용자: github-issues-server

2. 서버 설명을 입력해주세요:
사용자: GitHub 이슈를 관리하는 MCP 서버

3. 프로그래밍 언어를 선택해주세요:
사용자: python

4. 전송 방식을 선택해주세요:
사용자: stdio

5. 제공할 기능을 선택해주세요:
사용자: tools, resources

Gemini: MCP 서버 프로젝트 정보가 수집되었습니다.
프로젝트 구조를 생성합니다.
[/mcp-scaffold 호출]
```
