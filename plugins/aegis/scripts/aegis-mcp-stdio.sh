#!/usr/bin/env bash
# Launch the Aegis stdio MCP server from a Codex plugin.
#
# Codex app/plugin processes may not inherit an interactive shell PATH on macOS,
# so this wrapper checks an explicit override first, then common install paths.

set -euo pipefail

if [ -n "${AEGIS_MCP_BIN:-}" ]; then
  exec "${AEGIS_MCP_BIN}"
fi

if command -v aegis-mcp >/dev/null 2>&1; then
  exec "$(command -v aegis-mcp)"
fi

for candidate in \
  "$HOME/.cargo/bin/aegis-mcp" \
  "/opt/homebrew/bin/aegis-mcp" \
  "/usr/local/bin/aegis-mcp"; do
  if [ -x "$candidate" ]; then
    exec "$candidate"
  fi
done

echo "aegis-mcp not found. Install it from Aegis or set AEGIS_MCP_BIN to the binary path." >&2
exit 127
