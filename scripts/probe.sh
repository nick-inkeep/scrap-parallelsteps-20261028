#!/usr/bin/env bash
LOG=$1
ts() { date -u +%T.%3N; }
echo "$(ts) top start pid=$$ ppid=$PPID pgid=$(ps -o pgid= -p $$ | tr -d ' ') sid=$(ps -o sid= -p $$ | tr -d ' ')" >> "$LOG"
ps -o pid,ppid,pgid,sid,comm -p $PPID >> "$LOG"
python3 -u -c '
import signal, sys, time, os, datetime
log = sys.argv[1]
def w(msg):
    with open(log, "a") as f:
        f.write(datetime.datetime.utcnow().strftime("%H:%M:%S.%f")[:-3] + " " + msg + "\n")
def h(sig, frame):
    w("child(python pid=%d) got %s" % (os.getpid(), signal.Signals(sig).name))
for s in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP, signal.SIGQUIT, signal.SIGUSR1, signal.SIGUSR2):
    signal.signal(s, h)
w("child(python) start pid=%d pgid=%d" % (os.getpid(), os.getpgid(0)))
while True:
    time.sleep(0.1)
' "$LOG" &
CHILD=$!
echo "$CHILD" > "$LOG.childpid"
echo "$$" > "$LOG.toppid"
for s in INT TERM HUP QUIT USR1 USR2; do
  trap "echo \"\$(date -u +%T.%3N) top(bash pid=$$) got $s\" >> \"$LOG\"" $s
done
while :; do sleep 0.1; done
