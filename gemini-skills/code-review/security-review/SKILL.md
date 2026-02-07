---
name: security-review
description: OWASP Top 10 기반으로 보안 취약점을 스캔하고 위험 요소를 식별합니다.
---

# security-review

보안 취약점을 검토하는 skill입니다.

## 설명

이 skill은 코드 리뷰 파이프라인의 네 번째 단계입니다. OWASP Top 10을 기반으로 코드의 보안 취약점을 검사하고, 보안 모범 사례 준수 여부를 확인합니다.

## 지시사항

1. 이전 단계의 분석 결과 파일들을 읽으세요:
   - `.code-review-context.json`
   - `.code-review-analysis.json`
   - `.code-review-standards.json`

2. `references/owasp-top10.md` 파일을 읽어 주요 보안 취약점 유형을 숙지하세요.

3. `scripts/security-scan.sh` 스크립트를 실행하여 자동화된 보안 검사를 수행하세요.

4. 변경된 각 파일에 대해 다음 항목을 수동 검토하세요:
   - SQL Injection 가능성
   - XSS (Cross-Site Scripting) 취약점
   - 인증/인가 문제
   - 민감 정보 노출
   - 안전하지 않은 역직렬화
   - 취약한 의존성 사용

5. 검사 결과를 `.code-review-security.json`에 저장하세요:
   ```json
   {
     "scanType": "automated+manual",
     "vulnerabilities": [
       {
         "id": "SEC-001",
         "severity": "high|medium|low|info",
         "category": "OWASP A03:2021 - Injection",
         "file": "src/api/user.ts",
         "line": 45,
         "description": "SQL 쿼리에 사용자 입력이 직접 삽입됨",
         "recommendation": "Prepared Statement 또는 ORM 사용"
       }
     ],
     "summary": {
       "critical": 0,
       "high": 1,
       "medium": 2,
       "low": 3,
       "info": 5
     },
     "passedChecks": ["CSRF 보호 확인", "HTTPS 강제"],
     "scannedAt": "ISO날짜"
   }
   ```

6. 보안 검토 결과를 사용자에게 표시하세요:
   - 심각도별 취약점 수
   - 주요 취약점 상세 내용
   - 권장 조치 사항

7. "보안 검토가 완료되었습니다. 최종 보고서를 생성합니다." 라고 알리세요.

8. **반드시 다음 skill을 호출하세요: `/generate-report`**

## 예시

```
[/security-review 호출됨]
Gemini: 보안 검토를 진행하고 있습니다...

🔒 보안 검토 결과:
- 🔴 Critical: 0건
- 🟠 High: 1건
- 🟡 Medium: 2건
- 🟢 Low: 3건

주요 발견 사항:
1. [HIGH] src/api/user.ts:45 - SQL Injection 위험
   → Prepared Statement 사용 권장

2. [MEDIUM] src/auth/login.ts:23 - 약한 비밀번호 정책
   → 최소 12자, 대소문자/숫자/특수문자 조합 권장

보안 검토가 완료되었습니다. 최종 보고서를 생성합니다.
[/generate-report 호출]
```
