# Aegis for Codex

这个目录把 Aegis 接进 Codex，目标不是只给 Codex 一个提示词，而是提供一套可复用的 chief-of-staff 工作入口。

## 包含内容

| 路径 | 作用 |
|---|---|
| `.codex-plugin/plugin.json` | Codex plugin manifest，打包 Aegis skills |
| `.mcp.json` | 插件随包声明的 `aegis` MCP server，默认连接本机 Aegis Server `/mcp` |
| `scripts/aegis-mcp-stdio.sh` | stdio fallback：在 Codex app 环境里定位并启动 `aegis-mcp` |
| `assets/` | Aegis 自有 icon / mascot，用于插件展示 |
| `skills/aegis-operator/` | 操作 Aegis MCP 工具的主 skill |
| `skills/aegis-gateway-diagnostics/` | Gateway / local worker / delivery 排障 skill |
| `config.toml` | MCP 接入示例 |
| `AGENTS.md` | 可合并到项目根目录的持久协作规则 |
| `prompts/aegis-standup.md` | 旧 custom prompt 兼容入口，优先使用 skill |

## 推荐安装

1. 让 Codex 能看到 Aegis marketplace。

这个公开仓库提供 `.agents/plugins/marketplace.json`，其中指向 `./plugins/aegis`。把仓库作为 Codex marketplace 加进 Codex：

```bash
codex plugin marketplace add HaloForgeAI/aegis-agent-plugins
codex plugin add aegis@aegis-agent-plugins
```

本地开发调试时，也可以在仓库根目录使用：

```bash
codex plugin marketplace add "$(pwd)"
codex plugin add aegis@aegis-agent-plugins
```

2. 准备 Aegis Server MCP。

Codex 插件已经随包声明 `.mcp.json`，默认连接本机 Aegis Server 的 Streamable HTTP MCP：

```json
{
  "url": "http://localhost:8787/mcp",
  "bearer_token_env_var": "AEGIS_TOKEN"
}
```

也就是说，公开插件优先使用已有 Aegis 服务，而不是要求本机先安装 `aegis-mcp`。本机启动 Aegis Server 后，设置同一套 REST Bearer token：

```bash
export AEGIS_TOKEN="<your access token>"
```

如果你要连接远程部署，把 [config.toml](./config.toml) 里的 URL 改成：

```toml
[mcp_servers.aegis]
url = "https://aegis.example.com/mcp"
bearer_token_env_var = "AEGIS_TOKEN"
```

3. 可选：stdio fallback。

如果没有运行 Aegis Server，只想让 Codex 直接跑本机 `aegis-mcp`，可以把 [config.toml](./config.toml) 的 stdio fallback 合并到 `~/.codex/config.toml`：

```toml
[mcp_servers.aegis]
command = "aegis-mcp"
```

4. 重启 Codex 或开启新线程，确认 `/mcp` 能看到 `aegis`。

本机快速确认：

```bash
codex plugin list --marketplace aegis-agent-plugins
curl -sS -H "Authorization: Bearer $AEGIS_TOKEN" \
  -H "content-type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' \
  http://localhost:8787/mcp
```

## 使用方式

- 让 Codex 自动选择：直接说“用 Aegis 看一下当前工作 / 清理误收录事项 / 诊断 Gateway”。
- 显式调用 skill：用 `@Aegis` 或 `$aegis-operator` / `$aegis-gateway-diagnostics`。
- 仅做 repo 开发规范：把 [AGENTS.md](./AGENTS.md) 合并到目标仓库根目录。

## 操作边界

- 普通问答、天气/时间、一次性脚本、简单提醒，不应自动创建 WorkItem。
- 只有 durable team work 才进入 Aegis 看板。
- 看板、成员、Gateway、worker 状态必须来自 `aegis_*` 工具结果。
- WebFetch、server-side tool、MCP、local worker 都是有效完成路径，但回复里必须诚实说明实际路径。

## 官方依据

- Codex skills 用于复用工作流，plugin 用于分发 skills / MCP / apps。
- Codex custom prompts 已偏兼容形态；新工作流优先写 skill。
- MCP 配置走 Codex `config.toml` 的 `mcp_servers` 表。

对应实现见 [skills/aegis-operator/SKILL.md](./skills/aegis-operator/SKILL.md)。
