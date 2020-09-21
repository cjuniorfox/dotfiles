#!/bin/sh
xrandr --delmonitor DVI-D-0~1
xrandr --delmonitor DVI-D-0~2
xrandr --fb 2560x1080
i3-msg reload
