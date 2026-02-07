# 코딩 표준 및 가이드라인

## 1. 일반 원칙

### 1.1 가독성 우선
- 명확하고 이해하기 쉬운 코드 작성
- 자기 문서화(Self-documenting) 코드 지향
- 복잡한 로직은 주석으로 설명

### 1.2 일관성 유지
- 기존 코드베이스의 스타일을 따름
- 같은 문제는 같은 방식으로 해결
- 팀/프로젝트 컨벤션 우선

### 1.3 단순성
- KISS (Keep It Simple, Stupid)
- YAGNI (You Aren't Gonna Need It)
- 과도한 추상화 지양

## 2. 네이밍 컨벤션

### 변수명
```
// 명확하고 의미 있는 이름
const userEmail = 'user@example.com';     // Good
const ue = 'user@example.com';            // Bad

// 불린 변수는 is, has, can 등으로 시작
const isActive = true;
const hasPermission = false;
const canEdit = true;
```

### 함수명
```
// 동사로 시작, 동작을 설명
function getUserById(id) { }              // Good
function user(id) { }                     // Bad

// 불린 반환 함수
function isValidEmail(email) { }
function hasAccess(user, resource) { }
```

### 상수명
```
// 대문자 스네이크 케이스
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';
```

## 3. 함수 작성

### 단일 책임
```
// Good: 하나의 기능만 수행
function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function sendEmail(email, content) {
  // 이메일 전송 로직
}

// Bad: 여러 기능 혼재
function validateAndSendEmail(email, content) {
  // 검증과 전송을 함께 처리
}
```

### 파라미터
```
// 3개 이하 권장
function createUser(name, email, role) { }

// 많은 파라미터는 객체로
function createUser({ name, email, role, department, manager }) { }
```

### 반환값
```
// 일관된 반환 타입
function findUser(id) {
  // 항상 User 또는 null 반환
  return user || null;
}

// 에러 처리 명확히
function parseJSON(str) {
  try {
    return { success: true, data: JSON.parse(str) };
  } catch (error) {
    return { success: false, error: error.message };
  }
}
```

## 4. 에러 처리

### 예외 처리
```
// 구체적인 에러 메시지
throw new Error(`User not found: ${userId}`);

// 적절한 에러 타입
class ValidationError extends Error {
  constructor(message) {
    super(message);
    this.name = 'ValidationError';
  }
}
```

### try-catch 사용
```
// 필요한 범위만 감싸기
try {
  const data = await fetchData();
  return processData(data);
} catch (error) {
  logger.error('Failed to fetch data', { error });
  throw new DataFetchError('Unable to retrieve data');
}
```

## 5. 테스트 작성

### 테스트 구조
```
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', () => {
      // Arrange
      const userData = { name: 'John', email: 'john@example.com' };

      // Act
      const result = userService.createUser(userData);

      // Assert
      expect(result.name).toBe('John');
    });

    it('should throw ValidationError for invalid email', () => {
      const userData = { name: 'John', email: 'invalid' };

      expect(() => userService.createUser(userData))
        .toThrow(ValidationError);
    });
  });
});
```

### 테스트 명명
```
// 형식: should [expected behavior] when [condition]
it('should return null when user not found', () => {});
it('should throw error when email is invalid', () => {});
it('should update user name when valid name provided', () => {});
```

### 테스트 커버리지
- 핵심 비즈니스 로직: 높은 커버리지
- 유틸리티 함수: 중간 커버리지
- UI 컴포넌트: 스냅샷 + 주요 인터랙션

## 6. 주석

### 언제 주석을 작성하는가
```
// Good: 왜(Why)를 설명
// 레거시 시스템 호환을 위해 이 형식 유지
const date = formatLegacyDate(timestamp);

// Bad: 무엇(What)을 설명 (코드로 명확함)
// 사용자 이메일을 가져옴
const email = user.email;
```

### TODO 주석
```
// TODO: 다음 릴리스에서 deprecated API 제거 (#123)
// FIXME: 동시성 이슈 해결 필요
// HACK: 임시 해결책, 근본 원인 조사 필요
```

## 7. 파일 구조

### 임포트 순서
```
// 1. 외부 라이브러리
import React from 'react';
import { useState } from 'react';

// 2. 내부 모듈 (절대 경로)
import { UserService } from '@/services/user';
import { Button } from '@/components/ui';

// 3. 상대 경로
import { helper } from './utils';
import styles from './styles.module.css';
```

### 파일 내 순서
```
// 1. 타입/인터페이스 정의
// 2. 상수
// 3. 헬퍼 함수
// 4. 메인 컴포넌트/클래스
// 5. 익스포트
```

## 8. Brownfield 특별 고려사항

### 레거시 코드 수정 시
- 기존 테스트 먼저 확인
- 작은 단위로 리팩토링
- 변경 전후 동작 동일성 확인

### 새 코드와 레거시 코드 공존
- 어댑터 패턴 활용
- 점진적 마이그레이션 계획
- 명확한 경계 설정

### 코드 리뷰 체크리스트
- [ ] 기존 컨벤션 준수
- [ ] 테스트 포함
- [ ] 영향 범위 확인
- [ ] 성능 영향 없음
- [ ] 보안 취약점 없음
