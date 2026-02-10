# MCP 서버 구현 패턴

## TypeScript 패턴

### 서버 초기화
```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  { name: "server-name", version: "0.1.0" },
  { capabilities: { tools: {}, resources: {}, prompts: {} } }
);
```

### 도구 핸들러
```typescript
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [{ name: "tool_name", description: "설명", inputSchema: {...} }]
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  if (name === "tool_name") {
    const result = await executeLogic(args);
    return { content: [{ type: "text", text: JSON.stringify(result) }] };
  }
  throw new Error(`Unknown tool: ${name}`);
});
```

## Python 패턴

### 서버 초기화
```python
from mcp.server import Server
server = Server("server-name")
```

### 도구 핸들러
```python
@server.list_tools()
async def list_tools():
    return [Tool(name="tool_name", description="설명", inputSchema={...})]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "tool_name":
        result = await execute_logic(arguments)
        return [TextContent(type="text", text=json.dumps(result))]
    raise ValueError(f"Unknown tool: {name}")
```

## 환경 변수
```typescript
const API_KEY = process.env.API_KEY;
if (!API_KEY) throw new Error("API_KEY required");
```

```python
import os
API_KEY = os.environ.get("API_KEY")
if not API_KEY: raise RuntimeError("API_KEY required")
```
