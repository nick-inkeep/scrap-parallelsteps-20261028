LOG=$1
echo $$ > "$LOG.pid"
for s in INT TERM HUP QUIT USR1 USR2; do
  trap "echo \"\$(date -u +%T.%3N) step-shell got $s\" >> \"$LOG\"" $s
done
echo "$(date -u +%T.%3N) step-shell start pid=$$ ppid=$PPID cmd=$(tr '\0' ' ' < /proc/$$/cmdline)" >> "$LOG"
while :; do sleep 0.1; done
