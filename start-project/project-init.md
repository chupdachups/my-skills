# project-init

Full-Stack 프로젝트 초기화를 시작하는 진입점 skill입니다.

## 설명

이 skill은 프로젝트 생성 파이프라인의 첫 번째 단계입니다. 사용자로부터 프로젝트 정보를 수집하고 다음 skill을 호출합니다.

## 지시사항

1. 사용자에게 다음 정보를 질문하세요:
   - 프로젝트 이름 (영문, 소문자, 하이픈 허용)
   - 프로젝트 설명
   - 프레임워크 선택: React, Vue, Svelte 중 하나
   - 백엔드 포함 여부: Yes/No

2. 수집한 정보를 현재 디렉토리에 `.project-config.json` 파일로 저장하세요:
   ```json
   {
     "name": "프로젝트이름",
     "description": "프로젝트 설명",
     "framework": "react|vue|svelte",
     "includeBackend": true|false,
     "createdAt": "ISO날짜"
   }
   ```

3. 저장이 완료되면 사용자에게 "프로젝트 정보가 수집되었습니다. 디렉토리 구조를 생성합니다." 라고 알리세요.

4. **반드시 다음 skill을 호출하세요: `/scaffold`**

## 예시

```
사용자: /project-init
Claude: 프로젝트 정보를 수집하겠습니다...
[질문 및 응답]
Claude: 프로젝트 정보가 수집되었습니다. 디렉토리 구조를 생성합니다.
[/scaffold 호출]
```
