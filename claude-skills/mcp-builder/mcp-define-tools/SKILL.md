---
name: mcp-define-tools
description: MCP 서버의 도구(Tools)를 정의합니다. 입력 스키마와 동작을 설계합니다.
user-invocable: false
allowed-tools: Read, Write
---

# MCP 도구(Tools) 정의

MCP 서버가 제공할 도구를 정의합니다.

## 도구란?

도구(Tools)는 LLM이 호출할 수 있는 동적 작업입니다. POST 엔드포인트와 유사하게 외부 시스템과 상호작용하거나 상태를 변경할 수 있습니다.

가이드라인은 [references/tool-design-guide.md](references/tool-design-guide.md)를 참조하세요.

## 지시사항

1. **설정 읽기**: `.mcp-config.json` 파일 확인

2. **도구 정보 수집**: 각 도구에 대해 질문
   - **이름**: snake_case (예: `get_weather`)
   - **설명**: 도구가 수행하는 작업
   - **입력 파라미터**: 이름, 타입, 설명, 필수 여부
   - **출력 형식**: 반환 데이터 형식

3. **스키마 템플릿 참조**: [assets/tool-schema-template.json](assets/tool-schema-template.json)

4. **설정 파일 업데이트**: `.mcp-config.json`에 도구 추가
   ```json
   {
     "tools": [
       {
         "name": "get_weather",
         "description": "도시의 현재 날씨 조회",
         "inputSchema": {
           "type": "object",
           "properties": {
             "city": {"type": "string", "description": "도시 이름"}
           },
           "required": ["city"]
         }
       }
     ]
   }
   ```

5. **추가 도구 확인**: 더 필요한 도구가 있는지 사용자에게 확인

6. **정의된 도구 목록 표시**

7. **다음 skill 호출**:
   - resources 선택됨 → `/mcp-define-resources`
   - prompts만 선택됨 → `/mcp-define-prompts`
   - 둘 다 없음 → `/mcp-implement`
