#!/bin/bash
kill $(ps -ax | grep 'rofi -show combi' | grep -v grep | awk '{print $1}') 2>/dev/null || rofi -show combi -modes combi -combi-modes 'window,drun,run'
