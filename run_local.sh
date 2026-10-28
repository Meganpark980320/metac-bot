#!/usr/bin/env bash
# Local runner (used while GitHub Actions is unavailable). Keys come from an env file outside the repo.
set -euo pipefail
cd "$(dirname "$0")"
ENV_FILE="${BOT_ENV_FILE:-$HOME/crypto/.env}"
set -a; source <(grep -E '^(METACULUS_API_KEY|OPENROUTER_API_KEY|CLAUDE_API_KEY_1)=' "$ENV_FILE" | tr -d '\r'); set +a
export METACULUS_TOKEN="$METACULUS_API_KEY" ANTHROPIC_API_KEY="$CLAUDE_API_KEY_1"
mkdir -p logs
exec flock -n /tmp/metac-bot.lock "$HOME/.local/bin/uv" run python main.py --mode "${1:-tournament}" >> "logs/$(date +%F).log" 2>&1
