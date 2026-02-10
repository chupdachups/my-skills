---
name: mcp-define-resources
description: MCP 서버의 리소스(Resources)를 정의합니다. URI 스키마와 데이터 구조를 설계합니다.
user-invocable: false
allowed-tools: Read, Write
---

# MCP 리소스(Resources) 정의

MCP 서버가 제공할 리소스를 정의합니다.

## 리소스란?

리소스(Resources)는 LLM 컨텍스트에 로드할 수 있는 데이터입니다. GET 엔드포인트와 유사하게 읽기 전용 데이터를 반환합니다.

가이드라인은 [references/resource-design-guide.md](references/resource-design-guide.md)를 참조하세요.

## 지시사항

1. **설정 읽기**: `.mcp-config.json` 파일 확인

2. **리소스 정보 수집**: 각 리소스에 대해 질문
   - **URI**: 고유 URI (예: `github://repos/{owner}/{repo}`)
   - **이름**: 리소스 표시 이름
   - **설명**: 리소스가 제공하는 데이터
   - **MIME 타입**: `application/json`, `text/plain` 등
   - **동적 여부**: URI 템플릿 변수 포함 여부

3. **스키마 템플릿 참조**: [assets/resource-schema-template.json](assets/resource-schema-template.json)

4. **설정 파일 업데이트**: `.mcp-config.json`에 리소스 추가
   ```json
   {
     "resources": [
       {
         "uri": "weather://current/{city}",
         "name": "현재 날씨",
         "description": "도시의 현재 날씨 데이터",
         "mimeType": "application/json",
         "uriTemplate": true
       }
     ]
   }
   ```

5. **추가 리소스 확인**: 더 필요한 리소스가 있는지 확인

6. **정의된 리소스 목록 표시**

7. **다음 skill 호출**:
   - prompts 선택됨 → `/mcp-define-prompts`
   - prompts 없음 → `/mcp-implement`
