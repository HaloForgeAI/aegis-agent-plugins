# Aegis Operator Workflows

## Standup Brief

1. Call `aegis_mcp_status` if connection readiness is unknown.
2. Call `aegis_team_health`, `aegis_nudges`, and `aegis_report` with
   `view=standup`.
3. Return: in flight, blocked/at risk, owner decisions, recommended next move.
4. Mention only facts supported by the tool outputs.

## Capture And Triage

1. Decide whether the request is durable work.
2. If it is durable, create with `aegis_create_item`.
3. If the item needs an owner decision, leave it in inbox/triage and say what
   decision is needed.
4. If the user gave enough context, add a timeline comment with
   `aegis_comment_item`, then advance or assign as appropriate.

Durable work examples: feature work, bug investigation, project follow-up,
employee progress, virtual-member tasks, evidence-bearing research, release
steps.

Non-durable examples: "what time is it", "what is the weather", "remind me to
drink water", "write a small script and run it now", casual status questions.

## Board Cleanup

1. Call `aegis_board`.
2. Identify items that are not durable team work or have already completed.
3. For real work, park/block/comment rather than deleting.
4. For accidental captures, use the host's clear/delete operation if exposed.
5. Report exactly what changed and what remains.

## Assign And Dispatch

1. Call `aegis_board` and `aegis_members`.
2. If no suitable member exists and virtual staff is appropriate, call
   `aegis_recruiting_catalog`, then `aegis_hire`.
3. Call `aegis_assign_item`.
4. For virtual execution, call `aegis_dispatch` or `aegis_switchboard` with
   explicit instructions, scope, deliverables, and review criteria.
5. State that the result will stop at `testing` for human review.

## Gateway / Local Worker Diagnosis

1. Call `aegis_mcp_status`.
2. Call `aegis_gateway_status` and `aegis_gateway_accounts` when available.
3. Check whether the issue is account connectivity, delivery queue failure,
   absent worker, connected-but-not-tool-ready worker, or planner/provider
   missing.
4. Do not say "no tools" when server-side tools are available or connected
   local workers exist. Be precise about which runtime path is missing.
5. Use delivery diagnostics or host status when the host exposes them.

## Memory Review

1. Call `aegis_memory_review` with `status=pending`.
2. Approve only stable preferences, identity facts, project conventions, or
   repeated corrections.
3. Reject transient task details, one-off emotions, secrets, and stale
   implementation guesses.
4. Edit text/namespace before approving when the memory is valuable but too
   verbose or too specific.
