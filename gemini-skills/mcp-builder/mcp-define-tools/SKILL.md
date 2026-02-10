---
name: mcp-define-tools
description: MCP 서버의 도구(Tools)를 정의합니다. 입력 스키마와 동작을 설계합니다.
---

# mcp-define-tools

MCP 서버의 도구(Tools)를 정의하는 skill입니다.

## 설명

이 skill은 MCP 서버가 제공할 도구(Tools)를 정의합니다. `references/tool-design-guide.md`를 참조하여 올바른 도구 설계를 수행합니다.

## 지시사항

1. 현재 디렉토리의 `.mcp-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. `references/tool-design-guide.md`를 읽어 도구 설계 가이드라인을 숙지하세요.

3. `assets/tool-schema-template.json`을 참조하여 도구 스키마를 정의하세요.

4. 사용자에게 정의할 도구에 대해 질문하세요:
   - **도구 이름**: 고유 이름 (snake_case)
   - **설명**: 도구가 수행하는 작업
   - **입력 파라미터**: 이름, 타입, 설명, 필수 여부
   - **출력 형식**: 반환 데이터 형식

5. 도구 정의를 `.mcp-config.json`에 추가하세요:
   ```json
   {
     "tools": [
       {
         "name": "tool_name",
         "description": "도구 설명",
         "inputSchema": {
           "type": "object",
           "properties": { ... },
           "required": [...]
         }
       }
     ]
   }
   ```

6. 추가 도구가 필요한지 확인하고 반복하세요.

7. 정의된 도구 목록을 사용자에게 표시하세요.

8. 선택된 기능에 따라 다음 skill을 호출하세요:
   - resources 선택 시: **`/mcp-define-resources`**
   - resources 없고 prompts 선택 시: **`/mcp-define-prompts`**
   - 둘 다 없는 경우: **`/mcp-implement`**

## 예시

```
[/mcp-scaffold에서 호출됨]
Gemini: 도구(Tools)를 정의하겠습니다.

1. 도구 이름: create_issue
2. 설명: GitHub 저장소에 새 이슈를 생성합니다
3. 입력 파라미터:
   - owner (string, 필수): 저장소 소유자
   - repo (string, 필수): 저장소 이름
   - title (string, 필수): 이슈 제목
   - body (string, 선택): 이슈 내용

추가 도구: list_issues, close_issue

정의된 도구: 3개
[/mcp-define-resources 호출]
```
