---
name: mcp-configure
description: MCP 클라이언트 설정을 안내합니다. Claude Desktop, Claude Code 등 다양한 클라이언트 설정 방법을 제공합니다.
---

# mcp-configure

MCP 클라이언트 설정을 안내하는 skill입니다.

## 설명

이 skill은 MCP 서버 제작 파이프라인의 마지막 단계입니다. 생성된 MCP 서버를 다양한 클라이언트에서 사용하기 위한 설정 방법을 안내합니다. `assets/client-configs.json`에서 클라이언트별 설정 템플릿을 참조합니다.

## 지시사항

1. 현재 디렉토리의 `.mcp-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. `assets/client-configs.json`을 참조하여 클라이언트별 설정을 생성하세요.

3. 클라이언트별 설정 방법을 안내하세요:

### Claude Desktop
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

### Claude Code
- 프로젝트: `.claude/settings.local.json`
- 전역: `~/.claude/settings.json`

4. 환경 변수 설정이 필요한 경우 안내하세요.

5. 설정 확인 방법을 안내하세요:
   - Claude Desktop: 재시작 후 MCP 서버 아이콘 확인
   - Claude Code: `/mcp` 명령으로 연결 상태 확인

6. `.mcp-config.json`의 `status`를 `completed`로 업데이트하세요.

7. 최종 요약을 제공하세요:
   - 생성된 MCP 서버 정보
   - 제공되는 기능 목록
   - 추가 개발 가이드

## 배포 옵션

### NPM 패키지 (TypeScript)
```bash
npm publish
```

### PyPI 패키지 (Python)
```bash
python -m build
twine upload dist/*
```

## 예시

```
[/mcp-test에서 호출됨]
Gemini: 클라이언트 설정을 안내합니다.

## Claude Desktop 설정

~/Library/Application Support/Claude/claude_desktop_config.json:

{
  "mcpServers": {
    "github-issues-server": {
      "command": "python",
      "args": ["-m", "github_issues_server"],
      "cwd": "/path/to/project",
      "env": {
        "GITHUB_TOKEN": "your-token"
      }
    }
  }
}

## 환경 변수

GITHUB_TOKEN을 설정하세요:
https://github.com/settings/tokens

## 완료!

MCP 서버가 성공적으로 생성되었습니다:
- 이름: github-issues-server
- 언어: Python
- 도구: create_issue, list_issues, close_issue
- 리소스: github://repos/{owner}/{repo}
```
