# Aegis for Claude Code

这个目录是 Aegis 的 Claude Code 插件包。它不只是一个人格 prompt，而是把 Aegis 作为 chief-of-staff 接进 Claude Code：subagent、skills、MCP、SessionStart live context hook、兼容 slash commands 都在这里。

## 包含内容

| 路径 | 作用 |
|---|---|
| `.claude-plugin/plugin.json` | Claude Code plugin manifest |
| `.mcp.json` | Aegis MCP over SSE 配置 |
| `agents/aegis.md` | Aegis 子代理人格与操作边界 |
| `skills/aegis-operator/` | 看板、成员、派活、报告、记忆审核主 skill |
| `skills/aegis-gateway-diagnostics/` | Gateway / delivery / local worker 排障 skill |
| `hooks/hooks.json` | SessionStart 时注入 Aegis live snapshot |
| `scripts/aegis-context.sh` | 读取 board / nudges / members / health / Gateway 状态 |
| `commands/*.md` | 旧 slash command 兼容入口，优先使用 skills |

## 前置

- 一个可运行的 Aegis Server
- 一个 owner/collaborator Bearer token
- `AEGIS_URL` 指向 REST 地址
- `AEGIS_MCP_URL` 指向 MCP SSE 地址
- `AEGIS_TOKEN` 放 Bearer token

```bash
export AEGIS_URL="https://aegis.example.com"
export AEGIS_MCP_URL="https://aegis.example.com/mcp/sse"
export AEGIS_TOKEN="<your access token>"
```

本地默认可用：

```bash
export AEGIS_URL="http://localhost:8787"
export AEGIS_MCP_URL="http://localhost:8787/mcp/sse"
```

## 安装

把公开插件仓库加入 Claude Code plugin marketplace：

```text
/plugin marketplace add ./claude-code/aegis
/plugin install aegis@haloforge-aegis
/reload-plugins
```

装好后，Claude Code 应能看到：

- Subagent：`aegis`
- Skills：`/aegis:aegis-operator`、`/aegis:aegis-gateway-diagnostics`
- MCP server：`aegis`
- 兼容 commands：`/board`、`/capture`、`/standup`、`/report`

## 推荐用法

- “看一下当前 Aegis 工作”：用 `/aegis:aegis-operator`
- “清理误收录事项”：用 `/aegis:aegis-operator`
- “为什么 Gateway 说有 worker 但 Aegis 还是说不能做事”：用 `/aegis:aegis-gateway-diagnostics`
- “让 Aegis 子代理接手”：显式调用 `aegis` subagent

## 操作边界

- 普通问答、天气/时间、一次性脚本、简单提醒，不应自动创建 WorkItem。
- 只有 durable team work 才进入看板。
- 看板、报告、成员、Gateway、memory/context、worker 状态必须来自
  `aegis_*` MCP 工具结果；如果当前宿主看不到 MCP 工具，必须报告缺口，
  不能改用 CLI、curl/REST、本地 token、数据库、仓库文件或聊天历史回答
  Aegis 状态。
- 不确定工具或状态时先用 `aegis_search_tools` / `aegis_lifecycle`；清理
  误收录事项用 `aegis_clear_item`，明确要求删除时才用
  `aegis_delete_item(confirm=true)`。
- WebFetch、server-side tools、local worker 可用于非状态任务或 MCP 缺口
  诊断，但不能替代 `aegis_*` MCP 状态读取。
- Agent 结果停在 `testing` 是等待人工复核，不是自动发布。

人格说明与 `clients/PERSONA.md`、`crates/aegis-core/src/persona.rs` 保持同步。
