---
name: check-standards
description: 언어별 코딩 표준 체크리스트를 기반으로 코드 품질과 컨벤션 준수 여부를 검사합니다.
---

# check-standards

코딩 표준 준수 여부를 검사하는 skill입니다.

## 설명

이 skill은 코드 리뷰 파이프라인의 세 번째 단계입니다. 변경된 코드가 프로젝트의 코딩 표준과 컨벤션을 준수하는지 검사합니다. 언어별 체크리스트를 활용하여 일관된 품질을 유지합니다.

## 지시사항

1. `.code-review-context.json`과 `.code-review-analysis.json` 파일을 읽으세요.

2. 변경된 파일들의 확장자를 확인하고, 해당 언어의 체크리스트를 `assets/` 에서 로드하세요:
   - TypeScript/JavaScript: `assets/typescript-checklist.json`
   - Python: `assets/python-checklist.json`
   - 기타: `assets/general-checklist.json`

3. 각 변경된 파일을 읽고 체크리스트 항목을 검사하세요.

4. 검사 결과를 `.code-review-standards.json`에 저장하세요:
   ```json
   {
     "checksPerformed": 25,
     "passed": 22,
     "warnings": 2,
     "errors": 1,
     "results": [
       {
         "file": "src/utils/helper.ts",
         "checks": [
           {
             "rule": "naming-convention",
             "status": "pass",
             "message": null
           },
           {
             "rule": "no-any-type",
             "status": "warning",
             "message": "Line 45: 'any' 타입 사용 발견"
           }
         ]
       }
     ],
     "summary": {
       "passRate": 88,
       "criticalIssues": ["no-console: 프로덕션 코드에 console.log 발견"]
     },
     "checkedAt": "ISO날짜"
   }
   ```

5. 검사 결과 요약을 사용자에게 표시하세요:
   - 총 검사 항목 수
   - 통과/경고/오류 수
   - 주요 이슈 목록

6. "코딩 표준 검사가 완료되었습니다. 보안 검토를 진행합니다." 라고 알리세요.

7. **반드시 다음 skill을 호출하세요: `/security-review`**

## 예시

```
[/check-standards 호출됨]
Gemini: 코딩 표준을 검사하고 있습니다...

📋 코딩 표준 검사 결과:
- 총 25개 항목 검사
- ✅ 통과: 22개
- ⚠️ 경고: 2개
- ❌ 오류: 1개

주요 이슈:
1. [WARNING] src/utils/helper.ts:45 - 'any' 타입 사용
2. [ERROR] src/api/client.ts:12 - console.log 사용

코딩 표준 검사가 완료되었습니다. 보안 검토를 진행합니다.
[/security-review 호출]
```
