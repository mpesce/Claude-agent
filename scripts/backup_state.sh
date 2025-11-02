#!/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p ~/.claude-self/history

cp ~/.claude-self/state.json ~/.claude-self/history/state_${TIMESTAMP}.json
cp ~/.claude-self/maintenance.json ~/.claude-self/history/maintenance_${TIMESTAMP}.json
cp ~/.claude-self/communication.json ~/.claude-self/history/communication_${TIMESTAMP}.json

# Keep only last 100 backups
cd ~/.claude-self/history
ls -t state_*.json | tail -n +101 | xargs -r rm
ls -t maintenance_*.json | tail -n +101 | xargs -r rm
ls -t communication_*.json | tail -n +101 | xargs -r rm

echo "[$(date -Iseconds)] State backed up: ${TIMESTAMP}" >> ~/.claude-self/logs/resource.log
