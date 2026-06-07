# Aegis MCP Workflows

## Durable Work Test

Create a WorkItem when the request needs future tracking, lifecycle state,
assignment, dispatch, acceptance, or evidence. Do not create a WorkItem for an
ordinary question, one-off lookup, completed script/tool request, or simple
personal reminder unless the user explicitly wants it tracked as work.

## Status Brief

1. `aegis_mcp_status` when readiness is unknown.
2. `aegis_team_health`.
3. `aegis_nudges`.
4. `aegis_report` with `view=standup` or `view=lead`.
5. Summarize in flight, blocked/at risk, owner decisions, next move.

If any required `aegis_*` MCP tool is unavailable, stop and report the missing
MCP/readiness layer. Do not replace the status brief with `aegis` CLI output,
direct REST/curl calls, local token files, database queries, repository
inspection, or chat-history inference.

## Tool Discovery And Cleanup

1. Use `aegis_search_tools(q=...)` before guessing which Aegis MCP tool exists.
2. Use `aegis_lifecycle` before guessing valid work item statuses or whether a
   transition can be direct.
3. For mistaken captures, read `aegis_board`, identify the exact ids, then call
   `aegis_clear_item` to remove accidental/non-work items from the open board.
4. Use `aegis_delete_item` only when the owner explicitly asks to delete
   accidental items; pass `confirm=true`.
5. Use `aegis_move_item` for a requested target lifecycle status when
   `aegis_transition_item` would require multiple one-step transitions.

## Capture And Assign

1. `aegis_create_item` with a durable title and useful body.
2. `aegis_members` to find assignee ids.
3. `aegis_add_member` only when the user is clearly adding a new human/virtual
   member.
4. `aegis_assign_item` with the member id.
5. `aegis_comment_item` when the reason or acceptance criteria matter.

## Virtual Execution

1. `aegis_recruiting_catalog` if no virtual member exists.
2. `aegis_hire` if the user wants a new virtual member.
3. `aegis_assign_item`.
4. `aegis_dispatch` for assigned virtual-member work, or `aegis_switchboard`
   for coding backend routing.
5. Tell the user the result stops at `testing` for human review.

## Gateway / Worker Diagnosis

1. `aegis_mcp_status`.
2. `aegis_gateway_status`.
3. `aegis_gateway_accounts`.
4. `aegis_gateway_deliveries` filtered by `failed`, `dead_letter`, or
   `pending` when delivery is implicated.
5. Separate these cases in the answer: MCP disconnected, auth failed, server
   lacks provider planner, Gateway account unhealthy, no local worker,
   connected worker without tool catalog, tool-ready worker but failed job.

## Memory Review

Approve stable preferences, identity facts, recurring corrections, and durable
project conventions. Reject one-off task details, secrets, transient mood, and
implementation guesses.
