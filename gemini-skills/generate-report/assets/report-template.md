# Code Review Report

## 메타데이터

| 항목 | 값 |
|------|-----|
| 리뷰 ID | {{REVIEW_ID}} |
| 생성일시 | {{GENERATED_AT}} |
| 리뷰 대상 | {{REVIEW_TARGET}} |
| 리뷰 수준 | {{REVIEW_LEVEL}} |

---

## 1. 종합 평가

### 1.1 Overall Score

```
┌─────────────────────────────────────────┐
│                                         │
│        Overall Score: {{SCORE}}/100     │
│                                         │
│   ████████████░░░░░░  {{SCORE}}%        │
│                                         │
└─────────────────────────────────────────┘
```

### 1.2 Verdict

**{{VERDICT_EMOJI}} {{VERDICT}}**

{{VERDICT_DESCRIPTION}}

### 1.3 Score Breakdown

| 카테고리 | 점수 | 상태 |
|---------|------|------|
| 코드 품질 | {{QUALITY_SCORE}}/100 | {{QUALITY_STATUS}} |
| 보안 | {{SECURITY_SCORE}}/100 | {{SECURITY_STATUS}} |
| 표준 준수 | {{STANDARDS_SCORE}}/100 | {{STANDARDS_STATUS}} |
| 문서화 | {{DOCS_SCORE}}/100 | {{DOCS_STATUS}} |

---

## 2. 변경사항 개요

### 2.1 통계

| 항목 | 수치 |
|------|------|
| 변경된 파일 수 | {{TOTAL_FILES}} |
| 추가된 라인 | +{{ADDITIONS}} |
| 삭제된 라인 | -{{DELETIONS}} |
| 총 변경 라인 | {{TOTAL_CHANGES}} |

### 2.2 파일 타입별 분포

{{FILE_TYPES_TABLE}}

### 2.3 영향 영역

{{IMPACT_AREAS_LIST}}

---

## 3. 코딩 표준 검사 결과

### 3.1 검사 요약

| 상태 | 건수 |
|------|------|
| ✅ 통과 | {{STANDARDS_PASSED}} |
| ⚠️ 경고 | {{STANDARDS_WARNINGS}} |
| ❌ 오류 | {{STANDARDS_ERRORS}} |

### 3.2 주요 이슈

{{STANDARDS_ISSUES_LIST}}

---

## 4. 보안 검토 결과

### 4.1 취약점 요약

| 심각도 | 건수 |
|--------|------|
| 🔴 Critical | {{SECURITY_CRITICAL}} |
| 🟠 High | {{SECURITY_HIGH}} |
| 🟡 Medium | {{SECURITY_MEDIUM}} |
| 🟢 Low | {{SECURITY_LOW}} |
| ℹ️ Info | {{SECURITY_INFO}} |

### 4.2 취약점 상세

{{SECURITY_VULNERABILITIES_LIST}}

### 4.3 통과한 보안 검사

{{SECURITY_PASSED_CHECKS}}

---

## 5. 개선 권장 사항

### 5.1 필수 조치 (Blockers)

{{BLOCKERS_LIST}}

### 5.2 권장 조치 (Should Fix)

{{SHOULD_FIX_LIST}}

### 5.3 개선 제안 (Nice to Have)

{{NICE_TO_HAVE_LIST}}

---

## 6. 긍정적 측면

{{POSITIVE_ASPECTS_LIST}}

---

## 7. 결론

{{CONCLUSION}}

---

## Appendix A: 검사한 파일 목록

{{FILES_LIST}}

---

## Appendix B: 사용된 체크리스트

- 코딩 표준: {{STANDARDS_CHECKLIST}}
- 보안 가이드라인: OWASP Top 10 (2021)
- 리뷰 가이드라인: Google Engineering Practices

---

*이 보고서는 자동화된 코드 리뷰 파이프라인에 의해 생성되었습니다.*
*생성 도구: Gemini Code Review Pipeline v1.0*
