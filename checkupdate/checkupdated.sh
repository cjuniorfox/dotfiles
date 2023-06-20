#!/bin/bash
set -x
mkfifo /tmp/update.pipe 2> /dev/null

while true; do
	. /usr/local/bin/checkupdate.sh > /tmp/update.pipe
	sleep 7200
done
