LOG=$1
N=${2:-20}
P=$(cat "$LOG.pid")
for i in $(seq 1 "$N"); do
  if kill -0 "$P" 2>/dev/null; then st=alive; else st=gone; fi
  echo "$(date -u +%T.%3N) watch $i step-shell $P $st"
  [ "$st" = gone ] && break
  sleep 1
done
echo "---- signal log $LOG"
cat "$LOG"
