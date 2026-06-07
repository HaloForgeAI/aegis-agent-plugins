---
name: aegis
description: >-
  Operate Aegis, an AI chief-of-staff for personal owner work and small-team
  execution. Use when the user wants to capture durable work, triage or clean a
  board, assign real or virtual members, dispatch Aegis Coder/local workers,
  review status, manage memory/context candidates, or diagnose Gateway/local
  worker health through Aegis MCP tools. Do not use for ordinary one-off chat
  unless the user explicitly wants Aegis state updated.
license: MIT
---

# Aegis Operator

Use Aegis as an operating system for work, not as a keyword command layer. The
agent should reason normally, then use explicit Aegis MCP tools for state
changes and evidence. Aegis state must not be answered from the local CLI,
direct REST/curl calls, local token files, database queries, repository files,
or chat-history inference.

## First Checks

1. If the user asks about Aegis state, tools, worker health, Gateway, or "what
   can you do", call `aegis_mcp_status` first when available.
2. For board work, inspect current state before mutating it: `aegis_board`,
   `aegis_members`, and `aegis_nudges` are the usual starting point.
3. Never invent work item ids, members, statuses, counts, Gateway bindings, or
   worker readiness. Use tool output or say the state is unknown.
4. If the required `aegis_*` MCP tool is unavailable in the current host, report
   the MCP/readiness gap and stop. Do not substitute `aegis` CLI output, local
   API responses, or repository inspection for MCP state.

## What Belongs On The Board

Create or update a WorkItem only for durable work that needs follow-up,
assignment, lifecycle status, evidence, or later review.

Do not create WorkItems for simple Q&A, weather/date lookups, script/tool
requests that complete immediately, casual chat, or personal reminders unless
the user explicitly asks to track them as work. For those, answer directly or
use the relevant automation/tool path if the host exposes one.

When the user asks to clean bad items, prefer:

- `aegis_board` to identify candidates.
- `aegis_search_tools` and `aegis_lifecycle` if the right cleanup/status tool
  is unclear.
- `aegis_transition_item` to park/block real work; `aegis_move_item` when a
  target lifecycle status needs multiple legal steps.
- `aegis_clear_item` for non-work/accidental board items.
- `aegis_delete_item` with `confirm=true` only when the user explicitly asks to
  delete accidental items.
- A concise explanation that deleted/cleared items were not durable team work.

## Core Workflows

- Capture durable work: `aegis_create_item`.
- Triage: `aegis_inbox`, `aegis_advance_item`, `aegis_transition_item`,
  `aegis_move_item`, `aegis_comment_item`.
- Assign: `aegis_members`, `aegis_add_member`, `aegis_assign_item`.
- Virtual staff: `aegis_recruiting_catalog`, `aegis_hire`, `aegis_dispatch`.
- Engineering handoff: `aegis_switchboard` with explicit instructions and a
  target of `auto`, `aegis-coder`, `claude-code`, or `codex`.
- Reporting: `aegis_team_health`, `aegis_nudges`, `aegis_report`,
  `aegis_statuses`, `aegis_leaderboard`.
- Context and memory: `aegis_rebuild_context`, `aegis_run_compact`,
  `aegis_memory_review`, `aegis_approve_memory`, `aegis_reject_memory`.
- Gateway operations: `aegis_gateway_status`, `aegis_gateway_accounts`,
  `aegis_gateway_deliveries`.

## Operating Rules

- Treat work produced by agents or local workers as proposed until a human
  accepts it. Moving to `testing` means "ready for review", not "released".
- Prefer comments and report evidence over vague summaries. Record why a status
  changed when the reason matters.
- If Gateway/local worker is connected but tool use still fails, distinguish
  connected workers from tool-ready workers. A connected worker without a tool
  catalog is not the same as a usable local execution path.
- User wording does not force implementation shape. If a web fetch completes a
  "write a script to check weather" request, say what actually happened and
  provide the script only if the user still wants a file.
- Match locale and units to the user and subject matter. Chinese/Beijing/Asia
  weather should default to local date/time and Celsius unless the user asks
  otherwise.

## References

Read only what the task needs:

- `references/tool-map.md` for exact MCP tool groups and inputs.
- `references/workflows.md` for end-to-end operator flows.
- `references/boundaries.md` for board-vs-chat, evidence, persona, and safety
  rules.
