# MCP 리소스 설계 가이드

## 리소스란?

MCP 리소스(Resources)는 LLM 컨텍스트에 로드할 수 있는 데이터를 제공합니다. GET 엔드포인트와 유사하게 읽기 전용 데이터를 반환합니다.

## URI 설계 원칙

### 스키마 선택
URI의 스키마는 리소스 유형을 나타냅니다:
- `github://` - GitHub 관련 리소스
- `db://` - 데이터베이스 리소스
- `config://` - 설정 리소스
- `docs://` - 문서 리소스
- `file://` - 파일 시스템 리소스

### 경로 구조
```
scheme://resource-type/{parameter}/sub-resource
```

### 좋은 URI 예시
```
github://repos/{owner}/{repo}
github://repos/{owner}/{repo}/issues/{number}
db://tables/{table}/records/{id}
config://app/settings
```

### 나쁜 URI 예시
```
get-repo          # 스키마 없음
github://getRepo  # 카멜케이스, 동사 사용
data://1234       # 불명확한 경로
```

## 정적 vs 동적 리소스

### 정적 리소스
고정된 URI로 접근하는 리소스:
```json
{
  "uri": "config://app/settings",
  "uriTemplate": false
}
```

사용 사례:
- 시스템 설정
- 메타데이터
- 정적 문서

### 동적 리소스 (URI 템플릿)
파라미터화된 URI로 접근하는 리소스:
```json
{
  "uri": "github://repos/{owner}/{repo}",
  "uriTemplate": true
}
```

사용 사례:
- 특정 엔티티 조회
- 사용자별 데이터
- 필터링된 결과

## MIME 타입 선택

| 데이터 유형 | MIME 타입 |
|------------|----------|
| 구조화된 데이터 | `application/json` |
| 일반 텍스트 | `text/plain` |
| 마크다운 | `text/markdown` |
| HTML | `text/html` |
| 바이너리 | `application/octet-stream` |

## 설명 작성

### 포함할 내용
1. 리소스가 제공하는 **데이터 유형**
2. **사용 사례** 또는 **용도**
3. 반환되는 **데이터 구조** 개요
4. **제한사항** (있는 경우)

### 예시
```
"지정된 GitHub 저장소의 메타데이터를 제공합니다.
반환 데이터: 저장소 이름, 설명, 스타 수, 포크 수,
기본 브랜치, 생성일, 최근 업데이트일.
비공개 저장소는 인증이 필요합니다."
```

## 데이터 구조 권장사항

### 일관성 유지
- 동일 유형의 리소스는 동일한 구조 사용
- 필드명은 snake_case 또는 camelCase 중 하나로 통일

### 페이지네이션
대용량 데이터는 페이지네이션 고려:
```json
{
  "data": [...],
  "pagination": {
    "total": 100,
    "page": 1,
    "per_page": 20,
    "next_cursor": "abc123"
  }
}
```

### 메타데이터 포함
```json
{
  "data": {...},
  "metadata": {
    "retrieved_at": "2024-01-01T00:00:00Z",
    "source": "github-api"
  }
}
```

## 캐싱 고려사항

- 자주 변경되지 않는 데이터는 캐시 권장
- 변경 빈도에 따른 TTL 설정
- 캐시 무효화 전략 고려
