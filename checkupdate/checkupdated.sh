#!/bin/bash

. /usr/local/bin/checkupdate.sh getvariables

touch "$PIPE" 2> /dev/null
chmod 666 "$PIPE"

SLEEP=7200

PIPE_MAX_LINES=100

while true; do
	if [[ "$(wc -l $PIPE)" > "$PIPE_MAX_LINES" ]]; then
		rm "$PIPE"
		touch "$PIPE"
		chmod 666 "$PIPE"
	fi
	echo  requesting update check
	. /usr/local/bin/checkupdate.sh | tee -a "$PIPE"
	echo Sleeping for "$SLEEP" seconds
	sleep "$SLEEP"
done
