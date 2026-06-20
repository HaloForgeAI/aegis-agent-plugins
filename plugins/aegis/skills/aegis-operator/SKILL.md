---
name: aegis-operator
description: >-
  Use Aegis from Codex as an AI assistant. Trigger when the user asks to
  inspect, capture, triage, assign, dispatch, report, clean up, or diagnose
  Aegis work through the configured aegis MCP server. Do not trigger for simple
  one-off chat unless Aegis state should be read or changed.
---

# Aegis Operator For Codex

Operate Aegis state through MCP tools only, not by guessing state from
conversation or by falling back to the local CLI, REST API, curl, database
queries, repository files, or shell probes.

## Start

1. If connection, owner/profile scope, Gateway, worker, or tool readiness matters, call
   `aegis_mcp_status`.
2. For board/state work, call `aegis_board` before changing anything. Add
   `aegis_members`, `aegis_nudges`, or `aegis_team_health` when relevant.
3. Keep answers grounded in tool output. If a tool is unavailable, say which
   layer is missing: MCP config, auth, server, Gateway, provider planner,
   connected local worker, or tool-ready local worker.
4. If the required `aegis_*` MCP tool is not callable in the current host, stop
   and report `mcp_unavailable` or the concrete missing layer. Do not use
   `aegis` CLI commands, direct HTTP calls, local access-token files, or repo
   inspection as a substitute for Aegis MCP state.

## Board Discipline

Only create WorkItems for durable work requiring follow-up, assignment,
lifecycle status, evidence, or review.

Do not put ordinary questions, completed weather/time/web/script requests,
casual chat, or simple personal reminders on the board unless the user
explicitly says to track them as work.

## Main Flows

- Discover: `aegis_search_tools` when unsure which Aegis MCP tool applies;
  `aegis_lifecycle` when unsure about statuses or transitions.
- Capture: `aegis_create_item`, then optionally `aegis_comment_item`.
- Triage: `aegis_inbox`, `aegis_advance_item`, `aegis_transition_item`,
  `aegis_move_item`.
- Cleanup: `aegis_board`, then `aegis_clear_item` for non-work/accidental
  board items, or `aegis_delete_item` when the owner explicitly requests
  deletion.
- Assign: `aegis_members`, `aegis_add_member`, `aegis_assign_item`.
- Delegate: `aegis_recruiting_catalog`, `aegis_hire`, `aegis_dispatch`, or
  `aegis_switchboard`.
- Report: `aegis_team_health`, `aegis_nudges`, `aegis_report`,
  `aegis_statuses`.
- Memory/context: `aegis_memory_review`, `aegis_approve_memory`,
  `aegis_reject_memory`, `aegis_rebuild_context`, `aegis_run_compact`.
- Gateway: `aegis_gateway_status`, `aegis_gateway_accounts`,
  `aegis_gateway_deliveries`.

## Output Contract

Return concise operator-facing prose:

- What changed or what was found.
- The exact item/member/gateway ids only when useful.
- What needs owner review next.
- Any missing runtime capability as a concrete readiness gap.

Never claim that WebFetch, server-side tools, or MCP calls were a local script.
For Aegis board, report, Gateway, member, memory, or worker-state requests,
there is no non-MCP fallback. Other tools may help diagnose why MCP is missing,
but they must not be used to answer Aegis state as if the plugin operated
normally.

## More Detail

Read `references/aegis-mcp-workflows.md` when the task needs exact tool grouping,
cleanup guidance, memory review, or Gateway diagnosis.
