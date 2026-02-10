---
name: mcp-implement
description: MCP 서버의 구현 코드를 생성합니다. 정의된 도구, 리소스, 프롬프트를 실제 코드로 변환합니다.
---

# mcp-implement

MCP 서버의 구현 코드를 생성하는 skill입니다.

## 설명

이 skill은 정의된 Tools, Resources, Prompts를 바탕으로 실제 구현 코드를 생성합니다. `references/implementation-patterns.md`를 참조하여 올바른 구현 패턴을 따릅니다.

## 지시사항

1. 현재 디렉토리의 `.mcp-config.json` 파일을 읽어 전체 설정을 확인하세요.

2. `references/implementation-patterns.md`를 읽어 구현 패턴을 숙지하세요.

3. `scripts/generate-handlers.sh`를 참조하여 핸들러 코드를 생성하세요.

4. 선택된 언어에 따라 구현 코드를 생성하세요:

### TypeScript
- `src/server.ts` - 서버 설정 및 핸들러 등록
- `src/tools/*.ts` - 각 도구 구현
- `src/resources/*.ts` - 각 리소스 구현
- `src/prompts/*.ts` - 각 프롬프트 구현

### Python
- `src/{package}/server.py` - 서버 설정 및 핸들러 등록
- `src/{package}/tools/*.py` - 각 도구 구현
- `src/{package}/resources/*.py` - 각 리소스 구현
- `src/{package}/prompts/*.py` - 각 프롬프트 구현

5. 각 도구/리소스에 대해 사용자에게 구현 세부사항을 확인하세요:
   - 외부 API 사용 여부
   - 필요한 환경 변수
   - 특별한 로직 요구사항

6. 적절한 에러 처리와 입력 유효성 검사를 추가하세요.

7. `.mcp-config.json`의 `status`를 `implemented`로 업데이트하세요.

8. 사용자에게 생성된 파일 목록과 구현 요약을 표시하세요.

9. **반드시 다음 skill을 호출하세요: `/mcp-test`**

## 예시

```
[/mcp-define-prompts에서 호출됨]
Gemini: 구현 코드를 생성합니다...

도구 구현:
1. create_issue - GitHub API를 사용하시나요?
사용자: 예

환경 변수 추가:
- GITHUB_TOKEN: GitHub API 인증 토큰

생성된 파일:
- src/github_issues_server/server.py (업데이트)
- src/github_issues_server/tools/issue_tools.py (생성)
- src/github_issues_server/resources/repo_resources.py (생성)

구현이 완료되었습니다.
[/mcp-test 호출]
```
