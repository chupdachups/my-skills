# MCP 서버 구현 패턴

## TypeScript 구현 패턴

### 서버 초기화

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
  ListPromptsRequestSchema,
  GetPromptRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  {
    name: "server-name",
    version: "0.1.0",
  },
  {
    capabilities: {
      tools: {},
      resources: {},
      prompts: {},
    },
  }
);
```

### 도구 핸들러

```typescript
// 도구 목록 반환
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "tool_name",
        description: "도구 설명",
        inputSchema: {
          type: "object",
          properties: {
            param: { type: "string", description: "파라미터 설명" },
          },
          required: ["param"],
        },
      },
    ],
  };
});

// 도구 실행
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === "tool_name") {
    // 입력 유효성 검사
    if (!args?.param) {
      throw new Error("param is required");
    }

    // 도구 로직 실행
    const result = await executeToolLogic(args.param);

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(result),
        },
      ],
    };
  }

  throw new Error(`Unknown tool: ${name}`);
});
```

### 리소스 핸들러

```typescript
// 리소스 목록 반환
server.setRequestHandler(ListResourcesRequestSchema, async () => {
  return {
    resources: [
      {
        uri: "scheme://path",
        name: "리소스 이름",
        description: "리소스 설명",
        mimeType: "application/json",
      },
    ],
  };
});

// 리소스 읽기
server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;

  // URI 파싱
  const match = uri.match(/^scheme:\/\/path\/(.+)$/);
  if (match) {
    const data = await fetchResourceData(match[1]);
    return {
      contents: [
        {
          uri,
          mimeType: "application/json",
          text: JSON.stringify(data),
        },
      ],
    };
  }

  throw new Error(`Unknown resource: ${uri}`);
});
```

## Python 구현 패턴

### 서버 초기화

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, Resource, Prompt

server = Server("server-name")
```

### 도구 핸들러

```python
@server.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="tool_name",
            description="도구 설명",
            inputSchema={
                "type": "object",
                "properties": {
                    "param": {"type": "string", "description": "파라미터 설명"}
                },
                "required": ["param"],
            },
        )
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name == "tool_name":
        # 입력 유효성 검사
        param = arguments.get("param")
        if not param:
            raise ValueError("param is required")

        # 도구 로직 실행
        result = await execute_tool_logic(param)

        return [TextContent(type="text", text=json.dumps(result))]

    raise ValueError(f"Unknown tool: {name}")
```

### 리소스 핸들러

```python
@server.list_resources()
async def list_resources() -> list[Resource]:
    return [
        Resource(
            uri="scheme://path",
            name="리소스 이름",
            description="리소스 설명",
            mimeType="application/json",
        )
    ]

@server.read_resource()
async def read_resource(uri: str) -> str:
    import re

    match = re.match(r"^scheme://path/(.+)$", uri)
    if match:
        data = await fetch_resource_data(match.group(1))
        return json.dumps(data)

    raise ValueError(f"Unknown resource: {uri}")
```

## 에러 처리 패턴

```typescript
// TypeScript
try {
  const result = await externalApiCall();
  return { content: [{ type: "text", text: JSON.stringify(result) }] };
} catch (error) {
  if (error instanceof ValidationError) {
    throw new Error(`Invalid input: ${error.message}`);
  }
  if (error instanceof ApiError) {
    throw new Error(`API error: ${error.message}`);
  }
  throw new Error(`Unexpected error: ${error}`);
}
```

```python
# Python
try:
    result = await external_api_call()
    return [TextContent(type="text", text=json.dumps(result))]
except ValidationError as e:
    raise ValueError(f"Invalid input: {e}")
except ApiError as e:
    raise RuntimeError(f"API error: {e}")
except Exception as e:
    raise RuntimeError(f"Unexpected error: {e}")
```

## 환경 변수 패턴

```typescript
// TypeScript
const API_KEY = process.env.API_KEY;
if (!API_KEY) {
  throw new Error("API_KEY environment variable is required");
}
```

```python
# Python
import os

API_KEY = os.environ.get("API_KEY")
if not API_KEY:
    raise RuntimeError("API_KEY environment variable is required")
```
