# script to Tiny-launch polybar

#!/usr/bin/env bash

echo "---" | tee -a /tmp/$(whoami)-polybar2.log
u=$(xprop -name "Polybar tray window" _NET_WM_PID | grep -o '[[:digit:]]*')
kill $u || polybar tray >> /tmp/$(whoami)-polybar2.log 2>&1
