---
name: mcp-scaffold
description: MCP 서버 프로젝트 디렉토리 구조와 기본 파일을 생성합니다.
user-invocable: false
allowed-tools: Read, Write, Bash
---

# MCP 프로젝트 구조 생성

`.mcp-config.json` 설정을 기반으로 프로젝트 디렉토리 구조를 생성합니다.

## 지시사항

1. **설정 읽기**: `.mcp-config.json` 파일에서 프로젝트 설정 확인

2. **구조 템플릿 참조**:
   - TypeScript: [assets/typescript-structure.json](assets/typescript-structure.json)
   - Python: [assets/python-structure.json](assets/python-structure.json)

3. **디렉토리 생성**: 선택된 언어에 맞는 구조 생성

### TypeScript 구조
```
{server-name}/
├── src/
│   ├── index.ts
│   ├── server.ts
│   ├── tools/         (tools 선택 시)
│   ├── resources/     (resources 선택 시)
│   └── prompts/       (prompts 선택 시)
├── package.json
├── tsconfig.json
└── README.md
```

### Python 구조
```
{server-name}/
├── src/{package_name}/
│   ├── __init__.py
│   ├── __main__.py
│   ├── server.py
│   ├── tools/         (tools 선택 시)
│   ├── resources/     (resources 선택 시)
│   └── prompts/       (prompts 선택 시)
├── pyproject.toml
└── README.md
```

4. **기본 파일 생성**:
   - 패키지 설정 파일 (package.json / pyproject.toml)
   - 기본 서버 코드
   - README.md

5. **스크립트 실행** (선택): [scripts/create-project.sh](scripts/create-project.sh) 참조

6. **상태 업데이트**: `.mcp-config.json`의 `status`를 `scaffolded`로 변경

7. **다음 skill 호출**:
   - tools 선택됨 → `/mcp-define-tools`
   - resources만 선택됨 → `/mcp-define-resources`
   - prompts만 선택됨 → `/mcp-define-prompts`
