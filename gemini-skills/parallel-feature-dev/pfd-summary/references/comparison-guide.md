# 브랜치 결과 비교 가이드

## 비교 관점

병렬로 생성된 브랜치를 비교할 때 다음 관점에서 평가하세요:

### 1. 기능 완성도

- [ ] PLAN 파일의 모든 요구사항이 구현되었는가?
- [ ] 엣지 케이스가 처리되었는가?
- [ ] API/인터페이스 스펙이 준수되었는가?

### 2. 코드 품질

- [ ] 기존 코드 스타일과 일관성이 있는가?
- [ ] 불필요한 코드가 없는가?
- [ ] 변수/함수명이 명확한가?

### 3. 테스트

- [ ] 단위 테스트가 포함되었는가?
- [ ] 기존 테스트가 통과하는가?

### 4. 변경 범위

- [ ] 최소한의 파일만 수정되었는가?
- [ ] 의도하지 않은 변경이 없는가?

## CLI 비교 명령어 모음

```bash
# 변경된 파일 수 비교
git diff --name-only main...feature/pfd-run-1 | wc -l
git diff --name-only main...feature/pfd-run-2 | wc -l

# 추가된 줄 수 비교
git diff --stat main...feature/pfd-run-1 | tail -1
git diff --stat main...feature/pfd-run-2 | tail -1

# 특정 파일 브랜치 간 비교
git diff feature/pfd-run-1:src/service.ts feature/pfd-run-2:src/service.ts
```
