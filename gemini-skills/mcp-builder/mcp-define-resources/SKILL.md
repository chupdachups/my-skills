---
name: mcp-define-resources
description: MCP 서버의 리소스(Resources)를 정의합니다. URI 스키마와 데이터 구조를 설계합니다.
---

# mcp-define-resources

MCP 서버의 리소스(Resources)를 정의하는 skill입니다.

## 설명

이 skill은 MCP 서버가 제공할 리소스(Resources)를 정의합니다. `references/resource-design-guide.md`를 참조하여 올바른 리소스 설계를 수행합니다.

## 지시사항

1. 현재 디렉토리의 `.mcp-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. `references/resource-design-guide.md`를 읽어 리소스 설계 가이드라인을 숙지하세요.

3. `assets/resource-schema-template.json`을 참조하여 리소스 스키마를 정의하세요.

4. 사용자에게 정의할 리소스에 대해 질문하세요:
   - **리소스 URI**: 고유 URI (예: `github://repos/{owner}/{repo}`)
   - **이름**: 리소스의 표시 이름
   - **설명**: 리소스가 제공하는 데이터
   - **MIME 타입**: 반환 데이터 형식
   - **동적 여부**: URI 템플릿 변수 포함 여부

5. 리소스 정의를 `.mcp-config.json`에 추가하세요:
   ```json
   {
     "resources": [
       {
         "uri": "scheme://path/{param}",
         "name": "리소스 이름",
         "description": "리소스 설명",
         "mimeType": "application/json",
         "uriTemplate": true
       }
     ]
   }
   ```

6. 추가 리소스가 필요한지 확인하고 반복하세요.

7. 정의된 리소스 목록을 사용자에게 표시하세요.

8. 선택된 기능에 따라 다음 skill을 호출하세요:
   - prompts 선택 시: **`/mcp-define-prompts`**
   - prompts 없는 경우: **`/mcp-implement`**

## 예시

```
[/mcp-define-tools에서 호출됨]
Gemini: 리소스(Resources)를 정의하겠습니다.

1. 리소스 URI: github://repos/{owner}/{repo}
2. 이름: 저장소 정보
3. 설명: GitHub 저장소의 메타데이터를 제공합니다
4. MIME 타입: application/json
5. 동적 URI: 예

추가 리소스: github://repos/{owner}/{repo}/issues

정의된 리소스: 2개
[/mcp-implement 호출]
```
