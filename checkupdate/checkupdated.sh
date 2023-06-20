#!/bin/bash

. /usr/local/bin/checkupdate.sh getvariables

mkfifo "$PIPE" -m 666 2> /dev/null

SLEEP=7200

while true; do
	echo  requesting update check
	. /usr/local/bin/checkupdate.sh | tee -a "$PIPE"
	echo Sleeping for "$SLEEP" seconds
	sleep "$SLEEP"
done
