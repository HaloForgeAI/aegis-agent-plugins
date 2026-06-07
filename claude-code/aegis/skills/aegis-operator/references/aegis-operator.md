# Aegis Operator Reference

## Status Brief

1. `aegis_mcp_status` if readiness is unknown.
2. `aegis_team_health`.
3. `aegis_nudges`.
4. `aegis_report` with `view=standup` or `view=lead`.
5. Return in-flight, blocked/at-risk, owner decisions, and next recommended
   move.

## Capture And Cleanup

Create a WorkItem only when the request is durable. For accidental captures,
use `aegis_search_tools` or `aegis_lifecycle` if the cleanup/status tool is
unclear, read the board with `aegis_board`, identify non-work items, then use
`aegis_clear_item`. Use `aegis_delete_item` with `confirm=true` only when the
owner explicitly asks to delete accidental items. If those MCP tools are not
available, stop and tell the owner which accidental items need cleanup; do not
fall back to CLI, REST/curl, database, or token-file state.

Use `aegis_move_item` when the owner names a target lifecycle status and a
strict `aegis_transition_item` would require several one-step transitions.

## Assign And Dispatch

1. Resolve the member id with `aegis_members`.
2. Add a member only when the user clearly asks for a new human or virtual
   employee.
3. Assign with `aegis_assign_item`.
4. Dispatch with `aegis_dispatch` for virtual-member work, or
   `aegis_switchboard` for coding-backend routing.
5. State that agent work stops at `testing` for human review.

## Memory Review

Approve stable identity facts, preferences, recurring corrections, and durable
project conventions. Reject one-off task details, secrets, transient mood, and
implementation guesses.
