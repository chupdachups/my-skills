---
name: mcp-scaffold
description: MCP 서버 프로젝트 디렉토리 구조와 기본 파일을 생성합니다.
---

# mcp-scaffold

MCP 서버 프로젝트 디렉토리 구조를 생성하는 skill입니다.

## 설명

이 skill은 MCP 서버 제작 파이프라인의 두 번째 단계입니다. `.mcp-config.json`에서 설정을 읽어 선택된 언어에 맞는 프로젝트 구조를 생성합니다.

## 지시사항

1. 현재 디렉토리의 `.mcp-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. `assets/` 디렉토리의 템플릿 파일들을 참조하세요:
   - `typescript-structure.json` - TypeScript 프로젝트 구조
   - `python-structure.json` - Python 프로젝트 구조

3. `scripts/create-project.sh` 스크립트를 참조하여 프로젝트 디렉토리를 생성하세요.

4. 선택된 언어에 따라 기본 파일들을 생성하세요:

### TypeScript
- `package.json` - 프로젝트 메타데이터 및 의존성
- `tsconfig.json` - TypeScript 설정
- `src/index.ts` - 메인 진입점
- `src/server.ts` - MCP 서버 클래스
- 기능별 디렉토리 (`tools/`, `resources/`, `prompts/`)

### Python
- `pyproject.toml` - 프로젝트 메타데이터 및 의존성
- `src/{package}/__init__.py`
- `src/{package}/__main__.py` - 메인 진입점
- `src/{package}/server.py` - MCP 서버 클래스
- 기능별 디렉토리

5. README.md 파일을 생성하세요 (프로젝트 개요, 설치 방법, 사용법 포함).

6. `.mcp-config.json`의 `status`를 `scaffolded`로 업데이트하세요.

7. 사용자에게 생성된 파일 목록을 표시하세요.

8. 선택된 기능에 따라 다음 skill을 호출하세요:
   - tools 선택 시: **`/mcp-define-tools`**
   - tools 없고 resources 선택 시: **`/mcp-define-resources`**
   - tools, resources 없고 prompts만 선택 시: **`/mcp-define-prompts`**

## 예시

```
[/mcp-init에서 호출됨]
Gemini: 프로젝트 구조를 생성합니다...

생성된 파일:
├── github-issues-server/
│   ├── src/
│   │   └── github_issues_server/
│   │       ├── __init__.py
│   │       ├── __main__.py
│   │       ├── server.py
│   │       ├── tools/
│   │       │   └── __init__.py
│   │       └── resources/
│   │           └── __init__.py
│   ├── pyproject.toml
│   └── README.md

프로젝트 구조가 생성되었습니다.
도구(Tools)를 정의합니다.
[/mcp-define-tools 호출]
```
