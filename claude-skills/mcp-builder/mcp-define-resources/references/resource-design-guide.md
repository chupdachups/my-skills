# MCP 리소스 설계 가이드

## URI 설계

### 스키마 선택
- `github://` - GitHub 관련
- `db://` - 데이터베이스
- `config://` - 설정
- `docs://` - 문서

### 경로 구조
```
scheme://resource-type/{parameter}/sub-resource
```

### 좋은 URI 예시
```
github://repos/{owner}/{repo}
github://repos/{owner}/{repo}/issues/{number}
config://app/settings
```

## 정적 vs 동적 리소스

### 정적 리소스
```json
{"uri": "config://settings", "uriTemplate": false}
```
- 시스템 설정, 메타데이터

### 동적 리소스
```json
{"uri": "github://repos/{owner}/{repo}", "uriTemplate": true}
```
- 특정 엔티티 조회, 파라미터화된 데이터

## MIME 타입

| 데이터 유형 | MIME 타입 |
|------------|----------|
| 구조화된 데이터 | `application/json` |
| 일반 텍스트 | `text/plain` |
| 마크다운 | `text/markdown` |
