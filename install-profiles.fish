#!/usr/bin/env fish
# ~/AI/claude-glm-proxy/install-profiles.fish - FINAL PRODUCTION VERSION
set -e

echo "🚀 Starting Claude GLM Proxy installation..."

# ── Paths ──────────────────────────────────────────────────────────
set BASE_DIR ~/AI/claude-glm-proxy
set BIN_DIR  $BASE_DIR/bin
set FUNC_DIR ~/.config/fish/functions
mkdir -p $BIN_DIR ~/.claude $FUNC_DIR

echo "✅ Created directories"

# ── Dependencies ───────────────────────────────────────────────────
for dep in claude jq
    if not command -qs $dep
        echo "❌ Missing dependency: $dep" >&2
        echo "   Install it first (e.g., via brew or the official channel)." >&2
        exit 127
    end
end
# Verify jq works with our usage
echo '{}' | jq '.ok=1' >/dev/null 2>&1; or begin
    echo "❌ jq not working as expected" >&2
    exit 127
end

echo "✅ Dependencies verified"
