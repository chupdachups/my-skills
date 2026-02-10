---
name: mcp-configure
description: MCP 클라이언트 설정을 안내합니다. Claude Desktop, Claude Code 등 다양한 클라이언트 설정 방법을 제공합니다.
user-invocable: false
allowed-tools: Read, Write
---

# MCP 클라이언트 설정

MCP 서버 제작 파이프라인의 마지막 단계입니다. 다양한 클라이언트에서 사용하기 위한 설정 방법을 안내합니다.

## 지시사항

1. **설정 읽기**: `.mcp-config.json` 파일 확인

2. **클라이언트 설정 템플릿 참조**: [assets/client-configs.json](assets/client-configs.json)

3. **Claude Desktop 설정 안내**:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "{server-name}": {
      "command": "node",
      "args": ["/absolute/path/dist/index.js"],
      "env": {"API_KEY": "your-key"}
    }
  }
}
```

4. **Claude Code 설정 안내**:

**프로젝트**: `.claude/settings.local.json`
**전역**: `~/.claude/settings.json`

```json
{
  "mcpServers": {
    "{server-name}": {
      "command": "node",
      "args": ["/absolute/path/dist/index.js"]
    }
  }
}
```

5. **환경 변수 안내**: 필요한 API 키 및 설정 방법

6. **설정 확인 방법**:
   - Claude Desktop: 재시작 후 MCP 아이콘 확인
   - Claude Code: `/mcp` 명령으로 연결 상태 확인

7. **상태 업데이트**: `status`를 `completed`로 변경

8. **최종 요약 제공**:
   - 생성된 MCP 서버 정보
   - 제공 기능 목록 (Tools, Resources, Prompts)
   - 추가 개발 가이드

## 배포 옵션

### NPM (TypeScript)
```bash
npm publish
# 사용: "command": "npx", "args": ["{server-name}"]
```

### PyPI (Python)
```bash
python -m build && twine upload dist/*
# 사용: "command": "uvx", "args": ["{server-name}"]
```
