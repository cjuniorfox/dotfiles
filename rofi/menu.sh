#!/bin/bash
kill $(ps -ax | grep 'rofi run -show drun' | grep -v grep | awk '{print $1}') 2>/dev/null || rofi run -show drun
