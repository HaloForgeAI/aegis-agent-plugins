# AGENTS.md - Aegis Agent Plugin Repository

This repository publishes public integration packages for Aegis. Keep it
installer-friendly and free of private Aegis implementation code.

## Boundaries

- Do not copy Aegis server, worker, database, or internal product source here.
- Do not commit tokens, tenant ids, local database paths, private screenshots,
  or generated runtime ledgers.
- Agent hosts may include prompts, skills, commands, hooks, assets, MCP config,
  and wrapper scripts.
- Use explicit MCP/tool contracts. Do not add keyword-based natural-language
  routing or host-specific weather/date/search hacks.

## Package Layout

- `plugins/aegis/` is the Codex plugin root and must keep
  `.codex-plugin/plugin.json`.
- `.agents/plugins/marketplace.json` is the Codex marketplace root and should
  point to `./plugins/aegis`.
- `claude-code/aegis/` is the Claude Code plugin package.
- `skills/aegis/` is the portable skill package for non-Codex agents.

## Verification

- Validate Codex manifests with the Codex plugin validator before release.
- Check JSON manifests with a structured parser.
- Check shell wrappers with `bash -n`.
- For runtime claims, prefer real MCP/provider/tool evidence over prose.
