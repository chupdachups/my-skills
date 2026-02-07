---
name: generate-report
description: 모든 분석 결과를 종합하여 점수, 권장사항, 승인 여부를 포함한 최종 리뷰 보고서를 생성합니다.
---

# generate-report

코드 리뷰 최종 보고서를 생성하는 skill입니다.

## 설명

이 skill은 코드 리뷰 파이프라인의 마지막 단계입니다. 이전 단계들의 모든 분석 결과를 종합하여 사용자에게 명확하고 실행 가능한 피드백을 제공하는 최종 보고서를 생성합니다.

## 지시사항

1. 이전 단계에서 생성된 모든 분석 파일을 읽으세요:
   - `.code-review-context.json` - 리뷰 설정
   - `.code-review-analysis.json` - 변경사항 분석
   - `.code-review-standards.json` - 코딩 표준 검사
   - `.code-review-security.json` - 보안 검토

2. `assets/report-template.md` 템플릿을 로드하세요.

3. 템플릿을 기반으로 다음 내용을 포함한 보고서를 작성하세요:
   - 리뷰 요약 (총점, 주요 지표)
   - 변경사항 개요
   - 코딩 표준 준수 현황
   - 보안 검토 결과
   - 개선 권장 사항 (우선순위별)
   - 승인 권고 (Approve / Request Changes / Needs Discussion)

4. 최종 보고서를 `CODE_REVIEW_REPORT.md` 파일로 저장하세요.

5. 동시에 요약 정보를 `.code-review-summary.json`에 저장하세요:
   ```json
   {
     "overallScore": 85,
     "verdict": "approve|request_changes|needs_discussion",
     "highlights": {
       "positive": ["잘 작성된 테스트", "명확한 타입 정의"],
       "concerns": ["보안 취약점 1건", "console.log 사용"]
     },
     "actionItems": [
       {
         "priority": "high",
         "action": "SQL Injection 취약점 수정 필요",
         "file": "src/api/user.ts",
         "line": 45
       }
     ],
     "completedAt": "ISO날짜"
   }
   ```

6. 사용자에게 보고서 요약을 표시하고, 전체 보고서 파일 경로를 알려주세요.

7. **이것이 파이프라인의 마지막 skill입니다. 다음 skill을 호출하지 마세요.**

## 예시

```
[/generate-report 호출됨]
Gemini: 최종 보고서를 생성하고 있습니다...

═══════════════════════════════════════════
           CODE REVIEW REPORT
═══════════════════════════════════════════

📊 Overall Score: 85/100

📋 Summary:
- Files Changed: 10
- Lines Changed: +150 / -30
- Standards Compliance: 88%
- Security Issues: 1 High, 2 Medium

✅ Highlights:
- Well-structured component architecture
- Comprehensive error handling

⚠️ Action Required:
1. [HIGH] Fix SQL Injection in src/api/user.ts:45
2. [MEDIUM] Remove console.log statements

🏷️ Verdict: REQUEST CHANGES

Full report saved to: CODE_REVIEW_REPORT.md

═══════════════════════════════════════════

코드 리뷰가 완료되었습니다!
```
