# Aegis MCP Tool Map

Use the actual tools exposed by `crates/aegis-mcp/src/server.rs`.

## Status

| Tool | Use |
|---|---|
| `aegis_mcp_status` | Check protocol, tenant scope, Gateway availability, resources, prompts, and tool count. |

## Board

| Tool | Required input | Use |
|---|---|---|
| `aegis_create_item` | `title` | Create durable work in `researching`. |
| `aegis_board` | none | List open work items. |
| `aegis_inbox` | none | List untriaged items. |
| `aegis_advance_item` | `id` | Move one normal lifecycle step. |
| `aegis_transition_item` | `id`, `to` | Move to a specific status. Status values are lowercase. |
| `aegis_assign_item` | `id`, `assignee` | Assign by member id. |
| `aegis_comment_item` | `id`, `text` | Add timeline evidence or context. |
| `aegis_suggestions` | none | Review advisory transitions inferred from recent activity. |

Status values: `researching`, `evaluating`, `developing`, `testing`,
`releasing`, `released`, `blocked`, `parked`.

## Team

| Tool | Required input | Use |
|---|---|---|
| `aegis_members` | none | List real and virtual members. |
| `aegis_add_member` | `display_name` | Add a real or virtual member. `kind` may be `human` or `virtual`. |
| `aegis_recruiting_catalog` | none | List virtual-member role templates. |
| `aegis_hire` | `template_id`, `display_name` | Provision a virtual member. |
| `aegis_dispatch` | `id`, `instructions` | Dispatch to assigned virtual member and stop at review. |
| `aegis_switchboard` | `id`, `instructions` | Route engineering work to `aegis-coder`, `claude-code`, `codex`, or `auto`. |

## Reporting

| Tool | Input | Use |
|---|---|---|
| `aegis_nudges` | none | Surface overdue, blocked, stale, and attention-needed work. |
| `aegis_report` | `view` optional | Render `lead`, `standup`, or `member` report. |
| `aegis_team_health` | none | Team-health snapshot. |
| `aegis_statuses` | none | Member live status derived from real signals. |
| `aegis_leaderboard` | `include_humans` optional | Productivity leaderboard. Humans are opt-in. |
| `aegis_search_knowledge` | `q` | Search past decisions and lessons. |

## Context And Memory

| Tool | Required input | Use |
|---|---|---|
| `aegis_start_session_context` | `session_id` | Freeze L1/base memory prefix. |
| `aegis_prepare_compact` | `session_id` | Plan context compaction. |
| `aegis_record_compact` | `session_id`, `first_kept_entry_id`, `summary`, `tokens_before` | Record a completed summary. |
| `aegis_run_compact` | `session_id` | Run deterministic or threshold-gated compaction. |
| `aegis_sweep_compact` | none | Compact recent sessions over threshold. |
| `aegis_rebuild_context` | `session_id` | Rebuild memory snapshots + compact summary + tail. |
| `aegis_end_session` | `session_id` | Finalize session memory. |
| `aegis_memory_review` | none | List pending/approved/rejected memory candidates. |
| `aegis_approve_memory` | `id` | Approve a memory candidate, optionally editing text/namespace. |
| `aegis_reject_memory` | `id` | Reject a memory candidate. |

## Talents And Gateway

| Tool | Required input | Use |
|---|---|---|
| `aegis_talents` | none | List installed talents. |
| `aegis_install_talent` | `id`, `version`, `display_name` | Install or update a talent manifest. |
| `aegis_bind_talent` | `talent_id`, `scope_kind` | Bind talent to `aegis`, `workspace`, `agent`, or `channel`. |
| `aegis_talent_bindings` | none | List talent bindings. |
| `aegis_talent_events` | `talent_id` | List audit events. |
| `aegis_gateway_status` | none | Show account health and queued delivery counts. |
| `aegis_gateway_accounts` | none | List platform accounts. |
| `aegis_gateway_register_account` | `platform`, `account_label` | Register platform account. |
| `aegis_gateway_bind` | `account_id`, `session_id`, `chat_id` | Bind account to session/chat. |
| `aegis_gateway_deliveries` | none | List queued deliveries, optional `status` filter. |
