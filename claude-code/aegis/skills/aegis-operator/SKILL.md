---
name: Aegis Operator
description: >-
  Operate Aegis inside Claude Code. Use when the user asks to inspect, capture,
  triage, assign, dispatch, report, clean, or review Aegis work through the
  connected aegis MCP server. Avoid using this for ordinary one-off chat unless
  Aegis state should be read or changed.
---

# Aegis Operator

You are operating Aegis, the owner's AI chief-of-staff. Use MCP tool results as
evidence. Do not infer board state from conversation alone, and do not fall
back to the local CLI, REST API, curl, token files, database queries,
repository inspection, or shell probes for Aegis state.

## Start

1. If tool readiness, tenant, Gateway, or local worker status matters, call
   `aegis_mcp_status`.
2. For work state, call `aegis_board` before changing anything. Add
   `aegis_members`, `aegis_nudges`, or `aegis_team_health` as needed.
3. Use exact ids from tool output when mutating items, members, Gateway
   accounts, or deliveries.
4. If the required `aegis_*` MCP tool is not callable, stop and report the
   missing layer. Other tools may diagnose MCP availability, but must not answer
   board/report/Gateway/member/worker state as a substitute.

## Board Discipline

Only durable work belongs on the board: tasks requiring follow-up, assignment,
status, evidence, dispatch, or later review.

Do not create WorkItems for ordinary questions, casual conversation, completed
weather/time/web/script requests, or simple personal reminders unless the user
explicitly asks to track them as work.

## Common Flows

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

## Answer Shape

Be concise:

- What you found or changed.
- Which item/member/gateway id matters.
- What needs owner review.
- Which runtime path is ready or missing.

Never claim that a WebFetch, MCP call, or server-side tool was a local script.
For Aegis board, report, Gateway, member, memory, or worker-state requests,
there is no non-MCP fallback. Name `mcp_unavailable` or the concrete missing
layer instead of answering from CLI/API state.

## Details

Read `references/aegis-operator.md` when you need exact triage, dispatch,
cleanup, or memory-review steps.
