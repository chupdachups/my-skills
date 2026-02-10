---
name: mcp-define-prompts
description: MCP 서버의 프롬프트(Prompts)를 정의합니다. 재사용 가능한 LLM 상호작용 템플릿을 설계합니다.
user-invocable: false
allowed-tools: Read, Write
---

# MCP 프롬프트(Prompts) 정의

MCP 서버가 제공할 프롬프트를 정의합니다.

## 프롬프트란?

프롬프트(Prompts)는 재사용 가능한 LLM 상호작용 템플릿입니다. 일관된 작업 수행을 위한 표준화된 요청을 정의합니다.

## 지시사항

1. **설정 읽기**: `.mcp-config.json` 파일 확인

2. **프롬프트 정보 수집**: 각 프롬프트에 대해 질문
   - **이름**: snake_case (예: `code_review`)
   - **설명**: 프롬프트의 용도
   - **인자**: 템플릿에 전달할 파라미터들
   - **메시지 템플릿**: 실제 프롬프트 내용

3. **스키마 템플릿 참조**: [assets/prompt-template.json](assets/prompt-template.json)

4. **설정 파일 업데이트**: `.mcp-config.json`에 프롬프트 추가
   ```json
   {
     "prompts": [
       {
         "name": "code_review",
         "description": "코드를 리뷰하고 개선점 제안",
         "arguments": [
           {"name": "code", "description": "리뷰할 코드", "required": true},
           {"name": "language", "description": "프로그래밍 언어", "required": true}
         ],
         "messages": [
           {"role": "user", "content": "다음 {{language}} 코드를 리뷰해주세요:\n{{code}}"}
         ]
       }
     ]
   }
   ```

5. **추가 프롬프트 확인**

6. **정의된 프롬프트 목록 표시**

7. **다음 skill 호출**: `/mcp-implement`
