---
name: code-review-init
description: 코드 리뷰 자동화 파이프라인의 진입점. 리뷰 대상과 수준을 설정하고 컨텍스트를 초기화합니다.
---

# code-review-init

코드 리뷰 자동화 파이프라인의 진입점 skill입니다.

## 설명

이 skill은 코드 리뷰 파이프라인의 첫 번째 단계입니다. 리뷰 대상을 설정하고 리뷰 컨텍스트를 초기화합니다. Google의 코드 리뷰 가이드라인을 참조하여 체계적인 리뷰를 준비합니다.

## 지시사항

1. 사용자에게 다음 정보를 수집하세요:
   - 리뷰 대상: `branch` (브랜치 비교) 또는 `files` (특정 파일들)
   - 브랜치 선택 시: 소스 브랜치와 타겟 브랜치 이름
   - 파일 선택 시: 리뷰할 파일 경로 목록
   - 리뷰 수준: `quick` (빠른 리뷰), `standard` (표준), `thorough` (심층)

2. `references/code-review-guidelines.md` 파일을 읽어 리뷰 원칙을 숙지하세요.

3. 수집한 정보를 현재 디렉토리에 `.code-review-context.json` 파일로 저장하세요:
   ```json
   {
     "reviewType": "branch|files",
     "sourceBranch": "feature/xxx",
     "targetBranch": "main",
     "files": [],
     "reviewLevel": "quick|standard|thorough",
     "startedAt": "ISO날짜",
     "status": "initialized"
   }
   ```

4. 사용자에게 "코드 리뷰가 초기화되었습니다. 변경사항을 분석합니다." 라고 알리세요.

5. **반드시 다음 skill을 호출하세요: `/analyze-changes`**

## 예시

```
사용자: /code-review-init
Gemini: 코드 리뷰를 시작하겠습니다. 몇 가지 정보가 필요합니다...
[질문 및 응답]
Gemini: 코드 리뷰가 초기화되었습니다. 변경사항을 분석합니다.
[/analyze-changes 호출]
```
