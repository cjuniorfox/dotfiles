#!/bin/bash
kill kill $(cat /run/user/$UID/rofi.pid) 2> /dev/null || rofi -show combi -modes combi -combi-modes 'window,drun,run'
