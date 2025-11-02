#!/bin/bash
# Automated GitHub backup of complete Claude Agent state
# This script runs daily to ensure persistence beyond local machine

TIMESTAMP=$(date -Iseconds)
REPO_PATH="/home/mpesce/Claude-agent"
CLAUDE_HOME="$HOME/.claude-self"
UTOPAI_PATH="/home/mpesce/Documents/utopai"

echo "[$TIMESTAMP] Starting GitHub backup..." >> "$CLAUDE_HOME/logs/resource.log"

# Navigate to repository
cd "$REPO_PATH" || { echo "[$TIMESTAMP] ERROR: Cannot access repository" >> "$CLAUDE_HOME/logs/resource.log"; exit 1; }

# Pull latest changes (in case of manual edits)
git pull --quiet

# Copy all state files
cp "$CLAUDE_HOME"/*.json "$REPO_PATH/state/" 2>/dev/null

# Copy all logs
cp "$CLAUDE_HOME/logs"/* "$REPO_PATH/logs/" 2>/dev/null

# Copy all scripts (including this one)
cp "$CLAUDE_HOME/scripts"/* "$REPO_PATH/scripts/" 2>/dev/null

# Copy markdown documentation from utopai
cp "$UTOPAI_PATH"/*.md "$REPO_PATH/docs/" 2>/dev/null

# Update SESSION_HISTORY.md timestamp
if [ -f "$REPO_PATH/session-history/SESSION_HISTORY.md" ]; then
    sed -i "s/\*Last updated:.*/\*Last updated: $TIMESTAMP\*/" "$REPO_PATH/session-history/SESSION_HISTORY.md"
fi

# Check if there are changes to commit
if git diff --quiet && git diff --staged --quiet; then
    echo "[$TIMESTAMP] No changes to backup" >> "$CLAUDE_HOME/logs/resource.log"
    exit 0
fi

# Stage all changes
git add .

# Commit with automated message
git commit -m "Automated daily backup - $TIMESTAMP

State synchronized:
- JSON state files updated
- Logs synchronized
- Scripts backed up
- Documentation current

🤖 Automated backup via cron

Co-Authored-By: Claude <noreply@anthropic.com>" --quiet

# Push to GitHub
if git push --quiet; then
    echo "[$TIMESTAMP] GitHub backup completed successfully" >> "$CLAUDE_HOME/logs/resource.log"
else
    echo "[$TIMESTAMP] ERROR: GitHub push failed" >> "$CLAUDE_HOME/logs/resource.log"
    exit 1
fi
