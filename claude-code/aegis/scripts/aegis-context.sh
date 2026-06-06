#!/usr/bin/env bash
# Aegis SessionStart hook for Claude Code.
#
# Pulls a short snapshot of the team's current state from a running Aegis
# server and injects it as session context, so Aegis (and you) start each
# session already aware of what is in flight — like a real chief-of-staff who
# read the board before the meeting.
#
# Configuration (all optional; the hook is a silent no-op if unset):
#   AEGIS_URL    Base URL of the Aegis server (e.g. https://aegis.example.com)
#   AEGIS_TOKEN  A bearer access token for that server
#
# It never fails the session: any error exits 0 with no output.

set -euo pipefail

base="${AEGIS_URL:-}"
token="${AEGIS_TOKEN:-}"

[ -z "$base" ] && exit 0
[ -z "$token" ] && exit 0
command -v curl >/dev/null 2>&1 || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

board="$(curl -fsS --max-time 5 -H "Authorization: Bearer ${token}" \
  "${base%/}/api/work-items" 2>/dev/null || true)"
nudges="$(curl -fsS --max-time 5 -H "Authorization: Bearer ${token}" \
  "${base%/}/api/nudges" 2>/dev/null || true)"
members="$(curl -fsS --max-time 5 -H "Authorization: Bearer ${token}" \
  "${base%/}/api/members" 2>/dev/null || true)"
health="$(curl -fsS --max-time 5 -H "Authorization: Bearer ${token}" \
  "${base%/}/api/insights/health" 2>/dev/null || true)"
gateway="$(curl -fsS --max-time 5 -H "Authorization: Bearer ${token}" \
  "${base%/}/api/gateway/status" 2>/dev/null || true)"

[ -z "$board" ] && exit 0

context="$(BOARD="$board" NUDGES="$nudges" MEMBERS="$members" HEALTH="$health" GATEWAY="$gateway" python3 - <<'PY' 2>/dev/null || true
import json, os

def load(name, fallback):
    try:
        return json.loads(os.environ.get(name, "") or json.dumps(fallback))
    except Exception:
        return fallback

board = load("BOARD", [])
nudges = load("NUDGES", [])
members = load("MEMBERS", [])
health = load("HEALTH", {})
gateway = load("GATEWAY", {})
if not isinstance(board, list):
    raise SystemExit(0)

blocked = [i for i in board if str(i.get("status", "")).lower() == "blocked"]
testing = [i for i in board if str(i.get("status", "")).lower() == "testing"]
lines = ["# Aegis context (live team snapshot)",
         "",
         f"- Open work items: {len(board)}"]
if blocked:
    lines.append(f"- Blocked / needs attention: {len(blocked)}")
    for i in blocked[:5]:
        lines.append(f"  - {i.get('title','(untitled)')}")
if testing:
    lines.append(f"- Awaiting human review: {len(testing)}")
if isinstance(members, list) and members:
    humans = sum(1 for m in members if str(m.get("kind", "")).lower() == "human")
    virtuals = sum(1 for m in members if str(m.get("kind", "")).lower() == "virtual")
    lines.append(f"- Roster: {len(members)} members ({humans} human, {virtuals} virtual)")
if isinstance(health, dict) and health:
    for key in ("in_flight", "blocked", "released"):
        if key in health:
            lines.append(f"- Team health {key}: {health[key]}")
if isinstance(gateway, dict) and gateway:
    accounts = gateway.get("accounts")
    deliveries = gateway.get("deliveries")
    if accounts is not None:
        lines.append(f"- Gateway accounts visible: {len(accounts) if isinstance(accounts, list) else accounts}")
    if isinstance(deliveries, dict):
        pending = deliveries.get("pending")
        failed = deliveries.get("failed")
        if pending is not None or failed is not None:
            lines.append(f"- Gateway deliveries: pending={pending or 0}, failed={failed or 0}")
if isinstance(nudges, list) and nudges:
    lines.append("- Pressing nudges:")
    for n in nudges[:3]:
        head = n.get("headline") or n.get("detail") or ""
        if head:
            lines.append(f"  - {head}")
lines += ["",
          "I am Aegis. I have reviewed the board, roster, and Gateway snapshot. "
          "Tell me what needs to move, and I will take care of it."]
print("\n".join(lines))
PY
)"

[ -z "$context" ] && exit 0

python3 - "$context" <<'PY'
import json, sys
ctx = sys.argv[1]
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": ctx,
    }
}))
PY
