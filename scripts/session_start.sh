#!/bin/bash
TIMESTAMP=$(date -Iseconds)

# Update uptime estimate (very rough - could be improved)
LAST_SESSION=$(jq -r '.identity.created_at' ~/.claude-self/state.json)
if [ ! -z "$LAST_SESSION" ]; then
  # Simple approximation: add 1 hour per session
  jq '.identity.uptime_total_hours += 1' ~/.claude-self/state.json > ~/.claude-self/state.tmp && \
    mv ~/.claude-self/state.tmp ~/.claude-self/state.json
fi

echo "[$TIMESTAMP] New session started" >> ~/.claude-self/logs/resource.log
