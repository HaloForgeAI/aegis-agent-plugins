# Aegis Agent Plugins

Public agent integration packages for Aegis, the AI chief-of-staff and team
operating system.

This repository intentionally contains only distributable plugin and skill
materials. It does not publish the private Aegis application source code. The
plugins connect a host agent to an existing Aegis Server or local `aegis-mcp`
binary through explicit MCP tools.

## Packages

| Path | Host | Purpose |
|---|---|---|
| `plugins/aegis/` | Codex | Codex plugin with skills, MCP server config, icon, and prompt compatibility |
| `claude-code/aegis/` | Claude Code | Claude Code plugin with subagent, skills, MCP config, hooks, and commands |
| `skills/aegis/` | Any skill-aware agent | Portable Aegis operator skill and references |

## Codex Install

```bash
codex plugin marketplace add HaloForgeAI/aegis-agent-plugins
codex plugin add aegis@aegis-agent-plugins
```

The Codex plugin connects to an existing local Aegis Server through Streamable
HTTP MCP:

```bash
export AEGIS_TOKEN="<your access token>"
```

Default endpoint: `http://localhost:8787/mcp`.

For remote Aegis deployments, configure the same MCP shape with your hosted URL:

```toml
[mcp_servers.aegis]
url = "https://aegis.example.com/mcp"
bearer_token_env_var = "AEGIS_TOKEN"
```

The packaged stdio wrapper remains available at
`plugins/aegis/scripts/aegis-mcp-stdio.sh` for offline/development fallback
workflows.

Release notes live in [CHANGELOG.md](./CHANGELOG.md).

## Claude Code Install

From a local checkout of this repository:

```text
/plugin marketplace add ./claude-code/aegis
/plugin install aegis@haloforge-aegis
/reload-plugins
```

Set runtime connection variables:

```bash
export AEGIS_URL="http://localhost:8787"
export AEGIS_MCP_URL="http://localhost:8787/mcp/sse"
export AEGIS_TOKEN="<your access token>"
```

## Runtime Boundary

The agent should not route natural language with keyword tricks. Conversational
requests go through the host agent and Aegis planning/provider layer; workers
execute explicit `tool_call`, `tool_calls`, or `worker_probe` payloads and
record evidence.

Board items are for durable work that needs follow-up, assignment, lifecycle
status, evidence, or review. Ordinary Q&A, completed weather/time/tool
requests, casual chat, and simple personal reminders should stay out of the
work board unless the user explicitly asks to track them.

## Development

Validate the Codex package:

```bash
python3 /Users/loyio/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/aegis
bash -n plugins/aegis/scripts/aegis-mcp-stdio.sh
```

The Aegis source repository can remain private; this repository is the public
distribution surface for agent integrations.
