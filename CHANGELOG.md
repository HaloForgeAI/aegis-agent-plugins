# Changelog

## 0.2.3 - 2026-06-07

- Codex plugin: document the new Aegis MCP cleanup and discovery flow:
  `aegis_search_tools`, `aegis_lifecycle`, `aegis_clear_item`,
  `aegis_delete_item`, and `aegis_move_item`.
- Codex plugin: require MCP-sourced Aegis board/report/Gateway/member/memory
  and worker state instead of CLI, REST, local token, database, repository, or
  chat-history fallbacks.
- Claude plugin 0.2.2: align operator guidance with the same MCP-only state,
  cleanup, and lifecycle discovery flow.
