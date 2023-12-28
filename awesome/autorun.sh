#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}
run ${HOME}/.local/bin/start-sunshine-x11
run ${HOME}/.config/hypr/scripts/autostart
