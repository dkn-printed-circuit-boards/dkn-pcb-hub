#!/usr/bin/env python3
"""Claude Code status line: context-window use, plus a /clear nudge past a threshold.

Wire it up in ~/.claude/settings.json:
  "statusLine": {"type": "command", "command": "python3 <hub>/tools/statusline-context.py"}
Threshold: $CTX_CLEAR_PCT (default 20). Uses context_window.used_percentage if Claude Code sends
it; otherwise computes from the transcript's last assistant usage / context window size.
"""
import json, os, sys

def pct_from_transcript(path, window):
    try:
        with open(path, "rb") as f:
            f.seek(0, 2); f.seek(max(0, f.tell() - 400_000)); lines = f.read().decode("utf-8", "ignore").splitlines()
    except OSError:
        return None
    for line in reversed(lines):
        try: m = json.loads(line).get("message") or {}
        except ValueError: continue
        u = m.get("usage") if isinstance(m, dict) else None
        if u:
            used = sum(u.get(k, 0) or 0 for k in ("input_tokens", "cache_read_input_tokens", "cache_creation_input_tokens"))
            return 100.0 * used / window
    return None

def main():
    raw = sys.stdin.read()
    try: d = json.loads(raw)
    except ValueError: d = {}
    dbg = os.environ.get("CTX_STATUS_DEBUG")
    if dbg:
        try: open(dbg, "w").write(raw)
        except OSError: pass
    cw = d.get("context_window") or {}
    window = cw.get("context_window_size") or 200_000
    pct = cw.get("used_percentage")
    if pct is None and d.get("transcript_path"):
        pct = pct_from_transcript(d["transcript_path"], window)
    limit = float(os.environ.get("CTX_CLEAR_PCT", "20"))
    model = (d.get("model") or {}).get("display_name", "")
    name = d.get("session_name") or os.path.basename((d.get("workspace") or {}).get("current_dir", "") or d.get("cwd", ""))
    head = " · ".join(x for x in (name, model) if x)
    if pct is None:
        print(f"{head} · ctx ?"); return
    if pct >= limit:
        print(f"{head} · \033[33mctx {pct:.0f}% · /clear at next task boundary\033[0m")
    else:
        print(f"{head} · ctx {pct:.0f}%")

main()
