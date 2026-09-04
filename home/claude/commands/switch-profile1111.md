Switch Claude Code profile. Argument: align | kiro | status.

If $ARGUMENTS is empty, call AskUserQuestion with these options: status, align, kiro. Use the answer as the argument below.

---

**status**: Run this bash command and show output:
```
python3 -c "import json,os; d=json.load(open(os.path.expanduser('~/.claude/settings.json'))); print('Model:', d.get('model','?')); print('URL  :', d.get('env',{}).get('ANTHROPIC_BASE_URL','?'))"
```

**align**: Run `cp ~/.claude/settings.align.json ~/.claude/settings.json` then tell user:
- Profile switched to **align**
- Run `/model sonnet` to switch model in this session
- Restart Claude Code for URL/token to take effect

**kiro**: Run `cp ~/.claude/settings.kiro.json ~/.claude/settings.json` then tell user:
- Profile switched to **kiro**
- Run `/model claude-sonnet-4.6` to switch model in this session
- Restart Claude Code for URL/token to take effect
