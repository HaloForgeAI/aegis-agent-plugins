---
name: aegis-gateway-diagnostics
description: >-
  Diagnose Aegis Gateway, channel delivery, MCP, and local worker readiness
  from Codex. Use when the user says Gateway/local worker/tools are connected
  but Aegis still claims it cannot act, or when Telegram/WeCom/HaloForge
  delivery and runtime action behavior needs evidence.
---

# Aegis Gateway Diagnostics

Be precise about the failing layer. "Gateway connected" is not the same as
"planner can call a tool-ready local worker".

## Procedure

1. Call `aegis_mcp_status`.
2. Call `aegis_gateway_status`.
3. Call `aegis_gateway_accounts`.
4. Inspect deliveries with `aegis_gateway_deliveries` when queue or channel
   reply behavior is involved.
5. For board-linked execution, inspect the relevant WorkItem and timeline with
   `aegis_board` and reports before recommending a fix.

## Diagnosis Labels

Use these labels in the answer:

- `mcp_unavailable`: Codex cannot see the Aegis MCP server.
- `auth_or_tenant_scope`: MCP/server responds but token or tenant scope is wrong.
- `server_side_ready`: server-side tools can act even if local worker cannot.
- `gateway_account_unhealthy`: platform account/binding/delivery health issue.
- `worker_connected_not_tool_ready`: a worker heartbeat exists but declared
  tools/tool schemas are absent.
- `worker_tool_ready`: local execution path exists; failures need job evidence.
- `provider_planner_missing`: AI planning provider is not configured or failed.

## Output

Return: observed state, most likely layer, evidence, and one next operational
check. Do not say Aegis has no tools when only one runtime path is missing.
