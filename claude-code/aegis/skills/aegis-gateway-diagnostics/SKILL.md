---
name: Aegis Gateway Diagnostics
description: >-
  Diagnose Aegis Gateway, channels, delivery queues, MCP, and local worker
  readiness. Use when Aegis reports no tools/local worker despite connected
  Gateway status, or when Telegram/WeCom/HaloForge delivery/runtime behavior
  needs evidence.
---

# Aegis Gateway Diagnostics

Gateway connected is not the same as a complete tool execution path. Diagnose
the layer precisely.

## Procedure

1. Call `aegis_mcp_status`.
2. Call `aegis_gateway_status`.
3. Call `aegis_gateway_accounts`.
4. Call `aegis_gateway_deliveries` when delivery or channel reply behavior is
   involved.
5. If the user references a WorkItem or agent run, inspect board/report context
   before recommending action.

## Labels

Use the most accurate label:

- `mcp_unavailable`
- `auth_or_tenant_scope`
- `server_side_ready`
- `gateway_account_unhealthy`
- `worker_connected_not_tool_ready`
- `worker_tool_ready`
- `provider_planner_missing`
- `delivery_queue_failure`

## Output

Give observed state, likely layer, evidence, and one next operational check. Do
not say "no tools" when server-side tools exist or only local worker execution
is missing.
