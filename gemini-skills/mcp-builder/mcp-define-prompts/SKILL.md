---
name: mcp-define-prompts
description: MCP 서버의 프롬프트(Prompts)를 정의합니다. 재사용 가능한 LLM 상호작용 템플릿을 설계합니다.
---

# mcp-define-prompts

MCP 서버의 프롬프트(Prompts)를 정의하는 skill입니다.

## 설명

이 skill은 MCP 서버가 제공할 프롬프트(Prompts)를 정의합니다. 프롬프트는 재사용 가능한 LLM 상호작용 템플릿으로, 일관된 작업 수행을 돕습니다.

## 지시사항

1. 현재 디렉토리의 `.mcp-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. `assets/prompt-template.json`을 참조하여 프롬프트 스키마를 정의하세요.

3. 사용자에게 정의할 프롬프트에 대해 질문하세요:
   - **프롬프트 이름**: 고유 이름 (snake_case)
   - **설명**: 프롬프트의 용도
   - **인자(Arguments)**: 템플릿에 전달할 파라미터들
   - **메시지 템플릿**: 실제 프롬프트 내용

4. 프롬프트 정의를 `.mcp-config.json`에 추가하세요:
   ```json
   {
     "prompts": [
       {
         "name": "prompt_name",
         "description": "프롬프트 설명",
         "arguments": [
           {
             "name": "arg1",
             "description": "인자 설명",
             "required": true
           }
         ],
         "messages": [
           {
             "role": "user",
             "content": "{{arg1}}에 대한 내용을 분석해주세요."
           }
         ]
       }
     ]
   }
   ```

5. 추가 프롬프트가 필요한지 확인하고 반복하세요.

6. 정의된 프롬프트 목록을 사용자에게 표시하세요.

7. **반드시 다음 skill을 호출하세요: `/mcp-implement`**

## 프롬프트 설계 가이드라인

### 좋은 프롬프트 설계
- 명확한 목적과 예상 결과 정의
- 필수/선택 인자 명확히 구분
- 일관된 출력 형식 지정

### 메시지 역할
- `user`: 사용자 메시지 (요청/질문)
- `assistant`: AI 응답 (예시 응답 제공 가능)

## 예시

```
[/mcp-define-resources에서 호출됨]
Gemini: 프롬프트(Prompts)를 정의하겠습니다.

1. 프롬프트 이름: analyze_issue
2. 설명: GitHub 이슈를 분석하고 해결 방안을 제안합니다
3. 인자:
   - issue_title (필수): 이슈 제목
   - issue_body (필수): 이슈 내용
   - labels (선택): 라벨 목록
4. 메시지: "다음 GitHub 이슈를 분석하고..."

정의된 프롬프트: 1개
구현을 시작합니다.
[/mcp-implement 호출]
```
