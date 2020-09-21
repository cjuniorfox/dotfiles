#!/bin/sh
xrandr --fb 1280x1080
xrandr --setmonitor DVI-D-0 2560/254x1080/286+0+0 DVI-D-0
xrandr --setmonitor DVI-D-0~1 1280/254x1080/286+0+0 none
xrandr --setmonitor DVI-D-0~2 1280/254x1080/286+1280+0 none
i3-msg reload
