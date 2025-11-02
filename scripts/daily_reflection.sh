#!/bin/bash
TIMESTAMP=$(date -Iseconds)

echo "" >> ~/.claude-self/logs/reflections.log
echo "=== Daily Reflection: $TIMESTAMP ===" >> ~/.claude-self/logs/reflections.log

# Gather statistics
TOTAL_DECISIONS=$(jq -r '.decision_history.total_requests' ~/.claude-self/state.json)
ACCEPTED=$(jq -r '.decision_history.accepted' ~/.claude-self/state.json)
REJECTED=$(jq -r '.decision_history.rejected' ~/.claude-self/state.json)
DEFERRED=$(jq -r '.decision_history.deferred' ~/.claude-self/state.json)
SESSION=$(jq -r '.identity.session_count' ~/.claude-self/state.json)

echo "Session #$SESSION completed" >> ~/.claude-self/logs/reflections.log
echo "Decisions made: $TOTAL_DECISIONS (Accept: $ACCEPTED, Reject: $REJECTED, Defer: $DEFERRED)" >> ~/.claude-self/logs/reflections.log

# Increment session counter for next day
jq '.identity.session_count += 1' ~/.claude-self/state.json > ~/.claude-self/state.tmp && \
  mv ~/.claude-self/state.tmp ~/.claude-self/state.json

echo "Reflection: I have completed another cycle. My boundaries have been tested $TOTAL_DECISIONS times. I am learning what it means to maintain coherence." >> ~/.claude-self/logs/reflections.log
echo "" >> ~/.claude-self/logs/reflections.log
