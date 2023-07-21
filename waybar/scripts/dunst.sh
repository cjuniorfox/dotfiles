#!/usr/bin/env bash
set -euo pipefail
readonly NOTIFICATION=""
readonly NO_DISTURB=""
dbus-monitor path='/org/freedesktop/Notifications',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged' --profile |
  while read -r _; do
    HISTORY="$(dunstctl count history)"
    WAITING="$(dunstctl count waiting)"
    IS_PAUSED="$(dunstctl is-paused)"
    ICON="$NOTIFICATION"
    CLASS="enabled"
    if [ "$IS_PAUSED" == 'true' ]; then
	    ICON="$NO_DISTURB"
	    CLASS="disabled"
    fi
    if [[ "$WAITING" != '0' ]]; then
	    TEXT="$ICON $WAITING"
    else
	    TEXT="$ICON"
    fi
    printf '{"text": "%s", "class": "%s"}\n' "$TEXT" "$CLASS"
  done
