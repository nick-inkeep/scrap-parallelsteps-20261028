#!/usr/bin/env bash
LOG=$1
echo "---- $(date -u +%T.%3N) probe log $LOG"
cat "$LOG" 2>/dev/null || echo "(no log)"
for f in toppid childpid; do
  P=$(cat "$LOG.$f" 2>/dev/null)
  if [ -n "$P" ] && kill -0 "$P" 2>/dev/null; then echo "$f $P ALIVE: $(ps -o pid,pgid,stat,comm -p $P | tail -1)"; else echo "$f $P gone"; fi
done
