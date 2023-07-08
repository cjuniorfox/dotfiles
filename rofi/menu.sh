#!/bin/bash
kill $(cat /run/user/$UID/rofi.pid) 2> /dev/null || rofi run -show drun
