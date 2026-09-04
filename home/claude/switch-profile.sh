#!/bin/bash
CLAUDE_DIR="$HOME/.claude"
case "$1" in
  align)
    cp "$CLAUDE_DIR/settings.align.json" "$CLAUDE_DIR/settings.json"
    echo "Switched to: Align proxy (align-aws-sonnet-4-6)"
    ;;
  kiro)
    cp "$CLAUDE_DIR/settings.kiro.json" "$CLAUDE_DIR/settings.json"
    echo "Switched to: Kiro gateway (claude-sonnet-4.6)"
    ;;
  status)
    model=$(python3 -c "import json; d=json.load(open('$CLAUDE_DIR/settings.json')); print(d.get('model','?'))")
    url=$(python3 -c "import json; d=json.load(open('$CLAUDE_DIR/settings.json')); print(d.get('env',{}).get('ANTHROPIC_BASE_URL','?'))")
    echo "Model : $model"
    echo "URL   : $url"
    ;;
  *)
    echo "Usage: claude-switch [align|kiro|status]"
    ;;
esac
